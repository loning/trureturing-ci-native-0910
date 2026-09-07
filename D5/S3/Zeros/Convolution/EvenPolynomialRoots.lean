/- GID: D5/S3/Zeros/Convolution/EvenPolynomialRoots
   generality: G
   mirror-B: D5/B/S3/Zeros/Convolution/EvenPolynomialRoots
   mirror-E: none(waiver:symbolic-root-geometry)
   anchors: []
   utility: none
   digest: Real splitting after evenization is equivalent to nonnegative real roots. -/

import Mathlib.Algebra.Polynomial.Expand
import Mathlib.Algebra.Polynomial.Splits
import Mathlib.Analysis.Complex.Polynomial.Basic
import Mathlib.Analysis.Real.Sqrt
import Mathlib.Tactic

/-!
Root-geometry bridge for arXiv:2502.00254v2, Corollary 3.14.
The named consumer is `RectangularHalfConvolution.preserves_nonnegative_roots`.
Mathlib owns `expand`, its coefficients, monicity and degree, and the splitting
and root-range APIs used here. No coefficient-evenization lemma is re-proved.
Repository and pinned Mathlib searches found no splitting/nonnegative-root
equivalence for expansion by two. The upper direction factors each quadratic;
the lower direction lifts a complex root to a square root and uses real splitting.
Zero and repeated roots are included. Nonzeroness is needed only for descent.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

namespace D5.S3.Zeros.Convolution.EvenPolynomialRoots

open Polynomial

private theorem splits_quadratic {a : ℝ} (ha : 0 ≤ a) :
    (X^2 - C a : ℝ[X]).Splits := by
  have hfactor : (X^2 - C a : ℝ[X]) =
      (X - C (Real.sqrt a)) * (X - C (-Real.sqrt a)) := by
    have hs : (C (Real.sqrt a) : ℝ[X])^2 = C a := by
      rw [← map_pow, Real.sq_sqrt ha]
    rw [map_neg, ← hs]
    ring
  rw [hfactor]
  exact (Splits.X_sub_C _).mul (Splits.X_sub_C _)

/-- Nonnegative real roots give real splitting after substitution of `X^2`. -/
theorem splits_expand_two {p : ℝ[X]} (hp : p.Splits)
    (hn : ∀ x : ℝ, p.IsRoot x → 0 ≤ x) : (expand ℝ 2 p).Splits := by
  by_cases hp0 : p = 0
  · simp [hp0]
  conv => arg 1; rw [hp.eq_prod_roots]
  rw [map_mul, expand_C, map_multiset_prod, Multiset.map_map]
  apply Splits.C_mul
  apply Splits.multisetProd
  intro f hf
  obtain ⟨a, ha, rfl⟩ := Multiset.mem_map.mp hf
  simpa using splits_quadratic (hn a ((mem_roots hp0).mp ha))

private theorem root_is_real_square {p : ℝ[X]} (hp0 : p ≠ 0)
    (hp : (expand ℝ 2 p).Splits) {z : ℂ}
    (hz : (p.map Complex.ofRealHom).IsRoot z) :
    ∃ a : ℝ, (a : ℂ)^2 = z := by
  obtain ⟨w, hw⟩ := IsAlgClosed.exists_pow_nat_eq z (by norm_num : 0 < (2 : ℕ))
  have hwroot : ((expand ℝ 2 p).map Complex.ofRealHom).IsRoot w := by
    simpa only [IsRoot.def, map_expand, expand_eval, hw] using hz
  obtain ⟨a, ha⟩ := hp.mem_range_of_isRoot ((expand_ne_zero (by norm_num)).mpr hp0) hwroot
  exact ⟨a, by rw [show (a : ℂ) = w from ha]; exact hw⟩

/-- A real-split nonzero evenization forces the original roots to be real and nonnegative. -/
theorem nonnegative_roots_of_splits_expand_two {p : ℝ[X]} (hp0 : p ≠ 0)
    (hp : (expand ℝ 2 p).Splits) :
    p.Splits ∧ ∀ x : ℝ, p.IsRoot x → 0 ≤ x := by
  constructor
  · apply Splits.of_splits_map Complex.ofRealHom (IsAlgClosed.splits _)
    intro z hz
    obtain ⟨a, ha⟩ := root_is_real_square hp0 hp
      ((mem_roots (map_ne_zero hp0)).mp hz)
    exact ⟨a^2, by simpa using ha⟩
  · intro x hx
    have hx' : (p.map Complex.ofRealHom).IsRoot (x : ℂ) := hx.map
    obtain ⟨a, ha⟩ := root_is_real_square hp0 hp hx'
    have heq : a^2 = x := Complex.ofReal_injective (by simpa using ha)
    exact heq ▸ sq_nonneg a

#print axioms splits_expand_two
#print axioms nonnegative_roots_of_splits_expand_two

end D5.S3.Zeros.Convolution.EvenPolynomialRoots
