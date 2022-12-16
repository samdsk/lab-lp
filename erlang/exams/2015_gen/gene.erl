-module(gene).
-export([start/3,test/3]).

start(Pos,N,M) -> %  Limit is the M
    %io:format("Worker:~p, Pos:~p, N:~p, Limit: ~p\n",[self(),Pos,N,M]),
    receive
        {gen,Pid} -> 
            %io:format("Worker:~p, Pos:~p, received order\n",[self(),Pos]),
            StepSize = trunc(math:pow(M,Pos)),
            Max = trunc(math:pow(M,N)),
            Pid ! {res,Pos,gen(StepSize,1,1,M,[],1,Max)}
end.

% gen(Step,Times,Limit,Acc,Max) Max = M^N 
% gen(1,2,1,1,3,) -> gen(1,2,1+1,1,3)
% gen(1,2,2,1,3) -> gen(1,2,1,1+1,3)
% gen(1,2,1,2,3) -> gen(1,2,1+1,2,3)
% gen(1,2,2,2,3) -> gen(1,2,1,2+1,3)
% gen(1,2,1,3,3) -> gen(1,2,1+1,3,3)
% gen(1,2,2,3,3) -> gen(1,2,1,1,3)

test(N,M,P) ->
    gen(trunc(math:pow(M,P)),1,1,M,[],1,trunc(math:pow(M,N))).


% outside loop exit
gen(_Step,_Times,_Num,_Limit,Acc,Tot,Max) when (Tot > Max) ->
    lists:reverse(Acc);
% outside loop, repeating inside loop
gen(Step,Times,Num,Limit,Acc,Tot,Max) when (Step =:= Times) and (Num =:= Limit) ->
    %io:format("Gen-> (Step == Times and Num == Limit) Step:~p, Num:~p, Acc:~p, Tot:~p\n",[Step,Num,Acc,Tot]),
    gen(Step,1,1,Limit,[Num]++Acc,Tot+1,Max);

% increasing Number
gen(Step,Times,Num,Limit,Acc,Tot,Max) when (Step =:= Times) ->
    %io:format("Gen-> (Step == Times) Times:~p, Num:~p, Acc:~p, Tot:~p\n",[Times,Num,Acc,Tot]),
    gen(Step,1,Num+1,Limit,[Num]++Acc,Tot+1,Max);
% increasing inside loop Times
gen(Step,Times,Num,Limit,Acc,Tot,Max) -> 
    %io:format("Gen-> Step:~p, Times:~p, Num:~p, Acc:~p, Tot:~p\n",[Step,Times,Num,Acc,Tot]),
    gen(Step,Times+1,Num,Limit,[Num]++Acc,Tot+1,Max).

