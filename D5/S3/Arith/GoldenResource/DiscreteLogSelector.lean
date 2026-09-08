/- GID: D5/S3/Arith/GoldenResource/DiscreteLogSelector
   generality: G
   mirror-B: D5/B/S3/Arith/GoldenResource/DiscreteLogSelector
   mirror-E: none(waiver:general-real-analysis)
   anchors: []
   utility: none
   digest: The logarithmic price interval uniquely selects an integer layer and supplies a uniform gap. -/

import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity

namespace D5.S3.Arith.GoldenResource.DiscreteLogSelector

open Real

noncomputable section

private def objective (p : ℝ) (n : ℕ) : ℝ := Real.log (n : ℝ) - p * n

private def lowerMargin (k : ℕ) (p : ℝ) : ℝ := Real.log ((k : ℝ) / (k - 1 : ℕ)) - p

private def upperMargin (k : ℕ) (p : ℝ) : ℝ := p - Real.log (((k + 1 : ℕ) : ℝ) / k)

private theorem cast_pos {n : ℕ} (hn : 0 < n) : (0 : ℝ) < n := by
  exact_mod_cast hn

private theorem ratio_step (n : ℕ) (hn : 0 < n) :
    (((n + 2 : ℕ) : ℝ) / (n + 1)) < (((n + 1 : ℕ) : ℝ) / n) := by
  rw [div_lt_div_iff₀ (by positivity : (0 : ℝ) < n + 1) (cast_pos hn)]
  norm_num [Nat.cast_add]
  nlinarith [cast_pos hn]

private theorem ratio_antitone {m n : ℕ} (hm : 0 < m) (h : m ≤ n) :
    (((n + 1 : ℕ) : ℝ) / n) ≤ (((m + 1 : ℕ) : ℝ) / m) := by
  norm_num [Nat.cast_add]
  have hn : 0 < n := lt_of_lt_of_le hm h
  rw [div_le_div_iff₀ (cast_pos hn) (cast_pos hm)]
  nlinarith [show (m : ℝ) ≤ n by exact_mod_cast h]

private theorem ratio_strict {m n : ℕ} (hm : 0 < m) (hmn : m < n) :
    (((n + 1 : ℕ) : ℝ) / n) < (((m + 1 : ℕ) : ℝ) / m) := by
  norm_num [Nat.cast_add]
  have hn : 0 < n := lt_of_lt_of_le hm (Nat.le_of_lt hmn)
  rw [div_lt_div_iff₀ (cast_pos hn) (cast_pos hm)]
  nlinarith [show (m : ℝ) < n by exact_mod_cast hmn]

private theorem objective_succ_sub (p : ℝ) {n : ℕ} (hn : 0 < n) :
    objective p (n + 1) - objective p n =
      Real.log (((n + 1 : ℕ) : ℝ) / n) - p := by
  simp only [objective, Nat.cast_add, Nat.cast_one]
  rw [Real.log_div (by positivity : (n : ℝ) + 1 ≠ 0) (ne_of_gt (cast_pos hn))]
  ring

private theorem lower_step {k n : ℕ} (hk : 2 ≤ k) (hn : 0 < n) (hnk : n < k)
    {p : ℝ} (_hp : p < Real.log ((k : ℝ) / (k - 1 : ℕ))) :
    lowerMargin k p ≤ objective p (n + 1) - objective p n := by
  rw [objective_succ_sub p hn]
  unfold lowerMargin
  have hkn : n ≤ k - 1 := by omega
  have hratio : ((k : ℝ) / (k - 1 : ℕ)) ≤ (((n + 1 : ℕ) : ℝ) / n) := by
    have h := ratio_antitone hn hkn
    simpa [Nat.sub_add_cancel (by omega : 1 ≤ k)] using h
  have hkminus : 0 < k - 1 := by omega
  have hlog := Real.strictMonoOn_log.monotoneOn
    (show 0 < (k : ℝ) / ((k - 1 : ℕ) : ℝ) by
      exact div_pos (by exact_mod_cast (show 0 < k by omega)) (by exact_mod_cast hkminus))
    (show 0 < ((n + 1 : ℕ) : ℝ) / n by positivity) hratio
  linarith

private theorem upper_step {k n : ℕ} (hk : 2 ≤ k) (hn : 0 < k) (hnk : k ≤ n)
    {p : ℝ} (_hp : Real.log (((k + 1 : ℕ) : ℝ) / k) < p) :
    upperMargin k p ≤ objective p n - objective p (n + 1) := by
  have hstep := objective_succ_sub p (by omega : 0 < n)
  rw [show objective p n - objective p (n + 1) =
      -(objective p (n + 1) - objective p n) by ring, hstep]
  unfold upperMargin
  have hratio : (((n + 1 : ℕ) : ℝ) / n) ≤ (((k + 1 : ℕ) : ℝ) / k) :=
    ratio_antitone (by omega) hnk
  have hnpos : 0 < n := lt_of_lt_of_le hn hnk
  have hlog := Real.strictMonoOn_log.monotoneOn
    (show 0 < ((n + 1 : ℕ) : ℝ) / n by
      exact div_pos (by positivity) (by exact_mod_cast hnpos))
    (show 0 < ((k + 1 : ℕ) : ℝ) / k by positivity) hratio
  linarith

private theorem left_telescope {k n : ℕ} (hk : 2 ≤ k) (hn : 0 < n) (hnk : n < k)
    {p : ℝ} (hp : p < Real.log ((k : ℝ) / (k - 1 : ℕ))) :
    lowerMargin k p ≤ objective p k - objective p n := by
  have hmargin : 0 ≤ lowerMargin k p := by
    unfold lowerMargin
    linarith
  have hres : k ≤ k → lowerMargin k p ≤ objective p k - objective p n := by
    refine @Nat.le_induction (n + 1)
      (fun j _ => j ≤ k → lowerMargin k p ≤ objective p j - objective p n) ?_ ?_ k (by omega)
    · intro _
      have hstep := lower_step (k := k) (n := n) hk hn (by omega) hp
      linarith
    · intro j hj ih hjk
      have hstep := lower_step (k := k) (n := j) hk (by omega) (by omega) hp
      have hsum : objective p (j + 1) - objective p n =
          (objective p (j + 1) - objective p j) + (objective p j - objective p n) := by ring
      rw [hsum]
      have ih' := ih (by omega)
      linarith
  exact hres (by omega)

private theorem right_telescope {k n : ℕ} (hk : 2 ≤ k) (hn : 0 < k) (hkn : k < n)
    {p : ℝ} (hp : Real.log (((k + 1 : ℕ) : ℝ) / k) < p) :
    upperMargin k p ≤ objective p k - objective p n := by
  have hmargin : 0 ≤ upperMargin k p := by
    unfold upperMargin
    linarith
  have hres : n ≤ n → upperMargin k p ≤ objective p k - objective p n := by
    refine @Nat.le_induction (k + 1)
      (fun j _ => j ≤ n → upperMargin k p ≤ objective p k - objective p j) ?_ ?_ n (by omega)
    · intro _
      have hstep := upper_step (k := k) (n := k) hk hn (by omega) hp
      linarith
    · intro j hj ih hjn
      have hstep := upper_step (k := k) (n := j) hk hn (by omega) hp
      have hsum : objective p k - objective p (j + 1) =
          (objective p k - objective p j) + (objective p j - objective p (j + 1)) := by ring
      rw [hsum]
      have ih' := ih (by omega)
      linarith
  exact hres (by omega)

/-- On the strict price interval, the integer objective has a unique maximizer and
every other positive integer loses at least the smaller endpoint margin. -/
theorem discrete_log_unique_maximum {k : ℕ} (hk : 2 ≤ k) {p : ℝ}
    (hlo : Real.log (((k + 1 : ℕ) : ℝ) / k) < p)
    (hhi : p < Real.log ((k : ℝ) / (k - 1 : ℕ))) :
    ∀ n : ℕ, 0 < n →
      objective p n ≤ objective p k ∧
      (n ≠ k → min (lowerMargin k p) (upperMargin k p) ≤ objective p k - objective p n) := by
  intro n hn
  by_cases hnk : n = k
  · subst hnk
    constructor
    · rfl
    · intro h
      contradiction
  · have hkpos : 0 < k := by omega
    by_cases hleft : n < k
    · have hgap := left_telescope hk hn hleft hhi
      have hpos : 0 < lowerMargin k p := by
        unfold lowerMargin
        linarith
      constructor
      · linarith
      · intro _
        exact min_le_left _ _ |>.trans hgap
    · have hright : k < n := by omega
      have hgap := right_telescope hk hkpos hright hlo
      have hpos : 0 < upperMargin k p := by
        unfold upperMargin
        linarith
      constructor
      · linarith
      · intro _
        exact min_le_right _ _ |>.trans hgap

#print axioms discrete_log_unique_maximum

end
end D5.S3.Arith.GoldenResource.DiscreteLogSelector
