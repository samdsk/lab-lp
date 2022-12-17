-module(tempsys).
-export([startsys/0]).


startsys() ->
    Temps = ['C','F','K','R','De','N','Re','Ro'],
    Init = fun(T) -> Pid = spawn(fun()-> register(T,self()),temp(T) end), {T,Pid} end,
    Pids = lists:map(Init,Temps),
    Map = maps:from_list(Pids),
    io:format("Services created: ~p\n",[Map]).

temp(T) ->
    io:format("Temp: ~p:~p\n",[T,self()]),
    receive
        {Who,{from,A,to,B,Temp}} when (A=:=B)=:=T -> Who ! {res,Temp},temp(T);
        {Who,{from,_,to,B,Temp}} when T=:=B -> Who ! {res,convert(B,Temp)} ,temp(T);
        {Who,{from,A,to,B,Temp}} -> B ! {Who,{from,A,to,B,convert_to_c(A, Temp)}},temp(T);
        Any -> io:format("Error: ~p",[Any]),temp(T)    
end.

convert(T,Temp) ->
    case T of
        'C'   -> Temp;
        'F'   -> Temp * (9/5) + 32; 
        'K'   -> Temp + 273.15;
        'R'   -> (Temp + 273.15) * (9/5);
        'De'  -> (100 - Temp) * (3/2); 
        'N'   -> Temp * (33/100);
        'Re'  -> Temp * (4/5);
        'Ro'  -> (Temp * (21/40)) + 7.5
end.

convert_to_c(T,Temp) ->
    case T of
        'C'   -> Temp;
        'F'   -> (Temp - 32) * (5/9); 
        'K'   -> Temp - 273.15;
        'R'   -> (Temp * (5/9)) - 273.15;
        'De'  -> 100 - (Temp * (2/3)); 
        'N'   -> Temp * (100/33);
        'Re'  -> Temp * (5/4);
        'Ro'  -> (Temp - 7.5) * (40/21)
end.


