import Lean

open Lean

/-- Type/constructor half of Inspector's axiom-closure traversal. -/
def declarationTypeDependencies : ConstantInfo → Array Name
  | .quotInfo _ => #[]
  | .inductInfo info => info.type.getUsedConstants ++ info.ctors.toArray
  | info => info.type.getUsedConstants

/-- The body walk is shared with the structural reader so a frozen value is
visited once. Opaque bodies are available in the private olean view. -/
def declarationValueDependencies (info : ConstantInfo) : Option (Array Name) :=
  (info.value? (allowOpaque := true)).map Expr.getUsedConstants

/-- The constants whose axiom closures are unioned by Inspector. Structural
folding uses this same type + value + constructor dependency definition. -/
def declarationDependencies (info : ConstantInfo) : Array Name :=
  declarationTypeDependencies info ++ (declarationValueDependencies info).getD #[]
