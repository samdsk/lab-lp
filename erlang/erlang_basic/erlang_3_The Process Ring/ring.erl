-module(ring).
-export([start/3]).


start(N,M,Msg) -> 
    First_Pid = spawn(ps,start,[]), First_Pid ! {none},
    Last_Pid = spawn_loop(N-1,First_Pid),  
    First_Pid ! {Last_Pid,spawn}, 
    msg_loop(M, First_Pid,Msg)      
.


msg_loop(0,Head,_) -> Head ! {quit};
msg_loop(M,Head,Msg) -> Head ! {msg,Msg}, msg_loop(M-1,Head,Msg).


spawn_loop(0,Last_Pid) -> Last_Pid;
spawn_loop(N,Last_Pid) -> 
    io:format("Spawning: ~p~n",[N]), 
    Pid = spawn(ps,start,[]),
    Pid ! {Last_Pid,spawn},
    spawn_loop(N-1,Pid).
