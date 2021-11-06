# Exercise 5: Playing around with Strings.

* Define the following functions/operators on strings:

1.    `is_palindrome`: `string → bool` that checks if the string is palindrome, a string is palindrome when the represented sentence can be read the same way in either directions in spite of spaces, punctual and letter cases, e.g., detartrated, "Do geese see God?", "Rise to vote, sir.", ...
2.    `operator (-)`: `string → string → string` that subtracts the letters in a string from the letters in another string, e.g., `"Walter Cazzola"-"abcwxyz"` will give `"Wlter Col"` note that the operator - is case sensitive
3.    `anagram `: `string → string list → boolean` that given a dictionary of strings, checks if the input string is an anagram of one or more of the strings in the dictionary
