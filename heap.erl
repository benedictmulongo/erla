%%%-------------------------------------------------------------------
%%% @author ben
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. mar 2017 13:12
%%%-------------------------------------------------------------------
-module(heap).
-author("ben").

%% API
-compile(export_all).

%% There are two representation for the heap data structures
%% one of which uses arrays and the other uses a binary tree
%% representation of the heap.
%% Thera 2 sort of heap
%% max_heap = maximun element on the top och every children is <= parent
%% max_heap = minimum element on the top och every children is >= parent


%% in the array based reprentation can the heap
%% be represented with a list [7,6,5,4,3,2,1].
%% and we keep track of the index
%% parent(i) -> i/2
%% left(i) -> 2i
%% right(i) -> 2i + 1
%% parent(I) -> I/2.
%% left(I) -> 2*I.
%% right(I) -> 2*I + 1.
%%
%%heapify(Array,Index) ->
%%  N = length(A),
%%  loop
%%    L = left(Index),
%%    R = right(Index),
%%    Min = Index,
%%    if
%%(L < N ) and (A[L] < A[I]) -> Min = L
%%if
%%(R < N ) and (A[R] < A[Min]) -> Min = R
%%if
%%Min != Index -> swap(A[Index],A[Min])
%%I = Min
%%else
%%   break loop



%%1: function Build-Heap(A)
%%2: n <- #A
%%3: for i  <- ⌊n/2⌋ down to 1 do
%%4: Heapify(A,i)



