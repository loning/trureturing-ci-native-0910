/- GID: D5/S3/Weil/ZetaBridge/WeilBoundaryKernelIntegral
   generality: I
   mirror-B: D5/B/S3/Weil/ZetaBridge/WeilBoundaryKernelIntegral
   mirror-E: none(waiver:singular-integral-identification-with-separate-operator-domain)
   anchors: []
   digest: Identify the original infinite arithmetic boundary symbol with its singular Gamma and pole integrals, and transport the identity to its exterior columns. -/

import D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingJet
import Mathlib.MeasureTheory.Integral.DominatedConvergence
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Tactic.FunProp
import Mathlib.Tactic.Omega

/-!
The target is the ORIGINAL arithmeticBoundarySymbol, including all Gamma
summands, both poles and the finite von Mangoldt sum. Its Gamma series was
already proved absolutely convergent by arithmetic_boundary_symbol_bound.
Here its equality to the paper's singular integral is proved, including the
integrability and limit interchange. The singular kernel is never integrated
alone. A pointwise value at zero is irrelevant for the Ioc integral.

The last theorem identifies couplingColumn with integrals of the divided
sine tests. It is an adapter of the new analytic identity. The canonical
Fourier convolution calculation, diagonal matrix entries, operator domain,
full-space coercivity and the actual ground/prolate comparison remain
separate. No substitute operator or spectral approximation is defined.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false
noncomputable section

namespace D5.S3.Weil.ZetaBridge.WeilBoundaryKernelIntegral

open MeasureTheory Set Filter
open scoped BigOperators Topology
open D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingJet

private def rho (t : ℝ) : ℝ := Real.exp (t / 2) / (Real.exp t - Real.exp (-t))
private def rate (j : ℕ) : ℝ := 2 * (j : ℝ) + 1 / 2
private def wave (L : ℝ) (n : ℤ) : ℝ := 2 * Real.pi * (n : ℝ) / L

private theorem rho_denominator {t : ℝ} (ht : 0 < t) :
    t ≤ Real.exp t - Real.exp (-t) ∧ 0 < Real.exp t - Real.exp (-t) := by
  have he : Real.exp (-t) ≤ 1 := Real.exp_le_one_iff.mpr (by linarith)
  have h : t ≤ Real.exp t - Real.exp (-t) := by
    linarith [Real.add_one_le_exp t]
  exact ⟨h, ht.trans_le h⟩

private theorem rho_nonneg {t : ℝ} (ht : 0 < t) : 0 ≤ rho t :=
  (div_pos (Real.exp_pos _) (rho_denominator ht).2).le

private theorem rho_sine_bound {L t : ℝ} (ht : 0 < t) (htL : t ≤ L) (w : ℝ) :
    |rho t * Real.sin (w * t)| ≤ |w| * Real.exp (L / 2) := by
  obtain ⟨hden, hd⟩ := rho_denominator ht
  have hs : |Real.sin (w * t)| ≤ |w| * t := by
    simpa only [abs_mul, abs_of_pos ht] using Real.abs_sin_le_abs (w * t)
  have hdiv : |Real.sin (w * t)| / (Real.exp t - Real.exp (-t)) ≤ |w| := by
    apply (div_le_iff₀ hd).mpr
    exact hs.trans (mul_le_mul_of_nonneg_left hden (abs_nonneg _))
  calc
    _ = Real.exp (t / 2) *
        (|Real.sin (w * t)| / (Real.exp t - Real.exp (-t))) := by
      rw [rho, abs_mul, abs_div, abs_of_pos (Real.exp_pos _), abs_of_pos hd]
      ring
    _ ≤ Real.exp (t / 2) * |w| :=
      mul_le_mul_of_nonneg_left hdiv (Real.exp_pos _).le
    _ ≤ Real.exp (L / 2) * |w| :=
      mul_le_mul_of_nonneg_right (Real.exp_le_exp.mpr (by linarith)) (abs_nonneg _)
    _ = _ := mul_comm _ _

/-- The sine factor regularizes the actual singular Gamma kernel on a finite
positive window. This proves integrability and a common pointwise majorant;
neither an improper-integrability premise nor a cutoff near zero is supplied. -/
theorem gamma_kernel_sine_integrable {L : ℝ} (hL : 0 < L) (w : ℝ) :
    IntegrableOn (fun t : ℝ =>
      Real.exp (t / 2) / (Real.exp t - Real.exp (-t)) * Real.sin (w * t)) (Ioc 0 L) ∧
    ∀ t ∈ Ioc (0 : ℝ) L,
      |Real.exp (t / 2) / (Real.exp t - Real.exp (-t)) * Real.sin (w * t)| ≤
        |w| * Real.exp (L / 2) := by
  have hm : Measurable (fun t : ℝ => rho t * Real.sin (w * t)) := by
    unfold rho
    fun_prop
  have hi : Integrable (fun _ : ℝ => |w| * Real.exp (L / 2))
      (volume.restrict (Ioc 0 L)) := integrable_const _
  refine ⟨hi.mono' hm.aestronglyMeasurable ?_, ?_⟩
  · filter_upwards [ae_restrict_mem measurableSet_Ioc] with t ht
    simpa only [Real.norm_eq_abs] using rho_sine_bound ht.1 ht.2 w
  · intro t ht
    exact rho_sine_bound ht.1 ht.2 w

private theorem geometric_kernel {t : ℝ} (ht : 0 < t) :
    HasSum (fun j : ℕ => Real.exp (-rate j * t)) (rho t) := by
  have hq : Real.exp (-2 * t) < 1 := Real.exp_lt_one_iff.mpr (by linarith)
  have hqn : ‖Real.exp (-2 * t)‖ < 1 := by
    simpa only [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)] using hq
  have he (j : ℕ) : Real.exp (-rate j * t) =
      Real.exp (-t / 2) * Real.exp (-2 * t) ^ j := by
    calc
      _ = Real.exp (-t / 2 + (j : ℝ) * (-2 * t)) := by
        congr 1
        unfold rate
        ring
      _ = _ := by rw [Real.exp_add, Real.exp_nat_mul]
  have h1 : Real.exp (-t / 2) * Real.exp t = Real.exp (t / 2) := by
    rw [← Real.exp_add]
    congr 1
    ring
  have h2 : Real.exp (-t / 2) * Real.exp (-t) =
      Real.exp (t / 2) * Real.exp (-2 * t) := by
    rw [← Real.exp_add, ← Real.exp_add]
    congr 1
    ring
  have hid : Real.exp (-t / 2) * (1 - Real.exp (-2 * t))⁻¹ = rho t := by
    rw [← div_eq_mul_inv, rho]
    apply (div_eq_div_iff (sub_ne_zero.mpr (ne_of_gt hq))
      (rho_denominator ht).2.ne').mpr
    rw [mul_sub, mul_sub, mul_one, h1, h2]
  have hg := (hasSum_geometric_of_norm_lt_one hqn).mul_left (Real.exp (-t / 2))
  rw [hid] at hg
  simpa only [he] using hg

private theorem partial_sine_bound {L t : ℝ} (ht : 0 < t) (htL : t ≤ L)
    (w : ℝ) (N : ℕ) :
    ‖∑ j ∈ Finset.range N, Real.exp (-rate j * t) * Real.sin (w * t)‖ ≤
      |w| * Real.exp (L / 2) := by
  have hg := geometric_kernel ht
  have hsum : (∑ j ∈ Finset.range N, Real.exp (-rate j * t)) ≤ rho t := by
    rw [← hg.tsum_eq]
    exact hg.summable.sum_le_tsum _ (fun _ _ => (Real.exp_pos _).le)
  have hn : 0 ≤ ∑ j ∈ Finset.range N, Real.exp (-rate j * t) :=
    Finset.sum_nonneg (fun _ _ => (Real.exp_pos _).le)
  calc
    _ = (∑ j ∈ Finset.range N, Real.exp (-rate j * t)) * |Real.sin (w * t)| := by
      rw [← Finset.sum_mul, Real.norm_eq_abs, abs_mul, abs_of_nonneg hn]
    _ ≤ rho t * |Real.sin (w * t)| :=
      mul_le_mul_of_nonneg_right hsum (abs_nonneg _)
    _ = |rho t * Real.sin (w * t)| := by
      rw [abs_mul, abs_of_nonneg (rho_nonneg ht)]
    _ ≤ _ := rho_sine_bound ht htL w

private theorem wave_endpoints {L : ℝ} (hL : 0 < L) (n : ℤ) :
    Real.sin (wave L n * L) = 0 ∧ Real.cos (wave L n * L) = 1 := by
  have hw : wave L n * L = (n : ℝ) * (2 * Real.pi) := by
    unfold wave
    field_simp [hL.ne']
    <;> ring
  have hc : Real.cos (wave L n * L) = 1 := by
    rw [hw]
    exact Real.cos_int_mul_two_pi n
  exact ⟨Real.sin_eq_zero_iff_cos_eq.mpr (Or.inl hc), hc⟩

private theorem laplace_sine_integral {L a w : ℝ}
    (hL : 0 ≤ L) (hd : a ^ 2 + w ^ 2 ≠ 0)
    (hs : Real.sin (w * L) = 0) (hc : Real.cos (w * L) = 1) :
    (∫ t : ℝ in Ioc 0 L, Real.exp (-a * t) * Real.sin (w * t)) =
      w * (1 - Real.exp (-a * L)) / (a ^ 2 + w ^ 2) := by
  let F : ℝ → ℝ := fun t =>
    Real.exp (-a * t) * (-a * Real.sin (w * t) - w * Real.cos (w * t)) /
      (a ^ 2 + w ^ 2)
  have hF (x : ℝ) : HasDerivAt F (Real.exp (-a * x) * Real.sin (w * x)) x := by
    have he := ((hasDerivAt_id x).const_mul (-a)).exp
    have hs' := ((hasDerivAt_id x).const_mul w).sin
    have hc' := ((hasDerivAt_id x).const_mul w).cos
    convert (he.mul ((hs'.const_mul (-a)).sub (hc'.const_mul w))).div_const
      (a ^ 2 + w ^ 2) using 1 <;>
      dsimp [F] <;> field_simp [hd] <;> ring
  have hi : IntervalIntegrable (fun t : ℝ => Real.exp (-a * t) * Real.sin (w * t))
      volume 0 L := (by fun_prop : Continuous _).intervalIntegrable 0 L
  rw [← intervalIntegral.integral_of_le hL,
    intervalIntegral.integral_eq_sub_of_hasDerivAt (fun x _ => hF x) hi]
  simp only [F, hs, hc, mul_zero, sub_zero, zero_sub, mul_one,
    Real.exp_zero, Real.sin_zero, Real.cos_zero, one_mul]
  ring

/-- Exact identification of the original absolutely convergent Gamma sine
series with its singular-kernel integral at every integer Fourier frequency.
Dominated convergence is justified by a finite-window constant, so no region
near the singular endpoint or tail summand is omitted. -/
theorem gamma_boundary_integral {c : ℕ} (hc : 2 ≤ c) (n : ℤ) :
    (∫ t : ℝ in Ioc 0 (Real.log (c : ℝ)),
      Real.exp (t / 2) / (Real.exp t - Real.exp (-t)) *
        Real.sin ((2 * Real.pi * (n : ℝ) / Real.log (c : ℝ)) * t)) =
      ∑' j : ℕ, (2 * Real.pi * (n : ℝ) / Real.log (c : ℝ)) *
        (1 - Real.exp (-(2 * (j : ℝ) + 1 / 2) * Real.log (c : ℝ))) /
        ((2 * (j : ℝ) + 1 / 2) ^ 2 + (2 * Real.pi * (n : ℝ) / Real.log (c : ℝ)) ^ 2) := by
  let L := Real.log (c : ℝ)
  let w := wave L n
  have hcR : (1 : ℝ) < (c : ℝ) := by exact_mod_cast (show 1 < c by omega)
  have hL : 0 < L := Real.log_pos hcR
  let F : ℕ → ℝ → ℝ := fun N t =>
    ∑ j ∈ Finset.range N, Real.exp (-rate j * t) * Real.sin (w * t)
  have hf : ∀ N, AEStronglyMeasurable (F N) (volume.restrict (Ioc 0 L)) := by
    intro N
    exact (by unfold F rate; fun_prop : Continuous _).aestronglyMeasurable
  have hlim : ∀ᵐ t ∂volume.restrict (Ioc 0 L),
      Tendsto (fun N => F N t) atTop (𝓝 (rho t * Real.sin (w * t))) := by
    filter_upwards [ae_restrict_mem measurableSet_Ioc] with t ht
    exact ((geometric_kernel ht.1).mul_right (Real.sin (w * t))).tendsto_sum_nat
  have hdom := MeasureTheory.tendsto_integral_of_dominated_convergence
    (μ := volume.restrict (Ioc 0 L)) (fun _ => |w| * Real.exp (L / 2)) hf
    (integrable_const _) (fun N => by
      filter_upwards [ae_restrict_mem measurableSet_Ioc] with t ht
      exact partial_sine_bound ht.1 ht.2 w N) hlim
  have hji (j : ℕ) : IntegrableOn
      (fun t : ℝ => Real.exp (-rate j * t) * Real.sin (w * t)) (Ioc 0 L) :=
    ((by fun_prop : Continuous _).intervalIntegrable 0 L).1
  obtain ⟨hs, hcos⟩ := wave_endpoints hL n
  have heval (N : ℕ) : (∫ t : ℝ in Ioc 0 L, F N t) =
      ∑ j ∈ Finset.range N, w * (1 - Real.exp (-rate j * L)) / (rate j ^ 2 + w ^ 2) := by
    rw [show F N = (fun t => ∑ j ∈ Finset.range N,
      Real.exp (-rate j * t) * Real.sin (w * t)) from rfl,
      MeasureTheory.integral_finsetSum _ (fun j _ => hji j)]
    apply Finset.sum_congr rfl
    intro j _
    apply laplace_sine_integral hL.le _ hs hcos
    have hr : 0 < rate j := by unfold rate; positivity
    positivity
  have habs := (arithmetic_boundary_symbol_bound hc n).1
  change Summable (fun j : ℕ =>
    ‖w * (1 - Real.exp (-rate j * L)) / (rate j ^ 2 + w ^ 2)‖) at habs
  have hseries := habs.of_norm.hasSum.tendsto_sum_nat
  simp_rw [heval] at hdom
  have hid := tendsto_nhds_unique hdom hseries
  simpa only [L, w, wave, rate, rho] using hid

private theorem pole_integral {L : ℝ} (hL : 0 < L) (n : ℤ) :
    (∫ t : ℝ in Ioc 0 L, 2 * Real.cosh (t / 2) * Real.sin (wave L n * t)) =
      -(2 * wave L n * (Real.cosh (L / 2) - 1) / (wave L n ^ 2 + 1 / 4)) := by
  obtain ⟨hs, hc⟩ := wave_endpoints hL n
  have hm := laplace_sine_integral (a := -(1 / 2 : ℝ)) hL.le (by positivity) hs hc
  have hp := laplace_sine_integral (a := (1 / 2 : ℝ)) hL.le (by positivity) hs hc
  have hi (a : ℝ) : IntegrableOn
      (fun t : ℝ => Real.exp (-a * t) * Real.sin (wave L n * t)) (Ioc 0 L) :=
    ((by fun_prop : Continuous _).intervalIntegrable 0 L).1
  have hfun : (fun t : ℝ => 2 * Real.cosh (t / 2) * Real.sin (wave L n * t)) =
      (fun t => Real.exp (-(-(1 / 2 : ℝ)) * t) * Real.sin (wave L n * t) +
        Real.exp (-(1 / 2 : ℝ) * t) * Real.sin (wave L n * t)) := by
    funext t
    have harg1 : -(-(1 / 2 : ℝ)) * t = t / 2 := by ring
    have harg2 : -(1 / 2 : ℝ) * t = -(t / 2) := by ring
    rw [harg1, harg2, Real.cosh_eq]
    ring
  rw [hfun, MeasureTheory.integral_add (hi _) (hi _), hm, hp, Real.cosh_eq]
  have hden : (-(1 / 2 : ℝ)) ^ 2 + wave L n ^ 2 = wave L n ^ 2 + 1 / 4 := by ring
  have hden' : (1 / 2 : ℝ) ^ 2 + wave L n ^ 2 = wave L n ^ 2 + 1 / 4 := by ring
  rw [hden, hden']
  have harg1 : -(-(1 / 2 : ℝ)) * L = L / 2 := by ring
  have harg2 : -(1 / 2 : ℝ) * L = -(L / 2) := by ring
  rw [harg1, harg2]
  ring

/-- The existing arithmeticBoundarySymbol is the actual pole-minus-Gamma
sine integral minus the unchanged finite prime sum. Integrability of the
combined singular integrand is derived. This identifies the original object;
it does not define a replacement symbol or assume the desired integral. -/
theorem arithmetic_boundary_symbol_integral {c : ℕ} (hc : 2 ≤ c) (n : ℤ) :
    IntegrableOn (fun t : ℝ =>
      (2 * Real.cosh (t / 2) - Real.exp (t / 2) / (Real.exp t - Real.exp (-t))) *
        Real.sin ((2 * Real.pi * (n : ℝ) / Real.log (c : ℝ)) * t))
      (Ioc 0 (Real.log (c : ℝ))) ∧
    arithmeticBoundarySymbol c n =
      (∫ t : ℝ in Ioc 0 (Real.log (c : ℝ)),
        (2 * Real.cosh (t / 2) - Real.exp (t / 2) / (Real.exp t - Real.exp (-t))) *
          Real.sin ((2 * Real.pi * (n : ℝ) / Real.log (c : ℝ)) * t)) -
      ∑ j ∈ Finset.range c, (ArithmeticFunction.vonMangoldt j / Real.sqrt j) *
        Real.sin ((2 * Real.pi * (n : ℝ) / Real.log (c : ℝ)) * Real.log j) := by
  let L := Real.log (c : ℝ)
  have hcR : (1 : ℝ) < (c : ℝ) := by exact_mod_cast (show 1 < c by omega)
  have hL : 0 < L := Real.log_pos hcR
  have hi : IntegrableOn (fun t : ℝ => 2 * Real.cosh (t / 2) *
      Real.sin (wave L n * t)) (Ioc 0 L) :=
    ((by fun_prop : Continuous _).intervalIntegrable 0 L).1
  have hg := (gamma_kernel_sine_integrable hL (wave L n)).1
  constructor
  · simpa only [sub_mul, L, wave] using hi.sub hg
  · have hp := pole_integral hL n
    have hgamma := gamma_boundary_integral hc n
    change arithmeticBoundarySymbol c n =
      (∫ t : ℝ in Ioc 0 L, (2 * Real.cosh (t / 2) - rho t) * Real.sin (wave L n * t)) - _
    simp_rw [sub_mul]
    rw [MeasureTheory.integral_sub hi hg, hp]
    change arithmeticBoundarySymbol c n =
      -(2 * wave L n * (Real.cosh (L / 2) - 1) / (wave L n ^ 2 + 1 / 4)) -
        (∫ t : ℝ in Ioc 0 L, rho t * Real.sin (wave L n * t)) - _
    rw [show (∫ t : ℝ in Ioc 0 L, rho t * Real.sin (wave L n * t)) = _ from hgamma]
    rfl

/-- Application to the original finite exterior column: every divided sine
integral is justified by the preceding integrability result. The output is
still the previously owned couplingColumn. This is an adapter, not a proof
of the canonical operator's domain or of its diagonal Fourier entries. -/
theorem coupling_column_kernel_integral {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v : ℤ → ℂ) (m : ℤ) (hout : m ∉ S) :
    couplingColumn c S v m = ∑ n ∈ S,
      (((∫ t : ℝ in Ioc 0 (Real.log (c : ℝ)),
          (2 * Real.cosh (t / 2) - Real.exp (t / 2) / (Real.exp t - Real.exp (-t))) *
          (Real.sin ((2 * Real.pi * (n : ℝ) / Real.log (c : ℝ)) * t) -
            Real.sin ((2 * Real.pi * (m : ℝ) / Real.log (c : ℝ)) * t)) /
          (Real.pi * ((m : ℝ) - (n : ℝ)))) -
        ∑ j ∈ Finset.range c, (ArithmeticFunction.vonMangoldt j / Real.sqrt j) *
          (Real.sin ((2 * Real.pi * (n : ℝ) / Real.log (c : ℝ)) * Real.log j) -
            Real.sin ((2 * Real.pi * (m : ℝ) / Real.log (c : ℝ)) * Real.log j)) /
          (Real.pi * ((m : ℝ) - (n : ℝ))) : ℝ) : ℂ) * v n := by
  unfold couplingColumn
  apply Finset.sum_congr rfl
  intro n hnS
  have hmn : m ≠ n := by
    intro h
    exact hout (h.symm ▸ hnS)
  have hd : (m : ℝ) - (n : ℝ) ≠ 0 := by
    apply sub_ne_zero.mpr
    exact_mod_cast hmn
  obtain ⟨hnint, hn⟩ := arithmetic_boundary_symbol_integral hc n
  obtain ⟨hmint, hm⟩ := arithmetic_boundary_symbol_integral hc m
  apply congrArg (fun r : ℝ => (r : ℂ) * v n)
  rw [hn, hm]
  simp_rw [mul_sub]
  rw [MeasureTheory.integral_div, MeasureTheory.integral_sub hnint hmint]
  rw [← Finset.sum_div, Finset.sum_sub_distrib]
  field_simp [Real.pi_ne_zero, hd]
  <;> ring

#print axioms gamma_boundary_integral
#print axioms arithmetic_boundary_symbol_integral
#print axioms coupling_column_kernel_integral

end D5.S3.Weil.ZetaBridge.WeilBoundaryKernelIntegral
