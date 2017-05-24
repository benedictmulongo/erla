%% @author Benedith Mulongo
%% @doc Functions for huffman coding
%% @copyright 2017-01-20
%% @version 0.1
%%cd("C:/Users/ben/Desktop/ERLANGOVNING").
%%edoc:files(["huffman.erl"], [{dir, "C:/Users/ben/Desktop/ERLANGOVNING"}]).

-module(huffman).
-compile(export_all).

%%-export([read/2,sortFile/1,dex/1,proper/1,encode/1,
%%         count/1,tr/1,small/1,tree/1,arbre/1,findChar/2,
%%         remove_dups/1,outt/1,treeF/1,thefile/1,decode/2,
%%         remove_d/1,freq/2,build/1,look/1,lookup/2,
%%         findSmall/1,extract_min/1,f/1]).
         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Presentation %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%@doc This module build a huffman tree given 
%%a text and encode it with with th function encode
%% to a binary sequence, with then can be tranlated  
%%again to the origal text.
%%This module shows how the huffman coding may 
%%work.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Performance analys %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% The performance analys of this module shows that
%% the module need to be improved further for example
%% by using only tuples, because the sorting operation
%% searching and other operations performed to the list 
%% increase the amount of time required to do the task.
%%%%  FILE %%%% NUMBER OF WORDS %%%%%%% TIME REQUIRED %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  1kb  %%%%      160        %%%%%%%    1 min      %%%
%%%%  2kb  %%%%      300        %%%%%%%    6 min      %%%
%%%% 6,7kb %%%%      963        %%%%%%%  > 20 min     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
%%%%%%%%%%%%%%%% sorting Algorithm %%%%%%%%%%%%%%%%%%%%% 
minimum(L) -> 
    [H|_] = L,
    minimum(L,H).

minimum([], Current) -> Current;
minimum([H|T],Current) -> 
         if
           H < Current -> minimum(T,H);
           true -> minimum(T,Current)
         end.
maximum(L) -> 
    [H|_] = L,
    maximum(L,H).

maximum([], Current) -> Current;
maximum([H|T],Current) -> 
         if
           H > Current -> maximum(T,H);
           true -> maximum(T,Current)
         end.
         
sort(List,F) -> 
         case F of
           asc -> sort2(List,[]);
           _ -> sort1(List,[])
         end.

sort2([], A) -> A;

sort2(Lista,Actual) -> 
         Mina = maximum(Lista),
         L1 = lists:delete(Mina,Lista),
         sort2(L1,[Mina|Actual]).

sort1([], B) -> B;

sort1(Li,Act) -> 
         Min = minimum(Li),
         L2 = lists:delete(Min,Li),
         sort1(L2,[Min|Act]).    
%%%%%%%%%%%%%%%% End of  sorting Algorithm %%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
%%%%%%%%%%%% Read the file and return a list %%%%%%%%%%%% 
read(File, N) ->
	{ok, Fd} = file:open(File, [read, binary]),
	{ok, Binary} = file:read(Fd, N),
	file:close(Fd),
	case unicode:characters_to_list(Binary, utf8) of
		{incomplete, List, _} ->
		List;
		List ->
		List
	end.
%%count the total numbers of bytes in 
%%in the given file
%%size(F) -> filelib:file_size(F).

%%read the file as a list and return the file sorted 
%% in a list in ascending ord
sortFile(Fi) -> 
             %%T = read(Fi,size(Fi)),
             L = unicode:characters_to_list(read(Fi,filelib:file_size(Fi)),utf8),
             sort(L,asc).
%%read a entire file and return the file as a list 
thefile(Fi) -> unicode:characters_to_list(read(Fi,filelib:file_size(Fi)),utf8).
%%count
count(Fil) -> 
             [P|_] = sortFile(Fil),
             count(sortFile(Fil),[],P).
count([],O,_) -> O;
count(Fic,C,Nu) ->
             [K|L] = Fic,
             case K of
                 Nu -> count(L,C,Nu);
                 _ -> count(L,[Nu|C],Nu)
             end.
%%Find if a Element El is in a list K.
is_element(_,[]) -> 0;
is_element(El,K) ->
      [H|T] = K,
        if 
          El == H -> 1;
          true -> is_element(El,T)
         end.
%%remove duplicate from a list
remove_d(F) ->  remove_d(sortFile(F),[]).
remove_d([],K) -> lists:reverse(K);
remove_d(L,P) ->
        [A|B] = L,
        case is_element(A,P) of 
            1 -> remove_d(B,P);
            0 -> remove_d(B,[A|P])
        end.     
remove_dups([])    -> [];
remove_dups([H|T]) -> [H | [X || X <- remove_dups(T), X /= H]].
%%%%%%%%%%%%%%%% End of remove dup %%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
%%test
outt(Fa) -> remove_dups(sortFile(Fa)).   
%%count the freqency for each character 
%%in the list
freq(El,L) ->
        case is_element(El,L) of
           1 -> freq(El,L,0);
           0 -> 0
        end.
freq(_,[],C) -> C;
freq(El,L,C) -> 
        %%L1 = sortFile(F),
        [A|B] = L,
        case A of
           El -> freq(El,B,C+1);
           _ -> freq(El,B,C)
        end.
%%%%%%%%%%%%%%%% End of fred counter %%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%take the file, sort each character and, remove duplic
%% return a list with the occurence of each character
dex(F) -> 
        L1 = remove_d(F),
        L2 = sortFile(F),
        [freq(X,L2)|| X <- L1].

dex1(F) ->
  L1 = remove_dups(F),
  L2 = sort(F,asc),
  [{X,freq(X,L2)}|| X <- L1].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% return a zip list with [{character,freq}]
tr(F) -> 
        L1 = remove_d(F),
        Occ = dex(F),
        lists:zip(L1,Occ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%find the smallest frequency in a zip list 
%%%[{character,freq}]
small(Lt) -> 
         [A|_] = Lt,
         {_,C} = A,
         small(Lt,C).
small([],G) -> G;
small(L,C) -> 
        [A|B] = L,
        {_,D} = A,
        if 
           D < C -> small(B,D);
           true -> small(B,C)
        end.
%%%%%%%%%%%%%%%% End of small %%%%%%%%%%%%%%%%%%%  
%%given a tuple return frq
f(Tuple) -> 
       {_,Fr} = Tuple,  
       Fr.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% find the element with the smallest frequency in 
%%%zip list 
%%%[{character,freq}]  %%%%%%%%%%%%%%%%%%%%5
findSmall(Lt) -> 
         El = small(Lt),
         findSmall(El,Lt).
findSmall(_,[]) -> 0;
findSmall(El,Lt) ->
        [A|B] = Lt,
        {_,D} = A,
        case D of
            El -> A;
            _ -> findSmall(El,B)
        end.
%%%%%%%%%%%%%%%% End of small %%%%%%%%%%%%%%%%%%%%%%%%%
%%extract the minimun in the zip list
extract_min(Lt) -> 
           T = findSmall(Lt),
           [_|U] = Lt,
           case U of
                [] -> hd(Lt);
                 _ -> extract_min(T,Lt,[])
           end.
extract_min(_,[],P) -> lists:reverse(P);
extract_min(T,Lt,Q) -> 
           [A|B] = Lt,
           case A of
              T -> extract_min(T,B,Q);
              _ -> extract_min(T,B,[A|Q])
           end.
%%%%%%%%%%%%%%%% end extract_min %%%%%%%%%%%%%%%%%%%%%%
%%build the tree one interaction
build(L) -> 
           T = findSmall(L),
           L1 = extract_min(L),
           T1 = findSmall(L1),
           L2 = extract_min(L1),
           [{{T,T1},f(T) + f(T1)}|L2].
%%build the whole tree   
tree(L) -> 
           Len = length(L)-1,     
           tree(L,Len,0).
tree(L,Len,P) when P == Len -> L; 
tree(L,Len,P) when P < Len ->
           Y = build(L),
           tree(Y,Len,P+1).
treeF(L) -> 
         [H|_] = tree(L),
         [H].
%%%%%%%%%%%%%%%% end tree building %%%%%%%%%%%%%%%%%%%%%%   
%%build the encoding table
look(T) -> 
         [{H,_}|_] = T,
         proper(look(H,[],[])).

look(P,L,U) when is_tuple(P) == false -> 
         [{P,lists:reverse(L)}|U];
look({W,_},L,U) when is_tuple(W) == false ->
         [{W,lists:reverse(L)}|U];
look({F,_},L,U) when is_tuple(F) == false ->
         [{F,lists:reverse(L)}|U];
look({B,C},L,I) when is_tuple(B) == true ->  
         look(B,[1|L],[I|look(C,[0|L],I)]);
look({_,C},L,I) when is_tuple(C) == true -> 
         look(C,[0|L],I).
%%%%%%%%%%%%%%%% end the encod table %%%%%%%%%%%%%%%%%%%         
%%given a list A create a new list B which contains
%%only the element of A that are tuples
%%Awful trics -> 
proper(L) -> proper(L,[]).
proper([],Q) -> Q;
proper(L,P) ->
         [H|T] = L,
         case is_tuple(H) of
             true -> proper(T,[H|P]);
             false -> proper(T,P)
         end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%generate the encoding table for each character
arbre(F) -> 
      Y = remove_d(F),
      X = look(treeF(tr(F))),
      arbre(X,Y,[]).
arbre([],_,Q)-> lists:reverse(Q);
arbre(X,Y,Z) -> 
      [H|T] = X,
      {A,_} = H,
      case is_element(A,Y) of
           1 -> arbre(T,Y,[H|Z]);
           0 -> arbre(T,Y,Z)
      end.
      
%%given a character find is representation
%%in the huffman tree as binary code
lookup(El,File) ->  lookup(El,File,arbre(File)).
lookup(_,_,[]) -> [];
lookup(El,File,N) ->
      [H|T] = N,
      {X,R} = H,
      case X of
           El -> R;
           _ -> lookup(El,File,T)
      end.
%%encode each chracter in the file F
encode(F) -> 
      Th = thefile(F),
      encode(F,Th,[]).
encode(_,[],Q) -> lists:reverse(Q);
encode(F,G,S) -> 
      [H|T] = G,
      P = lookup(H,F),
      encode(F,T,[P|S]).
%%tired - I will take the easy way to do 
%%the decode part
%%decode(L,F) -> decode(L,F,[]).
%%given a rbinary code find is representation
%%in the huffman tree as character
findChar(_,[]) -> [];
findChar(El,F) -> 
      [H|T] = F,
      {X,V} = H,
      case V of 
           El -> X;
           _ -> findChar(El,T)
      end.   
%% K = huffman:encode("Sample.txt")
%% L = huffman:arbre("Sample.txt").
decode(K,L) -> [findChar(X,L)|| X <- K].

      
