:- [while_abstract, while_concrete, while_eval, while_flow].

printStmts :-
    whileStmtCST(Stmt),
    format('~p~n', [Stmt]),
    false.

% An example program.
stmt(0, seq(1, s1)).
stmt(1, assign(z, e1)).
stmt(s1, while(2, s2)).
stmt(s2, seq(3, 4)).
stmt(3, assign(z, e2)).
stmt(4, assign(x, e3)).
bexpr(2, rop(gt, e4, e5)).
aexpr(e1, lit(1)).
aexpr(e2, aop(times, e6, e7)).
aexpr(e3, aop(minus, e4, e1)).
aexpr(e4, var(x)).
aexpr(e5, lit(0)).
aexpr(e6, var(z)).
aexpr(e7, var(y)).
