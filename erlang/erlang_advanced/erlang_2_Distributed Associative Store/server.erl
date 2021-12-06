-module(server).
-export([start/0,store/2,lookup/1]).


start() -> Nodes = ['a@192.168.1.2', 'b@192.168.1.16'], ping(Nodes),
    register(server, spawn(fun() -> loop() end)).

ping([]) -> ping_ok;
ping([H|T]) -> net_adm:ping(H), ping(T).

store(Key, Value) -> rpc({store,Key, Value}).
lookup(Key) -> rpc({lookup,Key}).


rpc(Msg) -> 
    server ! {self(),Msg},
    receive 
        {server, Reply} -> Reply
    after 2000 ->
        io:format("Timeout\n")
end.

loop() ->
receive
    {node_op,{Pid,{store,K,V}}} -> put(K,V), Pid ! {server, ok}, loop();
    {_,{store,K,V}} = M -> put(K,V), exec_nodes(nodes(),M), loop();
    {Pid,{lookup,K}} -> Pid ! {server, get(K)}, loop()
end.

exec_nodes([],_) -> io:format("send_to_all_nodes");
exec_nodes([H|T],M) -> io:format("Node: ~p~n",[H]),{server, H} ! {node_op,M}, exec_nodes(T,M).