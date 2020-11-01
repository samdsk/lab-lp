module IntRing =
  struct
     type t = int
     let zero = 0
     let one = 1
     let (+) x y = x + y
     let ( * ) x y = x * y
     let pp_print ppf e = Format.fprintf ppf "%02d" e
  end
