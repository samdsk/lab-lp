module Matrix = struct
  type matrix = (int list) list

  let zeroes n m = List.init n (fun x -> List.init m (fun y -> 0))
  let identity n = List.init n (fun x -> List.init n (fun y -> if x=y then 1 else 0))
  let init n = List.init n (fun x -> List.init n (fun y -> n*x+y+1))

  let rec transpose = function 
    | [] -> []
    | [] :: t -> transpose t
    | h::t -> ((List.hd h) :: (List.map (List.hd) t)) :: transpose ((List.tl h) :: (List.map List.tl t))

  let dotprod x y = 
    let rec dotprod l1 l2 acc = match l1,l2 with
      | h1::t1, h2::t2 -> (dotprod t1 t2 (h1*h2 + acc))
      | _,_ -> acc
  in dotprod x y 0;;

 let ( + ) m1 m2 =
    List.map2 (fun x y -> List.map2 (fun i j -> i+j) x y) m1 m2;;

  let ( * ) m1 m2 =     
    let columns = transpose m2  
    in List.map (fun x -> List.map (dotprod x) columns) m1

end;;