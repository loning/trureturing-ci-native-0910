import LeanInformationAudit.Census.Publish

open Lean Meta Elab Command LeanInformationAudit DispositionCensus CensusManifest CensusProjection

/-- B1 isolates key accounting from classification/query work. Its row authority
is parseReport's validated frozen set; the emitter separately reads the export
for the report side. This receipt makes no classification or Name-level theorem claim. -/
elab "#census_certificate_benchmark" &"report" reportPath:str &"head" head:str
    &"digest" sha:str &"directory" directory:str : command => do
  let destination : System.FilePath := directory.getString
  let phase (label : String) := IO.FS.writeFile (destination / "benchmark.phase") label
  phase "emission"
  let report ← ofExcept <| parseReport head.getString sha.getString (← IO.FS.readFile reportPath.getString)
  let bindings := destination / "bindings.json"
  IO.FS.writeFile bindings (toJson report.theorems).compress
  let repository ← IO.currentDir
  let emission ← IO.Process.output { cmd := "python3", args := #[
    (repository / "tools/lean-inspector/Census/certificate_benchmark.py").toString,
    "--report", reportPath.getString, "--bindings", bindings.toString, "--directory", directory.getString] }
  unless emission.exitCode == 0 do throwError "emission failed: {emission.stderr}"
  let source := destination / "CensusRun/Root.lean"
  let input ← IO.FS.readFile source
  let options := (← getOptions).setBool `Elab.async false
  phase "compile_kernel"
  let env ← elaborateFinalSource input source.toString `CensusRun.Root options
  phase "boundary_axioms"
  liftTermElabM <| checkFinalEnvironment env (some `CensusRun.Root)
  withEnv env <| liftTermElabM do
    bindEmittedManifest report `CensusRun.Root report.theorems `CensusRun.manifest `CensusRun.reportKeys
  phase "compile_kernel"
  let checked := source.withExtension "checked.lean"
  let certificate := `CensusRun.accountingCertificate
  let staged ← elaborateFinalSource (certificateSource input `CensusRun.manifestKeys
    `CensusRun.reportKeys certificate report.theorems.size) checked.toString `CensusRun.Root options
  phase "boundary_axioms"
  liftTermElabM <| checkFinalEnvironment staged (some `CensusRun.Root)
  let (data, _) ← readModuleData (checked.withExtension "olean")
  let axioms ← withEnv staged <| collectAxioms certificate
  unless axioms.all (#[`propext, `Classical.choice, `Quot.sound].contains ·) do
    throwError "unapproved certificate axioms {axioms}"
  let proposition ← withEnv staged <| liftTermElabM do
    let info ← getConstInfo certificate
    unless info matches .thmInfo _ do throwError "expected serialized kernel theorem"
    let expected ← mkAppM ``CensusKeyManifest.Certificate
      #[mkConst `CensusRun.manifestKeys, toExpr report.theorems.size, mkConst `CensusRun.reportKeys]
    unless ← isDefEq info.type expected do throwError "wrong certificate proposition"
    return toString (← ppExpr info.type)
  withEnv staged <| elabCommand (← `(command| #print axioms $(mkIdent certificate)))
  phase "json"
  let fields := Json.mkObj [
    ("head_sha", toJson report.headSha), ("report_sha256", toJson report.reportSha256),
    ("keys", toJson report.theorems.size), ("rows", toJson report.theorems),
    ("certificate", Json.mkObj [("name", toJson certificate.toString), ("proposition", toJson proposition),
      ("axioms", toJson (axioms.map Name.toString))]),
    ("final_env_imports", toJson (data.imports.map (·.module.toString))),
    ("transitive_imports", toJson (staged.header.moduleNames.filter (· != `CensusRun.Root) |>.map Name.toString))]
  IO.FS.writeBinFile (source.withExtension "olean") (← IO.FS.readBinFile (checked.withExtension "olean"))
  IO.FS.writeFile (destination / "certificate.json.tmp") (fields.compress ++ "\n")
  IO.FS.rename (destination / "certificate.json.tmp") (destination / "certificate.json")
