%%%-------------------------------------------------------------------
%%% @author QiLi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. feb 2017 00:08
%%%-------------------------------------------------------------------
-module(philosopher).
-author("QiLi").

%% API
%%-export([]).
-compile(export_all).

sleep(T,D)->
timer:sleep(rand:uniform(T) + rand:uniform(D)).

start(Hungry,Left,Right,Name,Ctrl)->
  spawn_link(fun()->aphil(Hungry,Left,Right,Name,Ctrl) end).

aphil(Hungry,Left,Right,Name,Ctrl) ->
  if
    Hungry ==0 -> io:format("~s is done with process", [Name]),done(Ctrl);
    true ->dreaming(),
      feelshungry(Left,Right,Name,999,Ctrl),
      aphil(Hungry-1,Left,Right,Name,Ctrl)
  end.

done(Ctrl) ->
  Ctrl!done.


feelshungry(Left,Right,Name,Timeout,Ctrl)->
     case waiting(Left,Right,Name) of
               eat -> eating(Name),
               chopstick:return(Left),
               chopstick:return(Right),
               io:format("~s returned all the chopstick~n", [Name]);
                nochop -> %io:format("~s shit! no chopstick......~n", [Name]),
                  if
                         Timeout ==0 ->io:format("~s : WHERE ARE ALL THE CHOPSTICKS!!!!!~n", [Name]), timeout;
                         true ->feelshungry(Left,Right,Name,Timeout-1,Ctrl)
                       end

                  end.

dreaming()->
sleep(99,999).

waiting(Left,Right,Name)->
case chopstick:request(Left) of
  ok -> case chopstick:request(Right) of
          ok ->io:format("~s received a chopstick~n", [Name]),eat;
            error->nochop
        end;
  error ->nochop
end.

eating(Name)->
  Time = 5,
  nomnomnom(Time,Name).

nomnomnom(Time,Name) ->
  io:format("~s : Nom Nom Nom~n", [Name]),
  if
    Time ==1 -> io:format("~s is done eating!~n", [Name]);
    true ->nomnomnom(Time-1,Name)
  end.