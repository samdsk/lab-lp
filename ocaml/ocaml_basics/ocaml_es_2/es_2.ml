type temp = 
|Celsius
|Fahrenheit
|Kelvin
|Rankine
|Delisle
|Newton
|Reaumur
|Romer

let convert = function
  | Celsius -> fun x -> x
  | Fahrenheit -> fun x -> (x*.(9./.5.))+.32.
  | Kelvin -> fun x -> x +. 273.15
  | Rankine -> fun x -> (x +. 273.15)*.(9./.5.) 
  | Delisle -> fun x -> (100. -. x) *. (3./.2.)
  | Newton -> fun x -> x *. (33./.100.)
  | Reaumur -> fun x -> x*.(4./.5.)
  | Romer -> fun x -> (x *. (21./.40.)) +. 7.5

let all_types input = convert Celsius input :: 
convert Fahrenheit input :: 
convert Kelvin input :: 
convert Rankine input :: 
convert Delisle input :: 
convert Newton input :: 
convert Reaumur input :: 
convert Romer input :: []

let rec print_list = function 
| [] -> print_string("\n")
| h::t -> print_string(string_of_float h^" "); print_list t

let () = print_list (all_types 45.0)

let invert = function
| Celsius -> fun x -> x
| Fahrenheit -> fun x -> (x -. 32.)*. (5./.9.)
| Kelvin -> fun x -> x -. 273.15
| Rankine -> fun x -> (x -. 491.67)*.(5./.9.) 
| Delisle -> fun x -> (100. -. x) *. (2./.3.)
| Newton -> fun x -> x *. (100./.33.)
| Reaumur -> fun x -> x*.(5./.4.)
| Romer -> fun x -> (x -. 7.5)*. (40./.21.)

let all_inverted_temps = fun input temp -> all_types ( invert temp input)
let inverted  = all_inverted_temps 5. Kelvin

let () = print_list inverted