let trialdivision n = 
  let rec check x = function
    | d when d > x/2 -> true
    | d when x mod d = 0 -> false
    | d -> check x (if d=2 then 3 else (d+2))
in  check n 2

(** Lucas-Lehmer prime test - M_p = 2^p - 1 -> p = log(m+1)/log(2) *)
let lucaslehmer m =
  let rec s_i s_i_1 = function
    | 0 -> s_i_1 = 0.
    | p -> s_i ((s_i_1 ** 2.) -. 1.) (p-1) in s_i 4. (int_of_float((log (float m +. 1.)) /. (log 2.) -. 2.))

(**produce a list of int within the given range and step excluding bounds*)
let range ~start:i ~finish:e ~step:step =
  let rec range s f acc = match f with
      | f when f=s -> acc
      | _ -> range (s+step) f (s+step::acc)
in range i e []

(** Modular exponential resolver a^e = b (mod m) *)
let mod_resolve a e m = 
  let rec find b = function
    | l when l==e -> b
    | l -> find (b*a mod m) (l+1)
in find 1 0

(**Little Fermat prime test*)
let littlefermat n = 
  let n_1 = n-1 in
    let a = (range ~start:0 ~finish:(int_of_float (log (float n))) ~step:1) in
    List.filter (fun x -> mod_resolve x (n_1) n <> 1) a |> List.length == 0
       

let is_prime = function
  | n when n<=10000 -> print_endline "trialdivision";trialdivision n
  | n when n<=524287 -> print_endline "lucas lehmer";lucaslehmer n
  | n -> print_endline "little fermat";littlefermat n