%%%-------------------------------------------------------------------
%%% @author QiLi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. feb 2017 10:49
%%%-------------------------------------------------------------------
-module(color).
-author("QiLi").

%% API
%%-export([convert/2]).
-compile(export_all).

%%-record(color,{x,r,g,b}).

convert(Depth,Max) ->
  F = Depth / Max,
  A=F*4,
  X= trunc(A),
  Y= trunc(255*(A-X)),
  case X of
    0 -> {Y, 0, 0};
    1 -> {255, Y, 0};
    2 ->{255-Y, 255, 0};
    3 -> {0, 255, Y };
    4 -> {0, 255-Y, 255}
  end.