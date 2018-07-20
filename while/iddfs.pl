% A metainterpreter using IDDFS.

iddfs(Goal) :- iddfs(Goal, [true/0, atom/1, integer/1, is/2]).
iddfs(Goal, Builtins) :-
    counter(N),
    % (N > 10 -> !, fail; true),
    dldfs_normalize(Goal, Builtins, GoalN),
    dldfs(GoalN, Builtins, N, _).

% The positive integers.
counter(1).
counter(X1) :- !, counter(X0), X1 is X0 + 1.

dldfs((A, B), Builtins) --> dldfs(A, Builtins), dldfs(B, Builtins).
dldfs(builtin(Goal), _, N, N) :- Goal.
dldfs(goal(Goal), Builtins, N0, N2) :-
    N0 > 0,
    N1 is N0 - 1,
    dldfs_clause(Goal, Builtins, Body),
    dldfs(Body, Builtins, N1, N2).

dldfs_clause(Goal, Builtins, BodyN) :-
    clause(Goal, Body),
    dldfs_normalize(Body, Builtins, BodyN).

dldfs_normalize((A, B), Builtins, (NA, NB)) :-
    dldfs_normalize(A, Builtins, NA),
    dldfs_normalize(B, Builtins, NB).
dldfs_normalize(G, Builtins, Out) :-
    dldfs_builtin(G, Builtins) -> Out = builtin(G);
    G = (_, _) -> fail;
    true -> Out = goal(G).

dldfs_builtin(Goal, Builtins) :- functor(Goal, F, N), memberchk(F/N, Builtins).
