-module(chat_server).
-export([start/0]).
start() -> start_server(), lib_chan:start_server("chat.conf").

start_server() ->
    register(chat_server,
    spawn(fun() -> 
        process_flag(trap_exit, true),
        Val = (catch server_loop([])),
        io:format("Server terminated with:~p~n",[Val])
end)).

server_loop(L) -> 
    receive
        {mm,Channel,{login,Group,Nickname}} ->
            case lookup(Group,L) of
                {ok,Pid} -> Pid ! {login,Channel,Nickname}, server_loop(L);
                error -> 
                    Pid = spawn_link(fun() -> chat_group:start(Channel,Nickname) end),
                    server_loop([{Group,Pid}|L])
            end;
        {mm_closed, _} -> server_loop(L);
        {'EXIT',Pid,allGone} -> L1 = remove_group(Pid,L), server_loop(L1);
        Msg -> io:format("Server received Msg=~p~n",[Msg]), server_loop(L)
end.

lookup(G,[{G,Pid}|_]) -> {ok,Pid};
lookup(G,[_|T]) -> lookup(G,T);
lookup(_,[]) -> error.

remove_group(Pid,[{G,Pid}|T]) -> io:format("~p removed\n",[G]),T;
remove_group(Pid,[H|T]) -> [H | remove_group(Pid,T)];
remove_group(_,[]) -> [].

