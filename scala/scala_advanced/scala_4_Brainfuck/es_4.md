# The Language

The brainfuck language uses a simple machine model consisting of the program and instruction pointer, as well as an array of at least 30,000 byte cells initialized to zero; a movable data pointer (initialized to point to the leftmost byte of the array); and two streams of bytes for input and output (most often connected to a keyboard and a monitor respectively, and using the ASCII character encoding).

# Commands

The eight language commands, each consisting of a single character:
# Character     Meaning
    > 	        increment the data pointer (to point to the next cell to the right).
    < 	        decrement the data pointer (to point to the next cell to the left).
    + 	        increment (increase by one) the byte at the data pointer.
    - 	        decrement (decrease by one) the byte at the data pointer.
    .       	output a character, the ASCII value of which being the byte at the data pointer.
    , 	        accept one byte of input, storing its value in the byte at the data pointer.
    [ 	        if the byte at the data pointer is zero, then instead of moving the instruction pointer forward to the next command, jump it forward to the command after the matching ] command*.
    ] 	        if the byte at the data pointer is nonzero, then instead of moving the instruction pointer forward to the next command, jump it back to the command after the matching [ command*.

Any other character contributes to for a spurious string and is ignored.

# Grammar

The brainfuck grammar is

```
Program ::= StatementList
StatementList ::= Statement { StatementList }
Statement ::= > | < | + | - | . | , | [ StatementList ] | SpuriousStr
SpuriousStr ::= ... a string composed of chars not in the operator set
```

Some examples in brainfuck are (respectively, helloworld, rot13 of a string given as input and the wrapping of a number given as input):

```
[ This program prints "Hello World!" and a newline to the screen, its
  length is 106 active command characters. [It is not the shortest.]

  This loop is an "initial comment loop", a simple way of adding a comment
  to a BF program such that you don't have to worry about any command
  characters. Any ".", ",", "+", "-", "<" and ">" characters are simply
  ignored, the "[" and "]" characters just have to be balanced. This
  loop and the commands it contains are ignored because the current cell
  defaults to a value of 0; the 0 value causes this loop to be skipped.
]
++++++++               Set Cell 0 to 8
[
    >++++               Add 4 to Cell 1; this will always set Cell 1 to 4
    [                   as the cell will be cleared by the loop
        >++             Add 2 to Cell 2
        >+++            Add 3 to Cell 3
        >+++            Add 3 to Cell 4
        >+              Add 1 to Cell 5
        <<<<-           Decrement the loop counter in Cell 1
    ]                   Loop till Cell 1 is zero; number of iterations is 4
    >+                  Add 1 to Cell 2
    >+                  Add 1 to Cell 3
    >-                  Subtract 1 from Cell 4
    >>+                 Add 1 to Cell 6
    [<]                 Move back to the first zero cell you find; this will
                        be Cell 1 which was cleared by the previous loop
    <-                  Decrement the loop Counter in Cell 0
]                       Loop till Cell 0 is zero; number of iterations is 8

The result of this is:
Cell No :   0   1   2   3   4   5   6
Contents:   0   0  72 104  88  32   8
Pointer :   ^

>>.                     Cell 2 has value 72 which is 'H'
>---.                   Subtract 3 from Cell 3 to get 101 which is 'e'
+++++++..+++.           Likewise for 'llo' from Cell 3
>>.                     Cell 5 is 32 for the space
<-.                     Subtract 1 from Cell 4 for 87 to give a 'W'
<.                      Cell 3 was set to 'o' from the end of 'Hello'
+++.------.--------.    Cell 3 for 'rl' and 'd'
>>+.                    Add 1 to Cell 5 gives us an exclamation point
>++.                    And finally a newline from Cell 6
```
```
[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-
[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-
[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-
[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-
[>++++++++++++++<-
[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-
[>>+++++[<----->-]<<-
[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-
[>++++++++++++++<-
[>+<-[>+<-[>+<-[>+<-[>+<-
[>++++++++++++++<-
[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-
[>>+++++[<----->-]<<-
[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-
[>++++++++++++++<-
[>+<-]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]>.[-]<,]
```

```
>>>>+>+++>+++>>>>>+++[
  >,+>++++[>++++<-]>[<<[-[->]]>[<]>-]<<[
    >+>+>>+>+[<<<<]<+>>[+<]<[>]>+[[>>>]>>+[<<<<]>-]+<+>>>-[
      <<+[>]>>+<<<+<+<--------[
        <<-<<+[>]>+<<-<<-[
          <<<+<-[>>]<-<-<<<-<----[
            <<<->>>>+<-[
              <<<+[>]>+<<+<-<-[
                <<+<-<+[>>]<+<<<<+<-[
                  <<-[>]>>-<<<-<-<-[
                    <<<+<-[>>]<+<<<+<+<-[
                      <<<<+[>]<-<<-[
                        <<+[>]>>-<<<<-<-[
                          >>>>>+<-<<<+<-[
                            >>+<<-[
                              <<-<-[>]>+<<-<-<-[
                                <<+<+[>]<+<+<-[
                                  >>-<-<-[
                                    <<-[>]<+<++++[<-------->-]++<[
                                      <<+[>]>>-<-<<<<-[
                                        <<-<<->>>>-[
                                          <<<<+[>]>+<<<<-[
                                            <<+<<-[>>]<+<<<<<-[
                                              >>>>-<<<-<-
  ]]]]]]]]]]]]]]]]]]]]]]>[>[[[<<<<]>+>>[>>>>>]<-]<]>>>+>>>>>>>+>]<
]<[-]<<<<<<<++<+++<+++[
  [>]>>>>>>++++++++[<<++++>++++++>-]<-<<[-[<+>>.<-]]<<<<[
    -[-[>+<-]>]>>>>>[.[>]]<<[<+>-]>>>[<<++[<+>--]>>-]
    <<[->+<[<++>-]]<<<[<+>-]<<<<
  ]>>+>>>--[<+>---]<.>>[[-]<<]<
]
[Enter a number using ()-./0123456789abcdef and space, and hit return.]
```

**Note**, other brainfuck examples are available [here](http://www.hevanet.com/cristofd/brainfuck/).

The exercise consists in writing a «interpreter» by using the parser combinators technique.