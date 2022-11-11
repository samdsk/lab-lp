open Reduction.ArithExpr;;
let main() =
let expressions = ["+34"; "+3-15"; "*+34-23"; "+7++34+23";
  "*+*34-34/6-35"; "/+-81*45*/93/52"; "*+/12/14-2/32"] 
  in List.iter print_evaluation expressions ;;

main();;