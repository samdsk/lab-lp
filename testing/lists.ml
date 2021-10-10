(*Testing lists*)

let l = [1;2;3;4;5;6;7];;

let add list n = match list with
                    [] -> [n]
                    | h::t -> n::list;;

let rec print_list ls = match ls with
                        [] -> () |
                        h::t -> begin print_int h; print_newline (); print_list t end;;

let rec append l n = match l with
    [] -> [n] |
    h::t -> h:: append t n;;



let  l = append l 8;;
print_list l;;