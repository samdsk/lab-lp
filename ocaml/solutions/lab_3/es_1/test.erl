-module(test).
-export([test_is_palindrome/0, test_is_an_anagram/0, test_factors/0, test_is_perfect/0]).

test(F, L) ->
  lists:foreach(
     fun (X) -> io:format("~p :- ~p~n", [X, F(X)]) end, 
     L). 

test_is_palindrome() -> 
  test(
    fun sequential:is_palindrome/1, 
    ["detartrated", "Do geese see God?", "Rise to vote, sir."]).

test_is_an_anagram() ->
  test(
    fun (X) -> sequential:is_an_anagram(X, 
      ["tar", "rat", "arc", "car", "elbow", "below", "state", "taste", 
       "cider", "cried", "dusty", "study", "night", "thing", "inch", 
       "chin", "brag", "grab", "cat", "act", "bored", "robed", "save", 
       "vase", "angel", "glean", "stressed", "desserts"]) end,  
    ["rat", "stressed", "elbow", "house", "thing", "desserts", "teaching"]).

test_factors() ->
  test(
    fun sequential:factors/1,
    [25, 400, 1970, 42, 32523, 7, 534587]).

test_is_perfect() ->
  test(
    fun sequential:is_perfect/1, 
    [6, 7, 28, 41, 100, 496, 500, 8128]
).
