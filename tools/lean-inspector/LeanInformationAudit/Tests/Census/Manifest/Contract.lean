import LeanInformationAudit.Census.Manifest

open Lean Meta Elab.Command LeanInformationAudit DispositionCensus CensusManifest

private def zeroId := "sha256:" ++ String.ofList (List.replicate 64 '0')
private def oneId := "sha256:" ++ String.ofList (List.replicate 63 '0') ++ "1"

run_cmd do
  unless decodeStatementId `T zeroId == .ok 0 && decodeStatementId `T oneId == .ok 1 do
    throwError "leadingZeroIdentity: strict codec lost leading zeros"
  let bad := #["SHA256:" ++ (oneId.drop 7).toString,
    "sha256:" ++ String.ofList (List.replicate 64 'A'),
    "sha256:" ++ String.ofList (List.replicate 63 '0'),
    "sha256:" ++ String.ofList (List.replicate 65 '0'),
    (oneId.drop 7).toString, "+" ++ oneId, oneId ++ " ", " " ++ oneId]
  for wire in bad do
    match decodeStatementId `T wire with
    | .error error => unless error.contains "component=statement_id_format" do throwError error
    | .ok _ => throwError "strictCodecRejections: malformed identity accepted"
  match bindStatementIdNat `T oneId 0 with
  | .error error => unless error.contains "component=statement_id_nat" do throwError error
  | .ok _ => throwError "codecRoundTripBinding: a second wire identity bound to zero"

private def report : FrozenReport :=
  { headSha := "head", reportSha256 := "digest", theorems := #[⟨`T, zeroId⟩, ⟨`U, oneId⟩] }

private def manifest : CensusKeyManifest :=
  ⟨"head", "digest", `Root, [(`T, 0), (`U, 1)]⟩

run_cmd do
  let keys := report.theorems
  ofExcept <| checkManifestBinding report `Root keys manifest manifest.keys
  for (label, candidate, reportKeys) in #[
      ("manifestDetachedFromRows", { manifest with keys := [(`V, 0), (`U, 1)] }, manifest.keys),
      ("reflexiveReportRejected", { manifest with keys := [(`V, 0), (`U, 1)] }, [(`V, 0), (`U, 1)]),
      ("staleManifestHead", { manifest with headSha := "stale" }, manifest.keys),
      ("wrongManifestDigest", { manifest with reportSha256 := "wrong" }, manifest.keys),
      ("manifestNatBinding", { manifest with keys := [(`T, 1), (`U, 2)] }, manifest.keys)] do
    match checkManifestBinding report `Root keys candidate reportKeys with
    | .error _ => pure ()
    | .ok _ => throwError "{label}: detached certificate accepted"
  match checkManifestBinding report `Root (keys.extract 0 1) manifest manifest.keys with
  | .error error => unless error.startsWith "IE-C034" do throwError error
  | .ok _ => throwError "deletedManifestRow: deleted row accepted"

run_cmd do
  liftTermElabM do
    let value := toExpr manifest
    let keys := toExpr manifest.keys
    let proof ← certificateProof value "head" "digest" `Root keys
    let expected ← mkAppM ``CensusKeyManifest.Certificate
      #[value, toExpr "head", toExpr "digest", toExpr (`Root : Name), keys]
    unless ← isDefEq (← inferType proof) expected do
      throwError "certificateAscendingConjunct: certificate type lost a conjunct"
    checkWithKernel proof
    let detached := toExpr ([(`Other, 0), (`U, 1)] : List (Name × Nat))
    let rejected ← try
      discard <| certificateProof value "head" "digest" `Root detached
      pure false
    catch _ => pure true
    unless rejected do throwError "reportListEqualityBinding: inventory copied to report side"

example : manifest.ExactlyCovers "head" manifest.keys.toFinset :=
  CensusKeyManifest.exactlyCovers_of_certificate manifest "head" "digest" `Root manifest.keys
    ⟨rfl, rfl, rfl, by decide, rfl⟩

example : strictlyAscending [0, 1, 2] = true := by decide
example : strictlyAscending [0, 0] = false := by decide
example : strictlyAscending [1, 0] = false := by decide

-- The structured Name is part of the kernel contract even when the id agrees.
example : ([(Name.mkSimple "T", 0)] : List (Name × Nat)) ≠ [(Name.mkSimple "U", 0)] := by decide
