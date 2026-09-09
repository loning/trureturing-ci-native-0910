import Lean
import LeanInformationAudit.Census.Certificate
import Mathlib.Data.Finset.Card

namespace LeanInformationAudit

open Lean

instance : ToExpr CensusKeyManifest where
  toTypeExpr := mkConst ``CensusKeyManifest
  toExpr value := mkApp4 (mkConst ``CensusKeyManifest.mk) (toExpr value.headSha)
    (toExpr value.reportSha256) (toExpr value.censusRoot) (toExpr value.keys)

/-- The existing inventory accounting contract restated over Name × Nat.
The hex-to-Nat correspondence is elaborator-validated, not a String-level theorem. -/
def CensusKeyManifest.ExactlyCovers (m : CensusKeyManifest) (head : String)
    (reportKeys : Finset (Name × Nat)) : Prop :=
  m.headSha = head ∧ m.keys.Nodup ∧ (m.keys.map Prod.snd).Nodup ∧ m.keys.toFinset = reportKeys

theorem CensusKeyManifest.exactlyCovers_of_certificate (m : CensusKeyManifest)
    (head sha : String) (root : Name) (reportKeys : List (Name × Nat))
    (h : m.Certificate head sha root reportKeys) : m.ExactlyCovers head reportKeys.toFinset := by
  have ids := strictlyAscending_nodup _ h.2.2.2.1
  exact ⟨h.1, List.Nodup.of_map Prod.snd ids, ids, congrArg List.toFinset h.2.2.2.2⟩

end LeanInformationAudit
