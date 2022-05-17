-module(client).
-export([init/1,send/2,listen/0]).

init(Server) -> spawn(
    fun() -> 
        process_flag(trap_exit, true),
        link(Server),
        listen()
    end
).

listen() -> 
    receive 
        Any -> io:format("Listening in Client: ~p \n",[Any]), listen()
end.

send(Pid,Msg) -> echo_server ! {Pid,Msg}.

