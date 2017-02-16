%%%-------------------------------------------------------------------
%%% @author QiLi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. feb 2017 12:17
%%%-------------------------------------------------------------------
-module(mandel).
-author("QiLi").

%% API
-export([demo/0]).
%%-compile(export_all).

mandelbrot(Width, Height, X, Y, K, Depth) ->
  Trans = fun(W, H) ->
    cmplx:new(X + K*(W-1), Y-K*(H-1))
          end,
  rows(Width, Height, Trans, Depth, []).

row(Width, Height, Trans, Depth, L)->
 W= color:convert(brot:mandelbrot(Trans(Width,Height),Depth),255),
  if
     Width/=0 -> row(Width-1, Height, Trans, Depth,[W|L]);
    true -> L
  end.

rows(Width, Height, Trans, Depth, L) ->
  K=row(Width, Height, Trans, Depth, []),
  if
    Height /=0 ->rows(Width, Height-1, Trans, Depth,[K|L]);
    true -> L
  end
.
demo() ->
  small(-2.6,1.2,1.6).
small(X,Y,X1) ->
  Width = 960,
  Height = 540,
  K = (X1 - X)/Width,
  Depth = 64,
  T0 = erlang:timestamp(),
  Image = mandelbrot(Width, Height, X, Y, K, Depth),
  T = timer:now_diff(erlang:timestamp(), T0),
  io:format("picture generated in ~w ms~n", [T div 1000]),
  ppm:write("small.ppm", Image).
