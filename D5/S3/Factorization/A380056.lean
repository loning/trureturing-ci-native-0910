/- GID: D5/S3/Factorization/A380056
   generality: G
   mirror-B: D5/B/S3/Factorization/A380056
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: Hanna's second A380056 conjecture follows from its finite sum and Euler residues. -/

import Mathlib.Data.Nat.Choose.Sum
import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.NormNum

open scoped BigOperators
open Finset

namespace D5.S3.Factorization.A380056

/-- A fourth-root filter evaluates the entire residue-two binomial sum modulo five. -/
theorem binomial_residue_two (n : ℕ) (hn : 1 ≤ n) :
    (∑ j ∈ range (4 * n + 1),
      if j % 4 = 2 then ((4 * n).choose j : ZMod 5) else 0) = 1 := by
  have hfilter (j : ℕ) :
      (if j % 4 = 2 then (1 : ZMod 5) else 0) =
        4 * (1 ^ j + (-1) ^ j - 2 ^ j - 3 ^ j) := by
    rw [pow_eq_pow_mod j (by decide : (-1 : ZMod 5) ^ 4 = 1),
      pow_eq_pow_mod j (by decide : (2 : ZMod 5) ^ 4 = 1),
      pow_eq_pow_mod j (by decide : (3 : ZMod 5) ^ 4 = 1)]
    have hj : j % 4 < 4 := Nat.mod_lt _ (by decide)
    interval_cases h : j % 4 <;> norm_num <;> decide
  have hbinom (x : ZMod 5) :
      (∑ j ∈ range (4 * n + 1), x ^ j * ((4 * n).choose j : ZMod 5)) =
        (x + 1) ^ (4 * n) := by
    simpa only [one_pow, mul_one] using (add_pow x 1 (4 * n)).symm
  calc
    _ = ∑ j ∈ range (4 * n + 1),
        4 * (1 ^ j + (-1) ^ j - 2 ^ j - 3 ^ j) *
          ((4 * n).choose j : ZMod 5) := by
      apply sum_congr rfl
      intro j _
      rw [← hfilter]
      split_ifs <;> simp
    _ = 4 * ((1 + 1) ^ (4 * n) + (-1 + 1) ^ (4 * n) -
        (2 + 1) ^ (4 * n) - (3 + 1) ^ (4 * n)) := by
      simp only [mul_assoc, add_mul, sub_mul, ← mul_sum, sum_add_distrib,
        sum_sub_distrib, hbinom]
    _ = 1 := by
      have hpos : 4 * n ≠ 0 := by omega
      norm_num [hpos, pow_mul]
      rw [show (16 : ZMod 5) = 1 from by decide,
        show (81 : ZMod 5) = 1 from by decide,
        show (256 : ZMod 5) = 1 from by decide, zero_pow (by omega : n ≠ 0)]
      norm_num
      decide

#print axioms binomial_residue_two

end D5.S3.Factorization.A380056
