-module(controller).
-export([start/1]).


start(Limit) ->
    global:register_name(server,
    spawn(fun() -> 
        process_flag(trap_exit, true),
        Sieve_1 = spawn_link(sieve,start,[2,Limit]),
        listen(Sieve_1,Limit)
end)).

listen(Sieve_1,Limit) ->
    receive
        {new,N} when N > Limit -> io:format("~p is uncheckable, too big value.~n",[N]), listen(Sieve_1,Limit);
        {new,N} = Msg -> io:format("You asked for: ~p~n",[N]), Sieve_1 ! Msg, listen(Sieve_1,Limit);
        {res,R} -> global:send(client,{result,R}), listen(Sieve_1,Limit);
        quit -> io:format("I'm closing ...~n"), exit(closing)
end.
