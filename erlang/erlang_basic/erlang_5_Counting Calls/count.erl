-module(count).
-export([counter/2]).

counter({S1,S2,S3,Tot},Server) ->
    receive
        {_, print, _} = M -> Server ! M, counter({S1+1,S2,S3,Tot+1},Server);
        {_, sum, _} = M -> Server ! M, counter({S1,S2+1,S3,Tot+1},Server);
        {_, min, _} = M -> Server ! M, counter({S1,S2,S3+1,Tot+1},Server);
        {Pid, tot} -> Pid ! {S1,S2,S3,Tot}, counter({S1,S2,S3,Tot},Server)
end.