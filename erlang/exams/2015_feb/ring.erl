-module(ring).
-export([start/2,send_message/1,send_message/2,stop/0,test/0]).

start(N,L) ->
    register(head,spawn(fun () -> build_ring(N,L,self()) end)).

build_ring(1,[H],Head) ->
    %io:format("Last: ~p\n",[1]),    
    listen(H, Head,last);

build_ring(N,[H|T],Head) ->
    %io:format("N: ~p\n",[N]),
    Next = spawn_link(fun () -> build_ring(N-1, T, Head) end),
    listen(H,Next).

listen(Fun,Next,last) ->
    %io:format("Next of last ~p is ~p\n",[self(),Next]),
    receive
        {stop} -> exit(normal);
        {msg,N} -> 
            io:format("~p\n",[Fun(N)]), 
            listen(Fun, Next,last);
        {msg,Msg,1} -> 
            io:format("~p\n",[Fun(Msg)]),
            listen(Fun, Next,last);
        {msg,Msg,N} -> 
            %io:format("last fun: ~p\n",[Fun(Msg)]),    
            Next ! {msg,Fun(Msg),N-1},        
            listen(Fun, Next,last)
end.  

listen(Fun,Next) ->
    %io:format("Next of ~p is ~p\n",[self(),Next]),
    receive
        {stop} -> Next ! {stop}, exit(normal);
        {msg,N} -> 
            %io:format("~p\n",[Fun(N)]),    
            Next ! {msg,Fun(N)},        
            listen(Fun, Next);
        {msg,Msg,N} -> 
            %io:format("~p\n",[Fun(Msg)]),    
            Next ! {msg,Fun(Msg),N},        
            listen(Fun, Next)
end.

send_message(Msg) ->
    head ! {msg,Msg}.

send_message(Msg,N) ->
    head ! {msg,Msg,N}.

stop() -> head ! {stop}.

test() ->
    L1 = [fun(X)-> X*N end||N<-lists:seq(1,7)],
    L2 = [fun(X)-> X+1 end||N<-lists:seq(1,1000)],    
    try unregister(head) catch _:_ -> io:format("Error\n") end,
    %start(4, [fun(X)-> Y*X end || Y <- lists:seq(1,4)]),
    %send_message(1, 2).
    start(1000, L2).
    %send_message(1, 10).

