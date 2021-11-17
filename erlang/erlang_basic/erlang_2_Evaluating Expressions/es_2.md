This exercise asks you to build a collection of functions that manipulate arithmetical expressions. Start with an expression such as the following: `((2+3)-4), 4 and ~((2*3)+(3*4))` which is fully bracketed and where you use a tilde `(~)` for unary minus.

First, write a parser for these, turning them into Erlang representations, such as the following: `{minus, {plus, {num, 2}, {num,3}}, {num, 4}}` which represents `((2+3)-4)`. We call these exp s. Now, write an evaluator, which takes an exp and returns its value.

You can also extend the collection of expressions to add conditionals: `if ((2+3)-4) then 4 else ~((2*3)+(3*4))` where the value returned is the “`then`” value if the “`if`” expression evaluates to 0, and it is the “`else`” value otherwise.