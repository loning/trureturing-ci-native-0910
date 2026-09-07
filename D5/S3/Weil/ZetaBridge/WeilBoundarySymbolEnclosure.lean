/- GID: D5/S3/Weil/ZetaBridge/WeilBoundarySymbolEnclosure
   generality: I
   mirror-B: D5/B/S3/Weil/ZetaBridge/WeilBoundarySymbolEnclosure
   mirror-E: none(waiver:finite-expression-and-proved-infinite-symbol-tail)
   anchors: []
   digest: Enclose the actual infinite arithmetic boundary symbol from a finite expression and pass its proved remainder to a repaired-trial certificate. -/

import D5.S3.Weil.ZetaBridge.WeilRepairedTrialCertificate
import Mathlib.Analysis.SpecificLimits.Basic

/-!
This is a finite-evaluation interface to the existing arithmeticBoundarySymbol.
It retains the complete pole and prime terms and the first K+1 Gamma terms.
Absolute convergence is reused from the original owner. A shifted inverse-
square telescoping estimate bounds ALL remaining Gamma terms by |omega|/(4K+1).
No infinite-symbol error enclosure is an input to the final consumer.

The finite expression still contains log, exp, sin and cosh. Its enclosure,
the frequency bound, and the global arithmetic budget must be certified
separately. This file is not a verified implementation of those functions.
The uncorrected O(1/K) bound is sharpened by an exactly summed rational
correction to a cubic-plus-exponential remainder. No claim of an efficient
arbitrary-precision implementation or all-scale spectral certification follows.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false
noncomputable section

namespace D5.S3.Weil.ZetaBridge.WeilBoundarySymbolEnclosure

open D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingJet
open D5.S3.Weil.ZetaBridge.WeilArithmeticResidualTail
open D5.S3.Weil.ZetaBridge.WeilArithmeticResidualPrecision
open D5.S3.Weil.ZetaBridge.FiniteRationalTrialRepair
open D5.S3.Weil.ZetaBridge.WeilRepairedTrialCertificate
open Filter
open scoped BigOperators ComplexConjugate

private def omega (c : ℕ) (n : ℤ) : ℝ := 2 * Real.pi * (n : ℝ) / Real.log (c : ℝ)

private def gammaTerm (c : ℕ) (n : ℤ) (j : ℕ) : ℝ :=
  omega c n * (1 - Real.exp (-(2 * (j : ℝ) + 1 / 2) * Real.log (c : ℝ))) /
    ((2 * (j : ℝ) + 1 / 2) ^ 2 + omega c n ^ 2)

/-- The finite expression retains K+1 Gamma terms, not K terms. Every pole
and prime term of the existing symbol is retained exactly. -/
def boundarySymbolPartial (c : ℕ) (n : ℤ) (K : ℕ) : ℝ :=
  -(2 * omega c n * (Real.cosh (Real.log (c : ℝ) / 2) - 1) /
      (omega c n ^ 2 + 1 / 4)) -
    (∑ j ∈ Finset.range (K + 1), gammaTerm c n j) -
    ∑ j ∈ Finset.range c,
      (ArithmeticFunction.vonMangoldt j / Real.sqrt j) * Real.sin (omega c n * Real.log j)

private theorem gamma_term_abs_bound {c : ℕ} (hc : 2 ≤ c) (n : ℤ) (j : ℕ) :
    |gammaTerm c n j| ≤ |omega c n| / (2 * (j : ℝ) + 1 / 2) ^ 2 := by
  have hc1 : (1 : ℝ) ≤ (c : ℝ) := by
    exact_mod_cast (le_trans (by decide : 1 ≤ 2) hc)
  have hL := Real.log_nonneg hc1
  have hb : 0 < 2 * (j : ℝ) + 1 / 2 := by positivity
  have he : Real.exp (-(2 * (j : ℝ) + 1 / 2) * Real.log (c : ℝ)) ≤ 1 :=
    Real.exp_le_one_iff.mpr (mul_nonpos_of_nonpos_of_nonneg (by linarith) hL)
  have he0 := Real.exp_pos (-(2 * (j : ℝ) + 1 / 2) * Real.log (c : ℝ))
  unfold gammaTerm
  rw [abs_div, abs_mul, abs_of_nonneg (by linarith :
      0 ≤ 1 - Real.exp (-(2 * (j : ℝ) + 1 / 2) * Real.log (c : ℝ))),
    abs_of_pos (by positivity)]
  calc
    _ ≤ |omega c n| / ((2 * (j : ℝ) + 1 / 2) ^ 2 + omega c n ^ 2) :=
      div_le_div_of_nonneg_right
        (mul_le_of_le_one_right (abs_nonneg _) (by linarith)) (by positivity)
    _ ≤ _ := div_le_div_of_nonneg_left (abs_nonneg _) (by positivity)
      (le_add_of_nonneg_right (sq_nonneg _))

private theorem inverse_square_step {x : ℝ} (hx : 0 < x) :
    1 / (x + 2) ^ 2 ≤ 1 / (2 * x) - 1 / (2 * (x + 2)) := by
  have hx2 : x + 2 ≠ 0 := by linarith
  have hid : (1 / (2 * x) - 1 / (2 * (x + 2))) - 1 / (x + 2) ^ 2 =
      2 / (x * (x + 2) ^ 2) := by
    field_simp [hx.ne', hx2]
    <;> ring
  apply sub_nonneg.mp
  rw [hid]
  positivity

private theorem gamma_tail_step {c : ℕ} (hc : 2 ≤ c) (n : ℤ) (j : ℕ) :
    |gammaTerm c n (j + 1)| ≤
      |omega c n| / (4 * (j : ℝ) + 1) -
        |omega c n| / (4 * ((j + 1 : ℕ) : ℝ) + 1) := by
  have h := mul_le_mul_of_nonneg_left
    (inverse_square_step (show 0 < 2 * (j : ℝ) + 1 / 2 by positivity))
    (abs_nonneg (omega c n))
  have ha : 2 * (((j + 1 : ℕ) : ℝ)) + 1 / 2 = (2 * (j : ℝ) + 1 / 2) + 2 := by
    push_cast
    ring
  have hd0 : 2 * (2 * (j : ℝ) + 1 / 2) = 4 * (j : ℝ) + 1 := by ring
  have hd1 : 2 * ((2 * (j : ℝ) + 1 / 2) + 2) =
      4 * ((j + 1 : ℕ) : ℝ) + 1 := by push_cast; ring
  rw [hd0, hd1, mul_sub, mul_one_div, mul_one_div, mul_one_div] at h
  exact (gamma_term_abs_bound hc n (j + 1)).trans (by simpa only [ha] using h)

private theorem gamma_tail_partial {c : ℕ} (hc : 2 ≤ c) (n : ℤ) (K T : ℕ) :
    (∑ j ∈ Finset.range T, |gammaTerm c n (j + (K + 1))|) ≤
      |omega c n| / (4 * (K : ℝ) + 1) -
        |omega c n| / (4 * ((T + K : ℕ) : ℝ) + 1) := by
  induction T with
  | zero => simp
  | succ T ih =>
      rw [Finset.sum_range_succ]
      have hs := gamma_tail_step hc n (T + K)
      have hidx : T + (K + 1) = T + K + 1 := by ring
      have hnext : T + 1 + K = T + K + 1 := by ring
      rw [hidx, hnext]
      linarith

/-- Actual infinite-symbol error, including every omitted Gamma term.
The proof reuses the original absolute convergence theorem, splits its sum,
and proves a shifted tail bound. No terminal omitted-mode cutoff appears. -/
theorem boundary_symbol_partial_error {c : ℕ} (hc : 2 ≤ c) (n : ℤ) (K : ℕ) :
    |arithmeticBoundarySymbol c n - boundarySymbolPartial c n K| ≤
      |2 * Real.pi * (n : ℝ) / Real.log (c : ℝ)| / (4 * (K : ℝ) + 1) := by
  have hs := (arithmetic_boundary_symbol_bound hc n).1
  change Summable (fun j : ℕ => ‖gammaTerm c n j‖) at hs
  have hp (T : ℕ) : (∑ j ∈ Finset.range T, ‖gammaTerm c n (j + (K + 1))‖) ≤
      |omega c n| / (4 * (K : ℝ) + 1) := by
    have ht := gamma_tail_partial hc n K T
    have hlast : 0 ≤ |omega c n| / (4 * ((T + K : ℕ) : ℝ) + 1) := by positivity
    simpa only [Real.norm_eq_abs] using (show
      (∑ j ∈ Finset.range T, |gammaTerm c n (j + (K + 1))|) ≤
        |omega c n| / (4 * (K : ℝ) + 1) by linarith)
  have htail := summable_of_sum_range_le
    (fun j => norm_nonneg (gammaTerm c n (j + (K + 1)))) hp
  have htailBound := Real.tsum_le_of_sum_range_le
    (fun j => norm_nonneg (gammaTerm c n (j + (K + 1)))) hp
  have hsplit := hs.of_norm.sum_add_tsum_nat_add (K + 1)
  have hdiff : arithmeticBoundarySymbol c n - boundarySymbolPartial c n K =
      -(∑' j : ℕ, gammaTerm c n (j + (K + 1))) := by
    unfold arithmeticBoundarySymbol boundarySymbolPartial
    change
      (-(2 * omega c n * (Real.cosh (Real.log (c : ℝ) / 2) - 1) /
          (omega c n ^ 2 + 1 / 4)) - (∑' j : ℕ, gammaTerm c n j) -
          ∑ j ∈ Finset.range c, (ArithmeticFunction.vonMangoldt j / Real.sqrt j) *
            Real.sin (omega c n * Real.log j)) -
      (-(2 * omega c n * (Real.cosh (Real.log (c : ℝ) / 2) - 1) /
          (omega c n ^ 2 + 1 / 4)) - (∑ j ∈ Finset.range (K + 1), gammaTerm c n j) -
          ∑ j ∈ Finset.range c, (ArithmeticFunction.vonMangoldt j / Real.sqrt j) *
            Real.sin (omega c n * Real.log j)) = _
    rw [← hsplit]
    ring
  rw [hdiff, abs_neg]
  have hnorm : |∑' j : ℕ, gammaTerm c n (j + (K + 1))| ≤
      ∑' j : ℕ, ‖gammaTerm c n (j + (K + 1))‖ := by
    simpa only [Real.norm_eq_abs] using (norm_tsum_le_tsum_norm htail)
  exact hnorm.trans htailBound

/-- A finite-expression enclosure and a frequency upper bound yield an
actual-symbol enclosure. Only an upper frequency bound enters the radius.
All finite expression evaluation errors stay explicit. -/
theorem boundary_symbol_enclosure_of_partial {c : ℕ} (hc : 2 ≤ c)
    (n : ℤ) (K : ℕ) (center eps W : ℝ)
    (hfinite : |boundarySymbolPartial c n K - center| ≤ eps)
    (hfreq : |2 * Real.pi * (n : ℝ) / Real.log (c : ℝ)| ≤ W) :
    |arithmeticBoundarySymbol c n - center| ≤ eps + W / (4 * (K : ℝ) + 1) := by
  have htail := (boundary_symbol_partial_error hc n K).trans
    (div_le_div_of_nonneg_right hfreq (by positivity))
  have ht := abs_add_le (arithmeticBoundarySymbol c n - boundarySymbolPartial c n K)
    (boundarySymbolPartial c n K - center)
  rw [sub_add_sub_cancel] at ht
  linarith


/-- A rational first-tail correction of the same finite Gamma expression.
The correction is the exact sum of omega/((2j+1/2)^2-1) over j>K. -/
def boundarySymbolAccelerated (c : ℕ) (n : ℤ) (K : ℕ) : ℝ :=
  boundarySymbolPartial c n K - omega c n / (4 * (K : ℝ) + 3)

private def acceleratedBudget (w d x : ℝ) : ℝ :=
  4 * |w| * (w ^ 2 + 1) / (3 * (4 * x + 3) ^ 3) + d * |w| / (4 * x + 1)

private theorem cubic_step {a : ℝ} (ha : 1 < a) :
    1 / (a ^ 2 * (a ^ 2 - 1)) ≤
      1 / (6 * (a - 1) ^ 3) - 1 / (6 * (a + 1) ^ 3) := by
  have hpos : 0 < a := by linarith
  have hm : 0 < a - 1 := by linarith
  have hp : 0 < a + 1 := by linarith
  have hsq : 0 < a ^ 2 - 1 := by nlinarith
  have hid : (1 / (6 * (a - 1) ^ 3) - 1 / (6 * (a + 1) ^ 3)) -
      1 / (a ^ 2 * (a ^ 2 - 1)) =
        (7 * a ^ 2 - 3) / (3 * a ^ 2 * (a - 1) ^ 3 * (a + 1) ^ 3) := by
    field_simp [hpos.ne', hm.ne', hp.ne', hsq.ne']
    <;> ring
  apply sub_nonneg.mp
  rw [hid]
  exact div_nonneg (by nlinarith) (by positivity)

private theorem accelerated_scalar_step (w d e x : ℝ)
    (hx : 0 ≤ x) (he : 0 ≤ e) (hed : e ≤ d) :
    |w * (1 - e) / ((2 * x + 5 / 2) ^ 2 + w ^ 2) -
      w / ((2 * x + 5 / 2) ^ 2 - 1)| ≤
        acceleratedBudget w d x - acceleratedBudget w d (x + 1) := by
  let a : ℝ := 2 * x + 5 / 2
  have ha : 2 < a := by dsimp [a]; linarith
  have ha0 : 0 < a := by linarith
  have hden : 0 < a ^ 2 + w ^ 2 := by positivity
  have hsub : 0 < a ^ 2 - 1 := by nlinarith
  have hd : 0 ≤ d := he.trans hed
  have hid : w * (1 - e) / (a ^ 2 + w ^ 2) - w / (a ^ 2 - 1) =
      -(w * (w ^ 2 + 1) / ((a ^ 2 + w ^ 2) * (a ^ 2 - 1))) -
        w * e / (a ^ 2 + w ^ 2) := by
    field_simp [hden.ne', hsub.ne']
    <;> ring
  have hfirst : |w * (w ^ 2 + 1) / ((a ^ 2 + w ^ 2) * (a ^ 2 - 1))| ≤
      |w| * (w ^ 2 + 1) * (1 / (a ^ 2 * (a ^ 2 - 1))) := by
    rw [abs_div, abs_mul, abs_of_pos (by positivity : 0 < w ^ 2 + 1),
      abs_of_pos (mul_pos hden hsub)]
    rw [mul_one_div]
    apply div_le_div_of_nonneg_left (by positivity) (by positivity)
    exact mul_le_mul_of_nonneg_right (le_add_of_nonneg_right (sq_nonneg w)) hsub.le
  have hsecond : |w * e / (a ^ 2 + w ^ 2)| ≤ d * |w| * (1 / a ^ 2) := by
    rw [abs_div, abs_mul, abs_of_nonneg he, abs_of_pos hden]
    calc
      _ ≤ |w| * d / (a ^ 2 + w ^ 2) :=
        div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left hed (abs_nonneg _)) hden.le
      _ ≤ |w| * d / a ^ 2 :=
        div_le_div_of_nonneg_left (by positivity) (by positivity)
          (le_add_of_nonneg_right (sq_nonneg w))
      _ = _ := by ring
  have h3 := mul_le_mul_of_nonneg_left (cubic_step (show 1 < a by linarith))
    (show 0 ≤ |w| * (w ^ 2 + 1) by positivity)
  have h2 := mul_le_mul_of_nonneg_left
    (inverse_square_step (show 0 < a - 2 by linarith))
    (show 0 ≤ d * |w| by positivity)
  have ha2 : a - 2 + 2 = a := by ring
  rw [ha2] at h2
  change |w * (1 - e) / (a ^ 2 + w ^ 2) - w / (a ^ 2 - 1)| ≤ _
  rw [hid]
  calc
    _ ≤ |w * (w ^ 2 + 1) / ((a ^ 2 + w ^ 2) * (a ^ 2 - 1))| +
        |w * e / (a ^ 2 + w ^ 2)| := by
      simpa only [abs_neg] using abs_sub
        (-(w * (w ^ 2 + 1) / ((a ^ 2 + w ^ 2) * (a ^ 2 - 1))))
        (w * e / (a ^ 2 + w ^ 2))
    _ ≤ _ := (add_le_add hfirst hsecond).trans (add_le_add h3 h2)
    _ = _ := by
      dsimp [a, acceleratedBudget]
      have h1 : 4 * x + 1 ≠ 0 := by positivity
      have h3 : 4 * x + 3 ≠ 0 := by positivity
      have h5 : 4 * x + 5 ≠ 0 := by positivity
      have h7 : 4 * x + 7 ≠ 0 := by positivity
      field_simp
      all_goals first | ring | positivity | linarith

private theorem gamma_decay_bound {c : ℕ} (hc : 2 ≤ c) (K j : ℕ) :
    Real.exp (-(2 * ((j + (K + 1) : ℕ) : ℝ) + 1 / 2) * Real.log (c : ℝ)) ≤
      ((c : ℝ) ^ (2 * K + 2))⁻¹ := by
  have hcpos : 0 < (c : ℝ) := by exact_mod_cast (lt_of_lt_of_le (by decide : 0 < 2) hc)
  have hL : 0 ≤ Real.log (c : ℝ) :=
    Real.log_nonneg (by exact_mod_cast (le_trans (by decide : 1 ≤ 2) hc))
  have hexp : -(2 * ((j + (K + 1) : ℕ) : ℝ) + 1 / 2) * Real.log (c : ℝ) ≤
      -((2 * K + 2 : ℕ) : ℝ) * Real.log (c : ℝ) := by
    push_cast
    nlinarith [mul_nonneg (Nat.cast_nonneg j : (0 : ℝ) ≤ (j : ℝ)) hL]
  calc
    _ ≤ Real.exp (-((2 * K + 2 : ℕ) : ℝ) * Real.log (c : ℝ)) := Real.exp_le_exp.mpr hexp
    _ = _ := by rw [neg_mul, Real.exp_neg, Real.exp_nat_mul, Real.exp_log hcpos]

private theorem rational_tail_step (w x : ℝ) (hx : 0 ≤ x) :
    w / ((2 * x + 5 / 2) ^ 2 - 1) =
      w / (4 * x + 3) - w / (4 * (x + 1) + 3) := by
  have hden : 0 < (2 * x + 5 / 2) ^ 2 - 1 := by nlinarith
  have h0 : 0 < 4 * x + 3 := by positivity
  have h1 : 0 < 4 * (x + 1) + 3 := by positivity
  field_simp [hden.ne', h0.ne', h1.ne']
  <;> ring

/-- Subtracting the exactly summable rational tail improves the remaining
symbol error to a cubic term plus an explicit rational exponential term.
The physical cutoff c, exterior Fourier cutoff M and evaluator index K are
independent parameters. No omitted Gamma series is supplied as an input. -/
theorem boundary_symbol_accelerated_error {c : ℕ} (hc : 2 ≤ c) (n : ℤ) (K : ℕ) :
    |arithmeticBoundarySymbol c n - boundarySymbolAccelerated c n K| ≤
      4 * |omega c n| * (omega c n ^ 2 + 1) / (3 * (4 * (K : ℝ) + 3) ^ 3) +
        |omega c n| / ((c : ℝ) ^ (2 * K + 2) * (4 * (K : ℝ) + 1)) := by
  let w := omega c n
  let d : ℝ := ((c : ℝ) ^ (2 * K + 2))⁻¹
  let b : ℝ → ℝ := acceleratedBudget w d
  have hd : 0 ≤ d := by dsimp [d]; positivity
  have hb (x : ℝ) (hx : 0 ≤ x) : 0 ≤ b x := by dsimp [b, acceleratedBudget]; positivity
  have hstep (j : ℕ) :
      |gammaTerm c n (j + (K + 1)) -
        (w / (4 * ((j + K : ℕ) : ℝ) + 3) -
          w / (4 * ((j + K + 1 : ℕ) : ℝ) + 3))| ≤
        b (j + K) - b (j + K + 1) := by
    have hx : 0 ≤ ((j + K : ℕ) : ℝ) := Nat.cast_nonneg _
    have ha : 2 * ((j + (K + 1) : ℕ) : ℝ) + 1 / 2 =
        2 * ((j + K : ℕ) : ℝ) + 5 / 2 := by push_cast; ring
    have h := accelerated_scalar_step w d
      (Real.exp (-(2 * ((j + (K + 1) : ℕ) : ℝ) + 1 / 2) * Real.log (c : ℝ)))
      ((j + K : ℕ) : ℝ) hx (Real.exp_pos _).le (gamma_decay_bound hc K j)
    rw [rational_tail_step w _ hx] at h
    simpa only [gammaTerm, ha, Nat.cast_add, Nat.cast_one, w, b] using h
  have hpartial (T : ℕ) :
      |(∑ j ∈ Finset.range T, gammaTerm c n (j + (K + 1))) -
        (w / (4 * (K : ℝ) + 3) - w / (4 * ((T + K : ℕ) : ℝ) + 3))| ≤
          b K - b (T + K) := by
    induction T with
    | zero => simp
    | succ T ih =>
        rw [Finset.sum_range_succ]
        have ht := hstep T
        have hnext : T + 1 + K = T + K + 1 := by ring
        rw [hnext]
        have hid :
            ((∑ j ∈ Finset.range T, gammaTerm c n (j + (K + 1))) +
              gammaTerm c n (T + (K + 1))) -
            (w / (4 * (K : ℝ) + 3) - w / (4 * ((T + K + 1 : ℕ) : ℝ) + 3)) =
            ((∑ j ∈ Finset.range T, gammaTerm c n (j + (K + 1))) -
              (w / (4 * (K : ℝ) + 3) - w / (4 * ((T + K : ℕ) : ℝ) + 3))) +
            (gammaTerm c n (T + (K + 1)) -
              (w / (4 * ((T + K : ℕ) : ℝ) + 3) - w / (4 * ((T + K + 1 : ℕ) : ℝ) + 3))) := by ring
        rw [hid]
        exact (abs_add_le _ _).trans (by linarith [ih, ht])
  have hs := (arithmetic_boundary_symbol_bound hc n).1
  change Summable (fun j : ℕ => ‖gammaTerm c n j‖) at hs
  have hshift : Summable (fun j : ℕ => gammaTerm c n (j + (K + 1))) :=
    (summable_nat_add_iff (K + 1)).mpr hs.of_norm
  have hzero : Filter.Tendsto (fun T : ℕ => w / (4 * ((T + K : ℕ) : ℝ) + 3))
      Filter.atTop (nhds 0) := by
    have hlim : Filter.Tendsto (fun T : ℕ => |w| * (1 / ((T : ℝ) + 1)))
        Filter.atTop (nhds 0) := by
      simpa only [mul_zero] using
        ((tendsto_const_nhds : Filter.Tendsto (fun _ : ℕ => |w|) Filter.atTop (nhds |w|)).mul
          (tendsto_one_div_add_atTop_nhds_zero_nat (𝕜 := ℝ)))
    refine squeeze_zero_norm (fun T => ?_) hlim
    rw [Real.norm_eq_abs, abs_div, abs_of_pos (by positivity), mul_one_div]
    exact div_le_div_of_nonneg_left (abs_nonneg _) (by positivity) (by
      push_cast
      nlinarith [Nat.cast_nonneg T, Nat.cast_nonneg K])
  have hcorrect : Filter.Tendsto
      (fun T : ℕ => w / (4 * (K : ℝ) + 3) - w / (4 * ((T + K : ℕ) : ℝ) + 3))
      Filter.atTop (nhds (w / (4 * (K : ℝ) + 3))) := by
    simpa only [sub_zero] using
      ((tendsto_const_nhds : Filter.Tendsto (fun _ : ℕ => w / (4 * (K : ℝ) + 3))
        Filter.atTop (nhds (w / (4 * (K : ℝ) + 3)))).sub hzero
  have hlim := ((hshift.hasSum.tendsto_sum_nat).sub hcorrect).norm
  have htail : |(∑' j : ℕ, gammaTerm c n (j + (K + 1))) - w / (4 * (K : ℝ) + 3)| ≤ b K := by
    have h := le_of_tendsto hlim (Filter.Eventually.of_forall fun T => by
      simpa only [Real.norm_eq_abs] using (hpartial T).trans (sub_le_self _ (hb _ (Nat.cast_nonneg _))))
    simpa only [sub_zero, Real.norm_eq_abs] using h
  have hsplit := hs.of_norm.sum_add_tsum_nat_add (K + 1)
  have hid : arithmeticBoundarySymbol c n - boundarySymbolAccelerated c n K =
      -((∑' j : ℕ, gammaTerm c n (j + (K + 1))) - w / (4 * (K : ℝ) + 3)) := by
    unfold boundarySymbolAccelerated boundarySymbolPartial arithmeticBoundarySymbol
    change
      (-(2 * w * (Real.cosh (Real.log (c : ℝ) / 2) - 1) / (w ^ 2 + 1 / 4)) -
        (∑' j : ℕ, gammaTerm c n j) -
        ∑ j ∈ Finset.range c, (ArithmeticFunction.vonMangoldt j / Real.sqrt j) *
          Real.sin (w * Real.log j)) -
      ((-(2 * w * (Real.cosh (Real.log (c : ℝ) / 2) - 1) / (w ^ 2 + 1 / 4)) -
        (∑ j ∈ Finset.range (K + 1), gammaTerm c n j) -
        ∑ j ∈ Finset.range c, (ArithmeticFunction.vonMangoldt j / Real.sqrt j) *
          Real.sin (w * Real.log j)) - w / (4 * (K : ℝ) + 3)) = _
    rw [← hsplit]
    ring
  rw [hid, abs_neg]
  simpa only [b, acceleratedBudget, d, w, div_eq_mul_inv, mul_inv_rev, mul_comm, mul_left_comm, mul_assoc] using htail

end D5.S3.Weil.ZetaBridge.WeilBoundarySymbolEnclosure

end

namespace D5.S3.Weil.ZetaBridge.WeilBoundarySymbolEnclosure

open D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingJet
open D5.S3.Weil.ZetaBridge.WeilArithmeticResidualTail
open D5.S3.Weil.ZetaBridge.WeilArithmeticResidualPrecision
open D5.S3.Weil.ZetaBridge.FiniteRationalTrialRepair
open D5.S3.Weil.ZetaBridge.WeilRepairedTrialCertificate
open Filter
open scoped BigOperators ComplexConjugate

/-- Exact rational radii for the accelerated finite expression. The count
K retains terms 0 through K inclusive; c is the physical integer cutoff. -/
def rationalSymbolRadii (c : ℕ) (K : ℤ → ℕ) (eps W : ℤ → ℚ) (n : ℤ) : ℚ :=
  eps n + 4 * W n * ((W n) ^ 2 + 1) / (3 * (4 * (K n : ℚ) + 3) ^ 3) +
    W n / ((c : ℚ) ^ (2 * K n + 2) * (4 * (K n : ℚ) + 1))

/-- The actual infinite symbol lies in the computed rational balls whenever
the finite evaluations and frequency bounds have been certified. -/
theorem rational_symbol_radii_sound {c : ℕ} (hc : 2 ≤ c) (S : Finset ℤ)
    (K : ℤ → ℕ) (s eps F : ℤ → ℚ)
    (hfinite : ∀ n ∈ S, |boundarySymbolAccelerated c n (K n) - (s n : ℝ)| ≤ (eps n : ℝ))
    (hfreq : ∀ n ∈ S, |2 * Real.pi * (n : ℝ) / Real.log (c : ℝ)| ≤ (F n : ℝ)) :
    ∀ n ∈ S, ‖(arithmeticBoundarySymbol c n : ℂ) - (s n : ℂ)‖ ≤
      (rationalSymbolRadii c K eps F n : ℝ) := by
  intro n hn
  have hc0 : 0 < (c : ℝ) := by exact_mod_cast (lt_of_lt_of_le (by decide : 0 < 2) hc)
  have hf := hfreq n hn
  change |omega c n| ≤ (F n : ℝ) at hf
  have hf0 : 0 ≤ (F n : ℝ) := (abs_nonneg _).trans hf
  have hsquare : omega c n ^ 2 ≤ (F n : ℝ) ^ 2 := by
    simpa only [sq_abs] using pow_le_pow_left₀ (abs_nonneg (omega c n)) hf 2
  have hnum : 4 * |omega c n| * (omega c n ^ 2 + 1) ≤
      4 * (F n : ℝ) * ((F n : ℝ) ^ 2 + 1) :=
    mul_le_mul (mul_le_mul_of_nonneg_left hf (by norm_num))
      (add_le_add_right hsquare 1) (by positivity) (by positivity)
  have htail := (boundary_symbol_accelerated_error hc n (K n)).trans
    (add_le_add
      (div_le_div_of_nonneg_right hnum (by positivity))
      (div_le_div_of_nonneg_right hf (by positivity)))
  have htri := abs_add_le
    (arithmeticBoundarySymbol c n - boundarySymbolAccelerated c n (K n))
    (boundarySymbolAccelerated c n (K n) - (s n : ℝ))
  rw [sub_add_sub_cancel] at htri
  have hout := htri.trans (add_le_add htail (hfinite n hn))
  simpa [rationalSymbolRadii, ← Complex.ofReal_sub, Complex.norm_real, Real.norm_eq_abs,
    add_assoc, add_comm, add_left_comm] using hout

/-- Finite expression enclosures feed the SAME exact repaired trial and its
computed moments. The caller no longer supplies a bound on the infinite
arithmeticBoundarySymbol. The global envelope, actual finite evaluations,
frequency/parameter bounds and successful rational tail check remain explicit.
This is a coefficient certificate, not a canonical Weil-domain realization. -/
theorem repaired_trial_from_finite_symbols {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (k v t : ℤ → ℚ × ℚ) (hrepair : repairTrial S k v = some t)
    (K : ℤ → ℕ) (s eps F : ℤ → ℚ)
    (hfinite : ∀ n ∈ S, |boundarySymbolAccelerated c n (K n) - (s n : ℝ)| ≤ (eps n : ℝ))
    (hfreq : ∀ n ∈ S, |2 * Real.pi * (n : ℝ) / Real.log (c : ℝ)| ≤ (F n : ℝ))
    (N B p H W tau : ℚ) (hN : 0 ≤ (N : ℝ))
    (hS : ∀ n ∈ S, |(n : ℝ)| ≤ (N : ℝ))
    (hB : arithmeticBoundaryBudget c ≤ (B : ℝ)) (hp : 0 < (p : ℝ))
    (hpi : (p : ℝ) ≤ Real.pi) (eta w : ℂ)
    (heta : ‖eta‖ ≤ (H : ℝ)) (hw : ‖w‖ ≤ (W : ℝ)) {M : ℕ}
    (hcheck : let E := rationalMomentBudgets S t s (rationalSymbolRadii c K eps F)
      residualTailCheck M N W ((E.2.1 + B * E.1) / p)
        ((4 / 3 : ℚ) * H + 4 * B * N / p * E.2.2) tau = true) :
    (∀ n, n ∉ S → t n = (0, 0)) ∧
      (∑ n ∈ S, conj (decode (k n)) * decode (t n)) = 0 ∧
      Summable (fun j : ℕ => ‖arithmeticResidualTail c S (fun n => decode (t n)) eta w M false j‖ ^ 2 +
        ‖arithmeticResidualTail c S (fun n => decode (t n)) eta w M true j‖ ^ 2) ∧
      (∑' j : ℕ, ‖arithmeticResidualTail c S (fun n => decode (t n)) eta w M false j‖ ^ 2 +
        ‖arithmeticResidualTail c S (fun n => decode (t n)) eta w M true j‖ ^ 2) ≤ (tau : ℝ) := by
  exact repaired_arithmetic_residual_certificate hc S k v t hrepair
    s (rationalSymbolRadii c K eps F) (rational_symbol_radii_sound hc S K s eps F hfinite hfreq)
    N B p H W tau hN hS hB hp hpi eta w heta hw hcheck

#print axioms boundary_symbol_partial_error
#print axioms boundary_symbol_accelerated_error
#print axioms repaired_trial_from_finite_symbols

end D5.S3.Weil.ZetaBridge.WeilBoundarySymbolEnclosure
