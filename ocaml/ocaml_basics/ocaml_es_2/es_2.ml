type temp = Celsius | Fahrenheit | Kelvin | Rankine | Delisle | Newton | Reaumur | Romer

(*Converts from celsius to any other scale of type temp*)
let convert = function
  | Celsius -> fun x -> x
  | Fahrenheit -> fun x -> (x*.(9./.5.))+.32.
  | Kelvin -> fun x -> x +. 273.15
  | Rankine -> fun x -> (x +. 273.15)*.(9./.5.) 
  | Delisle -> fun x -> (100. -. x) *. (3./.2.)
  | Newton -> fun x -> x *. (33./.100.)
  | Reaumur -> fun x -> x*.(4./.5.)
  | Romer -> fun x -> (x *. (21./.40.)) +. 7.5

(*Converts to Celsius from any other scale of type temp*)
let to_celsius = function
  | Celsius -> fun x -> x
  | Fahrenheit -> fun x -> (x -. 32.)*. (5./.9.)
  | Kelvin -> fun x -> x -. 273.15
  | Rankine -> fun x -> (x -. 491.67)*.(5./.9.) 
  | Delisle -> fun x -> (100. -. x) *. (2./.3.)
  | Newton -> fun x -> x *. (100./.33.)
  | Reaumur -> fun x -> x*.(5./.4.)
  | Romer -> fun x -> (x -. 7.5)*. (40./.21.)

(*List of scales*)
let table_of_temps = [Celsius;Fahrenheit;Kelvin;Rankine;Delisle;Newton;Reaumur;Romer]

(*Converts the given float to every scale of type temp and returns the results as a list*)
let rec make_table input = function
  |	[] -> []
	| h::t -> (convert h input) :: make_table input convert t;;

let t = (Kelvin,0.);;

(*Given the scale and value of tempeture returns a list of corrisponding tempetures in other scales*)
let invert temp value = make_table (to_celsius temp value) convert table_of_temps;;

invert (fst t) (snd t)

