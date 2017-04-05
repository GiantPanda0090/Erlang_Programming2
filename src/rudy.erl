%%%-------------------------------------------------------------------
%%% @author QiLi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. feb 2017 19:00
%%%-------------------------------------------------------------------
-module(rudy).
-author("QiLi").

%% API
-export([start/0, stop/0]).

start() ->
  Opt = [list, {active, false}, {reuseaddr, true}],
  %%init(8080, Opt).
  register(rudy, spawn(fun() -> init(8080, Opt) end)).

stop() ->
  exit(whereis(rudy), "time to die").


iptrace(Socket) ->
  case inet:peername(Socket) of
    {ok, {Address, Port}} -> io:format("Address ~p,  is asking for request from port  ~p~n", [Address, Port]);
    {error, Error} -> io:format("Error occured in iptrace -  ~p~n ", [Error]), error;
    _Else -> io:format("Exception occured in iptrace")
  end.


init(Port, Opt) ->
  case gen_tcp:listen(Port, Opt) of
    {ok, Socket} ->
      handler(Socket),
      gen_tcp:close(Socket),
      ok;
    {error, Error} ->
      io:format("HTTP ERROR MESSAGE: error opening server socket - ~w~n", [Error]),
      error
  end.

request_con(Socket)->
  %%io:format("A request process has spawned!!!"),
  spawn(fun()->request(Socket) end).

handler(Socket) ->
  case gen_tcp:accept(Socket) of
    {ok, Client} ->
      request_con(Client),
      handler(Socket);
    {error, Error} ->
      io:format("HTTP ERROR MESSAGE: error at handler - ~w~n", [Error]),
      error
  end.

request(Client) ->
  iptrace(Client),
  Recv = gen_tcp:recv(Client, 0),
  case Recv of
    {ok, Packet} ->
      Response = reply(http:parse_request(Packet)),
      gen_tcp:send(Client, Response);
    {error, Error} ->
      io:format("rudy: error: ~w~n", [Error])
  end,
  gen_tcp:close(Client).



reply({{get, URI, Ver}, _, Body,Res,Err}) ->
  timer:sleep(40),
  io:format(http:get(URI,Ver)),
  case Res of
     404 ->Response = http:notfound(Ver,Err);
     200 ->Response = http:ok([], Ver)
end,
  io:format("Reply: " ++ Response),
  http:ok(Body, Ver)
.