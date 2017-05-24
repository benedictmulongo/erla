%%%-------------------------------------------------------------------
%%% @author ben
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. feb 2017 15:23
%%%-------------------------------------------------------------------
%% C:\Users\ben\Desktop\Erlang tcp_udp_http
%% cd("C:/Users/ben/Desktop/Erlang tcp_udp_http").
-module(naive_tcp).
-author("ben").

%% API
-compile(export_all).
start_server(Port) ->
  Pid = spawn_link(fun() ->
    {ok, Listen} = gen_tcp:listen(Port, [binary, {active, false}]),
    spawn(fun() -> acceptor(Listen) end),
    timer:sleep(infinity)
                   end),
  {ok, Pid}.
acceptor(ListenSocket) ->
  {ok, Socket} = gen_tcp:accept(ListenSocket),
  spawn(fun() -> acceptor(ListenSocket) end),
  handle(Socket).
%% Echoing back whatever was obtained.
handle(Socket) ->
  inet:setopts(Socket, [{active, once}]),
  receive
    {tcp, Socket, <<"shut up", _/binary>>} ->
      gen_tcp:close(Socket);
    {tcp, Socket,_} ->
      gen_tcp:send(Socket, "I want to fuck !"),
      handle(Socket)
  end.
