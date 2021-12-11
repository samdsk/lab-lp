-module(ring).
-export([start/0,send_m/1,send_m/2,stop/0,start/2]).
start() ->
    L1 = [fun(X)-> X*N end||N<-lists:seq(1,7)],
    start(7,L1).

start(_,L) ->  register(server,spawn(fun() -> 
    process_flag(trap_exit, true),
    First = spawn_link(fun() -> spawn_loop(1,L,self()) end),
    listen(First)
end)).

send_m(N) -> server ! {job1,N}.
send_m(N,T) -> server ! {jobt,N,T}.
stop() -> server ! quit.
listen(First) ->
    receive
        {job1,_} = Msg -> First ! Msg, listen(First);
        {jobt,_,_} = Msg -> First ! Msg, listen(First);
        {res,N} -> io:format("Result: ~p\n",[N]),listen(First);
        quit -> First ! quit, unregister(server), exit(quitting)
end.

spawn_loop(_,[X],First) ->    
    sub_proc_last(X, First);
spawn_loop(I,[H|L],First) ->    
    Next = spawn_link(fun() -> spawn_loop(I+1,L,First) end),
    sub_proc(H,Next).

sub_proc(X,Next) ->
    receive
        {job1,N} -> Next ! {job1,apply(X, [N])},sub_proc(X, Next);
        {jobt,N,T} -> Next ! {jobt,apply(X, [N]),T},sub_proc(X, Next);
        quit -> Next ! quit, exit(quitting)
end.
sub_proc_last(X,First) ->
    receive
        {job1,N} -> server ! {res,apply(X, [N])},sub_proc_last(X, First);
        {jobt,N,1} -> server ! {res,apply(X, [N])},sub_proc_last(X, First);
        {jobt,N,T} -> First ! {jobt,apply(X, [N]),T-1},sub_proc_last(X, First);        
        quit -> exit(quitting)
end.