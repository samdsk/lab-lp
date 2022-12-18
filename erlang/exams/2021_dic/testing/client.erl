-module(client).
-compile(export_all).

-define(Abc, "abcdefghijklmnopqrstuvwxyz").
-define(A123, "0123456789").


start() ->
    try register(server,spawn(server,start,[]))
    catch
        E -> io:format(user,"~p\n",[E])
    end.

test() ->
    {L1,L2} = split_even_odd(?A123),
    send(L1),
    send(L2).

send(L)->
    server ! {ready,length(L)},
    send(L,1).
%    receive 
%        {server,ready} -> send(L,1)
%end.


sleep(T) ->
    receive after T -> ok end.

send([],_) -> ok;
send([H|T],N) ->
    server ! {H,N},
    send(T,N+1).

split_even_odd(L) ->
    split_even_odd([],[],L,0).

split_even_odd(L1,L2,[],_)->
    {L1,L2};
split_even_odd(L1,L2,[H|T],1)->
    split_even_odd(L1,[H|L2],T,0);
split_even_odd(L1,L2,[H|T],0) ->
    split_even_odd([H|L1], L2,T,1).


rpc(Msg)->
    server ! {self(),Msg},
    receive
        Any ->
            io:format("Rpc: ~p\n",[Any])
end.



