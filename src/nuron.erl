
-module(nuron).
-compile(export_all).

-define(FIRET, 5).%1000/200
-define(COOLT, 10).
-define(THRESH, 30).


%https://gist.github.com/DimitryDushkin/5532071 {
%-spec get_timestamp() -> integer().
%get_timestamp() ->
%  {Mega, Sec, Micro} = os:timestamp(),
%  (Mega*1000000 + Sec)*1000 + round(Micro/1000).
%}

spawn_nurons(-1, R) ->
	R;
spawn_nurons(I, R) ->
	spawn_nurons(I-1, R++[spawn_link(?MODULE, nuron_sb, [])]).

nuron_sb() ->
	receive
    {s, N} ->
			nuron(N, 0, 0)
	end.

<<<<<<< Updated upstream
%nuron(Nurons, Charge, Hot, CoolTime)
nuron(N, C, H, _CT, T, I) when C >= ?THRESH andalso H==0->
  T!get_timestamp()+?FIRET,
%  fireSynaps(N),
	nuron(N, C, 1, get_timestamp()+?COOLT, T, I+1);
nuron(N, C, H, CT, T, I) ->
  A=gt(H, CT-get_timestamp()),
=======
%nuron(Nurons, Charge, I-count)
nuron(N, C, I) when C >= ?THRESH->
  timer:sleep(?FIRET),
  fireSynaps(N),
  timer:sleep(?COOLT),
  clear(N, 0, I+1);
nuron(N, C, I) ->
>>>>>>> Stashed changes
	receive
		{h, S} ->
			nuron(N, C+S, I);
		{get, P} ->
			P!I,
    nuron(N, C, 0)
	end.

gt(A) when A > 0 ->
  A;
gt(_A) ->
  0.

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
