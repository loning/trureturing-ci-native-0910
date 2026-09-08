/- GID: D5/S3/Arith/CyclotomicFiveResidueSum
   generality: G
   mirror-B: D5/B/S3/Arith/CyclotomicFiveResidueSum
   mirror-E: none(waiver:symbolic-arithmetic-no-numerical-evidence)
   anchors: []
   utility: none
   digest: Exact sums of units whose fifth cyclotomic value is a unit. -/

import D5.S3.Arith.ChineseRemainder
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Data.Nat.Factorization.Induction
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

namespace D5.S3.Arith.CyclotomicFiveResidueSum

def phi5 (u : ℕ) : ℕ := u ^ 4 + u ^ 3 + u ^ 2 + u + 1

def goodUnits (n : ℕ) : Finset ℕ :=
  (Finset.Ico 1 n).filter fun u => Nat.Coprime u n ∧ Nat.Coprime (phi5 u) n

private def admissible (n u : ℕ) : Prop := Nat.Coprime u n ∧ Nat.Coprime (phi5 u) n

private instance (n u : ℕ) : Decidable (admissible n u) :=
  inferInstanceAs (Decidable (Nat.Coprime u n ∧ Nat.Coprime (phi5 u) n))

private def residueSum (n : ℕ) : ℕ :=
  ∑ u ∈ Finset.range n, if admissible n u then u else 0

private theorem residueSum_eq (n : ℕ) : residueSum n = ∑ u ∈ goodUnits n, u := by
  rw [goodUnits, Finset.sum_filter]
  symm
  apply Finset.sum_subset
  · intro u hu
    simp only [Finset.mem_Ico, Finset.mem_range] at *
    exact hu.2
  · intro u hu hnot
    have hu' := Finset.mem_range.mp hu
    have hn' : ¬(1 ≤ u ∧ u < n) := by simpa only [Finset.mem_Ico] using hnot
    have : u = 0 := by omega
    simp [this]

/-- The only zero of the fifth cyclotomic value modulo five is the class one. -/
theorem phi5_mod_five_eq_zero_iff (u : ℕ) : phi5 u % 5 = 0 ↔ u % 5 = 1 := by
  have h : u % 5 < 5 := Nat.mod_lt _ (by decide)
  have hm : phi5 u % 5 = phi5 (u % 5) % 5 := by
    simp [phi5, Nat.add_mod, Nat.pow_mod]
  rw [hm]
  interval_cases hmod : u % 5 <;> norm_num [phi5]

private theorem admissible_five_pow (a u : ℕ) :
    admissible (5 ^ (a + 1)) u ↔ 2 ≤ u % 5 := by
  have hp : Nat.Prime 5 := by decide
  simp only [admissible, Nat.coprime_pow_right_iff (Nat.succ_pos a)]
  rw [Nat.coprime_comm, hp.coprime_iff_not_dvd,
    Nat.coprime_comm (n := phi5 u), hp.coprime_iff_not_dvd,
    Nat.dvd_iff_mod_eq_zero, Nat.dvd_iff_mod_eq_zero, phi5_mod_five_eq_zero_iff]
  omega

private theorem block_sum (q : ℕ) :
    (∑ u ∈ Finset.range (5 * q), if 2 ≤ u % 5 then u else 0) =
      9 * q + 15 * ∑ j ∈ Finset.range q, j := by
  induction q with
  | zero => simp
  | succ q ih =>
    rw [Nat.mul_succ, Finset.sum_range_add, ih, Finset.sum_range_succ]
    norm_num [Finset.sum_range_succ, Nat.add_mod, Nat.mul_mod]
    ring

/-- Exact representative sum for every positive power of five. -/
theorem sum_goodUnits_five_pow (a : ℕ) :
    (∑ u ∈ goodUnits (5 ^ (a + 1)), u) =
      9 * 5 ^ a + 15 * (5 ^ a * (5 ^ a - 1) / 2) := by
  rw [← residueSum_eq]
  simp_rw [residueSum, admissible_five_pow]
  rw [pow_succ', block_sum, Finset.sum_range_id]

#print axioms phi5_mod_five_eq_zero_iff
#print axioms sum_goodUnits_five_pow

end D5.S3.Arith.CyclotomicFiveResidueSum
