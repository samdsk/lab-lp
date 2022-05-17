A KeWord In Context (KWIC) index is a simple index for a list of lines or titles. This assignment involves creating a KWIC index for an input list of titles stored in a file. Here's a small example. For the input file:

```
[02:34]cazzola@hymir:~/lp/scala>cat kwic.txt
My Big Fat Greek Wedding
One Flew Over the Cuckoo's Nest
Star Wars: Revenge of the Sith
Everything You Always Wanted To Know About Sex But Were Too Afraid To Ask
Borat: Cultural Learnings of America for Make Benefit Glorious Nation of Kazakhstan
```

```
[02:36]cazzola@hymir:~/lp/scala>scala KWIC kwic.txt
   4 ed To Know About Sex But Were Too Afraid To Ask                           
   4                    Everything You Always Wanted To Know About Sex But Were
   5      Borat: Cultural Learnings of America for Make Benefit Glorious Nation
   4  About Sex But Were Too Afraid To Ask                                     
   5 ral Learnings of America for Make Benefit Glorious Nation of Kazakhstan   
   1                                My Big Fat Greek Wedding                   
   5                                   Borat: Cultural Learnings of America for
   2                 One Flew Over the Cuckoo's Nest                           
   5                            Borat: Cultural Learnings of America for Make B
   4                                   Everything You Always Wanted To Know Abo
   1                            My Big Fat Greek Wedding                       
   2                               One Flew Over the Cuckoo's Nest             
   5 nings of America for Make Benefit Glorious Nation of Kazakhstan           
   1                        My Big Fat Greek Wedding                           
   5 r Make Benefit Glorious Nation of Kazakhstan                              
   4   Everything You Always Wanted To Know About Sex But Were Too Afraid To As
   5                   Borat: Cultural Learnings of America for Make Benefit Gl
   5 Cultural Learnings of America for Make Benefit Glorious Nation of Kazakhst
   1                                   My Big Fat Greek Wedding                
   5 America for Make Benefit Glorious Nation of Kazakhstan                    
   2        One Flew Over the Cuckoo's Nest                                    
   2                                   One Flew Over the Cuckoo's Nest         
   3                        Star Wars: Revenge of the Sith                     
   4 g You Always Wanted To Know About Sex But Were Too Afraid To Ask          
   3         Star Wars: Revenge of the Sith                                    
   3                                   Star Wars: Revenge of the Sith          
   4 Wanted To Know About Sex But Were Too Afraid To Ask                       
   4             Everything You Always Wanted To Know About Sex But Were Too Af
   3                              Star Wars: Revenge of the Sith               
   1                  My Big Fat Greek Wedding                                 
   4 ways Wanted To Know About Sex But Were Too Afraid To Ask                  
   4                        Everything You Always Wanted To Know About Sex But
   ```

   As you can see, each title is listed for each word (omitting some minor words). The titles are arranged so that the word being indexed is shown in a column on the page. The position the lines have in the input file is shown on the left in the result.

Your solution should follow the following rules:

*    The input is just a series of titles, one per line. Any leading or trailing spaces should be removed. Internal spaces should be retained (trimmed to one).
*    A word is a maximal sequence of non-blank characters.
*    The output line is at most 79 characters wide.
    *    The number is 4 characters wide, right-justified.
    *    There is a space after the number.
    *    The key word starts at position 40 (numbering from 1).
    *    If the part of the title left of the keyword is longer than 33, trim it (on the left) to 33.
    *    If the part of the keyword and the part to the right is longer than 40, trim it to 40.
*    Each title appears in the output once for each word that isn't minor. Any article, conjunction and preposition is minor, e.g., and, to, and the words are minor words.
*    If a title has a repeated word, it should be listed for each repetition.
*    Sorting should be case-insensitive.
