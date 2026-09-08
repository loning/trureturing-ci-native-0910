/- GID: D5/S3/Arith/GoldenResource/GoldenFixedPoint
   generality: G
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

#guard Nat.greatestFib 0 = 0
#guard Nat.greatestFib 1 = 2
#guard Nat.fib 1 = 1
#guard Nat.fib 2 = 1

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

#print axioms b_fixed_iff

end D5.S3.Arith.GoldenResource.GoldenFixedPoint
