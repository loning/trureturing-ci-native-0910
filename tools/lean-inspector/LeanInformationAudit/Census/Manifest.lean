import LeanInformationAudit.Census.Coverage
import LeanInformationAudit.Census.Report

namespace LeanInformationAudit.CensusManifest

open Lean Meta DispositionCensus

private def literalNameExpr : Name → Expr
  | .anonymous => mkConst ``Name.anonymous
  | .str parent part => mkApp2 (mkConst ``Name.str) (literalNameExpr parent) (toExpr part)
  | .num parent part => mkApp2 (mkConst ``Name.num) (literalNameExpr parent) (toExpr part)

/-- All renderers consume ascending decoded ids. Name/hex/Nat correspondence is
an elaborator obligation; the JSON retains the original structured Name and hex. -/
def canonicalKeys (keys : Array StatementKey) : Except String (List Nat) := do
  let values ← keys.mapM fun key => decodeStatementId key.theoremName key.statementId
  return (values.qsort (· < ·)).toList

private def bindKeys (component : String) (wire : Array StatementKey)
    (keys : List Nat) : Except String Unit := do
  let sorted := wire.qsort (fun a b => a.statementId < b.statementId)
  unless sorted.size == keys.length do
    throw <| identityError .anonymous component (toString sorted.size) (toString keys.length)
  for (key, value) in sorted.toList.zip keys do
    bindStatementIdNat key.theoremName key.statementId value

/-- Both sides have independent authorities: actual rows and immutable report.
This checks metadata and Name-level binding; the kernel claims only an id set. -/
def checkManifestBinding (report : FrozenReport) (root : Name) (rows : Array StatementKey)
    (m : CensusKeyManifest) (reportKeys : List Nat) : Except String Unit := do
  checkIdentityInputs report.headSha report.theorems rows
  unless m.reportSha256 == report.reportSha256 do
    throw <| identityError .anonymous "report_sha256" report.reportSha256 m.reportSha256
  unless m.censusRoot == root do
    throw <| identityError .anonymous "census_root" (nameJson root).compress (nameJson m.censusRoot).compress
  checkKeyIdentity report.headSha report.theorems m.headSha rows
  bindKeys "manifest_keys" rows m.keys
  bindKeys "report_keys" report.theorems reportKeys
  checkMissingKeys report.headSha report.theorems rows

private def bindingError (component : String) : MetaM α :=
  throwError "{identityError .anonymous component "independent canonical chunks" "alias or expression"}"

/-- Pack validated 256-bit ids, least significant digit first. -/
def packIds (ids : List Nat) : Nat :=
  ids.foldr (fun value packed => value + 2 ^ 256 * packed) 0

/-- Match both the chunk graph and every packed Nat literal. No evalExpr or
unfolding of global definitions: cross-side aliases, moves, duplication, order
and arity changes are rejected before kernel proof construction. -/
def bindChunkedKeys (listName : Name) (component : String)
    (wire : Array StatementKey) : MetaM (List Nat) := do
  let keys ← ofExcept <| canonicalKeys wire
  let keyArray := keys.toArray
  let chunkCount := (wire.size + 99) / 100
  let names := (List.range chunkCount).map (fun n => listName ++ .mkSimple ("chunk" ++ toString n))
  let decoded := names.zipIdx |>.map fun (name, n) =>
    mkApp2 (mkConst ``decodeIds) (mkNatLit (min 100 (wire.size - n * 100))) (mkConst name)
  let chunks ← mkListLit (toTypeExpr (List Nat)) decoded
  let expected ← mkAppM ``List.flatten #[chunks]
  -- List notation inserts local lets. Substitute only those lets; global
  -- definitions (including an alias to the other side) remain opaque.
  let joined ← zetaReduce (← getConstInfoDefn listName).value (zetaDelta := false) (beta := false)
  unless joined == expected do bindingError (component ++ "_binding")
  for n in [:chunkCount] do
    let actual := (← getConstInfoDefn names[n]!).value
    unless actual.isAppOfArity ``OfNat.ofNat 3 do bindingError component
    let .lit (.natVal value) := actual.getAppArgs[1]! | bindingError component
    unless actual == mkNatLit value do bindingError component
    let chunk := keyArray.extract (n * 100) ((n + 1) * 100) |>.toList
    let packed := packIds chunk
    unless (.lit (.natVal value) : Expr) == .lit (.natVal packed) do
      -- Preserve the row's strict codec diagnostic on a mismatching digit.
      let ordered := wire.qsort (fun a b => a.statementId < b.statementId)
      for (key, digit) in (ordered.extract (n * 100) ((n + 1) * 100)).toList.zip
          (decodeIds chunk.length value) do
        ofExcept <| bindStatementIdNat key.theoremName key.statementId digit
      bindingError component
  return keys

def bindEmittedManifest (report : FrozenReport) (root : Name) (rows : Array StatementKey)
    (manifestName reportKeysName : Name) : MetaM Unit := do
  ofExcept <| checkIdentityInputs report.headSha report.theorems rows
  let value := (← getConstInfoDefn manifestName).value
  unless value.isAppOfArity ``CensusKeyManifest.mk 4 do bindingError "manifest_keys"
  let args := value.getAppArgs
  let .lit (.strVal head) := args[0]! | bindingError "head"
  let .lit (.strVal sha) := args[1]! | bindingError "report_sha256"
  unless sha == report.reportSha256 do
    throwError "{identityError .anonymous "report_sha256" report.reportSha256 sha}"
  unless args[2]! == literalNameExpr root do bindingError "census_root"
  ofExcept <| checkKeyIdentity report.headSha report.theorems head rows
  let listName := manifestName.appendAfter "Keys"
  unless args[3]! == mkConst listName do bindingError "manifest_keys"
  if reportKeysName == listName then bindingError "report_keys_binding"
  discard <| bindChunkedKeys listName "manifest_keys" rows
  discard <| bindChunkedKeys reportKeysName "report_keys" report.theorems
  ofExcept <| checkMissingKeys report.headSha report.theorems rows

/-- Decide only linear order and length. Reflexivity compares the independently
bound chunk graphs for equality without deciding quadratic Nodup/Finset goals. -/
def certificateProof (ids : Expr) (requested : Nat) (reportIds : Expr) : MetaM Expr := do
  let ordered ← mkAppM ``strictlyAscending #[ids]
  let orderProof ← mkDecideProof (← mkEq ordered (toExpr true))
  let length ← mkAppM ``List.length #[ids]
  let lengthProof ← mkDecideProof (← mkEq length (toExpr requested))
  let equalityProof ← mkEqRefl ids
  let tail ← mkAppM ``And.intro #[lengthProof, equalityProof]
  let proof ← mkAppM ``And.intro #[orderProof, tail]
  let expected ← mkAppM ``CensusKeyManifest.Certificate #[ids, toExpr requested, reportIds]
  unless ← isDefEq (← inferType proof) expected do
    throwError "{identityError .anonymous "certificate_type" "id order, length and report equality" "detached proof"}"
  checkWithKernel proof
  return proof

end LeanInformationAudit.CensusManifest
