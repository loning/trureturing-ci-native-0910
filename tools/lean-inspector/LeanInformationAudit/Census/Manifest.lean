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

private def bindingError (component : String) : MetaM α :=
  throwError "{identityError .anonymous component "independent canonical chunks" "alias or expression"}"

/-- Compare constructor trees without evaluating definitions or requiring their IR.
Each side has its own names and is rendered from its own validated wire authority. -/
def bindChunkedKeys (listName : Name) (component : String)
    (wire : Array StatementKey) : MetaM (List (Name × Nat)) := do
  let keys ← ofExcept <| canonicalKeys wire
  let keyArray := keys.toArray
  let ordered := wire.qsort (fun a b => a.statementId < b.statementId)
  let chunkCount := (wire.size + 99) / 100
  let names := (List.range chunkCount).map (fun n => listName ++ .mkSimple ("chunk" ++ toString n))
  let keyType := toTypeExpr (Name × Nat)
  let chunks ← mkListLit (mkApp (mkConst ``List [.zero]) keyType) (names.map mkConst)
  let expected ← mkAppM ``List.flatten #[chunks]
  -- Lean's list notation inserts local lets. Only substitute those lets;
  -- global definitions (including aliases to the other side) stay opaque.
  let joined ← zetaReduce (← getConstInfoDefn listName).value (zetaDelta := false) (beta := false)
  unless joined == expected do
    bindingError (component ++ "_binding")
  for n in [:chunkCount] do
    let chunkName := names[n]!
    let actual ← zetaReduce (← getConstInfoDefn chunkName).value (zetaDelta := false) (beta := false)
    let chunk := keyArray.extract (n * 100) ((n + 1) * 100) |>.toList
    unless actual == keysLiteralExpr chunk do
      -- Preserve row/name/Nat diagnostics, even when the canonical tree is wrong.
      let mut tail := actual
      for key in ordered.extract (n * 100) ((n + 1) * 100) do
        unless tail.isAppOfArity ``List.cons 3 do bindingError component
        let pair := tail.getAppArgs[1]!
        unless pair.isAppOfArity ``Prod.mk 4 &&
            pair.getAppArgs[2]! == literalNameExpr key.theoremName do bindingError component
        let numeral := pair.getAppArgs[3]!
        unless numeral.isAppOfArity ``OfNat.ofNat 3 do bindingError component
        let some value := numeral.getAppArgs[1]!.rawNatLit? | bindingError component
        unless numeral == mkNatLit value do bindingError component
        ofExcept <| bindStatementIdNat key.theoremName key.statementId value
        tail := tail.getAppArgs[2]!
      bindingError component
  return keys

def bindEmittedManifest (report : FrozenReport) (root : Name) (rows : Array StatementKey)
    (manifestName reportKeysName : Name) : MetaM Unit := do
  ofExcept <| checkFrozenKeys report.headSha report.theorems
  ofExcept <| checkInventoryDuplicates rows
  let value := (← getConstInfoDefn manifestName).value
  unless value.isAppOfArity ``CensusKeyManifest.mk 4 do bindingError "manifest_keys"
  let args := value.getAppArgs
  let .lit (.strVal head) := args[0]! | bindingError "head"
  let .lit (.strVal sha) := args[1]! | bindingError "report_sha256"
  unless sha == report.reportSha256 do
    throwError "{identityError .anonymous "report_sha256" report.reportSha256 sha}"
  unless args[2]! == literalNameExpr root do bindingError "census_root"
  ofExcept <| checkKeyCoverage report.headSha report.theorems head rows
  let listName := manifestName.appendAfter "Keys"
  unless args[3]! == mkConst listName do bindingError "manifest_keys"
  if reportKeysName == listName then bindingError "report_keys_binding"
  let keys ← bindChunkedKeys listName "manifest_keys" rows
  let reportKeys ← bindChunkedKeys reportKeysName "report_keys" report.theorems
  ofExcept <| checkManifestBinding report root rows ⟨head, sha, root, keys⟩ reportKeys

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
