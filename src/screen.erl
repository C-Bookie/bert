%%%-------------------------------------------------------------------
%%% @author duck-
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. May 2017 19:26
%%%-------------------------------------------------------------------
-module(screen).
-author("duck-").

%% API
-compile(export_all).

init() ->
  {ok, P} = python:start().
