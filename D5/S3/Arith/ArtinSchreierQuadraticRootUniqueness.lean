/- GID: D5/S3/Arith/ArtinSchreierQuadraticRootUniqueness
   generality: G
   mirror-B: D5/B/S3/Arith/ArtinSchreierQuadraticRootUniqueness
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: Equal-constant roots of one Artin-Schreier quadratic over F2 power series coincide. -/

import Mathlib.RingTheory.PowerSeries.Inverse
import Mathlib.Data.ZMod.Basic

set_option autoImplicit false
set_option relaxedAutoImplicit false

open PowerSeries

namespace D5.S3.Arith.ArtinSchreierQuadraticRootUniqueness

/-- Two roots of the same Artin--Schreier quadratic with equal constant coefficients coincide. -/
theorem quadratic_root_unique (f F G : PowerSeries (ZMod 2))
    (hF : F ^ 2 + F = f) (hG : G ^ 2 + G = f)
    (h0 : constantCoeff F = constantCoeff G) :
    F = G := by
  have hu : IsUnit (1 + F + G) := by
    rw [isUnit_iff_constantCoeff]
    convert isUnit_one
    rw [map_add, map_add, map_one, h0, add_assoc, CharTwo.add_self_eq_zero, add_zero]
  have he : (1 + F + G) * (F - G) = (1 + F + G) * 0 := by
    calc
      (1 + F + G) * (F - G) = (F ^ 2 + F) - (G ^ 2 + G) := by ring
      _ = 0 := by rw [hF, hG, sub_self]
      _ = (1 + F + G) * 0 := by ring
  exact sub_eq_zero.mp (hu.mul_left_cancel he)

example : Nonempty (PowerSeries (ZMod 2)) := ⟨0⟩

example : ∃ f F G : PowerSeries (ZMod 2),
    F ^ 2 + F = f ∧ G ^ 2 + G = f ∧ constantCoeff F = constantCoeff G := by
  exact ⟨0, 0, 0, by simp⟩

#print axioms quadratic_root_unique

end D5.S3.Arith.ArtinSchreierQuadraticRootUniqueness
