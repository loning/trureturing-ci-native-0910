import LeanInformationAudit.Census.Report

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
