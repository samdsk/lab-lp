open Lists
open Modules
let l = [2;7;25;3;11;-1;0;7;25;25;0;99;-25;7]

let q = Modules.PQueue.Empty;;

module Asd = Modules.App(Modules.A);;

print_int(Asd.s);;
exit 0