:- [while_predicates].

formatStmt(Id, A) :- concretifyStmt(Id, Stmt), format(atom(A), '~p', Stmt).
formatExpr(Id, A) :- concretifyExpr(Id, Expr), format(atom(A), '~p', Expr).

concretifyExpr(Id, C) :- 
	expr(Id, A),
	( A = var(C) ->               atom(C)
	; A = int(C) ->               integer(C)
    ; A = true ->                 C = true
    ; A = false ->                C = false
	; A = aop(plus, IdL, IdR) ->  concretifyExpr(IdL, L), concretifyExpr(IdR, R), C = L + R
	; A = aop(minus, IdL, IdR) -> concretifyExpr(IdL, L), concretifyExpr(IdR, R), C = L - R
	; A = aop(times, IdL, IdR) -> concretifyExpr(IdL, L), concretifyExpr(IdR, R), C = L * R
	; A = bop(and, IdL, IdR) ->   concretifyExpr(IdL, L), concretifyExpr(IdR, R), C = and(L, R)
	; A = bop(or, IdL, IdR)  ->   concretifyExpr(IdL, L), concretifyExpr(IdR, R), C = or(L, R)
    ; A = not(IdE) ->             concretifyExpr(IdE, E),                         C = not(E)
	; A = rop(eq, IdL, IdR) ->    concretifyExpr(IdL, L), concretifyExpr(IdR, R), C = (L = R)
	; A = rop(gt, IdL, IdR) ->    concretifyExpr(IdL, L), concretifyExpr(IdR, R), C = (L > R)
	; A = rop(lt, IdL, IdR) ->    concretifyExpr(IdL, L), concretifyExpr(IdR, R), C = (L < R)).

concretifyStmt(Id, C) :-
    stmt(Id, A),
    ( A = assign(N, IdE) ->
          concretifyExpr(IdE, E),
          C = (N := E)
    ; A = if(IdCond, IdThen, IdElse) ->
          concretifyExpr(IdCond, Cond),
          concretifyStmt(IdThen, Then),
          concretifyStmt(IdElse, Else),
          C = if(Cond, Then, Else)
    ; A = seq(IdL, IdR) ->
          concretifyStmt(IdL, L),
          concretifyStmt(IdR, R),
          C = (L; R)
    ; A = skip -> C = skip
	; A = while(IdCond, IdBody) ->
          concretifyExpr(IdCond, Cond),
          concretifyStmt(IdBody, Body),
          C = while(Cond, Body)).
