%%%-------------------------------------------------------------------
%%% @author QiLi
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. jan 2017 15:45
%%%-------------------------------------------------------------------
-module(hello).
-author("QiLi").
%% API
-export([hello_world/1]).
hello_world(Name) -> io:fwrite("hello, ~s\n", [Name]).