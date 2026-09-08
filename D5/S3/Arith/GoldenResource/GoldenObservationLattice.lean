/- GID: D5/S3/Arith/GoldenResource/GoldenObservationLattice
   generality: I
   mirror-B: D5/B/S3/Arith/GoldenResource/GoldenObservationLattice
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: kind=certified-instance; basis=refutes=atom:9352f754b7437592817050548dd3e5f8f386307ff69d73c934573232e17dd260; result=D5/S3/Arith/GoldenResource/GoldenObservationLattice.Gobs_lattice_boundary_refutation; claim=D5/S3/Arith/GoldenResource/GoldenObservationLattice.goldenObservationMultiplicativeOrAssociativeAtWitness
   digest: Golden observation preserves gcd and lcm but fails multiplicativity and fixed-point associativity. -/

import D5.S3.Arith.GoldenResource.GoldenDivisorLanguage
import D5.S3.Arith.GoldenResource.GoldenFixedPoint

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S3.Arith.GoldenResource.GoldenObservationLattice

open D5.S3.Arith.GoldenResource.GoldenDivisorLanguage
open D5.S3.Arith.GoldenResource.GoldenFixedPoint

/-- Golden observation preserves greatest common divisors. -/
theorem Gobs_gcd (m n : PNat) :
    Gobs (PNat.gcd m n) = (Gobs m).gcd (Gobs n) := by
  apply Nat.eq_of_factorization_eq (Gobs_pos _).ne'
    (Nat.gcd_pos_of_pos_left _ (Gobs_pos m)).ne'
  intro p
  rw [Gobs_factorization, PNat.gcd_coe,
    Nat.factorization_gcd m.pos.ne' n.pos.ne', Finsupp.inf_apply,
    Nat.factorization_gcd (Gobs_pos m).ne' (Gobs_pos n).ne', Finsupp.inf_apply,
    Gobs_factorization, Gobs_factorization, b_monotone.map_min]

/-- Golden observation preserves least common multiples. -/
theorem Gobs_lcm (m n : PNat) :
    Gobs (PNat.lcm m n) = (Gobs m).lcm (Gobs n) := by
  apply Nat.eq_of_factorization_eq (Gobs_pos _).ne'
    (Nat.lcm_ne_zero (Gobs_pos m).ne' (Gobs_pos n).ne')
  intro p
  rw [Gobs_factorization, PNat.lcm_coe,
    Nat.factorization_lcm m.pos.ne' n.pos.ne', Finsupp.sup_apply,
    Nat.factorization_lcm (Gobs_pos m).ne' (Gobs_pos n).ne', Finsupp.sup_apply,
    Gobs_factorization, Gobs_factorization, b_monotone.map_max]

private theorem Gobs_two_pow (k : Nat) :
    Gobs ((2 : ℕ+) ^ k) = 2 ^ b k := by
  apply Nat.eq_of_factorization_eq (Gobs_pos _).ne' (pow_pos (by decide) _).ne'
  intro p
  calc
    _ = b ((2 ^ k).factorization p) := Gobs_factorization _ p
    _ = _ := by
      simp only [Nat.factorization_pow, Nat.Prime.factorization (by decide : Nat.Prime 2)]
      by_cases hp : p = 2 <;> simp [hp, b_zero]

/-- The false alternative refuted by the multiplicative and associativity witnesses. -/
def goldenObservationMultiplicativeOrAssociativeAtWitness : Prop :=
  (∀ m n : PNat, Gobs (m * n) = Gobs m * Gobs n) ∨
  Gobs (Nat.toPNat (Gobs (2 * 2) * 4) (Nat.mul_pos (Gobs_pos _) (by decide))) =
    Gobs (Nat.toPNat (2 * Gobs (2 * 4)) (Nat.mul_pos (by decide) (Gobs_pos _)))

/-- The witness `2, 4` shows that golden observation is not multiplicative. -/
theorem Gobs_not_multiplicative :
    ¬ ∀ m n : PNat, Gobs (m * n) = Gobs m * Gobs n := by
  intro h
  have h24 := h (2 : ℕ+) (4 : ℕ+)
  have h2 : Gobs (2 : ℕ+) = 2 := by
    simpa only [pow_one, show b 1 = 1 by decide] using Gobs_two_pow 1
  have h4 : Gobs (4 : ℕ+) = 4 := by
    simpa only [show (2 : ℕ+) ^ 2 = 4 by decide, show b 2 = 2 by decide,
      show 2 ^ 2 = 4 by decide] using Gobs_two_pow 2
  have h8 : Gobs (8 : ℕ+) = 4 := by
    simpa only [show (2 : ℕ+) ^ 3 = 8 by decide, show b 3 = 2 by decide,
      show 2 ^ 2 = 4 by decide] using Gobs_two_pow 3
  rw [show (2 : ℕ+) * 4 = 8 by decide, h8, h2, h4] at h24
  norm_num at h24

/-- The fixed points `2`, `4`, and `16` witness failure of associativity for
the product obtained by observing ordinary multiplication. -/
theorem Gobs_product_not_associative_on_fixed_points :
    IsGolden (2 : ℕ+) ∧
    IsGolden (4 : ℕ+) ∧
    IsGolden (16 : ℕ+) ∧
    Gobs (Nat.toPNat (Gobs (2 * 2) * 4) (Nat.mul_pos (Gobs_pos _) (by decide))) = 16 ∧
    Gobs (Nat.toPNat (2 * Gobs (2 * 4)) (Nat.mul_pos (by decide) (Gobs_pos _))) = 4 ∧
    Gobs (Nat.toPNat (Gobs (2 * 2) * 4) (Nat.mul_pos (Gobs_pos _) (by decide))) ≠
      Gobs (Nat.toPNat (2 * Gobs (2 * 4)) (Nat.mul_pos (by decide) (Gobs_pos _))) := by
  have h2 : Gobs (2 : ℕ+) = 2 := by
    simpa only [pow_one, show b 1 = 1 by decide] using Gobs_two_pow 1
  have h4 : Gobs (4 : ℕ+) = 4 := by
    simpa only [show (2 : ℕ+) ^ 2 = 4 by decide, show b 2 = 2 by decide,
      show 2 ^ 2 = 4 by decide] using Gobs_two_pow 2
  have h8 : Gobs (8 : ℕ+) = 4 := by
    simpa only [show (2 : ℕ+) ^ 3 = 8 by decide, show b 3 = 2 by decide,
      show 2 ^ 2 = 4 by decide] using Gobs_two_pow 3
  have h16 : Gobs (16 : ℕ+) = 16 := by
    simpa only [show (2 : ℕ+) ^ 4 = 16 by decide, show b 4 = 4 by decide,
      show 2 ^ 4 = 16 by decide] using Gobs_two_pow 4
  have hleftArg :
      Nat.toPNat (Gobs (2 * 2) * 4) (Nat.mul_pos (Gobs_pos _) (by decide)) =
        (16 : ℕ+) := by
    apply PNat.eq
    change Gobs ((2 : ℕ+) * 2) * 4 = 16
    rw [show (2 : ℕ+) * 2 = 4 by decide, h4]
  have hrightArg :
      Nat.toPNat (2 * Gobs (2 * 4)) (Nat.mul_pos (by decide) (Gobs_pos _)) =
        (8 : ℕ+) := by
    apply PNat.eq
    change 2 * Gobs ((2 : ℕ+) * 4) = 8
    rw [show (2 : ℕ+) * 4 = 8 by decide, h8]
  have hleft :
      Gobs (Nat.toPNat (Gobs (2 * 2) * 4)
        (Nat.mul_pos (Gobs_pos _) (by decide))) = 16 := by
    rw [hleftArg, h16]
  have hright :
      Gobs (Nat.toPNat (2 * Gobs (2 * 4))
        (Nat.mul_pos (by decide) (Gobs_pos _))) = 4 := by
    rw [hrightArg, h8]
  refine ⟨(isGolden_iff_Gobs_fixed _).mpr h2, (isGolden_iff_Gobs_fixed _).mpr h4,
    (isGolden_iff_Gobs_fixed _).mpr h16, hleft, hright, ?_⟩
  omega

/-- Golden observation is neither multiplicative nor associative at the stated
fixed-point witness. -/
theorem Gobs_lattice_boundary_refutation :
    ¬ goldenObservationMultiplicativeOrAssociativeAtWitness := by
  intro h
  rcases h with hmul | hassoc
  · exact Gobs_not_multiplicative hmul
  · exact Gobs_product_not_associative_on_fixed_points.2.2.2.2.2 hassoc

#print axioms Gobs_gcd
#print axioms Gobs_lcm
#print axioms goldenObservationMultiplicativeOrAssociativeAtWitness
#print axioms Gobs_not_multiplicative
#print axioms Gobs_product_not_associative_on_fixed_points
#print axioms Gobs_lattice_boundary_refutation

end D5.S3.Arith.GoldenResource.GoldenObservationLattice
