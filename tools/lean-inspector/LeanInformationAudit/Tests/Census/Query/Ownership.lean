import LeanInformationAudit.Census.Command
import LeanInformationAudit.Tests.Census.Query.OwnerFirst
import LeanInformationAudit.Tests.Census.Query.OwnerSecond

open Lean Lean.Elab.Command LeanInformationAudit

run_cmd liftTermElabM do
  let env <- getEnv
  let owner := `LeanInformationAudit.Tests.Census.Query.OwnerSecond
  let name := `LeanInformationAudit.Tests.Census.Query.ownerParent.congr_simp
  let index <- CensusQuery.buildIndex env.header.mainModule
  unless CensusQuery.owningModule env name != owner do
    throwError "ownerMembershipPositive: fixture did not exercise first-import ambiguity"
  unless <- CensusOwnership.recordedModuleContainsTheorem env index.modules owner name do
    throwError "ownerMembershipPositive: valid realizing module rejected"
  let row <- CensusQuery.assess index "fixture-head"
    (.mk name ("sha256:" ++ String.ofList (List.replicate 64 '0'))) (some owner)
  let .observed value := row | throwError "ownerMembershipPositive: expected observation"
  unless value.owningModule == owner do
    throwError "ownerMembershipPositive: recorded provenance was lost"
  if <- CensusOwnership.recordedModuleContainsTheorem env #[] owner name then
    throwError "ownerMembershipOutOfScope: out-of-scope module accepted"
  if <- CensusOwnership.recordedModuleContainsTheorem env index.modules `Init name then
    throwError "ownerMembershipAbsent: declaration absent from module constants accepted"
  let some moduleIndex := env.getModuleIdx? owner | throwError "missing fixture module"
  let data := env.header.moduleData[moduleIndex.toNat]!
  let .thmInfo info <- getConstInfo name | throwError "fixture is not a theorem"
  let wrongType := ConstantInfo.thmInfo { info with type := mkConst ``False }
  let wrongLevels := ConstantInfo.thmInfo { info with levelParams := [`u] }
  for (label, candidate) in [("ownerMembershipDifferentType", wrongType),
      ("ownerMembershipDifferentLevels", wrongLevels)] do
    if CensusOwnership.moduleContainsTheorem data candidate then
      throwError "{label}: mismatching declaration accepted"
  let parent <- getConstInfo `LeanInformationAudit.Tests.Census.Query.ownerParent
  if CensusOwnership.moduleContainsTheorem data parent then
    throwError "ownerMembershipWrongKind: definition accepted as theorem"
