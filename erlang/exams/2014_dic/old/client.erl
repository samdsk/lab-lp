-module(client).
-export([is_prime/1,close/0]).

is_prime(N) ->
    global:register_name(client, 
        spawn(fun()-> 
            global:send(server,{new,N}),
                receive
                    {result,R} -> io:format("is ~p prime? ~p\n",[N,R]);
                    Any -> io:format("un: ~p",[Any])
                end
        end)
    ).

close() -> global:send(server,quit).