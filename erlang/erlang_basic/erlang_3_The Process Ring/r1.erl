-module(r1).
-export([start/3,start/1]).

start(N,M,Msg) -> 
    io:format("Creating element of ring: ~p\n",[self()]),
    Next_Pid = spawn(r1,start,[{spawn,N-1,self()}]),
    receive 
        {ok, _Last_Pid} -> io:format("ok ring build\n"), init(M,Msg,Next_Pid);        
        _Q -> io:format("Unknown msg: ~p~n",[_Q])
end.

init(0,_,Next_Pid) -> Next_Pid ! {quit};
init(M,Msg,Next_Pid) -> Next_Pid ! {msg,Msg}, init(M-1,Msg,Next_Pid).

start({spawn,1,Head_Pid}) -> 
    io:format("Last element of ring created: ~p\n",[self()]),   
    Head_Pid ! {ok, self()},
    listen(Head_Pid);
start({spawn,N,Head_Pid}) -> 
    io:format("Creating element of ring: ~p\n",[self()]),
    Next_Pid = spawn(r1,start,[{spawn,N-1,Head_Pid}]),
    listen(Next_Pid).
    
listen(Last_Pid) -> 
    receive        
        {msg,Msg} -> io:format("Self:~p Next:~p Msg:~p~n",[self(),Last_Pid,Msg]), Last_Pid ! {msg,Msg}, listen(Last_Pid);
        {quit} -> io:format("Quiting ring: ~p\n",[self()]), Last_Pid ! {quit};
        _Q -> io:format("Unknown command in listen ~p\n",[_Q])
end.

