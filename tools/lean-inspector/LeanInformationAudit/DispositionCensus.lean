import LeanInformationAudit.CensusSchema
import LeanInformationAudit.Sha256
import LeanInformationAudit.DispositionEvidence
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

/-- Duplicate statement IDs are checked before identity and missing-row diagnostics. -/
def checkCoverage (head : String) (frozen : Array StatementKey)
    (inventory : DispositionInventory) : Except String Unit := do
  let expected := frozen.qsort StatementKey.lt
  checkFrozenKeys head expected
  for key in expected do
    unless inventory.headSha == head do
      throw <| identityError key.theoremName "head" head inventory.headSha
  unless inventory.headSha == head do
    throw <| identityError .anonymous "head" head inventory.headSha
  let mut records : Std.HashMap String (Array Nat) := {}
  for i in [:inventory.entries.size] do
    let id := inventory.entries[i]!.1.statementId
    records := records.insert id ((records.getD id #[]).push i)
  for entry in inventory.entries do
    let key := entry.1
    let duplicates := records.getD key.statementId #[]
    if duplicates.size > 1 then
      throw s!"IE-C035 DuplicateAnalysisDisposition theorem={key.theoremName} statement_id={key.statementId} records={(toJson duplicates).compress}"
  let names : Std.HashMap Name (Array String) :=
    expected.foldl (init := {}) fun result key =>
      result.insert key.theoremName ((result.getD key.theoremName #[]).push key.statementId)
  for entry in inventory.sortedEntries do
    match names[entry.1.theoremName]? with
    | some ids =>
      unless ids.contains entry.1.statementId do
        throw <| identityError entry.1.theoremName "statement_id" ids[0]! entry.1.statementId
    | none =>
      let expectedName := (expected.find? (·.statementId == entry.1.statementId)).map
        (·.theoremName.toString) |>.getD "absent"
      throw <| identityError entry.1.theoremName "theorem_name" expectedName entry.1.theoremName.toString
  for key in expected do
    unless records.contains key.statementId do
      throw s!"IE-C034 MissingAnalysisDisposition theorem={key.theoremName} statement_id={key.statementId} head={head}"
  unless inventory.ExactlyCovers head frozen.toList.toFinset do
    throw <| censusError head "keys" (toJson expected).compress
      (toJson inventory.keys).compress

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

/-- Consume the truth export dialect currently emitted by TruthExportCommand.
source_commit binds HEAD; declaration_name_key preserves Lean Name structure;
statement_id is read verbatim. Only frozen nodes' theorem declarations are included.
The caller pins the report bytes independently with expectedSha256. -/
def parseReport (expectedHead expectedSha256 bytes : String) : Except String FrozenReport := do
  let actualSha256 := "sha256:" ++ Sha256.hex bytes.toUTF8
  unless actualSha256 == expectedSha256 do
    throw <| identityError .anonymous "report_sha256" expectedSha256 actualSha256
  let json ← Json.parse bytes
  for (field, expected) in [("schema", "stratalint.truth-export"),
      ("dialect", "stratalint.truth-export.v2"), ("producer", "TruthExportCommand")] do
    unless (← stringField json field) == expected do
      throw <| censusError expectedHead field expected (← stringField json field)
  unless (← json.getObjValAs? Nat "schema_version") == 2 do
    throw <| censusError expectedHead "schema_version" "2"
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

def artifact (report : FrozenReport) (inventory : DispositionInventory)
    (sources : Array ProvenanceSource := #[]) : Except String Json := do
  checkCoverage report.headSha report.theorems inventory
  let counts := count inventory
  checkCounts inventory counts
  return Json.mkObj [
    ("schema", toJson "lean-information-disposition-census"),
    ("head_sha", toJson report.headSha), ("report_sha256", toJson report.reportSha256),
    ("source_inputs", toJson sources),
    ("theorem_count", toJson report.theorems.size), ("counts", toJson counts),
    ("certified_complete", toJson (counts.observed == 0)),
    ("rows", Json.arr <| inventory.sortedEntries.map dispositionRowJson)]

/-- Independently checks an output projection against its input inventory. -/
def checkArtifact (report : FrozenReport) (inventory : DispositionInventory)
    (candidate : Json) (sources : Array ProvenanceSource := #[]) : Except String Unit := do
  let expected ← artifact report inventory sources
  for field in censusArtifactFields do
    let expectedValue ← expected.getObjVal? field
    let actual ← match candidate.getObjVal? field with
      | .ok value => pure value
      | .error _ => throw <| censusError report.headSha field expectedValue.compress "missing"
    unless expectedValue.compress == actual.compress do
      throw <| censusError report.headSha field expectedValue.compress actual.compress
  validateAnalysisInventory .anonymous candidate

open Meta Elab Command

private def keyExpr (key : StatementKey) : Expr :=
  mkApp2 (mkConst ``StatementKey.mk) (toExpr key.theoremName) (toExpr key.statementId)

def rowExpr (entry : Sigma fun key : StatementKey => CensusAssessment key)
    (sharedScope : Option Expr := none) : MetaM Expr := do
  let key := keyExpr entry.1
  let assessment ← match entry.2 with
    | .certified disposition => match disposition with
      | .finiteOccurrence value => do
        let payload ← mkAppOptM ``FiniteOccurrenceDisposition.mk #[some key,
          some (toExpr value.canonicalArena), some (toExpr value.registration),
          some (toExpr value.realization), some (toExpr value.nondegeneracyCertificate),
          some (toExpr value.stateEnumerationCertificate)]
        let disposition ← mkAppOptM ``AnalysisDisposition.finiteOccurrence #[some key, some payload]
        mkAppOptM ``CensusAssessment.certified #[some key, some disposition]
      | .structuralOccurrence value => do
        let payload ← mkAppOptM ``StructuralOccurrenceDisposition.mk #[some key,
          some (toExpr value.canonicalArena), some (toExpr value.registration),
          some (toExpr value.realization), some (toExpr value.strictnessCertificate),
          some (toExpr value.witnessCertificate)]
        let disposition ← mkAppOptM ``AnalysisDisposition.structuralOccurrence #[some key, some payload]
        mkAppOptM ``CensusAssessment.certified #[some key, some disposition]
      | .boundedFiniteTruncation value => do
        let certification := match value.certification with
          | .reportOnly => mkConst ``TruncationCertification.reportOnly
          | .transferred name => mkApp (mkConst ``TruncationCertification.transferred) (toExpr name)
        let payload ← mkAppOptM ``BoundedFiniteTruncationDisposition.mk #[some key,
          some (toExpr value.truncationFamily), some (toExpr value.bound),
          some (toExpr value.comparisonStatement), some certification]
        let disposition ← mkAppOptM ``AnalysisDisposition.boundedFiniteTruncation
          #[some key, some payload]
        mkAppOptM ``CensusAssessment.certified #[some key, some disposition]
      | .unreachable value => do
        let reason := mkConst <| match value.reason with
          | .noCanonicalObjectCarrier => ``UnreachableReason.noCanonicalObjectCarrier
          | .noFinitePrimitiveBundle => ``UnreachableReason.noFinitePrimitiveBundle
          | .noFaithfulPrimitiveRealization => ``UnreachableReason.noFaithfulPrimitiveRealization
        let payload ← mkAppOptM ``UnreachableDisposition.mk #[some key,
          some reason, some (toExpr value.evidence)]
        let disposition ← mkAppOptM ``AnalysisDisposition.unreachable #[some key, some payload]
        mkAppOptM ``CensusAssessment.certified #[some key, some disposition]
    | .observed value => do
      let scope ← match sharedScope with
        | some scope => pure scope
        | none => mkAppOptM ``ImportClosureScope.mk #[
            some (toExpr value.importScope.modules), some (toExpr value.importScope.completed)]
      let observation ← mkAppOptM ``AnalysisObservation.mk #[some key,
        some (toExpr value.owningModule), some (toExpr value.root), some scope,
        some (toExpr value.queryCompleted), some (toExpr value.candidates), some (toExpr value.note)]
      mkAppOptM ``CensusAssessment.observed #[some key, some observation]
  let motive := mkLambda `key .default (mkConst ``StatementKey)
    (mkApp (mkConst ``CensusAssessment) (.bvar 0))
  mkAppOptM ``Sigma.mk #[some (mkConst ``StatementKey), some motive, some key, some assessment]

/-- Reifies the actual inventory and asks Lean's kernel to verify ExactlyCovers.
No native evaluation result is used as a proof. -/
def coverageProof (report : FrozenReport) (inventory : DispositionInventory)
    (declaredInventory : Option Expr := none) : MetaM Expr := do
  let motive := mkLambda `key .default (mkConst ``StatementKey)
    (mkApp (mkConst ``CensusAssessment) (.bvar 0))
  let rowType := mkApp2 (mkConst ``Sigma [.zero, .zero]) (mkConst ``StatementKey) motive
  let inventoryExpr ← match declaredInventory with
    | some value => pure value
    | none => do
      let entries ← mkArrayLit rowType (← inventory.entries.toList.mapM (rowExpr ·))
      pure <| mkApp2 (mkConst ``DispositionInventory.mk) (toExpr inventory.headSha) entries
  let keys ← mkListLit (mkConst ``StatementKey) (report.theorems.toList.map keyExpr)
  let frozen ← mkAppM ``List.toFinset #[keys]
  let proposition ← mkAppM ``DispositionInventory.ExactlyCovers
    #[inventoryExpr, toExpr report.headSha, frozen]
  let proof ← mkDecideProof proposition
  checkWithKernel proof
  return proof

private def readUtf8 (path : String) : IO String := do
  let bytes ← IO.FS.readBinFile path
  match String.fromUTF8? bytes with
  | some text => return text
  | none => throw <| IO.userError s!"invalid UTF-8: {path}"

/-- Report-only command. File inputs are the truth export dialect currently emitted
by TruthExportCommand and the source modules of structural rows, resolved by
findLean/getSrcSearchPath and hashed in
source_inputs. Provenance means generated by structural_theorem in source;
source rewriting during a build and modified source search paths are out of scope.
The inventory is a typed declaration in the elaborated environment. It stages
ExactlyCovers only after checking the full inventory and its semantic evidence.
The resulting JSON is output, never seal input. -/
elab "#disposition_census" &"root" root:ident &"report" reportPath:str
    &"head" head:str &"report_sha256" reportSha:str &"inventory" inventoryName:ident
    &"certificate" certificate:ident " output " outputPath:str : command => do
  -- realPath resolves relative components and symlinks before any declaration is staged.
  let inputResolved ← IO.FS.realPath reportPath.getString
  let destination : System.FilePath := outputPath.getString
  if ← destination.pathExists then
    if inputResolved == (← IO.FS.realPath destination) then
      throwError (censusError head.getString "output_path" "distinct-from-report" "report-alias")
    -- Lean metadata exposes link counts but not inode identity. POSIX test -ef
    -- compares the existing files without involving shell parsing.
    if (← destination.metadata).numLinks > 1 then
      let comparison ← IO.Process.output {
        cmd := "/bin/test", args := #[reportPath.getString, "-ef", outputPath.getString] }
      if comparison.exitCode == 0 then
        throwError (censusError head.getString "output_path" "distinct-from-report" "report-alias")
      unless comparison.exitCode == 1 do
        throwError "cannot compare census input/output file identities"
  let reportBytes ← readUtf8 reportPath.getString
  let report ← ofExcept <| parseReport head.getString reportSha.getString reportBytes
  let inventory ← liftTermElabM do
    let name ← realizeGlobalConstNoOverloadWithInfo inventoryName
    let value ← mkConstWithFreshMVarLevels name
    unless ← isDefEq (← inferType value) (mkConst ``DispositionInventory) do
      throwError "expected a DispositionInventory declaration: {name}"
    checkWithKernel value
    unsafe evalExpr DispositionInventory (mkConst ``DispositionInventory) value
  ofExcept <| checkCoverage report.headSha report.theorems inventory
  let certificateName := (← getCurrNamespace) ++ certificate.getId.eraseMacroScopes
  if (← getEnv).contains certificateName then
    throwError "disposition census certificate already exists: {certificateName}"
  let (proof, sources) ← liftTermElabM do
    let sources ← validateEvidenceSources root.getId.eraseMacroScopes inventory
    let inventoryName ← realizeGlobalConstNoOverloadWithInfo inventoryName
    return (← coverageProof report inventory (some (mkConst inventoryName)), sources)
  let proofType ← liftTermElabM <| inferType proof
  let projection ← ofExcept <| artifact report inventory sources
  ofExcept <| checkArtifact report inventory projection sources
  let declaration := Declaration.thmDecl {
    name := certificateName
    levelParams := []
    type := proofType
    value := proof
  }
  let options ← getOptions
  let stagedEnv ← match (← getEnv).addDeclCore (Core.getMaxHeartbeats options).toUSize
      (maxRecDepth.get options).toUSize declaration none true with
    | .ok env => pure env
    | .error error => throwError "{error.toMessageData options}"
  IO.FS.writeFile outputPath.getString (projection.pretty ++ "\n")
  setEnv stagedEnv

end DispositionCensus

end LeanInformationAudit
