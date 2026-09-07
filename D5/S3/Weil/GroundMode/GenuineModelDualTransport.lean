/- GID: D5/S3/Weil/GroundMode/GenuineModelDualTransport
   generality: G
   mirror-B: D5/B/S3/Weil/GroundMode/GenuineModelDualTransport
   mirror-E: none(waiver:domain-level-recentering-with-complete-residual)
   anchors: []
   digest: Transfer candidate-complement coercivity and complete dual trials to a nearby genuine model with arbitrary Fourier support. -/

import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Module
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-!
# Recenter a full-domain certificate on the genuine model

A finite trial v orthogonal to k need not be orthogonal to a nearby genuine
prolate model e. Its repaired trial v-<e,v>e generally has infinite Fourier
support. These theorems retain the FULL action on that correction rather
than applying a finite-support exterior bound to it.

The target consumer is the actual full-residual energy-dual inequality in
CoerciveDualCertificate/ProjectiveEnergyDual (PR #5882). Its coefficient is
not redefined here. This owner proves the change-of-candidate bounds needed
to use that existing inequality with the SAME genuine prolate family.

The action is defined only on a complex-linear domain. Completeness, a
bounded extension, a new exact dual inverse and a uniform spectral gap are
not assumed. The model is required to be in that domain and its actual
Rayleigh residual must be bounded. Mere L2 proximity would not suffice.

The algebra is classical hyperplane elimination and residual control,
consistent with the full-exterior Feshbach-Schur methodology; no priority
or actual all-scale Weil/prolate convergence is claimed.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section
namespace D5.S3.Weil.GroundMode.GenuineModelDualTransport

open scoped InnerProductSpace ComplexConjugate

variable {H E : Type*}
variable [NormedAddCommGroup H] [InnerProductSpace ℂ H]
variable [AddCommGroup E] [Module ℂ E]

private def off (k x : H) : H := x - ⟪k, x⟫_ℂ • k

private theorem unit_self (k : H) (hk : ‖k‖ = 1) : ⟪k, k⟫_ℂ = 1 := by
  rw [inner_self_eq_norm_sq_to_K, hk]
  norm_num

private theorem off_add (k x y : H) : off k (x + y) = off k x + off k y := by
  simp only [off, inner_add_right]
  module

private theorem off_smul (k x : H) (a : ℂ) : off k (a • x) = a • off k x := by
  simp only [off, inner_smul_right]
  module

private theorem off_self (k : H) (hk : ‖k‖ = 1) : off k k = 0 := by
  simp only [off, unit_self k hk, one_smul, sub_self]

private theorem off_norm_sq (k x : H) (hk : ‖k‖ = 1) :
    ‖off k x‖ ^ 2 = ‖x‖ ^ 2 - ‖⟪k, x⟫_ℂ‖ ^ 2 := by
  have hc : ⟪x, k⟫_ℂ = conj ⟪k, x⟫_ℂ := (inner_conj_symm x k).symm
  rw [off, norm_sub_sq (𝕜 := ℂ), inner_smul_right, hc, norm_smul, hk, mul_one]
  simp only [← Complex.normSq_eq_norm_sq, Complex.normSq_apply,
    Complex.mul_re, Complex.conj_re, Complex.conj_im]
  ring

private theorem off_contract (k x : H) (hk : ‖k‖ = 1) : ‖off k x‖ ≤ ‖x‖ := by
  have h := off_norm_sq k x hk
  nlinarith [sq_nonneg ‖⟪k, x⟫_ℂ‖, norm_nonneg (off k x), norm_nonneg x]

private theorem off_other_unit (e k : H) (he : ‖e‖ = 1) :
    ‖off e k‖ ≤ ‖e - k‖ := by
  have hh : off e (k - e) = off e k := by
    simp only [off, inner_sub_right, unit_self e he]
    module
  rw [← hh, norm_sub_rev e k]
  exact off_contract e (k - e) he

private theorem near_orthogonal_overlap (k e v : H) (eps : ℝ)
    (hd : ‖e - k‖ ≤ eps) (hv : ⟪k, v⟫_ℂ = 0) :
    ‖⟪e, v⟫_ℂ‖ ≤ eps * ‖v‖ := by
  have heq : ⟪e - k, v⟫_ℂ = ⟪e, v⟫_ℂ := by rw [inner_sub_left, hv, sub_zero]
  rw [← heq]
  exact (norm_inner_le_norm _ _).trans (mul_le_mul_of_nonneg_right hd (norm_nonneg _))

private theorem energy_sub_smul (ι A : E →ₗ[ℂ] H)
    (hsym : ∀ x y : E, ⟪ι x, A y⟫_ℂ = ⟪A x, ι y⟫_ℂ)
    (f e : E) (b : ℂ) :
    (⟪ι (f - b • e), A (f - b • e)⟫_ℂ).re =
      (⟪ι f, A f⟫_ℂ).re + ‖b‖ ^ 2 * (⟪ι e, A e⟫_ℂ).re -
        2 * (b * ⟪ι f, A e⟫_ℂ).re := by
  have hc : ⟪ι e, A f⟫_ℂ = conj ⟪ι f, A e⟫_ℂ := by
    rw [hsym e f]
    exact (inner_conj_symm (A e) (ι f)).symm
  simp only [map_sub, map_smul, inner_sub_left, inner_sub_right,
    inner_smul_left, inner_smul_right, hc]
  simp only [← Complex.normSq_eq_norm_sq, Complex.normSq_apply,
    Complex.sub_re, Complex.mul_re, Complex.mul_im, Complex.conj_re, Complex.conj_im]
  ring

/-- A certified distance to a unit candidate supplies a nonzero overlap
without a separate angle or nonvanishing oracle. -/
theorem candidate_overlap_floor (k e : H) (eps : ℝ)
    (hk : ‖k‖ = 1) (hd : ‖e - k‖ ≤ eps) :
    1 - eps ≤ ‖⟪k, e⟫_ℂ‖ := by
  have h := (norm_inner_le_norm k (e - k)).trans
    (mul_le_mul_of_nonneg_left hd (norm_nonneg k))
  rw [inner_sub_right, unit_self k hk, hk, one_mul] at h
  have ht := norm_sub_norm_le (1 : ℂ) ⟪k, e⟫_ℂ
  rw [norm_one, norm_sub_rev] at ht
  linarith

/-- Transfer the actual candidate-complement lower bound to the genuine
model's complement. The full model residual, not an L2-only action bound,
pays for the change of hyperplane. The new threshold is T-2*rho*eps/(1-eps).
No prior coercivity statement on the new complement is an input. -/
theorem near_candidate_complement_coercivity
    (ι A : E →ₗ[ℂ] H) (k e : E) (T mu eps rho : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, A y⟫_ℂ = ⟪A x, ι y⟫_ℂ)
    (hk : ‖ι k‖ = 1) (he : ‖ι e‖ = 1)
    (heps : 0 ≤ eps) (heps1 : eps < 1) (hrho : 0 ≤ rho)
    (hd : ‖ι e - ι k‖ ≤ eps)
    (hmu : (⟪ι e, A e⟫_ℂ).re = mu) (hmuT : mu ≤ T)
    (hr : ‖A e - (mu : ℂ) • ι e‖ ≤ rho)
    (hcoercive : ∀ f : E, ⟪ι k, ι f⟫_ℂ = 0 →
      T * ‖ι f‖ ^ 2 ≤ (⟪ι f, A f⟫_ℂ).re) :
    ∀ f : E, ⟪ι e, ι f⟫_ℂ = 0 →
      (T - 2 * rho * eps / (1 - eps)) * ‖ι f‖ ^ 2 ≤
        (⟪ι f, A f⟫_ℂ).re := by
  intro f hf
  let alpha : ℂ := ⟪ι k, ι e⟫_ℂ
  let beta : ℂ := ⟪ι k, ι f⟫_ℂ / alpha
  let h : E := f - beta • e
  let r : H := A e - (mu : ℂ) • ι e
  have hden : 0 < 1 - eps := by linarith
  have halower : 1 - eps ≤ ‖alpha‖ := candidate_overlap_floor (ι k) (ι e) eps hk hd
  have ha : alpha ≠ 0 := norm_pos_iff.mp (lt_of_lt_of_le hden halower)
  have hkh : ⟪ι k, ι h⟫_ℂ = 0 := by
    rw [show ι h = ι f - beta • ι e by simp only [h, map_sub, map_smul],
      inner_sub_right, inner_smul_right]
    change ⟪ι k, ι f⟫_ℂ - (⟪ι k, ι f⟫_ℂ / alpha) * alpha = 0
    rw [div_mul_cancel₀ _ ha, sub_self]
  have hnum : ‖⟪ι k, ι f⟫_ℂ‖ ≤ eps * ‖ι f‖ :=
    near_orthogonal_overlap (ι e) (ι k) (ι f) eps
      (by simpa only [norm_sub_rev] using hd) hf
  have hb : ‖beta‖ ≤ (eps / (1 - eps)) * ‖ι f‖ := by
    rw [beta, norm_div]
    calc
      _ ≤ (eps * ‖ι f‖) / ‖alpha‖ :=
        div_le_div_of_nonneg_right hnum (norm_nonneg _)
      _ ≤ (eps * ‖ι f‖) / (1 - eps) :=
        div_le_div_of_nonneg_left (mul_nonneg heps (norm_nonneg _)) hden halower
      _ = _ := by ring
  have hfe : ⟪ι f, ι e⟫_ℂ = 0 := inner_eq_zero_symm.mp hf
  have hnorm : ‖ι h‖ ^ 2 = ‖ι f‖ ^ 2 + ‖beta‖ ^ 2 := by
    simp only [h, map_sub, map_smul, norm_sub_sq (𝕜 := ℂ), inner_smul_right,
      hfe, mul_zero, Complex.zero_re, mul_zero, sub_zero, norm_smul, he, mul_one]
  have hir : ⟪ι f, A e⟫_ℂ = ⟪ι f, r⟫_ℂ := by
    simp only [r, inner_sub_right, inner_smul_right, hfe, mul_zero, sub_zero]
  have henergy := energy_sub_smul ι A hsym f e beta
  rw [hmu, hir] at henergy
  have hc := hcoercive h hkh
  rw [hnorm, henergy] at hc
  have hcross : |(beta * ⟪ι f, r⟫_ℂ).re| ≤ ‖beta‖ * ‖ι f‖ * rho := by
    calc
      _ ≤ ‖beta * ⟪ι f, r⟫_ℂ‖ := Complex.abs_re_le_norm _
      _ = ‖beta‖ * ‖⟪ι f, r⟫_ℂ‖ := norm_mul _ _
      _ ≤ ‖beta‖ * (‖ι f‖ * rho) :=
        mul_le_mul_of_nonneg_left
          ((norm_inner_le_norm _ _).trans (mul_le_mul_of_nonneg_left hr (norm_nonneg _)))
          (norm_nonneg beta)
      _ = _ := by ring
  have hbc := mul_le_mul_of_nonneg_right hb (mul_nonneg (norm_nonneg (ι f)) hrho)
  have hpos := mul_nonneg (sub_nonneg.mpr hmuT) (sq_nonneg ‖beta‖)
  have hlow := (abs_le.mp hcross).1
  have htarget : (T - 2 * rho * (eps / (1 - eps))) * ‖ι f‖ ^ 2 ≤
      (⟪ι f, A f⟫_ℂ).re := by nlinarith
  simpa only [mul_div_assoc] using htarget

/-- The genuine-model repair stays in the linear operator domain. Its full
projected residual is exactly the old raw residual plus beta times the
FULL model residual, projected on the new complement. This identity applies
even when e has infinitely many Fourier coefficients. -/
theorem recentered_trial_residual_identity
    (ι M : E →ₗ[ℂ] H) (e v : E) (g : H) (nu : ℝ) (he : ‖ι e‖ = 1) :
    let beta := ⟪ι e, ι v⟫_ℂ
    let w := v - beta • e
    let r := M e - (nu : ℂ) • ι e
    let z := g - M v + beta • r
    ⟪ι e, ι w⟫_ℂ = 0 ∧
      (g - M w) - ⟪ι e, g - M w⟫_ℂ • ι e = z - ⟪ι e, z⟫_ℂ • ι e := by
  dsimp only
  constructor
  · simp only [map_sub, map_smul, inner_sub_right, inner_smul_right,
      unit_self (ι e) he, mul_one, sub_self]
  · simp only [map_sub, map_smul, inner_sub_right, inner_add_right,
      inner_smul_right, unit_self (ι e) he]
    module

/-- A full residual bound transported from a finite candidate. The old raw
candidate coefficient alpha and the actual model Rayleigh residual are both
paid for. The finite-support tail theorem is never applied to the repaired
infinite-support vector. -/
theorem recentered_trial_residual_bound
    (ι M : E →ₗ[ℂ] H) (k e v : E) (g : H) (nu eps rho : ℝ)
    (hk : ‖ι k‖ = 1) (he : ‖ι e‖ = 1)
    (heps : 0 ≤ eps) (hrho : 0 ≤ rho)
    (hd : ‖ι e - ι k‖ ≤ eps) (hv : ⟪ι k, ι v⟫_ℂ = 0)
    (hr : ‖M e - (nu : ℂ) • ι e‖ ≤ rho) :
    let raw := g - M v
    let w := v - ⟪ι e, ι v⟫_ℂ • e
    ‖(g - M w) - ⟪ι e, g - M w⟫_ℂ • ι e‖ ≤
      ‖raw - ⟪ι k, raw⟫_ℂ • ι k‖ + eps * ‖⟪ι k, raw⟫_ℂ‖ +
        eps * ‖ι v‖ * rho := by
  let raw := g - M v
  let beta := ⟪ι e, ι v⟫_ℂ
  let r := M e - (nu : ℂ) • ι e
  have hb : ‖beta‖ ≤ eps * ‖ι v‖ := near_orthogonal_overlap (ι k) (ι e) (ι v) eps hd hv
  have hpk : ‖off (ι e) (ι k)‖ ≤ eps := (off_other_unit (ι e) (ι k) he).trans hd
  have hraw : off (ι e) raw = off (ι e) (off (ι k) raw) +
      ⟪ι k, raw⟫_ℂ • off (ι e) (ι k) := by
    have hdecomp : raw = off (ι k) raw + ⟪ι k, raw⟫_ℂ • ι k := by
      simp only [off, sub_add_cancel]
    conv_lhs => rw [hdecomp]
    rw [off_add, off_smul]
  have hrawbound : ‖off (ι e) raw‖ ≤ ‖off (ι k) raw‖ + eps * ‖⟪ι k, raw⟫_ℂ‖ := by
    rw [hraw]
    calc
      _ ≤ ‖off (ι e) (off (ι k) raw)‖ + ‖⟪ι k, raw⟫_ℂ • off (ι e) (ι k)‖ := norm_add_le _ _
      _ ≤ ‖off (ι k) raw‖ + eps * ‖⟪ι k, raw⟫_ℂ‖ := by
        rw [norm_smul]
        exact add_le_add (off_contract _ _ he)
          (by simpa only [mul_comm] using mul_le_mul_of_nonneg_left hpk (norm_nonneg _))
  have hid := (recentered_trial_residual_identity ι M e v g nu he).2
  dsimp only at hid ⊢
  rw [hid]
  change ‖off (ι e) (raw + beta • r)‖ ≤ _
  rw [off_add, off_smul]
  calc
    _ ≤ ‖off (ι e) raw‖ + ‖beta • off (ι e) r‖ := norm_add_le _ _
    _ ≤ ‖off (ι k) raw‖ + eps * ‖⟪ι k, raw⟫_ℂ‖ + eps * ‖ι v‖ * rho := by
      rw [norm_smul]
      exact add_le_add hrawbound
        (mul_le_mul hb ((off_contract _ _ he).trans hr) (norm_nonneg _) (mul_nonneg heps (norm_nonneg _)))

/-- The signed variational objective is transported without replacing it by
an energy norm or assuming positivity. Both complex mixed terms are retained.
The same full model residual used above pays for the graph action. -/
theorem recentered_trial_objective_bound
    (ι M : E →ₗ[ℂ] H) (k e v : E) (g : H) (nu eps rho : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (heps : 0 ≤ eps) (hrho : 0 ≤ rho)
    (hd : ‖ι e - ι k‖ ≤ eps) (hv : ⟪ι k, ι v⟫_ℂ = 0)
    (hnu : (⟪ι e, M e⟫_ℂ).re = nu)
    (hr : ‖M e - (nu : ℂ) • ι e‖ ≤ rho) :
    let w := v - ⟪ι e, ι v⟫_ℂ • e
    2 * (⟪g, ι w⟫_ℂ).re - (⟪ι w, M w⟫_ℂ).re ≤
      2 * (⟪g, ι v⟫_ℂ).re - (⟪ι v, M v⟫_ℂ).re +
      2 * eps * ‖ι v‖ * ‖⟪g, ι e⟫_ℂ‖ +
      |nu| * (eps * ‖ι v‖) ^ 2 + 2 * eps * ‖ι v‖ ^ 2 * rho := by
  let beta := ⟪ι e, ι v⟫_ℂ
  let r := M e - (nu : ℂ) • ι e
  have hb : ‖beta‖ ≤ eps * ‖ι v‖ := near_orthogonal_overlap (ι k) (ι e) (ι v) eps hd hv
  have hc : ⟪ι v, ι e⟫_ℂ = conj beta := (inner_conj_symm (ι v) (ι e)).symm
  have haction : M e = (nu : ℂ) • ι e + r := by dsimp [r]; module
  have hcross : (beta * ⟪ι v, M e⟫_ℂ).re =
      nu * ‖beta‖ ^ 2 + (beta * ⟪ι v, r⟫_ℂ).re := by
    rw [haction, inner_add_right, inner_smul_right, hc]
    simp only [← Complex.normSq_eq_norm_sq, Complex.normSq_apply,
      Complex.mul_re, Complex.mul_im, Complex.add_re, Complex.add_im,
      Complex.conj_re, Complex.conj_im, Complex.ofReal_re, Complex.ofReal_im]
    ring
  have henergy := energy_sub_smul ι M hsym v e beta
  rw [hnu, hcross] at henergy
  have hp : |(beta * ⟪g, ι e⟫_ℂ).re| ≤
      eps * ‖ι v‖ * ‖⟪g, ι e⟫_ℂ‖ := by
    calc
      _ ≤ ‖beta * ⟪g, ι e⟫_ℂ‖ := Complex.abs_re_le_norm _
      _ ≤ _ := by rw [norm_mul]; exact mul_le_mul_of_nonneg_right hb (norm_nonneg _)
  have hrp : |(beta * ⟪ι v, r⟫_ℂ).re| ≤ eps * ‖ι v‖ ^ 2 * rho := by
    calc
      _ ≤ ‖beta * ⟪ι v, r⟫_ℂ‖ := Complex.abs_re_le_norm _
      _ ≤ (eps * ‖ι v‖) * (‖ι v‖ * rho) := by
        rw [norm_mul]
        exact mul_le_mul hb ((norm_inner_le_norm _ _).trans
          (mul_le_mul_of_nonneg_left hr (norm_nonneg _))) (norm_nonneg _)
          (mul_nonneg heps (norm_nonneg _))
      _ = _ := by ring
  have hnuTerm : nu * ‖beta‖ ^ 2 ≤ |nu| * (eps * ‖ι v‖) ^ 2 :=
    (mul_le_mul_of_nonneg_right (le_abs_self nu) (sq_nonneg _)).trans
      (mul_le_mul_of_nonneg_left (pow_le_pow_left₀ (norm_nonneg _) hb 2) (abs_nonneg _))
  have hpneg := (abs_le.mp hp).1
  have hrppos := (abs_le.mp hrp).2
  dsimp only
  change 2 * (⟪g, ι (v - beta • e)⟫_ℂ).re - (⟪ι (v - beta • e), M (v - beta • e)⟫_ℂ).re ≤ _
  rw [henergy, map_sub, map_smul, inner_sub_right, inner_smul_right, Complex.sub_re]
  nlinarith

/-- Assemble a certified upper bound for the genuine-model dual coefficient.
The left expression is exactly the coefficient consumed by the existing
energy-dual owner. A,B,R,J cap independently checked finite-trial quantities;
the full model residual rho pays for the infinite correction. -/
theorem recentered_dual_coefficient_bound
    (ι M : E →ₗ[ℂ] H) (k e v : E) (g : H)
    (nu eps rho kappa V G A R J : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (hk : ‖ι k‖ = 1) (he : ‖ι e‖ = 1)
    (heps : 0 ≤ eps) (hrho : 0 ≤ rho) (hkappa : 0 < kappa)
    (hd : ‖ι e - ι k‖ ≤ eps) (hv : ⟪ι k, ι v⟫_ℂ = 0)
    (hnu : (⟪ι e, M e⟫_ℂ).re = nu) (hr : ‖M e - (nu : ℂ) • ι e‖ ≤ rho)
    (hV : ‖ι v‖ ≤ V) (hG : ‖⟪g, ι e⟫_ℂ‖ ≤ G)
    (hA : ‖⟪ι k, g - M v⟫_ℂ‖ ≤ A)
    (hR : ‖(g - M v) - ⟪ι k, g - M v⟫_ℂ • ι k‖ ≤ R)
    (hJ : 2 * (⟪g, ι v⟫_ℂ).re - (⟪ι v, M v⟫_ℂ).re ≤ J) :
    let w := v - ⟪ι e, ι v⟫_ℂ • e
    2 * (⟪g, ι w⟫_ℂ).re - (⟪ι w, M w⟫_ℂ).re +
      ‖(g - M w) - ⟪ι e, g - M w⟫_ℂ • ι e‖ ^ 2 / kappa ≤
      J + 2 * eps * V * G + |nu| * (eps * V) ^ 2 + 2 * eps * V ^ 2 * rho +
        (R + eps * A + eps * V * rho) ^ 2 / kappa := by
  have hV0 : 0 ≤ V := (norm_nonneg _).trans hV
  have hG0 : 0 ≤ G := (norm_nonneg _).trans hG
  have hA0 : 0 ≤ A := (norm_nonneg _).trans hA
  have hR0 : 0 ≤ R := (norm_nonneg _).trans hR
  have hV2 := pow_le_pow_left₀ (norm_nonneg _) hV 2
  have hb := recentered_trial_residual_bound ι M k e v g nu eps rho
    hk he heps hrho hd hv hr
  have ho := recentered_trial_objective_bound ι M k e v g nu eps rho
    hsym heps hrho hd hv hnu hr
  dsimp only at hb ho
  have hnorm : ‖(g - M (v - ⟪ι e, ι v⟫_ℂ • e)) -
      ⟪ι e, g - M (v - ⟪ι e, ι v⟫_ℂ • e)⟫_ℂ • ι e‖ ≤ R + eps * A + eps * V * rho := by
    refine hb.trans ?_
    exact add_le_add (add_le_add hR (mul_le_mul_of_nonneg_left hA heps))
      (mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left hV heps) hrho)
  have hp := mul_le_mul (mul_le_mul_of_nonneg_left hV (by positivity : 0 ≤ 2 * eps))
    hG (norm_nonneg _) (by positivity : 0 ≤ 2 * eps * V)
  have hn := mul_le_mul_of_nonneg_left
    (pow_le_pow_left₀ (by positivity : 0 ≤ eps * ‖ι v‖)
      (mul_le_mul_of_nonneg_left hV heps) 2) (abs_nonneg nu)
  have hc := mul_le_mul_of_nonneg_right
    (mul_le_mul_of_nonneg_left hV2 (by positivity : 0 ≤ 2 * eps)) hrho
  have hobj : 2 * (⟪g, ι (v - ⟪ι e, ι v⟫_ℂ • e)⟫_ℂ).re -
      (⟪ι (v - ⟪ι e, ι v⟫_ℂ • e), M (v - ⟪ι e, ι v⟫_ℂ • e)⟫_ℂ).re ≤
      J + 2 * eps * V * G + |nu| * (eps * V) ^ 2 + 2 * eps * V ^ 2 * rho := by linarith
  exact add_le_add hobj (div_le_div_of_nonneg_right
    (pow_le_pow_left₀ (norm_nonneg _) hnorm 2) hkappa.le)

#print axioms near_candidate_complement_coercivity
#print axioms recentered_trial_residual_identity
#print axioms recentered_trial_residual_bound
#print axioms recentered_trial_objective_bound
#print axioms recentered_dual_coefficient_bound


/-!
## Positive shifted-form transport

The following alternative USES the additional whole-domain certificate
`0 <= Re <iota f, M f>`. It is justified by an independently proved lower
bound A >= ell when M=A-ell*iota; ell may be negative. It is not an
assumption of unshifted Weil positivity at every window.

The old graph-residual route above remains available without this premise.
Here positive quadratic-form arithmetic transfers the coercive complement
and the READOUT INEQUALITY directly. No new trial is repaired, no norm of
M e is evaluated, and no projected infinite correction is thrown away.
-/

private theorem energy_smul_for_positive_transport (ι M : E →ₗ[ℂ] H)
    (f : E) (a : ℂ) :
    (⟪ι (a • f), M (a • f)⟫_ℂ).re =
      ‖a‖ ^ 2 * (⟪ι f, M f⟫_ℂ).re := by
  simp only [map_smul, inner_smul_left, inner_smul_right]
  simp only [← Complex.normSq_eq_norm_sq, Complex.normSq_apply,
    Complex.mul_re, Complex.mul_im, Complex.conj_re, Complex.conj_im]
  ring

private theorem positive_energy_young
    (ι M : E →ₗ[ℂ] H)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (hpositive : ∀ f : E, 0 ≤ (⟪ι f, M f⟫_ℂ).re)
    (f k : E) (a : ℂ) (t : ℝ) (ht : 0 < t) :
    (⟪ι (f - a • k), M (f - a • k)⟫_ℂ).re ≤
      (1 + t) * (⟪ι f, M f⟫_ℂ).re +
        (1 + 1 / t) * ‖a‖ ^ 2 * (⟪ι k, M k⟫_ℂ).re := by
  have hplus := energy_sub_smul ι M hsym ((t : ℂ) • f) k (-a)
  have hcross : ((-a) * ⟪ι ((t : ℂ) • f), M k⟫_ℂ).re =
      -t * (a * ⟪ι f, M k⟫_ℂ).re := by
    simp only [map_smul, inner_smul_left]
    simp only [Complex.mul_re, Complex.mul_im, Complex.neg_re, Complex.neg_im,
      Complex.conj_re, Complex.conj_im, Complex.ofReal_re, Complex.ofReal_im]
    ring
  rw [energy_smul_for_positive_transport, norm_neg, hcross,
    Complex.norm_real, Real.norm_eq_abs, sq_abs] at hplus
  have hn := hpositive (((t : ℂ) • f) - (-a) • k)
  rw [hplus] at hn
  rw [energy_sub_smul ι M hsym f k a]
  apply (mul_le_mul_left ht).mp
  have hid : t * ((1 + t) * (⟪ι f, M f⟫_ℂ).re +
      (1 + 1 / t) * ‖a‖ ^ 2 * (⟪ι k, M k⟫_ℂ).re) -
      t * ((⟪ι f, M f⟫_ℂ).re + ‖a‖ ^ 2 * (⟪ι k, M k⟫_ℂ).re -
        2 * (a * ⟪ι f, M k⟫_ℂ).re) =
      t ^ 2 * (⟪ι f, M f⟫_ℂ).re + ‖a‖ ^ 2 * (⟪ι k, M k⟫_ℂ).re +
        2 * t * (a * ⟪ι f, M k⟫_ℂ).re := by
    field_simp [ht.ne']
    <;> ring
  nlinarith

private theorem norm_add_square_young (x y : ℂ) (s : ℝ) (hs : 0 < s) :
    ‖x + y‖ ^ 2 ≤ (1 + s) * ‖x‖ ^ 2 + (1 + 1 / s) * ‖y‖ ^ 2 := by
  have ht := pow_le_pow_left₀ (norm_nonneg (x + y)) (norm_add_le x y) 2
  have hmul := mul_le_mul_of_nonneg_left ht hs.le
  have hid : s * ((1 + s) * ‖x‖ ^ 2 + (1 + 1 / s) * ‖y‖ ^ 2) -
      s * (‖x‖ + ‖y‖) ^ 2 = (s * ‖x‖ - ‖y‖) ^ 2 := by
    field_simp [hs.ne']
    <;> ring
  apply (mul_le_mul_left hs).mp
  nlinarith [sq_nonneg (s * ‖x‖ - ‖y‖)]

/-- A positive SHIFTED form transfers complement coercivity using the old
candidate's energy delta, rather than the norm of the genuine-model action.
The scalar t is any positive balancing parameter. The derived threshold
may be negative; its positivity is checked separately by the consumer. -/
theorem positive_form_complement_coercivity
    (ι M : E →ₗ[ℂ] H) (k e : E) (kappa delta eps t : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (hpositive : ∀ f : E, 0 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hk : ‖ι k‖ = 1) (hkenergy : (⟪ι k, M k⟫_ℂ).re ≤ delta)
    (hkappa : 0 ≤ kappa) (heps : 0 ≤ eps) (ht : 0 < t)
    (hd : ‖ι e - ι k‖ ≤ eps)
    (hcoercive : ∀ f : E, ⟪ι k, ι f⟫_ℂ = 0 →
      kappa * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re) :
    ∀ f : E, ⟪ι e, ι f⟫_ℂ = 0 →
      (kappa * (1 - eps ^ 2) / (1 + t) - delta * eps ^ 2 / t) * ‖ι f‖ ^ 2 ≤
        (⟪ι f, M f⟫_ℂ).re := by
  intro f hf
  let a : ℂ := ⟪ι k, ι f⟫_ℂ
  let v : E := f - a • k
  have hdelta : 0 ≤ delta := (hpositive k).trans hkenergy
  have htp : 0 < 1 + t := by linarith
  have hv : ⟪ι k, ι v⟫_ℂ = 0 := by
    simp only [v, map_sub, map_smul, inner_sub_right, inner_smul_right,
      unit_self (ι k) hk, mul_one, a, sub_self]
  have himage : ι v = off (ι k) (ι f) := by simp only [v, off, map_sub, map_smul, a]
  have hn : ‖ι v‖ ^ 2 = ‖ι f‖ ^ 2 - ‖a‖ ^ 2 := by
    rw [himage, off_norm_sq (ι k) (ι f) hk]
  have ha := near_orthogonal_overlap (ι e) (ι k) (ι f) eps
    (by simpa only [norm_sub_rev] using hd) hf
  have ha2 : ‖a‖ ^ 2 ≤ eps ^ 2 * ‖ι f‖ ^ 2 := by
    simpa only [mul_pow] using pow_le_pow_left₀ (norm_nonneg _) ha 2
  have hy := positive_energy_young ι M hsym hpositive f k a t ht
  have hqc := hcoercive v hv
  rw [hn] at hqc
  have henergy := mul_le_mul_of_nonneg_left hkenergy
    (by positivity : 0 ≤ (1 + 1 / t) * ‖a‖ ^ 2)
  have hcoef : 0 ≤ kappa + (1 + 1 / t) * delta := by positivity
  have hangle := mul_le_mul_of_nonneg_left ha2 hcoef
  have hcombined : (kappa - (kappa + (1 + 1 / t) * delta) * eps ^ 2) *
      ‖ι f‖ ^ 2 ≤ (1 + t) * (⟪ι f, M f⟫_ℂ).re := by
    change (⟪ι v, M v⟫_ℂ).re ≤ _ at hy
    nlinarith
  apply (mul_le_mul_left htp).mp
  calc
    _ = (kappa - (kappa + (1 + 1 / t) * delta) * eps ^ 2) * ‖ι f‖ ^ 2 := by
      field_simp [ht.ne', htp.ne']
      <;> ring
    _ ≤ _ := hcombined

/-- Transport an already proved energy-dual READOUT inequality directly.
No repaired trial, inverse, model Rayleigh residual or graph norm is an
input. The old full-space lower certificate is essential and explicit.
The gain G controls the old candidate's readout, and the same g occurs on
both complements. The two positive balancing parameters are independent. -/
theorem positive_form_readout_transport
    (ι M : E →ₗ[ℂ] H) (k e : E) (g : H) (kappa delta eps t s C G : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (hpositive : ∀ f : E, 0 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hk : ‖ι k‖ = 1) (hkenergy : (⟪ι k, M k⟫_ℂ).re ≤ delta)
    (hkappa : 0 ≤ kappa) (heps : 0 ≤ eps) (ht : 0 < t) (hs : 0 < s)
    (hd : ‖ι e - ι k‖ ≤ eps)
    (hcoercive : ∀ f : E, ⟪ι k, ι f⟫_ℂ = 0 →
      kappa * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hC : 0 ≤ C) (hG : ‖⟪g, ι k⟫_ℂ‖ ≤ G)
    (hreadout : ∀ f : E, ⟪ι k, ι f⟫_ℂ = 0 →
      ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤ C * (⟪ι f, M f⟫_ℂ).re)
    (hmargin : 0 < kappa * (1 - eps ^ 2) / (1 + t) - delta * eps ^ 2 / t) :
    let kp := kappa * (1 - eps ^ 2) / (1 + t) - delta * eps ^ 2 / t
    ∀ f : E, ⟪ι e, ι f⟫_ℂ = 0 →
      ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤
        ((1 + s) * (1 + t) * C + eps ^ 2 / kp *
          ((1 + s) * (1 + 1 / t) * C * delta + (1 + 1 / s) * G ^ 2)) *
            (⟪ι f, M f⟫_ℂ).re := by
  dsimp only
  intro f hf
  let kp := kappa * (1 - eps ^ 2) / (1 + t) - delta * eps ^ 2 / t
  let a : ℂ := ⟪ι k, ι f⟫_ℂ
  let v : E := f - a • k
  let Q := (⟪ι f, M f⟫_ℂ).re
  let B := (1 + s) * (1 + 1 / t) * C * delta + (1 + 1 / s) * G ^ 2
  have hdelta : 0 ≤ delta := (hpositive k).trans hkenergy
  have hG0 : 0 ≤ G := (norm_nonneg _).trans hG
  have hB : 0 ≤ B := by dsimp [B]; positivity
  have hv : ⟪ι k, ι v⟫_ℂ = 0 := by
    simp only [v, map_sub, map_smul, inner_sub_right, inner_smul_right,
      unit_self (ι k) hk, mul_one, a, sub_self]
  have hnew := positive_form_complement_coercivity ι M k e kappa delta eps t
    hsym hpositive hk hkenergy hkappa heps ht hd hcoercive f hf
  have hnorm : ‖ι f‖ ^ 2 ≤ Q / kp := by
    apply (le_div_iff₀ hmargin).mpr
    simpa only [mul_comm] using hnew
  have ha := near_orthogonal_overlap (ι e) (ι k) (ι f) eps
    (by simpa only [norm_sub_rev] using hd) hf
  have ha2 : ‖a‖ ^ 2 ≤ eps ^ 2 * Q / kp := by
    calc
      _ ≤ eps ^ 2 * ‖ι f‖ ^ 2 := by
        simpa only [mul_pow] using pow_le_pow_left₀ (norm_nonneg _) ha 2
      _ ≤ eps ^ 2 * (Q / kp) := mul_le_mul_of_nonneg_left hnorm (sq_nonneg eps)
      _ = _ := by ring
  have hdecomp : ⟪g, ι f⟫_ℂ = ⟪g, ι v⟫_ℂ + a * ⟪g, ι k⟫_ℂ := by
    simp only [v, map_sub, map_smul, inner_sub_right, inner_smul_right, sub_add_cancel]
  have hy := norm_add_square_young ⟪g, ι v⟫_ℂ (a * ⟪g, ι k⟫_ℂ) s hs
  rw [← hdecomp, norm_mul, mul_pow] at hy
  have hvread := mul_le_mul_of_nonneg_left (hreadout v hv)
    (by positivity : 0 ≤ 1 + s)
  have hyenergy := positive_energy_young ι M hsym hpositive f k a t ht
  have hqk := mul_le_mul_of_nonneg_left hkenergy
    (by positivity : 0 ≤ (1 + 1 / t) * ‖a‖ ^ 2)
  have hyenergy' : (⟪ι v, M v⟫_ℂ).re ≤
      (1 + t) * Q + (1 + 1 / t) * ‖a‖ ^ 2 * delta := by
    change (⟪ι v, M v⟫_ℂ).re ≤ _ at hyenergy
    dsimp [Q]
    linarith
  have hqvmul := mul_le_mul_of_nonneg_left hyenergy'
    (by positivity : 0 ≤ (1 + s) * C)
  have hG2 := mul_le_mul_of_nonneg_left
    (pow_le_pow_left₀ (norm_nonneg _) hG 2)
    (by positivity : 0 ≤ (1 + 1 / s) * ‖a‖ ^ 2)
  have hcore : ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤ (1 + s) * (1 + t) * C * Q + B * ‖a‖ ^ 2 := by
    dsimp [B]
    nlinarith
  calc
    _ ≤ (1 + s) * (1 + t) * C * Q + B * ‖a‖ ^ 2 := hcore
    _ ≤ (1 + s) * (1 + t) * C * Q + B * (eps ^ 2 * Q / kp) :=
      add_le_add_left (mul_le_mul_of_nonneg_left ha2 hB) _
    _ = _ := by dsimp [B, Q, kp]; ring

/-- A root-free scale criterion. Under eps^2*(kappa/2+delta)<=kappa/4,
the genuine complement retains at least kappa/4 and its readout coefficient
is bounded by 8*C+8*eps^2*G^2/kappa. Thus the additional normalized scale cost
is quadratic in eps and contains no full-model residual rho. -/
theorem positive_form_uniform_readout_bound
    (ι M : E →ₗ[ℂ] H) (k e : E) (g : H) (kappa delta eps C G : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (hpositive : ∀ f : E, 0 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hk : ‖ι k‖ = 1) (hkenergy : (⟪ι k, M k⟫_ℂ).re ≤ delta)
    (hkappa : 0 < kappa) (heps : 0 ≤ eps) (hd : ‖ι e - ι k‖ ≤ eps)
    (hcoercive : ∀ f : E, ⟪ι k, ι f⟫_ℂ = 0 →
      kappa * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hC : 0 ≤ C) (hG : ‖⟪g, ι k⟫_ℂ‖ ≤ G)
    (hreadout : ∀ f : E, ⟪ι k, ι f⟫_ℂ = 0 →
      ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤ C * (⟪ι f, M f⟫_ℂ).re)
    (hangle : eps ^ 2 * (kappa / 2 + delta) ≤ kappa / 4) :
    ∀ f : E, ⟪ι e, ι f⟫_ℂ = 0 →
      (kappa / 4) * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re ∧
      ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤ (8 * C + 8 * eps ^ 2 * G ^ 2 / kappa) *
        (⟪ι f, M f⟫_ℂ).re := by
  intro f hf
  let kp := kappa * (1 - eps ^ 2) / 2 - delta * eps ^ 2
  have hdelta : 0 ≤ delta := (hpositive k).trans hkenergy
  have hkp : kappa / 4 ≤ kp := by dsimp [kp]; nlinarith
  have hkp0 : 0 < kp := lt_of_lt_of_le (by positivity) hkp
  have hgap := positive_form_complement_coercivity ι M k e kappa delta eps 1
    hsym hpositive hk hkenergy hkappa.le heps (by norm_num) hd hcoercive f hf
  have hgap' : kp * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re := by
    simpa only [one_add_one_eq_two, div_one] using hgap
  have hr := positive_form_readout_transport ι M k e g kappa delta eps 1 1 C G
    hsym hpositive hk hkenergy hkappa.le heps (by norm_num) (by norm_num) hd hcoercive
    hC hG hreadout (by simpa only [one_add_one_eq_two, div_one] using hkp0) f hf
  have hr' : ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤
      (4 * C + eps ^ 2 / kp * (4 * C * delta + 2 * G ^ 2)) *
        (⟪ι f, M f⟫_ℂ).re := by
    simpa only [one_add_one_eq_two, div_one, one_div_one,
      show (2 : ℝ) * 2 = 4 by norm_num] using hr
  have hepd : eps ^ 2 * delta ≤ kp := by
    have hnon := mul_nonneg (sq_nonneg eps) hkappa.le
    nlinarith
  have hratio : eps ^ 2 * delta / kp ≤ 1 := (div_le_iff₀ hkp0).mpr (by simpa using hepd)
  have hlast : 2 * eps ^ 2 * G ^ 2 / kp ≤ 2 * eps ^ 2 * G ^ 2 / (kappa / 4) :=
    div_le_div_of_nonneg_left (by positivity) (by positivity) hkp
  have hcap : 4 * C + eps ^ 2 / kp * (4 * C * delta + 2 * G ^ 2) ≤
      8 * C + 8 * eps ^ 2 * G ^ 2 / kappa := by
    calc
      _ = 4 * C + 4 * C * (eps ^ 2 * delta / kp) + 2 * eps ^ 2 * G ^ 2 / kp := by ring
      _ ≤ 4 * C + 4 * C + 2 * eps ^ 2 * G ^ 2 / (kappa / 4) := by
        have hc := mul_le_mul_of_nonneg_left hratio (by positivity : 0 ≤ 4 * C)
        linarith
      _ = _ := by field_simp [hkappa.ne']; ring
  exact ⟨(mul_le_mul_of_nonneg_right hkp (sq_nonneg _)).trans hgap',
    hr'.trans (mul_le_mul_of_nonneg_right hcap (hpositive f))⟩

/-- Exact arithmetic on the existing c=3 certificates. This certifies the
new scalar implications only: it does not reprove the original global
spectral lower bound, candidate energy or genuine-model approximation. -/
theorem prime_three_positive_form_budget :
    let ell : ℝ := 2252813807 / 40960000000000000
    let kappa := 3 / 250000 - ell
    let delta := 560909 / 10000000000000 - ell
    let eps : ℝ := 113 / 100000
    let t : ℝ := 1 / 100000
    let s : ℝ := 1 / 10000
    let kp := kappa * (1 - eps ^ 2) / (1 + t) - delta * eps ^ 2 / t
    let C := (1 + s) * (1 + t) * 103 + eps ^ 2 / kp *
      ((1 + s) * (1 + 1 / t) * 103 * delta + (1 + 1 / s) * (1 / 500 : ℝ) ^ 2)
    kappa * (99997 / 100000) < kp ∧ C < 5151 / 50 ∧
      (929549 / 15625000000000 - ell) * (5151 / 50) < (681 / 1000000 : ℝ) ^ 2 := by
  norm_num

#print axioms positive_form_complement_coercivity
#print axioms positive_form_readout_transport
#print axioms positive_form_uniform_readout_bound
#print axioms prime_three_positive_form_budget

end D5.S3.Weil.GroundMode.GenuineModelDualTransport
end
