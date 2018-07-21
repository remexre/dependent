:- [while_flow].

stmt(0, seq(1, s1)).
stmt(1, assign(x, e1)).
stmt(2, assign(y, e2)).
stmt(4, assign(a, e3)).
stmt(5, assign(x, e1)).
stmt(s1, seq(2, s2)).
stmt(s2, while(3, s3)).
stmt(s3, seq(4, 5)).

expr(3, rop(gt, e5, e1)).
expr(e1, aop(plus, e6, e7)).
expr(e2, aop(times, e6, e7)).
expr(e3, aop(plus, e6, e8)).
expr(e4, var(x)).
expr(e5, var(y)).
expr(e6, var(a)).
expr(e7, var(b)).
expr(e8, lit(1)).
