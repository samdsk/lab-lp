type gold = None | Some of int*int

let is_prime n = 
  let rec is_prime d = 
    if n mod d = 0 && n <> d 
    then false 
    else 
      if n = d 
      then true 
      else is_prime (d+1)
  in is_prime 2

let goldbach n =   
  let tuple = Some(n/2,n/2) in 
  let rec search = function 
    | None -> None
    | Some(f,s) when(f < 2 || s < 2) -> None
    | Some(f,s) -> if (is_prime f) && (is_prime s) then Some(f,s) else search (Some ((f-1),(s+1)))
  in if n mod 2 = 0 then search tuple else None
  
let goldbach_list (n,m) = 
  let rec build_list output = function
    | n -> if n > m then output else if goldbach n <> None then build_list ( n :: output) (n+1) else build_list output (n+1)
in build_list [] n