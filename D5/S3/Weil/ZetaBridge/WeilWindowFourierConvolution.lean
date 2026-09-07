/- GID: D5/S3/Weil/ZetaBridge/WeilWindowFourierConvolution
   generality: I
   mirror-B: D5/B/S3/Weil/ZetaBridge/WeilWindowFourierConvolution
   mirror-E: none(waiver:window-convolution-with-separate-canonical-operator-domain)
   anchors: []
   digest: Compute the actual zero-extended Fourier convolution, including its diagonal, and identify the existing arithmetic exterior columns with these tests. -/

import D5.S3.Weil.ZetaBridge.WeilBoundaryKernelIntegral
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Analysis.Complex.Trigonometric

/-!
CCM, Zeta Spectral Triples, Section 2.2, uses normalized Fourier functions
on [0,L], extended by zero to the real line. We choose the half-open (0,L]
representative. Its endpoint point values have no effect on the convolution
integrals and MUST NOT be interpreted as Sobolev boundary traces.

The product is the repository's existing Zeta23.EF.weilTest, with the first
and second arguments ordered so that windowCorrelation n m = U_n^* * U_m.
The overlap integral, its integrability, the reflected convolution, the
non-diagonal divided sine and the separate triangular diagonal are derived.
The final theorem consumes the existing singular-kernel identity and gives
its actual convolution tests. No Fourier inversion or completeness theorem
is re-proved, and no canonical operator domain or spectral gap is assumed
away by defining a new operator.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false
noncomputable section

namespace D5.S3.Weil.ZetaBridge.WeilWindowFourierConvolution

open MeasureTheory MeasureTheory.Measure Set
open scoped BigOperators ComplexConjugate
open D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingJet
open D5.S3.Weil.ZetaBridge.WeilBoundaryKernelIntegral

private def omega (L : ℝ) (n : ℤ) : ℂ :=
  2 * (Real.pi : ℂ) * (n : ℂ) * Complex.I / (L : ℂ)

private def tone (L : ℝ) (n : ℤ) (x : ℝ) : ℂ :=
  Complex.exp (omega L n * (x : ℂ))

/-- The normalized Fourier mode on (0,L], extended by zero. The half-open
choice only fixes a pointwise representative, not a boundary condition. -/
def windowFourierMode (L : ℝ) (n : ℤ) : ℝ → ℂ :=
  (Ioc (0 : ℝ) L).indicator (fun x =>
    Complex.exp ((2 * (Real.pi : ℂ) * (n : ℂ) * Complex.I / (L : ℂ)) * (x : ℂ)) /
      (Real.sqrt L : ℂ))

/-- The actual pre-existing convolution product, in the U_n^* * U_m order.
This definition contains no proposed formula for its value. -/
def windowCorrelation (L : ℝ) (n m : ℤ) : ℝ → ℂ :=
  Zeta23.EF.weilTest (windowFourierMode L m) (windowFourierMode L n)

private theorem correlation_integral (L : ℝ) (n m : ℤ) (y : ℝ) :
    windowCorrelation L n m y =
      ∫ x : ℝ, conj (windowFourierMode L n (x - y)) * windowFourierMode L m x := by
  change (∫ x : ℝ, windowFourierMode L m x *
    conj (windowFourierMode L n (-(y - x)))) = _
  apply integral_congr_ae
  filter_upwards [] with x
  rw [neg_sub, mul_comm]

private theorem tone_mul (L : ℝ) (n m : ℤ) (x : ℝ) :
    tone L n x * tone L (m - n) x = tone L m x := by
  unfold tone
  rw [← Complex.exp_add]
  congr 1
  unfold omega
  push_cast
  ring

private theorem tone_product (L : ℝ) (n m : ℤ) (x y : ℝ) :
    conj (tone L n (x - y)) * tone L m x = tone L n y * tone L (m - n) x := by
  unfold tone
  rw [← Complex.exp_conj, ← Complex.exp_add, ← Complex.exp_add]
  congr 1
  simp only [omega, map_mul, map_div₀, map_ofNat, Complex.conj_ofReal,
    map_intCast, Complex.conj_I, Int.cast_sub, Complex.ofReal_sub]
  ring

private theorem normalized_product {L : ℝ} (hL : 0 < L)
    (n m : ℤ) (x y : ℝ) :
    conj (tone L n (x - y) / (Real.sqrt L : ℂ)) *
      (tone L m x / (Real.sqrt L : ℂ)) =
      tone L n y * tone L (m - n) x / (L : ℂ) := by
  have hs : (Real.sqrt L : ℂ) * (Real.sqrt L : ℂ) = (L : ℂ) := by
    exact_mod_cast Real.mul_self_sqrt hL.le
  rw [map_div₀, Complex.conj_ofReal, div_mul_div_comm, hs, tone_product]

private theorem product_indicator {L : ℝ} (hL : 0 < L) (n m : ℤ) (y : ℝ) :
    (fun x : ℝ => conj (windowFourierMode L n (x - y)) * windowFourierMode L m x) =
      (Ioc (max 0 y) (min L (L + y))).indicator
        (fun x => tone L n y * tone L (m - n) x / (L : ℂ)) := by
  funext x
  by_cases hx : x ∈ Ioc (max 0 y) (min L (L + y))
  · have hxm : x ∈ Ioc (0 : ℝ) L :=
      ⟨lt_of_le_of_lt (le_max_left _ _) hx.1, hx.2.trans (min_le_left _ _)⟩
    have hxn : x - y ∈ Ioc (0 : ℝ) L := by
      have hlo := lt_of_le_of_lt (le_max_right 0 y) hx.1
      have hhi := hx.2.trans (min_le_right L (L + y))
      constructor <;> linarith
    simp only [windowFourierMode, Set.indicator_of_mem hxn, Set.indicator_of_mem hxm,
      Set.indicator_of_mem hx]
    exact normalized_product hL n m x y
  · rw [Set.indicator_of_notMem hx]
    by_cases hxm : x ∈ Ioc (0 : ℝ) L
    · have hxn : x - y ∉ Ioc (0 : ℝ) L := by
        intro h
        apply hx
        exact ⟨max_lt hxm.1 (by linarith [h.1]), le_min hxm.2 (by linarith [h.2])⟩
      simp [windowFourierMode, Set.indicator_of_notMem hxn]
    · simp [windowFourierMode, Set.indicator_of_notMem hxm]

/-- Every original convolution integral exists, for all real displacements.
The proof uses the actual intersection of the two finite supports, including
negative displacements and empty intersections. -/
theorem window_correlation_integrable {L : ℝ} (hL : 0 < L) (n m : ℤ) (y : ℝ) :
    Integrable (fun x : ℝ => conj (windowFourierMode L n (x - y)) * windowFourierMode L m x) := by
  rw [product_indicator hL n m y]
  apply (integrable_indicator_iff measurableSet_Ioc).mpr
  exact ((by unfold tone; fun_prop : Continuous
    (fun x : ℝ => tone L n y * tone L (m - n) x / (L : ℂ))).intervalIntegrable
      (max 0 y) (min L (L + y))).1

/-- The real-line convolution integrand is integrable, and its actual
intersection of supports is (y,L]. Both endpoint cases are included. -/
theorem window_correlation_overlap {L : ℝ} (hL : 0 < L) (n m : ℤ)
    {y : ℝ} (hy : 0 ≤ y) (hyL : y ≤ L) :
    Integrable (fun x : ℝ => conj (windowFourierMode L n (x - y)) * windowFourierMode L m x) ∧
      windowCorrelation L n m y =
        (∫ x : ℝ in y..L,
          Complex.exp ((2 * (Real.pi : ℂ) * (n : ℂ) * Complex.I / (L : ℂ)) * (y : ℂ)) *
          Complex.exp ((2 * (Real.pi : ℂ) * ((m - n : ℤ) : ℂ) * Complex.I / (L : ℂ)) *
            (x : ℂ)) / (L : ℂ)) := by
  have hprod := product_indicator hL n m y
  rw [max_eq_right hy, min_eq_left (by linarith : L ≤ L + y)] at hprod
  have hc : Continuous (fun x : ℝ => tone L n y * tone L (m - n) x / (L : ℂ)) := by
    unfold tone
    fun_prop
  have hi := (hc.intervalIntegrable y L).1
  refine ⟨?_, ?_⟩
  · rw [hprod]
    exact (integrable_indicator_iff measurableSet_Ioc).mpr hi
  · rw [correlation_integral, hprod, integral_indicator measurableSet_Ioc,
      ← intervalIntegral.integral_of_le hyL]
    rfl

/-- Reflection exchanges the two original convolution factors and conjugates.
It is proved by Haar translation and conjugation of the actual integral. -/
theorem window_correlation_reflection (L : ℝ) (n m : ℤ) (y : ℝ) :
    windowCorrelation L n m (-y) = conj (windowCorrelation L m n y) := by
  rw [correlation_integral, correlation_integral, ← Zeta23.EF.cintegral_conj]
  simp only [map_mul, starRingEnd_self_apply]
  have h := integral_add_right_eq_self
    (μ := volume) (fun x : ℝ => conj (windowFourierMode L n x) *
      windowFourierMode L m (x - y)) y
  simpa only [sub_neg_eq_add, add_sub_cancel_right, mul_comm] using h

/-- A common translation of the actual two zero-extended functions leaves
this convolution unchanged. In particular a=L/2 transports the formula from
(0,L] to the centered physical window without changing the matrix test. -/
theorem window_correlation_translate (L : ℝ) (n m : ℤ) (a y : ℝ) :
    Zeta23.EF.weilTest (fun x => windowFourierMode L m (x + a))
      (fun x => windowFourierMode L n (x + a)) y = windowCorrelation L n m y := by
  rw [correlation_integral]
  change (∫ x : ℝ, windowFourierMode L m (x + a) *
    conj (windowFourierMode L n (-(y - x) + a))) = _
  have h := integral_add_right_eq_self (μ := volume)
    (fun x : ℝ => conj (windowFourierMode L n (x - y)) * windowFourierMode L m x) a
  convert h using 1
  apply integral_congr_ae
  filter_upwards [] with x
  rw [neg_sub, show x - y + a = x + a - y by ring, mul_comm]

private theorem omega_ne_zero {L : ℝ} (hL : 0 < L) {n : ℤ} (hn : n ≠ 0) :
    omega L n ≠ 0 := by
  have hpi : (Real.pi : ℂ) ≠ 0 := Complex.ofReal_ne_zero.mpr Real.pi_ne_zero
  have hn' : (n : ℂ) ≠ 0 := by exact_mod_cast hn
  have hL' : (L : ℂ) ≠ 0 := Complex.ofReal_ne_zero.mpr hL.ne'
  exact div_ne_zero (mul_ne_zero (mul_ne_zero (mul_ne_zero (by norm_num) hpi) hn')
    Complex.I_ne_zero) hL'

private theorem tone_period {L : ℝ} (hL : 0 < L) (n : ℤ) : tone L n L = 1 := by
  have hL' : (L : ℂ) ≠ 0 := Complex.ofReal_ne_zero.mpr hL.ne'
  have harg : omega L n * (L : ℂ) = (n : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) := by
    unfold omega
    field_simp [hL']
    <;> ring
  rw [tone, harg, Complex.exp_int_mul_two_pi_mul_I]

private theorem off_diagonal_tone {L : ℝ} (hL : 0 < L) {n m : ℤ} (hnm : n ≠ m)
    {y : ℝ} (hy : 0 ≤ y) (hyL : y ≤ L) :
    windowCorrelation L n m y =
      (tone L n y - tone L m y) / (2 * (Real.pi : ℂ) * Complex.I * ((m : ℂ) - (n : ℂ))) := by
  have hd : m - n ≠ 0 := sub_ne_zero.mpr hnm.symm
  have hw := omega_ne_zero hL hd
  have hL' : (L : ℂ) ≠ 0 := Complex.ofReal_ne_zero.mpr hL.ne'
  rw [(window_correlation_overlap hL n m hy hyL).2]
  change (∫ x : ℝ in y..L, tone L n y * tone L (m - n) x / (L : ℂ)) = _
  have hfun : (fun x : ℝ => tone L n y * tone L (m - n) x / (L : ℂ)) =
      (fun x : ℝ => (tone L n y / (L : ℂ)) * Complex.exp (omega L (m - n) * x)) := by
    funext x
    dsimp [tone]
    ring
  rw [hfun, intervalIntegral.integral_const_mul, integral_exp_mul_complex hw]
  change (tone L n y / (L : ℂ)) *
      ((tone L (m - n) L - tone L (m - n) y) / omega L (m - n)) = _
  rw [tone_period hL]
  have hwD : (L : ℂ) * omega L (m - n) =
      2 * (Real.pi : ℂ) * Complex.I * ((m : ℂ) - (n : ℂ)) := by
    unfold omega
    push_cast
    field_simp [hL']
    <;> ring
  rw [div_mul_div_comm, mul_sub, mul_one, tone_mul, hwD]

private theorem diagonal_tone {L : ℝ} (hL : 0 < L) (n : ℤ)
    {y : ℝ} (hy : 0 ≤ y) (hyL : y ≤ L) :
    windowCorrelation L n n y = (1 - (y : ℂ) / (L : ℂ)) * tone L n y := by
  have hL' : (L : ℂ) ≠ 0 := Complex.ofReal_ne_zero.mpr hL.ne'
  rw [(window_correlation_overlap hL n n hy hyL).2]
  change (∫ x : ℝ in y..L, tone L n y * tone L (n - n) x / (L : ℂ)) = _
  simp only [sub_self, tone, omega, Int.cast_zero, mul_zero, zero_mul,
    zero_div, Complex.exp_zero, mul_one]
  rw [intervalIntegral.integral_const]
  simp only [Complex.real_smul, Complex.ofReal_sub]
  field_simp [hL']
  <;> ring

private theorem tone_real (L : ℝ) (n : ℤ) (y : ℝ) :
    (tone L n y).re = Real.cos (2 * Real.pi * (n : ℝ) * y / L) ∧
      (tone L n y).im = Real.sin (2 * Real.pi * (n : ℝ) * y / L) := by
  have heq : omega L n * (y : ℂ) =
      ((2 * Real.pi * (n : ℝ) * y / L : ℝ) : ℂ) * Complex.I := by
    unfold omega
    push_cast
    ring
  simp [tone, heq, Complex.exp_re, Complex.exp_im]

private theorem divided_even (a b : ℂ) (r : ℝ) (hr : r ≠ 0) :
    (a - b) / ((r : ℂ) * Complex.I) + conj ((a - b) / ((r : ℂ) * Complex.I)) =
      ((2 * (a.im - b.im) / r : ℝ) : ℂ) := by
  apply Complex.ext <;>
    simp [Complex.div_re, Complex.div_im, Complex.normSq_apply] <;>
    field_simp [hr] <;> ring

/-- Full CCM Lemma 2.3 on the positive half-window. The off-diagonal formula
and the triangular diagonal are both conclusions about the actual convolution.
The diagonal is not obtained by evaluating a totalized zero denominator. -/
theorem window_even_correlation_formula {L : ℝ} (hL : 0 < L) (n m : ℤ)
    {y : ℝ} (hy : 0 ≤ y) (hyL : y ≤ L) :
    windowCorrelation L n m y + windowCorrelation L n m (-y) =
      if n = m then
        ((2 * (1 - y / L) * Real.cos (2 * Real.pi * (n : ℝ) * y / L) : ℝ) : ℂ)
      else
        (((Real.sin (2 * Real.pi * (n : ℝ) * y / L) -
            Real.sin (2 * Real.pi * (m : ℝ) * y / L)) /
          (Real.pi * ((m : ℝ) - (n : ℝ))) : ℝ) : ℂ) := by
  rw [window_correlation_reflection]
  by_cases hnm : n = m
  · subst m
    rw [if_pos rfl]
    simp only [diagonal_tone hL n hy hyL]
    have hpref : (1 - (y : ℂ) / (L : ℂ)) = ((1 - y / L : ℝ) : ℂ) := by
      push_cast
      <;> rfl
    simp only [hpref]
    have ht := tone_real L n y
    apply Complex.ext <;>
      simp [Complex.mul_re, Complex.mul_im, ht.1, ht.2] <;> ring
  · rw [if_neg hnm, off_diagonal_tone hL hnm hy hyL,
      off_diagonal_tone hL hnm.symm hy hyL]
    have hmn : (m : ℝ) - (n : ℝ) ≠ 0 := by exact_mod_cast sub_ne_zero.mpr hnm.symm
    have hd1 : 2 * (Real.pi : ℂ) * Complex.I * ((m : ℂ) - (n : ℂ)) =
        ((2 * Real.pi * ((m : ℝ) - (n : ℝ)) : ℝ) : ℂ) * Complex.I := by push_cast; ring
    have hd2 : 2 * (Real.pi : ℂ) * Complex.I * ((n : ℂ) - (m : ℂ)) =
        -(((2 * Real.pi * ((m : ℝ) - (n : ℝ)) : ℝ) : ℂ) * Complex.I) := by push_cast; ring
    have hr : 2 * Real.pi * ((m : ℝ) - (n : ℝ)) ≠ 0 :=
      mul_ne_zero (mul_ne_zero (by norm_num) Real.pi_ne_zero) hmn
    rw [hd1, hd2, show tone L m y - tone L n y = -(tone L n y - tone L m y) by ring,
      neg_div_neg_eq, divided_even _ _ _ hr, (tone_real L n y).2, (tone_real L m y).2]
    apply congrArg Complex.ofReal
    field_simp [Real.pi_ne_zero, hmn]
    <;> ring

/-- No convolution mass exists outside the true doubled window. This is
proved from zero-extended support, not imposed on the computed formula. -/
theorem window_correlation_outside {L : ℝ} (hL : 0 < L) (n m : ℤ)
    {y : ℝ} (hy : L < |y|) : windowCorrelation L n m y = 0 := by
  have hpos (n m : ℤ) {t : ℝ} (ht : L < t) : windowCorrelation L n m t = 0 := by
    rw [correlation_integral, product_indicator hL n m t,
      max_eq_right (hL.le.trans ht.le), min_eq_left (by linarith : L ≤ L + t)]
    have hemp : Ioc t L = ∅ := Set.Ioc_eq_empty_of_le ht.le
    simp [hemp]
  rcases le_or_gt 0 y with hy0 | hy0
  · exact hpos n m (by simpa only [abs_of_nonneg hy0] using hy)
  · have hneg : L < -y := by simpa only [abs_of_neg hy0] using hy
    rw [← neg_neg y, window_correlation_reflection, hpos m n hneg, map_zero]

private theorem log_mem_window {c : ℕ} (hc : 2 ≤ c) {j : ℕ} (hj : j ∈ Finset.range c) :
    0 ≤ Real.log (j : ℝ) ∧ Real.log (j : ℝ) ≤ Real.log (c : ℝ) := by
  have hcR : (1 : ℝ) < (c : ℝ) := by exact_mod_cast (show 1 < c by omega)
  by_cases hj0 : j = 0
  · subst j
    simpa using (Real.log_pos hcR).le
  · have hjR : (0 : ℝ) < (j : ℝ) := by exact_mod_cast Nat.pos_of_ne_zero hj0
    have hj1 : (1 : ℝ) ≤ (j : ℝ) := by exact_mod_cast Nat.one_le_iff_ne_zero.mpr hj0
    exact ⟨Real.log_nonneg hj1,
      Real.log_le_log hjR (by exact_mod_cast (Finset.mem_range.mp hj).le)⟩

/-- The actual convolution tests now replace the previously supplied divided
sines in the existing arithmetic exterior column. All pole, Gamma and prime
terms retain the same original symbol. The real part is legitimate because
the complete even correlation formula above proves the test real-valued.
This is still not a canonical unbounded-operator domain theorem. -/
theorem coupling_column_window_convolution {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v : ℤ → ℂ) (m : ℤ) (hout : m ∉ S) :
    couplingColumn c S v m = ∑ n ∈ S,
      (((∫ t : ℝ in Ioc 0 (Real.log (c : ℝ)),
          (2 * Real.cosh (t / 2) - Real.exp (t / 2) / (Real.exp t - Real.exp (-t))) *
            (windowCorrelation (Real.log (c : ℝ)) n m t +
              windowCorrelation (Real.log (c : ℝ)) n m (-t)).re) -
        ∑ j ∈ Finset.range c, (ArithmeticFunction.vonMangoldt j / Real.sqrt j) *
          (windowCorrelation (Real.log (c : ℝ)) n m (Real.log (j : ℝ)) +
            windowCorrelation (Real.log (c : ℝ)) n m (-Real.log (j : ℝ))).re : ℝ) : ℂ) * v n := by
  have hcR : (1 : ℝ) < (c : ℝ) := by exact_mod_cast (show 1 < c by omega)
  have hL : 0 < Real.log (c : ℝ) := Real.log_pos hcR
  rw [coupling_column_kernel_integral hc S v m hout]
  apply Finset.sum_congr rfl
  intro n hnS
  have hnm : n ≠ m := by intro h; exact hout (h ▸ hnS)
  have hq (t : ℝ) (ht : 0 ≤ t) (htL : t ≤ Real.log (c : ℝ)) :
      (windowCorrelation (Real.log (c : ℝ)) n m t +
        windowCorrelation (Real.log (c : ℝ)) n m (-t)).re =
      (Real.sin ((2 * Real.pi * (n : ℝ) / Real.log (c : ℝ)) * t) -
        Real.sin ((2 * Real.pi * (m : ℝ) / Real.log (c : ℝ)) * t)) /
        (Real.pi * ((m : ℝ) - (n : ℝ))) := by
    rw [window_even_correlation_formula hL n m ht htL, if_neg hnm, Complex.ofReal_re]
    have hnarg : 2 * Real.pi * (n : ℝ) * t / Real.log (c : ℝ) =
        (2 * Real.pi * (n : ℝ) / Real.log (c : ℝ)) * t := by ring
    have hmarg : 2 * Real.pi * (m : ℝ) * t / Real.log (c : ℝ) =
        (2 * Real.pi * (m : ℝ) / Real.log (c : ℝ)) * t := by ring
    rw [hnarg, hmarg]
  have hint : (∫ t : ℝ in Ioc 0 (Real.log (c : ℝ)),
      (2 * Real.cosh (t / 2) - Real.exp (t / 2) / (Real.exp t - Real.exp (-t))) *
        (windowCorrelation (Real.log (c : ℝ)) n m t +
          windowCorrelation (Real.log (c : ℝ)) n m (-t)).re) =
      ∫ t : ℝ in Ioc 0 (Real.log (c : ℝ)),
        (2 * Real.cosh (t / 2) - Real.exp (t / 2) / (Real.exp t - Real.exp (-t))) *
        (Real.sin ((2 * Real.pi * (n : ℝ) / Real.log (c : ℝ)) * t) -
          Real.sin ((2 * Real.pi * (m : ℝ) / Real.log (c : ℝ)) * t)) /
          (Real.pi * ((m : ℝ) - (n : ℝ))) := by
    apply integral_congr_ae
    filter_upwards [ae_restrict_mem measurableSet_Ioc] with t ht
    rw [hq t ht.1.le ht.2]
    ring
  apply congrArg (fun z : ℝ => (z : ℂ) * v n)
  rw [hint]
  congr 1
  apply Finset.sum_congr rfl
  intro j hj
  obtain ⟨hlo, hhi⟩ := log_mem_window hc hj
  rw [hq _ hlo hhi]
  ring

#print axioms window_correlation_overlap
#print axioms window_even_correlation_formula
#print axioms coupling_column_window_convolution

end D5.S3.Weil.ZetaBridge.WeilWindowFourierConvolution
