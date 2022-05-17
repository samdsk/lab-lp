-module(ms).
-export([s/0]).
-define(debug,true).


-ifdef(debug).
-define(prova,x).
-endif.

-ifdef(prova).
s() -> io:format(?prova).
-else.
s() -> io:format("no\n").
-endif.