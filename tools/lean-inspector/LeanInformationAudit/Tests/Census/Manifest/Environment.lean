import LeanInformationAudit.Census.Publish

open Lean Lean.Elab.Command LeanInformationAudit

run_cmd liftTermElabM <| CensusProjection.checkFinalEnvironment (← getEnv)
