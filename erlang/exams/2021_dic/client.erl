-module(client).
-export([start/0,ping/0,make_node/1,do_reverse/1]).

% this app spawn 2 middle-man processes and a server
% every process must print it's output on own shell
% to print output on different shell use io:format/3 with user -> es. io:format(user,"hello world!\n",[]). 
% user = is a registered process which every node erlang shell has
% if you want redirect th output to a particular node, register group_leader() of that node globally 
% using global:register_name(shell,group_leader()) then use it as io:format(global:whereis_name(shell),"hello world!\n",[])

%           MM1 (receives only even charactors)
%         /    \
%        /      \
% CLIENT \      / SERVER (assemble msgs received fron mm1/2 and reverse them and send to back to client)
%         \    /
%           MM2 (receives only odd charactors)

ping() ->
    [net_adm:ping(make_node(X))||X<-["mm1","mm2","server"]].

make_node(Node) ->
    {_,Host} = net:gethostname(),
    list_to_atom(Node++[$@]++Host).

start() ->
    ping(),
    io:format(user,"Starting...\n",[]),
    spawn(make_node("mm1"),mm,start,[mm1]),
    spawn(make_node("mm2"),mm,start,[mm2]),
    io:format(user,"Spawned mm1 and mm2\n",[]),
    {mm,make_node("mm1")} ! {cmd,spawn_server}.

do_reverse(Input) ->
    register(client,self()),
    Len = length(Input),
    case Len rem 2 of
        0 -> send_to_mm(lists:split(Len div 2, Input));
        _ -> {L1,[H|_]=L2} = lists:split(Len div 2, Input), send_to_mm({L1++[H],L2})
    end,
    listen().

send_to_mm({L1,L2}) ->
    io:format("L1:~p - L2:~p\n",[L1,L2]),
    Len = length(L1),
    rpc("mm1",mm,{cmd,reverse_ready,Len}),
    sleep(2000),
    foreach(L1,1,Len,"mm1"),
    foreach(L2,1,Len,"mm2").

sleep(T) -> receive after T -> true end.

listen() ->
    receive
        Any -> io:format(user,"Client: recevied -> ~p\n",[Any]),listen()
end.

foreach([],_,_,_) -> ok;
foreach([H|T],N,Len,Node) ->
    rpc(Node,mm,{reverse,{N,Len,H}}),
    foreach(T,N+1,Len,Node).

rpc(Node,Mod,Msg) ->
    {Mod,make_node(Node)} ! Msg.
    