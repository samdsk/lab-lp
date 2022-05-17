-module(remoting_nosep).
-export([start/2, create/1, send_msg/2, stop/1]).

start(N, L) -> spawn(N, remoting_nosep, create, [L]).

create(L) ->
    global:register_name(L, self()),
    io:format("I'm the actor «~p» created on ~p and registered as ~p~n", [self(), node(), L]),
    wait().

wait() ->
    io:format("Waiting...~n", []),
    receive
        {msg, M} -> io:format("Here it is ~p~n", [M]), wait();
        {stop} -> io:format("Stopping");
        Other -> io:format("I got this :- ~p~n", [Other])
    end.

send_msg(L, M) -> global:whereis_name(L) ! {msg, M}.
stop(L) -> global:whereis_name(L) ! {stop}.
