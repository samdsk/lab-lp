-module(combinator).
-export([start/2]).


start(N,M) ->
    process_flag(trap_exit,true),
    register(server,self()),
    Workers = [spawn_link(generator,start,[X,M,trunc(math:pow(M,N))]) || X <- lists:seq(1,N)],
    build(Workers).


% build([],L) ->
%     io:format("RESULT: ~p\n",[L]),unregister(server);
% build([H|T],L) ->
%     H ! {gen,[]},
%     receive
%         {res,List} -> build(T, List)
% end.

build(Workers) ->
    [H ! {gen,[]} || H <- Workers],
    print(collect(1,length(Workers),[])),
    unregister(server).


collect(P,M,Output) when P>M -> Output;
collect(Pos,PosMax,Output) ->
    receive
        {res,P,Res} when P == Pos ->
            io:format("Pos: ~p Res: ~p\n",[Pos,Res]),
            collect(Pos+1,PosMax,combine(Output,Res,[]))            
end.

combine([],[],Acc) -> lists:reverse(Acc);
combine([],Res,_) -> lists:map(fun (H) -> [H] end,Res);
combine([O|Output],[R|Res],Acc) ->
    combine(Output,Res,[[R]++O|Acc]).

% collect(Acc,Len) when length(Acc) == Len -> 
%     unregister(server),
%     {_,L}=lists:unzip(lists:sort(fun ({X,_},
%     {Y,_})-> X<Y end,Acc)),lists:reverse(L);
% collect(Acc,Len) -> 
%     receive
%         {res,Pos,Res} -> 
%         %io:format("List received from ~p - ~p\n",[Pos,Res]),
%         collect([{Pos,Res}|Acc],Len)
% end.

% combine([[]|_],Acc) -> lists:reverse(Acc);
% combine(L,Acc) ->
%     %io:format("combine: ~p\n",[lists:map(fun ([_|T]) -> T end, L)]),
%     combine(lists:map(fun ([_|T]) -> T end, L),[lists:map(fun ([H|_]) -> H end, L)| Acc]).

print([]) -> true;    
print([H|T]) ->
    print_1(H),
    print(T).

print_1([H]) -> io:format("~p\n",[H]);
print_1([H|T]) ->
    io:format("~p,",[H]),
    print_1(T).