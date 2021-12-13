-module(hyper).
-compile(export_all).
%-export([create/0]).

create() ->
    L = gray(4),
    Neighbours = maps:from_list([ {X,find_neighbours(X,L,[])} || X <- L]),    
    Pids = maps:from_list([{X,spawn_link(fun() -> sub(X,maps:get(X,Neighbours))end)} || X <- L]),
    register('0000',maps:get("0000",Pids)).

sub(Node,[H|T] = Neighbours) ->
    io:format("Spawned: ~p -> ~p\n",[Node,Neighbours]),
    receive
        {msg,{src,H,msg,Msg},Path} -> true
end.

hamilton(Msg, [H|Path]) ->
    '0000' ! {msg,{src,H,msg,Msg},Path},
    receive 
        Any -> io:format("~p\n",[Any])
end.



find_neighbours(_,[],Output) -> Output;
find_neighbours(S,[H|L],Output)->    
    case myxor(S,H,1,0) of
        1 -> find_neighbours(S,L,[H|Output]);
        _ -> find_neighbours(S,L,Output)
    end.


myxor(S,R,5,Output) -> Output;
myxor(S,R,N,Output) ->
    case lists:nth(N, S) =:= lists:nth(N,R) of
        true -> myxor(S,R,N+1,Output);
        false -> myxor(S,R,N+1,Output+1)
    end.

gray(0) -> [""];
gray(N) ->
    L1 = gray(N-1),
    L2 = lists:reverse(L1),
    ["0"++X || X <- L1]++["1"++X || X<-L2].