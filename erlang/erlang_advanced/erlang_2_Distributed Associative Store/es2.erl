-module(es2).
-export([connect/0,init/0,loop/1,rpc/2]).



string_to_atom_node(Node) ->
    {_,Host} = inet:gethostname(),
    list_to_atom(Node++"@"++Host).

connect() ->
    L = ["node1","node2"],
    [net_adm:ping(string_to_atom_node(X))|| X <- L].

init() ->
    connect(),
    Node_1 = string_to_atom_node("node1"),
    Node_2 = string_to_atom_node("node2"),    
    Server_1 = spawn(Node_1,?MODULE,loop,["Server_1"]),
    Server_2 = spawn(Node_2,?MODULE,loop,["Server_2"]),
    {Server_1,Server_2}.


loop(Server_name) ->
    io:format("Server: ~p ready\n",[Server_name]),
    receive
        {_Pid,{store,Key,Value}} ->
            io:format("~p # received Key-Value -> ~p:~p \n",[Server_name,Key,Value]),
            put(Key,Value),
            send_to_nodes(Key,Value),
            loop(Server_name);
        {node_op,store,Key,Value} ->
            io:format("~p # received node_op -> ~p:~p \n",[Server_name,Key,Value]),
            put(Key,Value),
            loop(Server_name);
        {Pid,{lookup,Key}} ->
            io:format("~p # received lookup -> ~p \n",[Server_name,Key]),
            Pid ! {server,get(Key)},
            loop(Server_name)
    
end.

send_to_nodes(Key,Value) ->
    Nodes = nodes(),
    send(Nodes,Key,Value).

send([],_,_) -> ok;  
send([H|T],K,V) ->
    {loop,H} ! {node_op,store,K,V},
    send([T],K,V).

rpc(Node,M) ->    
    {loop,string_to_atom_node(Node)} ! {self(),M}.


