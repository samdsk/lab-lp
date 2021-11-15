open IntervalI

module type Comparable = sig
  type t
  val compare : t -> t -> int
  val tostring : t -> string
end

module Interval (C: Comparable) : (IntervalI with type endpoint = C.t ) = struct
  
  type endpoint = C.t
  type interval = Empty | Interval of endpoint * endpoint
  exception WrongInterval

  let create i f = 
    if i>f then raise WrongInterval
    else Interval(i,f)
  let is_empty = function 
    | Empty -> true
    | _ -> false
  let contains i e = match i with
    | Empty -> raise WrongInterval
    | Interval(i,f) -> if e >= i || e <= f then true else false
  let intersect i1 i2 = match i1 with 
    | Empty -> i2
    | Interval(i,f) -> match i2 with
      | Empty -> i1
      | Interval(x,y) -> 
        let min = if C.compare i x >= 0 then x else i in
        let max = if C.compare f y >= 0 then f else y in
        create min max
  let tostring = function
    | Empty -> ""
    | Interval(i,f) -> (C.tostring i)^" , "^(C.tostring f)
end

module Ints : (Comparable with type t=int) = struct
  type t = int  
  let compare a b =  if a >= b then 1 else -1
  let tostring i = string_of_int i
end

module Strings : (Comparable with type t=string) = struct
  type t = string  
  let compare a b =  if a >= b then 1 else -1
  let tostring i = i
end

module IntInterval = Interval(Ints)
module StringInterval = Interval(Strings)