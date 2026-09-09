import __IMPORT__
import Lean
open Lean Elab Command

namespace ProofEdgesAudit

def moduleName : Name := `__MODULE__

def deps (info : ConstantInfo) : Array Name :=
  let v := match info.value? (allowOpaque := true) with
    | some value => value.getUsedConstants
    | none => #[]
  v ++ info.type.getUsedConstants

def isAux (n : Name) : Bool := (privateToUserName n).isInternalDetail

/-- direct module dependencies of `root`, expanding through auxiliary (internal-detail) constants. -/
partial def directDeps (env : Environment) (idx : ModuleIdx) (root : Name) : NameSet := Id.run do
  let mut pending : Array Name := (env.find? root).map deps |>.getD #[]
  let mut seen : NameSet := {}
  let mut out : NameSet := {}
  while h : 0 < pending.size do
    let n := pending.back
    pending := pending.pop
    if seen.contains n || n == root then continue
    seen := seen.insert n
    if env.getModuleIdxFor? n != some idx then continue
    if isAux n then
      pending := pending ++ ((env.find? n).map deps |>.getD #[])
    else
      out := out.insert n
  return out

def render (n : Name) : String :=
  let u := privateToUserName n
  let short := u.toString.stripPrefix (moduleName.toString ++ ".")
  if u == n then short else s!"{short} (private)"

elab "#proof_edges" : command => do
  let env ← getEnv
  let some idx := env.getModuleIdx? moduleName | throwError "module not loaded"
  let data := env.header.moduleData[idx.toNat]!
  for n in data.constNames do
    if isAux n then continue
    let ds := (directDeps env idx n).toArray.map render |>.qsort (· < ·)
    let kind := match env.find? n with
      | some (.thmInfo _) => "theorem" | some (.defnInfo _) => "def" | some (.opaqueInfo _) => "opaque"
      | some (.axiomInfo _) => "axiom" | some (.inductInfo _) => "inductive" | some (.ctorInfo _) => "constructor" | _ => "other"
    let used := ((env.find? n).map deps |>.getD #[]).map (·.toString)
    let closed := match env.find? n with | some info => !info.type.isForall | none => false
    let isNum := closed && used.any (fun s => s.startsWith "Mathlib.Meta.NormNum" || s == "of_decide_eq_true" || s.startsWith "Decidable.decide" || s == "Lean.ofReduceBool" || s == "Nat.decEq" || s.startsWith "Nat.decLe" || s.startsWith "Nat.decLt")
    -- constants this declaration uses that live in OTHER D5 modules (per-declaration frozen dependencies)
    let mut ext : Array String := #[]
    for c in ((env.find? n).map deps |>.getD #[]) do
      if env.getModuleIdxFor? c != some idx then
        if let some m := env.getModuleFor? c then
          if m.toString.startsWith "D5." then ext := ext.push (m.toString ++ ":" ++ (privateToUserName c).toString)
    let extSorted := ext.qsort (· < ·)
    let axsRaw ← collectAxioms n
    let axs := axsRaw.map (fun a => a.toString) |>.qsort (· < ·)
    logInfo m!"EDGE {render n} :: {kind} :: {String.intercalate ", " ds.toList} :: NUM={isNum} :: AX={String.intercalate ", " axs.toList} :: EXT={String.intercalate ", " extSorted.toList}"

end ProofEdgesAudit
#proof_edges
