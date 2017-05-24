%%%-------------------------------------------------------------------
%%% @author ben
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. mar 2017 14:15
%%%-------------------------------------------------------------------
%%cd("C:/Users/ben/Desktop/CINTE PERIOD 3/Etudes for Erlang docs").
%%cd("C:/Users/ben/Desktop/Erlang_rep").
-module(arithmetic).
-author("ben").
%% arithmetic:decimal_to_binary().
%% API
-compile(export_all).

map(_,[]) -> [];
map(F,[H|T]) ->
  [F(H)|map(F,T)].

foldr(_,Acc, []) -> Acc;
foldr(Op,Acc,[H|T]) -> Op(H,foldr(Op,Acc,T)).

foldl(_,Acc,[]) -> Acc;
foldl(Op,Acc,[H|T]) -> foldl(Op,Op(H,Acc),T).

decimal_to_binary(L) -> decimal_to_binary(L,[]).
decimal_to_binary(0,Acc) -> Acc;
decimal_to_binary(L,Acc) ->
  {A,B} = divide(L),
  case B of
    0.0 ->
      decimal_to_binary(A,[0|Acc]);
    0 ->
      decimal_to_binary(A,[0|Acc]);
    0.5 ->
      decimal_to_binary(A,[1|Acc])
  end.

divide(F) ->
  R = F/2,
  case erlang:is_float(R) of
    true ->
      {trunc(R),R-trunc(R)};
    false ->
      {trunc(R),trunc(0)}
  end.
multiply(X,Y) -> multiply(X,Y,[]).
multiply(_,0,_) -> 0;
multiply(0,_,_) -> 0;
multiply(1,R,A) ->
  D = [R|A],
  foldr(fun(X,Y) -> X + Y end,0,D);
multiply(X,Y,Acc) ->
  case X rem 2 of
    0 ->
      multiply(trunc(X/2),Y*2,Acc);
    1 ->
      multiply(trunc(X/2),Y*2,[Y|Acc])
  end.

gcd(0,B) -> B;
gcd(A,0) -> A;
gcd(A,B) ->
  gcd(B, A rem B).

takewhile_even(L) -> takewhile(fun(X) -> X rem 2 == 0 end, L).
takewhile(_,[]) -> [];
takewhile(F,[H|T]) ->
  case F(H) of
    true ->
      [H|takewhile(F,T)];
    false ->
      takewhile(F,T)
  end.
dropwhile_even(L) -> dropwhile(fun(X) -> X rem 2 == 0 end, L).

dropwhile(_,[]) -> [];
dropwhile(F,[H|T] = C) ->
  case F(H) of
    true ->
      dropwhile(F,T);
    false ->
      C
  end.
%% modular exponentiation X^y mod N
modexp(X,Y,N) -> modexp(X,Y,N,1).
modexp(_,0,_,R) -> R;
modexp(X,Y,N,R) ->
  T = R*X rem N,
  E = X*X rem N,
  case Y rem 2 of
    0 ->
      modexp(E,trunc(Y/2),N,R);
    _ ->
      modexp(E,trunc(Y/2),N,T)
  end.

primalty(N,R) ->
%%  R = rand:uniform(N-1),
  C = gcd(trunc(math:pow(R,N-1)),N),
  case C of
    1 ->
      true;
    _ ->
      false
  end.

prim(N) -> prim(N,6,[]).
prim(_,0,A) -> A;
prim(N,K,A) ->
  R = random:uniform(N-1),
  C = primalty(N,R),
  prim(N,K-1,[C|A]).

prim_safe(N) ->
  F = prim(N),
  case dropwhile(fun(X) -> X == true end, F) of
    [] ->
      true;
    _ ->
      false
  end.

prim_n(N) -> prim_nn(lists:seq(1,N)).
prim_nn([]) -> [];
prim_nn([H|T]) ->
  case  prim_safe(H) of
    true ->
      [H|prim_nn(T)];
    false ->
      prim_nn(T)
  end.



