-module(client).
-compile(export_all).
-define(Shell,user).
-define(Abc, "abcdefghijklmnopqrstuvwxyz").
-define(A123, "0123456789").

start() ->
    ping(),
    spawn(node_make("mm1"),mm,start,["mm1"]),
    spawn(node_make("mm2"),mm,start,["mm2"]),
    {mm,node_make("mm1")} ! {cmd,spawn_server}.

ping() ->
    [net_adm:ping(node_make(X)) || X <- ["mm1","mm2","server"]].

test() -> send_eo(?Abc,1).

node_make(Str) ->
    {_,Host} = inet:gethostname(),
    list_to_atom(Str++[$@]++Host).

rpc(Msg)->
    server ! {self(),Msg},
    receive
        Any -> io:format(?Shell,"Rpc: ~p\n",[Any])
end.

send_eo([],_) -> ok;
send_eo([H|L],N) when N rem 2 =:= 0 -> {mm,node_make("mm2")} ! {reverse,N,H}, send_eo(L,N+1);
send_eo([H|L],N) -> {mm,node_make("mm1")} ! {reverse,N,H}, send_eo(L,N+1).