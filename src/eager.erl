%%%-------------------------------------------------------------------
%%% @author QiLi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. feb 2017 16:07
%%%-------------------------------------------------------------------
-module(eager).
-author("QiLi").

%% API
-compile(export_all).

eval_expr({atm,Id},_) ->
{ok,Id};
eval_expr({var,Id},Env) ->
  case Env of
    []->error;
  _Else->{Idt,Var}=Env,
    if
      Idt==Id -> {ok,Var};
      true->error
    end
  end;

eval_expr({cons,First, Second}, Env) ->
  case eval_expr(First,Env) of
error -> error;
{ok,_} ->{_,Var}=eval_expr(First,Env),
case eval_expr(Second,Env) of
error -> error;
{ok, _} ->{_,At}=eval_expr(Second,Env), {ok, {Var,At}}
end
end.


eval_match(ignore, Var, _) ->
{ok, Var};
eval_match({atm, Id}, Var, _) ->
  if
    Id==Var ->{ok, []} ;
    true -> fail
  end;
eval_match({var, Id}, Var, []) ->{ok, env:lookup(Id,env:add(Id, Var, env:new()))};
eval_match({var, Id}, Var, Envir) ->
  Env=env:addall(Envir),
  H=env:lookup(Id,Env),
  {Key,Val}=H,
  if
    Key==Id -> if
                Var ==Val  -> {ok, env:lookup(Id,env:add(Id, Var, Env))};
                 true -> error
               end;
    true ->{ok,env:lookup(Id,env:add(Id, Var, Env))}
  end;

eval_match({cons,Var1 , Var2}, {M1,M2}, Env) ->
  R =eager:eval_match(Var1, M1, Env),
case R of
fail -> fail;
{ok, _} ->{_,NewEnv}=R, case eager:eval_match(Var2, M2,[NewEnv]) of
                          error ->  error;
                          _Else ->{R,eager:eval_match(Var2, M2,[NewEnv])}
                        end
end;
eval_match(_, _, _) ->
fail.
