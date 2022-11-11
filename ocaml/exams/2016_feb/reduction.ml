module ArithExpr = struct
  type expr = 
    | Value of float
    | Add of expr*expr 
    | Sub of expr*expr
    | Mul of expr*expr
    | Div of expr*expr

  (**Parse the given string into the expr data structure *)
  let parse str =
    let char_list = List.init (String.length str) (fun x -> String.get str x)
  in let stack = Stack.create () in 
    let to_expr = function
      | '+' -> Stack.push(Add(Stack.pop stack, Stack.pop stack)) stack
      | '-' -> Stack.push(Sub(Stack.pop stack, Stack.pop stack)) stack
      | '*' -> Stack.push(Mul(Stack.pop stack, Stack.pop stack)) stack
      | '/' -> Stack.push(Div(Stack.pop stack, Stack.pop stack)) stack
      | n -> Stack.push(Value(float_of_string (String.make 1 n))) stack
  in List.iter to_expr (List.rev char_list);
    if Stack.length stack <> 1 then failwith "Error: Invalid Expression" else Stack.pop stack

  (**Evaluate the last expr operation on each branch*)
  let rec reduce = function
    | Add(x,y) -> begin match x,y with
      | Value(a),Value(b) -> Value(a+.b)
      | Value(_) as c, t | t,(Value(_) as c) -> Add(reduce t,c)
      | t, s -> Add(reduce t,reduce s) end

    | Sub(x,y) -> begin match x,y with
      | Value(a),Value(b) -> Value(-.a+.b)
      | Value(_) as c , t | t,(Value(_) as c) -> Sub(reduce t,c)
      | t, s  -> Sub(reduce s,reduce t) end

    | Mul(x,y) -> begin match x,y with
      | Value(a),Value(b) -> Value(a*.b)
      | Value(_) as c ,t | t,(Value(_) as c) -> Mul(reduce t,c)
      | t, s  -> Mul(reduce t,reduce s) end

    | Div(x,y) -> begin match x,y with
      | Value(a),Value(b) -> Value(b/.a)
      | Value(_) as c , t | t, (Value(_) as c) -> Div(reduce t,c)
      | t, s  -> Div(reduce t,reduce s) end

    | c -> c ;;

  (**Prints the given polish notation to stdio evaluating it one expression at a time*)
  let print_evaluation str =
    let exp = parse str in 
    let rec print_line = function 
      | Add(x,y) -> ("( "^print_line y^" +. "^print_line x^" )")
      | Sub(x,y) -> ("( "^print_line y^" -. "^print_line x^" )")
      | Mul(x,y) -> ("( "^print_line y^" *. "^print_line x^" )")
      | Div(x,y) -> ("( "^print_line y^" /. "^print_line x^" )")
      | Value(n) -> string_of_float n
    in let rec print = function
    | Value(x) -> print_endline (string_of_float x)
    | t -> print_endline (print_line t); print (reduce t) 
  in print exp

  
end
