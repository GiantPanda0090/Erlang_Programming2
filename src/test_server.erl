%%%-------------------------------------------------------------------
%%% @author QiLi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. feb 2017 21:07
%%%-------------------------------------------------------------------
-module(test_server).
-author("QiLi").

%% API
-export([bench/2,start/3]).

%%multi process test (duability)
start(Host,Port,T)->
  spawn(fun()->bench(Host,Port) end),
  if
    T==0 -> spawn(fun()->bench(Host,Port) end);
    true -> start(Host,Port,T-1)
  end .


%%normal test
bench(Host, Port) ->
  Start = erlang:system_time(micro_seconds),
  run(100, Host, Port),
  Finish = erlang:system_time(micro_seconds),
  Finish - Start.
run(N, Host, Port) ->
  if
    N == 0 ->
      ok;
    true ->
      request(Host, Port),
      run(N - 1, Host, Port)
  end.
request(Host, Port) ->
  Opt = [list, {active, false}, {reuseaddr, true}],
  {ok, Server} = gen_tcp:connect(Host, Port, Opt),
  gen_tcp:send(Server, http:get("/index.html",v11)),
  Recv = gen_tcp:recv(Server, 0),
  case Recv of
    {ok, _} ->
      ok;
    {error, Error} ->
      io:format("test: error: ~w~n", [Error])
  end,
  gen_tcp:close(Server).

