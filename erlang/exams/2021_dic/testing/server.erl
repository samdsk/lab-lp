-module(server).
-compile(export_all).

start() ->
    io:format(user,"Server ready!\n",[]),
    listen().

listen() ->
    receive
        Any -> io:format("Server: ~p\n",[Any]),
        listen()
end.