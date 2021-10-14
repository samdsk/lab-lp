module Sort = struct

    let quicksort (>:) l =
      let rec quicksort = function
        [] -> []
        | h::t -> (quicksort (List.filter(fun x -> (x >: h)) t)) (** una lista in cui tutti valori sono maggiore di h*)
                  @ [h] @
                  (quicksort (List.filter(fun x -> (h >: x)) t)) (** una lista in cui tutti valori sono minori di h*)
      in quicksort l

      (**questo algoritmo esclude valori equivalenti, se uso >= "duplica" valori*)
end