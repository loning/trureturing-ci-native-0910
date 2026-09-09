import Lean

open Lean

/-- Type/constructor half of Inspector's axiom-closure traversal. -/
def declarationTypeDependencies : ConstantInfo → Array Name
  | .quotInfo _ => #[]
  | .inductInfo info => info.type.getUsedConstants ++ info.ctors.toArray
  | info => info.type.getUsedConstants

/-- Structural seeds use proof values only. Opaque bodies are available in the
private olean view. -/
def declarationValueDependencies (info : ConstantInfo) : Option (Array Name) :=
  (info.value? (allowOpaque := true)).map Expr.getUsedConstants
