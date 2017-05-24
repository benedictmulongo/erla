%%%-------------------------------------------------------------------
%%% @author ben
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. feb 2017 16:01
%%%-------------------------------------------------------------------
%% C:\Users\ben\Desktop\Erlang tcp_udp_http
%% cd("C:/Users/ben/Desktop/Erlang tcp_udp_http").
%%fetch:nano_get_url().
-module(fetch).
-author("ben").

%% API
-compile(export_all).
nano_get_url() ->
  R = nano_get_url("www.google.se"),
  string:tokens(erlang:binary_to_list(R),"\r\n").

nano_get_url(Host) ->
  {ok,Socket} = gen_tcp:connect(Host,80,[binary, {packet, 0}]),
  ok = gen_tcp:send(Socket, "GET / HTTP/1.0\r\n\r\n"),
receive_data(Socket, []).
receive_data(Socket, SoFar) ->
  receive
    {tcp,Socket,Bin} ->
receive_data(Socket, [Bin|SoFar]);
{tcp_closed,Socket} ->
list_to_binary(lists:reverse(SoFar))
end.

arb([]) ->
  0;
arb([$X|T]) ->
  10 + arb(T);
arb([$V|T]) ->
  5 + arb(T);
arb([$I|T]) ->
  1 + arb(T).

arb1([]) ->
  0;
arb1([$X,$I|T]) ->
  9 + arb1(T);
arb1([$V,$I|T]) ->
  4 + arb1(T);
arb1([$X|T]) ->
  10 + arb1(T);
arb1([$V|T]) ->
  5 + arb1(T);
arb1([$I|T]) ->
  1 + arb(T).

union(S1,S2) -> union(S1,S2,S2).
union([],_,Acc) -> Acc;
union([H1|T1],Set2,Acc) ->
  case lists:member(H1,Set2) of
    true ->
      union(T1,Set2,Acc);
    false ->
      union(T1,Set2,[H1|Acc])
  end.

isec([],_) -> [];
isec([H1|T1],Set2) ->
  case lists:member(H1,Set2) of
    true ->
      [H1|isec(T1,Set2)];
    false ->
      isec(T1,Set2)
  end.

diff([],_) -> [];
diff([H1|T1],Set2) ->
  case lists:member(H1,Set2) of
    true ->
      diff(T1,Set2)  ;
    false ->
      [H1|diff(T1,Set2)]
  end.