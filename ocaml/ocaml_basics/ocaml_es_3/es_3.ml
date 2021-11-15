module Matrix = struct
type matrix = (int list) list
let zeroes n m = List.init n (fun x -> List.init m (fun y -> 0)) 

let identity n = List.init n (fun x -> List.init n (fun y -> if (x==y) then 1 else 0)) 

let init n = List.init n (fun x -> List.init n (fun y -> (n*x)+(y+1)))

(**Prendo il primo elemento da ogni lista e creo una lista la quale appendo un'altra lista creato nello stesso modo *)
let rec transpose = function
  | [] -> []
  | []::t -> transpose t
  | (h_n::t_n)::t -> (h_n :: List.map List.hd t) :: (transpose (t_n :: (List.map List.tl t)))

(**Prodotto tra due liste *)
let dotprod x y = 
  let rec dotprod x y output = match x,y with
  | h1::t1 , h2::t2 -> (dotprod t1 t2 (output+h1*h2))
  | _,_ -> output
in dotprod x y 0

let ( + ) m1 m2 = 
  List.map2 (fun x y -> List.map2 (fun i j -> i+j) x y) m1 m2


(**Prodotto di due matrici: considero le liste della m 
siano le righe della metrice, mi creo una matrice dove 
le righe sono colonne della seconda matrice (matrice trasposta)
infine mappo le righe della prima matrice attraverso 
la funzione dotprod (prodotto di due liste (vettori))
con le colonne della seconda matrice
 *)
let ( * ) m_a m_b = 
  let prod rows_a rows_b = 
    let columns = transpose rows_b 
  in List.map (fun row -> List.map (dotprod row) columns) rows_a
in prod m_a m_b

end