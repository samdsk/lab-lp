let l1 = [2;2;7;25;3;11;-1;0;7;25;25;0;99;-25;7](* *)
let l2 =[4;8;7;5;2;1;3;4;3;8]


open Varargs

module T = struct type t = int end

module P = Varargs.VarArgs(Varargs.ListConcat(T))

let s = P.f (P.arg 1) (P.arg 2) P.stop;;

open Lists

Lists.MyLists.print_list s

;;exit 0