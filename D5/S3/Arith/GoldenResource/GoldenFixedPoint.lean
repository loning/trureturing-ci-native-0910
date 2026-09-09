/- GID: D5/S3/Arith/GoldenResource/GoldenFixedPoint
   generality: I
   mirror-B: D5/B/S3/Arith/GoldenResource/GoldenFixedPoint
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Fibonacci exponents characterize golden fixed points and greatest golden divisors. -/

import D5.S3.Arith.GoldenResource.GoldenDivisorLanguage

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S3.Arith.GoldenResource.GoldenFixedPoint

open D5.S3.Arith.GoldenResource.GoldenDivisorLanguage

/-- The fixed exponents are precisely one less than a Fibonacci number of index at least two. -/
theorem b_fixed_iff (a : Nat) : b a = a ↔ ∃ L, 2 ≤ L ∧ a + 1 = Nat.fib L := by
  constructor
  · intro h
    have hL : 2 ≤ Nat.greatestFib (a + 1) := Nat.le_greatestFib.mpr (by simp)
    have hpos : 1 ≤ Nat.fib (Nat.greatestFib (a + 1)) :=
      Nat.fib_pos.mpr (by omega)
    refine ⟨Nat.greatestFib (a + 1), hL, ?_⟩
    unfold b at h
    omega
  · rintro ⟨L, hL, h⟩
    unfold b
    rw [h, Nat.greatestFib_fib (by omega), ← h]
    omega

/-- A positive integer is golden when every prime exponent is a Fibonacci window endpoint. -/
def IsGolden (g : PNat) : Prop :=
  ∀ p, ∃ L, 2 ≤ L ∧ g.val.factorization p + 1 = Nat.fib L

/-- Golden integers are exactly the fixed points of integer observation. -/
theorem isGolden_iff_Gobs_fixed (g : PNat) : IsGolden g ↔ Gobs g = g := by
  constructor
  · intro h
    apply Nat.eq_of_factorization_eq (Gobs_pos g).ne' g.pos.ne'
    intro p
    rw [Gobs_factorization]
    exact (b_fixed_iff _).mpr (h p)
  · intro h p
    apply (b_fixed_iff _).mp
    rw [← Gobs_factorization, h]

/-- Every observation is a golden integer. -/
theorem Gobs_isGolden (n : PNat) : IsGolden ⟨Gobs n, Gobs_pos n⟩ :=
  (isGolden_iff_Gobs_fixed _).mpr (Gobs_idempotent n)

/-- Observation preserves divisibility. -/
theorem Gobs_dvd_of_dvd (n m : PNat) (h : n.val ∣ m.val) : Gobs n ∣ Gobs m := by
  apply (Nat.factorization_le_iff_dvd (Gobs_pos n).ne' (Gobs_pos m).ne').mp
  intro p
  rw [Gobs_factorization, Gobs_factorization]
  exact b_monotone ((Nat.factorization_le_iff_dvd n.pos.ne' m.pos.ne').mpr h p)

/-- The observed integer is the greatest golden divisor in the divisibility order. -/
theorem Gobs_greatest_golden_divisor (n : PNat) :
    Gobs n ∣ n.val ∧ IsGolden ⟨Gobs n, Gobs_pos n⟩ ∧
      ∀ g : PNat, IsGolden g → g.val ∣ n.val → g.val ∣ Gobs n := by
  refine ⟨Gobs_dvd n, Gobs_isGolden n, ?_⟩
  intro g hg hgn
  have h := Gobs_dvd_of_dvd g n hgn
  rwa [(isGolden_iff_Gobs_fixed g).mp hg] at h

#print axioms b_fixed_iff
#print axioms isGolden_iff_Gobs_fixed
#print axioms Gobs_isGolden
#print axioms Gobs_dvd_of_dvd
#print axioms Gobs_greatest_golden_divisor

end D5.S3.Arith.GoldenResource.GoldenFixedPoint
