module type Matrix = 
  sig
    type elt
    type matrix
    val zeroes : int -> int -> matrix
    val identity : int -> matrix
    (* val init : int -> matrix *)
    val transpose : matrix -> matrix
    val pp_print_matrix : Format.formatter -> matrix -> unit
    val (+) : matrix -> matrix -> matrix
    val ( * ) : matrix -> matrix -> matrix
  end ;;
