open Natural.N ;;
let main () =
  Printf.printf " 7 + 18 :- %3d\n" (eval ((convert 7) + (convert 18)) ) ;
  Printf.printf "125 + 252 :- %3d\n" (eval ((convert 125) + (convert 252)) ) ;
  Printf.printf " 25 - 18 :- %3d\n" (eval ((convert 25) - (convert 18)) ) ;
try
  Printf.printf " 18 - 25 :- %3d\n" (eval ((convert 18) - (convert 25)) )
with NegativeNumber -> Printf.printf "Exception: NegativeNumber\n" ;
  Printf.printf " 5 * 3 :- %3d\n" (eval ((convert 5) * (convert 3)) ) ;
  Printf.printf " 25 * 7 :- %3d\n" (eval ((convert 25) * (convert 7)) ) ;
  Printf.printf "125 / 25 :- %3d\n" (eval ((convert 125) / (convert 25)) ) ;
  Printf.printf "125 / 23 :- %3d\n" (eval ((convert 125) / (convert 23)) ) ;
try
  Printf.printf " 1 / 0 :- %3d\n" (eval ((convert 1) / (convert 0)) )
with DivisionByZero -> Printf.printf "Exception: DivisionByZero\n" ;
  Printf.printf " 1 / 2 :- %3d\n" (eval ((convert 1) / (convert 2)) ) ;
  Printf.printf " 0 / 100 :- %3d\n" (eval ((convert 0) / (convert 100)) ) ;;

let () = main ();;