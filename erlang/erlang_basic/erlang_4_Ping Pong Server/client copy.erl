-module(client).
-export([start/0,send/1,stop/0]).

start() ->
    process_flag(trap_exit, true), 
    spawn_link(echo,start,[]),
    receive
        {E,P, Why}-> io:format("Exiting-Msg: ~p ~p ~p \n",[E,P,Why])  
    end.

init(Pid) -> spawn(
    fun() -> 
        process_flag(trap_exit, true),
        link(Pid),
        listen()
    end
).


init(Pid) -> 
    process_flag(trap_exit, true),
    link(Pid),
    spawn(client,listen,[]).

stop() -> exit("badarg").
send(Msg) ->   
    echo_server ! {self(),Msg},
    receive
        pong -> io:format("Server replied: Ok\n");
        {E,P, Why}-> io:format("Exiting: ~p ~p ~p \n",[E,P,Why])         

end.

flush() ->
    receive
           _Any -> io:format("Flushing: ~p \n",[_Any]), flush()
    after
            0 -> ok
    end.