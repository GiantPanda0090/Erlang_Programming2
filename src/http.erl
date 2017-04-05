%%%-------------------------------------------------------------------
%%% @author QiLi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. feb 2017 17:44
%%%-------------------------------------------------------------------
-module(http).
-author("QiLi").

%% API
-export([parse_request/1, ok/2, get/2,notfound/2]).

parse_request(R0) ->
  {{get, URI, Ver}, R1} = request_line(R0),
  {Headers, _} = headers(R1),
  {Body, Response,Err} = message_body(URI),
  {{get, URI, Ver}, Headers, Body,Response,Err}.

ok(Body, Version) ->
  case Version of
    v11 -> "HTTP/" ++ "1.1" ++ " 200 OK\r\n" ++ "\r\n" ++ Body;
    v10 -> "HTTP/" ++ "1.0" ++ " 200 OK\r\n" ++ "\r\n" ++ Body
  end.

get(URI, Version) ->
  case Version of
    v11 -> "GET " ++ URI ++ " HTTP/1.1\r\n" ++ "\r\n";
    v10 -> "GET " ++ URI ++ " HTTP/1.0\r\n" ++ "\r\n"
  end.

notfound(Version,Error)->
  Err=atom_to_list(Error),
  case Version of
    v11 -> "HTTP/" ++ "1.1" ++ " 404 Not Found\r\n" ++ "\r" ++"Reason: " ++Err++ "\r\n";
      v10 ->"HTTP/" ++ "1.0" ++ " 404 Not Found\r\n" ++ "\r" ++"Reason: " ++Err++ "\r\n"
  end.

request_line([$G, $E, $T, 32 | R0]) ->
  {URI, R1} = request_uri(R0),
  %%io:format(URI),
  {Ver, R2} = http_version(R1),
  [13, 10 | R3] = R2,
  {{get, URI, Ver}, R3}.

%%request_uri([47 |R0])->
  %%{[], R0};
request_uri([32 | R0]) ->
  {[], R0};
request_uri([C | R0]) ->
  {Rest, R1} = request_uri(R0),
  {[C | Rest], R1}.

http_version([$H, $T, $T, $P, $/, $1, $., $1 | R0]) ->
  {v11, R0};
http_version([$H, $T, $T, $P, $/, $1, $., $0 | R0]) ->
  {v10, R0}.

headers([13, 10 | R0]) ->
  {[], R0};
headers(R0) ->
  {Header, R1} = header(R0),
  {Rest, R2} = headers(R1),
  {[Header | Rest], R2}.

header([13, 10 | R0]) ->
  {[], R0};
header([C | R0]) ->
  {Rest, R1} = header(R0),
  {[C | Rest], R1}.


message_body(URI) ->
  %[File|_]=Headers,
  io:format("Grbbing file :"++filename_p(URI)++" \r\n"),
  case file:read_file(filename_p(URI))  of
    {error,Error}->{ok, Fof}=file:read_file("notfound.html"),{Fof, 404,Error};
    {ok, File} ->{File, 200,""}

end.

 %% Content = unicode:characters_to_list(File),




filename_p([47|Filename]) ->
  Filename.
