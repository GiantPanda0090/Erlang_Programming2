%%%-------------------------------------------------------------------
%%% @author QiLi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. jan 2017 19:38
%%%-------------------------------------------------------------------
-module(env).
-author("QiLi").

-compile(export_all).
%% API

new() ->
  nil.
tree({Key,Match},nil,_)->{Key,Match,new(),new()};
tree({Key,Match},{Node,Val,Left,Right},Env)->
  if
    Key==Node ->Env;
    Key<Node ->{Node,Val,tree({Key,Match},Left,Env),Right};
    true -> {Node,Val,Left,tree({Key,Match},Right,Env)}
  end.


add(Id,Str,Env)->
  tree({Id,Str},Env,Env).
addall(Envir)->
  [H|T]=Envir,
  {Key,Val}=H,
  if
    T==[] -> env:add(Key, Val, env:new());
    true -> env:add(Key, Val, addall(T))
  end.

envtoleaf(Env) ->
  {Key,Var}=Env,
  env:add(Key,Var,env:new()).

lookup(Id,Env) ->
fix(Id,Env,Env).

fix(_,nil,_)->{false,false};
  fix(Key,{Node,Val,Left,Right},Env)->
  if
    Key==Node ->{Node,Val};
    Key<Node ->fix(Key,Left,Env);
    true -> fix(Key,Right,Env)
  end.

