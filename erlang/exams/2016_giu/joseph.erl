-module(joseph).
-export([start/2]).



start(N,T) -> spawn(fun() -> 
process_flag(trap_exit,true),
Head = spawn_link(fun() -> init_sub_proc(1,N,self()) end),
rpc(Head,T,N)
end).

rpc(Head,T,N) ->
    Head ! {new,self(),every,T,hops,1,N},
    receive
        Any -> Any
end.

init_sub_proc(N,N,Head) ->     
    io:format("Last process: ~p\n",[self()]),
    sub_proc(N,Head);
init_sub_proc(M,N,Head) -> 
    Next = spawn_link(fun() -> init_sub_proc(M+1,N,Head) end), 
    io:format("Process: ~p:~p\n",[M,self()]),
    sub_proc(M,Next).


sub_proc(N,Next) -> 
    receive  
    {RPC,every,_T,hops,_Num,_Last,Total} when Total =:= 1 -> io:format("Last remaining ~p:~p\n",[N,self()]), RPC ! {res,N}; 

    {RPC,every,T,hops,Num,Last,Total} when T=:=Num -> 
        Last ! {next,Next},        
        io:format("Removed node: ~p N:~p Total: ~p\n",[self(),N,Total]),
        Next ! {RPC,every,T,hops,1,Last,Total-1};

    {RPC,every,T,hops,Num,_Last,Total}  -> Next ! {RPC,every,T,hops,Num+1,self(),Total}, sub_proc(N, Next);

    {next,New} -> io:format("Setting new next\n"),sub_proc(N, New);

    {new,RPC,every,T,hops,Num,Total} -> io:format("Received first msg in: ~p\n",[N]),Next ! {RPC,every,T,hops,Num+1,self(),Total}, sub_proc(N, Next)
end.