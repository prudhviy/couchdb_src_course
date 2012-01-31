-module(dolphins).

-compile(export_all).

dolphin1() ->
	receive
		{From, do_a_flip} ->
			From ! "how about no? ~n",
			dolphin1();
		{From, fish} ->
			From ! "so long and thanks for all the fish~n";
		_ ->
			io:format("heh, we're smarter than you humans.~n"),
			dolphin1()
	end.
