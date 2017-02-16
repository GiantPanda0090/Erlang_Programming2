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
-export([convert/2]).

-record(color,{r,g,b}).

convert(Depth,Max) ->
  F = Depth / Max,
  A=F*4,
  X= trunc(A),
  Y= trunc(255*(A-X)),
  #color{r=Y,g=0,b=0},
  #color{r=255,g=Y,b=0},
  #color{r=255-Y,g=255,b=0},
  #color{r=0,g=255,b=Y},
  #color{r=0,g=255-Y,b=255}.