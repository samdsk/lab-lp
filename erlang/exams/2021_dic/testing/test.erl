-module(test).
-export([start/0,rpc/1,ping/0]).

start() ->
    %global:register_name(server, spawn('mm1@DsStudios',fun () -> loop() end)).
    spawn('mm1@DsStudios',fun () -> register(server,self()), loop() end).

ping() -> 
    net_adm:ping('mm1@DsStudios').

loop() ->
    io:format(user,"Server ready!\n",[]),
    receive
        {Pid,Msg} -> 
            io:format(user,"Server: ~p : ~p\n",[Pid,Msg]),
            Pid ! pong,
            loop();
        Any -> io:format(user,"Some msg: ~p\n",[Any]), loop()
end.

rpc(Msg) ->
    {server,'mm1@DsStudios'} ! {self(),Msg},
    receive
        Any -> io:format(user,"Rpc: ~p\n",[Any])
end.