-module(pn).
-export([parser/1,eval/1]).


eval(Exp) ->     
    {Op,Num} = make_stack(Exp,[],[]),
    io:format("~p ~p ~n",[Op,Num]),
    eval(Op,Num).

eval([],[H]) -> H;
eval([Op|T1],[N1,N2|T2]) ->
    io:format("~p ~p ~p ~n",[Op,N1,N2]),
    case Op of
        minus -> eval(T1,[(N1-N2)|T2]);
        plus -> eval(T1,[(N1+N2)|T2]);
        division ->eval(T1,[(N1/N2)|T2]);
        multi -> eval(T1,[(N1*N2)|T2])
    end.
        

make_stack([],Op,Num) -> {lists:reverse(Op),lists:reverse(Num)};
make_stack([H|T],Op,Num) ->
    case is_list(H) of
        false -> case is_op(H) of
                    true -> make_stack(T,[H|Op],Num);
                    false -> {num, N} = H, make_stack(T,Op,[N|Num])
                end;
        true -> {O,N} = make_stack(H,[],[]), make_stack(T, lists:reverse(Op++O),Num++lists:reverse(N))
    end.

is_op(minus) -> true;
is_op(plus) -> true;
is_op(multi) -> true;
is_op(division) -> true;
is_op(pow) -> true;
is_op(_) -> false.

parser(String) -> parser(String,[],[]).

parser([],_,[H]) -> H;
parser([H|T],Stack,Exp) ->
    case H of
        $( -> parser(T,[H|Stack], []);
        $) -> {S1,E1} = use_stack(Stack,Exp), parser(T, S1, [E1]);
        _ -> case lists:member(H, [$+,$-,$*,$/,$^]) of
            true ->
                case is_less(Stack,H) of
                    true -> parser(T,Stack,[which_op(H) | Exp]);
                    false -> parser(T,reorder(Stack,H),Exp)
                end;
            false ->  parser(T,Stack,Exp++[{num, list_to_integer([H])}])
            end
    end.

use_stack([],Exp) ->{[],Exp};
use_stack([H|T], Exp) ->
    case H of 
        $( -> {T,Exp};
        _ -> use_stack(T,[which_op(H) | Exp])
end.

reorder([H|T],Op) -> 
    case is_less([H],Op) of
        true -> [H|reorder(T, Op)];
        false -> [Op|T]
    end.

which_op(Op) ->
    case Op of
        $+ -> plus;
        $- -> minus;
        $/ -> division;
        $* -> multi;
        $^ -> pow
    end.
is_less([],_) -> true;
is_less([H|_], Op) ->
    case Op of        
        $+ -> case H of
            $^ -> true; 
            $/ -> true;
            $* -> true;
            _ -> false
            end;
        $- -> case H of
            $^ -> true; 
            $/ -> true;
            $* -> true;
            $+ -> true;
            _ -> false
            end;
        $/ -> case H of
            $^ -> true;            
            $* -> true;
            _ -> false
            end;
        $* -> case H of
            $^ -> true;            
            _ -> false
            end;
        _ -> false
end.


