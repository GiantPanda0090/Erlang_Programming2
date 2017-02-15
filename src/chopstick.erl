%%%-------------------------------------------------------------------
%%% @author QiLi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. feb 2017 13:24
%%%-------------------------------------------------------------------
-module(chopstick).
-author("QiLi").

%% API
-export([start/0,request/1,available/0,gone/0,input/0,return/1,quit/1]).
start() ->
  spawn_link(fun() ->chopstick:available()
             end).

available() ->
  %io:format("Current state available. "),
  receive
    {return,_,Self}->Self!reject,available();
    {request,_,Self}-> Self!granted,gone();
    quit-> ok;
      {_,_,Self}->Self!error,available() %%debug exception
end.

gone() ->
  %io:format("Current state gone. "),
  receive
    {request,_,Self}-> Self!reject,gone();
    {return,_,Self}->Self!return, available();
quit-> ok;
    {_,_,Self} ->Self!error,available() %%debug exception
end.

request(Stick) ->
  Stick!{request,name,self()},
receive
  granted -> ok;
  reject -> error
end.

return(Stick) ->
  Stick!{return,name,self()},
  receive
    return -> ok;
    reject -> io:format("Return rejected"),error
  end.

input() ->
  {ok,Request}=io:fread("/n Request: ","~s"),
  [H|_]=Request,
  list_to_atom(H).



quit(C) ->
  C!quit.