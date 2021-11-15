-module(remoting_sep).
-export([start/2, create/1, send_msg/2, stop/1]).

start(N, L) -> spawn(N, remoting_sep, create, [L]).

create(L) ->
    global:register_name(L, self()),
    io:format(global:whereis_name('remote-host'), "I'm the actor «~p» created on ~p and registered as ~p~n", [self(), node(), L]),
    wait().

wait() ->
    io:format(global:whereis_name('remote-host'), "Waiting...~n", []),
    receive
        {msg, M} -> io:format(global:whereis_name('remote-host'), "Here it is ~p~n", [M]), wait();
        {stop} -> io:format(global:whereis_name('remote-host'), "Stopping");
        Other -> io:format(global:whereis_name('remote-host'), "I got this :- ~p~n", [Other])
    end.

send_msg(L, M) -> global:whereis_name(L) ! {msg, M}.
stop(L) -> global:whereis_name(L) ! {stop}.
