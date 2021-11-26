-module(pn).
-export([parser/1]).

parser(String) -> io:format("~p~n",[parser(String,[],[])]).

parser([],_,Exp) -> Exp;
parser([H|T],Stack,Exp) ->
    case H of
        $( -> Exp ++ [list_to_tuple(parser(T,[H|Stack], []))];    

        $+ -> 
            case is_less(Stack,H) of
                true -> E1 = [plus | Exp], parser(T,Stack,E1);
                false -> S1 = reorder(Stack,H), parser(T,S1,Exp)
            end;
        $- -> 
            case is_less(Stack,H) of
                true -> E1 = [minus | Exp], parser(T,Stack,E1);
                false -> {E2,S1} = reorder(Stack,H), parser(T,[H|S1],[E2|Exp])
            end;
        $* -> 
            case is_less(Stack,H) of
                true -> E1 = [multi | Exp], parser(T,Stack,E1);
                false -> {E2,S1} = reorder(Stack,H), parser(T,[H|S1],[E2|Exp])
            end;
        $/ -> 
            case is_less(Stack,H) of
                true -> E1 = [division | Exp], parser(T,Stack,E1);
                false -> {E2,S1} = reorder(Stack,H), parser(T,[H|S1],[E2|Exp])
            end;
        $) -> {S1,E1} = use_stack(Stack,Exp), parser(T, S1, E1);
        _ -> parser(T,Stack,Exp++[{num, H}])
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


