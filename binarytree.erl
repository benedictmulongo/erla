%%cd("C:/Users/ben/Desktop/CINTE PERIOD 3/Etudes for Erlang docs").
%%cd("C:/Users/ben/Desktop/Erlang_rep").
-module(binarytree).
-compile(export_all).

lookup(_, nil) ->
not_found;
lookup(Key, {Key,Value,_,_}) ->
{found,Value};
lookup(Key, {Key1,_,Smaller,_}) when Key < Key1 ->
lookup(Key, Smaller);
lookup(Key, {Key1,_,_,Bigger}) when Key > Key1 ->
lookup(Key, Bigger).

insert(Key, Value, nil) ->
{Key,Value,nil,nil};
insert(Key, Value, {Key,_,Smaller,Bigger}) ->
{Key,Value,Smaller,Bigger};
insert(Key, Value, {Key1,V,Smaller,Bigger}) when Key < Key1 ->
{Key1,V,insert(Key, Value, Smaller),Bigger};
insert(Key, Value, {Key1,V,Smaller,Bigger}) when Key > Key1 ->
{Key1,V,Smaller,insert(Key, Value, Bigger)}.

write_tree(T) ->
  write_tree(0, T).

write_tree(D, nil) ->
  print(D),
  io:format("nil", []);
write_tree(D, {Key,Value,Smaller,Bigger}) ->
  D1=D+4,
  write_tree(D1, Bigger),
  io:format("~n", []),
  print(D),
  io:format("~w ===> ~w~n", [Key,Value]),
  write_tree(D1, Smaller).

delete(Key, nil) ->
  nil;
delete(Key, {Key,_,nil,nil}) ->
  nil;
delete(Key, {Key,_,Smaller,nil}) ->
  Smaller;
delete(Key, {Key,_,nil,Bigger}) ->
  Bigger;
delete(Key, {Key1,_,Smaller,Bigger}) when Key == Key1 ->
  {K2,V2,Smaller2} = deletesp(Smaller),
  {K2,V2,Smaller2,Bigger};
delete(Key, {Key1,V,Smaller,Bigger}) when Key < Key1 ->
  {Key1,V,delete(Key, Smaller),Bigger};
delete(Key, {Key1,V,Smaller,Bigger}) when Key > Key1 ->
  {Key1,V,Smaller,delete(Key, Bigger)}.

deletesp({Key,Value,nil,nil}) ->
  {Key,Value,nil};
deletesp({Key,Value,Smaller,nil}) ->
  {Key,Value,Smaller};
deletesp({Key,Value,Smaller,Bigger}) ->
  {K2,V2,Bigger2} = deletesp(Bigger),
  {K2,V2,{Key,Value,Smaller,Bigger2}}.

test1() ->
S1 = nil,
S2 = insert(4,joe,S1),
S3 = insert(12,fred,S2),
S4 = insert(3,jane,S3),
S5 = insert(7,kalle,S4),
S6 = insert(6,thomas,S5),
S7 = insert(5,rickard,S6),
S8 = insert(9,susan,S7),
S9 = insert(2,tobbe,S8),
S10 = insert(8,dan,S9),
S10.
%%write_tree(S10).
%%binarytree:insert()
test2() ->
  S1 = nil,
  S2 = insert(4,"+",S1),
  S3 = insert(12,"1",S2),
  S4 = insert(3,"2",S3),
  S4.
test3() ->
  S1 = nil,
  S2 = insert(12,"+",S1),
  S3 = insert(14,"1",S2),
  S4 = insert(10,"2",S3),
  S5 = insert(8,"-",S4),
  S6 = insert(9,"6",S5),
  S7 = insert(7,"5",S6),
  S8 = insert(6,"h",S7),
  S8.
test4() ->
  S1 = nil,
  S2 = insert(3,"1",S1),
  S3 = insert(2,"1",S2),
  S4 = insert(1,"1",S3),
  S4.

test5() ->
  S1 = nil,
  S2 = insert(3,71,S1),
  S3 = insert(5,87,S2),
  S4 = insert(4,75,S3),
  S4.

inorder(nil) -> [];
inorder({K,Value, L,R}) ->
  A = inorder(L),
  B = inorder(R),
  A ++ [Value|[{K}]] ++ B.

%%this change the tree representation to its string
%% representation --- yYOU need to change the +++ to
%% with an ACCUMULATOR instead
pre(nil) -> [];
pre({K,Value, L,R}) ->
  A = pre(L),
  B = pre(R),
  [Value] ++ "(" ++ A ++ "," ++ B ++ ")".

in(T) -> in(T,[]).
in(nil,S) -> S;
in({K,V, L,R},S) ->
  in(L,[V|in(R,S)]).

count(nil) -> 0;
count({_,_,L,R}) ->
  1 + count(L) + count(R).

index(_,nil) -> 0;
index(D,{K,_,L,_}) when (D < K) == true ->
  index(D,L);
index(D,{K,_,L,R}) when (D > K) == true ->
  case index(D,R) of
    0 -> 0;
    I -> count(L) + 1 + I
  end
   ;
index(D,{_,_,L,_})  ->
  count(L) + 1.

min({K,V,nil,_}) -> [{key,K},{value,V}];
min({_,_,L,_}) ->
  min(L).
mina({K,V,nil,_}) -> [K,V];
mina({_,_,L,_}) ->
  mina(L).

max({K,V,nil,_}) -> [{key,K},{value,V}];
max({_,_,_,R}) ->
  max(R).

delete_min(Tree) ->
  [{_,K}|_] = min(Tree),
  delete(K,Tree).

max_list(L) -> m(L,0).
m([C],A) -> {C,{ss,A}};
m([A,B|T],S) ->
  case A > B of
    true ->
      m([A|T],S+1);
    false ->
      m([B|T],S-1)
  end.

max_t(A,B) ->
  case A > B of
    true ->
      A;
    false ->
      B
  end.

%% this function calculate the (longest ) heigtht of a given vertex
%% to the leaf

height(_, nil) ->
  not_found;
height(Key, {Key1,_,Smaller,_} = T) when Key == Key1 ->
  treat(T) - 1;
height(Key, {Key1,_,Smaller,_}) when Key < Key1 ->
  height(Key, Smaller);
height(Key, {Key1,_,_,Bigger}) when Key > Key1 ->
  height(Key, Bigger).

treat(nil) ->
  0;
treat({K,V,L,R}) ->
  1 + max(treat(L),treat(R)).
%%rank
rank(_, nil) ->
  not_found;
rank(Key, {Key1,_,Smaller,_} = T) when Key == Key1 ->
  tr(T) - 1;
rank(Key, {Key1,_,Smaller,_}) when Key < Key1 ->
  rank(Key, Smaller);
rank(Key, {Key1,_,_,Bigger}) when Key > Key1 ->
  rank(Key, Bigger).

tr(nil) ->
  0;
tr({K,V,L,R}) ->
  1 + min(tr(L),tr(R)).
%%% this function is used to recursivlely enter a number
%% of keys in the binary searhc treee
%%% we use foldl as a help function
%% here A = element of the list X, take one after one
%%% b = is the accumulator for every iteration

foldl(_,Acc,[]) -> Acc;
foldl(Op,Acc,[H|T]) -> foldl(Op,Op(H,Acc),T).

fromlist(X) ->
  foldl(fun(A,B) -> insert(A,"1",B) end, nil ,X).

%%sucessor/predecessor /
%% the problem is how to create a data structure to keep track of every node
%% and their relative parent when traversing the treee?
%%succ(X,nil) ->
%%  nil;
%%succ(X,{K,V,L,R} = T) -> min(T);
%%succ(X,{K,V,L,nil}) ->

delete1(Key, nil) ->
  nil;
delete1(Key, {Key,_,nil,nil}) ->
  nil;
delete1(Key, {Key,_,Smaller,nil}) ->
  Smaller;
delete1(Key, {Key,_,nil,Bigger}) ->
  Bigger;
delete1(Key, {Key1,_,Smaller,Bigger}) when Key == Key1 ->
%%  {K2,V2,Smaller2} = deletesp(Smaller),
  [K,V] = mina(Bigger),
  {K,V,Smaller,delete1(K,Bigger)};
delete1(Key, {Key1,V,Smaller,Bigger}) when Key < Key1 ->
  {Key1,V,delete1(Key, Smaller),Bigger};
delete1(Key, {Key1,V,Smaller,Bigger}) when Key > Key1 ->
  {Key1,V,Smaller,delete1(Key, Bigger)}.


print(N) ->
  case N of
    0 ->
      io:format("\t");
    1 ->
      io:format("\t\t");
    2 ->
      io:format("\t\t\t");
    3 ->
      io:format("\t\t\t\t");
    4 ->
      io:format("\t\t\t\t\t");
    5 ->
      io:format("\t\t\t\t\t\t\t");
    _ ->
      io:format("\t\t\t\t\t\t\t\t")
  end.

