-module(com).
-export([start/2]).


start(N,M) ->
    process_flag(trap_exit, true),
    Workers = [spawn_link(gen,start,[X,M])|| X<-lists:seq(0, N-1)],
    listen(Workers).

permutations([H|Workers]) -> 
