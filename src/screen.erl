%%%-------------------------------------------------------------------
%%% @author duck-
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. May 2017 19:26
%%%-------------------------------------------------------------------
-module(screen).
-author("duck-").

%% API
-compile(export_all).

init() ->
  %{ok, P} = python:start([{python_path, "/path/to/my/modules"}, {python, "python3"}]),
  {ok, P} = python:start_link(),
  wait(),
  python:call(P, builtins, print, [<<"Hello, World!">>]),
  wait().

wait() ->
  receive
  after 1000 ->
    ok
  end.