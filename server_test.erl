%%%-------------------------------------------------------------------
%%% @author ben
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. mar 2017 11:50
%%%-------------------------------------------------------------------
-module(server_test).
-author("ben").

%% API
-compile(export_all).
start() ->
  {ok, Listen} = gen_tcp:listen(2345, [binary, {reuseaddr, true},{active, true}]),
  {ok, Socket} = gen_tcp:accept(Listen),
  gen_tcp:close(Listen),
  loop(Socket).

loop(Socket) ->
  receive
    {tcp, Socket, Bin} ->
      io:format("Server received binary = ~p~n",[Bin]),
      {ok,T}=file:read_file(Bin),
      io:format("Server replying = ~p~n",[T]),
      gen_tcp:send(Socket, T),
      loop(Socket);
    {tcp_closed, Socket} ->
      io:format("Server socket closed~n")
  end.
