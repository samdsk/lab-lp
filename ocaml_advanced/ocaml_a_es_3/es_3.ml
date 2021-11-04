let word_list = ref []

let () = 
  let reader = open_in "prova.txt" in  
  let count = 0 in
    try  
      while true do
        let line = input_line reader in
          word_list := (((count+1),line) :: !word_list)
      done
    with 
    End_of_file -> print_string ("Reading finished...\n")

let rec remove_excess_space = function
  | [] -> []
  | h::t -> if h="" then remove_excess_space t else h::(remove_excess_space t)


let trimmed lines = 
  let rec trim output = function
    | [] -> output
    | (n,h)::t -> trim ((n,remove_excess_space(String.split_on_char ' ' (String.trim h)))::output) t 
  in trim [] lines

let word_escape word = 
  let lower = String.lowercase_ascii(word) 
  in if lower = "the" || lower = "and" || String.length lower < 3 then true else false
  
let how_many_major_words line = 
  let rec how_many count = function
    | [] -> count
    | h::t -> if not (word_escape h) then how_many (count+1) t else how_many count t 
in how_many 0 line

let make_duplicates lines = 
  let rec duplicate output lines = match lines with
    | [] -> lines@output
    | (_,s) as h::t ->
        let rec append h count output = 
          if count = 1 then h::output else append h (count-1) (h::output)
        in duplicate (append h (how_many_major_words s) []) t
in duplicate [] lines  

let compare = fun x y -> if x>=y then 1 else -1

let find_min_word_foreach_line lines = 
  let rec build output = function
    | [] -> output
    | (_,s) as h::t ->  
      let rec skip_escape_word w = 
        let sorted = (List.sort compare w) 
        in if word_escape (List.hd sorted) then skip_escape_word (List.tl sorted) else (List.hd sorted)
      in build (((skip_escape_word s),h)::output) t
  in build [] lines

let find_offset words min = 
  let rec build offset = function
    | [] -> offset
    | h::t -> if h=min then offset else build (offset+(String.length h)+1) t
in build 0 words


let sort_lines_for_print lines = 
  List.sort (fun x y -> match x with | )

let print lines = 
  let rec print last_min lines = match lines with
    | [] -> print_newline()
    | (min,(n,words))::t -> 