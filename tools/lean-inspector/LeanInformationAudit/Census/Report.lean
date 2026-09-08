import LeanInformationAudit.CensusSchema
import LeanInformationAudit.Sha256
import LeanInformationAudit.Census.Codec
import Std.Internal.Parsec.ByteArray

namespace LeanInformationAudit

open Lean

namespace DispositionCensus

private def checkFrozenKeys (head : String) (keys : Array StatementKey) : Except String Unit := do
  let mut ids : Std.HashSet String := {}
  for key in keys do
    if ids.contains key.statementId then
      throw <| censusError head "frozen_keys" "unique" (toJson key).compress
    ids := ids.insert key.statementId
  for key in keys do
    discard <| decodeStatementId key.theoremName key.statementId

/-- Duplicate statement IDs are checked before identity and missing-row diagnostics. -/
def checkKeyCoverage (head : String) (frozen : Array StatementKey)
    (inventoryHead : String) (rows : Array StatementKey) : Except String Unit := do
  let expected := frozen.qsort StatementKey.lt
  checkFrozenKeys head expected
  let mut records : Std.HashMap String (Array Nat) := {}
  for i in [:rows.size] do
    let id := rows[i]!.statementId
    records := records.insert id ((records.getD id #[]).push i)
  for key in rows do
    let duplicates := records.getD key.statementId #[]
    if duplicates.size > 1 then
      throw s!"IE-C035 DuplicateAnalysisDisposition theorem={key.theoremName} statement_id={key.statementId} records={(toJson duplicates).compress}"
  for key in rows do
    discard <| decodeStatementId key.theoremName key.statementId
  for key in expected do
    unless inventoryHead == head do
      throw <| identityError key.theoremName "head" head inventoryHead
  unless inventoryHead == head do
    throw <| identityError .anonymous "head" head inventoryHead
  let names : Std.HashMap Name (Array String) :=
    expected.foldl (init := {}) fun result key =>
      result.insert key.theoremName ((result.getD key.theoremName #[]).push key.statementId)
  for key in rows.qsort StatementKey.lt do
    match names[key.theoremName]? with
    | some ids =>
      unless ids.contains key.statementId do
        throw <| identityError key.theoremName "statement_id" ids[0]! key.statementId
    | none =>
      let expectedName := (expected.find? (·.statementId == key.statementId)).map
        (·.theoremName.toString) |>.getD "absent"
      throw <| identityError key.theoremName "theorem_name" expectedName key.theoremName.toString
  for key in expected do
    unless records.contains key.statementId do
      throw s!"IE-C034 MissingAnalysisDisposition theorem={key.theoremName} statement_id={key.statementId} head={head}"

def checkCoverage (head : String) (frozen : Array StatementKey)
    (inventory : DispositionInventory) : Except String Unit :=
  checkKeyCoverage head frozen inventory.headSha (inventory.entries.map (·.1))

/-- An immutable report already restricted to frozen elaborated theorem declarations.
The producer owns frozen membership; source provenance checks do not discover members. -/
structure FrozenReport where
  headSha : String
  reportSha256 : String
  theorems : Array StatementKey

open Std.Internal.Parsec Std.Internal.Parsec.ByteArray in
private partial def nameKeyParser : Std.Internal.Parsec.ByteArray.Parser Name := do
    skipByteChar 'n'
    match ← any with
    | 48 => return .anonymous
    | 115 =>
      skipByteChar '('
      let parent ← nameKeyParser
      skipByteChar ','
      let size ← digits
      skipByteChar ':'
      let bytes ← take size
      let some text := String.fromUTF8? bytes.toByteArray | fail "invalid UTF-8 name component"
      skipByteChar ')'
      return .str parent text
    | 110 =>
      skipByteChar '('
      let parent ← nameKeyParser
      skipByteChar ','
      let index ← digits
      skipByteChar ')'
      return .num parent index
    | _ => fail "invalid Lean name key"

/-- Decode the inspector's structured, byte-length-prefixed Name encoding. -/
def parseNameKey (text : String) : Except String Name :=
  (nameKeyParser <* Std.Internal.Parsec.eof).run text.toUTF8

/-- The supported wire identity, also used by synthetic producer fixtures. -/
def truthExportIdentity : Json := Json.mkObj [
  ("schema", toJson "stratalint.truth-export"), ("schema_version", toJson (2 : Nat)),
  ("dialect", toJson "stratalint.truth-export.v2"), ("producer", toJson "TruthExportCommand")]

/-- Consume the truth export dialect currently emitted by TruthExportCommand.
source_commit binds HEAD; declaration_name_key preserves Lean Name structure;
statement_id is read verbatim. Only frozen nodes' theorem declarations are included.
The caller pins the report bytes independently with expectedSha256. -/
def parseReport (expectedHead expectedSha256 bytes : String) : Except String FrozenReport := do
  let actualSha256 := "sha256:" ++ Sha256.hex bytes.toUTF8
  unless actualSha256 == expectedSha256 do
    throw <| identityError .anonymous "report_sha256" expectedSha256 actualSha256
  let json ← Json.parse bytes
  for field in ["schema", "dialect", "producer"] do
    let expected ← truthExportIdentity.getObjValAs? String field
    unless (← stringField json field) == expected do
      throw <| censusError expectedHead field expected (← stringField json field)
  let version ← truthExportIdentity.getObjValAs? Nat "schema_version"
  unless (← json.getObjValAs? Nat "schema_version") == version do
    throw <| censusError expectedHead "schema_version" (toString version)
      (toString (← json.getObjValAs? Nat "schema_version"))
  let head ← stringField json "source_commit"
  unless head == expectedHead do
    throw <| identityError .anonymous "head" expectedHead head
  let modules ← json.getObjValAs? (Array Json) "nodes"
  let mut keys : Array StatementKey := #[]
  for moduleRow in modules do
    let freezeStatus ← match moduleRow.getObjValAs? String "freeze_status" with
      | .ok status => pure status
      | .error _ =>
        throw <| censusError head "freeze_status"
          "frozen|proven-not-yet-frozen" "missing-or-invalid"
    unless freezeStatus == "frozen" || freezeStatus == "proven-not-yet-frozen" do
      throw <| censusError head "freeze_status" "frozen|proven-not-yet-frozen" freezeStatus
    if freezeStatus != "frozen" then continue
    let declarations ← moduleRow.getObjValAs? (Array Json) "declarations"
    for declaration in declarations do
      if (← stringField declaration "kind") == "theorem" then
        keys := keys.push ⟨← parseNameKey (← stringField declaration "declaration_name_key"),
          ← stringField declaration "statement_id"⟩
  let sorted := keys.qsort StatementKey.lt
  checkFrozenKeys head sorted
  return { headSha := head, reportSha256 := actualSha256, theorems := sorted }

/-- The source bytes consumed by the syntax authority check. -/
structure ProvenanceSource where
  moduleName : Name
  path : String
  sha256 : String
  deriving Inhabited, BEq

instance : ToJson ProvenanceSource := ⟨fun source => Json.mkObj [
  ("module", toJson source.moduleName), ("path", toJson source.path),
  ("sha256", toJson source.sha256)]⟩

end DispositionCensus

end LeanInformationAudit
