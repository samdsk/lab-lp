-module(client).
-export([start/0,ping/0,make_node/1,do_reverse/1]).
-define(Shell,whereis(shell)).

ping() ->
     
    L = 
    [net_adm:ping(make_node("mm1")),
    net_adm:ping(make_node("mm2")),
    net_adm:ping(make_node("server"))],
    [X|| X <- L].


make_node(Node) ->
    String = atom_to_list(node()),
    [_,Hostname] = string:split(String, [$@]),
    list_to_atom(Node++[$@|Hostname]).

start() ->
    spawn(make_node("mm1"),mm,start,[mm1]),
    spawn(make_node("mm2"),mm,start,[mm2]),
    io:format(?Shell,"Spawned mm1 and mm2\n",[]),
    {mm,make_node("mm1")} ! {cmd,spawn_server}.

do_reverse(Input) ->
    Len = length(Input),
    case Len rem 2 of
        0 -> send_to_mm(lists:split(Len div 2, Input));
        _ -> {L1,[H|_]=L2} = lists:split(Len div 2, Input), send_to_mm({L1++[H],L2})
    end.

send_to_mm({L1,L2}) ->
    io:format(?Shell,"L1:~p - L2:~p\n",[L1,L2]),
    Len = length(L1),
    rpc("mm1",mm,{cmd,reverse_ready,Len}),
    sleep(2000),
    foreach(L1,1,Len,"mm1"),
    foreach(L2,1,Len,"mm2").

sleep(T) -> receive after T -> true end.

listen() ->
    receive
        Any -> io:format(?Shell,"Client: recevied -> ~p\n",[Any]),listen()
end.

foreach([],_,_,_) -> ok;
foreach([H|T],N,Len,Node) ->
    rpc(Node,mm,{reverse,{N,Len,H}}),
    foreach(T,N+1,Len,Node).

rpc(Node,Mod,Msg) ->
    {Mod,make_node(Node)} ! Msg.
    