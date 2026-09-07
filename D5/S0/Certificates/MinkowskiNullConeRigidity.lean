/- GID: D5/S0/Certificates/MinkowskiNullConeRigidity
   generality: G
   mirror-B: D5/B/S0/Certificates/MinkowskiNullConeRigidity
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Vanishing on the Minkowski null cone forces a real quadratic form to be a scalar multiple in every spatial dimension. -/

import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.QuadraticForm.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S0.Certificates.MinkowskiNullConeRigidity

/-- One real time coordinate and `d` Euclidean space coordinates. -/
abbrev Space (d : Nat) := Real × EuclideanSpace Real (Fin d)

/-- The quadratic form with signature `(1,d)`, positive on the time axis. -/
noncomputable def minkowski (d : Nat) : QuadraticForm Real (Space d) :=
  QuadraticMap.sq.comp (LinearMap.fst Real Real (EuclideanSpace Real (Fin d))) -
    (LinearMap.BilinMap.toQuadraticMap (innerₗ (EuclideanSpace Real (Fin d)))).comp
      (LinearMap.snd Real Real (EuclideanSpace Real (Fin d)))

private theorem minkowski_apply (d : Nat) (t : Real)
    (w : EuclideanSpace Real (Fin d)) : minkowski d (t, w) = t ^ 2 - ‖w‖ ^ 2 := by
  simp [minkowski, QuadraticMap.sq, pow_two]

private theorem quadratic_split {d : Nat} (S : QuadraticForm Real (Space d))
    (t : Real) (w : EuclideanSpace Real (Fin d)) :
    S (t, w) = t ^ 2 * S (1, 0) + S (0, w) +
      t * QuadraticMap.polar S (1, 0) (0, w) := by
  have hsplit : (t, w) = t • ((1, 0) : Space d) + (0, w) := by
    ext <;> simp
  rw [hsplit, QuadraticMap.map_add S, S.map_smul, S.polar_smul_left]
  simp only [smul_eq_mul, pow_two]

/-- Null values lock the spatial restriction and annihilate the mixed polar term. -/
theorem null_cone_spatial_rigidity {d : Nat} (S : QuadraticForm Real (Space d))
    (hnull : forall v, minkowski d v = 0 -> S v = 0)
    (w : EuclideanSpace Real (Fin d)) :
    S (0, w) = -S (1, 0) * ‖w‖ ^ 2 ∧
      QuadraticMap.polar S (1, 0) (0, w) = 0 := by
  have hp := hnull (‖w‖, w) (by rw [minkowski_apply]; ring)
  have hm := hnull (-‖w‖, w) (by rw [minkowski_apply]; ring)
  rw [quadratic_split] at hp hm
  have hspace : S (0, w) = -S (1, 0) * ‖w‖ ^ 2 := by
    nlinarith only [hp, hm]
  refine ⟨hspace, ?_⟩
  by_cases hw : w = 0
  · subst w
    exact S.polar_zero_right (1, 0)
  · have hprod : ‖w‖ * QuadraticMap.polar S (1, 0) (0, w) = 0 := by
      nlinarith only [hp, hm]
    exact (mul_eq_zero.mp hprod).resolve_left (norm_ne_zero_iff.mpr hw)

/-- Every real quadratic form vanishing on the full null cone is a scalar multiple
of the Minkowski form. No lower bound on the spatial dimension is needed. -/
theorem eq_smul_minkowski_of_null {d : Nat} (S : QuadraticForm Real (Space d))
    (hnull : forall v, minkowski d v = 0 -> S v = 0) :
    S = S (1, 0) • minkowski d := by
  apply QuadraticMap.ext
  rintro ⟨t, w⟩
  obtain ⟨hspace, hmixed⟩ := null_cone_spatial_rigidity S hnull w
  rw [quadratic_split, hspace, hmixed]
  change _ = S (1, 0) * minkowski d (t, w)
  rw [minkowski_apply]
  ring

/-- The proportionality factor exists, uniformly in the spatial dimension. -/
theorem exists_smul_minkowski_of_null {d : Nat} (S : QuadraticForm Real (Space d))
    (hnull : forall v, minkowski d v = 0 -> S v = 0) :
    exists f : Real, S = f • minkowski d :=
  ⟨S (1, 0), eq_smul_minkowski_of_null S hnull⟩

/-- In one spatial dimension there is no null-vanishing nonproportional quadratic form. -/
theorem no_one_space_dimension_counterexample :
    ¬ exists S : QuadraticForm Real (Space 1),
      (forall v, minkowski 1 v = 0 -> S v = 0) ∧
        (forall f : Real, S ≠ f • minkowski 1) := by
  rintro ⟨S, hnull, hnonproportional⟩
  exact hnonproportional (S (1, 0)) (eq_smul_minkowski_of_null S hnull)

example (d : Nat) : Space d := (1, 0)

example (d : Nat) : exists S : QuadraticForm Real (Space d),
    (forall v, minkowski d v = 0 -> S v = 0) ∧ S (1, 0) ≠ 0 := by
  refine ⟨minkowski d, fun _ h => h, ?_⟩
  simp [minkowski_apply]

#print axioms null_cone_spatial_rigidity
#print axioms eq_smul_minkowski_of_null
#print axioms exists_smul_minkowski_of_null
#print axioms no_one_space_dimension_counterexample

end D5.S0.Certificates.MinkowskiNullConeRigidity
