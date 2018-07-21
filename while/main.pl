#!/usr/bin/env swipl

:- [analysis_available, while].
:- initialization(main, program).

main :-
    Program = (
        y := x;
        z := 1;
        while(y > 1,
            z := z * y;
            y := y - 1);
        y := 0
    ),
    assertWhileStmt(Program, ProgramId),
	!,
	% Print the program again.
	formatStmt(ProgramId, PP), format('~p~n', [PP]),
	!,
	% Print flow analysis.
	flows(ProgramId, F), format('Flows = ~p~n', [F]),
	!,
	% Print evaluation.
	evalStmt(ProgramId, [x:10], Env),
	assoc(z, Z, Env),
	format('Env = ~p~nEnv.z = ~p~n', [Env, Z]),
	!,
	% Exit.
    halt.
