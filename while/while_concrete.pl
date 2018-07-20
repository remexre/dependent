?- use_module(library(gensym)).
?- op(700, xfx, :=).

whileAExprCST(Name) :- atom(Name).
whileAExprCST(Lit) :- integer(Lit).
whileAExprCST(L + R) :- whileAExprCST(L), whileAExprCST(R).

whileBExprCST(true).
whileBExprCST(false).
whileBExprCST(not(Expr)) :- whileBExprCST(Expr).
whileBExprCST(and(L, R)) :- whileBExprCST(L), whileBExprCST(R).
whileBExprCST(L = R) :- whileAExprCST(L), whileAExprCST(R).

whileStmtCST(skip).
whileStmtCST(Name := Expr) :- atom(Name), whileAExprCST(Expr).
whileStmtCST(if(C, T, E)) :- whileBExprCST(C), whileStmtCST(T), whileStmtCST(E).
whileStmtCST(while(Cond, Body)) :- whileBExprCST(Cond), whileStmtCST(Body).
whileStmtCST(L; R) :- whileStmtCST(L), whileStmtCST(R).
