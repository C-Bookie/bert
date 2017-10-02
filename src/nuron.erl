
-module(nuron).
-compile(export_all).

-define(FIRET, 5).%1000/200
-define(COOLT, 10).
-define(THRESH, 30).

spawn_nurons(-1, R) ->
	R;
spawn_nurons(I, R) ->
	spawn_nurons(I-1, R++[spawn_link(?MODULE, nuron_sb, [])]).

nuron_sb() ->
	receive
    {s, N} ->
			nuron(N, 0, 0)
	end.

%nuron(Nurons, Charge, I-count)
nuron(N, C, I) when C < 0->
	nuron(N, 0, I);
nuron(N, C, I) when C >= ?THRESH->
  sleep(N, C, I, ?FIRET),
  fireSynaps(N),
  sleep(N, C, I, ?COOLT),
  clear(N, 0, I+1);
nuron(N, C, I) ->
	receive
		{h, S} ->
			nuron(N, C+S, I);
		{getI, P} ->
			P!I,
			nuron(N, C, 0);
		{getC, P} ->
			P!C,
			nuron(N, C, I)
	end.

sleep(N, C, I, W) ->
	receive
		{get, P} ->
			P!I,
			sleep(N, C, 0, W);	%fixme w = now - then - W
		{getC, P} ->
			P!C,
			sleep(N, C, I, W)	%fixme w = now - then - W
	after W ->
		ok
	end.


fireSynaps([]) ->
	ok;
fireSynaps([{N, S}|Ns]) ->
	N!{h, S},
  fireSynaps(Ns).

clear(N, C, I) ->
  receive
    {h, _} ->
      clear(N, C, I)
    after 0 ->
        nuron(N, C, I)
  end.
