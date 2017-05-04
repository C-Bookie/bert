
-module(paint).
-compile(export_all).

pulse(N, I) ->
	io:fwrite("~p ~s~n", [I, printSnapShot(N, [])]),
    timer:sleep(1000),
	pulse(N, I+1).

printSnapShot([], R) ->
	R;
printSnapShot([N|Ns], R) ->
	N!{get, self()},
	receive
		X ->
			X
	end,
	printSnapShot(Ns, R++blip(X)).

blip(0) ->
	"_";
blip(X) ->
  integer_to_list(X).