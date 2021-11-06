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
    | (n,h)::t -> trim ((n,remove_excess_space(String.split_on_char ' ' (String.trim h)))::output) t 
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
    | (_,s) as h::t ->
        let rec append h count output = 
          if count < 2 then output 
          else 
            begin
            if count = 2 then h::output else append h (count-1) (h::output)
            end
        in duplicate (append h (how_many_major_words s) output) t
in duplicate [] lines  

let compare = fun x y -> if String.lowercase_ascii x>= String.lowercase_ascii y then 1 else -1

(*Builds a new list with smallest word in the line*)
let build_sorted_and_filtered_list lines min_words = 
  let rec build output = function
    | [] -> output
    | (_,s) as h::t ->        
        let sorted = (List.sort compare s) in 
        let filtered = List.filter_map 
        (fun x -> 
          if (List.exists 
            (fun y -> x=y) min_words) || (word_to_escape x) 
          then None 
          else Some(x)) sorted 
    in build (((List.hd filtered),h)::output) t
  in build [] lines

(*Finds position of the smallest word in the lines*)
let find_offset words min = 
  let rec build offset = function
    | [] -> offset
    | h::t -> if h=min then offset else build (offset+(String.length h)+1) t
in build 0 words

let compare_mylist = fun x y -> if String.lowercase_ascii(fst(x))>=String.lowercase_ascii(fst(y)) then 1 else -1

let sort_lines_for_print lines = List.sort compare_mylist lines

let rec equals l1 l2 = match l1,l2 with
  | [],[] -> true
  | [],_ | _,[] -> false
  | h1::t1, h2::t2 -> if h1=h2 then equals t1 t2 else false  

let rec remove_line line = function
  | [] -> []
  | (n,words) as h::t ->
    match line with
      (_,(nl,wordsl)) -> 
       if (nl=n) && equals wordsl words then t else h::(remove_line line t)

let print lines = 
  let rec print min_words lines = match lines with
    | [] -> print_newline()
    | _ -> 
      let line = List.hd (sort_lines_for_print (build_sorted_and_filtered_list lines min_words))
      in match line with
      | min,(n,words) -> 
        let offset = 37 - (find_offset words min) in 
        let toString = (String.concat " " words) in 
        print_string ((string_of_int n)^(String.make offset ' ')^toString^"\n");
        print (min::min_words) (remove_line line lines) 
  in print [""] lines


let () = read word_list;;
let lines = trimmed !word_list


let lines = make_duplicates lines

let () = print lines

(*let lines = build_sorted_and_filtered_list lines ["Big";"Falcon"]*)

