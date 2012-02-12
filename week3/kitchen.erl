-module(kitchen).

-compile(export_all).

fridge1(FoodList) ->
	receive
		{From, {store, Food}} ->
			From ! {self(), ok},
			fridge1([Food|FoodList]);
		{From, {take, Food}} ->
			case lists:member(Food, FoodList) of
				true ->
					From ! {self(), {ok, Food}},
					fridge1(lists:delete(Food, FoodList));
				false ->
					From ! {self(), not_found},
					fridge1(FoodList)
			end;
		terminate ->
			ok
	end.

store(Food) ->
	fridge ! {self(), {store, Food}},
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

start() ->
	restart().

restart() ->
	process_flag(trap_exit, true),
	Pid = spawn_link(?MODULE, fridge1, [apple, banana]),
	register(fridge, Pid),
	receive
		{'EXIT', Pid, normal} -> {ok, normal_exit};
		{'EXIT', Pid, shutdown} -> {ok, shutdown_exit};
		{'EXIT', Pid, _} -> restart()
	end.

