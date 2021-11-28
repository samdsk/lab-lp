-module(ps).
-export([start/0]).


start() -> 
    receive 
        {none} -> io:format("Spawned first ps of ring as pid: ~p~n",[self()]),start();
        {Next_Pid,spawn} -> io:format("Spawning loop -> My Pid: ~p ,Next Ps Pid: ~p, Msg: ~p~n",[self(),Next_Pid, spawn]), listen(Next_Pid);
        _ -> io:format("Unknown command\n")
end.
    
listen(Next_Pid) -> 
    receive
        {msg,Msg} -> io:format("Self:~p Next:~p Msg:~p~n",[self(),Next_Pid,Msg]), Next_Pid ! {msg,Msg}, listen(Next_Pid);
        {quit} -> Next_Pid ! {quit};
        _Q -> io:format("Unknown command in spawned ~p\n",[_Q])
end.

loop(0,Next_Pid,_) -> Next_Pid ! {quit};
loop(M,Next_Pid,Msg) -> io:format("Self:~p Next:~p Msg:~p M:~p~n",[self(),Next_Pid,Msg,M]), Next_Pid ! {msg,Msg,M-1}.