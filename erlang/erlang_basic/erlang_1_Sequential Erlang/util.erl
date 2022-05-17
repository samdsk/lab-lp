-module(util).
-export([is_palindrome/1,is_anagram/2,factors/1,is_proper/1]).

is_palindrome(L) -> 
    Lowered = string:lowercase(L),
    Reverse_string = lists:reverse(Lowered),
    is_palindrome(Lowered,Reverse_string).

is_palindrome([H1|T1]=L1,[H2|T2]=L2) -> 
    case is_member(H1) of 
        true -> is_palindrome(T1,L2);
        false -> 
            case is_member(H2) of 
                true -> is_palindrome(L1,T2);
                false -> if H1 == H2 -> is_palindrome(T1,T2);
                            H1 /= H2 -> false
                        end
            end
    end;

is_palindrome([],[]) -> true;
is_palindrome(_,[]) -> true.
is_member(H) -> lists:member(H, [$.,$,,$?,32]).

is_anagram(S, [H|T]) ->     
    case S--H of 
        [] -> true;
        _ -> is_anagram(S, T)
    end;
is_anagram(_,[]) -> false.

factors(N) -> factors(N,2,[]).


factors(N,D,Output) when N > 1 ->
    M = N rem D,
    Y = N div D,
    case M of
        0 -> factors(Y,2,[D|Output]);
        _ -> factors(N,next_prime(D),Output)
    end;
factors(_,_,Output) -> Output.

next_prime(D) ->
    M = D+1,
    case next(M,2) of
        true -> M;
        false -> next_prime(M)
    end.
next(M,M) -> true;
next(M,N) ->
    case M rem N of
        0 -> false;
        _ -> inext(M,N+1)
end.

is_proper(N) ->  
    L = [X|| X <- lists:seq(1,N div 2), N rem X == 0],
    Sum = lists:foldl((fun(X,Acc) -> X+Acc end), 0, L),
    is_proper(Sum,N).

is_proper(M,M) -> true;
is_proper(M,N) -> false.


