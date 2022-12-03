-module(es2).
-export([]).

parse([H|T],[X|Y]=Stack) -> 
    case H of
        $( -> parse(T, [$( | Stack]);
        $) -> parse(T, );
        $+ -> {plus,parse(T)};
        $- -> {minus,parse(T)};
        $/ -> {division, parse(T)};
        $* -> {mul, parse(T)};
        $~ -> {minus,parse(T)};
        n -> parse(T,[{num, n} | Stack])
end;
parse([]) -> 
