module type Mtesti = sig
  type t
  val to_t : string -> t
  val to_string : t -> string
  val f : t -> string
end