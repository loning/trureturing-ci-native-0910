/- GID: D5/S3/QuantumBounds/AffineEndpointPath
   generality: G
   mirror-B: D5/B/S3/QuantumBounds/AffineEndpointPath
   mirror-E: none(waiver:algebraically-proved)
   anchors: []
   utility: none
   digest: Finite complex paths with fixed endpoints are equivalent to compatible differences. -/

import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Data.Complex.Basic
import Mathlib.Tactic.Ring

/- Library-search audit trail (2026-09-07):
   1. D5: searched affine/path/equiv, difference/inverse, endpoint, forcing,
      and recurrence; read every public declaration in TargetVisibilityConditionCost,
      ReferenceFrameTax, ReferenceFrameTaxOptimal, RobertsonSchrodinger, and
      LagrangeGramIdentity. None supplies the finite forced endpoint correspondence.
      Visibility needs a measurement and a normal-equation certificate; the reference
      results concern real nearest-neighbour quadratic forms; Gram results concern norms.
   2. Pinned Mathlib v4.33.0, db584cd6d46c92f209a44c0f1c829460d327499d:
      read Algebra.LinearRecurrence (all public declarations), Algebra.Ring.GeomSum,
      and searched BigOperators/Fin and interval sums. LinearRecurrence.toInit concerns
      homogeneous infinite solutions, not arbitrary finite forcing and two endpoints.
      Exact component hits Finset.sum_insert, Finset.mul_sum, Finset.sum_congr,
      pow_succ', and Fin.induction are imported and applied below.
   3. Third-party ecosystem via NyxID/Tavily: queried "Lean4 formalization inhomogeneous
      linear recurrence explicit solution", "site:github.com Lean recurrence
      inhomogeneous", and "Lean4 affine recurrence inverse finite path". Returned
      material included recursive-definition documentation and Ripple's inhomogeneous
      ODE discussion, but no matching Lean declaration. GitHub code-search proxies
      returned HTTP 400 (credential error), not a negative search result.
      Result: not-found-in-searched-scope, not an exhaustive ecosystem claim.
   Preregistered witness unchanged: the reversible construction together with its
   coordinate computation laws directly produces the E-PATH conclusion (form 2).
   No norm/action bound or separate telescoping-sum result is claimed here. -/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S3.QuantumBounds.AffineEndpointPath

open scoped BigOperators

/-- Complex paths on `0,...,a+1` with their two prescribed endpoints. -/
def EndpointPath (a : ℕ) (ξ η : ℂ) :=
  {x : Fin (a + 2) → ℂ // x 0 = ξ ∧ x (Fin.last (a + 1)) = η}

/-- Differences on `0,...,a` satisfying the terminal compatibility equation. -/
def CompatibleDifference (a : ℕ) (r ξ η : ℂ) :=
  {v : Fin (a + 1) → ℂ //
    (∑ j, r ^ (a - j.val) * v j) = η - r ^ (a + 1) * ξ}

/-- The forward first-order difference, including both boundary edges. -/
noncomputable def pathDifference {a : ℕ} (r : ℂ) (x : Fin (a + 2) → ℂ)
    (j : Fin (a + 1)) : ℂ :=
  x j.succ - r * x j.castSucc

/-- The explicit forced solution. The finite sum contains exactly the indices `j < i`. -/
noncomputable def pathReconstruction {a : ℕ} (r ξ : ℂ) (v : Fin (a + 1) → ℂ)
    (i : Fin (a + 2)) : ℂ :=
  r ^ i.val * ξ + ∑ j : Fin (a + 1) with j.val < i.val,
    r ^ (i.val - 1 - j.val) * v j

private theorem reconstruction_zero {a : ℕ} (r ξ : ℂ) (v : Fin (a + 1) → ℂ) :
    pathReconstruction r ξ v 0 = ξ := by
  simp [pathReconstruction]

private theorem reconstruction_step {a : ℕ} (r ξ : ℂ) (v : Fin (a + 1) → ℂ)
    (j : Fin (a + 1)) :
    pathReconstruction r ξ v j.succ = r * pathReconstruction r ξ v j.castSucc + v j := by
  have hsplit :
      (Finset.univ.filter fun k : Fin (a + 1) => k.val < j.val + 1) =
        insert j (Finset.univ.filter fun k : Fin (a + 1) => k.val < j.val) := by
    ext k
    simp only [Finset.mem_filter, Finset.mem_univ, true_and, Finset.mem_insert, Fin.ext_iff]
    omega
  have hnot : j ∉ (Finset.univ.filter fun k : Fin (a + 1) => k.val < j.val) := by
    simp
  simp only [pathReconstruction, Fin.val_succ, Fin.val_castSucc]
  rw [hsplit, Finset.sum_insert hnot]
  simp only [Nat.add_sub_cancel, Nat.sub_self, pow_zero, one_mul]
  have hsum :
      (∑ k : Fin (a + 1) with k.val < j.val, r ^ (j.val - k.val) * v k) =
        r * ∑ k : Fin (a + 1) with k.val < j.val,
          r ^ (j.val - 1 - k.val) * v k := by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro k hk
    have hklt := (Finset.mem_filter.mp hk).2
    rw [show j.val - k.val = (j.val - 1 - k.val) + 1 by omega, pow_succ']
    exact mul_assoc _ _ _
  rw [hsum, pow_succ']
  ring

private theorem reconstruction_difference {a : ℕ} (r : ℂ) (x : Fin (a + 2) → ℂ) :
    pathReconstruction r (x 0) (pathDifference r x) = x := by
  funext i
  induction i using Fin.induction with
  | zero => exact reconstruction_zero r (x 0) (pathDifference r x)
  | succ j ih =>
    rw [reconstruction_step, ih, pathDifference]
    ring

private theorem difference_reconstruction {a : ℕ} (r ξ : ℂ) (v : Fin (a + 1) → ℂ) :
    pathDifference r (pathReconstruction r ξ v) = v := by
  funext j
  rw [pathDifference, reconstruction_step]
  ring

private theorem reconstruction_last {a : ℕ} (r ξ : ℂ) (v : Fin (a + 1) → ℂ) :
    pathReconstruction r ξ v (Fin.last (a + 1)) =
      r ^ (a + 1) * ξ + ∑ j, r ^ (a - j.val) * v j := by
  simp [pathReconstruction]

/-- E-PATH as an actual equivalence. It works for every complex multiplier, including zero;
in particular it applies to a real multiplier in `(0,1)` after coercion to `ℂ`. -/
noncomputable def affineEndpointPathEquiv (a : ℕ) (r ξ η : ℂ) :
    EndpointPath a ξ η ≃ CompatibleDifference a r ξ η where
  toFun x := ⟨pathDifference r x.val, by
    have h := congrFun (reconstruction_difference r x.val) (Fin.last (a + 1))
    rw [reconstruction_last, x.property.1, x.property.2] at h
    exact eq_sub_iff_add_eq.mpr (by simpa [add_comm] using h)⟩
  invFun v := ⟨pathReconstruction r ξ v.val,
    reconstruction_zero r ξ v.val, by
      rw [reconstruction_last, v.property]
      ring⟩
  left_inv x := by
    apply Subtype.ext
    change pathReconstruction r ξ (pathDifference r x.val) = x.val
    simpa only [x.property.1] using reconstruction_difference r x.val
  right_inv v := by
    apply Subtype.ext
    exact difference_reconstruction r ξ v.val

/-- The equivalence's forward map is exactly the requested difference at each edge. -/
theorem affine_endpoint_path_equiv_apply (a : ℕ) (r ξ η : ℂ)
    (x : EndpointPath a ξ η) (j : Fin (a + 1)) :
    (affineEndpointPathEquiv a r ξ η x).val j = x.val j.succ - r * x.val j.castSucc :=
  rfl

/-- The inverse has the explicit prefix-sum computation law at every vertex. -/
theorem affine_endpoint_path_equiv_symm_apply (a : ℕ) (r ξ η : ℂ)
    (v : CompatibleDifference a r ξ η) (i : Fin (a + 2)) :
    ((affineEndpointPathEquiv a r ξ η).symm v).val i =
      r ^ i.val * ξ + ∑ j : Fin (a + 1) with j.val < i.val,
        r ^ (i.val - 1 - j.val) * v.val j :=
  rfl

/-- The complete E-PATH conclusion: a bijection with both specified coordinate maps. -/
theorem affine_endpoint_path_equivalence (a : ℕ) (r ξ η : ℂ) :
    ∃ e : EndpointPath a ξ η ≃ CompatibleDifference a r ξ η,
      (∀ x j, (e x).val j = x.val j.succ - r * x.val j.castSucc) ∧
      (∀ v i, (e.symm v).val i =
        r ^ i.val * ξ + ∑ j : Fin (a + 1) with j.val < i.val,
          r ^ (i.val - 1 - j.val) * v.val j) :=
  ⟨affineEndpointPathEquiv a r ξ η, affine_endpoint_path_equiv_apply a r ξ η,
    affine_endpoint_path_equiv_symm_apply a r ξ η⟩

#print axioms affineEndpointPathEquiv
#print axioms affine_endpoint_path_equiv_apply
#print axioms affine_endpoint_path_equiv_symm_apply
#print axioms affine_endpoint_path_equivalence

end D5.S3.QuantumBounds.AffineEndpointPath
