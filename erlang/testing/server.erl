-module(server).
-export([start/0]).

start() ->
    register(server, self()),
    %global:register_name(server,self()),
    %process_info(self(),group_leader),
    io:format(server_shell,"Server started at ~p:~p\n",[node(),self()]),
    receive
        Any -> io:format(group_leader(),"from 4 client: ~p\n",[Any])
    end.