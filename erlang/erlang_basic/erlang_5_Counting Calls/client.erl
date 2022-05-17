-module(client).
-export([init/0,read/0]).

init() -> 
    Server = spawn(s,server,[]),
    Counter = spawn(count,counter,[{0,0,0,0},Server]),
    Reader = spawn(fun() -> read()end), {Counter,Reader}.

read() -> 
    receive 
        Any -> io:format("Reader: ~p~n",[Any]),read()
end.