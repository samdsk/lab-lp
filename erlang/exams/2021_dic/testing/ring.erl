-module(ring).
-export([start/1]).


start(N) ->
    First = spawn(fun () ->  ring(N,self(),N)  end),
    register(first,First).

ring(1,First,Max) ->
    loop(1, First,Max);
ring(N,First,Max) ->
    Next = spawn(fun () -> ring(N-1,First,Max) end),
    loop(N,Next,Max).



loop(N,Next,Max) ->
    receive
        {pass,Any} when N =:= Max -> 
            io:format("1 loop completed to ~p:~p > ~p\n",[N,Next,Any]),            
            loop(N, Next, Max);
        {pass,Any} -> 
            io:format("Recevied to ~p:~p > ~p\n",[N,Next,Any]),
            Next ! {pass,Any},
            loop(N, Next,Max);
        Any -> 
            io:format("Recevied to ~p:~p > ~p\n",[N,Next,Any]),
            Next ! {pass,Any},
            loop(N, Next,Max)
end.