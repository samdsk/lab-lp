module type StackADT =
sig
  type 'a t = 'a Stdlib.Stack.t

  exception Empty
  val create : unit -> 'a t
  val push : 'a -> 'a t -> unit
  val pop : 'a t -> 'a
  val top : 'a t -> 'a
  val is_empty : 'a t -> bool
  val length : 'a t -> int
  val iter : ('a -> unit) -> 'a t -> unit
end

module P (S : StackADT) = struct
  type expr = string S.t

  exception Error
  let empty_expr = fun () -> S.create()
  
  let order op1 op2 = match op1 with
    | "*" -> (match op2 with
      | "+" | "-" | "/" | "(" -> op1 
      | _ -> op2)
    | "/" -> (match op2 with
      | "+" | "-" | "(" -> op1
      | _ -> op2)
    | "+" | "-" -> (match op2 with
      | "(" -> op1
      | _ -> op2)
    | _ -> op1
  
  let rec reorder_op op1 s op =
      if (S.is_empty op) then S.push op1 op
      else let op2 = order op1 (S.top op ) in
      if op1 = op2 then (S.push op1 op) 
      else  
        begin
        (S.push (S.pop op) s);
        
        reorder_op op1 s op         
        end
 
  let rec close_parenthesis s temp = 
    let op = S.top temp in 
      match op with
      | "(" -> ignore (S.pop temp)
      | _ -> S.push (S.pop temp) s; close_parenthesis s temp

  let rec merge s temp =     
      if (S.is_empty temp) then s
      else begin (S.push (S.pop temp) s); (merge s temp) end  
  
  let reverse s = 
    let rec reverse s output = 
      if S.is_empty s then output
      else begin (S.push (S.pop s) output); reverse s output end
    in reverse s (empty_expr ())
  
  let expr_of_string s = 
    let s_list = (String.split_on_char ' ' s) in
      let output = 
        let rec create_expr s op = function
          | [] -> s,op    
          | h::t -> (match h with
          | "-" | "*" | "/" | "+" | "(" ->                     
            if(S.is_empty op) then 
              begin S.push h op; (create_expr s op t) end
            else  
            begin 
              reorder_op h s op;
              (create_expr s op t)
            end
          | ")" -> close_parenthesis s op;create_expr s op t
          | _ -> S.push h s; create_expr s op t) 

        in create_expr (empty_expr ()) (empty_expr ()) s_list
      in reverse(merge (fst output) (snd output))

  let rec print_expr e =    
    if (S.is_empty e) then print_newline ()
    else begin print_string((S.pop e)^" ") ; (print_expr e) end
 
  let exec n1 n2 = function
  | "*" -> (n1*n2)
  | "-" -> (n2-n1)
  | "/" -> (n1/n2)
  | "+" -> (n1+n2)
  | _ -> raise Error

  let eval e = 
    let rec eval e nums = 
      
      let n = S.pop e in
        match n with 
        | "*" | "-" | "/" | "+" -> 
          let n_1 = S.pop nums in 
            let n_2 = S.pop nums in
              let r = exec n_1 n_2 n in
                if (S.is_empty e) then r
                else begin
                S.push r nums; eval e nums
                end        
        | _ -> S.push (int_of_string n) nums; eval e nums
          
    in eval e (empty_expr())    
end

module M = P(Stack)
let s = M.expr_of_string ("25 - 4 * 4") (** ("4 * 5 + 6 - 7") ("3 - 4 * 4")*)
let v = M.eval s

let () = print_string ((string_of_int v)^"\n")
(*
let () = P.print_expr s
*)