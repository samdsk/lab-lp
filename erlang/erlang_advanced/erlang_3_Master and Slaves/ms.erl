-module(ms).
-export([start/1,to_slave/2]).

start(N) -> spawn(
    fun() ->
        process_flag(trap_exit, true),
        init_slaves(N),
        control()
    end
).

init_slaves(0) -> ok;
init_slaves(N) -> 
    Pid = spawn_link(fun() -> slave() end), 
    io:format("Created salve: ~p:~p\n",[N,Pid]),
    register(list_to_atom(integer_to_list(N)),Pid), 
    init_slaves(N-1).

slave() -> 
    receive
        {die,M} -> exit({"Exiting",M});
        {Any,M} -> io:format("Slave: ~p - ~p \n",[M,Any]),slave()
end.

to_slave(Msg,N) -> list_to_atom(integer_to_list(N)) ! {Msg,N}.


control() ->
    receive
        {'EXIT',Pid,{_,N}} -> 
            io:format("Restarting: ~p:~p\n",[N,Pid]), 
            P = spawn_link(fun() -> slave() end), 
            register(list_to_atom(integer_to_list(N)),P),
            control();
        Any -> Any, control()
end.