let is_palindrome str =   
  let lowered = String.lowercase_ascii str in
  let char_list = List.init (String.length lowered) (fun x -> String.get lowered x) in
  let escape = [' ';'.';',';'"';'?';'!';'(';')';':';';'] in
  let str_a = List.filter (fun x -> not (List.mem x escape)) char_list in
  List.equal (fun x y -> x=y) str_a (List.rev str_a)

let to_string str = 
  let rec concat output = function
    | [] -> output
    | h::t -> concat (output^(String.make 1 h)) t
  in concat "" str

let sub str diff = 
  let char_list = List.init (String.length diff) (fun x -> String.get diff x) in
  let str_list = List.init (String.length str) (fun x -> String.get str x) in
  to_string (List.filter (fun x -> not (List.mem x char_list)) str_list)

let rec anagram str = function
  | [] -> false
  | h::t -> if (sub str h) = (sub h str) then true else anagram str t
