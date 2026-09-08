import LeanInformationAudit.Census.Receipt

namespace LeanInformationAudit.CensusQuery

open Lean Meta Elab Command DispositionCensus

/-- Discovery visits the complete declared closure, including seals whose
registration modules are elsewhere. Only discovered module names cross processes. -/
elab "#census_discover " destination:str : command => do
  let modules <- liftTermElabM do
    let env <- getEnv
    let index <- buildIndex env.header.mainModule
    let mut modules := #[]
    for (_, names) in index.named.toList do
      for name in names do modules := modules.push (owningModule env name)
    for entry in index.finite do
      modules := modules ++ #[entry.registrationModuleName]
    for entry in index.structural do modules := modules.push entry.registrationModule
    for record in SealRecords.entries env do modules := modules.push record.catalog.rootId
    return modules.toList.eraseDups.toArray.qsort Name.quickLt
  IO.FS.writeFile destination.getString ((toJson (modules.map Name.toString)).compress ++ "\n")

/-- Keys are bound to the immutable report before querying. The census emits a
receipt only after every query succeeds; caller-supplied completion flags reject. -/
elab "#census_query " requestPath:str " output " destination:str : command => do
  let (input, _) <- liftTermElabM <| CensusReceipt.readRequest requestPath.getString
  let head <- ofExcept <| stringField input "head"
  let requests <- ofExcept <| input.getObjValAs? (Array (Array String)) "keys"
  let (result, modules) <- liftTermElabM do
    let env <- getEnv
    let index <- buildIndex env.header.mainModule
    let mut entries := #[]
    let mut certifiedImports := #[]
    let mut ids : Std.HashSet String := {}
    for request in requests do
      unless request.size == 3 do throwError "census query: expected module/name/identity triple"
      let key : StatementKey :=
        StatementKey.mk (<- ofExcept <| parseNameKey request[1]!) request[2]!
      if ids.contains key.statementId then throwError "census query: duplicate statement identity"
      ids := ids.insert key.statementId
      unless (owningModule env key.theoremName).toString == request[0]! do
        throwError "census query: owning module mismatch: {key.theoremName}"
      let row <- assess index head key
      if let .certified disposition := row then
        let names := match disposition with
          | .finiteOccurrence value => #[value.canonicalArena, value.registration,
              value.realization, value.nondegeneracyCertificate, value.stateEnumerationCertificate] ++
              (finiteSealInScope? env index.modules key.theoremName value.canonicalArena).toArray
          | .structuralOccurrence value => #[value.canonicalArena, value.registration,
              value.realization, value.strictnessCertificate, value.witnessCertificate]
          | .boundedFiniteTruncation value => #[value.truncationFamily, value.comparisonStatement] ++
              (match value.certification with | .reportOnly => #[] | .transferred name => #[name])
          | .unreachable value => #[value.evidence]
        for name in names.push key.theoremName do
          certifiedImports := certifiedImports.push (owningModule env name)
      let json := dispositionRowJson (Sigma.mk key row)
      let json := match row with
        | .observed _ => json.setObjVal! "payload"
            (((json.getObjVal? "payload").toOption.get!).setObjVal! "import_scope" Json.null)
        | .certified _ => json
      entries := entries.push json
    return (Json.mkObj [
      ("head", toJson head), ("root", nameJson index.root),
      ("scope", toJson (ImportClosureScope.mk index.modules true)),
      ("certified_imports", toJson (certifiedImports.toList.eraseDups.toArray.qsort Name.quickLt
        |>.map Name.toString)),
      ("entries", Json.arr entries)], index.modules)
  liftTermElabM <| CensusReceipt.write requestPath.getString destination.getString input result modules

end LeanInformationAudit.CensusQuery
