let list = [2;7;25;3;11;-1;0;7;25;25;0;99;-25;7];;

let rec find x l tot = match l with [] -> 0 | h::t -> tot+(if h=x then find x t tot+1 else find x t tot);;

print_int(find 25 list 0);;
print_newline() ;;

let count x l =
    let rec boh tot x = function
        [] -> tot 
      | h::t -> if h==x then boh (tot+1) x t else boh tot x t
      in boh 0 x l;;

print_int(count 25 list);;
print_newline() ;;

exit 0;;