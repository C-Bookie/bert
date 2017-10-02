
-module(paint).
-compile(export_all).

pulse(N, I) ->
  io:fwrite("~p "++printBlock(getData(N, [], getI), 0, []), [I]),
  io:fwrite("~p "++printBlock(getData(N, [], getC), 0, []), [I]),
%  io:format("~p~n", [getData(N, [])]),
  timer:sleep(1000),
	pulse(N, I+1).

getData([], R, _M) ->
  R;
getData([N|Ns], R, M) ->
  N!{M, self()},
  receive
    X ->
      getData(Ns, [X|R], M)
  end.

printLine(_, [], R, S) ->
  {S, R};
printLine(0, [X|Xs], R, _S) ->
  A = integer_to_list(X),
  if
    X==0 ->
      printLine(0, Xs, R++"_", true);
    true ->
      printLine(0, Xs, R++[util:get(A, 0)], true)
  end;
printLine(I, [X|Xs], R, S) ->
  A = integer_to_list(X),
  if
    length(A)=<I ->
      printLine(I, Xs, R++" ", S);
    true ->
      printLine(I, Xs, R++[util:get(A, I)], true)
  end.

printBlock(Xs, I, R) ->
  {C, L} = printLine(I, Xs, [], false),
  if
    C ->
      printBlock(Xs, I+1, R++L++"~n");
    true ->
      R
  end.

blip(0, fill) ->
  {fill, false};
blip(X, _fill) ->
  {integer_to_list(X), true}.



