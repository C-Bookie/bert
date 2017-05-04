
-module(nuron).
-compile(export_all).

-define(FIRET, 5).%1000/200
-define(COOLT, 10).
-define(THRESH, 30).


%https://gist.github.com/DimitryDushkin/5532071 {
-spec get_timestamp() -> integer().
get_timestamp() ->
  {Mega, Sec, Micro} = os:timestamp(),
  (Mega*1000000 + Sec)*1000 + round(Micro/1000).
%}

spawn_nurons(-1, R) ->
	R;
spawn_nurons(I, R) ->
	spawn_nurons(I-1, R++[spawn_link(?MODULE, nuron_sb, [])]).

nuron_sb() ->
	receive
    {s, N} ->
      T=spawn_link(?MODULE, tail, [N]),
      T!0,
			nuron(N, 0, 0, get_timestamp(), T, 0)
	end.

%nuron(Nurons, Charge, Hot, CoolTime)
nuron(N, C, H, _CT, T, I) when C >= ?THRESH andalso H==0->
%  T!get_timestamp()+?FIRET,
%  fireSynaps(N),
	nuron(N, C, 1, get_timestamp()+?COOLT, T, I+1);
nuron(N, C, H, CT, T, I) ->
  A=gt(H, CT-get_timestamp()),
	receive
		{h, S} ->
			nuron(N, C+S, H, CT, T, I);
		{get, P} ->
			P!I,
    nuron(N, C, H, CT, T, 0)
  after A ->
    nuron(N, 0, 0, CT, T, I)
	end.

gt(1, _A) ->
  infinity;
gt(_, A) when A > 0 ->
  A;
gt(_, _A) ->
  0.

tail(N) ->
  receive
    X ->
      timer:sleep(gt(0, X-get_timestamp())),
      fireSynaps(N),
      tail(N)
  end.

fireSynaps([]) ->
	ok;
fireSynaps([{N, S}|Ns]) ->
	N!{h, S},
  fireSynaps(Ns).
