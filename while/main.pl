#!/usr/bin/env swipl

:- [analysis_reaching, while].
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
    assertWhileStmt(Program, ProgId),
	% Print flow analysis.
	findall(format('~p -> ~p~n', [From, To]), flow(From, To), _),
	% Print evaluation.
    evalStmt(ProgId, _, Env),
    format('Env = ~p~n', [Env]),
    halt.
