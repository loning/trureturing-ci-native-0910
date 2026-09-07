/- GID: D5/S3/Zeros/Endpoints/CanonicalLiLocalExpansion
   generality: I
   mirror-B: D5/B/S3/Zeros/Endpoints/CanonicalLiLocalExpansion
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Canonical Li derivatives give the local xi logarithmic derivative series. -/

import D5.S3.Zeros.Endpoints.FirstLiCoefficientPositivity
import D5.S3.Zeros.Endpoints.XiEndpointValues
import D5.S3.Zeros.Symmetry.ZetaConjugationCovariance
import Mathlib.Analysis.Complex.TaylorSeries
import Mathlib.Analysis.Calculus.Deriv.Star
import Mathlib.Analysis.SpecialFunctions.Complex.Analytic

/-!
The coefficients use the Li derivative definition. The planned content is the
all-order Mobius derivative transformation, followed by Taylor convergence.
Generality I is required by the xi-specific frozen imports (SL-010).
The preregistered escape witness is the coefficient identity for every n;
it is not an assumed Keiper-Li expansion. No atom closure or L2 is claimed.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

open Complex Filter Set
open scoped Topology BigOperators ComplexConjugate
open D5.S3.Zeros.CompletedZeta
open D5.S3.Zeros.Endpoints.FirstLiCoefficientPositivity
open D5.S3.Zeros.Endpoints.XiEndpointValues
open D5.S3.Zeros.Symmetry.ZetaConjugationCovariance

namespace D5.S3.Zeros.Endpoints.CanonicalLiLocalExpansion

private theorem analytic_iterated {f : ℂ → ℂ} {x : ℂ} (hf : AnalyticAt ℂ f x) (n : ℕ) :
    AnalyticAt ℂ (iteratedDeriv n f) x := by
  simpa only [iteratedDeriv_eq_iterate] using hf.iterated_deriv n

private theorem coordinate_mul_derivative {f : ℂ → ℂ} {x : ℂ}
    (hf : AnalyticAt ℂ f x) (n : ℕ) :
    iteratedDeriv (n + 1) (fun s => s * f s) x =
      x * iteratedDeriv (n + 1) f x + (n + 1 : ℂ) * iteratedDeriv n f x := by
  have hmul : (fun s => s * f s) = (fun s => f s * s) := by
    funext s
    exact mul_comm _ _
  rw [hmul, iteratedDeriv_fun_mul hf.contDiffAt (by fun_prop)]
  rw [Finset.sum_range_succ, Finset.sum_range_succ]
  have hzero : ∑ i ∈ Finset.range n,
      (n + 1).choose i * iteratedDeriv i f x *
        iteratedDeriv (n + 1 - i) (fun s : ℂ => s) x = 0 := by
    apply Finset.sum_eq_zero
    intro i hi
    have hi' : i < n := Finset.mem_range.mp hi
    simp [iteratedDeriv_fun_id, show n + 1 - i ≠ 0 by omega,
      show n + 1 - i ≠ 1 by omega]
  rw [hzero]
  simp [iteratedDeriv_fun_id, Nat.cast_add, Nat.cast_one]
  ring

private theorem mobius_hasDerivAt {z : ℂ} (hz : 1 - z ≠ 0) :
    HasDerivAt (fun w : ℂ => (1 - w)⁻¹) ((1 - z)⁻¹ ^ 2) z := by
  simpa [inv_pow] using
    (((hasDerivAt_const z (1 : ℂ)).sub (hasDerivAt_id z)).fun_inv hz)

private theorem mobius_iterated_derivative (n : ℕ) {f : ℂ → ℂ} {z : ℂ}
    (hz : 1 - z ≠ 0) (hf : AnalyticAt ℂ f ((1 - z)⁻¹)) :
    iteratedDeriv n (fun w => (1 - w)⁻¹ ^ 2 * deriv f ((1 - w)⁻¹)) z =
      (1 - z)⁻¹ ^ (n + 2) *
        iteratedDeriv (n + 1) (fun s => s ^ n * f s) ((1 - z)⁻¹) := by
  induction n generalizing z with
  | zero => simp
  | succ n ih =>
    have hp := mobius_hasDerivAt hz
    have heq :
        iteratedDeriv n (fun w => (1 - w)⁻¹ ^ 2 * deriv f ((1 - w)⁻¹)) =ᶠ[𝓝 z]
          (fun w => (1 - w)⁻¹ ^ (n + 2) *
            iteratedDeriv (n + 1) (fun s => s ^ n * f s) ((1 - w)⁻¹)) := by
      filter_upwards [hp.continuousAt.eventually hf.eventually_analyticAt,
        ((continuous_const.sub continuous_id).continuousAt.eventually_ne hz)] with w hw hn
      exact ih hn hw
    have hpoly : AnalyticAt ℂ (fun s => s ^ n * f s) ((1 - z)⁻¹) :=
      (analyticAt_id.pow n).mul hf
    have hd := ((analytic_iterated hpoly (n + 1)).differentiableAt.hasDerivAt).comp z hp
    rw [iteratedDeriv_succ, heq.deriv_eq]
    have hderiv := ((hp.fun_pow (n + 2)).fun_mul hd).deriv
    dsimp only [Function.comp_apply] at hderiv
    rw [hderiv]
    have hrec := coordinate_mul_derivative hpoly (n + 1)
    have hfun : (fun s => s * (s ^ n * f s)) = (fun s => s ^ (n + 1) * f s) := by
      funext s
      ring
    rw [hfun] at hrec
    rw [hrec]
    simp only [show n + 2 - 1 = n + 1 by omega, Nat.cast_add, Nat.cast_ofNat,
      ← iteratedDeriv_succ]
    ring

/-- Li's normalization, including the conventional zeroth coefficient. -/
def canonicalLiCoefficient : ℕ → ℝ
  | 0 => 0
  | n + 1 =>
      ((n.factorial : ℂ)⁻¹ *
        iteratedDeriv (n + 1) (fun s => s ^ n * Complex.log (xiReading s)) 1).re

/-- The logarithmic derivative after the Keiper-Li change of variable. -/
def liGenerator (z : ℂ) : ℂ :=
  (1 - z)⁻¹ ^ 2 * logDeriv xiReading ((1 - z)⁻¹)

private theorem xi_one_slitPlane : xiReading 1 ∈ Complex.slitPlane := by
  rw [xi_reading_endpoint_values.2]
  norm_num [Complex.mem_slitPlane_iff]

private theorem xi_log_analytic :
    AnalyticAt ℂ (fun s => Complex.log (xiReading s)) 1 :=
  (xi_reading_differentiable.analyticAt 1).clog xi_one_slitPlane

private theorem xi_log_derivative :
    deriv (fun s => Complex.log (xiReading s)) =ᶠ[𝓝 (1 : ℂ)] logDeriv xiReading := by
  have hs := xi_reading_differentiable.continuous.continuousAt.eventually
    (Complex.isOpen_slitPlane.mem_nhds xi_one_slitPlane)
  filter_upwards [hs] with s hs
  exact Complex.deriv_log_comp_eq_logDeriv (xi_reading_differentiable s) hs

private theorem generator_derivative_eq (n : ℕ) :
    iteratedDeriv n liGenerator 0 =
      iteratedDeriv (n + 1) (fun s => s ^ n * Complex.log (xiReading s)) 1 := by
  have hp := mobius_hasDerivAt (z := 0) (by norm_num)
  have heq : liGenerator =ᶠ[𝓝 (0 : ℂ)]
      (fun w => (1 - w)⁻¹ ^ 2 * deriv (fun s => Complex.log (xiReading s)) ((1 - w)⁻¹)) := by
    have hpt : Tendsto (fun w : ℂ => (1 - w)⁻¹) (𝓝 0) (𝓝 1) := by
      simpa only [ContinuousAt, sub_zero, inv_one] using hp.continuousAt
    have hlog := xi_log_derivative.comp_tendsto hpt
    filter_upwards [hlog] with w hw
    exact congrArg ((1 - w)⁻¹ ^ 2 * ·) hw.symm
  rw [heq.iteratedDeriv_eq n]
  simpa using mobius_iterated_derivative n (z := 0) (by norm_num)
    (by simpa using xi_log_analytic)

private theorem iterated_reflection {f : ℂ → ℂ}
    (hf : conj ∘ f ∘ conj = f) (n : ℕ) :
    conj ∘ iteratedDeriv n f ∘ conj = iteratedDeriv n f := by
  induction n with
  | zero => simpa using hf
  | succ n ih =>
    simpa only [iteratedDeriv_succ] using
      (deriv_conj_conj (f := iteratedDeriv n f)).symm.trans (congrArg deriv ih)

private theorem generator_reflection : conj ∘ liGenerator ∘ conj = liGenerator := by
  have hxi : conj ∘ xiReading ∘ conj = xiReading := by
    funext s
    simp [Function.comp_apply, xi_reading_conj]
  have hd := iterated_reflection hxi 1
  simp only [iteratedDeriv_one] at hd
  have hderiv (s : ℂ) : conj (deriv xiReading (conj s)) = deriv xiReading s :=
    congrFun hd s
  funext z
  simp only [Function.comp_apply, liGenerator, logDeriv_apply, map_mul, map_pow,
    map_inv₀, map_sub, map_one, Complex.conj_conj, map_div₀]
  rw [show (1 - conj z)⁻¹ = conj ((1 - z)⁻¹) by simp,
    hderiv, xi_reading_conj, Complex.conj_conj]

/-- The preregistered coefficient identity for every order, with the source Li definition. -/
theorem generator_taylor_coefficient (n : ℕ) :
    iteratedDeriv n liGenerator 0 / (n.factorial : ℂ) =
      (canonicalLiCoefficient (n + 1) : ℂ) := by
  have hc : conj (iteratedDeriv n liGenerator 0) = iteratedDeriv n liGenerator 0 := by
    simpa using congrFun (iterated_reflection generator_reflection n) 0
  have hreal : conj (iteratedDeriv n liGenerator 0 / (n.factorial : ℂ)) =
      iteratedDeriv n liGenerator 0 / (n.factorial : ℂ) := by
    simp only [map_div₀, hc, map_natCast]
  rw [canonicalLiCoefficient, ← generator_derivative_eq, ← div_eq_inv_mul]
  exact (Complex.conj_eq_iff_re.mp hreal).symm

private theorem generator_analytic : AnalyticAt ℂ liGenerator 0 := by
  have hxi := xi_reading_differentiable.analyticAt 1
  have hlog : AnalyticAt ℂ (logDeriv xiReading) 1 := by
    exact hxi.deriv.div hxi (by rw [xi_reading_endpoint_values.2]; norm_num)
  have hp : AnalyticAt ℂ (fun z : ℂ => (1 - z)⁻¹) 0 :=
    (analyticAt_const.sub analyticAt_id).inv (by norm_num)
  apply (hp.pow 2).mul
  exact (show AnalyticAt ℂ (logDeriv xiReading) ((1 - (0 : ℂ))⁻¹) by
    simpa using hlog).comp (f := fun z : ℂ => (1 - z)⁻¹) hp

/-- The canonical Li series converges to the transformed logarithmic derivative near zero. -/
theorem canonical_li_local_expansion :
    ∀ᶠ z : ℂ in 𝓝 0,
      HasSum (fun n => (canonicalLiCoefficient (n + 1) : ℂ) * z ^ n)
        ((1 - z) ^ (-2 : ℤ) * logDeriv xiReading (1 / (1 - z))) := by
  obtain ⟨r, hr, hball⟩ := generator_analytic.exists_ball_analyticOnNhd
  filter_upwards [Metric.ball_mem_nhds (0 : ℂ) hr] with z hz
  have hs := Complex.hasSum_taylorSeries_on_ball hball.differentiableOn hz
  have hsum : HasSum (fun n => (canonicalLiCoefficient (n + 1) : ℂ) * z ^ n)
      (liGenerator z) := by
    apply hs.congr_fun
    intro n
    rw [← generator_taylor_coefficient]
    simp only [sub_zero, smul_eq_mul, div_eq_mul_inv]
    ring
  simpa only [liGenerator, one_div, zpow_neg, zpow_ofNat, inv_pow] using hsum

/-- The conventional initial value used by downstream Li recurrences. -/
theorem canonical_li_zero : canonicalLiCoefficient 0 = 0 := rfl

/-- The first coefficient is exactly the closed form certified by the preceding layer. -/
theorem canonical_li_one :
    canonicalLiCoefficient 1 =
      1 + Real.eulerMascheroniConstant / 2 - Real.log (2 * Real.sqrt Real.pi) := by
  have hderiv := xi_log_derivative.eq_of_nhds
  rw [canonicalLiCoefficient]
  simp only [Nat.factorial_zero, Nat.cast_one, inv_one, pow_zero, one_mul, Nat.zero_add,
    iteratedDeriv_one, hderiv, logDeriv_apply]
  exact first_li_coefficient_eq_log_deriv_re.symm

/-- Positivity is imported from the preceding layer after identifying the canonical coefficient. -/
theorem canonical_li_one_pos : 0 < canonicalLiCoefficient 1 := by
  rw [canonical_li_one]
  exact first_li_coefficient_pos

#print axioms generator_taylor_coefficient
#print axioms canonical_li_local_expansion
#print axioms canonical_li_zero
#print axioms canonical_li_one
#print axioms canonical_li_one_pos

end D5.S3.Zeros.Endpoints.CanonicalLiLocalExpansion
