import LeanInformationAudit.Census.Coverage
import LeanInformationAudit.Census.Report

namespace LeanInformationAudit.CensusManifest

open Lean Meta DispositionCensus

private def literalNameExpr : Name → Expr
  | .anonymous => mkConst ``Name.anonymous
  | .str parent part => mkApp2 (mkConst ``Name.str) (literalNameExpr parent) (toExpr part)
  | .num parent part => mkApp2 (mkConst ``Name.num) (literalNameExpr parent) (toExpr part)

/-- Match the emitted constructor syntax, without ToExpr's Name.mkStrN compression. -/
def keysLiteralExpr (keys : List (Name × Nat)) : Expr :=
  letI : ToExpr Name := ⟨literalNameExpr, mkConst ``Name⟩
  toExpr keys

/-- All renderers consume this ordering: ascending decoded 256-bit ids. -/
def canonicalKeys (keys : Array StatementKey) : Except String (List (Name × Nat)) := do
  let values ← keys.mapM fun key => do
    return (key.theoremName, ← decodeStatementId key.theoremName key.statementId)
  return (values.qsort (fun a b => a.2 < b.2)).toList

private def bindKeys (component : String) (wire : Array StatementKey)
    (keys : List (Name × Nat)) : Except String Unit := do
  let sorted := wire.qsort (fun a b => a.statementId < b.statementId)
  unless sorted.size == keys.length do
    throw <| identityError .anonymous component (toString sorted.size) (toString keys.length)
  for (key, (name, value)) in sorted.toList.zip keys do
    unless key.theoremName == name do
      throw <| identityError name component (nameJson key.theoremName).compress (nameJson name).compress
    bindStatementIdNat name key.statementId value

/-- Both sides have independent authorities: the actual rows and immutable report.
Checking a reflexive equality alone cannot establish either binding. -/
def checkManifestBinding (report : FrozenReport) (root : Name) (rows : Array StatementKey)
    (m : CensusKeyManifest) (reportKeys : List (Name × Nat)) : Except String Unit := do
  checkFrozenKeys report.headSha report.theorems
  checkInventoryDuplicates rows
  unless m.reportSha256 == report.reportSha256 do
    throw <| identityError .anonymous "report_sha256" report.reportSha256 m.reportSha256
  unless m.censusRoot == root do
    throw <| identityError .anonymous "census_root" (nameJson root).compress (nameJson m.censusRoot).compress
  checkKeyCoverage report.headSha report.theorems m.headSha rows
  bindKeys "manifest_keys" rows m.keys
  bindKeys "report_keys" report.theorems reportKeys

/-- Build only adjacent Nat decisions. Every other conjunct is reflexivity on
canonical literals, then checked against the independently constructed full type. -/
def certificateProof (manifest : Expr) (head sha : String) (root : Name)
    (reportKeys : Expr) : MetaM Expr := do
  let keys ← mkAppM ``CensusKeyManifest.keys #[manifest]
  let projection := mkApp2 (mkConst ``Prod.snd [.zero, .zero]) (toTypeExpr Name) (toTypeExpr Nat)
  let ids ← mkAppM ``List.map #[projection, keys]
  let ordered ← mkAppM ``strictlyAscending #[ids]
  let orderProof ← mkDecideProof (← mkEq ordered (toExpr true))
  let equalityProof ← mkEqRefl keys
  let mut proof ← mkAppM ``And.intro #[orderProof, equalityProof]
  for value in [toExpr root, toExpr sha, toExpr head] do
    proof ← mkAppM ``And.intro #[← mkEqRefl value, proof]
  let expected ← mkAppM ``CensusKeyManifest.Certificate
    #[manifest, toExpr head, toExpr sha, toExpr root, reportKeys]
  unless ← isDefEq (← inferType proof) expected do
    throwError "{identityError .anonymous "certificate_type" "full manifest certificate" "detached proof"}"
  checkWithKernel proof
  return proof

end LeanInformationAudit.CensusManifest
