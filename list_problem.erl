%%%-------------------------------------------------------------------
%%% @author ben
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. mar 2017 16:53
%%%-------------------------------------------------------------------
%%cd("C:/Users/ben/Desktop/CINTE PERIOD 3/Etudes for Erlang docs").
%%cd("C:/Users/ben/Desktop/Erlang_rep").
%%cd("C:/Users/ben/Desktop/Erlang_rep").
%%cd("C:/Users/ben/Desktop/Erlang_rep").
-module(list_problem).
-author("ben").

%% API
-compile(export_all).
%%P1
foldr(_,Acc, []) -> Acc;
foldr(Op,Acc,[H|T]) -> Op(H,foldr(Op,Acc,T)).

foldl(_,Acc,[]) -> Acc;
foldl(Op,Acc,[H|T]) -> foldl(Op,Op(H,Acc),T).

map(_,[]) -> [];
map(F,[H|T]) ->
  [F(H)|map(F,T)].
maps(_,[]) -> 0;
maps(F,[H|T]) ->
  [F(H) + maps(F,T)].

last([]) -> not_element_found;
last([A]) -> A;
last([_|T]) ->
  last(T).

last_fold([]) ->  not_element_found;
last_fold([H|T]) ->
  foldl(fun(A,_) -> A end, H,T).
%%P2
penultimate([]) -> not_element_found;
penultimate([A,_]) -> A;
penultimate([_|T]) -> penultimate(T).

%%P3
elementAt([H|_],1) -> H;
elementAt([_|T],N) ->
  elementAt(T,N-1).

%%P4
len([]) -> 0;
len([_|T]) ->
  1 + len(T).
%%P5
len_map([]) -> 0;
len_map(R) ->
  map(fun(_) -> 1 end,R).
len_f([]) -> 0;
len_f(R) ->
  foldl(fun(_,Y) -> 1 + Y end, 0,R).


reverse(T) -> reverse(T,[]).
reverse([],Acc) -> Acc;
reverse([H|T],Acc) ->
  reverse(T,[H|Acc]).

isPalindrome(L) -> isPalindrome(L,1,len(L)).
isPalindrome(_,S,S) -> true;
isPalindrome(L,Start,Final) ->
  case elementAt(L,Start) == elementAt(L,Final) of
    true ->
      isPalindrome(L,Start+1,Final-1);
    false ->
      false
  end.

flat(T) ->  flat(T,[]).
flat([], A) -> A;
flat([H|T],Acc) ->
  flat(T,Acc ++ H).

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
nodup([]) ->
   [];
nodup([A,A|T]) ->
  [A|nodup(T)];
nodup([H|T]) ->
  [H|nodup(T)].
%% G = [1,1,1,2,3,3,3,4,4,4,4,5,6,6].
pack(L) -> pack(L,[]).
pack([],F) -> F;
pack([H|_] = L,F) ->
  R = dropwhile(fun(X) -> X == H end,L),
  E = takewhile(fun(X) -> X == H end,L),
  pack(R,[E|F]).

pack1(L) -> pack1(L,[],[]).
pack1([],_,F) -> F;
pack1([H|T],A,F) ->
  case lists:member(H,T) of
    true ->
      pack1(T,[H|A],F);
    false ->
      pack1(T,[],[[H|A]|F])
  end.

to_tuple([]) -> [];
to_tuple([H|T]) ->
  G = length(H),
  [{G,hd(H)}|to_tuple(T)].

to_tuple_map([]) -> [];
to_tuple_map(L) ->
  map(fun(X) -> {length(X),hd(X)} end, L).
%% T = [1,2,3,5,8,8].
duplicate([]) -> [];
duplicate([A|T]) ->
  [A,A|duplicate(T)].

give(H,N) -> give(H,N,[]).
give(_,0,A) -> A;
give(H,N,A) ->
  give(H,N-1,[H|A]).

d([],_) -> [];
d([H|T],N) ->
  [give(H,N)|d(T,N)].
%%% P = [1,2,3,3].
dup([],_,_) -> [];
dup([_|T],0,N) -> dup(T,N,N);
dup([A|_] = L,N,K) ->
  [A|dup(L,N-1,K)].

dropNth(T,N) -> dropNth(T,N,N).
dropNth([],_,_) -> [];
dropNth([_|T],1,N) -> dropNth(T,N,N);
dropNth([H|T],N,K) ->
  [H|dropNth(T,N-1,K)].
slice([H|T],Start,Final) -> slice([H|T],Start,Final - Start,[]).
slice(_,1,-1,_) -> [];
slice([H|T],1,Final,A) ->
  [H|slice(T,1,Final-1,A)];
slice(_,Start,Final,_) when (Start < 0) and (Final < 0) ->
  [];
slice([_|T],Start,Final,A) ->
  slice(T,Start-1,Final,A).

splitl(T,N) -> splitl(T,N,[]).
splitl(T,0,A) ->
  {A,T};
splitl([H|T],N,A) ->
  splitl(T,N-1,[H|A]).

dup_map([]) -> [];
dup_map(L) ->
  map(fun(X) -> [X,X] end,L).

dup_fold([]) -> [];
dup_fold(L) ->
  foldl(fun(X,A) -> [X,X|A] end,[],L).


nodp([]) -> [];
nodp(L) ->
  foldl(fun(X,A) -> case lists:member(X,A) of
                      true ->
                        A;
                      false ->
                        [X|A]
                    end end,[],L).
%% A = [1,1,2,2,3,3,3,4,5,4,4,4,4].
rotate(A,0) -> A;
rotate([H|T],N) ->
  rotate(lists:append(T,[H]),N-1).
dropAt([],_) -> [];
dropAt([_|T],1) -> T;
dropAt([H|T],N) ->
  [H|dropAt(T,N-1)].

inAt([],_,_) -> [];
inAt(T,1,E) -> [E|T];
inAt([H|T],N,E) ->
  [H|inAt(T,N-1,E)].

range(B,B) -> [B];
range(A,B) ->
  [A|range(A+1,B)].

f(X) -> rand:uniform(X).

random_select(0,_) -> [];
random_select(X,L) ->
  E = f(length(L)),
  [elementAt(L,E)|random_select(X-1,L)].

lotto(0,_,_) -> [];
lotto(X,L,G) -> random_select(X,range(L,G)).

combine(_,[]) -> [];
combine(0,[]) -> [[]];
%%List.map	((::)	x)	(combinations	(n	-	1)	xs)	++	c
%%ombinations	n	xs
combine(N,[H|T]) ->
    map(fun(X) -> [X|H] end,combine(N-1,T)) ++ combine(N,T).

merg([],A) -> A;
merg(V,[]) -> V;
merg([H1|T1],[H2|T2]) ->
  case H1 < H2 of
    true ->
      [H1|merg(T1,[H2|T2])];
    false ->
      [H2|merg([H1|T1],T2)]
  end.

list_list([],A) -> A;
list_list(V,[]) -> V;
list_list([H1|T1],[H2|T2]) ->
  case length(H1) < length(H2) of
    true ->
      [H1|list_list(T1,[H2|T2])];
    false ->
      [H2|list_list([H1|T1],T2)]
  end.

msort(L,_) when length(L) == 1 -> L;
msort(L,G) when length(L) > 1 ->
  {L1,L2} = lists:split((length(L) div 2),L),
  case G of
    list_list ->
      list_list(msort(L1,G),msort(L2,G));
    _ ->
      merg(msort(L1,G),msort(L2,G))
  end.

r() -> [[a,b,c],[d,e],[f,g,h],[d,e],[i,j,k,l],[m,n],[o]].

decimal_to_binary(L) ->
  F = L/2,
  F.

divide(F) ->
  R = F/2,
  case erlang:is_float(R) of
    true ->
      {trunc(R),R-trunc(R)};
    false ->
      {trunc(R),trunc(0)}
  end.