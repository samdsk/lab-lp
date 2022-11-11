#load "str.cma";;
open Stack

module PolishCalculator = struct
  type expr = Add of expr*expr | Mul of expr*expr | Sub of expr*expr| Div of expr*expr | Pow of expr*expr | Val of int
  exception InvalidPolishNotation
  
  let str_to_expr str =
    let stack = Stack.create() in 
      let build = function
        | "**" -> Stack.push (Pow(Stack.pop stack, Stack.pop stack)) stack
        | "*"  -> Stack.push (Mul(Stack.pop stack, Stack.pop stack)) stack
        | "/"  -> Stack.push (Div(Stack.pop stack, Stack.pop stack)) stack
        | "+"  -> Stack.push (Add(Stack.pop stack, Stack.pop stack)) stack
        | "-"  -> Stack.push (Sub(Stack.pop stack, Stack.pop stack)) stack
        | n -> try Stack.push (Val(int_of_string n)) stack with Failure(_) -> raise InvalidPolishNotation
      in let l = Str.split (Str.regexp " +") str
          in if (List.length l) < 3 
            then raise InvalidPolishNotation 
            else begin List.iter build l; Stack.pop stack end;;

  let rec eval = function   
    | Add(x,y) -> eval x + eval y
    | Mul(x,y) -> eval x * eval y
    | Sub(x,y) -> eval x - eval y
    | Pow(x,y) -> int_of_float(float_of_int(eval x) ** float_of_int(eval y))
    | Val(x) -> x


end;;