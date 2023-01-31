-module(client).
-export([convert/5]).

convert(from,F,to,T,V) ->
    rpc({F,T,V},F).

rpc(Msg,F) ->
    F ! {self(),Msg},
    receive
        Any -> io:format("Client: ~p\n",[Any])
end.
