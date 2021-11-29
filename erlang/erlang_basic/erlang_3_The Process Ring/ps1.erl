-module(ps).
-export([start/1]).


start({spawn,N,Head_Pid,Last_Pid}) -> 
    Next_Pid = spawn(ps1,start,[{spawn,N-1,Head_Pid,self()}]),
    listen(Last_Pid)
    
listen(Next_Pid) -> 
    receive
        {msg,Msg} -> io:format("Self:~p Next:~p Msg:~p~n",[self(),Next_Pid,Msg]), Next_Pid ! {msg,Msg}, listen(Next_Pid);
        {quit} -> Next_Pid ! {quit};
        _Q -> io:format("Unknown command in spawned ~p\n",[_Q])
end.

