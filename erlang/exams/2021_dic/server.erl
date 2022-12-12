-module(server).
-export([start/0]).

start() ->
    register(server,self()),
    io:format(user,"Server: up and running at ~p\n",[node()]),
    listen().

listen() ->
    io:format(user,"Server ready!\n",[]),
    receive
        {cmd,reverse_ready,Len} -> 
            io:format(user,"Entering collection mode to perfome reverse operation\n",[]),
            {client,client:make_node("client")} ! {do_reverse(Len*2,[],[])},
            listen()
end.

do_reverse(0,L1,L2) ->
    L = L2++L1,
    io:format(user,"The reverse of ~p is ~p\n",[lists:reverse(L),L]),
    L;

do_reverse(Len,L1,L2) ->
    receive 
    {MM,{reverse,{N,L,H}}} -> 
            io:format(user,"Msg#reverse -> from ~p - (~p of ~p) :- ~p\n",[MM,N,L,H]), 
            case MM of
                mm1 -> do_reverse(Len-1,[H|L1],L2);
                _ -> do_reverse(Len-1,L1,[H|L2])
            end
end.
            
