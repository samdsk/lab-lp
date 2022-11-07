module type MonoidADT = sig
  type t
  val set : t list
  val op_1 : t -> t -> t
  val identity_1 : t
end

module Monoid(M: MonoidADT) = struct
  let set = M.set
  let identity_1 = M.identity_1
  let op_1 = M.op_1

  let rec is_associative = function
    | [] -> true
    | a::t -> let rec loop1 = function
      | [] -> is_associative t
      | b::t1 -> if (op_1 a b) == (op_1 b a) then loop1 t1 else false
    in loop1 set
  
  let rec identity_check op identity= function
    | [] -> true
    | h::t -> if (op h identity) <> h then false else identity_check op identity t
  let rec is_monoid = is_associative set && identity_check op_1 identity_1 set

end

module type GroupADT = sig
  include MonoidADT
end

module Group (G:GroupADT) = struct
  include Monoid(G)
  let rec inverse_check = function
    | [] -> true
    | a::t -> let rec loop1 = function
      | [] -> inverse_check t
      | b::t1 -> if op_1 a b <> identity_1 then false else loop1 t1
    in loop1 set
  let is_group = inverse_check set && is_monoid
end

module type RingADT = sig
  include GroupADT
  val op_2 : t -> t -> t
  val identity_2 : t
end

module Ring (R:RingADT) = struct
  include Group(R)

  let op_2 = R.op_2
  let identity_2 = R.identity_2

  module TempADT = struct
    type t = R.t
    let set = R.set
    let identity_1 = R.identity_2
    let op_1 = R.op_2
  end

  module Monoid_2 = Monoid(TempADT)

  let is_ring = is_group && Monoid_2.is_monoid

end

module Bool = struct
  type t = bool
  let set = [true;false]
  let i = false

  let i_2 = true
  let op a b = (a || b) 

  let op_2 a b = a && b
end

module Zero = struct
  type t = int
  let set = [0]
  let i = 0
  let i_2 = 1
  let op a b = a+b 
  let op_2 a b = a*b 
end

module Z4 = struct
  type t = int
  let set = [0;1;2;3]
  let i = 0
  let i_2 = 1
  let op a b = a+b mod 4

  let op_2 a b = a*b mod 4
end