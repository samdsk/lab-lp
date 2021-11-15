module type NaturalI =
sig
  type natural
  exception NegativeNumber
  exception DivisionByZero
  val ( + ) : natural -> natural -> natural
  val ( - ) : natural -> natural -> natural
  val ( * ) : natural -> natural -> natural
  val ( / ) : natural -> natural -> natural
  val eval : natural -> int
  val convert : int -> natural

end