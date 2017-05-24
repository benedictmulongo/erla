%%coding: latin-1
%% @version 0.1
%%cd("C:/Users/ben/Desktop/Erlang_rep").
%%edoc:files(["huffman.erl"], [{dir, "C:/Users/ben/Desktop/ERLANGOVNING"}]).

-module(split).
-compile(export_all).

split([]) -> {[],[]};
split([C|S]) ->
             {H1,H2} = split(S),
             {[C|H2],H1}.

splits(D) -> splits(D,[],[]).
splits([C,B],D1,D2) -> {[B|D1],[C|D2]};
splits([C,A|S],D1,D2) -> splits(S,[C|D1],[A|D2]).

%%foldr(F,basfallet,Lista)
%%F(H,Accumulatorn)
%%f�r varje element H i listan 
%%applicera funktionen F med basfallet "basfallet"

foldr(_,Acc, []) -> Acc;
foldr(Op,Acc,[H|T]) -> Op(H,foldr(Op,Acc,T)).

foldl(_,Acc,[]) -> Acc;
foldl(Op,Acc,[H|T]) -> foldl(Op,Op(H,Acc),T).