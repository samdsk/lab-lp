-module(ms).
-export([start/0,client/0]).

client() -> register(client,spawn(fun() -> 
    master ! {reverse,"abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz"},
    receive
        Any -> io:format("Client ~p\n",[Any])
end
end)).

start() -> register(master,spawn(
    fun() ->
        process_flag(trap_exit, true),
        listen() end)
). 

listen() -> 
    receive
        {reverse,_} = Msg -> 
            register(long_reverse,spawn(fun() -> 
                long_reverse_string()
            end)), long_reverse ! Msg, listen();
        {ok,_} = M -> client ! M,listen()
end.


long_reverse_string() ->
    receive 
        {reverse,String} -> 
            N = string:length(String) rem 10,
            register(collect,spawn_link( fun() -> collect(maps:new(), 0)   end)),
            init_slaves(N,0,String);
            
        
        _Any -> io:format("Error long reverse\n")
end.

assemble(_,-1) -> [];
assemble(Map,N) -> 
    io:format("Assemble ~p\n",[N]),
    maps:get(N,Map)++assemble(Map,N-1).

collect(Map,10) -> master ! {ok,assemble(Map,9)};
collect(Map,N) -> 
    io:format("Collect ~p\n",[N]),
    receive
        {ok,M,S} -> collect(maps:put(M,S,Map),N+1);
        _Any -> io:format("Error collect\n")
end.



init_slaves(_,9,String) ->
    Pid = spawn_link(fun() -> reverse_string() end),
    io:format("Spawn sub process: ~p:~p, S1: ~p\n",[9,Pid,String]),
    Pid ! {rev,9,String};

init_slaves(N,M,String) when M=<N  ->
    Split_point = (string:length(String) div 10) +1,
    io:format("split point ~p\n",[Split_point]),
    {S1,Rest} = lists:split(Split_point, String),
    Pid = spawn_link(fun() -> reverse_string() end),
    io:format("Spawn sub process: ~p:~p, S1: ~p, Rest: ~p\n",[M,Pid,S1,Rest]),
    Pid ! {rev,M,S1},
    init_slaves(N,M+1,Rest);

init_slaves(N,M,String) ->
    Split_point = (string:length(String) div 10),
    io:format("split point ~p\n",[Split_point]),
    {S1,Rest} = lists:split(Split_point, String),
    Pid = spawn_link(fun() -> reverse_string() end),
    io:format("Spawn sub process: ~p:~p, S1: ~p, Rest: ~p\n",[M,Pid,S1,Rest]),
    Pid ! {rev,M,S1}, 
    init_slaves(N,M+1,Rest).

reverse_string() -> 
    receive 
        {rev,M,S} -> Rev = lists:reverse(S), io:format("Working ~p ~p ~p, rev: ~p\n",[self(),M,S,Rev]), collect ! {ok,M,Rev};
        _Any -> io:format("Error reverse string\n")
end.
