module type MonoidADT = sig
  type t
  val set : t list
  (**Indentity *)
  val i : t
  val op : t -> t -> t 
end
module Monoid (M:MonoidADT) = struct  
  let i = M.i
  let op = M.op
  let set = M.set
  let rec test_identity = function
    | [] -> true
    | h::t -> if op h i = h then test_identity t else false
  let rec test_associativity = function
    | [] -> true
    | h1::t1 -> let rec loop1 = function
      | [] -> true
      | h2::t2 -> let rec loop2 = function 
        | [] -> true
        | h3::t3 -> if op h1 (op h2 h3) = op (op h1 h2) h3 then loop2 t3 else false 

    in if loop2 set then loop1 t2 else false 
    in if loop1 set then test_associativity t1 else false  
  let is_it_monoid =    
    if test_associativity set && test_identity set then true else false
end

module Group (G:MonoidADT) = struct
  include Monoid(G)
  let rec test_inverce = function
    | [] -> true
    | h1::t1 -> let rec loop1 = function
      | [] -> true
      | h2::t2 -> if op h1 h2 = i then loop1 t2 else false
      in if loop1 set then test_inverce t1 else false
  let is_it_group = 
    if test_inverce set && test_associativity set && test_identity set then true else false
end

module type RingADT = sig
  type t
  val set : t list
  (**Indentity *)
  val i : t
  (**Indentity for second operator *)
  val i_2 : t
  val op : t -> t -> t 
  val op_2 : t -> t -> t 
end

module Ring (R:RingADT) = struct
  include Group(R) 

  module TestADT = struct
    type t = R.t
    let i = R.i_2
    let set = R.set
    let op = R.op_2
  end

  module Test = Monoid(TestADT)

  let is_it_ring = 
    if is_it_group && Test.is_it_monoid then true else false
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

module P = Ring(Z4)

let x = P.is_it_ring


