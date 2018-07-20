:- [iddfs].
:- op(700, xfx, :=).

whileAExprCST(Expr) :- iddfs(whileAExprCSTImpl(Expr)).
whileBExprCST(Expr) :- iddfs(whileBExprCSTImpl(Expr)).
whileStmtCST(Expr) :- iddfs(whileStmtCSTImpl(Expr)).

whileAExprCSTImpl(Name) :- atom(Name).
whileAExprCSTImpl(Lit) :- integer(Lit).
whileAExprCSTImpl(L + R) :- whileAExprCSTImpl(L), whileAExprCSTImpl(R).
whileAExprCSTImpl(L - R) :- whileAExprCSTImpl(L), whileAExprCSTImpl(R).
whileAExprCSTImpl(L * R) :- whileAExprCSTImpl(L), whileAExprCSTImpl(R).

whileBExprCSTImpl(true).
whileBExprCSTImpl(false).
whileBExprCSTImpl(not(Expr)) :- whileBExprCSTImpl(Expr).
whileBExprCSTImpl(and(L, R)) :- whileBExprCSTImpl(L), whileBExprCSTImpl(R).
whileBExprCSTImpl(L = R) :- whileAExprCSTImpl(L), whileAExprCSTImpl(R).

whileStmtCSTImpl(skip).
whileStmtCSTImpl(Name := Expr) :- atom(Name), whileAExprCSTImpl(Expr).
whileStmtCSTImpl(if(C, T, E)) :-
    whileBExprCSTImpl(C),
    whileStmtCSTImpl(T),
    whileStmtCSTImpl(E).
whileStmtCSTImpl(while(Cond, Body)) :- whileBExprCSTImpl(Cond), whileStmtCSTImpl(Body).
whileStmtCSTImpl(L; R) :- whileStmtCSTImpl(L), whileStmtCSTImpl(R).
