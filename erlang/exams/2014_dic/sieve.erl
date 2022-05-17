-module(sieve).
-export([start/2]).

start(Prime,Limit) ->  
    Sieve_1 = self(),
    Next_Sieve = spawn_link(fun() -> start(next_prime(Prime+1,Limit),Limit,Sieve_1) end),
    listen(Prime,Next_Sieve).

start(Prime,Limit,Sieve_1) ->
    Next_prime = next_prime(Prime+1, Limit),
    case Next_prime of
        false -> 
            io:format("Last Sieve, ~p ~p\n",[Prime,self()]),
            listen(Prime,Sieve_1,Sieve_1);
        _ -> Next_Sieve = spawn_link(fun() -> start(Next_prime,Limit,Sieve_1) end),
            io:format("Sieve, ~p ~p\n",[Prime,self()]),
            listen(Prime,Sieve_1,Next_Sieve)
    end.

listen(Prime,Next_Sieve) ->    
    receive 
        {new, N} -> 
            io:format("Spawned Sieve, ~p ~p Received: ~p\n",[Prime,self(),N]),
            case N div Prime of
                1 when N rem Prime =:= 0 -> io:format("Prime\n"), global:send(server,{res,true}),listen(Prime,Next_Sieve);
                _ -> io:format("Passing to next\n"), Next_Sieve ! {pass,N},listen(Prime,Next_Sieve)
            end;
        {res,R} = Msg -> io:format("Spawned Sieve, ~p ~p Received res: ~p\n",[Prime,self(),R]), global:send(server,Msg), listen(Prime,Next_Sieve);
        {pass,N} -> io:format("Spawned Sieve, ~p ~p Received pass: ~p\n",[Prime,self(),N]), global:send(server,{res,false}), listen(Prime,Next_Sieve)
    end.

listen(Prime,Sieve_1,Next_Sieve) ->    
    receive
        {pass, N} = Msg ->
            io:format("Spawned Sieve, ~p ~p Received pass: ~p\n",[Prime,self(),N]),
            case N div Prime of
                1 when N rem Prime =:= 0 -> io:format("Returning to sieve 1\n"), Sieve_1 ! {res, true};
                _ -> Next_Sieve ! Msg
            end,listen(Prime,Sieve_1,Next_Sieve)
    end.
            

next_prime(N,Limit) when N > Limit ->
    false;
next_prime(N,Limit) -> 
    case is_prime(N,2) of
        true -> N;
        false -> next_prime(N+1,Limit)
end.

is_prime(N,N) -> true;
is_prime(N,Div) ->
    case N rem Div of
        0 -> false;
        _ -> is_prime(N,Div+1)
end.