-module(records).
-include("person.hrl").
-export([s/0]).
s() -> 
    P = #person{name=sam,friends=[none,":("]},
    io:format("Person: ~p~n",[P]),
    p(P).

p(#person{name=none}) ->  io:format("Person: sam true~n").