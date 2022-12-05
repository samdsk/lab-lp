-module(es5).
-export([start/0,unregister/0]).

unregister() ->
    begin
    Try_all = fun (C) ->        
        try whereis(C) of
            undefined -> ok;
            _Any -> unregister(C)
        catch
            Any -> io:format("im here: ~p\n",[Any])
        end 
    end,
    [Try_all(X) || X <- [client,server,counter]]
end.


start() ->    
    register(client,spawn(fun()-> client() end)),
    register(server,spawn(fun()-> server() end)),
    register(counter,spawn(fun()-> counter([0,0,0]) end)),
    send_my(whereis(client)).


send_my(Pid) ->
    io:format("Pid:~p\n",[Pid]),
    server ! {Pid, print, "test1"},
    server ! {Pid,tot},
    server ! {Pid, print, "test2"},
    server ! {Pid, sum, {1,2}},
    server ! {Pid, min, {1,2}},
    server ! {Pid,tot},
    server ! {Pid, sum, {6,2}},
    server ! {Pid, sum, {7,7}},
    server ! {Pid, min, {1,2}},
    server ! {Pid,tot}.

client() ->
    io:format("Client ready\n"),
    receive
        Any -> io:format("~p\n",[Any]),client()
end.

server() ->
    io:format("Server ready\n"),
    receive 
        {Pid, print, Msg} -> io:format("Server Received : ~p~n",[Msg]), Pid ! ok, count(print),server();
        {Pid, sum, {A,B}} -> 
            try Pid ! (A+B) catch Any -> io:format("Server Error: ~p~n",[Any]), 
            Pid ! error 
            after count(sum),server() end;
        {Pid, min, {A,B}} -> 
            try Pid ! (A-B) catch Any -> io:format("Server Error: ~p~n",[Any]), 
            Pid ! error 
            after count(min),server() end;
        {_, tot} = Msg -> count(Msg), server()
end.

count(Op) -> counter ! Op.

counter([P,M,S]=L) ->
    io:format("Counter ready\n"),
    receive
        sum -> counter([P,M,S+1]);
        min -> counter([P,M+1,S]);
        print -> counter([P+1,M,S]);
        {Pid,tot} -> Pid ! (lists:foldl(fun (X,Acc) -> Acc+X end, 0, L)),counter(L)
end.