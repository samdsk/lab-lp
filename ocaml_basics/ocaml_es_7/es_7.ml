(**ERROR!!! not working *)
module P = struct
  type expr = string Stack.t

  let empty_expr = fun () -> Stack.create()
  let order op1 op2 = match op1 with
    | "*" -> (match op2 with
      | "+" | "-" | "/" | "(" -> op1 
      | _ -> op2)
    | "/" -> (match op2 with
      | "+" | "-" | "(" -> op1
      | _ -> op2)
    | "+" -> (match op2 with
      | "-" | "(" -> op1
      | _ -> op2)
    | "-" -> (match op2 with
      | "(" -> op1
      | _ -> op2)
    | _ -> op1
  
  let rec output s temp = 
    let top = Stack.pop temp in 
      if Stack.is_empty temp then 
        Stack.push top s
      else begin Stack.push top s; output s temp end
 
  let rec push_in_order op1 s op =
    let op2 = order op1 (Stack.top op ) in
    if op1 = op2 then (Stack.push op1 op) 
    else  
      begin
      (Stack.push (Stack.pop op) s);
      push_in_order op1 s op         
      end
 
  let rec close_parenthesis s temp = 
    let op = Stack.top temp in 
      match op with
      | "(" -> ignore (Stack.pop temp)
      | _ -> Stack.push (Stack.pop temp) s; close_parenthesis s temp

  let rec unify_stacks s temp =     
      if (Stack.is_empty temp) then s
      else begin (Stack.push (Stack.pop temp) s); (unify_stacks s temp) end  
  
  let reverse s = 
    let rec reverse s output = 
      if Stack.is_empty s then output
      else begin (Stack.push (Stack.pop s) output); reverse s output end
    in reverse s (empty_expr ())


    (**
(match h with
            | "-" | "*" | "/" | "+" | "(" ->  
              print_string (h^ " ");           
              if(Stack.is_empty op) then 
                begin Stack.push h op; (create_expr s op t) end
              else  
              begin 
                push_in_order h s op;
                (create_expr s op t)
              end
            | ")" -> close_parenthesis s op;create_expr s op t
            | _ -> Stack.push h s; create_expr s op t) 


            let matching c = match c with
            | "-" | "*" | "/" | "+" | "(" ->  
              print_string (c^ " "); Stack.push c op; create_expr s op t
            | ")" -> print_string (c^ " "); create_expr s op t
            | _ -> print_string (c^ " "); Stack.push c s; create_expr s op t
         in matching h

            
*)
  
  let expr_of_string s = 
    let s_list = (String.split_on_char ' ' s) in
      let output = 
        let rec create_expr s op = function
          | [] -> s,op    
          | h::t -> (match h with
          | "-" | "*" | "/" | "+" | "(" ->                     
            if(Stack.is_empty op) then 
              begin Stack.push h op; (create_expr s op t) end
            else  
            begin 
              push_in_order h s op;
              (create_expr s op t)
            end
          | ")" -> close_parenthesis s op;create_expr s op t
          | _ -> Stack.push h s; create_expr s op t) 

        in create_expr (empty_expr ()) (empty_expr ()) s_list
      in reverse(unify_stacks (fst output) (snd output))

  let rec print_expr e =    
    if (Stack.is_empty e) then print_newline ()
    else begin print_string((Stack.pop e)^" ") ; (print_expr e) end

(*
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
                | _ -> 0 temp
                
            end
      end
    in eval 0 e

*)

end

let () = print_string("Prova\n")

let s = Stack.create()
let () = Stack.push "1" s
let () = Stack.push "2" s
let () = Stack.push "3" s
let () = Stack.push "4" s
let () = Stack.push "5" s


let () = P.print_expr (P.reverse s)
let () = P.print_expr (P.expr_of_string ("3 + 4 * 5"))