%%%-------------------------------------------------------------------
%%% @author QiLi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. feb 2017 12:17
%%%-------------------------------------------------------------------
-module(mandel).
-author("QiLi").

%% API
-export([demo/0,demo_test/2]).
%%-compile(export_all).



mandelbrot(Width, Height, X, Y, K, Depth, SelfLink) ->
  Trans = fun(W, H) ->
    cmplx:new(X + K*(W-1), Y-K*(H-1))
          end,
  {ok,Link} = server:start(Width, Height, X, Y, K, Depth, "small_test.ppm"),
  rows(Width, Height, Trans, Depth, [], Link),
  Link ! done.

rows(_, 0, _, _, _, _) ->
  ok;
rows(Width, Height, Trans, Depth, L, Link) ->
  spawn_link(fun() -> row(Width, Height, Trans, Depth, [], Link) end),
  rows(Width, Height - 1, Trans, Depth, L, Link).




row(Width, Height, Trans, Depth, L, Link) ->
  W = color:convert(brot:mandelbrot(Trans(Width, Height), Depth), 255),
  if
    Width /= 0 -> row(Width - 1, Height, Trans, Depth, [W | L], Link);
    true -> Link ! {L, Height}
  end.


demo() ->
  small(-2.6,1.2,1.6).

demo_test(Thread,File) ->
  X=-2.6,
  Y=1.2,
  X1=1.6,
  Width = 3840,
  Height = 2160,
  K = (X1 - X)/Width,
  Depth = 1000,
  T0 = erlang:timestamp(),
  {ok,Link} =server:start(Width, Height, X, Y, K, Depth, File,self()),
  concurrent_spawn(Link,Thread),
  receive
  done -> T = timer:now_diff(erlang:timestamp(), T0),
          io:format("picture generated in ~w ms~n", [T div 1000])
  end.

spawn_client(Server) ->
     {ok,Client_Link} = client:start(Server).
     %%Client_Link ! done.

concurrent_spawn(Server,Thread) ->
spawn_client(Server),
if
Thread > 1 -> concurrent_spawn(Server,Thread-1);
true -> ok
end.

small(X,Y,X1) ->
  Width = 480,
  Height = 240,
  K = (X1 - X)/Width,
  Depth = 64,
  T0 = erlang:timestamp(),
  Link = self(),
  %%server:start(Width, Height, X, Y, K, Depth, "small_test.ppm"),
  mandelbrot(Width, Height, X, Y, K, Depth, Link),
  receive
    Image -> T = timer:now_diff(erlang:timestamp(), T0),
      io:format("picture generated in ~w ms~n", [T div 1000]),
      ppm:write("small.ppm", Image)
  end.

