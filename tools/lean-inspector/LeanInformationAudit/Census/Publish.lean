import LeanInformationAudit.Census.Manifest
import LeanInformationAudit.Census.Transport

namespace LeanInformationAudit.CensusProjection

open Lean Meta Elab Command DispositionCensus CensusManifest

/-- Check the source boundary and the complete imported closure. A compiled
source is loaded through its own module; only that exact module is excluded
from the dependency closure, after its direct imports have been checked. -/
def checkFinalEnvironment (env : Environment) (compiledRoot : Option Name := none) : CoreM Unit := do
  let expected := #[compiledRoot.getD `LeanInformationAudit.Census.Certificate]
  unless (env.header.imports.map (·.module)).filter (· != `Init) == expected do
    throwError "finalEnvironmentImports: final source must import only Census.Certificate"
  for module in env.header.moduleNames do
    if module.getRoot != `Init && module != `LeanInformationAudit.Census.Certificate &&
        some module != compiledRoot then
      throwError "finalEnvironmentImports: payload import {module}"

private def checkSourceImports (imports : Array Import) : IO Unit := do
  unless (imports.map (·.module)).filter (· != `Init) == #[`LeanInformationAudit.Census.Certificate] do
    throw <| IO.userError "finalEnvironmentImports: final source must import only Census.Certificate"

/-- Compile in a separate Init-only process: the driver's Mathlib/Lean environment
must not coexist with kernel reduction in one heap. Load only the resulting
constructor trees for structural binding. The source and olean remain reviewable. -/
def elaborateFinalSource (input : String) (fileName : String) (root : Name)
    (options : Options) : IO Environment := do
  let input := input
  let (imports, _, messages) ← Elab.parseImports input fileName
  if messages.hasErrors then throw <| IO.userError "finalEnvironmentImports: invalid import header"
  checkSourceImports imports
  let source : System.FilePath := fileName
  let directory := source.withExtension "compile"
  let compiledSource := directory / (System.mkFilePath (root.components.map Name.toString)).withExtension "lean"
  IO.FS.createDirAll compiledSource.parent.get!
  IO.FS.writeFile compiledSource input
  let target := compiledSource.withExtension "olean"
  let result ← IO.Process.output {
    cmd := "lake"
    args := #["env", "lean", "-DmaxHeartbeats=0", "-DmaxRecDepth=4000",
      "-R", directory.toString, "-o", target.toString, compiledSource.toString]
    env := #[("LEAN_NUM_THREADS", some "1")] }
  IO.FS.writeFile (source.withExtension "compiler.log") (result.stdout ++ result.stderr)
  unless result.exitCode == 0 do
    throw <| IO.userError s!"census certificate: final source failed elaboration: {result.stdout}{result.stderr}"
  let (data, _) ← readModuleData target
  checkSourceImports data.imports
  -- Serialized output is the standalone compiler's environment, including its
  -- kernel-checked theorem on the second pass, never the IO driver's environment.
  IO.FS.writeBinFile (source.withExtension "olean") (← IO.FS.readBinFile target)
  let previous ← searchPathRef.get
  try
    searchPathRef.set (directory :: previous)
    importModules #[{ module := root }] options
  finally
    searchPathRef.set previous

/-- Emit the actual proposition over ids, with a literal requested count.
Reflexivity is cheaper than decide for equality of the independently bound chunks. -/
def certificateSource (input : String) (ids reportIds certificate : Name) (requested : Nat) : String :=
  input ++ "\ntheorem " ++ certificate.toString ++ " :\n  LeanInformationAudit.CensusKeyManifest.Certificate " ++
    ids.toString ++ " " ++ toString requested ++ " " ++ reportIds.toString ++
    " := by\n  exact ⟨by decide +kernel, by decide +kernel, rfl⟩\n"

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
accepting its rows. The kernel claim is over ids; Name-level `ExactlyCovers`
and report metadata are elaborator-bound, not claimed by the kernel theorem. -/
elab "#disposition_census" &"projection" &"root" root:ident &"source" sourcePath:str &"report" reportPath:str
    &"head" head:str &"report_sha256" reportSha:str &"prefix" selectionPrefix:str
    &"manifest" manifestName:ident &"report_keys" reportKeysName:ident &"receipts" receiptsPath:str
    &"certificate" certificate:ident " output " outputPath:str : command => do
  let destination := outputPath.getString
  phase destination "manifest_binding"
  let bytes ← IO.FS.readFile reportPath.getString
  let report ← parseReportDataIO bytes
  let selected ← ofExcept <| selectReport report bytes selectionPrefix.getString
  let paths ← ofExcept <| fromJson? (α := Array String) (← ofExcept <| Json.parse
    (← IO.FS.readFile receiptsPath.getString))
  let manifestName := manifestName.getId.eraseMacroScopes
  let reportKeysName := reportKeysName.getId.eraseMacroScopes
  let (inventory, sources) ← liftTermElabM <| readRows paths selected head.getString reportSha.getString
  phase destination "manifest_compile"
  let options := ((← getOptions).erase `maxRecDepth).setBool `Elab.async false
  let input ← IO.FS.readFile sourcePath.getString
  let finalEnv ← elaborateFinalSource input sourcePath.getString root.getId options
  liftTermElabM <| checkFinalEnvironment finalEnv (some root.getId)
  let (data, _) ← readModuleData ((System.FilePath.mk sourcePath.getString).withExtension "olean")
  let imports := data.imports.map (·.module.toString)
  let closure := finalEnv.header.moduleNames.filter (· != root.getId) |>.map Name.toString
  IO.FS.writeFile (destination ++ ".environment.json") ((Json.mkObj [
    ("imports", toJson imports), ("transitive_imports", toJson closure)]).pretty ++ "\n")
  phase destination "manifest_binding"
  let ids := mkConst (manifestName.appendAfter "Keys")
  let reportKeysExpr := mkConst reportKeysName
  withEnv finalEnv <| liftTermElabM <| withOptions (fun _ => options) do
    bindEmittedManifest selected root.getId (inventory.entries.map (·.1)) manifestName reportKeysName
  phase destination "receipt_verification"
  liftTermElabM do
    for path in paths do discard <| CensusReceipt.verify path report
  phase destination "certificate_compile_kernel"
  let certificateName := (← getCurrNamespace) ++ certificate.getId.eraseMacroScopes
  let checkedPath := (System.FilePath.mk sourcePath.getString).withExtension "checked.lean"
  let checkedInput := certificateSource input (manifestName.appendAfter "Keys") reportKeysName
    certificateName selected.theorems.size
  let staged ← elaborateFinalSource checkedInput checkedPath.toString root.getId options
  liftTermElabM <| checkFinalEnvironment staged (some root.getId)
  let proposition ← withEnv staged <| liftTermElabM do
    let expected ← mkAppM ``CensusKeyManifest.Certificate #[ids, toExpr selected.theorems.size, reportKeysExpr]
    let actual ← getConstInfo certificateName
    unless actual matches .thmInfo _ do throwError "census certificate: expected a kernel theorem"
    unless ← isDefEq actual.type expected do throwError "census certificate: incorrect proposition"
    return actual.type
  let axioms ← withEnv staged <| collectAxioms certificateName
  unless axioms.all (#[`propext, `Classical.choice, `Quot.sound].contains ·) do
    throwError "census certificate: unapproved axioms {axioms}"
  let typeText ← withEnv staged <| liftTermElabM <| return toString (← ppExpr proposition)
  let certificateJson := Json.mkObj [("name", toJson certificateName.toString),
    ("type", toJson typeText), ("axioms", toJson (axioms.map Name.toString))]
  let fields := summaryFields report inventory sources ++ [("certificate", certificateJson)]
  ofExcept <| checkCounts inventory (count inventory)
  IO.FS.writeBinFile ((System.FilePath.mk sourcePath.getString).withExtension "olean")
    (← IO.FS.readBinFile (checkedPath.withExtension "olean"))
  if ← (System.FilePath.mk destination).pathExists then
    let same ← IO.Process.output { cmd := "/bin/test", args := #[reportPath.getString, "-ef", destination] }
    unless same.exitCode == 1 do throwError "census projection: output aliases report"
  phase destination "json_emission"
  let temporary := destination ++ ".tmp"
  streamArtifact temporary fields inventory
  IO.FS.writeFile (temporary ++ ".summary.json") ((Json.mkObj fields).pretty ++ "\n")
  IO.FS.rename temporary destination
  IO.FS.rename (temporary ++ ".summary.json") (destination ++ ".summary.json")
  phase destination "certificate_compile_kernel"
  withEnv staged <| elabCommand (← `(command| #print axioms $(mkIdent certificateName)))

end LeanInformationAudit.CensusProjection
