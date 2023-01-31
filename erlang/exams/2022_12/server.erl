-module(server).
%-compile(export_all).
-export([start/0]).

start() ->
    group_leader(whereis(user), self()),
    register(server,self()),
    io:format("Server ready\n"),
    listen([],[],1).


listen(L1,L2,Len) ->
    receive        
        {mm1,{reverse,Msg,Size}} when Size == Len -> 
            L = [Msg|L1],io:format("Finaly capture Len:~p ",[Len]),
            io:format("mm1 "),
            case Len rem 2 of
                0 -> print(lists:reverse(collect_mm2(L2,Len))++L);
                _ -> print(lists:reverse(tl(collect_mm2(L2,Len)))++L)
            end,         
            listen([],[],1);
        
        {mm1,{reverse,Msg,_Size}} -> 
            L = [Msg|L1],io:format("Len:~p ",[Len]),
            print(mm1,L),
            listen(L,collect_mm2(L2,Len),Len+1);
        
        {stop} -> unregister(server),exit(normal)   
end.

collect_mm2(L,Len) ->
    receive
        {mm2,{reverse,Msg,_Size}} -> L2 = [Msg|L],io:format("Len:~p ",[Len]),print(mm2,L2),L2
end.

print(MM,List) ->     
    io:format("~p - List: ~s\n",[MM,lists:reverse(to_string(List))]).

print(List) ->    
    io:format("List: ~p\n",[lists:reverse(to_string(List))]).

to_string(L) ->
    {_,LL} = lists:mapfoldl(fun ({X,_},Acc) -> {X,[X|Acc]} end, [], L), LL.
