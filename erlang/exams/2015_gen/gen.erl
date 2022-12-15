-module(gen).
-export([start/2]).

start(Pos,Limit) ->
    io:format("Worker:~p, Pos:~p, Limit: ~p\n",[self(),Pos,Limit]),
    receive
        {gen,Pid,P,List} when P =:= Pos -> 
            io:format("Worker:~p, Pos:~p, received order\n",[self(),Pos]),
            Pid ! {res,gen(trunc(math:pow(Limit,Pos)),1,1,Limit,List,[])}
end.

% gen(Step,Times,Limit,List,Acc) 
% gen(1,2,1,1,3) -> gen(1,2,1+1,1,3)
% gen(1,2,2,1,3) -> gen(1,2,1,1+1,3)
% gen(1,2,1,2,3) -> gen(1,2,1+1,2,3)
% gen(1,2,2,2,3) -> gen(1,2,1,2+1,3)
% gen(1,2,1,3,3) -> gen(1,2,1+1,3,3)
% gen(1,2,2,3,3) -> gen(1,2,1,1,3)

loop(HowManyTimes,Acc) ->
    


gen(Step,Step,Num,Num,[H|T],Acc) ->
    io:format("Gen-> Step:~p, Num:~p, H:~p, T:~p, Acc:~p\n",[Step,Num,H,T,Acc]),
    [[Num]++H]++Acc;
gen(Step,Step,Num,Limit,[H|T],Acc) ->
    io:format("Gen-> Step:~p, Num:~p, Limit:~p, H:~p, T:~p, Acc:~p\n",[Step,Num,Limit,H,T,Acc]),
    gen(Step,1,Num+1,Limit,T,[[Num]++H]++Acc);
gen(Step,Times,Num,Limit,[H|T],Acc) -> 
    io:format("Gen-> Step:~p, Times:~p, Num:~p, Limit:~p, H:~p, T:~p, Acc:~p\n",[Step,Times,Num,Limit,H,T,Acc]),
    gen(Step,Times+1,Num,Limit,T, [[Num]++H]++Acc).

