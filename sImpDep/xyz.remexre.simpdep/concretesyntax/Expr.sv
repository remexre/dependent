grammar xyz:remexre:simpdep:concretesyntax;

import silver:langutil;
import silver:langutil:pp;
import xyz:remexre:simpdep:abstractsyntax;

nonterminal Expr_c with ast_Expr, location, pp;
synthesized attribute ast_Expr::Expr;

concrete production exprMul_c
top::Expr_c ::= l::Expr_c op::'*' r::Expr_c
{
  top.ast_Expr = exprBinop(l.ast_Expr, r.ast_Expr, opMul(location=op.location),
    location=top.location);
  top.pp = parens(ppImplode(text(" * "), [l.pp, r.pp]));
}

concrete production exprCall_c
top::Expr_c ::= func::Expr_c '(' args::Exprs_c ')'
{
  top.ast_Expr = exprCall(func.ast_Expr, [], args.ast_Exprs, location=top.location);
  top.pp = cat(func.pp, parens(args.pp));
}

concrete production exprCallImplicits_c
top::Expr_c ::= func::Expr_c '<{' implicits::Exprs_c '}>' '(' args::Exprs_c ')'
{
  top.ast_Expr = exprCall(func.ast_Expr, implicits.ast_Exprs, args.ast_Exprs,
    location=top.location);
  local ppImplicits :: Document = cat(text("<{"), cat(implicits.pp, text("}>")));
  top.pp = cat(cat(func.pp, ppImplicits), parens(args.pp));
}

concrete production exprInt_c
top::Expr_c ::= i::Int_t
{
  top.ast_Expr = exprInt(toInteger(i.lexeme), location=i.location);
  top.pp = text(i.lexeme);
}

concrete production exprVar_c
top::Expr_c ::= i::Identifier_t
{
  top.ast_Expr = exprVar(i.lexeme, location=i.location);
  top.pp = text(i.lexeme);
}

nonterminal Exprs_c with ast_Exprs, pp;
synthesized attribute ast_Exprs::[Expr];

-- TODO: Refactor for left recursion.

concrete production exprsZero_c
top::Exprs_c ::=
{
  top.ast_Exprs = [];
  top.pp = notext();
}

concrete production exprsOne_c
top::Exprs_c ::= expr::Expr_c
{
  top.ast_Exprs = [expr.ast_Expr];
  top.pp = expr.pp;
}

concrete production exprsCons_c
top::Exprs_c ::= h::Expr_c ',' t::Exprs_c
{
  top.ast_Exprs = cons(h.ast_Expr, t.ast_Exprs);
  top.pp = cat(cat(h.pp, text(", ")), t.pp);
}
