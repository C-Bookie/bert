
-module(input).
-compile(export_all).

shock(N) ->
	util:get(N, round(rand:uniform()*397))!{h, 10},
	timer:sleep(10),
	shock(N).
