-module(print).

-export([start/3]).

start(File, Width, Height) ->
  Pid = spawn(fun() -> init(File, Width, Height) end),
  {ok, Pid}.

init(File, Width, Height) ->
  {ok, Fd} = file:open(File, [write]),
  io:format(Fd, "P6~n", []),
  io:format(Fd, "#~s~n", ["generated by ppm.erl"]),
  io:format(Fd, "~w ~w~n", [Width, Height]),
  io:format(Fd, "255~n", []),
  rows(Height, 1, Width, Fd),
  io:format("image ~s printed~n", [File]),
  file:close(Fd).

rows(0, _, _, _Fd) ->
  ok;
rows(H, N, W, Fd) ->
  receive
    {row, N, Row} ->
      Chars = row(Row),
      io:put_chars(Fd, Chars),
      rows(H - 1, N + 1, W, Fd)
  after 20000 ->
    Black = lists:foldl(fun(_, A) -> [0, 0, 0 | A] end, [], lists:seq(1, W)),
    io:put_chars(Fd, Black),
    rows(H - 1, N + 1, W, Fd)
  end.

row(Row) ->
  lists:foldr(fun({R, G, B}, A) ->
    [R, G, B | A] end,
    [], Row).







    
