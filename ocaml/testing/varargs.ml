module type OpVarArgs = 
  sig
    type a
    type b
    type c
    val op: a -> b -> c
    val init : c
  end

module VarArgs = functor (Op : OpVarArgs) -> struct
  let arg a1 = fun a2 f -> f (Op.op a1 a2)
  let stop x = x

  let f g = g Op.init

end

module type ListType = sig
  type t
end
(** Polymorphic list var args *)
module ListConcat (T: ListType) = struct
  type a = T.t and b = a list and c = a list
  let init = []
  let op = fun e l -> l @ [e]
end