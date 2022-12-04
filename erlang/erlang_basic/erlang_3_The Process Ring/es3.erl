-module(es3).
-export([start/3,wait/1,listen/2]).


start(M,N,Message) ->
    erlang:unregister(first),
    First = spawn(es3,wait,[N]), %%4
    register(first,First),
    Last = build_ring(N-1,First), %%1
    First ! {next, Last},
    First ! {M,msg,Message},
    io:format("Ok done\n").


build_ring(0,Next) ->    
    io:format("Ring created\n"),
    Next;
build_ring(N,Next) ->
    New_Next = spawn(?MODULE,listen,[N,Next]),
    build_ring(N-1,New_Next).

wait(N) ->
    io:format("First node is waiting for the last node\n"),
    receive 
        {next,Last} -> io:format("Ok: setting up \"next\" of first node\n"),listen(N,Last);
        Other -> io:format("Error: Something went wrong ~p\n", [Other])
end.

listen(1 = N,Next) -> 
    receive
        {0,msg,Msg} ->  io:format("Loop finished: ~p\n",[Msg]),
                        listen(N,Next);
        {M,msg,Msg} ->  io:format("ps:~p(~p)- M:~p - Msg: ~p~n",[N,self(),M,Msg]), 
                        Next ! {M-1,msg,Msg},
                        listen(N,Next);        
        stop -> io:format("ps:~p(~p) - Stop!\n",[N,self()]), Next ! stop, exit(normal);
        _Q -> io:format("Unknown: ~p\n",[_Q]),listen(N, Next)
end;

listen(N,Next) -> 
    receive
        {M,msg,Msg}=Message ->    io:format("ps:~p(~p)- M:~p - Msg: ~p~n",[N,self(),M,Msg]),
                            Next ! Message,
                            listen(N,Next);
        stop -> io:format("ps:~p(~p) - Stop!\n",[N,self()]), Next ! stop, exit(normal);
        _Q -> io:format("Unknown: ~p\n",[_Q]),listen(N, Next)
end.
