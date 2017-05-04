
-module(main).
-compile(export_all).

-spec run() -> any().
run() ->
	N=util:makeNurons("./maps/bert"),
    io:fwrite("started, press enter to end~n"),
	S=spawn(input, shock, [N]),
	spawn_link(print_brain, pulse, [N, 0]),
    io:get_line(""),
    io:fwrite("~nshock stopped~n~n"),
    exit(S, "shock stopped"),
    io:get_line(""),
    exit("ended").






