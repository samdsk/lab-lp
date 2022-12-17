-module(client).
-export([convert/5,test/0]).


convert(from,X,to,Y,Temp) -> 
    X ! {self(),{from,X,to,Y,Temp}},
    receive
        {res,Result} ->
            io:format("~p°~s are equivalent to ~p°~s\n",[Temp,X,Result,Y]);
        Any ->
            io:format("Client received: ~p\n",[Any])
after 3000 -> exit(normal)
end.

test() ->
    Conv2 = fun(X) -> client:convert(from, 'C', to, X, 32) end,
    lists:map(Conv2, ['C','De', 'F', 'K', 'N', 'R', 'Re', 'Ro']).

rpc(X,Msg) ->
    X ! {self(),Msg},
    receive
        Any ->
            io:format("Client received: ~p\n",[Any])
after 3000 -> exit(normal)
end.

