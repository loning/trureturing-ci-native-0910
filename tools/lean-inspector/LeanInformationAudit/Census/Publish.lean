import LeanInformationAudit.DispositionCensus
import LeanInformationAudit.Census.Coverage

namespace LeanInformationAudit.CensusProjection

open Lean Meta Elab Command DispositionCensus

/-- Run-local data emitted by the completed partition query. The query process
checks the elaborated closure; publication consumes its projection, and does not
re-import observed targets. Editing generated query outputs is outside this
producer contract, as with the truth export itself. -/
structure Scope where
  root : Name
  importScope : ImportClosureScope
  deriving Inhabited

private def keyExpr (key : StatementKey) : Expr :=
  mkApp2 (mkConst ``StatementKey.mk) (toExpr key.theoremName) (toExpr key.statementId)

/-- Kernel proof from adjacent sorted identity comparisons and exact list equality.
Native evaluation is used only for diagnostics, never as a proof. -/
def coverage (report : FrozenReport) (inventory : Expr) : MetaM Expr := do
  let keys := report.theorems.qsort (fun a b => a.statementId < b.statementId)
  let keys <- mkListLit (mkConst ``StatementKey) (keys.toList.map keyExpr)
  let head <- mkAppM ``DispositionInventory.headSha #[inventory]
  let actual <- mkAppM ``DispositionInventory.keys #[inventory]
  let headProof <- mkDecideProof (<- mkEq head (toExpr report.headSha))
  let keysProof <- mkDecideProof (<- mkEq actual keys)
  let ids <- mkAppM ``List.map #[mkConst ``StatementKey.statementId, actual]
  let ordered <- mkAppM ``CensusCoverage.increasing #[ids]
  let orderProof <- mkDecideProof (<- mkEq ordered (toExpr true))
  let proof <- mkAppM ``CensusCoverage.of_sorted_ids
    #[inventory, toExpr report.headSha, keys, headProof, keysProof, orderProof]
  checkWithKernel proof
  return proof

private def reportOwners (bytes : String) : Except String (Std.HashMap String String) := do
  let report <- Json.parse bytes
  let mut owners := {}
  for node in <- report.getObjValAs? (Array Json) "nodes" do
    if (<- stringField node "freeze_status") != "frozen" then continue
    let path <- stringField node "repo_path"
    let module := String.intercalate "." ((path.dropEnd 5).toString.splitOn "/")
    for decl in <- node.getObjValAs? (Array Json) "declarations" do
      if (<- stringField decl "kind") != "theorem" then continue
      owners := owners.insert (<- stringField decl "statement_id") module
  return owners

def validate (inventory : DispositionInventory) (scopes : Array Scope)
    (owners : Std.HashMap String String) : MetaM Unit := do
  let mut scopeMap : Std.HashMap Name (Scope × Std.HashSet Name) := {}
  for scope in scopes do
    if scopeMap.contains scope.root then throwError "census projection: duplicate scope"
    unless scope.importScope.completed && scope.importScope.modules.contains scope.root do
      throwError "census projection: incomplete scope"
    scopeMap := scopeMap.insert scope.root (scope, Std.HashSet.ofArray scope.importScope.modules)
  for entry in inventory.entries do
    if let .observed payload := entry.2 then
      ofExcept <| checkObservationStatus inventory.headSha payload
      let some (scope, modules) := scopeMap[payload.root]?
        | throwError "census projection: unknown query root"
      unless scope.importScope == payload.importScope do
        throwError "census projection: scope mismatch"
      unless owners[entry.1.statementId]? == some payload.owningModule.toString &&
          modules.contains payload.owningModule do
        throwError "census projection: owning module mismatch"

/-- Preserve the census JSON schema while keeping only one serialized row in
memory. A scope may contain thousands of names and occur in thousands of rows. -/
private def streamArtifact (path : String) (report : FrozenReport)
    (inventory : DispositionInventory) (sources : Array ProvenanceSource) : IO Unit := do
  let counts := count inventory
  match checkCounts inventory counts with
  | .ok () => pure ()
  | .error message => throw (IO.userError message)
  let fields := [
    ("schema", toJson "lean-information-disposition-census"),
    ("head_sha", toJson report.headSha), ("report_sha256", toJson report.reportSha256),
    ("source_inputs", toJson sources), ("theorem_count", toJson report.theorems.size),
    ("counts", toJson counts), ("certified_complete", toJson (counts.observed == 0))]
  let handle <- IO.FS.Handle.mk path .write
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
  IO.FS.writeFile (path ++ ".summary.json") ((Json.mkObj fields).pretty ++ "\n")

/-- The projection form consumes data produced by #census_query. The ordinary
#disposition_census retains live-environment validation for handwritten inventories.
Certified rows are always checked again in the final evidence-only environment. -/
elab "#disposition_census" &"projection" &"root" root:ident &"report" reportPath:str
    &"head" head:str &"report_sha256" reportSha:str &"inventory" inventoryName:ident
    &"scopes" scopesName:ident &"certificate" certificate:ident " output " outputPath:str :
    command => do
  let bytes <- IO.FS.readFile reportPath.getString
  let report <- ofExcept <| parseReport head.getString reportSha.getString bytes
  let owners <- ofExcept <| reportOwners bytes
  let inventoryName <- liftCoreM <| realizeGlobalConstNoOverloadWithInfo inventoryName
  let scopesName <- liftCoreM <| realizeGlobalConstNoOverloadWithInfo scopesName
  let inventory <- liftTermElabM do
    unsafe evalExpr DispositionInventory (mkConst ``DispositionInventory) (mkConst inventoryName)
  let scopes <- liftTermElabM do
    unsafe evalExpr (Array Scope) (mkApp (mkConst ``Array [.zero]) (mkConst ``Scope))
      (mkConst scopesName)
  ofExcept <| checkCoverage report.headSha report.theorems inventory
  let (proof, sources) <- liftTermElabM do
    validate inventory scopes owners
    let certified := { inventory with entries := inventory.entries.filter fun entry =>
      match entry.2 with | .certified _ => true | .observed _ => false }
    let sources <- validateEvidenceSources root.getId certified
    IO.println "CENSUS_COVERAGE_BEGIN"
    let started <- IO.monoMsNow
    let proof <- coverage report (mkConst inventoryName)
    let elapsed := (<- IO.monoMsNow) - started
    IO.println s!"CENSUS_COVERAGE_COMPLETE milliseconds={elapsed}"
    return (proof, sources)
  let certificateName := (<- getCurrNamespace) ++ certificate.getId.eraseMacroScopes
  let declaration := Declaration.thmDecl {
    name := certificateName, levelParams := [], type := <- liftTermElabM <| inferType proof,
    value := proof }
  let options <- getOptions
  let staged <- match (<- getEnv).addDeclCore (Core.getMaxHeartbeats options).toUSize
      (maxRecDepth.get options).toUSize declaration none true with
    | .ok env => pure env
    | .error error => throwError "{error.toMessageData options}"
  let destination := outputPath.getString
  let temporary := destination ++ ".tmp"
  if <- (System.FilePath.mk destination).pathExists then
    if (<- IO.FS.realPath reportPath.getString) == (<- IO.FS.realPath destination) then
      throwError "census projection: output aliases report"
  streamArtifact temporary report inventory sources
  IO.FS.rename temporary destination
  IO.FS.rename (temporary ++ ".summary.json") (destination ++ ".summary.json")
  setEnv staged

end LeanInformationAudit.CensusProjection
