-module(es1).
-export([is_palindrom/0,is_an_anagram/0,factors/1,is_proper/1]).


is_palindrom() -> lists:map(fun (X) -> is_palindrom(X) end, ["Do geese see God?","Rise to vote, sir.","hello world!"]).
is_palindrom(Str) ->
    Lowered = string:lowercase(Str),
    Filtered = lists:filter(fun (X) -> not lists:member(X, [$.,$,,$!,$?,32]) end, Lowered),
    Filtered == lists:reverse(Filtered).

is_an_anagram() -> is_an_anagram(string:lowercase("cIao"),["asd","fdgshjbd","cai"]).

is_an_anagram(_,[]) -> false;
is_an_anagram(Str,[H|T]) ->
    case lists:sort(Str) == lists:sort(H) of
        true -> true;
        false -> is_an_anagram(Str,T)
    end.

factors(N) ->
    case N of
        0 -> [];
        N -> [X || X<-lists:seq(2, N div 2), 
        length([Y||Y <- lists:seq(2, trunc(math:sqrt(X))), (X rem Y) == 0])==0, 
        (N rem X) == 0]
end.

is_proper(N) ->
    case N of
        N when N =< 0 -> false;
        N -> lists:foldl(fun (X,Acc) -> X+Acc end, 0, [X || X <- lists:seq(1, N div 2), (N rem X) == 0]) == N
end.