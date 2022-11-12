open Primality
let main () =
let rec test_primes = function
  | hd::tl -> Printf.printf "%10d :- %b\n" hd (is_prime hd);
  flush stdout; test_primes tl
  | [] -> Printf.printf "\n"
in test_primes [25; 127; 8191; 131071; 524286; 524287; 524288; 2147483647] ;;

let() = main() ;;