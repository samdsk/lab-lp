
(**This solution is probably wrong*)
module Taylor : sig
  val sin : float -> float -> float
  val cos : float -> float -> float
  val exp : float -> float -> float
  val log : float -> float -> float
  val taylor : float -> float -> (float -> float) -> float

end = struct
  exception OutOfRange_X
let rec factorial = function
  | 1. | 0. -> 1.
  | _ as f -> f*.factorial (f-.1.)

let rec sin x n = match n with
  | _ when (n<0.) -> 0.
  | _ -> (((Float.pow (-1.) n)  /. factorial (2.*.n +. 1. )) 
    *. Float.pow x (2.*.n+.1.)) +. (sin x (n-.1.))

let rec cos x n = match n with
  | _ when (n<0.) -> 0.
  | _ -> (((Float.pow (-1.) n)  /. factorial (2.*.n)) 
    *. Float.pow x (2.*.n)) +. (cos x (n-.1.))

let rec exp x n = match n with
  | _ when (n<0.) -> 0.
  | _ -> (Float.pow x n *. factorial n) +. (exp x (n-.1.))
  
let rec log x n = 
  if ((x<(-1.)) && (x>1.)) then raise OutOfRange_X
  else begin
    match n with
    | _ when (n<1.) -> 0.
    | _ -> (((Float.pow (-1.) (n+.1.))  /. n) 
      *. Float.pow x (n)) +. (log x (n-.1.))
  end

let rec taylor x n f = match n with
  | _ when (n<0.) -> 0.
  | _ -> (f n) *. (Float.pow x n /. factorial n) +. (taylor x (n-.1.) f)

end