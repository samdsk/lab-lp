-module(chat_group).
-export([start/2]).

start(C,Nickname) -> 
    process_flag(trap_exit, true),
    lib_chan_mm:controller(C,self()), lib_chan_mm:send(C,ack),
    self() ! {chan,C,{reply,Nickname,"I'm starting the group"}},
    group_controller([{C,Nickname}]).

delete(Pid,[{Pid,Nickname}| T],L) -> {Nickname, lists:reverse(T,L)};
delete(Pid, [H|T], L) -> delete(Pid,T, [H|L]);
delete(_,[],L) -> {"????",L}.

group_controller([]) -> exit(allGone);
group_controller(L) -> 
    receive 
        {chan,C,{reply,Nickname,Str}} -> 
            lists:foreach(fun({Pid,_})-> lib_chan_mm:send(Pid,{msg,Nickname,C,Str}) end, L),
            group_controller(L);
        {login,C,Nickname} ->
            lib_chan_mm:controller(C,self()), lib_chan_mm:send(C,ack),
            self() ! {chan,C,{relay,Nickname,"I'm joining the group"}},
            group_controller([{C,Nickname}|L]);
        {chan_closed, C} ->
            {Nickname,L1} = delete(C,L,[]),
            self() ! {chan,C,{relay,Nickname,"I'm leaving the group"}},
            group_controller(L1);
        Any -> io:format("Group controller received Msg=~p~n",[Any]),
        group_controller(L)
end.