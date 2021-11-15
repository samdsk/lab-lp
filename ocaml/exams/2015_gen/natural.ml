open NaturalI

module N : NaturalI = struct

  type natural = Natural of int

  exception NegativeNumber
  exception DivisionByZero

  let ( + ) a b = match a,b with
    | Natural(x),Natural(y) -> Natural(x+y)

  let ( - ) a b = match a,b with
    | Natural(x),Natural(y) when(y>x) -> raise NegativeNumber 
    | Natural(x),Natural(y) -> Natural(x-y)

  let ( * ) a b = match a,b with
    | Natural(x),Natural(y) -> Natural(x*y)

  let ( / ) a b = match a,b with
    | _,Natural(y) when (y=0) -> raise DivisionByZero
    | Natural(x),Natural(y) -> Natural(x/y)

  let eval n = match n with Natural(a) -> a

  let convert n = match n with
    | _ when(n>=0) -> Natural(n)
    | _ -> let f = float_of_int n in Natural(int_of_float (Float.sqrt (f *. f)))

end