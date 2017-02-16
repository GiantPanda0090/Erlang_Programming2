%%%-------------------------------------------------------------------
%%% @author QiLi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. feb 2017 19:08
%%%-------------------------------------------------------------------
-module(brot).
-author("QiLi").

%% API
%%-export([]).
-compile(export_all).

mandelbrot(C,M)->
  Z0 = cmplx:new(0,0),
I = 0,
test(I, Z0, C, M)
.

test(I, Z, C, M) ->
  {Re,Im}=C,
  if
    I>M ->0;
    true -> Zplus = cmplx:add(cmplx:sqr(Z), cmplx:new(Re,Im)),
      case  cmplx:abs(Zplus) >=2of
                true ->I ;
              _Else ->test(I+1, Zplus, C, M)
              end
  end
.
