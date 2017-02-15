%%%-------------------------------------------------------------------
%%% @author QiLi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. feb 2017 18:14
%%%-------------------------------------------------------------------
-module(cmplx).
-author("QiLi").

%% API
-compile(export_all).
%%-export([]).

new(Re,Im) ->
  {Re,Im}.

add(A,B) ->
  {Rea,Ima}=A,
  {Reb,Imb}=B,
  {Rea+Reb,Ima+Imb}.

sqr(A)->
  {Re,Im}=A,
  {math:pow(Re,2)+math:pow(Im,2),2*Re*Im}.

abs(A) ->
  {Re,Im}=A,
  math:sqrt(math:pow(Re,2)+math:pow(Im,2)).







