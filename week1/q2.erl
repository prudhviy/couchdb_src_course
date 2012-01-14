-module(q2).

-export([convert/1]).

convert({c,C}) ->
	(C * (9/5)) + 32;
convert({f,F}) ->
	(F - 32) * (5/9).
