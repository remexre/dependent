:- [while_abstract, while_concrete, while_eval, while_flow, while_print, while_typing].

printStmts :-
    whileStmtCST(Stmt),
    format('~p~n', [Stmt]),
    false.
