-module(thunks).
-export([from/1, first/1, is_prime/1, primes/0]).

%% Revenge of the thunks
from(K) -> [K|fun()->from(K+1)end].

%% Note you can't use lists:filter because is not based on thunks
filter(_,[]) -> [];
filter(Pred,[H|Tl]) ->
  case Pred(H) of
    true -> [H|fun() -> filter(Pred,Tl()) end];
    false -> filter(Pred,Tl())
  end.

sift(P,L) -> filter(fun(N) -> N rem P /= 0 end,L).
sieve([H|Tl]) -> [H|fun() -> sieve(sift(H,Tl())) end].

%% This generates the list of prime numbers.
primes() -> sieve(from(2)).

is_prime(N) -> is_prime(N, primes()).
is_prime(N, [N|_])           -> true;
is_prime(N, [M|TL]) when M<N -> is_prime(N, TL());
is_prime(_,_)                -> false.

first(N) -> first(N, primes()).
first(0, _) -> [];
first(N, [X|P]) -> [X|first(N-1, P())].
