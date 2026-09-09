import LeanInformationAudit.Census.Stream

open Lean LeanInformationAudit CensusStream

private def theoremInfo : ConstantInfo := .thmInfo {
  name := `Fixture.target, levelParams := [], type := mkConst ``True, value := mkConst ``True.intro }

run_cmd do
  let data : ModuleData := { (default : ModuleData) with
    constNames := #[theoremInfo.name], constants := #[theoremInfo] }
  unless CensusOwnership.moduleContainsTheorem data theoremInfo do
    throwError "streamMembershipPositive: theorem not found in its module"
  let malformed := { data with constNames := #[] }
  if CensusOwnership.moduleContainsTheorem malformed theoremInfo then
    throwError "streamMembershipMalformed: missing name table accepted"
  let encoded := toExpr (`Fixture.target : Name)
  unless decodeName? encoded == some `Fixture.target do
    throwError "streamNamedKeyPositive: literal Name did not decode"
  unless (decodeName? (mkConst `opaqueName)).isNone do
    throwError "streamUnclassifiableNamedKey: opaque key silently classified"
  let family := mkApp (mkConst `LeanInformationAudit.BoundedTruncationFamily) (mkConst ``True)
  unless evidenceHead { theoremInfo.toConstantVal with type := family } ==
      some `LeanInformationAudit.BoundedTruncationFamily do
    throwError "streamTypeHeads: direct family evidence not indexed"
  logInfo "streamMembershipPositive streamMembershipMalformed streamNamedKeyPositive streamUnclassifiableNamedKey streamTypeHeads"
