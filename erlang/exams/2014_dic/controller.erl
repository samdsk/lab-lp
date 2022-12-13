-module(controller).
-export([start/1,node_addr/1]).
% -compile(export_all).
-define(Client,controller:node_addr("amora")).

node_addr(Name) ->
    {_,Host} = inet:gethostname(),
    list_to_atom(Name++[$@]++Host).

start(N) ->
    Server = spawn(fun() -> 
        process_flag(trap_exit,true),
        Primes = [X || X <- lists:seq(2, N), length([Y || Y <- lists:seq(2,trunc(math:sqrt(X))), (X rem Y) =:= 0])=:=0],
        First = spawn_link(sieve,start,[Primes]),
        register(first,First),
        Limit = lists:last(Primes),        
        server(Limit*Limit) end),
    register(server,Server).

server(Limit) ->
    io:format(user,"Server up and running at ~p - server limit: ~p\n",[self(),Limit]),
    receive 
        {new,N} = M when N < Limit -> 
            io:format(user,"You asked for: ~p\n",[N]),
            first ! M, server(Limit);
        {new,N} -> 
            io:format(user,"You asked for: ~p\n",[N]),
            {client,?Client} ! {result,{N,uncheckable}}, server(Limit); 
        {quit} ->
            io:format(user,"I'm closing...\n",[]),
            unregister(server),
            unregister(first),
            exit(normal);
        {res,R} ->  
            io:format(user,"Server received result : ~p\n",[R]),
            {client,?Client} ! {result,R}, server(Limit);
        Any -> io:format(user,"Server received unknown cmd : ~p\n",[Any])
end.
