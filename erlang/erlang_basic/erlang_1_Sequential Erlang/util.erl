-module(util).
-export([is_palindrome/1]).

is_palindrome(S) -> 
    Rev_list = lists:reverse(S),
    is_palindrome1(S,Rev_list).


is_palindrome1([H1|T1], [H2|T2]) when (H1 == H2) -> is_palindrome1(T1,T2);
is_palindrome1([H1|_], [H2|_]) when (H1 /= H2) -> false;
is_palindrome1([], []) -> true.

is_an_anagram(S,S_list) ->
    





.


p([]) -> [[]];
p(L) -> [[H|T] || H <- L, T <- p(L--[H])].