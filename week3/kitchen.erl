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

store(Pid, Food) ->
	Pid ! {self(), {store, Food}},
	receive
		{Pid, Msg} -> Msg
	after 3000 ->
		timeout
	end.

take(Pid, Food) ->
	Pid ! {self(), {take, Food}},
	receive
		{Pid, Msg} -> Msg
	after 3000 ->
		timeout
	end.

start(FoodList) ->
	spawn(?MODULE, fridge1, [FoodList]).

