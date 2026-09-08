import LeanInformationAudit.Census.Manifest
import LeanInformationAudit.Census.Transport

namespace LeanInformationAudit.CensusProjection

open Lean Meta Elab Command DispositionCensus CensusManifest

/-- The publication environment contains generic code and data types only. -/
def checkFinalEnvironment (env : Environment) : CoreM Unit := do
  unless (env.header.imports.map (·.module)).filter (· != `Init) == #[`LeanInformationAudit.Census.Publish] do
    throwError "finalEnvironmentImports: final source must import only Census.Publish"
  let allowed := #[`LeanInformationAudit.AnalysisDisposition, `LeanInformationAudit.CensusSchema,
    `LeanInformationAudit.Sha256, `LeanInformationAudit.Census.Codec,
    `LeanInformationAudit.Census.Report, `LeanInformationAudit.Census.Coverage,
    `LeanInformationAudit.Census.Manifest, `LeanInformationAudit.Census.Transport,
    `LeanInformationAudit.Census.Publish]
  for module in env.header.moduleNames do
    if module.getRoot == `D5 ||
        (module.getRoot == `LeanInformationAudit && !allowed.contains module) then
      throwError "finalEnvironmentImports: payload import {module}"

private def phase (destination label : String) : IO Unit :=
  IO.FS.writeFile (destination ++ ".phase") label

/-- Selection depends only on the immutable report and explicit requested prefix. -/
def selectReport (report : FrozenReport) (bytes selectionPrefix : String) : Except String FrozenReport := do
  let json ← Json.parse bytes
  let mut ids : Std.HashSet String := {}
  for node in ← json.getObjValAs? (Array Json) "nodes" do
    if (← stringField node "freeze_status") != "frozen" then continue
    let path ← stringField node "repo_path"
    let owner := String.intercalate "." ((path.dropEnd 5).toString.splitOn "/")
    unless owner == selectionPrefix || owner.startsWith (selectionPrefix ++ ".") do continue
    for row in ← node.getObjValAs? (Array Json) "declarations" do
      if (← stringField row "kind") == "theorem" then
        ids := ids.insert (← stringField row "statement_id")
  return { report with theorems := report.theorems.filter (fun key => ids.contains key.statementId) }

private def readRows (paths : Array String) (report : FrozenReport) (head sha : String) : MetaM
    (DispositionInventory × Array ProvenanceSource) := do
  if paths.isEmpty then throwError "query receipt: no independently verified query partitions"
  let mut rows := #[]
  let mut wireRows := #[]
  let mut sources := #[]
  for path in paths do
    unless ← (System.FilePath.mk path).pathExists do throwError "query receipt: missing transport"
    let result ← ofExcept <| Json.parse (← IO.FS.readFile path)
    let scopeJson ← ofExcept <| result.getObjVal? "scope"
    let scope : ImportClosureScope := {
      modules := ← (← ofExcept <| scopeJson.getObjValAs? (Array Json) "modules").mapM
        (fun value => ofExcept <| parseNameJson value)
      completed := ← ofExcept <| scopeJson.getObjValAs? Bool "completed" }
    for row in ← ofExcept <| result.getObjValAs? (Array Json) "entries" do
      wireRows := wireRows.push (row, scope)
    for source in ← ofExcept <| result.getObjValAs? (Array Json) "source_inputs" do
      let source : ProvenanceSource := {
        moduleName := (← ofExcept <| stringField source "module").toName
        path := ← ofExcept <| stringField source "path"
        sha256 := ← ofExcept <| stringField source "sha256" }
      unless sources.contains source do sources := sources.push source
  let keys ← wireRows.mapM fun (row, _) => do
    return StatementKey.mk (← ofExcept <| parseNameJson (← ofExcept <| row.getObjVal? "theorem_name"))
      (← ofExcept <| stringField row "statement_id")
  ofExcept <| checkInventoryDuplicates keys
  ofExcept <| checkReportBinding head sha report
  for (row, scope) in wireRows do
    let parsed ← ofExcept <| parseRow row (some scope)
    if let .observed value := parsed.2 then ofExcept <| checkObservationStatus head value
    rows := rows.push parsed
  return (⟨head, rows⟩, sources.qsort (fun a b => a.moduleName.toString < b.moduleName.toString))

def summaryFields (report : FrozenReport) (inventory : DispositionInventory)
    (sources : Array ProvenanceSource) : List (String × Json) :=
  let counts := count inventory
  let complete := counts.accounted == report.theorems.size
  [
    ("schema", toJson "lean-information-disposition-census"),
    ("head_sha", toJson report.headSha), ("report_sha256", toJson report.reportSha256),
    ("source_inputs", toJson sources), ("theorem_count", toJson report.theorems.size),
    ("requested_keys", toJson report.theorems.size),
    ("input_kind", toJson (if report.headSha == "fixture-head" then "synthetic_fixture" else "production")),
    ("query_verification", toJson "lean_query_replay"),
    ("status", toJson (if complete then "complete" else "partial")),
    ("coverage_theorem_count", toJson counts.accounted),
    ("counts", toJson counts), ("certified_complete", toJson (complete && counts.observed == 0))]

/-- Serialize one row at a time: the shared import closure can be much larger
than its row. It is never materialized as a whole-repository JSON value. -/
private def streamArtifact (path : String) (fields : List (String × Json))
    (inventory : DispositionInventory) : IO Unit := do
  let handle ← IO.FS.Handle.mk path .write
  handle.putStr "{"
  for (field, value) in fields do
    handle.putStr ((toJson field).compress ++ ":" ++ value.compress ++ ",\n")
  handle.putStr "\"rows\":[\n"
  let rows := inventory.sortedEntries
  for i in [:rows.size] do
    if i > 0 then handle.putStr ",\n"
    handle.putStr (dispositionRowJson rows[i]!).compress
  handle.putStr "\n]}\n"
  handle.flush

/-- Independent data-only publication. Lean replays each bounded query before
accepting its rows; the kernel sees only full keys and immutable report metadata. -/
elab "#disposition_census" &"projection" &"root" root:ident &"report" reportPath:str
    &"head" head:str &"report_sha256" reportSha:str &"prefix" selectionPrefix:str
    &"manifest" manifestName:ident &"report_keys" reportKeysName:ident &"receipts" receiptsPath:str
    &"certificate" certificate:ident " output " outputPath:str : command => do
  let destination := outputPath.getString
  liftTermElabM <| checkFinalEnvironment (← getEnv)
  let imports := (← getEnv).header.imports.map (·.module.toString)
  let closure := (← getEnv).header.moduleNames.map Name.toString
  IO.FS.writeFile (destination ++ ".environment.json") ((Json.mkObj [
    ("imports", toJson imports), ("transitive_imports", toJson closure)]).pretty ++ "\n")
  phase destination "manifest_binding"
  let bytes ← IO.FS.readFile reportPath.getString
  let report ← ofExcept <| parseReportData bytes
  let selected ← ofExcept <| selectReport report bytes selectionPrefix.getString
  let paths ← ofExcept <| fromJson? (α := Array String) (← ofExcept <| Json.parse
    (← IO.FS.readFile receiptsPath.getString))
  let manifestName ← liftTermElabM <| realizeGlobalConstNoOverloadWithInfo manifestName
  let reportKeysName ← liftTermElabM <| realizeGlobalConstNoOverloadWithInfo reportKeysName
  let (inventory, sources) ← liftTermElabM <| readRows paths selected head.getString reportSha.getString
  let value := mkConst manifestName
  let reportKeysExpr := mkConst reportKeysName
  liftTermElabM do
    let keyManifest ← do unsafe evalExpr CensusKeyManifest (mkConst ``CensusKeyManifest) value
    let reportKeys ← do unsafe evalExpr (List (Name × Nat)) (toTypeExpr (List (Name × Nat))) reportKeysExpr
    unless (← getConstInfoDefn reportKeysName).value == keysLiteralExpr reportKeys do
      throwError "{identityError .anonymous "report_keys_binding" "independent canonical literal" "alias or expression"}"
    ofExcept <| checkManifestBinding selected root.getId (inventory.entries.map (·.1)) keyManifest reportKeys
  phase destination "receipt_verification"
  liftTermElabM do
    for path in paths do discard <| CensusReceipt.verify path report
  phase destination "certificate_compile_kernel"
  let certificateName := (← getCurrNamespace) ++ certificate.getId.eraseMacroScopes
  let (proof, proposition) ← liftTermElabM do
    let proof ← certificateProof value report.headSha report.reportSha256 root.getId reportKeysExpr
    let proposition ← mkAppM ``CensusKeyManifest.Certificate
      #[value, toExpr report.headSha, toExpr report.reportSha256, toExpr root.getId, reportKeysExpr]
    return (proof, proposition)
  let declaration := Declaration.thmDecl {
    name := certificateName, levelParams := [], type := proposition, value := proof }
  let options ← getOptions
  let staged ← match (← getEnv).addDeclCore (Core.getMaxHeartbeats options).toUSize
      (maxRecDepth.get options).toUSize declaration none true with
    | .ok env => pure env
    | .error error => throwError "{error.toMessageData options}"
  let axioms ← withEnv staged <| collectAxioms certificateName
  unless axioms.all (#[`propext, `Classical.choice, `Quot.sound].contains ·) do
    throwError "census certificate: unapproved axioms {axioms}"
  let typeText ← liftTermElabM <| return toString (← ppExpr proposition)
  let certificateJson := Json.mkObj [("name", toJson certificateName.toString),
    ("type", toJson typeText), ("axioms", toJson (axioms.map Name.toString))]
  let fields := summaryFields report inventory sources ++ [("certificate", certificateJson)]
  ofExcept <| checkCounts inventory (count inventory)
  if ← (System.FilePath.mk destination).pathExists then
    let same ← IO.Process.output { cmd := "/bin/test", args := #[reportPath.getString, "-ef", destination] }
    unless same.exitCode == 1 do throwError "census projection: output aliases report"
  phase destination "json_emission"
  let temporary := destination ++ ".tmp"
  streamArtifact temporary fields inventory
  IO.FS.writeFile (temporary ++ ".summary.json") ((Json.mkObj fields).pretty ++ "\n")
  IO.FS.rename temporary destination
  IO.FS.rename (temporary ++ ".summary.json") (destination ++ ".summary.json")
  setEnv staged
  phase destination "certificate_compile_kernel"
  elabCommand (← `(command| #print axioms $(mkIdent certificateName)))

end LeanInformationAudit.CensusProjection
