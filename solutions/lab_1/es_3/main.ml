(*
Exercise 3: Matrix Calculi.

Write the matrix datatype with the following operations:

    A function zeroes to construct a matrix of size n×m filled with zeros.
    A function identity to construct the identity matrix (the one with all 0s but the 1s on the diagonal) of given size.
    A function init to construct a square matrix of a given size n filled with the first n×n integers.
    A function transpose that transposes a generic matrix independently of its size and content.
    The basics operators + and * that adds amd multiplies two matrices non necessarily squared.

*)

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
