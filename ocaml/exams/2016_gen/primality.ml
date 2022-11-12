let trialdivision n = 
  let rec check x = function
    | d when d > x/2 -> true
    | d when x mod d = 0 -> false
    | d -> check x (if d=2 then 3 else (d+2))
in  check n 2

let lucaslehmer m =   
  let rec s_i s_i_1 i = function
    | n when n = i -> if (int_of_float((s_i_1 ** 2.) -. 2.) mod m) = 0 then true else false
    | n -> s_i log( float m +. 1. )
in s_i 4. (n-2) 0

let littlefermat n = 
  let p = float_of_int n in
  let rec gen_random () = let r = Random.float 0.99 *. p in if r <> 0. then r else gen_random () in
  let rec gen acc = function 
    | 0 -> acc
    | times -> if int_of_float(gen_random () ** (p -.1.)) mod (n-1) = 1 then gen (acc+1) (times-1) else gen acc (times-1) 
  in(gen 0 100) > 70

let is_prime = function
  | n when n<=10000 -> print_endline "trialdivision";trialdivision n
  | n when n<=524287 -> print_endline "lucas lehmer";lucaslehmer n
  | n -> print_endline "little fermat";littlefermat n


let lucaslehmer m =
  Printf.printf "Lucas-Lehmer's Primality Test\t" ;
  let rec lucaslehmer p s m =
  if p==0 then s==0
  else lucaslehmer (p-1) ((s*s-2) mod m) m
  in lucaslehmer ((int_of_float ((log ((float m)+.1.))/.(log 2.)))-2) 4 m ;;