-module(q3).

-export([perimeter/1]).

perimeter(Form) ->
	case Form of
		{square, Side} ->
			{square, 4 * Side};
		{circle, Radius} ->
			{circle, 2 * (22/7) * Radius};
		{triangle, A, B, C} ->
			{triangle, A + B + C};
		{rectangle, Length, Width} ->
			{rectangle, 2 * Length + 2 * Width};
		_ ->
			{unknown}
	end.
