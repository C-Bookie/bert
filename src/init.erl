
-module(init).
-compile(export_all).

makeNurons(File) ->
	N=nuron:spawn_nurons(397, []),
	io:fwrite("nurons:~n~p~n", [N]),
   {ok, Device} = file:open(File, [read]),
    try util:get_all_lines(Device, 1, N, [], 0)
      after file:close(Device)
    end,
    N.

get_all_lines(File1, So, N, R, I) ->
	case io:get_line(File1, "") of
		eof  ->
			ok;
		Line ->
			case m_process(So, cut_end(Line)) of
				{0} ->
					util:get(N, I)!R,
					get_all_lines(File1, 1, N, [], I+1);
				{1, Str} ->
					get_all_lines(File1, 2, N, R, Str);
				{2, A, B} ->
					get_all_lines(File1, 2, N, R++[{getFromList(N, A), B}], I);
				{3} ->
					ok
			end
	end.

m_process(_, [$+|_]) ->
	{3};
m_process(_, [$-|_]) ->
	{0};
m_process(1, Str) ->
	{1, list_to_integer(Str)};
m_process(2, Str) ->
	{A,B}=get_a(Str, []),
	{2, list_to_integer(A), list_to_integer(B)}.

get_a([$=|Xs], R) ->
	{R, Xs};
get_a([X|Xs], R) ->
	get_a(Xs, R++[X]).

getFromList([X|_], 0) ->
	X;
getFromList([_|Xs], I) ->
	getFromList(Xs, I-1).

cut_end(Xs) ->
	A=flip(Xs, []),
	flip(cut_end2(A), []).

cut_end2([_|Xs]) ->
	Xs.

flip([], Rs) ->
	Rs;
flip([X|Xs], Rs) ->
	flip(Xs, [X]++Rs).
