%%%-------------------------------------------------------------------
%%% @author ben
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. mar 2017 10:43
%%%-------------------------------------------------------------------
%%cd("C:/Users/ben/Desktop/CINTE PERIOD 3/Etudes for Erlang docs").
%%cd("C:/Users/ben/Desktop/Erlang_rep").
%% misc:evaluate_postfix().
-module(misc).
-author("ben").

%% API
-compile(export_all).
map(_,[]) -> [];
map(F,[H|T]) ->
  [F(H)|map(F,T)].

evaluate_postfix(A) -> evaluate_postfix(A,[]).
evaluate_postfix([],S) -> S;
evaluate_postfix(['+'|T],[A,B|C] = R) ->
  case R of
    [] ->
      error;
    _ ->
      evaluate_postfix(T,[A+B|C])
  end;
evaluate_postfix(['-'|T],[A,B|C] = R) ->
  case R of
    [] ->
      error;
    _ ->
      evaluate_postfix(T,[A+B|C])
  end;
evaluate_postfix([H|T],A) when is_integer(H) ->
  evaluate_postfix(T,[H|A]).

%% give the seq of N odd numbers start at 0
%% or start at N down to 0. * it can be shown
%% that the sum of all the sequence is exactly
%% equal to N^2
seq_odd(N) -> seq_odd(N,[]).
seq_odd(0,S) -> S;
seq_odd(N,S) ->
  seq_odd(N-1,[2*N-1|S]).

%%procedure TOWER(n,x,y,Z)
%%if n>O then begin
%%TOWER(n-l,x,z,y)
%%end
%%write "Move ring n from x to y. "
%%TOWER(n-l,z,y,x)

tower(1,X,_,Z) ->
  io:format("Move ring N = ~w from ~w to  ~w ~n",[1,X,Z]);
tower(N,X,Y,Z) ->
  tower(N-1,X,Z,Y),
  io:format("Move ring N = ~w from ~w to ~w ~n",[N,X,Y]),
  tower(N-1,Y,X,Z).
%%tower(N,X,Y,Z) ->
%%tower(N,X,Y,Z) -> partition list fodl 385
partition(_,[]) -> {[],[]};
partition(P,[H|T]) ->
  {A,B} = partition(P,T),
  case P > H of
    true ->
      {[H|A],B};
    false ->
      {A,[H|B]}
  end.
%%list
init([]) -> [[]];
init([X|XS]) ->
  [[]|map(fun(Y) -> [X|Y] end, init(XS))].

foldr(_,Acc, []) -> Acc;
foldr(Op,Acc,[H|T]) -> Op(H,foldr(Op,Acc,T)).

foldl(_,Acc,[]) -> Acc;
foldl(Op,Acc,[H|T]) -> foldl(Op,Op(H,Acc),T).

%%subs [] = [ [] ]
%%subs (x:xs) = map (x:) (subs xs) ++ subs xs
subs([]) -> [[]];
subs([X|XS]) ->
  map(fun(Y) -> [X|Y] end, subs(XS)) ++ subs(XS).
tails([]) ->
  [[]];
tails(X) ->
  [X|tails(tl(X))].

fold(K, F, T) ->
  case T of
    {app, G, X} -> K(app, fold(K, F, G), fold(K, F, X));
    {lam, X, B} -> K(lam, F(pat, X), fold(K, F, B));
    {var, N} -> F(var, N)
  end.

vars(T) ->
  fold(fun(_, X, Y) -> X ++ Y end,
    fun(_, X) -> [X] end, T).
%%a() ->
%%spawn(fun() ->  Res = Fun(), Self ! {ok, Ref, Res} end).
%%combs 0 xs = [ [] ]
%%combs (n+1) [] = [ ]
%%combs (n+1) (x:xs) = map (x:) (combs n xs) ++ combs (n+1) xs
comb(0,_) ->
  [[]];
comb(N,[]) -> [];
comb(N,[X|S]) ->
  map(fun(Y) -> [X|Y] end, comb(N-1,S)) ++ comb(N,S).
%%between e [] = [ [e] ]
%%between e (y:ys) = (e:y:ys) : map (y:) (between e ys)
bet(E,[]) ->
  [[E]];
bet(E,[X|S] = P) ->
  [[E|P]|map(fun(Y) -> [Y|X] end, bet(E,S))].

church(0) -> fun(_,Y) -> Y end;
church(N) -> fun(F,X) -> F((church(N-1))(F,X)) end.

integer(Church) -> Church(fun(X) -> 1 + X end, 0).

succ(N) -> fun(F,X) -> F(N(F,X)) end.

add(N,M) -> fun(F,X) -> N(F,M(F,X)) end.
mul(N,M) -> fun(F,X) -> N(fun(Y) -> M(F,Y) end,X) end.




