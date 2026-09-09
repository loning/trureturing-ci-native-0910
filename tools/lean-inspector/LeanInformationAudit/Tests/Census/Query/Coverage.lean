import LeanInformationAudit.Census.Publish

open Lean LeanInformationAudit

namespace LeanInformationAudit.Tests.Census.Query

private def rows : CensusKeyManifest :=
  ⟨"head", "digest", `Scope, [(`Absent.A, 0), (`Absent.A, 1)]⟩

example : rows.ExactlyCovers "head" rows.keys.toFinset :=
  CensusKeyManifest.exactlyCovers_of_certificate _ _ _ _ _
    ⟨rfl, rfl, rfl, by decide, rfl⟩

private def assembled : CensusKeyManifest :=
  { rows with keys := [[(`Absent.A, 0)], [], [(`Absent.A, 1)]].flatten }

example : assembled.ExactlyCovers "head" rows.keys.toFinset :=
  CensusKeyManifest.exactlyCovers_of_certificate _ _ _ _ _
    ⟨rfl, rfl, rfl, by decide, rfl⟩

example : !strictlyAscending [0, 0] := by decide
example : !strictlyAscending [1, 0] := by decide

end LeanInformationAudit.Tests.Census.Query
