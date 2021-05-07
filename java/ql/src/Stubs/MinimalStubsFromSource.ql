/**
 * Tool to generate C# stubs from a qltest snapshot.
 *
 * It finds all declarations used in the source code,
 * and generates minimal C# stubs containing those declarations
 * and their dependencies.
 */

import java
import Stubs

/** Declarations used by source code. */
class UsedInSource extends GeneratedDeclaration {
  UsedInSource() {
    (
      this = any(Variable v | v.fromSource()).getType()
      or
      this = any(Expr e | e.getEnclosingCallable().fromSource()).getType()
      or
      this = any(RefType t | t.fromSource())
    )
  }
}

from GeneratedTopLevel t
where not t.fromSource()
select t.getQualifiedName(), t.stubFile()
