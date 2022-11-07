let is_prime n = 
  let rec is_prime d = function
    | n when n == 1 -> true
    | n when n mod d == 0 && n/2 >= d -> false
    | n when n mod d <> 0 -> is_prime (d+1) n
    | n -> true
in is_prime 2 n

(*let rec next_prime n = match is_prime (n+1) with false -> next_prime (n+1) | true -> (n+1)*)
type gold = None | Some of int * int

let goldbach = function
  | n when n < 3 || n mod 2 <> 0 -> None
  | n -> let n_2 = n/2 in
    let rec find_couple x y = match x,y with
      | _ when x>n_2 || y<n_2 -> raise (Failure ("Not found! : "^string_of_int n^" - "^string_of_int x^", "^string_of_int y))
      | _ -> if is_prime x && is_prime y && x+y == n then Some(x,y) else find_couple (x+1) (y-1)
    in find_couple (2) (n-2)

let goldbach_list n m = 
  let rec build n m acc = match n,m with
  | n,m when n>m -> List.rev acc
  | _,_ -> build (n+1) m (match goldbach n with None -> acc | Some(x,y) -> (x,y)::acc)
in build n m [] 