module type Ring =
  sig
    type t
    val zero : t
    val one : t
    val (+) : t -> t -> t
    val ( * ) : t -> t -> t
    val pp_print : Format.formatter -> t -> unit
end