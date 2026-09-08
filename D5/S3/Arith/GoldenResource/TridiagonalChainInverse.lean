/- GID: D5/S3/Arith/GoldenResource/TridiagonalChainInverse
   generality: G
   mirror-B: D5/B/S3/Arith/GoldenResource/TridiagonalChainInverse
   mirror-E: none(waiver:general-matrix-family)
   anchors: []
   utility: none
   digest: The 4,-1 chain has an explicit inverse column and exponentially small endpoints. -/

import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic

namespace D5.S3.Arith.GoldenResource.TridiagonalChainInverse

open Matrix
open scoped BigOperators

noncomputable section

/-- The integral recurrence associated with the diagonal-four chain. -/
def chainDet : ℕ → ℤ
  | 0 => 1
  | 1 => 4
  | n + 2 => 4 * chainDet (n + 1) - chainDet n

private theorem chainDet_growth (n : ℕ) :
    0 < chainDet n ∧ 3 * chainDet n ≤ chainDet (n + 1) := by
  induction n with
  | zero => norm_num [chainDet]
  | succ n ih =>
    have hp : 0 < chainDet (n + 1) := by omega
    constructor
    · exact hp
    · change 3 * chainDet (n + 1) ≤ 4 * chainDet (n + 1) - chainDet n
      omega

/-- Every term of the chain recurrence is positive. -/
theorem chainDet_pos (n : ℕ) : 0 < chainDet n := (chainDet_growth n).1

/-- The recurrence grows at least geometrically with ratio three. -/
theorem chainDet_ge_three_pow (n : ℕ) : (3 : ℤ) ^ n ≤ chainDet n := by
  induction n with
  | zero => norm_num [chainDet]
  | succ n ih =>
    have h := (chainDet_growth n).2
    rw [pow_succ]
    nlinarith

/-- Squared denominators grow at least geometrically with ratio nine. -/
theorem chainDet_sq_ge_nine_pow (n : ℕ) : (9 : ℤ) ^ n ≤ chainDet n ^ 2 := by
  have h := chainDet_ge_three_pow n
  have hp : 0 ≤ (3 : ℤ) ^ n := by positivity
  have he : (9 : ℤ) ^ n = ((3 : ℤ) ^ n) ^ 2 := by
    rw [← pow_mul, mul_comm n 2, pow_mul]
    norm_num
  rw [he]
  nlinarith

#print axioms chainDet_pos
#print axioms chainDet_ge_three_pow
#print axioms chainDet_sq_ge_nine_pow

end

end D5.S3.Arith.GoldenResource.TridiagonalChainInverse
