let word_list = ref []

let read word_list = 
  let reader = open_in "prova.txt" in  
  let count = ref 0 in
    try  
      while true do
        let line = input_line reader in
          count := (!count)+1;
          word_list := ((!count,line) :: !word_list)
      done
    with 
    End_of_file -> print_string ("Reading finished...\n")


(*Removes excess spaces charactor from the line
  Takes a list of strings (returned from String.split_on_char ' ')
  Return a list of strings without "" strings
*)
let rec remove_excess_space = function
  | [] -> []
  | h::t -> if h="" then remove_excess_space t else h::(remove_excess_space t)

(*Trims and removes excess spaces charators*)
let trimmed lines = 
  let rec trim output = function
    | [] -> output
    | (n,h)::t -> 
      let s = remove_excess_space(String.split_on_char ' ' (String.trim h)) in 
      trim ((n,s,s)::output) t 
  in trim [] lines

(*If words is equal to the, and or of it's a 2 char length string return true otherwise false*)
let word_to_escape word = 
  let lower = String.lowercase_ascii(word) 
  in if lower = "the" || lower = "and" || String.length lower < 3 then true else false

(* returns how many words those are not equal to word_to_escape*)
let how_many_major_words line = 
  let rec how_many count = function
    | [] -> count
    | h::t -> if (word_to_escape h) then how_many (count) t else how_many (count+1) t 
in how_many 0 line

(*Increase initial list duplicating lines according to how_many_major_words*)
let make_duplicates lines = 
  let rec duplicate output = function
    | [] -> lines@output
    | (_,s,_) as h::t ->
        let rec append h count output = 
          if count < 2 then output 
          else 
            begin
            if count = 2 then h::output else append h (count-1) (h::output)
            end
        in duplicate (append h (how_many_major_words s) output) t
in duplicate [] lines  

let compare = fun x y -> if String.lowercase_ascii(fst(x))>=String.lowercase_ascii(fst(y)) then 1 else -1

let sorted l = 
  let rec sorted l output = match l with 
    | [] -> List.rev output
    | (n,words,s) ::t -> sorted l ((n,(List.sort String.compare words),s)::output )
  in sorted l []

(*Builds a new list with smallest word in the line*)
let build_list lines min_words = 
  let rec build output = function
    | [] -> output
    | (_,words,_) as h::t ->
      let rec filtered = function
        | [] -> ""
        | word::t_words -> if (word_to_escape word) || (List.exists (fun x -> x=word) min_words) then filtered t_words else word      
    in build ((filtered words,h)::output) t
  in build [] lines

(*Finds position of the smallest word in the lines*)
let find_offset words min = 
  let rec build offset = function
    | [] -> offset
    | h::t -> if h=min then offset else build (offset+(String.length h)+1) t
in build 0 words

let sort_lines_for_print lines = List.sort compare lines

let rec equals l1 l2 = match l1,l2 with
  | [],[] -> true
  | [],_ | _,[] -> false
  | h1::t1, h2::t2 -> if h1=h2 then equals t1 t2 else false  

let rec remove_line line = function
  | [] -> []
  | ((n,_,s)) as h::t ->
    match line with
      (_,(nl,_,sl)) -> 
       if (nl=n) && equals sl s then t else h::(remove_line line t)

let print lines = 
  let rec print min_words lines = match lines with
    | [] -> print_newline()
    | _ -> 
      let line = List.hd (sort_lines_for_print (build_list lines min_words))
      in match line with
      | min,(n,words,s) -> 
        let offset = 37 - (find_offset s min) in 
        let toString = (String.concat " " s) in 
        print_string ((string_of_int n)^(String.make offset ' ')^toString^"\n");
        print (min::min_words) (remove_line line lines) 
  in print [""] lines


let () = read word_list;;
let lines = trimmed !word_list

let lines = make_duplicates lines

let () = print lines

(*let lines = build_sorted_and_filtered_list lines ["Big";"Falcon"]*)

