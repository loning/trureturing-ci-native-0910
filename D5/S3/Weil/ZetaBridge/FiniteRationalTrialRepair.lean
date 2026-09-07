/- GID: D5/S3/Weil/ZetaBridge/FiniteRationalTrialRepair
   generality: I
   mirror-B: D5/B/S3/Weil/ZetaBridge/FiniteRationalTrialRepair
   mirror-E: none(waiver:exact-rational-projection-refinement)
   anchors: []
   digest: Exact rational-complex trial repair refines Mathlib's orthogonal projection and preserves finite support. -/

import D5.S3.Weil.ZetaBridge.WeilOrthogonalTrialPrecision
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-!
Rational pairs are just a storage representation for real and imaginary
coordinates. No new complex field or inner product is introduced. The three
computational definitions below perform only exact rational operations and
integer support tests. The semantic theorem identifies a successful output
with the existing `orthogonalTrial` owner and hence Mathlib's projection.
The concurrent owner at ea58c3d808f19f82792e3343aec9726ba2dafabe is
imported rather than duplicating its projection or moment-transport proofs.
The candidate need not be normalized. A zero candidate on the selected support
is rejected. A parallel trial may legitimately project to zero.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S3.Weil.ZetaBridge.FiniteRationalTrialRepair

open D5.S3.Weil.ZetaBridge.WeilOrthogonalTrialPrecision
open scoped BigOperators ComplexConjugate ComplexInnerProductSpace

/-- Squared Euclidean size of the candidate, computed exactly in rationals. -/
def rationalGram (S : Finset ℤ) (k : ℤ → ℚ × ℚ) : ℚ :=
  ∑ n ∈ S, ((k n).1 ^ 2 + (k n).2 ^ 2)

/-- The exact complex projection coefficient, stored as two rationals.
It is used by `repairTrial` only after checking the Gram denominator. -/
def rationalCorrection (S : Finset ℤ) (k v : ℤ → ℚ × ℚ) : ℚ × ℚ :=
  ((∑ n ∈ S, ((k n).1 * (v n).1 + (k n).2 * (v n).2)) / rationalGram S k,
   (∑ n ∈ S, ((k n).1 * (v n).2 - (k n).2 * (v n).1)) / rationalGram S k)

/-- Executable exact repair with explicit zero-candidate rejection.
Values outside S are zero, regardless of the input functions there. -/
def repairTrial (S : Finset ℤ) (k v : ℤ → ℚ × ℚ) : Option (ℤ → ℚ × ℚ) :=
  if rationalGram S k = 0 then none else
    let b := rationalCorrection S k v
    some fun n => if n ∈ S then
      ((v n).1 - b.1 * (k n).1 + b.2 * (k n).2,
       (v n).2 - b.1 * (k n).2 - b.2 * (k n).1) else (0, 0)

/-- Exact interpretation of a pair, with no floating-point conversion. -/
noncomputable def decode (z : ℚ × ℚ) : ℂ := ((z.1 : ℝ) : ℂ) + ((z.2 : ℝ) : ℂ) * Complex.I

/-- The standard Mathlib Euclidean vector restricted to S. -/
noncomputable def decodedVector (S : Finset ℤ) (v : ℤ → ℚ × ℚ) :
    EuclideanSpace ℂ S := WithLp.toLp 2 (fun n : S => decode (v n))

private theorem vector_inner (S : Finset ℤ) (k v : ℤ → ℚ × ℚ) :
    ⟪decodedVector S k, decodedVector S v⟫_ℂ =
      ∑ n ∈ S, conj (decode (k n)) * decode (v n) := by
  simp [decodedVector, PiLp.inner_apply, RCLike.inner_apply, Finset.sum_coe_sort, mul_comm]

private theorem overlap_coordinates (S : Finset ℤ) (k v : ℤ → ℚ × ℚ) :
    ⟪decodedVector S k, decodedVector S v⟫_ℂ =
      ((∑ n ∈ S, ((k n).1 * (v n).1 + (k n).2 * (v n).2) : ℚ) : ℂ) +
      ((∑ n ∈ S, ((k n).1 * (v n).2 - (k n).2 * (v n).1) : ℚ) : ℂ) * Complex.I := by
  rw [vector_inner]
  push_cast
  rw [← Finset.sum_mul, ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro n _
  apply Complex.ext <;> simp [decode, Complex.mul_re, Complex.mul_im] <;> ring

private theorem gram_inner (S : Finset ℤ) (k : ℤ → ℚ × ℚ) :
    ⟪decodedVector S k, decodedVector S k⟫_ℂ = (rationalGram S k : ℂ) := by
  rw [overlap_coordinates]
  simp [rationalGram, pow_two, mul_comm]

private theorem correction_semantics (S : Finset ℤ) (k v : ℤ → ℚ × ℚ) :
    decode (rationalCorrection S k v) =
      ⟪decodedVector S k, decodedVector S v⟫_ℂ / (rationalGram S k : ℂ) := by
  rw [overlap_coordinates]
  unfold decode rationalCorrection
  push_cast
  ring

private theorem gram_zero_iff (S : Finset ℤ) (k : ℤ → ℚ × ℚ) :
    rationalGram S k = 0 ↔ ∀ n ∈ S, k n = (0, 0) := by
  constructor
  · intro hz n hn
    have hle : (k n).1 ^ 2 + (k n).2 ^ 2 ≤ rationalGram S k :=
      Finset.single_le_sum (fun j _ => add_nonneg (sq_nonneg _) (sq_nonneg _)) hn
    rw [hz] at hle
    have hr : (k n).1 = 0 := by nlinarith [sq_nonneg (k n).2]
    have hi : (k n).2 = 0 := by nlinarith [sq_nonneg (k n).1]
    exact Prod.ext hr hi
  · intro h
    apply Finset.sum_eq_zero
    intro n hn
    simp [h n hn]

/-- The rational algorithm succeeds exactly when the candidate has a nonzero
coordinate on S. Empty support and a zero restricted candidate are rejected. -/
theorem repair_defined_iff (S : Finset ℤ) (k v : ℤ → ℚ × ℚ) :
    (repairTrial S k v).isSome = true ↔ ∃ n ∈ S, k n ≠ (0, 0) := by
  classical
  constructor
  · intro hs
    by_contra hnone
    have hz : rationalGram S k = 0 := by
      apply (gram_zero_iff S k).mpr
      intro n hn
      by_contra hne
      exact hnone ⟨n, hn, hne⟩
    simp [repairTrial, hz] at hs
  · rintro ⟨n, hn, hne⟩
    have hg : rationalGram S k ≠ 0 := by
      intro hz
      exact hne ((gram_zero_iff S k).mp hz n hn)
    simp [repairTrial, hg]

/-- A successful output is supported on S and decodes to the exact algebraic
repair there. The same rational correction is used at every coordinate. -/
theorem repair_coordinates (S : Finset ℤ) (k v t : ℤ → ℚ × ℚ)
    (h : repairTrial S k v = some t) :
    (∀ n, n ∉ S → t n = (0, 0)) ∧
      ∀ n ∈ S, decode (t n) = decode (v n) -
        decode (rationalCorrection S k v) * decode (k n) := by
  unfold repairTrial at h
  split_ifs at h with hg
  · cases h
  · have ht := Option.some.inj h
    subst t
    constructor
    · intro n hn
      simp [hn]
    · intro n hn
      simp only [if_pos hn]
      apply Complex.ext <;> simp [decode, Complex.mul_re, Complex.mul_im] <;> ring

/-- The exact rational output is the SAME trial as the existing analytic
owner. This is an implementation-refinement theorem; the standard projection
and its mathematical formula are not independently reconstructed. -/
theorem repair_eq_existing_trial (S : Finset ℤ) (k v t : ℤ → ℚ × ℚ)
    (h : repairTrial S k v = some t) :
    (fun n => decode (t n)) = orthogonalTrial S
      (fun n => decode (k n)) (fun n => decode (v n)) := by
  have hb : decode (rationalCorrection S k v) =
      trialCorrection S (fun n => decode (k n)) (fun n => decode (v n)) := by
    unfold trialCorrection
    rw [← vector_inner S k v, ← vector_inner S k k, gram_inner]
    exact correction_semantics S k v
  funext n
  by_cases hn : n ∈ S
  · rw [orthogonal_trial_apply S (fun j => decode (k j)) (fun j => decode (v j)) hn]
    simpa only [hb] using (repair_coordinates S k v t h).2 n hn
  · rw [(repair_coordinates S k v t h).1 n hn]
    simp [decode, orthogonalTrial, hn]

/-- The previous refinement exposes the existing Mathlib projection in the
standard Euclidean carrier. No square-root normalization is performed. -/
theorem repair_eq_starProjection (S : Finset ℤ) (k v t : ℤ → ℚ × ℚ)
    (h : repairTrial S k v = some t) :
    decodedVector S t = (ℂ ∙ decodedVector S k)ᗮ.starProjection (decodedVector S v) := by
  ext n : 1
  have hx := congrFun (repair_eq_existing_trial S k v t h) n
  simpa only [orthogonalTrial, dif_pos n.property] using hx

/-- Orthogonality is inherited from the existing analytic owner, and
Euclidean contraction from Mathlib. Neither l1 mass nor a boundary moment
is asserted to contract. -/
theorem repair_orthogonal_and_norm_le (S : Finset ℤ) (k v t : ℤ → ℚ × ℚ)
    (h : repairTrial S k v = some t) :
    (∑ n ∈ S, conj (decode (k n)) * decode (t n)) = 0 ∧
      ‖decodedVector S t‖ ≤ ‖decodedVector S v‖ := by
  constructor
  · have ho := (orthogonal_trial_constraints S
      (fun n => decode (k n)) (fun n => decode (v n))).2
    rw [← repair_eq_existing_trial S k v t h] at ho
    exact ho
  · rw [repair_eq_starProjection S k v t h]
    exact Submodule.norm_starProjection_apply_le _ _

/-- Any known isometric synthesis transports the exact orthogonality to its
actual Hilbert-space image. It does not construct an arithmetic Fourier basis. -/
theorem repair_isometric_orthogonality {H : Type*} [NormedAddCommGroup H]
    [InnerProductSpace ℂ H] (S : Finset ℤ) (k v t : ℤ → ℚ × ℚ)
    (h : repairTrial S k v = some t) (J : EuclideanSpace ℂ S →ₗᵢ[ℂ] H) :
    ⟪J (decodedVector S k), J (decodedVector S t)⟫_ℂ = 0 := by
  rw [J.inner_map_map, vector_inner]
  exact (repair_orthogonal_and_norm_le S k v t h).1

-- These are pure exact arithmetic examples; they are not spectral certificates.
example : (repairTrial {0, 1} (fun _ => ((1 : ℚ), (0 : ℚ)))
    (fun n => if n = 0 then ((3 : ℚ), (1 : ℚ)) else (4, -1))).map
      (fun t => t 0) = some ((-1 / 2 : ℚ), (1 : ℚ)) := by
  norm_num [repairTrial, rationalGram, rationalCorrection]

example : repairTrial ∅ (fun _ => ((1 : ℚ), (0 : ℚ)))
    (fun _ => ((7 : ℚ), (2 : ℚ))) = none := by
  norm_num [repairTrial, rationalGram]

#print axioms repair_eq_existing_trial
#print axioms repair_eq_starProjection
#print axioms repair_orthogonal_and_norm_le

end D5.S3.Weil.ZetaBridge.FiniteRationalTrialRepair
