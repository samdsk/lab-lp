#load "str.cma";;
let sentences = ["Casablanca";"The Maltese Falcon";"The Big Big Sleep"]

(* kwic rappresents tuple of n:int, sorted_words:string list, words_list:string list 
  n = line number
  sorted_words = a sorted list of words_list obtained excluding words like "the","and" and with length < 3
  words_list = a list of string   
*)
type kwic = KWIC of int*(string list)*(string list)

(*given an string return a list of trimmed words*)
let trim_words str = 
  let reg = Str.regexp " +" in Str.split reg str

(*filter strings equal to "the","and" and of length < 3 *)
let filter list = List.filter 
  (fun x -> let lowered = String.lowercase_ascii x in
    if (List.mem lowered ["the"; "and"] || String.length lowered < 3) 
    then false 
    else true) list

(*given a list of strings returns kwic list*)
let build_structure list = 
  let rec build acc num = function
    | [] -> acc
    | h::t -> 
      let words = trim_words(String.trim h) 
        in let sorted = List.sort String.compare (filter words)
          in build (KWIC(num,sorted,words):: acc) (num+1) t
in build [] 1 list



(*sorts a list of kwic data type in ascending order*)
let sort_kwic list = 
  List.sort 
    (fun (KWIC(_,sorted_a,_)) (KWIC(_,sorted_b,_)) ->
      String.compare (List.hd sorted_a) (List.hd sorted_b)) list

(*removes the kwic elements which have an empty sorted_words list*)
let rec update_kwic_list = function
  | [] -> []
  | KWIC(_,[],_)::t -> t
  | KWIC(_,s::st,_) as h ::t -> h::update_kwic_list t

(*
  
  prints : (number right justified by 5 positions) + (34-offset of spaces) + (string)

*)
let print data = 
let rec print used_words = function
  | [] -> ()
  | KWIC(n,([]),words)::t -> print used_words t
  | KWIC(n,(s::st as sorted),words)::t -> 
      let find_offset word index words = 
        let rec find_offset word index acc = function
          | [] -> 0
          | h::t -> 
            if h == word && index < 2 
            then acc + 1 
            else find_offset word (index-1) (acc+String.length h+1) t
        in find_offset word index 0 words
      in let count word words = 
          let rec count word acc = function
            | [] -> acc
            | h::t -> if h==word then (count word (acc+1) t) else (count word acc t)
          in count word 0 words
      in let offset words used_words = function
        | [] -> 0
        | h::t -> find_offset h (count h used_words) words
      in  let offset = offset words used_words sorted
    in Printf.printf "%5d%s%s\n" n (String.make (37-offset) ' ') (String.concat " " words);
    print (s::used_words) (sort_kwic( match st with [] -> t | _ -> KWIC(n,st,words)::t))    
  in print [] data

  let () = print (build_structure sentences)