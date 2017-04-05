%%%-------------------------------------------------------------------
%%% @author QiLi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. mar 2017 12:17
%%%-------------------------------------------------------------------
-module(type).
-author("QiLi").


%% API
-compile(export_all).
%%-type string() :: [char()]|{'string',string(),string()}.
%%-type card() :: {card,char(),number()}.
%%-spec concat(string(),string())-> {string,_,_}.

%%concat(S1,S2) ->
%%  {string,S1,S2}.
%%
%%triss([]) ->
%%  [];
%%triss([{card,_,V}|T])->
%% case  list:filter(fun({card,_,N}) -> V =N end, T)of
%%   [_,_|_] -> true;
%%   _Else -> triss(T)
%% end.
%%
%%msort([]) -> [];
%%msort(A) ->
%%  {L1, L2} = split(A),
%%  merge(msort(L1), msort(L2)).
%%
%%
%%merge([],T2) ->
%%  T2;
%%merge(T1,[])->
%%  T1;
%%merge([H1|T1]=L1,[H2|T2]=L2)->
%%  if
%%    H1<H2 ->[H1|merge(T1,L2)] ;
%%    true -> [H2|merge(L1,T2)]
%%  end.
%%
%%
%%
%%reduce([]) ->
%%  [];
%%reduce([H|[]]) ->
%% [H]
%%;
%%reduce([H1,H2|T]) ->
%%  if
%%   H1==H2  ->reduce([H1|T]) ;
%%    true -> [H1|reduce([H2|T])]
%%  end.
%%
%%reduce2([]) ->
%%  [];
%%reduce2([H,H|T])->
%%reduce2([H|T]);
%%
%%reduce2([H|T])->
%%[H|reduce2(T)].
%%
%%
%%encode([])->
%%  [];
%%encode([32|T]) ->
%%  [32|encode(T)];
%%encode([H|T])when H-3<97 ->
%%  [122-(96-(H-3))|encode(T)];
%%encode([H|T]) ->
%%  [H-3|encode(T)].
%%
%%print(L)->
%%  io:format(encode(L)++" \r\n").
%%
%%heap_to_list(nil) ->[];
%%heap_to_list({heap,E,Left,Right}) ->
%%  L=heap_to_list(Left),
%%  R=heap_to_list(Right),
%%  %%SPLIT
%%  [E|merge(L,R)].
%%
%%pop(nil)->false;
%%pop({heap,V,L,nil})->
%%  {ok,V,L};
%%pop({heap,V,nil,R})->
%%  {ok,V,R};
%%pop({heap,V,L,R})->
%%  {heap,VL,_,_}=L,
%%{heap,VR,_,_ }=R,
%%  if
%%    VL<VR -> if
%%               VL>V -> {ok,VL,Rest}=pop(L),{ok,V,{heap,VL,Rest,R}};
%%               true ->err
%%             end;
%%    true ->{ok,VR,Rest}=pop(R),{ok,V,{heap,VR,L,Rest}}
%%  end.

new(Value) ->
  spawn(fun() -> cell(Value) end).


cell(Old) ->
  receive
    {swap, New, From} ->
      From ! {ok, Old},
      cell(New);
    {set, New} ->
      cell(New);
      {check,From}->
     From!{ok,Old}
  end.


 creat()->
   new(open).

lock(Cell) ->
  Cell!{swap,lock,self()},
  receive
    {ok,open}->
      ok;
    {ok,lock}->
     fail
  end.
 release(Cell) ->
   Cell!{set,open},ok.


server()->
  newserver(10).

client(Server)->
  Server!{request,self()},
  receive
    {granted,H}->lock(H);
    fail -> fail
  end.

newserver(T)->
  PidL=generate(T,[]),
  spawn(fun()->(PidL) end).

generate(T,L)->
  Pid=spawn(fun()->cell(open) end),
  if
    T==0 -> [Pid|L];
    true -> [Pid|generate(T-1,L)]
  end.

semaphor(PidL)->
  receive
    {request,From}->
      case checklock(PidL,0,PidL) of
        {ok,H}-> From!{granted,H};
        {fail,critical}-> From!fail
      end

  end.

checklock([],10,_)->{fail,critical};
checklock([],N,PidL)-> checklock(PidL,N+1,PidL);
checklock(PidL,N,Origin)->
  [H|T]=PidL,
  case trylock(H) of
    ok ->{ok,H};
    fail -> checklock(T,N,Origin)
  end.

trylock(H)->
 case check(H) of
   ok -> ok;
   fail->fail
 end.



    check(Cell) ->
    Cell!{check,self()},
    receive
      {ok,open}->
        ok;
      {ok,lock}->
        fail
    end.


do()->
  integer_to_list(L).