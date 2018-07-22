grammar xyz:remexre:simpdep:abstractsyntax;

import silver:langutil;
import silver:langutil:pp;

nonterminal Operator with kind, location, pp;
nonterminal OperatorKind;
synthesized attribute kind::OperatorKind;

abstract production opMul
top::Operator ::=
{
  top.kind = numop();
  top.pp = text("*");
}

abstract production opDiv
top::Operator ::=
{
  top.kind = numop();
  top.pp = text("/");
}

abstract production opAdd
top::Operator ::=
{
  top.kind = numop();
  top.pp = text("+");
}

abstract production opSub
top::Operator ::=
{
  top.kind = numop();
  top.pp = text("-");
}

abstract production logop
top::OperatorKind ::=
{}

abstract production numop
top::OperatorKind ::=
{}

abstract production relop
top::OperatorKind ::=
{}
