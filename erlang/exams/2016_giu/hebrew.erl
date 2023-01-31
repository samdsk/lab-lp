-module(hebrew).
-export([build/4]).

build(Tot,Tot,Step,Head) ->
    listen(Tot,Tot,Step,Head);
build(N,Tot,Step,Head) ->
    Next = spawn_link(fun ()-> build(N+1,Tot,Step,Head) end),
    listen(N,Tot,Step,Next).

listen(N,1,_,_) -> server ! {last,N},exit(normal);
listen(N,_,Step,Next) ->
    %io:format("~p -> ~p\n",[self(),Next]),
    receive
        {new_next,NewNext,NewTot} -> listen(N,NewTot,Step,NewNext);
        {K,Prev,NewTot} when K == Step -> 
            %io:format("Killing ~p\n",[N]),
            Prev ! {new_next, Next, NewTot-1}, Next ! {1,Prev,NewTot-1},exit(normal);
        {K,_,NewTot} -> Next ! {K+1,self(),NewTot},listen(N,NewTot,Step,Next);        
        Any -> io:format("N:~p received: ~p\n",[N,Any])
end.