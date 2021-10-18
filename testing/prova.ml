open Lists
open Sorting

let l = [2;2;7;25;3;11;-1;0;7;25;25;0;99;-25;7](*[4;8;7;5;2;1;3;4;3;8] *)


let y l = match l with
          h::t -> List.filter (fun x -> x>=h) t
          |[] -> []
let x = Sorting.Sort.quicksort_1 (<) l

let () = Lists.MyLists.print_list l
let () = Lists.MyLists.print_list x
let v = Sorting.Sort.selection_sort (>) l

let () = Lists.MyLists.print_list v
;;exit 0