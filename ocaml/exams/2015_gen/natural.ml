open NaturalI

module N = struct
  type natural = Natural of succ and
  succ = Succ of succ | Zero

  exception NegativeNumber
  exception DivisionByZero

  (**another way this function wrap m with type succ n times*)
  let add n m = match n with
    | Natural(Zero) -> m
    | Natural(Succ(_) as s) -> match m with 
      | Natural(Zero) -> n
      | Natural(Succ(_) as t) -> 
        let rec build sxx = function
          | Zero -> sxx
          | Succ(sx) -> build (Succ(sxx)) sx
        in Natural(build t s)

  let eval = function
    | Natural(Zero) -> 0
    | Natural(Succ(_) as x) -> 
      let rec build acc = function
      | Zero -> acc
      | Succ(s) -> build (acc+1) s
    in build 0 x
      
  let convert num = 
    let rec build = function
    | 0 -> Zero
    | n when n<0 -> raise NegativeNumber
    | n -> Succ(build (n-1))
  in Natural(build num)

  let ( + ) n m = convert((eval n) + (eval m))

  let ( - ) n m = convert((eval n) - (eval m))

  let ( * ) n m = convert((eval n) * (eval m))

  let ( / ) n m = match m with 
    | Natural(Zero) -> raise DivisionByZero
    | _ -> convert((eval n) / (eval m))



end