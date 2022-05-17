(* INCOMPLETE*)
let exec a b = function
  | '*' -> a*.b
  | '+' -> a+.b
  | '-' -> a-.b
  | '/' -> a/.b
  | _ -> failwith "Invalid Operator\n"

let build exprs = 
  let rec build = function
    | [] -> print_newline 
    | h::t -> 
      let exploded = List.init (String.length h) (fun x -> String.get h x) in
      let rec eval s = function
        | [] -> print_newline
        | a::t -> match a with
          | '+' | '-' | '*' | '/' -> Stack.push a s; eval s t
          | _ -> let b = List.hd t in 
          match a with
          | '+' | '-' | '*' | '/' -> Stack.push b s; eval s t
          | _ -> let res  = exec (float_of_string (String.make 1 a)) (float_of_string (String.make 1 b)) (Stack.pop s) in
          Stack.push string_of_float res s; print_string (string_of_float res^" "); eval s (List.tl t)