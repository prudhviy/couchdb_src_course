-module(lists1).

-export([min_max/1]).

min_max([F,S|T]) when F > S -> tail_min_max(T, S, F);
min_max([F,S|T]) when S > F -> tail_min_max(T, F, S).


tail_min_max([F|[]], Min, Max) ->
	if	F > Max -> {Min,F};
		F < Min -> {F,Max};
		true -> {Min,Max}
	end;
tail_min_max([F|T], Min, Max) ->
	if	F > Max  -> tail_min_max(T, Min, F);
		F < Min  -> tail_min_max(T, F, Max);
		true -> tail_min_max(T, Min, Max)
	end.

	
	
	
