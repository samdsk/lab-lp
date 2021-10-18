open Lists
open Sorting

let l = [2;7;25;3;11;-1;0;7;25;25;0;99;-25;7]

let y l = match l with
          h::t -> List.filter (fun x -> x<h) t
          |[] -> []
let x = Sorting.Sort.quicksort l

let () = Lists.MyLists.print_list l
let () = print_newline()

let () = Lists.MyLists.print_list x
let () = print_newline()

;;exit 0