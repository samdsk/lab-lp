
(*Not complete*)
module Primality = struct

  let traildivision p = 
    let rec check p n =     
      if p <> n then 
        if p mod n = 0 then false
        else check p (n+1)
      else true
    in check p 2

  
  let lucaslehmer mp = 
    let rec check p =      
      let rec s i = if i = 0. then 4. else ((s (i-.1.)) ** 2.) -. 2.
      in if int_of_float(s (p -. 2.)) mod mp = 0 then true else false
    in check ((Float.log (float_of_int mp)+. 1.) /. Float.log 2.)




end