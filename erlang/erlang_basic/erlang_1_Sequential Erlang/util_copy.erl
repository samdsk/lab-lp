-module(util_copy).
-export([text_filter/1]).

text_filter(S) -> 
    Fc = fun(X) -> 
    case X of
        " " -> "";
        "-" -> "";
        "_" -> "";
        "!" -> "";
        "?" -> "";
        "." -> "";
        "," -> "";
        ":" -> "";
        _ -> X
    end end, lists:map(Fc,S). 