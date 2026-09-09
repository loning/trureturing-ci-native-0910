import Lean

/- Canonical Inspector statement material, shared by the producer and census. -/
open Lean

def atom (value : String) : String := s!"{value.utf8ByteSize}:{value}"

partial def encodeName : Name → String
  | .anonymous => "n0"
  | .str parent value => s!"ns({encodeName parent},{atom value})"
  | .num parent value => s!"nn({encodeName parent},{value})"

partial def encodeLevel : Level → String
  | .zero => "l0"
  | .succ level => s!"ls({encodeLevel level})"
  | .max left right => s!"lm({encodeLevel left},{encodeLevel right})"
  | .imax left right => s!"li({encodeLevel left},{encodeLevel right})"
  | .param name => s!"lp({encodeName name})"
  | .mvar id => s!"lv({encodeName id.name})"

def encodeBinderInfo : BinderInfo → String
  | .default => "bd"
  | .implicit => "bi"
  | .strictImplicit => "bs"
  | .instImplicit => "bc"

def encodeLiteral : Literal → String
  | .natVal value => s!"ln({value})"
  | .strVal value => s!"lt({atom value})"

partial def encodeExpr : Expr → String
  | .bvar index => s!"eb({index})"
  | .fvar id => s!"ef({encodeName id.name})"
  | .mvar id => s!"em({encodeName id.name})"
  | .sort level => s!"es({encodeLevel level})"
  | .const name levels =>
      s!"ec({encodeName name},[{String.intercalate "," (levels.map encodeLevel)}])"
  | .app function argument => s!"ea({encodeExpr function},{encodeExpr argument})"
  | .lam _ type body binderInfo =>
      s!"el({encodeBinderInfo binderInfo},{encodeExpr type},{encodeExpr body})"
  | .forallE _ type body binderInfo =>
      s!"ep({encodeBinderInfo binderInfo},{encodeExpr type},{encodeExpr body})"
  | .letE _ type value body nondependent =>
      s!"ee({if nondependent then "1" else "0"},{encodeExpr type},{encodeExpr value},{encodeExpr body})"
  | .lit literal => s!"ei({encodeLiteral literal})"
  | .mdata _ body => s!"ed({encodeExpr body})"
  | .proj name index body => s!"ej({encodeName name},{index},{encodeExpr body})"

def encodeStatement (info : ConstantInfo) : String :=
  let parameters := info.levelParams.map encodeName
  let header :=
    s!"statement-v1(uparams=[{String.intercalate "," parameters}],type={encodeExpr info.type}"
  match info with
  | .defnInfo _ | .opaqueInfo _ =>
      match info.value? (allowOpaque := true) with
      | some value => header ++ s!",value={encodeExpr value})"
      | none => header ++ ",value=missing)"
  | _ => header ++ ")"

