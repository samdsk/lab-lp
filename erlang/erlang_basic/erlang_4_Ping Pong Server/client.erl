-module(client).
-export([init/0,send/2]).

init() -> spawn(fun() -> 
    process_flag(trap_exit, true), 
    Server = spawn_link(echo,loop,[]),
    register(echo_server,Server),
    listen()
end).


listen() -> 
    receive 
        Any -> io:format("Listening in Client: ~p \n",[Any]), listen()
end.

send(Pid,Msg) -> echo_server ! {Pid,Msg}.

