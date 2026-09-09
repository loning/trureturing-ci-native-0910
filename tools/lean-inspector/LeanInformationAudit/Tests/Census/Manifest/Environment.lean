import LeanInformationAudit.Census.Publish

open Lean Lean.Elab.Command LeanInformationAudit

run_cmd do
  let env ← CensusProjection.elaborateFinalSource
    "import LeanInformationAudit.Census.Certificate\n" "FinalEnvironment.lean" `FinalEnvironment {}
  liftTermElabM <| CensusProjection.checkFinalEnvironment env
