let alkaline_earth_metals = [("beryllium", 4);("magnesium",12);("calcium",20);("strontium",38);("barium",56);("radium",88)];;

let highest_atomic_number list = 	
	let rec max output = function
		[] -> output
	|	(_,value) :: t -> if(value > output) then max value t else max output t
in max (snd (List.hd list)) (List.tl list);;

let comp = fun x y -> if fst x = fst y then 0 else if fst x < fst y then -1 else 1

let sort list = List.sort comp list;;

Printf.printf "Highest is: %d" (highest_atomic_number alkaline_earth_metals);;

let noble_gases = [("helium",2);("neon",10);("argon", 18);("krypton", 36);("xenon", 54);("radon", 86)];;

let merge l1 l2 = 
	let rec merge l1 l2 output = match (l1,l2) with
		|	([],[]) -> List.rev output
		| ([],l) | (l,[]) -> (List.rev output) @l
		|	((h1::t1),(h2::t2)) -> if fst h1 < fst h2 then merge t1 l2 (h1::output) else merge l1 t2 (h2::output)
in merge l1 l2 [];;


print_string "ciao\n\n";;
merge (List.sort comp alkaline_earth_metals) (List.sort comp noble_gases);;