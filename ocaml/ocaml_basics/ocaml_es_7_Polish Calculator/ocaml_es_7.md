# Exercise 7: Playing around with Arithmetic (the Polish Calculator).

* Write a `PolishCalculator` module that implements a stack-based calculator that adopts polish notation for the expressions to be evaluated.

### **Polish Notation** is a prefix notation wherein every operator follows all of its operands; this notation has the big advantage of being unambiguous and permits to avoid the use of parenthesis. E.g., (3+4)*5 is equal to 3 4 + 5 *.

The module should include an:

-    Expr datatype representing an expression
-    a function `expr_of+string: string → Expr` which build the expression in the corresponding infix notation out of the string in polish notation;
-    a function `eval: Expr → int` which will evaluate the expression and returns such evaluation

* The recognized operators should be +, - (both unary and binary), *, /, ** over integers. At least a space ends each operands and operators.

* The evaluation/translation can be realized by pushing the recognized elements on a stack. Define the module independently of the Stack implementation and try to use functors to adapt it.