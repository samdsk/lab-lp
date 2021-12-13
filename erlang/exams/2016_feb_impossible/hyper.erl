-module(hyper).
-export([create/0]).

create() ->
    L = ["0000","0001","0011","0010","0110","0100","0101","0111","1111","1110","1100","1101","1001","1011","1010","1000"],
    Neighbours = maps:from_list([ {X,find_neighbours(X,L,[])} || X <- L]),
    io:format("~p\n",[Neighbours]),
    Pids = maps:from_list([{X,spawn_link(fun() -> sub(X,maps:get(X,Neighbours))end)} || X <- L]).

sub(Node,[H|T] = Neighbours) ->
    io:format("Spawned: ~p -> ~p\n",[Node,Neighbours])
    receive
        {pass,N} -> 
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


