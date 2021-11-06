module type MonoidADT = sig
  type t
  val set : t list
  (**Indentity *)
  val i : t
  val op : t -> t -> t 
end

module Z3 = struct
  type t = int
  let set = [0;1;2]
  let i = 0
  let op a b = (a+b) mod 3
end

module Bool = struct
  type t = bool
  let set = [true;false]
  let i = false
  let op a b = (a || b) 
end

module Monoid (M:MonoidADT) = struct  
  let i = M.i
  let op = M.op

  let set = M.set
  let is_it_monoid a b c = 
    let rec test_identity = function
      | [] -> true
      | h::t -> if op h i = h then test_identity t else false
    in let test_associativity = 
        if op a (op b c) = op (op a b) c then true else false 
    in if test_associativity && test_identity set then true else false
end

module Test = Monoid(Z3)

let x = Test.op 3 2

let x = Test.is_it_monoid 3 2 4

module Test = Monoid(Bool)
let x = Test.op true true

let x = Test.is_it_monoid false true false
