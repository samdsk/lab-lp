open Str
let file = "text.txt"

let rec print_list = function
  | [] -> print_string "\n"
  | (k,v)::t -> print_string(k^":"^(string_of_int v)^" "); print_list t

let rec remove s = function
  | [] -> []
  | (k,v) as h::t -> if k=s then t else h::(remove s t)

let rec increment s l = match l with
  | [] -> (s,1)::l
  | ((k,v) as h ::t)-> if k=s then (remove s l)@[(k,(v+1))] else h::increment s t

let rec insert m l = match l with
  | [] -> m
  | h::t -> (insert (increment h m) t)

let reader line word_list = 
  let lowered = (String.lowercase_ascii (line)) in
    let rg = Str.regexp "[ )(*,?\\.!_]+" in 
      let cleaned = Str.split rg lowered in 
        insert word_list cleaned 

let filename = "prova.txt"


let () =  
  let  file = open_in filename in
    let word_list = ref [] in
      try
        while true do
          let line = input_line file in
            word_list := reader line !word_list
        done
      with
        End_of_file -> print_list !word_list