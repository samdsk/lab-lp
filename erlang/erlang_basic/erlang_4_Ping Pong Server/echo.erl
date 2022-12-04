-module(echo).
-export([start/0,print/1,stop/0]).

start() -> 
    Pid = spawn(echo,loop,[]),
    register(echo_server,Pid), 
    Pid.

print(Term) -> 
    io:format("Term: ~p~n",[Term]), 
    echo_server ! {self(), Term},
    receive
        pong -> io:format("Reply: ~p~n",[pong]);
        _q -> io:format("Reply: unknown: ~p~n",[_q])  
    end. 

stop() -> echo_server ! stop, ok.

loop() ->
    receive 
        {_,crash} -> io:format("Crashing...\n"),exit(abnormal);
        {Pid, Msg} -> io:format("Received: ~p~n",[Msg]), Pid ! pong, loop();
        {E,P, Why}-> io:format("Exiting: ~p ~p ~p \n",[E,P,Why]);
        stop -> unregister(echo_server), void        
    end.