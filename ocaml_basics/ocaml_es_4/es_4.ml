open Str
let file = "text.txt"

let rec print_list = function
  | [] -> print_string "\n"
  | (k,v)::t -> print_string(k^":"^(string_of_int v)^"\n"); print_list t

let rec remove s = function
  | [] -> []
  | (k,v) as h::t -> if k=s then t else h::(remove s t)

let rec increment s l = match l with
  | [] -> (s,1)::l
  | ((k,v) as h ::t)-> if k=s then (remove s l)@[(k,(v+1))] else h::increment s t

let rec insert m l = match l with
  | [] -> m
  | h::t -> (insert (increment h m) t)

let () = 
  let line = read_line in
    let lowered = (String.lowercase_ascii (line ())) in
      let rg = Str.regexp "[ ,?\\.!_]+" in 
        let cleaned = Str.split rg lowered in 
          let word_list = insert [] cleaned in print_list word_list
      
