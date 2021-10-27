(**ERROR!!! not working *)
module P = struct
  type expr = ((string Stack.t) * (int Stack.t))

  let empty_expr = (Stack.create(),Stack.create())

  let expr_of_string s = 
    let s_list = (String.split_on_char ' ' s) in
      let rec create_expr s = function
        | [] -> s    
        | h::t -> match h with
          | "-" | "*" | "/" | "+" -> Stack.push h (fst s); create_expr s t
          | "(" | ")" -> create_expr s t
          | _ -> Stack.push (int_of_string h) (snd s); create_expr s t
      in create_expr empty_expr  s_list

  let eval e = 
    let rec eval output e =
      if (Stack.is_empty (fst e)) then output
      else if (Stack.is_empty (snd e)) then output
      else begin 
        let op = Stack.pop (fst e) in          
          let n1 = Stack.pop (snd e) in 
            if (Stack.is_empty (snd e)) then output
            else begin
              let n2 = Stack.pop (snd e) in 
                match op with 
                | "*" -> Stack.push (n1*n2) (snd e); eval (Stack.top (snd e)) e
                | "/" -> Stack.push (n1/n2) (snd e); eval (Stack.top (snd e)) e
                | "+" -> Stack.push (n1+n2) (snd e); eval (Stack.top (snd e)) e
                | "-" -> Stack.push (n1-n2) (snd e); eval (Stack.top (snd e)) e
                | _ -> 0
                
            end
      end
    in eval 0 e



end

let s = (P.expr_of_string "( 3 + 4 ) * 5") 

let n = P.eval s

let () = print_string ((string_of_int n) ^ "\n")