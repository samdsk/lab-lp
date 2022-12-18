-module(server).
-compile(export_all).
-define(Shell,user).
-define(MM1,client:node_make("mm1")).
-define(MM2,client:node_make("mm2")).

start() ->
    register(server,self()),
    io:format(?Shell,"Server ready!\n",[]),
    loop().

loop() ->
    receive
        {MM,{reverse,N,H}} = M -> 
            io:format(?Shell,"Server: ~p > ~p\n",[MM,M]),
            loop();
        Any -> 
            io:format(?Shell,"Server: ~p\n",[Any]),
            loop()
end.