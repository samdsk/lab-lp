module TheMatrix = (Matrix.Matrix: MatrixADT.Matrix);;

open TheMatrix;;

let main() =
   let z = zeroes 5 2 and i = identity 7 and a = init 7 in 
     let c = a + i in
       let t = transpose c in 
         let p = t*i in 
           (Format.printf "%a\n" pp_print_matrix z) ; 
           (Format.printf "%a\n" pp_print_matrix i) ; 
           (Format.printf "%a\n" pp_print_matrix a) ; 
           (Format.printf "%a\n" pp_print_matrix c) ; 
           (Format.printf "%a\n" pp_print_matrix p) ; 
           (Format.printf "%a\n" pp_print_matrix t) ;;

main();;
