-module(client).
-export([start/0]).

start() ->
    spawn(b@DsStudios,server,start,[]),
    %rpc:call(b@DsStudios,erlang,process_info,[Pid,group_leader]),
    sleep(),
    {server,b@DsStudios} ! ciao, io:format("Sent\n").


sleep() -> receive after 1000 -> true end.