import Mathlib.Algebra.Polynomial.Roots
import Mathlib.Analysis.SpecialFunctions.Pow.Continuity
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.Topology.MetricSpace.HausdorffDistance
import Mathlib.Tactic

/- Probe only: all analytic inputs are explicit. No actual zeta measure is defined. -/
noncomputable section

open Polynomial Filter MeasureTheory
open scoped BigOperators Topology

namespace HyperContractionProbe0909

def trial (s : Finset ℂ) (n : ℕ) : ℂ[X] :=
  (∏ a ∈ s, (X - C a)) * (X - C 1) ^ (n - s.card)

theorem trial_monic (s : Finset ℂ) (n : ℕ) : (trial s n).Monic := by
  exact (monic_prod_X_sub_C id s).mul ((monic_X_sub_C (1 : ℂ)).pow _)

theorem trial_degree (s : Finset ℂ) (n : ℕ) (hn : s.card ≤ n) :
    (trial s n).natDegree = n := by
  rw [trial, (monic_prod_X_sub_C id s).natDegree_mul
    ((monic_X_sub_C (1 : ℂ)).pow _)]
  rw [natDegree_prod_of_monic (fun a _ => monic_X_sub_C a)]
  simp only [natDegree_X_sub_C, Finset.sum_const, smul_eq_mul, mul_one,
    Polynomial.natDegree_pow]
  omega

theorem trial_zero (s : Finset ℂ) (n : ℕ) (a : ℂ) (ha : a ∈ s) :
    (trial s n).eval a = 0 := by
  simp only [trial, eval_mul, eval_prod, eval_sub, eval_X, eval_C, eval_pow]
  rw [Finset.prod_eq_zero ha (sub_self a), zero_mul]

theorem trial_bound (s : Finset ℂ) (n : ℕ) (z : ℂ) (r : ℝ)
    (hz : ‖z‖ = 1) (hs : ∀ a ∈ s, ‖a‖ = 1) (hr : ‖z - 1‖ ≤ r) :
    ‖(trial s n).eval z‖ ^ 2 ≤ 4 ^ s.card * r ^ (2 * (n - s.card)) := by
  have hprod : (∏ a ∈ s, ‖z - a‖) ≤ (2 : ℝ) ^ s.card := by
    have hfactor : ∀ a ∈ s, ‖z - a‖ ≤ (2 : ℝ) := by
      intro a ha
      have h := norm_sub_le z a
      rw [hz, hs a ha] at h
      norm_num at h ⊢
      exact h
    simpa only [Finset.prod_const] using
      (Finset.prod_le_prod (fun a _ => norm_nonneg (z - a)) hfactor)
  have hnorm : ‖(trial s n).eval z‖ ≤ 2 ^ s.card * r ^ (n - s.card) := by
    simp only [trial, eval_mul, eval_prod, eval_sub, eval_X, eval_C,
      eval_pow, norm_mul, norm_pow, norm_prod]
    exact mul_le_mul hprod (pow_le_pow_left₀ (norm_nonneg _) hr _)
      (pow_nonneg (norm_nonneg _) _) (pow_nonneg (by norm_num) _)
  have hsq := pow_le_pow_left₀ (norm_nonneg ((trial s n).eval z)) hnorm 2
  calc
    ‖(trial s n).eval z‖ ^ 2 ≤ (2 ^ s.card * r ^ (n - s.card)) ^ 2 := hsq
    _ = 4 ^ s.card * r ^ (2 * (n - s.card)) := by
      rw [mul_pow, ← pow_mul, Nat.mul_comm s.card 2, pow_mul]
      norm_num
      rw [← pow_mul, Nat.mul_comm]

theorem minimum_le_trial {A : Type*} (F : A → ℝ) (h : ℝ)
    (hmin : IsLeast (Set.range F) h) (a : A) : h ≤ F a :=
  hmin.2 ⟨a, rfl⟩

theorem minimum_pos_of_attained {A : Type*} (F : A → ℝ) (h : ℝ)
    (hmin : IsLeast (Set.range F) h) (hF : ∀ a, 0 < F a) : 0 < h := by
  obtain ⟨a, rfl⟩ := hmin.1
  exact hF a

theorem probability_integral_bound {A : Type*} [MeasurableSpace A]
    (mu : Measure A) [IsProbabilityMeasure mu] (f : A → ℝ) (B : ℝ)
    (hf : Integrable f mu) (hB : ∀ᵐ x ∂mu, f x ≤ B) :
    (∫ x, f x ∂mu) ≤ B := by
  simpa using integral_mono_ae hf (integrable_const B) hB

theorem constant_nth_root (A : ℝ) (hA : 0 < A) :
    Tendsto (fun n : ℕ => A ^ (1 / (n : ℝ))) atTop (𝓝 1) := by
  simpa using (tendsto_const_nhds (x := A)).rpow
    (tendsto_one_div_atTop_nhds_zero_nat (𝕜 := ℝ)) (Or.inl (ne_of_gt hA))

theorem normalized_bound_limit (r : ℝ) (hr : 0 < r) (K : ℕ) :
    Tendsto (fun n : ℕ => ((4 : ℝ) ^ K) ^ (1 / (n : ℝ)) *
      r ^ (2 - (2 * (K : ℝ)) / (n : ℝ))) atTop (𝓝 (r ^ 2)) := by
  have hfirst := constant_nth_root ((4 : ℝ) ^ K) (pow_pos (by norm_num) _)
  have hexponent : Tendsto (fun n : ℕ => 2 - (2 * (K : ℝ)) / (n : ℝ))
      atTop (𝓝 (2 : ℝ)) := by
    simpa using tendsto_const_nhds.sub
      (tendsto_const_div_atTop_nhds_zero_nat (2 * (K : ℝ)))
  simpa using hfirst.mul ((tendsto_const_nhds (x := r)).rpow hexponent
    (Or.inl (ne_of_gt hr)))

theorem positive_distance {A : Type*} [MetricSpace A] (S : Set A)
    (hS : IsClosed S) (hne : S.Nonempty) (x : A) (hx : x ∉ S) :
    0 < Metric.infDist x S :=
  (hS.notMem_iff_infDist_pos hne).mp hx

theorem spectral_distance_tendsto (rho : ℕ → ℂ)
    (h : Tendsto (fun n => ‖rho n‖) atTop atTop) :
    Tendsto (fun n => ‖(1 - (rho n)⁻¹) - 1‖) atTop (𝓝 0) := by
  simpa only [sub_sub_cancel_left, norm_neg, norm_inv] using
    tendsto_inv_atTop_zero.comp h

#print axioms trial_bound
#print axioms normalized_bound_limit

end HyperContractionProbe0909
