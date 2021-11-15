(*
Exercise 2: Temperature Conversion System.

Beyond the well-known Celsius and Fahrenheit, there are other six temperature scales: Kelvin, Rankine, Delisle, Newton, Réaumur, and Rømer (Look at:

http://en.wikipedia.org/wiki/Comparison_of_temperature_scales

to read about them).

    Write a function that given a pure number returns a conversion table for it among any of the 8 scales.
    Write a function that given a temperature in a specified scale returns a list of all the corresponding temperatures in the other scales, note that the scale must be specified.

Hint. Define a proper datatype for the temperature.
*)

type t_unit = Celsius|Fahrenheit|Kelvin|Rankine|Delisle|Newton|Reaumur|Romer ;;
type temperature = { value: float; tu: t_unit } ;;

let cons = [Celsius; Fahrenheit; Kelvin; Rankine; Delisle; Newton; Reaumur; Romer] ;;
let cons_repr = [(Celsius, "C"); (Fahrenheit, "F"); (Kelvin, "K"); (Rankine, "R"); (Delisle, "De"); (Newton, "N"); (Reaumur, "Ré"); (Romer, "Rø")] ;;

let any2c t =
  match t.tu with
    Celsius    -> t
  | Fahrenheit -> { value = (t.value -. 32.) *. 5. /. 9.;    tu = Celsius }
  | Kelvin     -> { value = t.value -. 273.15 ;              tu = Celsius }
  | Rankine    -> { value = (t.value -. 491.67) *. 5. /. 9.; tu = Celsius }
  | Delisle    -> { value = 100. -. t.value *. 2. /. 3.;     tu = Celsius }
  | Newton     -> { value = t.value *. 100. /. 33.;          tu = Celsius }
  | Reaumur    -> { value = t.value *. 5. /. 4.;             tu = Celsius }
  | Romer      -> { value = (t.value -. 7.5) *. 40. /. 21.;  tu = Celsius } ;;

let c2any t u =
  match u with
    Celsius    -> t
  | Fahrenheit -> { value = t.value *. 9. /. 5. +. 32.;    tu = u }
  | Kelvin     -> { value = t.value +. 273.15;             tu = u }
  | Rankine    -> { value = t.value *. 9. /. 5. +. 491.67; tu = u }
  | Delisle    -> { value = (100. -. t.value) *. 3. /. 2.; tu = u }
  | Newton     -> { value = t.value *. 33. /. 100.;        tu = u }
  | Reaumur    -> { value = t.value *. 4. /. 5.;           tu = u }
  | Romer      -> { value = t.value *. 21. /. 40. +. 7.5;  tu = u } ;;

let others t =
  let rec others c res =
    function
      []                             -> List.rev res
    | a_unit::tl when a_unit = t.tu  -> others c res tl
    | a_unit::tl                     -> others c ((c2any c a_unit)::res) tl
  in others (any2c t) [] cons ;;

let rec row t res =
  function
    []         -> List.rev res
  | a_unit::tl -> row t ((c2any t a_unit)::res) tl ;;

let rec columns n acc =
  function
    []     -> List.rev acc
  | hd::tl -> (columns n
                (((row
                     (any2c { value = n; tu = hd })
                     []
                     cons
                  )::acc)) tl) ;;

let table n = columns n [] cons ;;

exception ValueError ;;

let rec repr t =
  function
    []                         -> raise ValueError
  | (hd,s)::tl when t.tu == hd -> s
  | hd::tl                     -> repr t tl ;;

(** pretty printing functions **)
let p_temp ppf t = Format.fprintf ppf "%6.1fº%s" t.value (repr t cons_repr) ;;

let pp_comma ppf () = Format.fprintf ppf ", " ;;
let pp_comma_nl ppf () = Format.fprintf ppf ",\n " ;;

let pp_temp_generic ppf sep p lst =
  Format.fprintf ppf "%a" Format.(pp_print_list ~pp_sep:sep p) lst ;;

let p_temp_list ppf lst =
  let p_temp_list ppf lst = pp_temp_generic ppf pp_comma p_temp lst
  in Format.fprintf ppf "[%a]" p_temp_list lst ;;

let p_temp_table ppf tbl =
  let p_temp_table ppf tbl = pp_temp_generic ppf pp_comma_nl p_temp_list tbl
  in Format.fprintf ppf "[%a]" p_temp_table tbl ;;

let main() =
  let f = {value = 32. ; tu = Fahrenheit } and
      pure_number = 42. in
    (Format.printf "%a :- %a\n" p_temp f p_temp_list (others f)) ;
    (Format.printf "%a\n" p_temp_table (table pure_number)) ;;

main();;
