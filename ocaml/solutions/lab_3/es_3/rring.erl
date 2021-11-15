-module(rring).
-export([start/3, create/3]).

start(M, N, Msg) ->
  register(rring_fst, spawn(?MODULE, create, [N, 1, self()])),
  io:format("*** [rring_fst] is at ~p~n", [whereis(rring_fst)]),
  receive
    ready      -> ok
    after 5000 -> exit(timeout)
  end,
  msg_dispatcher(M, 1, Msg),
  rring_fst!stop,
  ok.

msg_dispatcher(M, M, Msg) -> rring_fst!{Msg, M, 1}; 
msg_dispatcher(M, N, Msg) -> rring_fst!{Msg, N, 1}, msg_dispatcher(M, N+1, Msg).

create(1, Who, Starter) ->
  Starter ! ready,
  io:format("*** created [~p] as ~p connected to ~p~n", [self(), Who, rring_fst]),
  loop_last(rring_fst, Who);
create(N, Who, Starter) ->
  Next = spawn(?MODULE, create, [N-1, Who+1, Starter]),
  io:format("*** created [~p] as ~p connected to ~p~n", [self(), Who, Next]),
  loop(Next, Who).

loop(Next, Who) ->
  receive
    {Msg, N, Pass}=M ->
        io:format("[~p] Got {~p ~p} for the ~p time~n", [Who, Msg, N, Pass]),
        io:format("*** [~p] is ~p alive? ~p~n", [Who, Next, erlang:is_process_alive(Next)]),
        Next ! {Msg, N, Pass},
        io:format("*** [~p] sent ~p to [~p]~n", [Who, M, Next]),
        loop(Next, Who);
    stop ->
        io:format("[~p] Got {stop}~n", [Who]),
        io:format("*** [~p] is ~p alive? ~p~n", [Who, Next, erlang:is_process_alive(Next)]),
        Next ! stop,
        io:format("*** [~p] sent {stop} to [~p]~n", [Who, Next]),
        io:format("# Actor ~p stops.~n", [Who]);
    Other -> io:format("*** Houston we have a problem: ~p~n", [Other])
  end.

loop_last(Next, Who) ->
  receive
    {Msg, N, Pass}=M ->
        io:format("[~p] Got {~p ~p} for the ~p time [loop_last]~n", [Who, Msg, N, Pass]),
        io:format("*** [~p] is ~p alive? ~p [loop_last]~n", [Who, Next, erlang:is_process_alive(whereis(Next))]),
        Next ! {Msg, N, Pass+1},
        io:format("*** [~p] sent ~p to [~p] [loop_last]~n", [Who, M, Next]),
        loop_last(Next, Who);
    stop ->
        io:format("[~p] Got {stop} [loop_last]~n", [Who]),
        exit(normal),
        unregister(rring_fst),
        io:format("*** [~p] unregistered [~p]~n", [Who, rring_fst]),
        io:format("# Actor ~p stops [loop_last].~n", [Who]);
    Other -> io:format("*** Houston we have a problem: ~p~n", [Other])
  end.
