-module(client).
-export([convert/5,test/0,test1/0]).

test() ->
    tempsys:startsys(),
    convert(from, 'Re', to, 'De', 25).
test1() ->
    U = fun(X) -> unregister(X) end,
    Temps = ['C','F','K','R','De','N','Re','Ro'],
    lists:map(U,Temps),
    tempsys:startsys(),
    convert(from, 'Re', to, 'De', 25).
convert(from,A,to,B,Temp) ->
    spawn(fun()-> rpc(self(),{from,A,to,B,Temp}) end).

rpc(Pid,{from,A,to,B,Temp} = Msg) ->
    A ! {Pid,Msg},
    receive 
        {res,Res} -> io:format("~p°~s are equivalent to ~p°~s\n",[Temp,A,Res,B]);
        Any -> io:format("Error: client: ~p\n",[Any])
end.