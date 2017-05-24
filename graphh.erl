%%%-------------------------------------------------------------------
%%% @author ben
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. mar 2017 18:11
%%%-------------------------------------------------------------------
-module(graphh).
-author("ben").

%% API
-compile(export_all).

%% graph term -> [a,b,c,d], [{a,b},{a,c},{d,a}]
%% graph term -> [a,b,c,d], [{a,b,4},{a,c,8},{d,a,6}]