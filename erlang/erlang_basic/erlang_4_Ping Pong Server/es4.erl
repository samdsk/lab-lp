-module(es4). %%ECHO MODULE
-compile(export_all).

%% ! register and start server

start() ->
    %%unregister(server),
    
    register(server,spawn(fun () -> 
        process_flag(trap_exit,true),
        loop()
    end)).

client() ->
    %%unregister(server),
    %%unregister(client),
    
    register(client,spawn(fun() -> 
        process_flag(trap_exit,true),
        register(server,spawn_link(fun () -> 
            process_flag(trap_exit,true),
            loop()
        end)),
        loop_client()
    end)).

    
loop_client() ->
    io:format("Client # Ready\n"),
    receive
        stop -> io:format("Client # stopping\n"),unregister(client),exit(exit_crash);
        _Any -> io:format("Client # ~p\n",[_Any]),loop_client()       
end.


loop() ->
    io:format("Server # Ready\n"),
    receive
        {print,Msg} -> 
            io:format("Server # Received: ~p\n",[Msg]),loop();
        stop -> io:format("Server # Received stop command\n"),
            unregister(server),
            exit(exit_crash);
        Other -> 
            io:format("Server # Unknown command << ~p >>\n",[Other]),loop()
end.

print(Msg) -> server ! {print,Msg}.

stop() -> server ! stop.
