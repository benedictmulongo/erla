%%%-------------------------------------------------------------------
%%% @author ben
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. mar 2017 11:51
%%%-------------------------------------------------------------------
%%% "C:/Users/ben/Desktop/testcc.txt"
-module(client_test).
-author("ben").

%% API
-compile(export_all).
eval(Str) ->
  {ok, Socket} =
    gen_tcp:connect("localhost", 2345,
      [binary]),
  ok = gen_tcp:send(Socket,Str),
  receive
    {tcp,Socket,Bin} ->
      io:format("Client received binary = ~p~n",[Bin]),
      Val = binary_to_list(Bin),
      io:format("Client result = ~w~n",[Val]),
      gen_tcp:close(Socket)
  end.
