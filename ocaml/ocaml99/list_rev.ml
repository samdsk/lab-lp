
let rev l = 
  let rec rev output = function
    | [] -> output
    | h::t -> rev (h::output) t 
  in rev [] l