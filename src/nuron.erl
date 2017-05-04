
-module(nuron).
-compile(export_all).

spawn_nurons(-1, R) ->
	R;
spawn_nurons(I, R) ->
	spawn_nurons(I-1, R++[spawn_link(?MODULE, nuron_sb, [])]).


boomerang() ->
	receive
		{T, P} ->
			timer:sleep(T),
			P!{continue}
	end,
	boomerang().

nuron_sb() ->
	receive
		N ->
			nuron(N, 0, 30, 0, spawn_link(?MODULE,boomerang, []))
	end.

nuron(N, C, T, H, B) when C > T andalso H==0->
	B!{50, self()},
	receive
		{continue} ->
			ok
	end,
	fireNuron(N),
	B!{5000, self()},
	nuron(N, 0, T, 1, B);
nuron(N, C, T, H, B) ->
	receive
		{h, S} ->
			nuron(N, C+S, T, H, B);
		{continue} ->
			nuron(N, C, T, 0, B);
		{get, P} ->
			P!H,
			nuron(N, C, T, H, B)
	end.

fireNuron([]) ->
%	io:fwrite("~p", [self()]),
	done;
fireNuron([{N, S}|Ns]) ->
	N!{h, S},
	fireNuron(Ns).
