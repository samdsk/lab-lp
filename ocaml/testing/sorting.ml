open Lists
module Sort = struct

    let quicksort_1 (>:) l =
      let rec quicksort = function      
        [] -> []                  
        | h::t -> 
          quicksort((List.filter(fun x -> (x >: h)) t)) 
          @[h]@ (List.filter(fun x -> (x==h)) t) 
          @ quicksort((List.filter(fun x -> (h >: x)) t))
                   
      in quicksort l

      (**questo algoritmo esclude valori equivalenti, se uso >= "duplica" valori*)

      
    let rec quicksort = function
        [] -> []
        | h::t -> let smaller, larger = List.partition (fun x -> x < h) t
    in quicksort smaller @ (h::quicksort larger)

    let rec min_max (>:) x l = match l with 
      |[] -> x
      |h::t -> if(x >: h) then min_max(>:) h t else min_max(>:) x t

    

    let selection_sort (>:) l = 
      let rec selection_sort i = match i with
      | [] -> []
      | h::t -> let x = (min_max (>:) h t) in x::selection_sort (Lists.MyLists.remove_once x i)  
      in selection_sort l 
   

    
end