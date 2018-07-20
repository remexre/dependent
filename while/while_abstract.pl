:- [while_concrete, while_predicates].
:- use_module(library(gensym)).
:- use_module(library(tabling)).

:- table assertWhileAExpr/2.
:- table assertWhileBExpr/2.
:- table assertWhileStmt/2.

assertWhileAExpr(C, Id) :- 
    gensym(aexpr, Id),
    ( atom(C) ->    A = var(C)
    ; integer(C) -> A = lit(C)
    ; C = L + R ->  assertWhileAExpr(L, IdL), assertWhileAExpr(R, IdR), A = aop(plus, IdL, IdR)
    ; C = L - R ->  assertWhileAExpr(L, IdL), assertWhileAExpr(R, IdR), A = aop(minus, IdL, IdR)
    ; C = L * R ->  assertWhileAExpr(L, IdL), assertWhileAExpr(R, IdR), A = aop(times, IdL, IdR)),
    assert(aexpr(Id, A)).

assertWhileBExpr(C, Id) :- 
    gensym(bexpr, Id),
    ( C = true ->      A = true
    ; C = false ->     A = false
    ; C = not(E) ->    assertWhileBExpr(E, IdE), A = not(IdE)
    ; C = and(L, R) -> assertWhileBExpr(L, IdL), assertWhileBExpr(R, IdR), A = bop(and, IdL, IdR)
    ; C = (L = R) ->   assertWhileAExpr(L, IdL), assertWhileAExpr(R, IdR), A = rop(eq, IdL, IdR)
    ; C = (L > R) ->   assertWhileAExpr(L, IdL), assertWhileAExpr(R, IdR), A = rop(gt, IdL, IdR)
    ; C = (L < R) ->   assertWhileAExpr(L, IdL), assertWhileAExpr(R, IdR), A = rop(lt, IdL, IdR)),
    assert(bexpr(Id, A)).

assertWhileStmt(C, Id) :- 
    gensym(stmt, Id),
    ( C = (N := E) ->
          atom(N),
          assertWhileAExpr(E, IdE),
          A = assign(N, IdE);
      C = if(Cond, Then, Else) ->
          assertWhileBExpr(Cond, IdCond),
          assertWhileStmt(Then, IdThen),
          assertWhileStmt(Else, IdElse),
          A = if(IdCond, IdThen, IdElse);
      C = (L; R) ->
          assertWhileStmt(L, IdL),
          assertWhileStmt(R, IdR),
          A = seq(IdL, IdR);
      C = skip -> A = skip;
      C = while(Cond, Body) ->
          assertWhileBExpr(Cond, IdCond),
          assertWhileStmt(Body, IdBody),
          A = while(IdCond, IdBody)),
    assert(stmt(Id, A)).
