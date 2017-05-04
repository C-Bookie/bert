-module(util).
-compile(export_all).

l_run() ->
	{ok, File1} = file:open("list-old", [read]),
	{ok, File2} = file:open("list", [append]),
	try l_get_all_lines(File1, File2, 0)
		after
			file:close(File1),
			file:close(File2)
	end,
	done.

l_get_all_lines(File1, File2, I) ->
	case io:get_line(File1, "") of
		eof  ->
			[];
		Line ->
			R=l_process(Line, I),
			E=file:write(File2, R++io_lib:nl()),
			case E of
				ok ->
					l_get_all_lines(File1, File2, I+1);
				{error, Reason} ->
					io:fwrite(Reason)
			end
	end.

l_process(Str, I) ->
	{_, Rest1} = lists:split(10, Str),
	{A, Resr2}=l_getName(Rest1, []),
	B=l_getNum(Resr2, []),
	l_checkP(B, I),
	A.

l_getName([$=|Rest], R) ->
	{R, Rest};
l_getName([X|Rest], R) ->
	l_getName(Rest, R++[X]).

l_getNum([$;|_], R) ->
	list_to_integer(R);
l_getNum([X|Rest], R) ->
	l_getNum(Rest, R++[X]).

l_checkP(B, I) when B==I ->
	ok;
l_checkP(B, I) ->
	io:fwrite(integer_to_list(B)++", "++integer_to_list(I)++"fucked up~n").









m_run() ->
	{ok, File1} = file:open("map-old", [read]),
	{ok, File2} = file:open("map", [append]),
	{ok, File3} = file:open("list", [read]),

	N=lst(File3, []),

	file:close(File3),
	try m_get_all_lines(File1, File2, -1, 0, N)	%-1 because +1 error
		after
			file:close(File1),
			file:close(File2)
	end,
	done.

m_get_all_lines(File1, File2, Io, So, N) ->
	case So of
		1 ->
			I = Io+1;
		_ ->
			I = Io
	end,
	case io:get_line(File1, "") of
		eof  ->
			ok;
		Line ->
			{R,S}=m_process(So, Line, I, N),
			m_write_list(R, File2),
			m_get_all_lines(File1, File2, I, S, N)
	end.

m_write_list([], _) ->
	ok;
m_write_list([X|Xs], File) ->
			E=file:write(File, X++io_lib:nl()),
		case E of
			{error, Reason} ->
				io:fwrite(Reason);
			ok ->
				m_write_list(Xs, File)
		end.



m_process(0, [${|_], _, _) ->
	{[], 1};
m_process(_, [$}|_], _, _) ->
	{["-"], 0};
m_process(1, [${|Str], I, N) ->
	{A,B}=m_ext(Str),
	io:fwrite(integer_to_list(I)++" not fucked up~n"),
	m_checkO(A, getAddressB(N, I)),
	m_checkP(B, 0),
	{[integer_to_list(I)],2};
m_process(2, [${|Str], _, N) ->
	{A,B}=m_ext(Str),
	{[integer_to_list(getAddress(A, N, 0))++"="++integer_to_list(B)],2}.

getAddress(A, [], _) ->
	io:fwrite(A++" not found=fucked up~n"),
	fek;
getAddress(A, [X|_], I) when A==X ->
	I;
getAddress(A, [_|Xs], I) ->
	getAddress(A, Xs, I+1).

getAddressB([], _) ->
	io:fwrite("something not found=fucked up~n"),
	fek;
getAddressB([X|_], 0)->
	X;
getAddressB([_|Xs], I) ->
	getAddressB(Xs, I-1).

m_ext(Str) ->
	{A, Rest}=m_getName(Str, []),
	B=m_getNum(Rest, []),
	{A,B}.

m_getName([$,|Xs], R) ->
	{R, Xs};
m_getName([X|Xs], R) ->
	m_getName(Xs, R++[X]).

m_getNum([$}|_], R) ->
	list_to_integer(R);
m_getNum([X|Xs], R) ->
	m_getNum(Xs, R++[X]).

m_checkP(B, I) when B==I ->
	ok;
m_checkP(B, I) ->
	io:fwrite(integer_to_list(B)++", "++integer_to_list(I)++"fucked up~n").

m_checkO(B, I) when B==I ->
	ok;
m_checkO(B, I) ->
	io:fwrite(B++", "++I++"fucked up~n").


lst(File, R) ->
	case io:get_line(File, "") of
		eof  ->
			R;
		Line ->
			lst(File, R++[cut_end(Line)])
	end.

cut_end(Xs) ->
	A=flip(Xs, []),
	flip(cut_end2(A), []).

cut_end2([_|Xs]) ->
	Xs.

flip([], Rs) ->
	Rs;
flip([X|Xs], Rs) ->
	flip(Xs, [X]++Rs).


