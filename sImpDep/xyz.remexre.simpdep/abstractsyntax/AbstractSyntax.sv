grammar xyz:remexre:simpdep:abstractsyntax;

import silver:langutil;
import silver:langutil:pp;

nonterminal Root with errors, location, pp;

abstract production rootNil
top::Root ::=
{
  top.errors := [];
  top.pp = notext();
}

abstract production rootCons
top::Root ::= init::Root fini::Decl
{
  top.errors := init.errors ++ fini.errors;
  top.pp = cat(cat(init.pp, fini.pp), realLine());
}

nonterminal Decl with errors, location, pp;

abstract production declConst
top::Decl ::= name::String ty::Expr expr::Expr
{
  top.errors := [];
  top.pp = cat(ppImplode(space(), [ty.pp, text(name), text("="), expr.pp]), text(";"));
}

abstract production declFunc
top::Decl ::=
{
  top.errors := [];
  top.pp = error("TODO");
} 

nonterminal Expr with errors, location, pp;

abstract production exprBinop
top::Expr ::= l::Expr r::Expr op::Operator
{
  top.pp = parens(ppImplode(space(), [l.pp, op.pp, r.pp]));
}

abstract production exprCall
top::Expr ::= func::Expr implicits::[Expr] args::[Expr]
{
  local ppImplicits :: Document =
    cat(text("<{"), cat(ppImplode(text(", "), map((.pp), implicits)), text("}>")));
  local ppArgs :: Document = parens(ppImplode(text(", "), map((.pp), args)));
  top.pp = cat(if null(implicits) then func.pp else cat(func.pp, ppImplicits), ppArgs);
}

abstract production exprInt
top::Expr ::= value::Integer
{
  top.errors := [];
  top.pp = text(toString(value));
}

abstract production exprVar
top::Expr ::= name::String
{
  top.errors := [];
  top.pp = text(name);
}
