
-module(main).
-compile(export_all).
%-include("util.erl").

moo() ->
  screen:init(),
  ok.

run() ->
  N=util:makeNurons("./maps/bert.map"),
%  N=util:makeNurons("./maps/small.map"),
  io:fwrite("started, press enter to stop shocking and again to end~n"),
	S=spawn(input, shock, [N]),
	spawn_link(paint, pulse, [N, 0]),
  io:get_line(""),
  exit(S, "shock stopped"),
  io:get_line(""),
  exit("ended").






