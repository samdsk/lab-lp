-module(es1).
-compile(export_all).


squared_int(L) ->
    [X*X||X<-L, is_integer(X)].

intersect(L1,L2) ->
    [X || X <- L1, lists:member(X, L2)].

symmetric_difference(L1,L2) ->
    [X || X<-L1, not lists:member(X, L2)]++[X || X<-L2, not lists:member(X, L1)].