/- GID: D5/S3/Weil/GroundMode/GenuineModelDualTransport
   generality: G
   mirror-B: D5/B/S3/Weil/GroundMode/GenuineModelDualTransport
   mirror-E: none(waiver:domain-level-recentering-with-complete-residual)
   anchors: []
   digest: Transfer candidate-complement coercivity and complete dual trials to a nearby genuine model with arbitrary Fourier support. -/

import D5.S3.Weil.ZetaBridge.WeilProjectiveRayleighCapture
import Mathlib.Topology.UniformSpace.UniformConvergence
import Mathlib.Topology.MetricSpace.Pseudo.Basic
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


/-!
## Model-annihilating readouts and a single normalized scale budget

For the ratio L_z(f)/L_0(f), the exact relevant linear readout is
L_z - (L_z(e)/L_0(e)) L_0. It annihilates the SAME genuine model e.
Keeping this identity avoids separately paying the old candidate readout G.
The centered dual coefficient must be certified for this new readout; the
old uncentered coefficient is not silently reused.
-/

open Filter
open scoped Topology
open D5.S3.Weil.ZetaBridge.WeilProjectiveRayleighCapture

/-- Center the actual two readouts against the genuine model. Both the exact
annihilation and the normalized-error identity retain the complex conjugation
required by the first, conjugate-linear argument of the inner product. -/
theorem model_centered_readout_identity (g0 g e : H)
    (he0 : ⟪g0, e⟫_ℂ ≠ 0) :
    let h := g - conj (⟪g, e⟫_ℂ / ⟪g0, e⟫_ℂ) • g0
    ⟪h, e⟫_ℂ = 0 ∧ ∀ p : H, ⟪g0, p⟫_ℂ ≠ 0 →
      ⟪g, p⟫_ℂ / ⟪g0, p⟫_ℂ - ⟪g, e⟫_ℂ / ⟪g0, e⟫_ℂ =
        ⟪h, p⟫_ℂ / ⟪g0, p⟫_ℂ := by
  dsimp only
  simp only [inner_sub_left, inner_smul_left, Complex.conj_conj]
  constructor
  · rw [div_mul_cancel₀ _ he0, sub_self]
  · intro p hp
    field_simp [hp, he0]
    <;> ring

/-- Transport an energy-dual readout which annihilates e. Hyperplane
elimination preserves that readout exactly, so there is no additive G term.
The supplied new-complement bound can be obtained by the positive-form
coercivity theorem above; the next theorem performs that derivation. -/
theorem annihilating_energy_dual_transport
    (ι M : E →ₗ[ℂ] H) (k e : E) (g : H) (eps nu kap t C : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (hpositive : ∀ f : E, 0 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hk : ‖ι k‖ = 1) (heps : 0 ≤ eps) (heps1 : eps < 1)
    (hd : ‖ι e - ι k‖ ≤ eps) (heenergy : (⟪ι e, M e⟫_ℂ).re ≤ nu)
    (hkap : 0 < kap) (ht : 0 < t) (hC : 0 ≤ C)
    (hgap : ∀ f : E, ⟪ι e, ι f⟫_ℂ = 0 →
      kap * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hzero : ⟪g, ι e⟫_ℂ = 0)
    (hdual : ∀ f : E, ⟪ι k, ι f⟫_ℂ = 0 →
      ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤ C * (⟪ι f, M f⟫_ℂ).re) :
    ∀ f : E, ⟪ι e, ι f⟫_ℂ = 0 →
      ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤
        ((1 + t) + (1 + 1 / t) * (eps / (1 - eps)) ^ 2 * (nu / kap)) * C *
          (⟪ι f, M f⟫_ℂ).re := by
  intro f hf
  let alpha : ℂ := ⟪ι k, ι e⟫_ℂ
  let beta : ℂ := ⟪ι k, ι f⟫_ℂ / alpha
  let v : E := f - beta • e
  let Q : ℝ := (⟪ι f, M f⟫_ℂ).re
  have hnu : 0 ≤ nu := (hpositive e).trans heenergy
  have hden : 0 < 1 - eps := by linarith
  have halower : 1 - eps ≤ ‖alpha‖ := candidate_overlap_floor (ι k) (ι e) eps hk hd
  have ha : alpha ≠ 0 := norm_pos_iff.mp (lt_of_lt_of_le hden halower)
  have hv : ⟪ι k, ι v⟫_ℂ = 0 := by
    simp only [v, map_sub, map_smul, inner_sub_right, inner_smul_right]
    change ⟪ι k, ι f⟫_ℂ - (⟪ι k, ι f⟫_ℂ / alpha) * alpha = 0
    rw [div_mul_cancel₀ _ ha, sub_self]
  have hsame : ⟪g, ι v⟫_ℂ = ⟪g, ι f⟫_ℂ := by
    simp only [v, map_sub, map_smul, inner_sub_right, inner_smul_right,
      hzero, mul_zero, sub_zero]
  have hnum := near_orthogonal_overlap (ι e) (ι k) (ι f) eps
    (by simpa only [norm_sub_rev] using hd) hf
  have hb : ‖beta‖ ≤ (eps / (1 - eps)) * ‖ι f‖ := by
    rw [beta, norm_div]
    calc
      _ ≤ (eps * ‖ι f‖) / ‖alpha‖ :=
        div_le_div_of_nonneg_right hnum (norm_nonneg _)
      _ ≤ (eps * ‖ι f‖) / (1 - eps) :=
        div_le_div_of_nonneg_left (mul_nonneg heps (norm_nonneg _)) hden halower
      _ = _ := by ring
  have hnorm : ‖ι f‖ ^ 2 ≤ Q / kap := by
    apply (le_div_iff₀ hkap).mpr
    simpa only [mul_comm] using hgap f hf
  have hb2 : ‖beta‖ ^ 2 ≤ (eps / (1 - eps)) ^ 2 * (Q / kap) := by
    calc
      _ ≤ ((eps / (1 - eps)) * ‖ι f‖) ^ 2 :=
        pow_le_pow_left₀ (norm_nonneg _) hb 2
      _ = (eps / (1 - eps)) ^ 2 * ‖ι f‖ ^ 2 := by ring
      _ ≤ _ := mul_le_mul_of_nonneg_left hnorm (sq_nonneg _)
  have henergy := positive_energy_young ι M hsym hpositive f e beta t ht
  change (⟪ι v, M v⟫_ℂ).re ≤ _ at henergy
  have hm1 := mul_le_mul_of_nonneg_left heenergy
    (by positivity : 0 ≤ (1 + 1 / t) * ‖beta‖ ^ 2)
  have hm2 := mul_le_mul_of_nonneg_left hb2
    (by positivity : 0 ≤ (1 + 1 / t) * nu)
  have hq : (⟪ι v, M v⟫_ℂ).re ≤
      ((1 + t) + (1 + 1 / t) * (eps / (1 - eps)) ^ 2 * (nu / kap)) * Q := by
    have hh : (⟪ι v, M v⟫_ℂ).re ≤
        (1 + t) * Q + (1 + 1 / t) * nu * ((eps / (1 - eps)) ^ 2 * (Q / kap)) := by
      change (⟪ι v, M v⟫_ℂ).re ≤ (1 + t) * Q +
        (1 + 1 / t) * ‖beta‖ ^ 2 * (⟪ι e, M e⟫_ℂ).re at henergy
      nlinarith only [henergy, hm1, hm2]
    calc
      _ ≤ _ := hh
      _ = _ := by ring
  have hr := hdual v hv
  rw [hsame] at hr
  calc
    _ ≤ C * (⟪ι v, M v⟫_ℂ).re := hr
    _ ≤ C * (((1 + t) + (1 + 1 / t) * (eps / (1 - eps)) ^ 2 * (nu / kap)) * Q) :=
      mul_le_mul_of_nonneg_left hq hC
    _ = _ := by dsimp [Q]; ring

/-- A uniform root-free centered bound. The same old positive-form angle
condition gives the new gap, while low model energy gives a multiplicative
4C bound. No independent candidate readout G or model graph norm occurs. -/
theorem positive_form_centered_readout_bound
    (ι M : E →ₗ[ℂ] H) (k e : E) (g : H) (kappa delta eps nu C : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (hpositive : ∀ f : E, 0 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hk : ‖ι k‖ = 1) (hkenergy : (⟪ι k, M k⟫_ℂ).re ≤ delta)
    (heenergy : (⟪ι e, M e⟫_ℂ).re ≤ nu)
    (hkappa : 0 < kappa) (heps : 0 ≤ eps) (hepshalf : eps ≤ 1 / 2)
    (hd : ‖ι e - ι k‖ ≤ eps) (hnu : nu ≤ kappa / 4) (hC : 0 ≤ C)
    (hcoercive : ∀ f : E, ⟪ι k, ι f⟫_ℂ = 0 →
      kappa * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hzero : ⟪g, ι e⟫_ℂ = 0)
    (hdual : ∀ f : E, ⟪ι k, ι f⟫_ℂ = 0 →
      ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤ C * (⟪ι f, M f⟫_ℂ).re)
    (hangle : eps ^ 2 * (kappa / 2 + delta) ≤ kappa / 4) :
    ∀ f : E, ⟪ι e, ι f⟫_ℂ = 0 →
      (kappa / 4) * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re ∧
      ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤ 4 * C * (⟪ι f, M f⟫_ℂ).re := by
  have hden : 0 < 1 - eps := by linarith
  have hdelta : 0 ≤ delta := (hpositive k).trans hkenergy
  have hgap : ∀ f : E, ⟪ι e, ι f⟫_ℂ = 0 →
      (kappa / 4) * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re := by
    intro f hf
    have hg := positive_form_complement_coercivity ι M k e kappa delta eps 1
      hsym hpositive hk hkenergy hkappa.le heps (by norm_num) hd hcoercive f hf
    norm_num at hg
    have hkp : kappa / 4 ≤ kappa * (1 - eps ^ 2) / 2 - delta * eps ^ 2 := by
      nlinarith
    exact (mul_le_mul_of_nonneg_right hkp (sq_nonneg _)).trans hg
  have hrel0 : 0 ≤ eps / (1 - eps) := div_nonneg heps hden.le
  have hrel : eps / (1 - eps) ≤ 1 := (div_le_iff₀ hden).mpr (by linarith)
  have hrel2 : (eps / (1 - eps)) ^ 2 ≤ 1 := by nlinarith
  have hnu0 : 0 ≤ nu := (hpositive e).trans heenergy
  have hnu1 : nu / (kappa / 4) ≤ 1 := (div_le_iff₀ (by positivity)).mpr (by simpa using hnu)
  have hproduct : (eps / (1 - eps)) ^ 2 * (nu / (kappa / 4)) ≤ 1 := by
    simpa only [one_mul] using
      (mul_le_mul hrel2 hnu1 (by positivity) (by norm_num : (0 : ℝ) ≤ 1))
  intro f hf
  have hr := annihilating_energy_dual_transport ι M k e g eps nu (kappa / 4) 1 C
    hsym hpositive hk heps (by linarith) hd heenergy (by positivity) (by norm_num) hC
    hgap hzero hdual f hf
  have hcoef : ((1 + (1 : ℝ)) + (1 + 1 / (1 : ℝ)) * (eps / (1 - eps)) ^ 2 *
      (nu / (kappa / 4))) ≤ 4 := by nlinarith
  exact ⟨hgap f hf, hr.trans (mul_le_mul_of_nonneg_right
    (mul_le_mul_of_nonneg_right hcoef hC) (hpositive f))⟩

private theorem projective_ratio_from_centered_dual
    (ι M : E →ₗ[ℂ] H) (e u : E) (g0 g : H) (nu kap lam B b : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (hpositive : ∀ f : E, 0 ≤ (⟪ι f, M f⟫_ℂ).re)
    (he : ‖ι e‖ = 1) (hu : ι u ≠ 0)
    (heigen : M u = (lam : ℂ) • ι u)
    (hlam0 : 0 ≤ lam) (hlam : lam < kap)
    (heenergy : (⟪ι e, M e⟫_ℂ).re ≤ nu) (hnu : nu < kap)
    (hgap : ∀ f : E, ⟪ι e, ι f⟫_ℂ = 0 →
      kap * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hB : 0 ≤ B) (hb : 0 < b) (hanchor : b ≤ ‖⟪g0, ι e⟫_ℂ‖)
    (hanchorError : ‖g0‖ ^ 2 * nu ≤ kap * (‖⟪g0, ι e⟫_ℂ‖ - b) ^ 2)
    (hdual : ∀ f : E, ⟪ι e, ι f⟫_ℂ = 0 →
      ‖⟪g - conj (⟪g, ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ) • g0, ι f⟫_ℂ‖ ^ 2 ≤
        B * (⟪ι f, M f⟫_ℂ).re) :
    ⟪g0, ι u⟫_ℂ ≠ 0 ∧
      ‖⟪g, ι u⟫_ℂ / ⟪g0, ι u⟫_ℂ - ⟪g, ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ‖ ^ 2 ≤
        B * nu / b ^ 2 := by
  obtain ⟨ha, _, _, _, hnorm, _, hless⟩ :=
    projective_rayleigh_enclosure ι M e u 0 nu kap lam hsym he hu heigen
      hlam0 hlam heenergy hnu hgap
  let alpha := ⟪ι e, ι u⟫_ℂ
  let p : E := alpha⁻¹ • u
  let w : E := p - e
  let h : H := g - conj (⟪g, ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ) • g0
  have hkap : 0 < kap := lt_of_le_of_lt hlam0 hlam
  have hnu0 : 0 ≤ nu := (hpositive e).trans heenergy
  obtain ⟨horth, henergy⟩ := projective_error_energy_identity ι M e u lam hsym he heigen ha
  have hnorm1 : ‖ι w‖ ^ 2 ≤ 1 := (hnorm.trans_lt hless).le
  have hq : (⟪ι w, M w⟫_ℂ).re ≤ nu := by
    have hm := mul_le_mul_of_nonneg_left hnorm1 hlam0
    change (⟪ι w, M w⟫_ℂ).re = _ at henergy
    linarith
  have hgapw := (hgap w horth).trans hq
  have hdecomp : ι p = ι e + ι w := by
    simp only [w, map_sub]
    module
  have he0 : ⟪g0, ι e⟫_ℂ ≠ 0 := norm_pos_iff.mp (hb.trans_le hanchor)
  obtain ⟨hhzero, hhid⟩ := model_centered_readout_identity g0 g (ι e) he0
  have hnoise : ‖⟪g0, ι w⟫_ℂ‖ ≤ ‖⟪g0, ι e⟫_ℂ‖ - b := by
    have hn := pow_le_pow_left₀ (norm_nonneg _) (norm_inner_le_norm g0 (ι w)) 2
    rw [mul_pow] at hn
    have hm1 := mul_le_mul_of_nonneg_left hn hkap.le
    have hm2 := mul_le_mul_of_nonneg_left hgapw (sq_nonneg ‖g0‖)
    have hs : kap * ‖⟪g0, ι w⟫_ℂ‖ ^ 2 ≤ kap * (‖⟪g0, ι e⟫_ℂ‖ - b) ^ 2 := by
      nlinarith
    have hs' := (mul_le_mul_left hkap).mp hs
    nlinarith [norm_nonneg ⟪g0, ι w⟫_ℂ]
  have hpbound : b ≤ ‖⟪g0, ι p⟫_ℂ‖ := by
    have ht := norm_sub_norm_le ⟪g0, ι e⟫_ℂ (-⟪g0, ι w⟫_ℂ)
    rw [norm_neg, sub_neg_eq_add] at ht
    rw [hdecomp, inner_add_right]
    linarith
  have hp0 : ⟪g0, ι p⟫_ℂ ≠ 0 := norm_pos_iff.mp (hb.trans_le hpbound)
  have hsame : ⟪h, ι p⟫_ℂ = ⟪h, ι w⟫_ℂ := by
    rw [hdecomp, inner_add_right]
    change ⟪h, ι e⟫_ℂ = 0 at hhzero
    rw [hhzero, zero_add]
  have hnum : ‖⟪h, ι p⟫_ℂ‖ ^ 2 ≤ B * nu := by
    rw [hsame]
    exact (hdual w horth).trans (mul_le_mul_of_nonneg_left hq hB)
  have hrp : ‖⟪g, ι p⟫_ℂ / ⟪g0, ι p⟫_ℂ - ⟪g, ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ‖ ^ 2 ≤
      B * nu / b ^ 2 := by
    rw [hhid (ι p) hp0, norm_div, div_pow]
    calc
      _ ≤ B * nu / ‖⟪g0, ι p⟫_ℂ‖ ^ 2 :=
        div_le_div_of_nonneg_right hnum (sq_nonneg _)
      _ ≤ _ := div_le_div_of_nonneg_left (mul_nonneg hB hnu0) (sq_pos_of_pos hb)
        (pow_le_pow_left₀ hb.le hpbound 2)
  have hraw0 : ⟪g0, ι u⟫_ℂ ≠ 0 := by
    intro hz
    apply hp0
    simp only [p, map_smul, inner_smul_right, hz, mul_zero]
  have hrat : ⟪g, ι p⟫_ℂ / ⟪g0, ι p⟫_ℂ = ⟪g, ι u⟫_ℂ / ⟪g0, ι u⟫_ℂ := by
    simp only [p, map_smul, inner_smul_right]
    exact mul_div_mul_left _ _ (inv_ne_zero ha)
  exact ⟨hraw0, by simpa only [hrat] using hrp⟩

/-- Actual eigenvector ratios with a derived nonzero denominator. The old
energy-dual certificate must concern the model-centered readout, not g alone.
The factor is multiplicative; no separate old candidate-readout error appears.
Spectral placement, model energy and the full origin-kernel norm are explicit. -/
theorem model_centered_projective_ratio_bound
    (ι M : E →ₗ[ℂ] H) (k e u : E) (g0 g : H) (eps nu kap lam t C b : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (hpositive : ∀ f : E, 0 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hk : ‖ι k‖ = 1) (he : ‖ι e‖ = 1) (hu : ι u ≠ 0)
    (heigen : M u = (lam : ℂ) • ι u) (hlam0 : 0 ≤ lam) (hlam : lam < kap)
    (heps : 0 ≤ eps) (heps1 : eps < 1) (hd : ‖ι e - ι k‖ ≤ eps)
    (heenergy : (⟪ι e, M e⟫_ℂ).re ≤ nu) (hnu : nu < kap)
    (hgap : ∀ f : E, ⟪ι e, ι f⟫_ℂ = 0 →
      kap * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re)
    (ht : 0 < t) (hC : 0 ≤ C) (hb : 0 < b) (hanchor : b ≤ ‖⟪g0, ι e⟫_ℂ‖)
    (hanchorError : ‖g0‖ ^ 2 * nu ≤ kap * (‖⟪g0, ι e⟫_ℂ‖ - b) ^ 2)
    (hdual : ∀ f : E, ⟪ι k, ι f⟫_ℂ = 0 →
      ‖⟪g - conj (⟪g, ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ) • g0, ι f⟫_ℂ‖ ^ 2 ≤
        C * (⟪ι f, M f⟫_ℂ).re) :
    ⟪g0, ι u⟫_ℂ ≠ 0 ∧
      ‖⟪g, ι u⟫_ℂ / ⟪g0, ι u⟫_ℂ - ⟪g, ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ‖ ^ 2 ≤
        (((1 + t) + (1 + 1 / t) * (eps / (1 - eps)) ^ 2 * (nu / kap)) * C) * nu / b ^ 2 := by
  have hkap : 0 < kap := lt_of_le_of_lt hlam0 hlam
  have hnu0 : 0 ≤ nu := (hpositive e).trans heenergy
  have he0 : ⟪g0, ι e⟫_ℂ ≠ 0 := norm_pos_iff.mp (hb.trans_le hanchor)
  have hz := (model_centered_readout_identity g0 g (ι e) he0).1
  have hdnew := annihilating_energy_dual_transport ι M k e
    (g - conj (⟪g, ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ) • g0) eps nu kap t C
    hsym hpositive hk heps heps1 hd heenergy hkap ht hC hgap hz hdual
  exact projective_ratio_from_centered_dual ι M e u g0 g nu kap lam
    (((1 + t) + (1 + 1 / t) * (eps / (1 - eps)) ^ 2 * (nu / kap)) * C) b
    hsym hpositive he hu heigen hlam0 hlam heenergy hnu hgap (by positivity) hb
    hanchor hanchorError hdnew

/-- A normalized, moving-domain single-rate theorem. The old full-residual
coefficients are for the EXACT model-centered readout on the target set.
The denominator is proved nonzero from the stated squared anchor margin.
Neither an uncentered coefficient nor a pre-assumed normalized error bound
is substituted. The actual arithmetic single-rate hypothesis remains to be
proved for the intended unbounded Weil/prolate family. -/
theorem model_centered_normalized_uniform_limit
    {Z : Type*} (K : Set Z)
    {Hs Es : ℕ → Type*}
    [∀ n, NormedAddCommGroup (Hs n)] [∀ n, InnerProductSpace ℂ (Hs n)]
    [∀ n, AddCommGroup (Es n)] [∀ n, Module ℂ (Es n)]
    (ι M : ∀ n, Es n →ₗ[ℂ] Hs n) (k e u : ∀ n, Es n)
    (g0 : ∀ n, Hs n) (g : ∀ n, Z → Hs n)
    (kappa delta eps nu lam C b : ℕ → ℝ)
    (hsym : ∀ n x y, ⟪ι n x, M n y⟫_ℂ = ⟪M n x, ι n y⟫_ℂ)
    (hpositive : ∀ n f, 0 ≤ (⟪ι n f, M n f⟫_ℂ).re)
    (hk : ∀ n, ‖ι n (k n)‖ = 1) (he : ∀ n, ‖ι n (e n)‖ = 1)
    (hu : ∀ n, ι n (u n) ≠ 0)
    (heigen : ∀ n, M n (u n) = (lam n : ℂ) • ι n (u n))
    (hlam0 : ∀ n, 0 ≤ lam n) (hlam : ∀ n, lam n < kappa n / 4)
    (hkappa : ∀ n, 0 < kappa n)
    (hkenergy : ∀ n, (⟪ι n (k n), M n (k n)⟫_ℂ).re ≤ delta n)
    (heenergy : ∀ n, (⟪ι n (e n), M n (e n)⟫_ℂ).re ≤ nu n)
    (hnu : ∀ n, nu n < kappa n / 4)
    (heps : ∀ n, 0 ≤ eps n) (hepshalf : ∀ n, eps n ≤ 1 / 2)
    (hd : ∀ n, ‖ι n (e n) - ι n (k n)‖ ≤ eps n)
    (hcoercive : ∀ n f, ⟪ι n (k n), ι n f⟫_ℂ = 0 →
      kappa n * ‖ι n f‖ ^ 2 ≤ (⟪ι n f, M n f⟫_ℂ).re)
    (hangle : ∀ n, eps n ^ 2 * (kappa n / 2 + delta n) ≤ kappa n / 4)
    (hC : ∀ n, 0 ≤ C n) (hb : ∀ n, 0 < b n)
    (hanchor : ∀ n, b n ≤ ‖⟪g0 n, ι n (e n)⟫_ℂ‖)
    (hanchorError : ∀ n, ‖g0 n‖ ^ 2 * nu n ≤
      (kappa n / 4) * (‖⟪g0 n, ι n (e n)⟫_ℂ‖ - b n) ^ 2)
    (hdual : ∀ n z, z ∈ K → ∀ f : Es n, ⟪ι n (k n), ι n f⟫_ℂ = 0 →
      ‖⟪g n z - conj (⟪g n z, ι n (e n)⟫_ℂ / ⟪g0 n, ι n (e n)⟫_ℂ) • g0 n,
        ι n f⟫_ℂ‖ ^ 2 ≤ C n * (⟪ι n f, M n f⟫_ℂ).re)
    (hrate : Filter.Tendsto (fun n => nu n * C n / b n ^ 2)
      Filter.atTop (nhds 0)) :
    TendstoUniformlyOn (fun n z =>
      ⟪g n z, ι n (u n)⟫_ℂ / ⟪g0 n, ι n (u n)⟫_ℂ -
      ⟪g n z, ι n (e n)⟫_ℂ / ⟪g0 n, ι n (e n)⟫_ℂ)
      (fun _ => 0) Filter.atTop K := by
  apply Metric.tendstoUniformlyOn_iff.mpr
  intro eta heta
  have hscaled : Filter.Tendsto (fun n => 4 * (nu n * C n / b n ^ 2))
      Filter.atTop (nhds 0) := by simpa using hrate.const_mul 4
  filter_upwards [(tendsto_order.mp hscaled).2 (eta ^ 2) (sq_pos_of_pos heta)]
      with n hn z hz
  have he0 : ⟪g0 n, ι n (e n)⟫_ℂ ≠ 0 := norm_pos_iff.mp ((hb n).trans_le (hanchor n))
  have hzero := (model_centered_readout_identity (g0 n) (g n z) (ι n (e n)) he0).1
  have htransfer := positive_form_centered_readout_bound (ι n) (M n) (k n) (e n)
    (g n z - conj (⟪g n z, ι n (e n)⟫_ℂ / ⟪g0 n, ι n (e n)⟫_ℂ) • g0 n)
    (kappa n) (delta n) (eps n) (nu n) (C n) (hsym n) (hpositive n)
    (hk n) (hkenergy n) (heenergy n) (hkappa n) (heps n) (hepshalf n)
    (hd n) (hnu n).le (hC n) (hcoercive n) hzero (hdual n z hz) (hangle n)
  have hbound := (projective_ratio_from_centered_dual (ι n) (M n) (e n) (u n)
    (g0 n) (g n z) (nu n) (kappa n / 4) (lam n) (4 * C n) (b n)
    (hsym n) (hpositive n) (he n) (hu n) (heigen n) (hlam0 n) (hlam n)
    (heenergy n) (hnu n) (fun f hf => (htransfer f hf).1)
    (mul_nonneg (by norm_num) (hC n))
    (hb n) (hanchor n) (hanchorError n) (fun f hf => (htransfer f hf).2)).2
  have hsq : ‖⟪g n z, ι n (u n)⟫_ℂ / ⟪g0 n, ι n (u n)⟫_ℂ -
      ⟪g n z, ι n (e n)⟫_ℂ / ⟪g0 n, ι n (e n)⟫_ℂ‖ ^ 2 < eta ^ 2 := by
    have heq : (4 * C n) * nu n / b n ^ 2 = 4 * (nu n * C n / b n ^ 2) := by ring
    rw [heq] at hbound
    exact hbound.trans_lt hn
  have hnlt : ‖⟪g n z, ι n (u n)⟫_ℂ / ⟪g0 n, ι n (u n)⟫_ℂ -
      ⟪g n z, ι n (e n)⟫_ℂ / ⟪g0 n, ι n (e n)⟫_ℂ‖ < eta := by
    nlinarith [norm_nonneg (⟪g n z, ι n (u n)⟫_ℂ / ⟪g0 n, ι n (u n)⟫_ℂ -
      ⟪g n z, ι n (e n)⟫_ℂ / ⟪g0 n, ι n (e n)⟫_ℂ)]
  simpa only [dist_zero_left, dist_zero_right] using hnlt

/-- Exact arithmetic for the archived c=3 centered certificate. The separate
interval/model inputs must still prove C<108, the model-origin floor and
log(3)<11/10. This statement does not attest those analytic inputs. -/
theorem prime_three_centered_budget :
    let ell : ℝ := 2252813807 / 40960000000000000
    let delta := 560909 / 10000000000000 - ell
    let kappa := 3 / 250000 - ell
    let nu := 929549 / 15625000000000 - ell
    let eps : ℝ := 113 / 100000
    let s : ℝ := 1 / 100000
    let t : ℝ := 1 / 50000
    let kp := kappa * (1 - eps ^ 2) / (1 + s) - delta * eps ^ 2 / s
    let factor := (1 + t) + (1 + 1 / t) * (eps / (1 - eps)) ^ 2 * (nu / kp)
    0 < nu ∧ nu < kp ∧ factor < 20001 / 20000 ∧
      (11 / 10 : ℝ) * nu < kp * (805 / 1000 - 39 / 50) ^ 2 ∧
      factor * 108 * nu / (39 / 50 : ℝ) ^ 2 < (9 / 10000 : ℝ) ^ 2 := by
  norm_num

#print axioms model_centered_readout_identity
#print axioms annihilating_energy_dual_transport
#print axioms positive_form_centered_readout_bound
#print axioms model_centered_projective_ratio_bound
#print axioms model_centered_normalized_uniform_limit
#print axioms prime_three_centered_budget


/-!
## Signed primal--dual defects for the same centered observable

The previous energy coefficient gives a robust sufficient rate. This section
keeps the complex residual pairing before taking a norm. Its remainder is a
product of the actual projective error and a complete dual residual, including
the independently bounded eigenvalue-shift uncertainty. No Galerkin
orthogonality, exact inverse, or discarded high-frequency residual is assumed.

The method is classical goal-oriented residual correction. Compare Wu--Zhang,
arXiv:2607.23850v1, Section 4, for corrected outputs with product remainders.
Their elliptic PDE hypotheses are not asserted for the Weil realization.
-/

/-- Repairing a trial along a unit Rayleigh model leaves its pairing with
the FULL model residual unchanged. Symmetry rewrites that pairing using the
actual action on the original trial. No finite-support claim is made for
either action. Symmetry derives the zero imaginary part of the Rayleigh pairing. -/
theorem model_repair_preserves_residual_pairing
    (ι M : E →ₗ[ℂ] H) (e v : E) (mu : ℝ) (beta : ℂ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (he : ‖ι e‖ = 1) (hmu : (⟪ι e, M e⟫_ℂ).re = mu) :
    ⟪ι (v - beta • e), M e - (mu : ℂ) • ι e⟫_ℂ =
      ⟪M v, ι e⟫_ℂ - (mu : ℂ) * ⟪ι v, ι e⟫_ℂ := by
  have hdiag : ⟪ι e, M e⟫_ℂ = (mu : ℂ) := by
    have hc : ⟪ι e, M e⟫_ℂ = conj ⟪ι e, M e⟫_ℂ :=
      (hsym e e).trans (inner_conj_symm (M e) (ι e)).symm
    have hi := congrArg Complex.im hc
    simp only [Complex.conj_im] at hi
    apply Complex.ext
    · simpa only [Complex.ofReal_re] using hmu
    · simp only [Complex.ofReal_im]
      linarith
  have hr : ⟪ι e, M e - (mu : ℂ) • ι e⟫_ℂ = 0 := by
    rw [inner_sub_right, inner_smul_right, hdiag, unit_self (ι e) he,
      mul_one, sub_self]
  rw [map_sub, map_smul, inner_sub_left, inner_smul_left, hr,
    mul_zero, sub_zero, inner_sub_right, inner_smul_right, hsym v e]

/-- Exact signed output identity for a domain eigenvector p aligned with e.
The arbitrary real shift sigma need not equal the unknown eigenvalue.
Its difference from lam is retained. The dual residual is projected only
because the actual error p-e is e-orthogonal, not because it is truncated. -/
theorem centered_goal_residual_identity
    (ι M : E →ₗ[ℂ] H) (e p v : E) (h : H) (lam sigma : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (heigen : M p = (lam : ℂ) • ι p)
    (hv : ⟪ι e, ι v⟫_ℂ = 0) (hzero : ⟪h, ι e⟫_ℂ = 0)
    (horth : ⟪ι e, ι (p - e)⟫_ℂ = 0) :
    let r := M e - (sigma : ℂ) • ι e
    let s := h - (M v - (sigma : ℂ) • ι v)
    ⟪h, ι p⟫_ℂ + ⟪ι v, r⟫_ℂ =
      ⟪s - ⟪ι e, s⟫_ℂ • ι e, ι (p - e)⟫_ℂ +
        ((lam - sigma : ℝ) : ℂ) * ⟪ι v, ι (p - e)⟫_ℂ := by
  let w : E := p - e
  let r := M e - (sigma : ℂ) • ι e
  let s := h - (M v - (sigma : ℂ) • ι v)
  have hve : ⟪ι v, ι e⟫_ℂ = 0 := inner_eq_zero_symm.mp hv
  have hMw : ⟪ι v, M w⟫_ℂ =
      (lam : ℂ) * ⟪ι v, ι w⟫_ℂ - ⟪ι v, r⟫_ℂ := by
    simp only [w, r, map_sub, heigen, inner_sub_right, inner_smul_right,
      hve, mul_zero, sub_zero]
  have hread : ⟪h, ι w⟫_ℂ = ⟪h, ι p⟫_ℂ := by
    simp only [w, map_sub, inner_sub_right, hzero, sub_zero]
  have hproj : ⟪s - ⟪ι e, s⟫_ℂ • ι e, ι w⟫_ℂ = ⟪s, ι w⟫_ℂ := by
    rw [inner_sub_left, inner_smul_left]
    change ⟪s, ι w⟫_ℂ - _ * ⟪ι e, ι (p - e)⟫_ℂ = _
    rw [horth, mul_zero, sub_zero]
  have hdual : ⟪s, ι w⟫_ℂ =
      ⟪h, ι p⟫_ℂ - ⟪ι v, M w⟫_ℂ + (sigma : ℂ) * ⟪ι v, ι w⟫_ℂ := by
    simp only [s, inner_sub_left, inner_smul_left, Complex.conj_ofReal]
    rw [← hsym v w, hread]
    ring
  change ⟪h, ι p⟫_ℂ + ⟪ι v, r⟫_ℂ =
    ⟪s - ⟪ι e, s⟫_ℂ • ι e, ι w⟫_ℂ +
      ((lam - sigma : ℝ) : ℂ) * ⟪ι v, ι w⟫_ℂ
  rw [hproj, hdual, hMw, Complex.ofReal_sub]
  ring

/-- The exact complex correction is -<v,r>. The certified disk around it
has radius (S+eta*V)*R. S is the norm bound for the COMPLETE projected dual
residual, eta bounds the real eigenvalue uncertainty, and R bounds the
actual error. No model residual norm is substituted for its signed pairing. -/
theorem centered_goal_residual_bound
    (ι M : E →ₗ[ℂ] H) (e p v : E) (h : H) (lam sigma S eta V R : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (heigen : M p = (lam : ℂ) • ι p)
    (hv : ⟪ι e, ι v⟫_ℂ = 0) (hzero : ⟪h, ι e⟫_ℂ = 0)
    (horth : ⟪ι e, ι (p - e)⟫_ℂ = 0)
    (hS : let s := h - (M v - (sigma : ℂ) • ι v)
      ‖s - ⟪ι e, s⟫_ℂ • ι e‖ ≤ S)
    (heta : |lam - sigma| ≤ eta) (hV : ‖ι v‖ ≤ V)
    (hR : ‖ι (p - e)‖ ≤ R) :
    ‖⟪h, ι p⟫_ℂ + ⟪ι v, M e - (sigma : ℂ) • ι e⟫_ℂ‖ ≤
      (S + eta * V) * R := by
  let s := h - (M v - (sigma : ℂ) • ι v)
  let w : E := p - e
  have hS0 : 0 ≤ S := (norm_nonneg _).trans hS
  have heta0 : 0 ≤ eta := (abs_nonneg _).trans heta
  have hV0 : 0 ≤ V := (norm_nonneg _).trans hV
  have hR0 : 0 ≤ R := (norm_nonneg _).trans hR
  have hfirst : ‖⟪s - ⟪ι e, s⟫_ℂ • ι e, ι w⟫_ℂ‖ ≤ S * R :=
    (norm_inner_le_norm _ _).trans (mul_le_mul hS hR (norm_nonneg _) hS0)
  have hsecond : ‖((lam - sigma : ℝ) : ℂ) * ⟪ι v, ι w⟫_ℂ‖ ≤ eta * (V * R) := by
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs]
    exact mul_le_mul heta ((norm_inner_le_norm _ _).trans
      (mul_le_mul hV hR (norm_nonneg _) hV0)) (norm_nonneg _) heta0
  rw [centered_goal_residual_identity ι M e p v h lam sigma hsym heigen hv hzero horth]
  exact (norm_add_le _ _).trans (by nlinarith only [hfirst, hsecond])

/-- Normalize the signed correction by the MODEL origin, which is known.
The denominator perturbation contributes a second product term and is not
silently replaced by the model value. Both actual and model anchors are
proved nonzero from b+G0*R<=b0<=|<g0,e>|. The p here is an actual aligned
eigenvector; the next consumer constructs it from an arbitrary eigenvector. -/
theorem centered_goal_corrected_ratio_bound
    (ι M : E →ₗ[ℂ] H) (e p v : E) (g0 g : H)
    (lam sigma S eta V R G0 b b0 : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (heigen : M p = (lam : ℂ) • ι p)
    (he : ‖ι e‖ = 1) (hpe : ⟪ι e, ι p⟫_ℂ = 1)
    (hv : ⟪ι e, ι v⟫_ℂ = 0)
    (hR : ‖ι (p - e)‖ ≤ R) (hV : ‖ι v‖ ≤ V)
    (heta : |lam - sigma| ≤ eta) (hG0 : ‖g0‖ ≤ G0)
    (hb : 0 < b) (hb0 : 0 < b0)
    (hmodel : b0 ≤ ‖⟪g0, ι e⟫_ℂ‖) (hanchor : b + G0 * R ≤ b0)
    (hS : let h := g - conj (⟪g, ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ) • g0
      let s := h - (M v - (sigma : ℂ) • ι v)
      ‖s - ⟪ι e, s⟫_ℂ • ι e‖ ≤ S) :
    ⟪g0, ι p⟫_ℂ ≠ 0 ∧
      ‖⟪g, ι p⟫_ℂ / ⟪g0, ι p⟫_ℂ - ⟪g, ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ +
        ⟪ι v, M e - (sigma : ℂ) • ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ‖ ≤
        (S + eta * V) * R / b +
          ‖⟪ι v, M e - (sigma : ℂ) • ι e⟫_ℂ‖ * G0 * R / (b0 * b) := by
  let de := ⟪g0, ι e⟫_ℂ
  let dp := ⟪g0, ι p⟫_ℂ
  let h := g - conj (⟪g, ι e⟫_ℂ / de) • g0
  let D := ⟪ι v, M e - (sigma : ℂ) • ι e⟫_ℂ
  have hG00 : 0 ≤ G0 := (norm_nonneg _).trans hG0
  have hR0 : 0 ≤ R := (norm_nonneg _).trans hR
  have hde : de ≠ 0 := norm_pos_iff.mp (hb0.trans_le hmodel)
  have horth : ⟪ι e, ι (p - e)⟫_ℂ = 0 := by
    rw [map_sub, inner_sub_right, hpe, unit_self (ι e) he, sub_self]
  have hdelta : ‖dp - de‖ ≤ G0 * R := by
    change ‖⟪g0, ι p⟫_ℂ - ⟪g0, ι e⟫_ℂ‖ ≤ _
    rw [← inner_sub_right, ← map_sub]
    exact (norm_inner_le_norm _ _).trans
      (mul_le_mul hG0 hR (norm_nonneg _) hG00)
  have hdpbound : b ≤ ‖dp‖ := by
    have ht := norm_sub_norm_le de dp
    rw [norm_sub_rev] at ht
    linarith
  have hdp : dp ≠ 0 := norm_pos_iff.mp (hb.trans_le hdpbound)
  obtain ⟨hz, hratio⟩ := model_centered_readout_identity g0 g (ι e) hde
  have hrem := centered_goal_residual_bound ι M e p v h lam sigma S eta V R
    hsym heigen hv hz horth hS heta hV hR
  have hS0 : 0 ≤ S := (norm_nonneg _).trans hS
  have heta0 : 0 ≤ eta := (abs_nonneg _).trans heta
  have hV0 : 0 ≤ V := (norm_nonneg _).trans hV
  have hiden : ⟪g, ι p⟫_ℂ / dp - ⟪g, ι e⟫_ℂ / de + D / de =
      (⟪h, ι p⟫_ℂ + D) / dp + D * (dp - de) / (de * dp) := by
    rw [hratio (ι p) hdp]
    change ⟪h, ι p⟫_ℂ / dp + D / de = _
    field_simp [hde, hdp]
    <;> ring
  have hfirst : ‖(⟪h, ι p⟫_ℂ + D) / dp‖ ≤ (S + eta * V) * R / b := by
    rw [norm_div]
    exact (div_le_div_of_nonneg_right hrem (norm_nonneg dp)).trans
      (div_le_div_of_nonneg_left (by positivity) hb hdpbound)
  have hsecond : ‖D * (dp - de) / (de * dp)‖ ≤ ‖D‖ * G0 * R / (b0 * b) := by
    rw [norm_div, norm_mul, norm_mul]
    have hden := mul_le_mul hmodel hdpbound hb.le (norm_nonneg de)
    calc
      _ ≤ (‖D‖ * (G0 * R)) / (‖de‖ * ‖dp‖) :=
        div_le_div_of_nonneg_right
          (mul_le_mul_of_nonneg_left hdelta (norm_nonneg D)) (by positivity)
      _ ≤ (‖D‖ * (G0 * R)) / (b0 * b) :=
        div_le_div_of_nonneg_left (by positivity) (mul_pos hb0 hb) hden
      _ = _ := by ring
  refine ⟨hdp, ?_⟩
  change ‖⟪g, ι p⟫_ℂ / dp - ⟪g, ι e⟫_ℂ / de + D / de‖ ≤ _
  rw [hiden]
  exact (norm_add_le _ _).trans (add_le_add hfirst hsecond)

/-- Construct the aligned eigenvector and its norm-error radius using the
existing Rayleigh enclosure, then consume the signed correction theorem.
Every occurrence of the target mode is the actual u. The complete dual
residual and signed model pairing remain quantities to certify, not a
supplied desired output estimate. The corrected model's own limiting
correction must vanish before identifying its limit with the original model. -/
theorem projective_goal_corrected_ratio_bound
    (ι M : E →ₗ[ℂ] H) (e u v : E) (g0 g : H)
    (lam nu kap sigma S eta V R G0 b b0 : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (he : ‖ι e‖ = 1) (hu : ι u ≠ 0)
    (heigen : M u = (lam : ℂ) • ι u)
    (hlam0 : 0 ≤ lam) (hlam : lam < kap)
    (heenergy : (⟪ι e, M e⟫_ℂ).re ≤ nu) (hnu : nu < kap)
    (hgap : ∀ f : E, ⟪ι e, ι f⟫_ℂ = 0 →
      kap * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hR0 : 0 ≤ R) (hR : nu ≤ kap * R ^ 2)
    (hv : ⟪ι e, ι v⟫_ℂ = 0) (hV : ‖ι v‖ ≤ V)
    (heta : |lam - sigma| ≤ eta) (hG0 : ‖g0‖ ≤ G0)
    (hb : 0 < b) (hb0 : 0 < b0)
    (hmodel : b0 ≤ ‖⟪g0, ι e⟫_ℂ‖) (hanchor : b + G0 * R ≤ b0)
    (hS : let h := g - conj (⟪g, ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ) • g0
      let s := h - (M v - (sigma : ℂ) • ι v)
      ‖s - ⟪ι e, s⟫_ℂ • ι e‖ ≤ S) :
    ⟪g0, ι u⟫_ℂ ≠ 0 ∧
      ‖⟪g, ι u⟫_ℂ / ⟪g0, ι u⟫_ℂ - ⟪g, ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ +
        ⟪ι v, M e - (sigma : ℂ) • ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ‖ ≤
        (S + eta * V) * R / b +
          ‖⟪ι v, M e - (sigma : ℂ) • ι e⟫_ℂ‖ * G0 * R / (b0 * b) := by
  obtain ⟨ha, _, _, _, hnorm, _, _⟩ := projective_rayleigh_enclosure ι M e u
    0 nu kap lam hsym he hu heigen hlam0 hlam heenergy hnu hgap
  let alpha := ⟪ι e, ι u⟫_ℂ
  let p : E := alpha⁻¹ • u
  have hkap : 0 < kap := lt_of_le_of_lt hlam0 hlam
  have hnorm' : ‖ι (p - e)‖ ^ 2 ≤ nu / kap := by simpa only [sub_zero] using hnorm
  have hradius : ‖ι (p - e)‖ ≤ R := by
    have hh : nu / kap ≤ R ^ 2 := (div_le_iff₀ hkap).mpr (by simpa [mul_comm] using hR)
    nlinarith [hnorm'.trans hh, norm_nonneg (ι (p - e))]
  have hp : M p = (lam : ℂ) • ι p := by
    simp only [p, map_smul, heigen, smul_smul]
    rw [mul_comm (alpha⁻¹) (lam : ℂ)]
  have hpe : ⟪ι e, ι p⟫_ℂ = 1 := by
    simp only [p, map_smul, inner_smul_right]
    exact inv_mul_cancel₀ ha
  obtain ⟨hdp, hout⟩ := centered_goal_corrected_ratio_bound ι M e p v g0 g
    lam sigma S eta V R G0 b b0 hsym hp he hpe hv hradius hV heta hG0 hb hb0
    hmodel hanchor hS
  have hdu : ⟪g0, ι u⟫_ℂ ≠ 0 := by
    intro hz
    apply hdp
    simp only [p, map_smul, inner_smul_right, hz, mul_zero]
  have hrat : ⟪g, ι p⟫_ℂ / ⟪g0, ι p⟫_ℂ = ⟪g, ι u⟫_ℂ / ⟪g0, ι u⟫_ℂ := by
    simp only [p, map_smul, inner_smul_right]
    exact mul_div_mul_left _ _ (inv_ne_zero ha)
  exact ⟨hdu, by simpa only [hrat] using hout⟩

/-- A finite-head model pairing with both tails retained. The old finite
candidate is orthogonal to the action tail. Its distance to the true model
therefore bounds the tail pairing, while the separate model-approximation
error pays for replacing the head readout by a polynomial model. -/
theorem model_pairing_finite_head_bound (aHead aTail e eApprox k : H)
    (htail : ⟪aTail, k⟫_ℂ = 0) :
    ‖⟪aHead + aTail, e⟫_ℂ - ⟪aHead, eApprox⟫_ℂ‖ ≤
      ‖aTail‖ * ‖e - k‖ + ‖aHead‖ * ‖e - eApprox‖ := by
  have hid : ⟪aHead + aTail, e⟫_ℂ - ⟪aHead, eApprox⟫_ℂ =
      ⟪aTail, e - k⟫_ℂ + ⟪aHead, e - eApprox⟫_ℂ := by
    simp only [inner_add_left, inner_sub_right, htail, sub_zero]
    ring
  rw [hid]
  exact (norm_add_le _ _).trans
    (add_le_add (norm_inner_le_norm _ _) (norm_inner_le_norm _ _))

/-- Unit normalization and a certified captured head give an independent
upper bound on the entire model tail. The approximation radius is subtracted
before squaring. This is the finite-energy complement used by the numerical
pairing consumer; a small difference of two energies is not rounded inward. -/
theorem model_tail_sq_from_captured_head (eHead eTail approxHead : H) (gamma : ℝ)
    (hunit : ‖eHead + eTail‖ = 1) (horth : ⟪eHead, eTail⟫_ℂ = 0)
    (happrox : ‖eHead - approxHead‖ ≤ gamma)
    (hgamma : gamma ≤ ‖approxHead‖) :
    ‖eTail‖ ^ 2 ≤ 1 - (‖approxHead‖ - gamma) ^ 2 := by
  have hrev := norm_sub_norm_le approxHead eHead
  rw [norm_sub_rev] at hrev
  have hlow : ‖approxHead‖ - gamma ≤ ‖eHead‖ := by linarith
  have hsq := pow_le_pow_left₀ (sub_nonneg.mpr hgamma) hlow 2
  have hpy := norm_add_sq (𝕜 := ℂ) eHead eTail
  rw [hunit, horth] at hpy
  simp only [one_pow, Complex.zero_re, mul_zero, add_zero] at hpy
  linarith

/-- Exact rounded-budget consumer for the already identified c=3 data.
The scalar pairing interval, complete dual residual and inherited spectral
hypotheses remain independent premises of the analytic application. -/
theorem prime_three_goal_correction_budget :
    let ell : ℝ := 2252813807 / 40960000000000000
    let kap := 3 / 250000 - ell
    let delta := 560909 / 10000000000000 - ell
    let nu := 929549 / 15625000000000 - ell
    let eps : ℝ := 113 / 100000
    let kp := kap * (1 - eps ^ 2) / (1 + 1 / 100000) -
      delta * eps ^ 2 / (1 / 100000)
    let eta := delta / 2
    nu < kp * (194 / 10000 : ℝ) ^ 2 ∧
      784 / 1000 + (21 / 20 : ℝ) * (194 / 10000) ≤ 805 / 1000 ∧
      357 / 10000 + eta * 7 + eps * (13 / 1000) +
        eps * 7 * (458331 / 5000000000) < (3572 / 100000 : ℝ) ∧
      (3572 / 100000 + eta * 7) * (194 / 10000) / (784 / 1000) +
        (544 / 100000000 : ℝ) * (21 / 20) * (194 / 10000) /
          ((805 / 1000) * (784 / 1000)) +
        (6 / 1000000000 : ℝ) / (805 / 1000) < 885 / 1000000 ∧
      ((544 / 100000000 : ℝ) + (3572 / 100000 + eta * 7) *
        (194 / 10000)) / (784 / 1000) < 891 / 1000000 := by
  norm_num

#print axioms model_pairing_finite_head_bound
#print axioms model_tail_sq_from_captured_head
#print axioms prime_three_goal_correction_budget

#print axioms model_repair_preserves_residual_pairing
#print axioms centered_goal_residual_identity
#print axioms centered_goal_residual_bound
#print axioms centered_goal_corrected_ratio_bound
#print axioms projective_goal_corrected_ratio_bound

end D5.S3.Weil.GroundMode.GenuineModelDualTransport
end
