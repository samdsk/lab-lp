let alkaline_earth_metals = [("Beryliium",4);("Magnesium",12);("Calcium",20);("Strontium",38);("Barium",56);("Radium",88)]

let noble_gases = [("Helium",2);("Neon",10);("Argon",18);("Xeonon",54);("Radon",86)]

let max l =
  let rec max acc = function
    | [] -> acc
    | (_,v)::t -> if acc < v then max v t else max acc t
  in max min_int l

let m = max alkaline_earth_metals
let () = print_string("Max: "^(string_of_int m)^"\n\n")

let op = fun x y -> if (snd x<=snd y) then 0 else 1  

let sorted_metals = List.sort op alkaline_earth_metals
let op = fun x y -> if (fst x<=fst y) then 0 else 1    

let merge l1 l2 = 
  let rec merge l_1 l_2 output = match (l_1,l_2) with
    | ([],l) | (l,[]) -> output@l
    | (((n1,_) as h1::t1),((n2,_)as h2::t2)) ->
      if (n1 <= n2) then merge t1 l_2 (output@[h1]) else merge l_1 t2 (output@[h2])     
  in (merge (List.sort op l1) (List.sort op l2) [])

let rec print_pair_list = function 
  | [] -> print_string("\n")
  | ((n,v)::t) -> Printf.printf ("%s - %d \n") n v; (print_pair_list t)

let () = print_pair_list sorted_metals
let () = print_pair_list (merge alkaline_earth_metals noble_gases)
