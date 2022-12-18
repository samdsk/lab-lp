-module(mm).
-export([start/1]).
-define(Shell,user).
-define(Server,client:node_make("server")).

start(MM) ->
    register(mm,self()),
    loop(MM).

loop(MM) ->
    io:format(?Shell,"Middleman: ~p\n",[MM]),
    receive
        {cmd,spawn_server} -> 
            spawn(client:node_make("server"),server,start,[]),
            loop(MM);
        Any -> 
            {server,?Server} ! {MM,Any},
            loop(MM)
end.