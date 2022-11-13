module Mtest(N : Ntest.Ntest) = struct
  type t = T of N.t

  let to_t x = T x 
  let to_string = function T(str) -> str

  let f x = "Hello "^(to_string x)^" from Mtest.Mtest"
end