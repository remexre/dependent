grammar xyz:remexre:simpdep:concretesyntax;

import silver:langutil;
import silver:langutil:pp;
import xyz:remexre:simpdep:abstractsyntax;

nonterminal Root_c with ast_Root, location, pp;
synthesized attribute ast_Root::Root;

concrete production rootNil_c
top::Root_c ::=
{
  top.ast_Root = rootNil(location=top.location);
  top.pp = notext();
}

concrete production rootCons_c
top::Root_c ::= init::Root_c fini::Decl_c
{
  top.ast_Root = rootCons(init.ast_Root, fini.ast_Decl, location=top.location);
  top.pp = cat(cat(init.pp, realLine()), cat(realLine(), fini.pp));
}

nonterminal Decl_c with ast_Decl, location, pp;
synthesized attribute ast_Decl::Decl;

concrete production declConst_c
top::Decl_c ::= ty::Expr_c name::Identifier_t '=' expr::Expr_c ';'
{
  top.ast_Decl = declConst(name.lexeme, ty.ast_Expr, expr.ast_Expr, location=top.location);
  top.pp = cat(ppImplode(space(), [ty.pp, text(name.lexeme), text("="), expr.pp]), text(";"));
}
