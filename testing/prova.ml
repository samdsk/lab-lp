open Lists
open Sorting

let l = [2;7;25;3;11;-1;0;7;25;25;0;99;-25;7];;

let y l = match l with
          h::t -> List.filter (fun x -> x<h) t
          |[] -> [];;
let x = Sort.quicksort ( >= ) l ;;

MyLists.print_list l;;
print_newline();;

MyLists.print_list x;;
print_newline();;

exit 0;;