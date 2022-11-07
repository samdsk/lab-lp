module type Comparable = sig
  type t
  val compare : t -> t -> int
  val tostring : t -> string
end