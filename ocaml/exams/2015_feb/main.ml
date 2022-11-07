open Interval;;

let main () = 
  let i1 = IntInterval.create 3 8 and
      i2 = IntInterval.create 4 10 and
      s1 = StringInterval.create "abacus" "zyxt" and
      s2 = StringInterval.create "dog" "wax" 
  in Printf.printf "%s\n" (IntInterval.tostring (IntInterval.intersect i1 i2));
  try 
    Printf.printf "%s\n" (StringInterval.tostring (StringInterval.create "wax" "fog"))
  with StringInterval.WrongInterval -> 
    Printf.printf "Exception: WrongInterval\n";
    Printf.printf "%s\n" (StringInterval.tostring (StringInterval.intersect s1 s2));
    Printf.printf "Does \"%s\" belong to %s? %B\nDoes it belong to %s? %B\n" "asylum"
      (StringInterval.tostring s2) (StringInterval.contains s2 "asylum")
      (StringInterval.tostring s1) (StringInterval.contains s1 "asylum")
  
let () = main()