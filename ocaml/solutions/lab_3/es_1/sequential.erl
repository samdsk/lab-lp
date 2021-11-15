-module(sequential).
-export([is_palindrome/1, is_an_anagram/2, factors/1, is_perfect/1]).

is_palindrome(S) ->
  L = string:casefold(
    lists:filter(fun(X) -> not lists:member(X,[$.,$,,$;,$?,32]) end, S)
  ), string:equal(lists:reverse(L),L).
  
is_an_anagram(_, []) -> false;
is_an_anagram(S, [HD|TL]) -> 
   is_an_anagram(lists:sort(S), lists:sort(HD), TL).

is_an_anagram(A, A, _)  -> true;
is_an_anagram(_, _, []) -> false;
is_an_anagram(A, _, [HD|TL]) -> 
   is_an_anagram(A, lists:sort(HD), TL).

factors(N) -> factors(N, [], thunks:primes()).
factors(N, R, _) when N =< 1 -> lists:reverse(R); 
factors(N, R, [N|_]) -> lists:reverse([N|R]); 
factors(N, R, [HD|_]=P) when N rem HD == 0 -> factors(N div HD, [HD|R], P);
factors(N, R, [_|TL]) -> factors(N, R, TL()).

is_perfect(N) -> lists:foldr(fun (X, Y) -> X+Y end, 0, divisors(N, [], thunks:from(1))) == N.
divisors(N, R, [N|_]) -> lists:reverse(R);
divisors(N, R, [HD|TL]) when N rem HD == 0 -> divisors(N, [HD|R], TL());
divisors(N, R, [_|TL]) -> divisors(N, R, TL()).
