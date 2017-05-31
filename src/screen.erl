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
  {ok, P} = python:start_link([{python_path, "python/"}]),
%  {ok, P} = python:start([{python, "python3"}]),
%  {ok, P} = python:start_link(),
  wait(),
  python:call(P, builtins, print, [<<"Hello, World!">>]),
  wait(),
  io:fwrite(python:call(P, screen, moo, [])),
  wait(),
  {ok, Dir}=file:get_cwd(),
  io:fwrite(Dir).

wait() ->
  receive
  after 1000 ->
    ok
  end.