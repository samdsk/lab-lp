-module(s).
-export([server/0]).

server() ->
    receive
        {Pid, print, Msg} -> io:format("~p~n",[Msg]), Pid ! ok, server();
        {Pid, sum, {A,B}} -> try Pid ! (A+B) catch Any -> io:format("Error: ~p~n",[Any]), Pid ! error after server() end;
        {Pid, min, {A,B}} -> try Pid ! (A-B) catch Any -> io:format("Error: ~p~n",[Any]), Pid ! error after server() end        
end.