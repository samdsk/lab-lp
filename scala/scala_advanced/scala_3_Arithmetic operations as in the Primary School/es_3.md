Let us consider the possibility to parse and evaluate scripts representing additions and subtractions written as in the primary school.

```
123456 +
123456 +
123456 +
   469 =
--------
370837
```

```
 999999999 +
       100 -
        99 =
------------
1000000000
```

```
    789 -
 234567 +
  20100 +
 109822 -
   7070 =
---------
-110926
```

The rules to consider are:

*    all the figures stand in each own row and are vertically right aligned
*    operators are the last symbol in each row
*    numbers can be negative
*   only one = symbol is admitted and it is in the last row before the result
*   the result is separated from the expression by a dashed row long as the longest row (operator included) and starting from the first column

The script includes both the operation and its expected result, the result of parsing/evaluation such a script should be the validation that the written result is the correct one.