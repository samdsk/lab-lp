-module(es3).
-export([start/1,to_worker/2]).

% initialize the system with N workers linked to a controller
start(N) ->
    L = lists:seq(1,N),
    register(controller,spawn(fun ()-> 
        process_flag(trap_exit,true),
        Workers_list = [{X,spawn_link(fun ()-> worker(X) end)} || X <- L],
        controller(Workers_list) end)).

% controller initialize with a tuple list which contains worker id and it's pid
controller(Workers_list) ->
    % io:format("Controller ready \n"),
    receive
        {to_worker,N,_Msg} = M ->
            % io:format("Controller received: to_worker:~p - ~p\n",[N,Msg]),
            {_,Pid} = lists:keyfind(N,1,Workers_list),
            Pid ! {from_controller,M},
            controller(Workers_list);
        {'EXIT',_From,{die,N}} = _M ->
            % io:format("Controller received: exit signal: ~p\n",[M]),
            New_nth_worker = spawn_link(fun()-> worker(N) end),
            % io:format("Controller spawned new worker-~p ~p\n",[N,New_nth_worker]),
            controller(lists:keyreplace(N, 1, Workers_list, {N,New_nth_worker}));
        stop -> 
            unregister(controller),
            exit(normal);
        _Any ->
            % io:format("Controller received unknowned command <<~p>>\n",[Any]),
            controller(Workers_list)
end.

% worker initialized with it's id number N
worker(N) ->
    % io:format("Worker-~p ready\n",[N]),
    receive
        {from_controller,{to_worker,Num,exit}} when Num =:= N -> 
            % io:format("Worker-~p received: exit\n",[N]),
            exit({die,N});
        {from_controller,{to_worker,_Num,_Msg}} = _M ->
            % io:format("Worker-~p received: ~p\n",[N,M]),
            worker(N);          
        _Any -> 
            % io:format("Controller received <<~p>> ready\n",[Any]),
            worker(N)
end.

% sends Msg to Nth worker
to_worker(N,Msg) ->
    controller ! {to_worker,N,Msg}.
