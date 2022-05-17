-module(chat_client).
-export([start/1,connect/5]).

start(Nickname) -> 
    connect("localhost", 2223, "password", "general", Nickname).

connect(Host,Port,HostPassword,Group,Nickname) -> 
    spawn(fun()-> handler(Host,Port,HostPassword,Group,Nickname) end).

handler(H,P,HP,G,N) -> 
    process_flag(trap_exit, true),
    start_connector(H,P,HP),
    disconnected(G,N).


disconnected(Group,Nickname) -> 
    receive
        {connected,MM} -> 
            io:format("Connected to server\nsending data\n"),
            lib_chan_mm:send(MM,{login,Group,Nickname}),
            wait_login_response(MM);
        {status,S} -> 
            io:format("Status: ~p\n",[S]),
            disconnected(Group,Nickname);
        Other -> io:format("chat_client disconnected unexpected: ~p\n",[Other]),
        disconnected(Group,Nickname)
end.

start_connector(H,P,HP) -> 
    S = self(), 
    spawn_link(fun() -> try_to_connect(S,H,P,HP) end).

try_to_connect(Parent,Host,Port,HostPassword) -> 
    case lib_chan:connect(Host,Port,chat,HostPassword,[]) of
        {error,_Why} -> 
            Parent ! {status,{cannot,connect,Host,Port}},
            sleep(2000),
            try_to_connect(Parent,Host,Port,HostPassword);
        {ok,MM} -> 
            lib_chan_mm:controller(MM,Parent),
            Parent ! {connected,MM},
            exit(connectorFinished)
    end.

sleep(T) -> receive after T -> true end.

wait_login_response(MM) -> 
    receive 
        {chan,MM,ack} -> active(MM);
        {'EXIT',_Pid, connectorFinished} -> wait_login_response(MM);
        Other -> 
            io:format("chat_client login unexpected: ~p\n",[Other]),
            wait_login_response(MM)
end.

active(MM) -> 
    receive
        {msg,Nickname,Str} -> 
            lib_chan_mm:send(MM,{reply,Nickname,Str}),
            active(MM);
        {chan,MM,{msg,From,Pid,Str}} -> 
            io:format("~p@~p: ~p~n",[From,Pid,Str]),
            active(MM);
        {close,MM} -> exit(serverDied);
        Other -> 
            io:format("chat_client active unexpected:~p~n",[Other]),
            active(MM)
end.
