import LeanInformationAudit.Census.Report

namespace LeanInformationAudit.CensusTransport

open Lean Meta DispositionCensus

/-- Consume the exact whole-stream handoff. The query lane owns classification;
publication binds its compact-row hash, expanded scopes and receipt digest. -/
def readHandoff (census receipt digest : String) (report : FrozenReport) : IO (Array StatementKey) :=
  IO.FS.withTempDir fun directory => do
    let keys := directory / "keys.json"
    let repository ← IO.currentDir
    let result ← IO.Process.output { cmd := "python3", args := #[
      (repository / "tools/lean-inspector/Census/handoff.py").toString,
      "--census", census, "--receipt", receipt, "--digest", digest,
      "--head", report.headSha, "--report-sha", report.reportSha256, "--output", keys.toString] }
    unless result.exitCode == 0 do throw <| IO.userError result.stderr
    let json ← IO.ofExcept <| Json.parse (← IO.FS.readFile keys)
    (← IO.ofExcept json.getArr?).mapM fun row => do
      return ⟨← IO.ofExcept <| parseNameJson (← IO.ofExcept <| row.getObjVal? "theorem_name"),
        ← IO.ofExcept <| stringField row "statement_id"⟩

def publish (census destination : String) (metadata : Json) : IO Unit :=
  IO.FS.withTempDir fun directory => do
    let certificate := directory / "certificate.json"
    IO.FS.writeFile certificate metadata.compress
    let repository ← IO.currentDir
    let result ← IO.Process.output { cmd := "python3", args := #[
      (repository / "tools/lean-inspector/Census/handoff.py").toString,
      "--census", census, "--certificate", certificate.toString, "--output", destination] }
    unless result.exitCode == 0 do throw <| IO.userError result.stderr

end LeanInformationAudit.CensusTransport
