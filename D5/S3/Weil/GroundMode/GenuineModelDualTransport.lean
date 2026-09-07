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

end D5.S3.Weil.GroundMode.GenuineModelDualTransport
end
