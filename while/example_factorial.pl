:- [while_predicates].

stmt(0, seq(1, s1)).
stmt(1, assign(z, e1)).
stmt(s1, while(2, s2)).
stmt(s2, seq(3, 4)).
stmt(3, assign(z, e2)).
stmt(4, assign(x, e3)).

expr(2, rop(gt, e4, e5)).
expr(e1, lit(1)).
expr(e2, aop(times, e6, e7)).
expr(e3, aop(minus, e4, e1)).
expr(e4, var(x)).
expr(e5, lit(0)).
expr(e6, var(z)).
expr(e7, var(y)).
