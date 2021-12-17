-module(mm).
-export([start/1]).
-define(Shell,whereis(shell)).
-define(server,client:make_node("server")).

start(MM)->
    register(mm,self()),
    io:format(?Shell,"~p: up and running at ~p\n",[MM,node()]),
    listen(MM).

listen(MM) ->
    receive
        {cmd,spawn_server} -> spawn(?server,server,start,[]), listen(MM);
        {cmd,reverse_ready,_} = Msg -> {server,?server} ! Msg, listen(MM);
        {reverse,_} = Msg -> 
            io:format(?Shell,"~p received from client ~p\n",[node(),Msg]),
            {server,?server} ! {MM,Msg}, listen(MM)
end.