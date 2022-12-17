-module(tempsys).
-export([startsys/0,stop/0]).
-define(Temps,['C','De', 'F', 'K', 'N', 'R', 'Re', 'Ro']).

startsys() -> 
    [{X,spawn(fun ()-> register(X,self()),temp(X) end)}||X <- ?Temps].

temp(Who)->
    %io:format("Temp actor ~p ready\n",[Who]),
    receive
        {Pid,{from,X,to,Y,Value}} when Y =:= Who ->
            %io:format("to same scale ~p:~p\n",[Who,Y]),
            X ! {Pid,res,convert(Y,Value)},
            temp(Who);
        {Pid,{from,X,to,Y,Value}} ->
            %io:format("Passing to next with value converted to C° ~p:~p\n",[Who,Y]),
            Y ! {Pid,{from,X,to,Y,convert_to_c(Who, Value)}},
            temp(Who);
        {Pid,res,Value} ->
            %io:format("Recevied result to ~p redirecting to client : ~p\n",[Who,Value]),
            Pid ! {res,Value},
            temp(Who)
after 10000 -> 
    stop(),
    exit(normal)
end.

stop() ->
    try
        [unregister(X) || X <- ?Temps] 
    catch
         Any:E -> io:format("~p---~p\n",[Any,E])
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

