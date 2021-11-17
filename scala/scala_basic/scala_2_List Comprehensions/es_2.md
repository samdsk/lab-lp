Write the following functions by using list comprehensions:

*    `squared_numbers` that removes all non-numbers from a polymorphic list and returns the resulting list of squared numbers, e.g., `squared_numbers(1 :: "hello" :: 100 :: 3.14 :: ('a'::10::Nil) :: 'c' :: (5,7,'a') :: Nil)` should return `List(1, 10000, 9.8596, List(100), (25,49))`. Note that it recursively applies to substructures.
*    `intersect` that given two generic lists, returns a new list that is the intersection of the two lists (e.g., `intersect(List(1,2,3,4,5), List(4,5,6,7,8))` should return `List(4,5))`.
*    `symmetric_difference` that given two lists, returns a new list that is the symmetric difference of the two lists. For example `symmetric_difference(List(1,2,3,4,5), List(4,5,6,7,8)) should return List(1,2,3,6,7,8)`.
