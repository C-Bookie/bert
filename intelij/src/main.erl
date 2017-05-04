
-module(main).
-compile(export_all).

run() ->
	N=util:makeNurons("./maps/bert.map"),
    io:fwrite("started, press enter to end~n"),
	S=spawn(input, shock, [N]),
	spawn_link(paint, pulse, [N, 0]),
    io:get_line(""),
    io:fwrite("shock stopped~n"),
    exit(S, "shock stopped"),
    io:get_line(""),
    exit("ended").






