-module(q2).

-export([convert/1]).
-import(q1, [c2f/1, f2c/1]).

convert({c,C}) ->
	{fehrenheit, q1:c2f(C)};
convert({f,F}) ->
	{celsius, q1:f2c(F)}.
