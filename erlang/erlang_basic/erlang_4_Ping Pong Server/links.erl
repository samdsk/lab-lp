-module(links).
-compile(export_all).



init() -> 
    Server = echo:start(),
    Client = spawn(fun() -> 
        process_flag(trap_exit, true),
        link(Server),
        client:listen()
    end),
    sleep(1000), client:send(Client,ping), status(server,Server), status(client,Client).

sleep(T) ->
    receive
    after T -> true
    end.

status(Name,Pid) ->
    case erlang:is_process_alive(Pid) of
        true -> io:format("Process: ~p - ~p is alive \n",[Name,Pid]);
        false -> io:format("Process: ~p - ~p is dead \n",[Name,Pid])
    end.
