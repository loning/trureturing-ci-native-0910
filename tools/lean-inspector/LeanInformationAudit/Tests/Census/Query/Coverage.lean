import LeanInformationAudit.Census.Publish

open LeanInformationAudit

namespace LeanInformationAudit.Tests.Census.Query

private def rows : DispositionInventory :=
  { headSha := "head", entries := #[
    Sigma.mk (StatementKey.mk `Absent.A "a")
      (.observed (AnalysisObservation.mk `Absent `Scope
        (ImportClosureScope.mk #[`Scope, `Absent] true) true #[] "")),
    Sigma.mk (StatementKey.mk `Absent.A "b")
      (.observed (AnalysisObservation.mk `Absent `Scope
        (ImportClosureScope.mk #[`Scope, `Absent] true) true #[] ""))] }

example : rows.ExactlyCovers "head" rows.keys.toFinset :=
  CensusCoverage.of_sorted_ids rows "head" rows.keys rfl rfl (by decide)

private def assembled : DispositionInventory :=
  { rows with entries := CensusProjection.assemble #[#[rows.entries[0]!], #[], #[rows.entries[1]!]] }

example : assembled.ExactlyCovers "head" rows.keys.toFinset :=
  CensusCoverage.of_sorted_ids assembled "head" rows.keys rfl (by decide) (by decide)

example : !CensusCoverage.increasing ["a", "a"] := by decide
example : !CensusCoverage.increasing ["b", "a"] := by decide

end LeanInformationAudit.Tests.Census.Query
