-module(es2).
-export([connect/0,init/0,loop/1,rpc/2,start/1,look/1,store/2]).


% creating a node address an atom from a string
% node@hostname
string_to_atom_node(Node) ->
    {_,Host} = inet:gethostname(),
    list_to_atom(Node++"@"++Host).

% connecting nodes
connect() ->
    L = ["node1","node2"],
    [net_adm:ping(string_to_atom_node(X))|| X <- L].

% initializing starters on each node (on node1 and node2)
init() ->
    connect(),
    Node_1 = string_to_atom_node("node1"),
    Node_2 = string_to_atom_node("node2"),    
    Server_1 = spawn(Node_1,?MODULE,start,["Server_1"]),
    Server_2 = spawn(Node_2,?MODULE,start,["Server_2"]),
    {Server_1,Server_2}.

% spawn server loop on the node and register the process as server with given name
start(Server_name) ->register(server,spawn(fun()-> loop(Server_name)end)).

% server loop
loop(Server_name) ->
    io:format("Server: ~p ready\n",[Server_name]),
    receive
        {Pid,{store,Key,Value}} ->
            io:format("~p # received Key-Value -> ~p:~p \n",[Server_name,Key,Value]),
            put(Key,Value),
            send_to_nodes(Key,Value),
            Pid ! ok,
            loop(Server_name);
        {node_op,store,Key,Value} ->
            io:format("~p # received node_op -> ~p:~p \n",[Server_name,Key,Value]),
            put(Key,Value),
            loop(Server_name);
        {Pid,{lookup,Key}} ->
            io:format("~p # received lookup -> ~p \n",[Server_name,Key]),
            Pid ! {server,get(Key)},
            loop(Server_name);
        Any -> 
            io:format("~p # received lookup -> ~p \n",[Server_name,Any]),
            loop(Server_name)
end.

% replicate the msg on each node
send_to_nodes(Key,Value) ->
    Nodes = nodes(),
    send(Nodes,Key,Value),
    io:format("send_to_nodes done\n").

% sends the Key Value to each node
send([],_,_) -> io:format("sent to all nodes\n");  
send([H|T],K,V) ->
    io:format("sending to ~p\n",[H]),
    {server,H} ! {node_op,store,K,V},
    send(T,K,V).

store(K,V) -> rpc("node1",{store,K,V}).
look(K) -> rpc("node1",{lookup,K}).
% sends the msg to server on given node 
rpc(Node,M) ->    
    {server,string_to_atom_node(Node)} ! {self(),M},
    receive
        Any -> io:format("RPC: ~p\n",[Any])
    after
        2000 -> io:format("RPC: Timeout\n"),
        exit(timeout)
end.


