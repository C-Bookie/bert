
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
  timer:sleep(?FIRET),
  fireSynaps(N),
  timer:sleep(?COOLT),
  clear(N, 0, I+1);
nuron(N, C, I) ->
	receive
		{h, S} ->
			nuron(N, C+S, I);
		{get, P} ->
			P!C,
	    nuron(N, C, 0)
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
