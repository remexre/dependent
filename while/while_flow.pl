:- [while_predicates].
:- op(1050, yfx, <-).
:- table flow/2.

flow(From, To) :-
    stmt(_, Stmt),
    ( Stmt = assign(_, _) ->         fail
    ; Stmt = if(From, Then, Else) -> (init(Then, To); init(Else, To))
    ; Stmt = seq(A, B) ->            final(A, From), init(B, To)
    ; Stmt = skip ->                 fail
    ; Stmt = while(Cond, Body) ->    ( (From = Cond, init(Body, To))
                                     ; (final(Body, From), To = Cond))).

flowIn(TopStmtId, From, To) :-
	flow(From, To),
	blocks(TopStmtId, From),
	blocks(TopStmtId, To).

flows(TopStmtId, Flows) :- setof(F -> T, flowIn(TopStmtId, F, T), Flows).
flowsR(TopStmtId, Flows) :- setof(T <- F, flowIn(TopStmtId, F, T), Flows).

init(StmtId, InitId) :- stmt(StmtId, Stmt), init(StmtId, Stmt, InitId).
final(StmtId, InitId) :- stmt(StmtId, Stmt), final(StmtId, Stmt, InitId).
blocks(StmtId, InitId) :- stmt(StmtId, Stmt), blocks(StmtId, Stmt, InitId).

init(Id, assign(_, _), Id).
init(_, if(Id, _, _), Id).
init(_, seq(A, _), Id) :- init(A, Id).
init(Id, skip, Id).
init(_, while(Id, _), Id).

final(Id, assign(_, _), Id).
final(_, if(_, T, _), Id) :- final(T, Id).
final(_, if(_, _, E), Id) :- final(E, Id).
final(_, seq(_, B), Id) :- final(B, Id).
final(Id, skip, Id).
final(_, while(Id, _), Id).

blocks(Id, assign(_, _), Id).
blocks(_, if(Id, _, _), Id).
blocks(_, if(_, T, _), Id) :- blocks(T, Id).
blocks(_, if(_, _, E), Id) :- blocks(E, Id).
blocks(_, seq(A, _), Id) :- blocks(A, Id).
blocks(_, seq(_, B), Id) :- blocks(B, Id).
blocks(Id, skip, Id).
blocks(_, while(Id, _), Id).
blocks(_, while(_, B), Id) :- blocks(B, Id).
