-module(kitchen).

-compile(export_all).

fridge1(FoodList) ->
	receive
		{From, {store, {Food, Temp}}} ->
			From ! {self(), ok},
			fridge1([{Food, Temp}|FoodList]);
		{From, {take, Food}} ->
			case lists:member(Food, FoodList) of
				true ->
					From ! {self(), {ok, Food}},
					fridge1(lists:delete(Food, FoodList));
				false ->
					from ! {self(), not_found},
					fridge1(FoodList)
			end;
		{From, {cool, By_temp, Min_temp}} ->
			Cooled_items = [ {Item, Temp - By_temp} || {Item, Temp}<- FoodList, Temp =< Min_temp],
			From ! {self(), {cooled, Cooled_items}},
			fridge1(Cooled_items);
		terminate ->
			{ok, stopped}
	end.

store(Food, Temp) ->
	fridge ! {self(), {store, {Food, Temp}}},
	receive
		{Pid, Msg} -> Msg
	after 3000 ->
		timeout
	end.

take(Food) ->
	fridge ! {self(), {take, Food}},
	receive
		{Pid, Msg} -> Msg
	after 3000 ->
		timeout
	end.

%% our desired temperature is 30 degrees and for every 3 secs
%% reduce temp by 2 degrees
cooler(Time) ->
	fridge ! {self(), {cool, 2, 30}},
	receive
		{Pid, {cooled, FoodList}} ->
			io:format("current temp and items: ~n~p~n", [FoodList]),
			cooler(Time);
		terminate ->
			{ok, stopped}
	after Time ->
		fridge ! {self(), {cool, 2}},
		cooler(Time)	
	end.

start_compressor() ->
	Pid = spawn_link(?MODULE, cooler, [2000]),
	{ok, Pid}.
	
start() ->
	spawn(?MODULE, restart, [[{apple, 35},{banana, 40}]]).

restart(FoodList) ->
	process_flag(trap_exit, true),
	Pid = spawn_link(?MODULE, fridge1, [[]]),
	register(fridge, Pid),
	start_compressor(),
	receive
		{'EXIT', Pid, normal} -> {ok, normal_exit};
		{'EXIT', Pid, shutdown} -> {ok, shutdown_exit};
		{'EXIT', Pid, _} -> {unknown, Pid}
	end.

stop() ->
	fridge ! terminate.
