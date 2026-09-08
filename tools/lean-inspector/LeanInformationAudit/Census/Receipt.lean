import LeanInformationAudit.Census.Query
import LeanInformationAudit.Census.Transport

namespace LeanInformationAudit.CensusReceipt

open Lean Meta DispositionCensus

def readRequest (path : String) : MetaM (Json × FrozenReport) := do
  let input ← ofExcept <| Json.parse (← IO.FS.readFile path)
  let object ← ofExcept <| input.getObj?
  unless object.size == 4 && ["head", "keys", "report", "report_sha256"].all object.contains do
    throwError "census query: input requires exactly head, keys, report and report_sha256"
  let head ← ofExcept <| stringField input "head"
  let bytes ← IO.FS.readFile (← ofExcept <| stringField input "report")
  let report ← ofExcept <| parseReport head (← ofExcept <| stringField input "report_sha256") bytes
  let json ← ofExcept <| Json.parse bytes
  let mut owners : Std.HashMap String (String × Name) := {}
  for node in ← ofExcept <| json.getObjValAs? (Array Json) "nodes" do
    let path ← ofExcept <| stringField node "repo_path"
    if head == "fixture-head" && !path.startsWith "LeanInformationAudit/Tests/" then
      throwError "query receipt: synthetic fixture cannot query production paths"
    if (← ofExcept <| stringField node "freeze_status") != "frozen" then continue
    let owner := String.intercalate "." ((path.dropEnd 5).toString.splitOn "/")
    for decl in ← ofExcept <| node.getObjValAs? (Array Json) "declarations" do
      if (← ofExcept <| stringField decl "kind") != "theorem" then continue
      let name ← ofExcept <| parseNameKey (← ofExcept <| stringField decl "declaration_name_key")
      owners := owners.insert (← ofExcept <| stringField decl "statement_id") (owner, name)
  if head != "fixture-head" then
    let actual ← IO.Process.output { cmd := "git", args := #["rev-parse", "HEAD"] }
    unless actual.exitCode == 0 && actual.stdout.trimAscii.toString == head do
      throwError "query receipt: report revision differs from environment HEAD"
    let pinned ← IO.Process.output { cmd := "git", args := #["diff", "--exit-code", "HEAD", "--",
      "D5", "lean-toolchain", "lake-manifest.json", "lakefile.toml", "Golden/Frozen/state"] }
    unless pinned.exitCode == 0 do throwError "query receipt: production inputs are not pinned"
    let imports := (← getEnv).header.imports.map (fun entry => entry.module.toString)
      |>.filter (fun name => name.startsWith "D5.")
    if !imports.isEmpty then
      let fresh ← IO.Process.output { cmd := "lake", args := #["--no-build", "build"] ++ imports }
      unless fresh.exitCode == 0 do throwError "query receipt: compiled environment is stale: {fresh.stderr}"
  for key in ← ofExcept <| input.getObjValAs? (Array (Array String)) "keys" do
    unless key.size == 3 do throwError "query receipt: expected module/name/identity triple"
    let name ← ofExcept <| parseNameKey key[1]!
    unless owners[key[2]!]? == some (key[0]!, name) do
      throwError "query receipt: requested key is not in the immutable report"
  return (input, report)

private def sourceInputs (modules : Array Name) : MetaM Json := do
  let repository ← IO.currentDir
  let search := (repository / "tools/lean-inspector") :: repository :: (← getSrcSearchPath)
  let mut paths := #[(← IO.FS.realPath (← readThe Core.Context).fileName).toString]
  for module in modules do
    if module == (← getEnv).header.mainModule then continue
    paths := paths.push (← IO.FS.realPath (← findOLean module)).toString
    if module.getRoot == `D5 || module.getRoot == `LeanInformationAudit then
      paths := paths.push (← IO.FS.realPath (← findLean search module)).toString
  for file in ["lean-toolchain", "lake-manifest.json", "lakefile.toml"] do
    paths := paths.push (← IO.FS.realPath (repository / file)).toString
  fingerprints (paths.toList.eraseDups.toArray.qsort (· < ·))

/-- A receipt is diagnostic transport, not a signature. The publisher replays the
canonical query and compares both receipts and row bytes before accepting it. -/
def write (request destination : String) (input result : Json) (modules : Array Name) : MetaM Unit := do
  let env ← getEnv
  let source ← IO.FS.realPath (← readThe Core.Context).fileName
  let imports := env.header.imports.map (fun entry => entry.module.toString) |>.filter (· != "Init")
  unless (← IO.FS.readFile source) == querySource imports request destination do
    throwError "query receipt: expected canonical query source"
  let bytes := result.compress ++ "\n"
  let receipt := Json.mkObj [
    ("head", ← ofExcept <| input.getObjVal? "head"),
    ("report_sha256", ← ofExcept <| input.getObjVal? "report_sha256"),
    ("request_path", toJson request), ("request_sha256", toJson (digest (← IO.FS.readFile request))),
    ("response_path", toJson destination), ("rows_sha256", toJson (digest bytes)),
    ("run_root", toJson (← runRoot).toString), ("source_path", toJson source.toString),
    ("root", nameJson env.header.mainModule), ("scope", ← ofExcept <| result.getObjVal? "scope"),
    ("direct_imports", toJson imports), ("direct_import_count", toJson imports.size),
    ("transitive_closure_count", toJson modules.size), ("source_inputs", ← sourceInputs modules)]
  let targetPath := (← IO.getEnv "CENSUS_RECEIPT_REPLAY").getD destination
  IO.FS.writeFile targetPath bytes
  IO.FS.writeFile (targetPath ++ ".receipt.json") (receipt.compress ++ "\n")

end LeanInformationAudit.CensusReceipt
