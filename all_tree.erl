%%%-------------------------------------------------------------------
%%% @author ben
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. mar 2017 08:50
%%%-------------------------------------------------------------------
%%cd("C:/Users/ben/Desktop/CINTE PERIOD 3/Etudes for Erlang docs").
%%cd("C:/Users/ben/Desktop/Erlang_rep").
-module(all_tree).
-author("ben").

%% API
-compile(export_all).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% BALANCED BINARY TREE PROB. 55 %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%This is a balanced binary tree
%% We have develop it with 2 auxiliary parameter NL and NR
%% to keep track of how many children each root has in the
%% left reps the right tree.

insert(Key, Value, nil) ->
  {Key,Value,nil,nil,0,0};
insert(Key, Value, {Key,_,Smaller,Bigger,NL,NR}) ->
  {Key,Value,Smaller,Bigger,NL,NR};
insert(Key, Value, {Key1,V,Smaller,Bigger,NL,NR}) when Key < Key1 ->
  case (NL - NR) < 0 of
    true ->
      {Key1,V,Smaller,insert(Key, Value, Bigger),NL,NR+1};
    false ->
      {Key1,V,insert(Key, Value, Smaller),Bigger,NL+1,NR} %%normally
  end;
insert(Key, Value, {Key1,V,Smaller,Bigger,NL,NR}) when Key > Key1 ->
  case (NL - NR) < 0 of
    true ->
      {Key1,V,insert(Key, Value, Smaller),Bigger,NL+1,NR};
    false ->
      {Key1,V,Smaller,insert(Key, Value, Bigger),NL,NR+1} %%normally
  end.

test1() ->
  S1 = nil,
  S2 = insert(4,"X",S1),
  S3 = insert(12,"Y",S2),
  S4 = insert(3,"Z",S3),
  S5 = insert(7,kalle,S4),
  S6 = insert(6,"W",S5),
  S7 = insert(5,"T",S6),
  S8 = insert(9,"W",S7),
  S8.

test5() ->
  S1 = nil,
  S2 = insert(3,"3",S1),
  S3 = insert(2,"2",S2),
  S4 = insert(2,"Hj",S3),
  S4.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% FIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% find if a tree is symmetric to itself 57 %%%%%%%%%%%
symmetric(T) -> isMirror(T,T).
isMirror(nil,nil) -> true;
isMirror({K,_,L,R},{K1,_,L1,R1}) ->
  case K == K1 of
    true ->
      isMirror(L,R1) and isMirror(R,L1);
    false ->
      false
  end.

%%%%%%%%%% count the numbers of leaves in the tree 61a %%%%%%%%%%%
count_leaf(nil) -> 0;
count_leaf({_,_,nil,nil}) -> 1;
count_leaf({_,_,L,R}) ->
  count_leaf(L) + count_leaf(R).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count_allnode(nil) -> 0;
count_allnode({_,_,L,R}) ->
  1 + count_allnode(L) + count_allnode(R).

count_internalnode(nil) -> 0;
count_internalnode({_,_,nil,nil}) -> 0;
count_internalnode({_,_,L,R}) ->
  1 + count_internalnode(L) + count_internalnode(R).

internal_node(nil) -> [];
internal_node({_,_, nil,nil}) -> [];
internal_node({_,Value, L,R}) ->
  A = internal_node(L),
  B = internal_node(R),
  A ++ [Value] ++ B.

to_tree(T) ->
  {R ,_} = dot_to_tree(T,8),
  R.
dot_to_tree([$.|T],_) ->
  {nil,T};
dot_to_tree([H|T],S) ->
  {L,RestL} = dot_to_tree(T,S+1),
  {R,RestR} = dot_to_tree(RestL,S-1),
  {{S,H,L,R},RestR}.

a() -> "abd..e..c.fg...".
b() ->  "afg^^c^bd^e^^^".
c() -> "afg^c".
%% b() is the input for the multiway tree
%% there ^ backtrack to the previous level

member(_,[]) -> false;
member(X,[X|_]) -> true;
member(X,[_|T]) -> member(X,T).

%%%try to implement a multiway tree {Value, []}.
m_tree([]) -> {[],[]};
m_tree([H|T]) ->
  case H of
    $^ ->
      {[],T};
    _ ->
      {L,RestL} = m_tree(T),
      {R,RestR} = m_tree(RestL),
      {[{node,H,L}] ++ R ,RestR}
  end.



