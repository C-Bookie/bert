
-module(screen).
-compile(export_all).

init() ->
  {ok, P} = python:start_link([{python_path, "/home/pi/python/luma.examples/examples"}]),
%  {ok, P} = python:start([{python, "python3"}]),
%  {ok, P} = python:start_link(),
  wait(),
  python:call(P, builtins, print, [<<"Hello, World!">>]),
  wait(),
%  io:fwrite(python:call(P, screen, moo, [])),
  io:fwrite(python:call(P, '3d_box', main, [])),

wait(),
  {ok, Dir}=file:get_cwd(),
  io:fwrite(Dir).

wait() ->
  receive
  after 1000 ->
    ok
  end.