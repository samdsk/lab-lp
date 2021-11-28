-module(ring).
-export([start/1]).


start(N) -> 
    First_Pid = spawn(ps,start,[]), First_Pid ! {none},
    Last_Pid = loop(N-1,First_Pid),
    First_Pid ! {Last_Pid,spawn}, 
    listen(First_Pid)
.


listen(Head) -> 
    receive
     {msg, Msg} -> Head ! {msg,Msg}, listen(Head);
     {quit} -> Head ! {quit}
end.

loop(1,Last_Pid) -> 
    io:format("Spawning: 1~n"), 
    Pid = spawn(ps,start,[]), 
    Pid ! {Last_Pid,spawn},
    Pid;

loop(N,Last_Pid) -> 
    io:format("Spawning: ~p~n",[N]), 
    Pid = spawn(ps,start,[]),
    Pid ! {Last_Pid,spawn},
    loop(N-1,Pid).
