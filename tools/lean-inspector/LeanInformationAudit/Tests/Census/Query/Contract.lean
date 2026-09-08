import LeanInformationAudit.Census.Query
import LeanInformationAudit.Tests.Census.Evidence
import LeanInformationAudit.Tests.Census.Query.Registration

open Lean Lean.Meta Lean.Elab.Command LeanInformationAudit DispositionCensus

namespace LeanInformationAudit.Tests.Census.Query

set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd liftTermElabM do
  let key : StatementKey := ⟨``target, "target-id"⟩
  let mut missingScopeRejected := false
  try
    let _ ← CensusQuery.buildIndex `MissingCensusModule
  catch error =>
    unless (← error.toMessageData.toString).contains "existing-module" do throw error
    missingScopeRejected := true
  unless missingScopeRejected do throwError "missingScopeRejected: query error became an observation"
  let outside ← CensusQuery.buildIndex `LeanInformationAudit.Tests.Census.Query.Source
  let row ← CensusQuery.assess outside "fixture-head" key
  match row with
  | .observed value =>
    unless value.queryCompleted && value.importScope.completed && value.candidates.isEmpty &&
        value.importScope.modules.contains `LeanInformationAudit.Tests.Census.Query.Source &&
        !value.importScope.modules.contains `LeanInformationAudit.Tests.Census.Query.Registration do
      throwError "outsideScopeObserved: registration leaked across the declared scope"
  | .certified _ => throwError "outsideScopeObserved: outside registration certified"
  let inside ← CensusQuery.buildIndex `LeanInformationAudit.Tests.Census.Evidence
  let finiteKey : StatementKey := ⟨``SealSuccess.idTheorem, "finite-id"⟩
  let row ← CensusQuery.assess inside "fixture-head" finiteKey
  unless row.className == "finite_occurrence" do
    throwError "insideScopeCertified: certifying registration was not selected"
  validateEvidence `LeanInformationAudit.Tests.Census.Evidence
    ⟨"fixture-head", #[⟨finiteKey, row⟩]⟩
  let mut rejected := false
  try
    let _ ← CensusQuery.assess outside "fixture-head" ⟨`MissingTheorem, "missing-id"⟩
  catch _ => rejected := true
  unless rejected do throwError "missingTheoremRejected: query error became an observation"
  logInfo "missingScopeRejected outsideScopeObserved insideScopeCertified missingTheoremRejected"

end LeanInformationAudit.Tests.Census.Query
