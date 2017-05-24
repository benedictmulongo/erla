%%%-------------------------------------------------------------------
%%% @author ben
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. feb 2017 11:47
%%%-------------------------------------------------------------------
%%%-------------------------------------------------------------------
%% C:\Users\ben\Desktop\Erlang tcp_udp_http
%% cd("C:/Users/ben/Desktop/Erlang tcp_udp_http").
%% c(rudy)
%% rudy:start(8101).
%% {ok, Socket} = gen_tcp:connect({127,0,0,1},8099,[list, {active, false},{reuseaddr, true}]).
%%  gen_tcp:send(Socket, "GET /index.html HTTP/1.1\r\nfoo 34\r\n\r\nHello").
-module(rudy).
-author("ben").

%% API
-export([start/1, stop/0]).
start(Port) ->
  register(rudy, spawn(fun() -> init(Port) end)).
stop() ->
  exit(whereis(rudy), "time to die").

init(Port) ->
  Opt = [list, {active, false}, {reuseaddr, true}],
  case gen_tcp:listen(Port, Opt) of
    {ok, Listen} ->
      %%..............
      handler(Listen),
      gen_tcp:close(Listen),
      ok;
    {error, Error} ->
      {error,Error}
  end.

handler(Listen) ->
  case gen_tcp:accept(Listen) of
    {ok, Client} ->
      request(Client);
    {error,Error} ->
      {error,Error}
  end.

request(Client) ->
  Recv = gen_tcp:recv(Client, 0),
  case Recv of
    {ok, Str} ->
      Request = http:parse_request(Str),
      Response = reply(Request),
      gen_tcp:send(Client, Response);
    {error, Error} ->
      io:format("rudy: error: ~w~n", [Error])
  end,
  gen_tcp:close(Client).

reply({{get, URI, _}, _, Message_Body}) ->
  http:ok("Page found hahah !").