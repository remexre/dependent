:- [while_concrete, while_predicates].
:- use_module(library(gensym)).

:- table assertWhileExpr/2.
:- table assertWhileFunc/2.
:- table assertWhileProg/2.
:- table assertWhileStmt/2.

assertWhileExpr(C, Id) :- 
    gensym(expr, Id),
    ( atom(C) ->    A = var(C)
    ; integer(C) -> A = lit(C)
    ; C = true ->      A = true
    ; C = false ->     A = false
    ; C = L + R ->  assertWhileExpr(L, IdL), assertWhileExpr(R, IdR), A = aop(plus, IdL, IdR)
    ; C = L - R ->  assertWhileExpr(L, IdL), assertWhileExpr(R, IdR), A = aop(minus, IdL, IdR)
    ; C = L * R ->  assertWhileExpr(L, IdL), assertWhileExpr(R, IdR), A = aop(times, IdL, IdR)
    ; C = not(E) ->    assertWhileExpr(E, IdE), A = not(IdE)
    ; C = and(L, R) -> assertWhileExpr(L, IdL), assertWhileExpr(R, IdR), A = bop(and, IdL, IdR)
    ; C = or(L, R) ->  assertWhileExpr(L, IdL), assertWhileExpr(R, IdR), A = bop(or, IdL, IdR)
    ; C = (L = R) ->   assertWhileExpr(L, IdL), assertWhileExpr(R, IdR), A = rop(eq, IdL, IdR)
    ; C = (L > R) ->   assertWhileExpr(L, IdL), assertWhileExpr(R, IdR), A = rop(gt, IdL, IdR)
    ; C = (L < R) ->   assertWhileExpr(L, IdL), assertWhileExpr(R, IdR), A = rop(lt, IdL, IdR)),
    assert(expr(Id, A)).

assertWhileFunc(C, Id) :-
	gensym(func, Id),
	todo.

assertWhileProg(C, Id) :- fail.

assertWhileStmt(C, Id) :- 
    gensym(stmt, Id),
    ( C = (N := E) ->
          atom(N),
          assertWhileExpr(E, IdE),
          A = assign(N, IdE);
      C = if(Cond, Then, Else) ->
          assertWhileExpr(Cond, IdCond),
          assertWhileStmt(Then, IdThen),
          assertWhileStmt(Else, IdElse),
          A = if(IdCond, IdThen, IdElse);
      C = (L; R) ->
          assertWhileStmt(L, IdL),
          assertWhileStmt(R, IdR),
          A = seq(IdL, IdR);
      C = skip -> A = skip;
      C = while(Cond, Body) ->
          assertWhileExpr(Cond, IdCond),
          assertWhileStmt(Body, IdBody),
          A = while(IdCond, IdBody)),
    assert(stmt(Id, A)).
