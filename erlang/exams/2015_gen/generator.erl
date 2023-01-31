-module(generator).
-export([start/3]).

start(Pos,M,Max) ->
    listen(Pos,trunc(math:pow(M,Pos-1)),M,Max).

listen(Pos,Limit,M,Max) ->
    receive
        {gen,L} -> %io:format("List received:- ~p\n",[L]),
            case L of
                [] -> server ! {res,Pos,gen(Limit,M,Max)}
                %_ -> server ! {res,gen(L, Limit, M, Max)}
            end; 
        Any -> io:format("Generator: ~p received unknown command: ~p\n",[Limit,Any])
end.

% gen(L,Limit,M,Max) ->
%     gen(L,1,Limit,1,M,[],0,Max).

gen(Limit,M,Max) ->
    gen(1,Limit,1,M,[],0,Max).

% gen(_,_,_,_,_,Acc,Max,Max) -> lists:reverse(Acc);

% gen([H|T],Limit,Limit,M,M,Acc,I,Max) ->
%     io:format("~p ~p ~p ~p\n",[Limit,Limit,M,M]),
%     gen(T,1,Limit,1,M,[[M|H]|Acc],I+1,Max);

% gen([H|T],Limit,Limit,Current,M,Acc,I,Max) ->
%     io:format("~p ~p ~p ~p\n",[Limit,Limit,Current,M]),
%     gen(T,1,Limit,Current+1,M,[[Current|H]|Acc],I+1,Max);

% gen([H|T],Count,Limit,Current,M,Acc,I,Max) ->
%     io:format("~p ~p ~p ~p\n",[Count,Limit,Current,M]),
%     gen(T,Count+1,Limit,Current,M,[[Current|H]|Acc],I+1,Max).
    

gen(_,_,_,_,Acc,Max,Max) -> lists:reverse(Acc);

gen(Limit,Limit,M,M,Acc,I,Max) ->
    %io:format("~p ~p ~p ~p\n",[Limit,Limit,M,M]),
    gen(1,Limit,1,M,[M|Acc],I+1,Max);

gen(Limit,Limit,Current,M,Acc,I,Max) ->
    %io:format("~p ~p ~p ~p\n",[Limit,Limit,Current,M]),
    gen(1,Limit,Current+1,M,[Current|Acc],I+1,Max);

gen(Count,Limit,Current,M,Acc,I,Max) ->
    %io:format("~p ~p ~p ~p\n",[Count,Limit,Current,M]),
    gen(Count+1,Limit,Current,M,[Current|Acc],I+1,Max).

