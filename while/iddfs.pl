% A metainterpreter using IDDFS.
iddfs(Goal) :- iddfs(Goal, [true/0, atom/1, integer/1]).
iddfs(Goal, Defs) :-
	counter(N),
	(N > 10 -> !, fail; true),
    dldfs_normalize(Goal, Defs, GoalN),
    dldfs(GoalN, Defs, N, _).

counter(1).
counter(X1) :- !, counter(X0), X1 is X0 + 1.

dldfs((A, B), Defs) --> dldfs(A, Defs), dldfs(B, Defs).
dldfs(builtin(Goal), _, N, N) :- Goal.
dldfs(goal(Goal), Defs, N0, N2) :-
    N0 > 0,
    N1 is N0 - 1,
    dldfs_clause(Goal, Defs, Body),
    dldfs(Body, Defs, N1, N2).

dldfs_clause(Goal, Defs, BodyN) :-
    clause(Goal, Body),
    dldfs_normalize(Body, Defs, BodyN).

dldfs_normalize((A, B), Defs, (NA, NB)) :-
    dldfs_normalize(A, Defs, NA),
    dldfs_normalize(B, Defs, NB).
dldfs_normalize(G, Defs, Out) :-
    (functor(G, F, N), memberchk(F/N, Defs)) -> Out = builtin(G);
    G = (_, _) ->                               fail;
                                                Out = goal(G).
