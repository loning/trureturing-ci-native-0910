/- GID: D5/S3/Weil/ZetaBridge/WeilArithmeticResidualTail
   generality: I
   mirror-B: D5/B/S3/Weil/ZetaBridge/WeilArithmeticResidualTail
   mirror-E: none(waiver:analytic-all-mode-residual-bound)
   anchors: []
   digest: Two exact boundary moments cancel the arithmetic first jet and certify the full two-sided squared residual tail. -/

import D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingJet
import D5.S3.Weil.ZetaBridge.WeilEvenFourierObservationTail
import Mathlib.LinearAlgebra.FiniteDimensional.Basic
import Mathlib.LinearAlgebra.Dimension.Constructions

/-!
This file uses the existing arithmetic boundary symbol and divided-difference
column, including its prime, pole and infinite Gamma contributions. It proves
an all-exterior-mode squared residual bound. There is no terminal tail cutoff.

For finite v, impose sum v=0 and sum s_n*v_n=0 on the dual TRIAL only. This
annihilates the complete first jet, before any norms are taken. For the even
readout coefficient eta/(m^2-w^2), the resulting residual is O(m^-2), with
squared tail at most 2 Q^2/(3 M^3). Both exterior signs are included.

The theorem is about the explicitly defined arithmetic coefficient column.
Its identification with the canonical Weil operator, the Hilbert-basis
realization of the even readout, and admissibility in the operator domain
are separate obligations. No constraint is imposed on the true ground mode.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false
noncomputable section

namespace D5.S3.Weil.ZetaBridge.WeilArithmeticResidualTail

open D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingJet
open D5.S3.Weil.ZetaBridge.WeilEvenFourierObservationTail
open scoped BigOperators ComplexConjugate

/-- The first arithmetic jet retains its two signed complex moments. This
identity also holds at m=0 with the field's total inverse convention; all
exterior estimates below separately require positive frequency separation. -/
theorem first_jet_moment_identity (c : ℕ) (S : Finset ℤ) (v : ℤ → ℂ) (m : ℤ) :
    couplingFirstJet c S v m =
      ((∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * v n) -
        (arithmeticBoundarySymbol c m : ℂ) * ∑ n ∈ S, v n) /
          ((Real.pi * (m : ℝ) : ℝ) : ℂ) := by
  unfold couplingFirstJet
  rw [Finset.mul_sum, ← Finset.sum_sub_distrib, ← Finset.sum_div]
  apply Finset.sum_congr rfl
  intro n _
  push_cast
  ring

/-- The two boundary moment constraints annihilate the first jet exactly. -/
theorem first_jet_eq_zero_of_moments (c : ℕ) (S : Finset ℤ) (v : ℤ → ℂ)
    (hzero : ∑ n ∈ S, v n = 0)
    (hsymbol : ∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * v n = 0) (m : ℤ) :
    couplingFirstJet c S v m = 0 := by
  rw [first_jet_moment_identity, hzero, hsymbol]
  simp

private theorem boundary_budget_nonneg {c : ℕ} (hc : 2 ≤ c) :
    0 ≤ arithmeticBoundaryBudget c :=
  (abs_nonneg (arithmeticBoundarySymbol c 0)).trans
    (arithmetic_boundary_symbol_bound hc 0).2

/-- The cancelled column has an inverse-square pointwise bound at every
exterior integer. The arithmetic envelope is the previously proved one. -/
theorem cancelled_arithmetic_column_bound {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v : ℤ → ℂ) {N : ℝ} (hN : 0 ≤ N)
    (hS : ∀ n ∈ S, |(n : ℝ)| ≤ N)
    (hzero : ∑ n ∈ S, v n = 0)
    (hsymbol : ∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * v n = 0)
    {m : ℤ} (hm : 0 < |(m : ℝ)|) (hsep : 2 * N ≤ |(m : ℝ)|) :
    ‖couplingColumn c S v m‖ ≤
      (4 * arithmeticBoundaryBudget c * N / Real.pi * ∑ n ∈ S, ‖v n‖) /
        |(m : ℝ)| ^ 2 := by
  have hB := boundary_budget_nonneg hc
  have hgap : 0 < |(m : ℝ)| - N := by linarith
  have h := arithmetic_coupling_first_jet_error hc S v hN hS
    (show N < |(m : ℝ)| by linarith)
  rw [first_jet_eq_zero_of_moments c S v hzero hsymbol m, sub_zero] at h
  have hden : |(m : ℝ)| ^ 2 ≤ 2 * |(m : ℝ)| * (|(m : ℝ)| - N) := by
    nlinarith [mul_nonneg hm.le (sub_nonneg.mpr hsep)]
  have hfrac : 2 * arithmeticBoundaryBudget c * N /
      (Real.pi * |(m : ℝ)| * (|(m : ℝ)| - N)) ≤
      4 * arithmeticBoundaryBudget c * N / (Real.pi * |(m : ℝ)| ^ 2) := by
    apply (div_le_div_iff₀ (by positivity) (by positivity)).mpr
    have ht := mul_le_mul_of_nonneg_left hden
      (show 0 ≤ 2 * arithmeticBoundaryBudget c * N * Real.pi by positivity)
    nlinarith [ht]
  have hsum : 0 ≤ ∑ n ∈ S, ‖v n‖ := Finset.sum_nonneg fun _ _ => norm_nonneg _
  calc
    _ ≤ _ := h
    _ ≤ (4 * arithmeticBoundaryBudget c * N / (Real.pi * |(m : ℝ)| ^ 2)) *
        ∑ n ∈ S, ‖v n‖ := mul_le_mul_of_nonneg_right hfrac hsum
    _ = _ := by ring

/-- A signed exterior integer. The two signs parameterize m=M+j+1 and its
negative; the even readout has the same squared denominator on both sides. -/
def exteriorMode (M j : ℕ) (negative : Bool) : ℤ :=
  if negative then -((M : ℤ) + (j : ℤ) + 1) else (M : ℤ) + (j : ℤ) + 1

/-- The complete residual coefficient, formed before taking its norm.
The numerator eta includes the physical even-readout prefactor when applied
to that readout. No value at a removable finite-frequency pole is used. -/
def arithmeticResidualTail (c : ℕ) (S : Finset ℤ) (v : ℤ → ℂ)
    (eta w : ℂ) (M : ℕ) (negative : Bool) (j : ℕ) : ℂ :=
  eta / ((((M : ℝ) + (j : ℝ) + 1 : ℝ) : ℂ) ^ 2 - w ^ 2) -
    couplingColumn c S v (exteriorMode M j negative)

/-- Explicit amplitude of the inverse-square residual estimate. -/
def residualTailBudget (c : ℕ) (S : Finset ℤ) (v : ℤ → ℂ) (N : ℝ) (eta : ℂ) : ℝ :=
  (4 / 3 : ℝ) * ‖eta‖ +
    4 * arithmeticBoundaryBudget c * N / Real.pi * ∑ n ∈ S, ‖v n‖

private theorem exterior_abs (M j : ℕ) (negative : Bool) :
    |(exteriorMode M j negative : ℝ)| = (M : ℝ) + (j : ℝ) + 1 := by
  have hn : 0 ≤ (M : ℝ) + (j : ℝ) + 1 := by positivity
  cases negative <;> simp [exteriorMode, abs_of_nonneg hn]

private theorem residual_pointwise {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v : ℤ → ℂ) {N : ℝ} (hN : 0 ≤ N)
    (hS : ∀ n ∈ S, |(n : ℝ)| ≤ N)
    (hzero : ∑ n ∈ S, v n = 0)
    (hsymbol : ∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * v n = 0)
    (eta w : ℂ) {M : ℕ} (hM : 0 < M) (hMN : 2 * N ≤ (M : ℝ))
    (hw : ‖w‖ ≤ (M : ℝ) / 2) (negative : Bool) (j : ℕ) :
    ‖arithmeticResidualTail c S v eta w M negative j‖ ≤
      residualTailBudget c S v N eta / ((M : ℝ) + (j : ℝ) + 1) ^ 2 := by
  have hcol := cancelled_arithmetic_column_bound hc S v hN hS hzero hsymbol
    (m := exteriorMode M j negative)
    (by rw [exterior_abs]; positivity)
    (by rw [exterior_abs]; linarith [Nat.cast_nonneg j])
  rw [exterior_abs] at hcol
  have hread := exterior_cauchy_term_bound hM hw eta j
  unfold arithmeticResidualTail
  calc
    _ ≤ _ := norm_sub_le _ _
    _ ≤ _ := add_le_add hread hcol
    _ = _ := by unfold residualTailBudget; ring

/-- The full exterior residual is square summable on either sign, with an
explicit cubic squared-tail rate. No finite terminal mode is introduced. -/
theorem arithmetic_residual_half_tail_bound {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v : ℤ → ℂ) {N : ℝ} (hN : 0 ≤ N)
    (hS : ∀ n ∈ S, |(n : ℝ)| ≤ N)
    (hzero : ∑ n ∈ S, v n = 0)
    (hsymbol : ∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * v n = 0)
    (eta w : ℂ) {M : ℕ} (hM : 0 < M) (hMN : 2 * N ≤ (M : ℝ))
    (hw : ‖w‖ ≤ (M : ℝ) / 2) (negative : Bool) :
    Summable (fun j : ℕ => ‖arithmeticResidualTail c S v eta w M negative j‖ ^ 2) ∧
      (∑' j : ℕ, ‖arithmeticResidualTail c S v eta w M negative j‖ ^ 2) ≤
        residualTailBudget c S v N eta ^ 2 / (3 * (M : ℝ) ^ 3) := by
  let Q := residualTailBudget c S v N eta
  have hpoint (j : ℕ) : ‖arithmeticResidualTail c S v eta w M negative j‖ ^ 2 ≤
      Q ^ 2 * (1 / ((M : ℝ) + (j : ℝ) + 1) ^ 4) := by
    have h := pow_le_pow_left₀ (norm_nonneg _)
      (residual_pointwise hc S v hN hS hzero hsymbol eta w hM hMN hw negative j) 2
    simpa only [div_pow, ← pow_mul, show (2 : ℕ) * 2 = 4 from rfl,
      div_eq_mul_inv, one_mul, Q] using h
  obtain ⟨hs, hb⟩ := exterior_inverse_fourth_bound hM
  have hdom := hs.mul_left (Q ^ 2)
  have hr : Summable (fun j : ℕ => ‖arithmeticResidualTail c S v eta w M negative j‖ ^ 2) :=
    Summable.of_nonneg_of_le (fun _ => sq_nonneg _) hpoint hdom
  refine ⟨hr, ?_⟩
  calc
    _ ≤ ∑' j : ℕ, Q ^ 2 * (1 / ((M : ℝ) + (j : ℝ) + 1) ^ 4) :=
      hr.tsum_le_tsum hpoint hdom
    _ = Q ^ 2 * ∑' j : ℕ, (1 / ((M : ℝ) + (j : ℝ) + 1) ^ 4) := by rw [tsum_mul_left]
    _ ≤ Q ^ 2 * (1 / (3 * (M : ℝ) ^ 3)) := mul_le_mul_of_nonneg_left hb (sq_nonneg Q)
    _ = _ := by dsimp only [Q]; ring

/-- Both signs of the complete residual are accounted for. The hypotheses
constrain the finite dual trial and its actual arithmetic moments, not the
unknown eigenmode or the desired residual norm. -/
theorem arithmetic_residual_two_sided_tail_bound {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v : ℤ → ℂ) {N : ℝ} (hN : 0 ≤ N)
    (hS : ∀ n ∈ S, |(n : ℝ)| ≤ N)
    (hzero : ∑ n ∈ S, v n = 0)
    (hsymbol : ∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * v n = 0)
    (eta w : ℂ) {M : ℕ} (hM : 0 < M) (hMN : 2 * N ≤ (M : ℝ))
    (hw : ‖w‖ ≤ (M : ℝ) / 2) :
    Summable (fun j : ℕ => ‖arithmeticResidualTail c S v eta w M false j‖ ^ 2 +
      ‖arithmeticResidualTail c S v eta w M true j‖ ^ 2) ∧
      (∑' j : ℕ, ‖arithmeticResidualTail c S v eta w M false j‖ ^ 2 +
        ‖arithmeticResidualTail c S v eta w M true j‖ ^ 2) ≤
          2 * residualTailBudget c S v N eta ^ 2 / (3 * (M : ℝ) ^ 3) := by
  obtain ⟨hp, hpb⟩ := arithmetic_residual_half_tail_bound hc S v hN hS hzero hsymbol
    eta w hM hMN hw false
  obtain ⟨hn, hnb⟩ := arithmetic_residual_half_tail_bound hc S v hN hS hzero hsymbol
    eta w hM hMN hw true
  refine ⟨hp.add hn, ?_⟩
  rw [hp.tsum_add hn]
  nlinarith

private def momentMap (c : ℕ) (S : Finset ℤ) (k : ℤ → ℂ) :
    (S → ℂ) →ₗ[ℂ] (Fin 3 → ℂ) where
  toFun x i := if i = 0 then ∑ n : S, x n
    else if i = 1 then ∑ n : S, (arithmeticBoundarySymbol c n : ℂ) * x n
    else ∑ n : S, conj (k n) * x n
  map_add' x y := by
    ext i
    by_cases h0 : i = 0
    · simp [h0, Finset.sum_add_distrib]
    · by_cases h1 : i = 1 <;> simp [h0, h1, mul_add, Finset.sum_add_distrib]
  map_smul' z x := by
    ext i
    by_cases h0 : i = 0
    · simp [h0, Finset.mul_sum, Pi.smul_apply, smul_eq_mul]
    · by_cases h1 : i = 1 <;>
        simp [h0, h1, Finset.mul_sum, Pi.smul_apply, smul_eq_mul, mul_left_comm, mul_assoc]

private theorem finite_joint_kernel (c : ℕ) (S : Finset ℤ) (k : ℤ → ℂ)
    (hcard : 3 < S.card) :
    ∃ x : S → ℂ, x ≠ 0 ∧ momentMap c S k x = 0 := by
  classical
  by_contra hnone
  have hinj : Function.Injective (momentMap c S k) := by
    intro x y hxy
    have hzero : x - y = 0 := by
      by_contra hne
      apply hnone
      refine ⟨x - y, hne, ?_⟩
      rw [map_sub, hxy, sub_self]
    exact sub_eq_zero.mp hzero
  have hd := LinearMap.finrank_le_finrank_of_injective hinj
  have hle : S.card ≤ 3 := by simpa using hd
  exact (not_le_of_gt hcard) hle

/-- A finite nonzero trial simultaneously satisfies the two actual arithmetic
moments and the candidate-orthogonality equation. No nondegeneracy of the
constraint matrix is assumed. All support indices are retained explicitly. -/
theorem exists_nonzero_arithmetic_moment_trial (c : ℕ) (S : Finset ℤ)
    (k : ℤ → ℂ) (hcard : 3 < S.card) :
    ∃ v : ℤ → ℂ, (∃ n ∈ S, v n ≠ 0) ∧ (∀ n, n ∉ S → v n = 0) ∧
      (∑ n ∈ S, v n) = 0 ∧
      (∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * v n) = 0 ∧
      (∑ n ∈ S, conj (k n) * v n) = 0 := by
  classical
  obtain ⟨x, hx, hm⟩ := finite_joint_kernel c S k hcard
  let v : ℤ → ℂ := fun n => if hn : n ∈ S then x ⟨n, hn⟩ else 0
  have hv (n : S) : v n = x n := by simp [v]
  have h0 := congrFun hm (0 : Fin 3)
  have h1 := congrFun hm (1 : Fin 3)
  have h2 := congrFun hm (2 : Fin 3)
  have eq0 : (∑ n : S, x n) = 0 := by simpa [momentMap] using h0
  have eq1 : (∑ n : S, (arithmeticBoundarySymbol c n : ℂ) * x n) = 0 := by
    simpa [momentMap] using h1
  have eq2 : (∑ n : S, conj (k n) * x n) = 0 := by simpa [momentMap] using h2
  refine ⟨v, ?_, ?_, ?_, ?_, ?_⟩
  · have hex : ∃ n : S, x n ≠ 0 := by
      by_contra h
      apply hx
      ext n
      by_contra hn
      exact h ⟨n, hn⟩
    obtain ⟨n, hn⟩ := hex
    exact ⟨n, n.property, by simpa only [hv] using hn⟩
  · intro n hn
    simp [v, hn]
  · simpa only [← hv, Finset.sum_coe_sort] using eq0
  · simpa only [← hv, Finset.sum_coe_sort] using eq1
  · simpa only [← hv, Finset.sum_coe_sort] using eq2

/-- The feasible nonzero trial is consumed by the actual arithmetic tail
bound. Hence its moment hypotheses are jointly realizable with a prescribed
candidate pairing, rather than satisfied only by a zero trial. -/
theorem exists_nonzero_trial_with_cubic_tail {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (k : ℤ → ℂ) (hcard : 3 < S.card)
    {N : ℝ} (hN : 0 ≤ N) (hS : ∀ n ∈ S, |(n : ℝ)| ≤ N)
    (eta w : ℂ) {M : ℕ} (hM : 0 < M) (hMN : 2 * N ≤ (M : ℝ))
    (hw : ‖w‖ ≤ (M : ℝ) / 2) :
    ∃ v : ℤ → ℂ, (∃ n ∈ S, v n ≠ 0) ∧ (∀ n, n ∉ S → v n = 0) ∧
      (∑ n ∈ S, v n) = 0 ∧
      (∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * v n) = 0 ∧
      (∑ n ∈ S, conj (k n) * v n) = 0 ∧
      Summable (fun j : ℕ => ‖arithmeticResidualTail c S v eta w M false j‖ ^ 2 +
        ‖arithmeticResidualTail c S v eta w M true j‖ ^ 2) ∧
      (∑' j : ℕ, ‖arithmeticResidualTail c S v eta w M false j‖ ^ 2 +
        ‖arithmeticResidualTail c S v eta w M true j‖ ^ 2) ≤
          2 * residualTailBudget c S v N eta ^ 2 / (3 * (M : ℝ) ^ 3) := by
  obtain ⟨v, hv, hs, h0, h1, h2⟩ := exists_nonzero_arithmetic_moment_trial c S k hcard
  obtain ⟨ht, hb⟩ := arithmetic_residual_two_sided_tail_bound hc S v hN hS h0 h1
    eta w hM hMN hw
  exact ⟨v, hv, hs, h0, h1, h2, ht, hb⟩

#print axioms arithmetic_residual_two_sided_tail_bound
#print axioms exists_nonzero_trial_with_cubic_tail

end D5.S3.Weil.ZetaBridge.WeilArithmeticResidualTail
