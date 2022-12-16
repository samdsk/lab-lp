-module(com).
-export([start/2]).


start(N,M) ->
    process_flag(trap_exit, true),
    Workers = [spawn_link(gene,start,[X,N,M])|| X<-lists:seq(0, N-1)],
    permutations(Workers,N-1).

permutations(Workers,Max) ->     
    send(Workers),
    collect(0,Max,[]),
    exit(normal).



send([]) -> ok;
send([H|Workers]) ->
    H ! {gen,self()},
    send(Workers).

collect(Pos,Max,Output) when Pos > Max ->
    lists:foreach(fun(X) -> print(X) end,Output);
collect(Pos,Max,Output) -> 
    receive
        {res,P,Res} when Pos =:= P -> 
            % io:format("Found P:~p\n",[P]),            
            collect(Pos+1,Max,build(Output, Res,[]))
end. 

build([],[],Acc) -> lists:reverse(Acc);
build([],L,_Acc) -> 
    lists:map(fun(X) -> [X] end, L);
build([OH|Output],[H|Res],Acc) ->    
    build(Output,Res,[[H]++OH]++Acc).

print([H]) -> io:format("~p\n",[H]);
print([H|T]) ->
    io:format("~p,",[H]),
    print(T).