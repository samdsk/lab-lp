(*Palindome sentence check skip .,'?| *)
let is_palindrome s =
  let s_list = List.init (String.length s) (fun x -> String.get (String.lowercase_ascii s) x) in 
    let s_list_rev = (List.rev s_list) in 
      let rec is_palindrome ~output s = function 
        | [] -> output
        | (h::t)as  l -> match h with 
          | '.' | ',' | '\'' | '?' | '!' | ' ' -> 
            (match s with 
            |[] -> false
            | h_s::t_s -> match h_s with 
              | '.' | ',' | '\'' | '?' | '!' | ' ' -> is_palindrome ~output t_s t
              | _ -> is_palindrome ~output s t)
            
          | _ -> (match s with 
            |[] -> false
            | h_s::t_s -> match h_s with 
              | '.' | ',' | '\'' | '?' | '!' | ' ' -> is_palindrome ~output t_s l
              | _ -> if (h == (h_s)) 
                then begin  is_palindrome ~output (List.tl s) t end
                else begin Printf.printf "%c : %c \n" h_s h; false end) 
        in is_palindrome true s_list s_list_rev

let rec remove c = function
  | [] -> []
  | h::t -> if (h==c) then remove c t else h::(remove c t)
let rec remove_list s = function
  | [] -> s
  | h::t -> remove_list (remove h s) t

let ( - ) s1 s2 = 
  let sl1 = List.init (String.length s1) (fun x -> (String.get s1 x)) in 
    let sl2 = List.init (String.length s2) (fun x -> (String.get s2 x)) in
      let removed = remove_list sl1 sl2 in String.concat "" (List.map (fun x -> String.make 1 x) removed)

let anagram s1 s_list = 
  let rec anagram s = function
    | [] -> false
    | h::t -> if((s-h) == (h-s)) then true else (anagram s t) 
  in anagram s1 s_list