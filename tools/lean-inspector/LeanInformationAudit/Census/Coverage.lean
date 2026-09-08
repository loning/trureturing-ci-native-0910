import LeanInformationAudit.AnalysisDisposition
import Mathlib.Data.List.Chain

namespace LeanInformationAudit.CensusCoverage

/-- Adjacent comparisons suffice for uniqueness in a strict total order. -/
def increasing : List String -> Bool
  | a :: b :: rest => decide (a < b) && increasing (b :: rest)
  | _ => true

private theorem increasing_chain (xs : List String) (h : increasing xs = true) :
    xs.IsChain (fun a b => a < b) := by
  induction xs with
  | nil => simp
  | cons a rest ih =>
    cases rest with
    | nil => simp
    | cons b rest =>
      simp only [increasing, Bool.and_eq_true, decide_eq_true_eq] at h
      exact List.isChain_cons_cons.mpr (And.intro h.1 (ih h.2))

theorem of_sorted_ids (inventory : DispositionInventory) (head : String)
    (keys : List StatementKey) (head_eq : inventory.headSha = head)
    (keys_eq : inventory.keys = keys)
    (ordered : increasing (keys.map StatementKey.statementId) = true) :
    inventory.ExactlyCovers head keys.toFinset := by
  have chain := increasing_chain _ ordered
  have pairs := List.isChain_iff_pairwise.mp chain
  have ids : (inventory.keys.map StatementKey.statementId).Nodup :=
    keys_eq.symm ▸ pairs.imp (fun {a b} h eq => by subst b; exact String.lt_irrefl a h)
  exact And.intro head_eq (And.intro (List.Nodup.of_map StatementKey.statementId ids)
    (And.intro ids (congrArg List.toFinset keys_eq)))

end LeanInformationAudit.CensusCoverage
