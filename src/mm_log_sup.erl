%%  Copyright (C) 2012 - Molchanov Maxim
-module(mm_log_sup).

-author('author Maxim Molchanov <elzor.job@gmail.com>').

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
	{ok, IsMaster} = config:get(this_is_master_node),
	if 
		IsMaster == true ->
			Mods = [
				?CHILD(log_collector, worker),
				?CHILD(log, worker)
			];
		true->
			Mods = [
				?CHILD(log, worker)
			]
	end,
    {ok, { {one_for_one, 5, 10}, Mods} }.

