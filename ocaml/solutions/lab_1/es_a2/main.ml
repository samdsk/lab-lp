module I = Matrix.Matrix(IntRing.IntRing) ;;
module B = Matrix.Matrix(BoolRing.BoolRing) ;;

(* open I ;; *)

let main() =
   let z = I.zeroes 5 2 and i = I.identity 7 in 
     let c = I.(+) i i in
       let t = (B.transpose (B.identity 10)) in 
         let p = B.( * ) t t in 
           (Format.printf "%a\n" I.pp_print_matrix z) ; 
           (Format.printf "%a\n" I.pp_print_matrix i) ; 
           (Format.printf "%a\n" I.pp_print_matrix c) ; 
           (Format.printf "%a\n" B.pp_print_matrix p) ; 
           (Format.printf "%a\n" B.pp_print_matrix t) ;;

main();;