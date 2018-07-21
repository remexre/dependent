:- ['../util/iddfs'].
:- op(700, xfx, :=).
:- op(1000, fy, func).

whileExprCST(Expr) :- iddfs(whileExprCSTImpl(Expr)).
whileStmtCST(Expr) :- iddfs(whileStmtCSTImpl(Expr)).

whileExprCSTImpl(Name) :- atom(Name).
whileExprCSTImpl(Lit) :- integer(Lit).
whileExprCSTImpl(true).
whileExprCSTImpl(false).
whileExprCSTImpl(L + R) :- whileExprCSTImpl(L), whileExprCSTImpl(R).
whileExprCSTImpl(L - R) :- whileExprCSTImpl(L), whileExprCSTImpl(R).
whileExprCSTImpl(L * R) :- whileExprCSTImpl(L), whileExprCSTImpl(R).
whileExprCSTImpl(not(Expr)) :- whileExprCSTImpl(Expr).
whileExprCSTImpl(and(L, R)) :- whileExprCSTImpl(L), whileExprCSTImpl(R).
whileExprCSTImpl(or(L, R)) :- whileExprCSTImpl(L), whileExprCSTImpl(R).
whileExprCSTImpl(L = R) :- whileExprCSTImpl(L), whileExprCSTImpl(R).
whileExprCSTImpl(L > R) :- whileExprCSTImpl(L), whileExprCSTImpl(R).
whileExprCSTImpl(L < R) :- whileExprCSTImpl(L), whileExprCSTImpl(R).

whileStmtCSTImpl(skip).
whileStmtCSTImpl(Name := Expr) :- atom(Name), whileExprCSTImpl(Expr).
whileStmtCSTImpl(if(C, T, E)) :-
    whileExprCSTImpl(C),
    whileStmtCSTImpl(T),
    whileStmtCSTImpl(E).
whileStmtCSTImpl(while(Cond, Body)) :- whileExprCSTImpl(Cond), whileStmtCSTImpl(Body).
whileStmtCSTImpl(L; R) :- whileStmtCSTImpl(L), whileStmtCSTImpl(R).
