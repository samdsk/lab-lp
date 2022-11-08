open NaturalI

module N = struct
  type natural = Succ of natural | Zero

  exception NegativeNumber
  exception DivisionByZero

  let rec convert = function
    | 0 -> Zero
    | n when n<0 -> raise NegativeNumber
    | n -> Succ(convert (n-1))
  
  let eval n =
    let rec build acc = function
      | Zero -> 0
      | Succ(s) -> build (acc+1) s
  in build 0 n

  let rec ( - ) n m = 
    let rec build n' m'  = match n',m' with      
      | n'',Zero -> n''
      | Zero,_ -> raise NegativeNumber 
      | Succ(ns),Succ(ms) -> build ns ms
    in build n m

  let ( / ) n m = match m with 
      | Zero -> raise DivisionByZero
      | _ -> convert((eval n) / (eval m))

  let div n m = match m with Zero -> raise DivisionByZero
  | _ -> 
    let rec build acc n' = function
      | Zero -> Zero
      | Succ(Zero) -> (convert acc)
      | Succ(s) -> build (acc + 1)  (n'-m) m
    in build 0 n m
  
  let rec ( + ) n = function
    | Zero -> n
    | Succ(s) -> ( + ) n s

  let ( * ) n m = match n with
    | Zero -> Zero
    | _ -> 
      let rec build n' = function
        | Zero -> Zero
        | Succ(Succ(Zero)) -> n'
        | Succ(s) -> n' + (build n' s)
      in build n m

end