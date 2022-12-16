-module(com).
-export([start/2]).

start(N,M) ->
    spawn(fun()-> 
        process_flag(trap_exit, true),
        register(server,self()),        
        Pids = init_sub_proc(N,M),
        Map = permutations(M,[],Pids),
        io:format("Result: ~p\n",[Map])
end).

init_sub_proc(N,M) ->
   [ spawn_link(gene,start,[N,M,X]) || X <- lists:seq(1, N)].

permutations(_,L,[]) -> L;
permutations(M,L,[H|Pids]) ->    
    H ! {p,L},
    receive 
        {res,Pos,List} -> io:format("Server - Pos: ~p,L: ~p\n",[Pos,List]), permutations(M,List,Pids)
        
   end.
