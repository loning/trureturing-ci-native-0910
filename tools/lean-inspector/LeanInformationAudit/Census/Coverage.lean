import Lean
import Mathlib.Data.List.Chain
import Mathlib.Data.Finset.Card

namespace LeanInformationAudit

open Lean

/-- The certificate uses complete structured keys; Nat alone cannot identify a Name. -/
structure CensusKeyManifest where
  headSha : String
  reportSha256 : String
  censusRoot : Name
  keys : List (Name × Nat)
  deriving Repr, Inhabited

instance : ToExpr CensusKeyManifest where
  toTypeExpr := mkConst ``CensusKeyManifest
  toExpr value := mkApp4 (mkConst ``CensusKeyManifest.mk) (toExpr value.headSha)
    (toExpr value.reportSha256) (toExpr value.censusRoot) (toExpr value.keys)

/-- Exactly one Nat comparison per adjacent pair; no String comparisons in the kernel. -/
def strictlyAscending : List Nat → Bool
  | a :: b :: rest => decide (a < b) && strictlyAscending (b :: rest)
  | _ => true

private theorem strictlyAscending_chain (xs : List Nat) (h : strictlyAscending xs = true) :
    xs.IsChain (fun a b => a < b) := by
  induction xs with
  | nil => simp
  | cons a rest ih =>
    cases rest with
    | nil => simp
    | cons b rest =>
      simp only [strictlyAscending, Bool.and_eq_true, decide_eq_true_eq] at h
      exact List.isChain_cons_cons.mpr (And.intro h.1 (ih h.2))

theorem strictlyAscending_nodup (xs : List Nat) (h : strictlyAscending xs = true) : xs.Nodup := by
  exact (List.isChain_iff_pairwise.mp (strictlyAscending_chain xs h)).imp
    (fun {a b} lt eq => by subst b; exact Nat.lt_irrefl a lt)

/-- Flat accounting certificate. Equality retains Names, ids, and report metadata. -/
def CensusKeyManifest.Certificate (m : CensusKeyManifest) (head sha : String) (root : Name)
    (reportKeys : List (Name × Nat)) : Prop :=
  m.headSha = head ∧ m.reportSha256 = sha ∧ m.censusRoot = root ∧
    strictlyAscending (m.keys.map Prod.snd) = true ∧ m.keys = reportKeys

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
