-module(ps).
-export([start/0]).


start() -> 
    receive 
        {none} -> io:format("Spawned first ps of ring as pid: ~p~n",[self()]),start();
        {Next_Pid, spawn} -> io:format("Spawning loop -> My Pid: ~p ,Next Ps Pid: ~p, Msg: ~p~n",[self(),Next_Pid, spawn]), start(Next_Pid);
        _ -> io:format("Unknown command\n")
end.
    
start(Next_Pid) -> 
    receive
        {msg,Msg} -> io:format("~p~n",[Msg]), Next_Pid ! {msg,Msg}, start(Next_Pid);
        {quit} -> io:format("Destructing the ring!\n"), Next_Pid ! {quit};
        _ -> io:format("Unknown command in spawned\n")
end.