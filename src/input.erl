
-module(input).
-compile(export_all).

shock(N) ->
	util:get(N, round(rand:uniform()*397))!{h, 30},
%	util:get(N, round(rand:uniform()*1))!{h, 30},
	timer:sleep(1),
	shock(N).
