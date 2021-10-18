module Sort = struct

    let quicksort_1 (>:) l =
      let rec quicksort = function
        [] -> []
        | h::t -> (quicksort (List.filter(fun x -> (x >: h)) t)) (** una lista in cui tutti valori sono maggiore di h*)
                  @ [h] @
                  (quicksort (List.filter(fun x -> (h >: x)) t)) (** una lista in cui tutti valori sono minori di h*)
      in quicksort l

      (**questo algoritmo esclude valori equivalenti, se uso >= "duplica" valori*)

      
    let rec quicksort = function
        | [] -> []
        | h::t -> let smaller, larger = List.partition (fun x -> x < h) t
    in quicksort smaller @ (h::quicksort larger)
        
end