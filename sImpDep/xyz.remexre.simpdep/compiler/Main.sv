grammar xyz:remexre:simpdep:compiler;

import core:monad;
import silver:langutil;
import silver:langutil:pp;
import xyz:remexre:simpdep:abstractsyntax;
import xyz:remexre:simpdep:concretesyntax;

parser parse::Root_c
{
  xyz:remexre:simpdep:concretesyntax;
}

function main
IOVal<Integer> ::= args::[String] ioIn::IO
{
  return evalIO(do (bindIO, returnIO) {
    if null(args) then {
      printM("Usage: [sImpDep invocation] [filename]\n");
      return 5;
    } else {
      fileName::String = head(args);
      src::String <- readFileM(fileName);
      result::ParseResult<Root_c> = parse(src, fileName);
      if !result.parseSuccess then {
        printM(result.parseErrors ++ "\n");
        return 2;
      } else {
        ast::Root = result.parseTree.ast_Root;
        printM(show(80, ast.pp));
        if null(ast.errors) then {
          return 0;
        } else {
          printM(messagesToString(ast.errors) ++ "\n");
          return 1;
        }
      }
    }
  }, ioIn);
}
