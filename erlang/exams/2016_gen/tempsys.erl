-module(tempsys).
-export([startsys/0]).
-define(TEMPS,['C','F','K','R','De','N','Re','Ro']).

%% This solution is WRONG!!!
%% the correct one should have 2 sets of nodes one for converting from "From_Temp" to Celcius,
%% another set to convert form Celcius to "To_Temp".
%% the msg has to travel from client to to_celcius (which converts to celicius the given from_temp) 
%% then to from_celcius (which converts from celcius to the given to_temp).
%% finally the msg have to travel back to client from from_celcius node to to_celcius node then to client
%% 
%% msg -> client -> to_celcius -> from_celcius
%% result -> from_celcius -> to_celcius -> client

startsys() -> 
    %try [unregister(X) || X <- ?TEMPS]
    %    catch _ -> io:format("Error\n")
    %end,

    [register(T,spawn(fun () -> temp(T) end)) || T <- ?TEMPS].


temp(Who) ->
    %io:format("~p is ready!\n",[Who]),
    receive
        
        {PID,{T_1,T_2,Value}} when Who == T_2 ->
            %io:format("Received a msg from ~p to ~p : ~p\n",[T_1,T_2,Value]),
            T_1 ! {res,PID,convert(Who,Value)},temp(Who);
        {PID,{T_1,T_2,Value}} when Who == T_1 ->
            %io:format("Received a msg to ~p : ~p sending it to ~p\n",[T_1,Value,T_2]),
            T_2 ! {PID,{T_1,T_2,convert_to_c(Who,Value)}},temp(Who);
        {res,PID,Value} -> 
            %io:format("Recevied a result:~p forwarding to client:~p\n",[Value,PID]),
            PID ! {res,Value},temp(Who);
        Any -> io:format("Any: ~p\n",[Any]),temp(Who)
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
