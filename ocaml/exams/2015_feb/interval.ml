open IntervalI
open Comparable

module Interval (T : Comparable) : (IntervalI with type endpoint = T.t)  = struct
  type endpoint = T.t
  type interval = Interval of endpoint*endpoint | Empty
  exception WrongInterval

  let create a b = 
    if T.compare a b > 0 then raise WrongInterval 
    else if T.compare a b == 0 then Empty else Interval(a,b)

  let is_empty = function Empty -> true | _ -> false

  let contains i e = match i with 
    | Empty -> false
    | Interval(a,b) -> T.compare e a >= 0 && T.compare e b <= 0
  
  let intersect i1 i2 = match i1,i2 with
    | Empty,_ | _,Empty -> Empty
    | Interval(a1,b1),Interval(a2,b2) -> 
      let min a b = if T.compare a b <= 0 then a else b in
      let max a b = if T.compare a b >= 0 then a else b in
      create (max a1 a2) (min b1 b2) 

  let tostring = function
    | Empty -> "[]"
    | Interval(a,b) -> "["^T.tostring a^", "^T.tostring b^"]"
end

module IntInterval = Interval(
  struct 
    type t = int
    let compare = compare
    let tostring = string_of_int
end)

module StringInterval = Interval(
  struct
    type t = string
    let compare = String.compare
    let tostring t = t
end)