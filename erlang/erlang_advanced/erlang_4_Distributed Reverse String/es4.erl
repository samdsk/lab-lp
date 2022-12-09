-module(es4).
-export([start/1,send/0]).

send() ->
    server ! {reverse,"abcdefghijklmnopqrstuvwxyz"}
    .

start(N) ->
    register(server,spawn(fun()->
        process_flag(trap_exit,true),
        server(N)
    end)).

server(N) ->
    % io:format("Server ready\n"),
    receive
        {reverse,Str} ->
            % io:format("Server received reverse order: ~p\n",[Str]),
            spawn_link(fun() -> process_flag(trap_exit,true),long_reverse_string(Str,N) end),
            server(N);
        stop -> 
            unregister(server),
            exit(normal);
        Any -> 
            io:format("Server received: ~p\n",[Any]),server(N)
end.

assemble(L) ->
    lists:foldl(fun({_,E},Acc) -> E++Acc end,"",lists:sort(fun({X,_},{Y,_})-> X<Y end,L))
.
collect(M,L) ->
    % io:format("Collector ready\n"),
     receive
        {Who,N,Rev_str} when M =:= N ->
            % io:format("Collector received last: from:~p - N:~p Str:~p\n",[Who,N,Rev_str]),
            server ! {reversed_ok,assemble([{N,Rev_str}]++L)},
            unregister(collect),
            exit(normal);

        {Who,N,Rev_str} ->
            % io:format("Collector received: from:~p - N:~p Str:~p\n",[Who,N,Rev_str]),
            collect(M,[{N,Rev_str}]++L)
end.

long_reverse_string(Str,M) ->
    % io:format("Long Reverse String ready\n"),

    Len = length(Str), 
    N = Len rem M,
    Size = Len div M,

    % io:format("Long reverse string: spawning ~p workers \n",[M]),
    Worker_list = [spawn_link(fun()-> 
        reverse(X)    
    end) || X<- lists:seq(1,M)],
   
    register(collect,spawn_link(fun()-> collect(M,[]) end)),

    split_and_send(1,N,M,Size,1,Str,Worker_list),

    receive
        {'EXIT',_,_} -> 
            % io:format("Long reverse received exit\n"),
            exit(normal)
end.

split_and_send(_,_,_,_,_,[],_) ->
    ok;
    % server ! "sent all";

split_and_send(N,N,Max,Size,Offset,Str,[H|T]) ->
    % io:format("m:~p n:~p max:~p size:~p offset:~p str:~p\n",[N,N,Max,Size,Offset,Str]),
    {Msg,Rest} = lists:split(Size+Offset,Str),
    H ! {reverse,N,Msg},
    split_and_send(N+1,Max,Max,Size,0,Rest,T);

split_and_send(M,N,Max,Size,Offset,Str,[H|T]) ->
    % io:format("m:~p n:~p max:~p size:~p offset:~p str:~p\n",[M,N,Max,Size,Offset,Str]),
    {Msg,Rest} = lists:split(Size+Offset, Str),
    H ! {reverse,M,Msg},
    split_and_send(M+1,N,Max,Size,Offset,Rest,T).

reverse_string(Str) -> lists:reverse(Str).

reverse(Who) -> 
    % io:format("Worker-~p ready\n",[Who]),
    receive
        {reverse,N,Str} -> 
            % io:format("Worker-~p received reverse order: ~p : ~p\n",[Who,N,Str]),
            collect ! {Who,N,reverse_string(Str)},
            reverse(Who);
        Any -> 
            % io:format("Worker-~p received: ~p\n",[Who,Any]),
            reverse(Who)
end.