-module(test).
-export([test/0]).


test() ->
    joseph:joseph(30,3),
    joseph:joseph(300,1001),
    joseph:joseph(3000,37),
    joseph:joseph(26212,2025),
    joseph:joseph(1000,1000),
    joseph:joseph(2345,26212),
    joseph:joseph(100000,7).