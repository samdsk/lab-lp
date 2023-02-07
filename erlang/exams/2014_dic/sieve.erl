-module(sieve).
-export([start/2,start/1]).

start([H|T]) ->
    Next = spawn_link(sieve,start,[T,self()]),
    listen(H,Next).
    
start([],_) -> io:format(user,"Sieve spawning loop finished\n",[]);
start([H],First) -> listen(H,First);
start([H|T],First) ->
    Next = spawn_link(sieve,start,[T,First]),
    listen(H,Next).

listen(Prime,Next) ->
    io:format(user,"Sieve ~p it's next is ~p ready!\n",[Prime,Next]),
    receive
        {new,N} when N =:= Prime -> 
            io:format(user,"Sieve ~p received ~p, it's prime.\n",[Prime,N]),
            server ! {res,{N,true}}, listen(Prime,Next);
        {new,N} when (N rem Prime) =:= 0 -> 
            io:format(user,"Sieve ~p received ~p, it's not prime.\n",[Prime,N]),
            server ! {res,{N,false}}, listen(Prime,Next);
        {new,N} -> 
            io:format(user,"Sieve ~p received ~p, passing to next node ~p.\n",[Prime,N,Next]),
            Next ! {pass,N}, listen(Prime,Next);
        {pass,N} when (N =:= Prime) -> 
            io:format(user,"Sieve ~p received passed ~p, it's a prime number ~p.\n",[Prime,N,Next]),
            first ! {res,{N,true}}, listen(Prime,Next);
        {pass,N} when (Prime =:= 2) -> 
            io:format(user,"Sieve ~p received passed ~p, it's a prime number ~p.\n",[Prime,N,Next]),
            server ! {res,{N,true}}, listen(Prime,Next);
        {pass,N} when (N rem Prime) /= 0 -> 
            io:format(user,"Sieve ~p received passed ~p, can't be divided by this prime. passing to next ~p.\n",[Prime,N,Next]),
            Next ! {pass,N}, listen(Prime,Next);
        {pass,N} when (N rem Prime) =:= 0 -> 
            io:format(user,"Sieve ~p received passed ~p, can be divided by this prime.\n",[Prime,N]),
            first ! {res,{N,false}}, listen(Prime,Next);
        {res,{N,_}} = M -> 
            io:format(user,"Sieve ~p received result ~p.\n",[Prime,N]),
            server ! M, listen(Prime,Next);
        Any -> io:format(user,"Unknown msg ~p : ~p\n",[Prime,Any])
end.