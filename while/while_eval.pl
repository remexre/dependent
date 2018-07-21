:- ['../util/util', while_predicates].

evalStmt(Id, EnvIn, EnvOut) :-
    stmt(Id, Stmt),
    ( Stmt = assign(Name, Expr) ->
          evalExpr(EnvIn, Expr, Value),
          EnvOut = [Name:Value|EnvIn]
    ; Stmt = if(Cond, Then, Else) ->
          evalExpr(EnvIn, Cond, Value),
          ( Value = true ->  evalStmt(Then, EnvIn, EnvOut)
          ; Value = false -> evalStmt(Else, EnvIn, EnvOut))
    ; Stmt = seq(A, B) ->
          evalStmt(A, EnvIn, EnvTmp),
          evalStmt(B, EnvTmp, EnvOut)
    ; Stmt = skip ->
          EnvOut = EnvIn
    ; Stmt = while(Cond, Body) ->
          evalExpr(EnvIn, Cond, Value),
          ( Value = true -> 
              evalStmt(Body, EnvIn, EnvTmp),
              evalStmt(Id, EnvTmp, EnvOut)
          ; Value = false ->
              EnvOut = EnvIn)).

evalExpr(Env, Id, Value) :-
    expr(Id, Expr),
    ( Expr = var(Name) ->
        assoc(Name, Value, Env)
    ; Expr = int(Lit) ->
        Value = Lit
    ; Expr = true -> value = true
    ; Expr = false -> value = false
    ; Expr = aop(Op, L, R) ->
        evalExpr(Env, L, ValL),
        evalExpr(Env, R, ValR),
        ( Op = plus  -> Value is ValL + ValR
        ; Op = minus -> Value is ValL - ValR
        ; Op = times -> Value is ValL * ValR)
    ; Expr = not(Id2) ->
        evalExpr(Env, Id2, Value2),
        ( Value2 = true  -> Value = false
        ; Value2 = false -> Value = true)
    ; Expr = bop(Op, L, R) ->
        evalExpr(Env, L, ValL),
        evalExpr(Env, R, ValR),
        ( Op = and -> evalCond((ValL = true, ValR = true), Value)
        ; Op = or  -> evalCond((ValL = true; ValR = true), Value))
    ; Expr = rop(Op, L, R) ->
        evalExpr(Env, L, ValL),
        evalExpr(Env, R, ValR),
        ( Op = eq -> evalCond(ValL = ValR, Value)
        ; Op = gt -> evalCond(ValL > ValR, Value)
        ; Op = lt -> evalCond(ValL < ValR, Value))).

evalCond(Cond, Value) :- Cond -> Value = true; Value = false.
