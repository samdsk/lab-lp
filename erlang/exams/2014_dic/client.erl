-module(client).
-export([is_prime/1,close/0,node_addr/1,ping/0]).
% -compile(export_all).

ping() -> net_adm:ping(node_addr("sif")).

node_addr(Name) ->
    {_,Host} = inet:gethostname(),
    list_to_atom(Name++[$@]++Host).

rpc(Msg) ->
    register(client,self()),
    {server,node_addr("sif")} ! Msg,
    receive
        {result,{N,uncheckable}} -> 
            io:format(user,"~p is uncheckable\n",[N]);
        {result,{N,R}} -> 
            io:format(user,"is ~p prime? ~p\n",[N,R])
    after 5000 ->
        io:format(user,"Client timeout\n",[]) 
end.

is_prime(N) ->
    rpc({new,N}).

close() ->
    rpc({quit}).

