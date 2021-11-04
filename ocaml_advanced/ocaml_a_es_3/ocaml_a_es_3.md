# Exercise 3: Playing with Files and Strings.

A `KeWord` In Context (KWIC) index is a simple index for a list of lines or titles. This assignment involves creating a KWIC index for an input list of titles stored in a file. Here's a small example. For the input file:

    Casablanca

    The Maltese Falcon

    The Big Sleep

your program should produce the output:

    3                              The Big Sleep    .

    1                                  Casablanca   .

    2                      The Maltese Falcon       .

    2                              The Maltese Falcon

    3                          The Big Sleep        .

As you can see, each title is listed for each word (omitting some minor words). The titles are arranged so that the word being indexed is shown in a column on the page. The position the lines have in the input file is shown on the left in the result.

Your solution should follow the following rules:

*    The input is just a series of titles, one per line. Any leading or trailing spaces should be removed. Internal spaces should be retained (trimmed to one).
*    A word is a maximal sequence of non-blank characters.
*    The output line is at most 79 characters wide.
 
    * The number is 5 characters wide, right-justified.
    * There is a space after the number.
    * The key word starts at position 40 (numbering from 1).
    *   If the part of the title left of the keyword is longer than 33, trim it (on the left) to 33.
    *   If the part of the keyword and the part to the right is longer than 40, trim it to 40.
    
*    Each title appears in the output once for each word that isn't **minor**. Any word of length two or less is minor, and and the words are minor words.
*    If a title has a repeated word, it should be listed for each repetition.
*    Sorting should be case-insensitive.
