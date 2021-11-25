-module(pn_test).
-export([parser/1]).

parser(String) -> list_to_tuple(parser(String,[])).

parser([H|T],Stack,Exp) -> 
    case H of
        $( -> Exp ++ parser(T,[H|Stack],[]);    
        $) -> {Output,S1} = work_on_stack(Stack,[]), parser(T,S1,[Output|Exp]);
        $+ -> E1 = reorder(Exp,H),
                case E1 of
                    true -> E2 = [pulse | Exp], parser()
                    false -> 
        _ -> 
            case lists:member(H, [$+,$-,$*,$/]) of 
                true -> parser(T,[H|Stack],Exp);
                false -> parser(T, Stack, [{num, H} | Exp])
            end
   end;
parser([],_) -> [].

work_on_stack([H|T],Output) -> 
   work_on_stack(T,[{num, H} | Output]);
work_on_stack([H|T],Output) when H =:= $( -> {Output,T}.

work_on_stack([H|T],Output) -> 
   work_on_stack(T,[{num, H} | Output]);
work_on_stack([H|T],Output) when H =:= $( -> {Output,T}.