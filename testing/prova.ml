open Lists
open Sorting

let l = [2;2;7;25;3;11;-1;0;7;25;25;0;99;-25;7](*[4;8;7;5;2;1;3;4;3;8] *)

let x = (Lists.MyLists.forall (fun x->(x==9)) l)

let () = print_string(string_of_bool x)

;;exit 0