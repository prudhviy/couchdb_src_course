-module(q3).

-export([perimeter/1]).

perimeter({square, Side}) ->
	4*Side;
perimeter({circle, Radius}) ->
	2 * (22/7) * Radius;
perimeter({triangle, A, B, C}) ->
	A + B + C.
