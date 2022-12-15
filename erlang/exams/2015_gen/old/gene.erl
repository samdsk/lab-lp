-module(gene).
-export([start/3]).
start(N,Limit,1) ->
    io:format("Spawned 1:~p\n",[self()]),
    receive
    {p,List} -> 
        Times = trunc(math:pow(Limit, N-1)),
        Max = trunc(math:pow(Limit,N)),
        L = loop(1,1,0,Times,List,Max,Limit), io:format("Proc:1 ~p\n",[L]), server ! {res,1,lists:reverse(L)}
end;

start(N,Limit,Pos) ->
    io:format("Spawned ~p:~p\n",[Pos,self()]),
    receive
    {p,List} ->         
        Times = trunc(math:pow(Limit, N-Pos)),
        io:format("Proc:~p List: ~p Times: ~p \n",[Pos,List,Times]),
        %Max = trunc(math:pow(Limit,N)),
        L = loop(1,0,Times,List,Limit), 
        io:format("~p\n",[L]), server ! {res,Pos,L}
end.


loop(1,_,_,_,L,0,_) -> io:format("finished proc1 loop\n"),L;
loop(1,Num,Times,Times,L,Limit,M) -> 
    io:format("Time=Time, Num: ~p ",[Num]),
    if 
        Num>M -> io:format("Not incrementing Num\n"),loop(1,1,0,Times,L,Limit,M);
        Num=<M -> io:format("Incrementing Num\n"), loop(1,Num+1,0,Times,L,Limit,M) 
    end;
loop(1,Num,T,Times,L,Limit,M) -> io:format("T:~p Time:~p Limit:~p\n",[T,Times,Limit]),loop(1,Num,T+1,Times,[[Num]|L],Limit-1,M).

loop(_,_,_,[],_) -> io:format("finished proc loop\n"), [];
loop(Num,Times,Times,L,M) -> 
    io:format("Time=Time, Num: ~p ",[Num]),
    if 
        Num>=M -> io:format("Resetting Num\n"), loop(1,0,Times,L,M);
        Num<M -> io:format("Incrementing Num\n"), loop(Num+1,0,Times,L,M)
        
    end;
loop(Num,T,Times,[H|List],M) -> io:format("T:~p Time:~p Limit:~p\n",[H,Times,M]), [H++[Num]  | loop(Num,T+1,Times,List,M)].