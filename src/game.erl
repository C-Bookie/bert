
-module(game).
-compile(export_all).

moo() ->
  register(bert, self()),
  io:fwrite(node()),
  mmo().

mmo() ->
  receive
    {get, P} ->
%      P!paint:getData(N, []),
      P!8,
      io:fwrite("beep");
    X ->
      io:fwrite(X)
  after 2500 ->
    io:fwrite(net_adm:ping('graph@computer-48')),
    io:fwrite("~n")
 %   io:format("~p~n", [self()]),
  %  io:format("~p~n", [registered()])
  end,
  mmo().

moo2() ->
  register(bert2, self()),
  {bert, 'moo1@computer-48'} ! "moo",
  io:fwrite(node()),
  io:fwrite(whereis('moo1@computer-48')).
%  lp().

lp() ->
  receive
    X ->
      io:fwrite(X)
  after 2500 ->
    io:format("~p~n", [self()]),
    io:format("~p~n", [registered()])
  end,
  lp().



graph(N) ->
  receive
    {getI, P} ->
      P!{ok, [-1|paint:getData(N, [], getI)]};
    {getC, P} ->
      P!{ok, [-1|paint:getData(N, [], getC)]};
    X ->
      io:fwrite(X)
  end,
  graph(N).

