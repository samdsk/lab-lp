-module(asd).
-compile(export_all).

start() -> 
    register(server,spawn(fun()-> listen()end)).

listen() ->
    receive 
        {ciao,Node,Pid} -> {Pid,Node} ! res, io:format("res\n"),listen()        
end.

rpc(Node) ->
    {server,Node} ! {ciao,node(),self()},
    receive 
        res -> io:format("ciao ~p\n",[node()])
end.