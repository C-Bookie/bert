
-module(main).
-compile(export_all).
%-include("util.erl").

moo() ->
  game:moo(),
  ok.

run() ->
  N=util:makeNurons("./maps/bert.map"),
%  N=util:makeNurons("./maps/small.map"),
  io:fwrite("started, press enter to stop shocking and again to end~n"),
	S=spawn(input, shock, [N]),
%	spawn_link(paint, pulse, [N, 0]),
  register(bert, spawn_link(game, graph, [N])),
  io:get_line(""),
  exit(S, "shock stopped"),
  io:get_line(""),
  exit("ended").






