-module(mm).
%-compile(export_all).
-export([start/1]).

unregister() ->
    try unregister(mm)
            
    catch
        _:_-> io:format("Error unregister\n")
            
    end.
start(MM) ->    
    group_leader(whereis(user), self()),
    register(mm,self()),
    io:format("~p ready!\n",[MM]),
    listen(MM).

listen(MM) ->
    receive
        {cmd,spawn_server} -> Node = client:to_node("server"),spawn(Node,server,start,[]), listen(MM);       
        {stop} when MM == mm1 -> {server,client:to_node("server")} ! {stop},unregister(mm), exit(normal);
        {stop} -> unregister(mm),exit(normal);
        Any -> {server,client:to_node("server")} ! {MM,Any}, listen(MM)
end.