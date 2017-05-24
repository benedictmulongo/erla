%%%-------------------------------------------------------------------
%%% @author ben
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. mar 2017 13:12
%%%-------------------------------------------------------------------
-module(socket_seq).
-author("ben").

%% API
-compile(export_all).

start() ->
  {ok, Listen} = gen_tcp:listen(2345, [binary, {packet, 4},
    {reuseaddr, true},
    {active, true}]),
seq_loop(Listen).

seq_loop(Listen) ->
  {ok, Socket} = gen_tcp:accept(Listen),
  loop(Socket),
  seq_loop(Listen).

loop(Socket) ->
  receive
    {tcp, Socket, Bin} ->
      io:format("Server received binary = ~p~n",[Bin]),
      Str = binary_to_term(Bin),
      io:format("Server (unpacked) ~p~n",[Str]),
      Reply = string2value(Str),
      io:format("Server replying = ~p~n",[Reply]),
      gen_tcp:send(Socket, term_to_binary(Reply)),
      loop(Socket);
    {tcp_closed, Socket} ->
      io:format("Server socket closed~n")
  end.

string2value(Str) ->
  {ok, Tokens, _} = erl_scan:string(Str ++ "."),
  {ok, Exprs} = erl_parse:parse_exprs(Tokens),
  Bindings = erl_eval:new_bindings(),
  {value, Value, _} = erl_eval:exprs(Exprs, Bindings),
  Value.