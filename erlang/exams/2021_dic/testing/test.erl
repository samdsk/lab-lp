-module(test).
-export([start/0,rpc/1,ping/0]).
-define(Shell,global:whereis_name(shell)).

to_node(Str) ->
    {_,Host} = net:gethostname(),
    list_to_atom(Str++[$@]++Host).

start() ->
    %global:register_name(server, spawn('mm1@DsStudios',fun () -> loop() end)).
    spawn(to_node("mm1"),fun () -> register(server,self()), loop() end).

ping() -> 
    net_adm:ping(to_node("mm1")).

loop() ->
    io:format(global:whereis_name(shell),"Server ready!\n",[]),
    receive
        {Pid,Msg} -> 
            io:format(global:whereis_name(shell),"Server: ~p : ~p\n",[Pid,Msg]),
            Pid ! pong,
            loop();
        Any -> io:format(global:whereis_name(shell),"Some msg: ~p\n",[Any]), loop()
end.

rpc(Msg) ->
    {server,to_node("mm1")} ! {self(),Msg},
    receive
        Any -> io:format(global:whereis_name(shell),"Rpc: ~p\n",[Any])
end.