-module(client).
%-compile(export_all).
-export([start/0,ping/0,to_node/1,close/0,reverse/1]).
ping() -> 
    io:format("calling ping here\n"),
    [net_adm:ping(to_node(X)) || X <- ["mm1","mm2","server"]].

to_node(Str) -> 
    {_,Host} = net:gethostname(),
    list_to_atom(Str++[$@]++Host).


unregister() ->
    try [unregister(X) || X <- ["mm1","mm2","server"]]
            
    catch
        Any -> io:format("~p\n",[Any])
            
    end.

start() ->    
    ping(),
    c:nl(client),
    c:nl(mm),
    c:nl(server), 
    %group_leader(whereis(user),self()),
    io:format("Spawning the system \n"),
    spawn(to_node("mm1"),mm,start,[mm1]),
    spawn(to_node("mm2"),mm,start,[mm2]),
    io:format("Spawning server "),
    {mm,to_node("mm1")} ! {cmd,spawn_server}.

close() ->
    {mm,to_node("mm1")} ! {stop},
    {mm,to_node("mm2")} ! {stop}.


reverse(Str) ->
    register(client,self()),
    Len = length(Str),
    Half = Len div 2,
    case Len rem 2 of
        0 -> send_to_mm(lists:split(Half,Str),Half);
        _ -> {L1,[H|_]=L2} = lists:split(Half, Str), send_to_mm({L1++[H],L2},Half+1)
    end,
    listen().

listen() ->
    receive 
        Any -> io:format(Any), listen()
    after 5000 -> exit(normal)
end.

enumerate(L) -> 
    {List,_} = lists:mapfoldl(fun (X,Acc) -> {{X,Acc},Acc+1} end,1,L),
    List.

send_to_mm({L1,L2},Size) -> 
    lists:foreach(fun (X) -> send("mm1",X,Size) end, enumerate(L1)),
    lists:foreach(fun (X) -> send("mm2",X,Size) end, lists:reverse(enumerate(L2))).

send(Node,Msg,Size) ->
    {mm,to_node(Node)} ! {reverse,Msg,Size}.
