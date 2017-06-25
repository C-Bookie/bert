
%insufficient erlport documentation

-module(screen).
-compile(export_all).

init() ->
  {ok, P} = python:start_link([{python_path, "./python/"}]),
%  {ok, P} = python:start([{python, "python3"}]),
%  {ok, P} = python:start_link(),
  wait(),
  python:call(P, builtins, print, [<<"Hello, World!">>]),
  wait(),
  io:fwrite(python:call(P, screen, moo, [])),
%  io:fwrite(python:call(P, '3d_box', moo, [])),
%  io:fwrite(python:call(P, 'demo_opts', get_device, [])),
  io:fwrite(python:call(P, screen, register_handler, [self()])),
  wait(),
%  io:fwrite(python:cast(P, test_message)),

  wait(),
  {ok, Dir}=file:get_cwd(),
  io:fwrite(Dir).

wait() ->
  receive
  after 1000 ->
    ok
  end.