?- [iddfs, while_concrete].

printStmts :-
	iddfs(whileStmtCST(Stmt)),
	format('~p~n', [Stmt]),
	false.
