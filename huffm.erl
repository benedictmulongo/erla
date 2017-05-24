%%%-------------------------------------------------------------------
%%% @author ben
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. mar 2017 17:57
%%%-------------------------------------------------------------------
-module(huffm).
-author("ben").

%% API
-import(huffman,[sort/2]).
-compile(export_all).

freq(El,L) ->
  case lists:member(El,L) of
    true -> freq(El,L,0);
    false -> 0
  end.
freq(_,[],C) -> C;
freq(El,L,C) ->
  %%L1 = sortFile(F),
  [A|B] = L,
  case A of
    El -> freq(El,B,C+1);
    _ -> freq(El,B,C)
  end.

remove_dups([])    -> [];
remove_dups([H|T]) -> [H | [X || X <- remove_dups(T), X /= H]].

dex1(F) ->
  L1 = remove_dups(F),
  L2 = sort(F,asc),
  [{X,freq(X,L2)}|| X <- L1].
