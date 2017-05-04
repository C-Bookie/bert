
-module(nuron).
-compile(export_all).

-define(FIRET, 5).%1000/200
-define(COOLT, 1000).
-define(THRESH, 30).


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
			nuron(N, 0, 0, spawn_link(?MODULE,boomerang, []))
	end.

%nuron(Nurons, Charge, Hot, Boomerang)
nuron(N, C, H, B) when C >= ?THRESH andalso H==0->
	B!{?FIRET, self()},
	receive
		{continue} ->
			ok
	end,
	fireNuron(N),
	B!{?COOLT, self()},
	nuron(N, 0, 1, B);
nuron(N, C, H, B) ->
	receive
		{h, S} ->
			nuron(N, C+S, H, B);
		{continue} ->
			nuron(N, C, 0, B);
		{get, P} ->
			P!H,
			nuron(N, C, H, B)
	end.

fireNuron([]) ->
	ok;
fireNuron([{N, S}|Ns]) ->
	N!{h, S},
	fireNuron(Ns).
