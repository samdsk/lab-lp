-module(joseph).
-export([joseph/2]).

joseph(N,Step) ->
    process_flag(trap_exit,true),
    register(server,self()),
    Head = spawn_link(fun() -> hebrew:build(1,N,Step,self()) end),
    io:format("Ina circle of ~p people, killing number ~p\n",[N,Step]),
    receive after 2000 -> ok end,
    Head ! {1,Head,N},
    receive
        {last,Who} -> io:format("Joseph is the Hebrew in position ~p\n",[Who]),unregister(server)
end.

