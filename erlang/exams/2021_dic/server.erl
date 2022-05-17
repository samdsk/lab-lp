-module(server).
-export([start/0]).
-define(Shell,whereis(shell)).

start() ->
    register(server,self()),
    io:format(?Shell,"Server: up and running at ~p\n",[node()]),
    listen().

listen() ->
    io:format(?Shell,"Server ready!\n",[]),
    receive
        {cmd,reverse_ready,Len} -> 
            io:format(?Shell,"Entering collection mode to perfome reverse operation\n",[]),
            do_reverse(Len*2,[],[]), listen()
end.

do_reverse(0,L1,L2) ->
    L = L2++L1,
    io:format(?Shell,"The reverse of ~p is ~p\n",[lists:reverse(L),L]);

do_reverse(Len,L1,L2) ->
    receive 
    {MM,{reverse,{N,L,H}}} -> 
            io:format(?Shell,"Msg#reverse -> from ~p - (~p of ~p) :- ~p\n",[MM,N,L,H]), 
            case MM of
                mm1 -> do_reverse(Len-1,[H|L1],L2);
                _ -> do_reverse(Len-1,L1,[H|L2])
            end
end.
            
