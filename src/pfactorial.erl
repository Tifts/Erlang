-module (pfactorial).
-export ([factorial/2, facProc/1, start/2, receiver/2]).

factorial(0, List) -> [1 | List];
factorial(N, List) -> 
	factorial(N-1, [fac(N) | List]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% start(N) ->
% 	ReceiverPid = spawn(?MODULE, receiver, [{self(), N}, []]),
% 	main({ReceiverPid, N}),
% 	receive
% 		List -> List
% 	end.


% main({_, 0}) -> ok;
% main({ReceiverPid, N}) ->
% 	spawn(?MODULE, facProc, [{ReceiverPid, N}]),
% 	main({ReceiverPid, N-1}).


% receiver({ParentPid, 0}, List) 	-> ParentPid ! lists:sort(List);
% receiver({ParentPid, N}, List)	->
% 	receive 
% 		Liczba -> receiver( {ParentPid, N-1}, [Liczba | List])
% 	end.


% facProc({ReceiverPid,N}) ->
% 	ReceiverPid ! fac(N).


% fac(0) -> 1;
% fac(N) -> N * fac(N-1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Mądrze

start(N, K) ->
	ReceiverPid = spawn(?MODULE, receiver, [{self(), N}, []]),
	main({ReceiverPid, N, K, K}),
	receive
		List -> List
	end.	

main({_, _, _, 0}) -> ok;
main({ReceiverPid, N, R, K}) ->
	spawn(?MODULE, facProc, [{ReceiverPid, [X || X <- lists:seq(K, N, R)]}]),
	main({ReceiverPid, N, R, K-1}).

receiver({ParentPid, 0}, List) 	-> ParentPid ! lists:sort(List);
receiver({ParentPid, N}, List)	->
	receive 
		Liczba -> 
			receiver( {ParentPid, N-1}, [Less || Less <- List, Less < Liczba] ++ [Liczba] ++ [More || More <- List, More >= Liczba])
	end.

facProc({_, []}) -> 0;
facProc({ReceiverPid, [H | T]}) ->
	ReceiverPid ! fac(H),
	facProc({ReceiverPid, T}).

fac(0) -> 1;
fac(N) -> N * fac(N-1).
