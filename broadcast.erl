%%%-------------------------------------------------------------------
%%% @author ben
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. mar 2017 14:15
%%%-------------------------------------------------------------------
%% C:\Users\ben\Desktop\Erlang tcp_udp_http
%% cd("C:/Users/ben/Desktop/Erlang tcp_udp_http").
%%
-module(broadcast).
-author("ben").

%% API

-compile(export_all).
send(IoList) ->
  case inet:ifget("192.168.0.100", [addr]) of
    {ok, [{addr, Ip}]} ->
      {ok, S} = gen_udp:open(5010, [{broadcast, true}]),
      gen_udp:send(S, Ip, 6000, IoList),
      gen_udp:close(S);
    T ->
      io:format("Bad interface name, or\~n"
      "broadcasting not supported\~w~n",[T])
  end.
listen() ->
  {ok, _} = gen_udp:open(6000),
  loop().
loop() ->
  receive
    Any ->
      io:format("received:~p~n", [Any]),
      loop()
  end.