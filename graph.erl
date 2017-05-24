%% coding: latin-1
%% @author Benedith Mulongo
%% @doc dining philosopher
%% of Erlang language
%% @copyright 2017-01-25
%% @version 0.1
%%cd("C:/Users/ben/Desktop/ERLANGOVNING").
%%This is a implementation of a graph API
%% using the following representation
%% [vertex1,vertex2,weigth]
%%G = [{a,b,2},{b,c,4},{c,d,1},{c,f,1},{a,f,1},{f,d,3}].

-module(graph).
-export([new/0,find/2,delete/2,addElement/2,vert/2,
         shortest/3,next/2,distances/3,select/1,initial/2]).

new() -> [].

%% 1. if the element is in the graph update the weight only
%% 2. if the elemnt is not in the graph find its weight and place it 
%% in the right place 
addElement(G,El) -> 
	H = find(G,El),
	case H of
	     not_in_the_graph -> [El|G];
	     _                 -> H
        end.
      
find(G,El) -> find(G,El,[]).
find([],_,_) ->  not_in_the_graph;
find([{H1,H2,_} = H|T],{V1,V2,_} = El,Acc) -> 
          case (V1 == H1) and (V2 == H2) of
               true   -> [El|Acc] ++ T;
	       false  -> find(T,El,[H|Acc]) 
	  end.

delete(G,El) -> delete(G,El,[]).
delete([],_,_) ->  not_such_element_exist;
delete([{H1,H2,_} = H|T],{V1,V2,_} = El,Acc) ->
          case (V1 == H1) and (V2 == H2) of
               true   -> Acc ++ T;
	       false  -> find(T,El,[H|Acc]) 
	  end.
	  
%%shortest path in a DAG
next(_, []) -> [];
next(From, [{From, T, D}|Rest]) -> [{T, D}|next(From, Rest)];
next(From, [_|Rest]) -> next(From, Rest).

distances(Next, To, Graph) ->
lists:map(fun({T,D}) ->
case shortest(T, To, Graph) of
{inf, na} -> {inf, na};
{N, Path} -> {D+N, [T|Path]}
end
end, Next).

select(Distances) ->
lists:foldl(fun({Sd,_}=S, {Ad,_}=A) ->
if
Sd < Ad ->
S;
true ->
A
end
end,
{inf, na},
Distances).

shortest(From, From, _) -> {0, []};
shortest(From, To, Graph) ->

Next = next(From, Graph),
Distances = distances(Next, To, Graph),
select(Distances).

vertex([],_) -> [];
vertex([{From,To,_}|T],S) ->
         if 
         From == S -> [To|vertex(T,S)];
         To == S   -> [From | vertex(T,S)];
         true      -> [From,To|vertex(T,S)]
         end.
remove_dups([])    -> [];
remove_dups([H|T]) -> [H | [X || X <- remove_dups(T), X /= H]].
vert(G,S) -> remove_dups(vertex(G,S)).

initial(G,S) -> initial(vert(G,S),S,[],[]).
initial([],S,D,P) -> {[{S,S,0}|D],P};
initial([H|T],S,Distance,Pred) -> 
       initial(T,S,[{S,H,1000}|Distance],[{pred,H,nil}|Pred]).

relax(V1,V2) -> 
V1.
 