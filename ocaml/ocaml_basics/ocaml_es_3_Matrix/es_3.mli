module type Matrix = 
  sig
    type matrix
    val zeroes : int -> int -> matrix
    val identity : int -> matrix
    val init : int -> matrix
    val transpose : matrix -> matrix
    val ( + ) : matrix -> matrix -> matrix
    val ( * ) : matrix -> matrix -> matrix
  end ;;