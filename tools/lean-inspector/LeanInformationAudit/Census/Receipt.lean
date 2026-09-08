import LeanInformationAudit.Census.Query

namespace LeanInformationAudit.CensusReceipt

open Lean Meta DispositionCensus

def digest (bytes : String) : String := "sha256:" ++ Sha256.hex bytes.toUTF8

def runRoot : CoreM System.FilePath := do
  let mut path ← IO.FS.realPath (← readThe Core.Context).fileName
  for _ in (← getEnv).header.mainModule.components do
    let some parent := path.parent | throwError "query receipt: missing run root"
    path := parent
  return path

def querySource (imports : Array String) (request destination : String) : String :=
  String.join (imports.toList.map (fun name => "import " ++ name ++ "\n")) ++
    "#census_query " ++ (toJson request).compress ++ " output " ++ (toJson destination).compress ++ "\n"

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

/-- Hash compiled inputs with the host SHA-256 implementation, without loading
whole olean files into the Lean heap. Batches bound the process argument vector. -/
def fingerprints (paths : Array String) : IO Json := do
  let mut entries := #[]
  for start in [: (paths.size + 127) / 128] do
    let batch := paths.extract (start * 128) ((start + 1) * 128)
    let result ← IO.Process.output { cmd := "/usr/bin/shasum", args := #["-a", "256", "--"] ++ batch }
    unless result.exitCode == 0 do throw <| IO.userError "query receipt: input hashing failed"
    let lines := result.stdout.splitOn "\n" |>.filter (!·.isEmpty) |>.toArray
    unless lines.size == batch.size do throw <| IO.userError "query receipt: input hash count mismatch"
    for i in [:batch.size] do
      let hash := (lines[i]!.take 64).toString
      unless hash.length == 64 && hash.toList.all (fun c => c.isDigit || ('a' ≤ c && c ≤ 'f')) do
        throw <| IO.userError "query receipt: invalid input digest"
      entries := entries.push <| Json.mkObj [("path", toJson batch[i]!), ("sha256", toJson ("sha256:" ++ hash))]
  return Json.arr entries

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

def verify (path : String) (report : FrozenReport) : MetaM Json := do
  let receiptPath := path ++ ".receipt.json"
  unless (← (System.FilePath.mk path).pathExists) && (← (System.FilePath.mk receiptPath).pathExists) do
    throwError "query receipt: missing transport or receipt"
  let receiptBytes ← IO.FS.readFile receiptPath
  let receipt ← ofExcept <| Json.parse receiptBytes
  let field (key : String) : MetaM String := Lean.ofExcept (stringField receipt key)
  let root ← runRoot
  unless (← field "run_root") == root.toString && (← field "response_path") == path &&
      (← field "head") == report.headSha && (← field "report_sha256") == report.reportSha256 do
    throwError "query receipt: stale or swapped run/report binding"
  let request ← field "request_path"
  let source ← field "source_path"
  unless request.startsWith (root.toString ++ "/") && source.startsWith (root.toString ++ "/") &&
      path.startsWith (root.toString ++ "/") do
    throwError "query receipt: files outside the run"
  let response ← IO.FS.readFile path
  unless digest response == (← field "rows_sha256") &&
      digest (← IO.FS.readFile request) == (← field "request_sha256") do
    throwError "query receipt: edited request or row transport"
  let imports ← ofExcept <| receipt.getObjValAs? (Array String) "direct_imports"
  unless (← IO.FS.readFile source) == querySource imports request path do
    throwError "query receipt: edited query source"
  let inputs ← ofExcept <| receipt.getObjValAs? (Array Json) "source_inputs"
  let paths ← inputs.mapM (fun input => ofExcept (stringField input "path"))
  unless (← fingerprints paths).compress == (Json.arr inputs).compress do
    throwError "query receipt: stale source or compiled input"
  let replay := path ++ ".replay"
  let repository ← IO.currentDir
  let execution ← IO.Process.output {
    cmd := "python3"
    args := #[(repository / "tools/lean-inspector/Census/resources.py").toString,
      "--directory", path ++ ".replay-logs", "--label", "query", "--", "lake", "env", "lean",
      "-DmaxRecDepth=100000", "-DmaxHeartbeats=0", "-R", root.toString, source]
    env := #[("CENSUS_RECEIPT_REPLAY", some replay), ("LEAN_NUM_THREADS", some "1")] }
  unless execution.exitCode == 0 do throwError "query receipt: bounded replay failed; see {path}.replay-logs"
  unless (← IO.FS.readFile replay) == response &&
      (← IO.FS.readFile (replay ++ ".receipt.json")) == receiptBytes do
    throwError "query receipt: replay differs from supplied receipt or rows"
  ofExcept <| Json.parse response

end LeanInformationAudit.CensusReceipt
