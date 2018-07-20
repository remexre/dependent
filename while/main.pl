#!/usr/bin/env swipl

?- [while].
?- initialization(main, program).

main :-
	format('hello, world!~n', []),
	iddfs(printStmts),
	halt.
