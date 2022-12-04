-module(es3r).
-export([ring/2,start/3]).


start(M,N,Message) ->
    unregister(last),
    register(last,spawn(?MODULE,ring,[N,self()])),
    receive
        {ok} -> last ! {M,msg,Message}
end.

ring(1,Start) ->
    Start ! {ok},
    listen(1,whereis(last));
ring(N,Start) ->    
    Next = spawn(?MODULE,ring,[N-1,Start]),
    listen(N,Next).

listen(1 = N,Next) -> 
    receive
        {0,msg,Msg} ->  
            io:format("Loop finished: ~p\n",[Msg]),
            listen(N,Next);
        {M,msg,Msg} ->  
            io:format("ps:~p(~p)- M:~p - Msg: ~p~n",[N,self(),M,Msg]), 
            Next ! {M-1,msg,Msg},
            listen(N,Next);        
        stop -> 
            io:format("ps:~p(~p) - Stop!\n",[N,self()]), Next ! stop, exit(normal);
        _Q -> 
            io:format("Unknown: ~p\n",[_Q]),listen(N, Next)
end;

listen(N,Next) -> 
    receive
        {M,msg,Msg}=Message ->    
            io:format("ps:~p(~p)- M:~p - Msg: ~p~n",[N,self(),M,Msg]),
            Next ! Message,
            listen(N,Next);
        stop -> 
            io:format("ps:~p(~p) - Stop!\n",[N,self()]), Next ! stop, exit(normal);
        _Q -> 
            io:format("Unknown: ~p\n",[_Q]),listen(N, Next)
end.

