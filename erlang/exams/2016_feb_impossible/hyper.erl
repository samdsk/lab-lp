-module(hyper).
-compile(export_all).
%-export([create/0]).
test()-> create(), hamilton("Hello", gray(4)).

create() ->
    L = gray(4),
    Neighbours = maps:from_list([ {X,find_neighbours(X,L,[])} || X <- L]),    
    io:format("Neighbours: ~p\n",[Neighbours]),
    Pids = [{X,spawn_link(fun() -> sub(X)end)} || X <- L],
    send_neigbour_pids(Pids, Pids, Neighbours),
    {_,Pid} = lists:keyfind("0000",1,Pids),
    register('0000',Pid).

send_neigbour_pids([],_,_) -> io:format("Sent pids\n");
send_neigbour_pids([{S,Pid}|T],Pids,Neighbours) ->
    io:format("S:~p:~p\n",[S,Pid]),
    L = maps:get(S,Neighbours),
    Pid ! {neighbours, find_nPids(Pids, L)},
    send_neigbour_pids(T,Pids,Neighbours).

find_nPids(Pids,L) -> [lists:keyfind(X,1,Pids)|| X<-L].

sub(Node) ->
    %io:format("Spawned: ~p - waiting for neighbours pids\n",[Node]),
    receive
        {neighbours,List} -> listen(Node,List)
end.

listen(Node,List) ->
    io:format("Ready: ~p -> ~p - pids ~p\n",[Node,self(),List]),
    receive
        {msg,Msg,[_,Next | Path]} = M ->  
            {_,NextPid} = lists:keyfind(Next,1,List),
            io:format("Node: ~p Next: ~p Find:~p\n",[Node,Next,NextPid]),
            NextPid ! {msg,{src,Node,msg,Msg},Path},listen(Node,List);
        {msg,_Msg,[]} = M -> io:format("End ~p\n",M)
end.

    
hamilton(Msg, Path) ->
    '0000' ! {msg,Msg,Path},
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