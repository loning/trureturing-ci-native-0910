/- GID: D5/S3/Weil/ZetaBridge/WeilArithmeticResidualPrecision
   generality: I
   mirror-B: D5/B/S3/Weil/ZetaBridge/WeilArithmeticResidualPrecision
   mirror-E: none(waiver:infinite-tail-with-exact-rational-acceptance)
   anchors: []
   digest: Propagate coefficient and symbol enclosures into a full arithmetic residual tail, retaining nonzero moments and their mixed term. -/

import D5.S3.Weil.ZetaBridge.WeilArithmeticResidualTail
import Mathlib.Tactic.NormNum

/-!
Absolute error radii, rather than a working-precision label, enter the proof.
The actual arithmetic symbol is unchanged. Both boundary moments may be
nonzero. An explicit mixed majorant D/m+Q/m^2 gives the full squared tail
2*(D^2/M+D*Q/M^2+Q^2/(3*M^3)). A polynomial rational checker validates that
scalar tail budget; it does not certify the external transcendental inputs,
operator domains, interior residuals, or the Weil/prolate all-scale limit.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false
noncomputable section

namespace D5.S3.Weil.ZetaBridge.WeilArithmeticResidualPrecision

open D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingJet
open D5.S3.Weil.ZetaBridge.WeilArithmeticResidualTail
open D5.S3.Weil.ZetaBridge.WeilEvenFourierObservationTail
open scoped BigOperators

private theorem norm_le_center_radius (z center : ℂ) (radius : ℝ)
    (h : ‖z - center‖ ≤ radius) : ‖z‖ ≤ ‖center‖ + radius := by
  have ht := norm_add_le (z - center) center
  rw [sub_add_cancel] at ht
  linarith

/-- Coefficient and symbol errors are propagated before taking the moment
norm. The product of both radii is retained. The centers need not satisfy
any exact moment cancellation. -/
theorem finite_moment_enclosures {I : Type*} (S : Finset I)
    (v center symbol symbolCenter : I → ℂ) (ev es : I → ℝ)
    (hev : ∀ n ∈ S, ‖v n - center n‖ ≤ ev n)
    (hes : ∀ n ∈ S, ‖symbol n - symbolCenter n‖ ≤ es n) :
    ‖∑ n ∈ S, v n‖ ≤ ‖∑ n ∈ S, center n‖ + ∑ n ∈ S, ev n ∧
    ‖∑ n ∈ S, symbol n * v n‖ ≤ ‖∑ n ∈ S, symbolCenter n * center n‖ +
      ∑ n ∈ S, (‖symbolCenter n‖ * ev n + es n * ‖center n‖ + es n * ev n) ∧
    (∑ n ∈ S, ‖v n‖) ≤ ∑ n ∈ S, (‖center n‖ + ev n) := by
  have he0 (n) (hn : n ∈ S) : 0 ≤ ev n := (norm_nonneg _).trans (hev n hn)
  have hs0 (n) (hn : n ∈ S) : 0 ≤ es n := (norm_nonneg _).trans (hes n hn)
  have hproduct (n) (hn : n ∈ S) :
      ‖symbol n * v n - symbolCenter n * center n‖ ≤
        ‖symbolCenter n‖ * ev n + es n * ‖center n‖ + es n * ev n := by
    have hid : symbol n * v n - symbolCenter n * center n =
        symbolCenter n * (v n - center n) + (symbol n - symbolCenter n) * center n +
          (symbol n - symbolCenter n) * (v n - center n) := by ring
    rw [hid]
    calc
      _ ≤ ‖symbolCenter n * (v n - center n)‖ +
          ‖(symbol n - symbolCenter n) * center n‖ +
          ‖(symbol n - symbolCenter n) * (v n - center n)‖ :=
        (norm_add_le _ _).trans (add_le_add_right (norm_add_le _ _) _)
      _ ≤ _ := by
        simp only [norm_mul]
        exact add_le_add
          (add_le_add (mul_le_mul_of_nonneg_left (hev n hn) (norm_nonneg _))
            (mul_le_mul_of_nonneg_right (hes n hn) (norm_nonneg _)))
          (mul_le_mul (hes n hn) (hev n hn) (norm_nonneg _) (hs0 n hn))
  have hsum : ‖(∑ n ∈ S, v n) - ∑ n ∈ S, center n‖ ≤ ∑ n ∈ S, ev n := by
    rw [← Finset.sum_sub_distrib]
    exact (norm_sum_le _ _).trans (Finset.sum_le_sum hev)
  have hweighted : ‖(∑ n ∈ S, symbol n * v n) -
      ∑ n ∈ S, symbolCenter n * center n‖ ≤
        ∑ n ∈ S, (‖symbolCenter n‖ * ev n + es n * ‖center n‖ + es n * ev n) := by
    rw [← Finset.sum_sub_distrib]
    exact (norm_sum_le _ _).trans (Finset.sum_le_sum hproduct)
  exact ⟨norm_le_center_radius _ _ _ hsum, norm_le_center_radius _ _ _ hweighted,
    Finset.sum_le_sum fun n hn => norm_le_center_radius _ _ _ (hev n hn)⟩

/-- Full two-sided squared-tail budget, with the nonzero-moment and mixed
terms explicit. M denotes the number through which modes are retained. -/
def precisionTailBound (D Q M : ℝ) : ℝ :=
  2 * (D ^ 2 / M + D * Q / M ^ 2 + Q ^ 2 / (3 * M ^ 3))

private def tailPrimitive (D Q x : ℝ) : ℝ :=
  D ^ 2 / x + D * Q / x ^ 2 + Q ^ 2 / (3 * x ^ 3)

private theorem mixed_step (D Q : ℝ) (hD : 0 ≤ D) (hQ : 0 ≤ Q)
    {x : ℝ} (hx : 0 < x) :
    (D / (x + 1) + Q / (x + 1) ^ 2) ^ 2 ≤
      tailPrimitive D Q x - tailPrimitive D Q (x + 1) := by
  have hx1 : x + 1 ≠ 0 := by linarith
  have hid : (tailPrimitive D Q x - tailPrimitive D Q (x + 1)) -
      (D / (x + 1) + Q / (x + 1) ^ 2) ^ 2 =
        D ^ 2 / (x * (x + 1) ^ 2) +
        D * Q * (3 * x + 1) / (x ^ 2 * (x + 1) ^ 3) +
        Q ^ 2 * (6 * x ^ 2 + 4 * x + 1) / (3 * x ^ 3 * (x + 1) ^ 4) := by
    unfold tailPrimitive
    field_simp [hx.ne', hx1]
    <;> ring
  apply sub_nonneg.mp
  rw [hid]
  positivity

private theorem mixed_partial (D Q : ℝ) (hD : 0 ≤ D) (hQ : 0 ≤ Q)
    {M : ℕ} (hM : 0 < M) (K : ℕ) :
    (∑ j ∈ Finset.range K,
      (D / ((M : ℝ) + j + 1) + Q / ((M : ℝ) + j + 1) ^ 2) ^ 2) ≤
        tailPrimitive D Q M - tailPrimitive D Q ((M : ℝ) + K) := by
  have hm : 0 < (M : ℝ) := by exact_mod_cast hM
  induction K with
  | zero => simp
  | succ K ih =>
      rw [Finset.sum_range_succ]
      have hs := mixed_step D Q hD hQ (show 0 < (M : ℝ) + K by positivity)
      simp only [Nat.cast_succ, ← add_assoc]
      linarith

private theorem mixed_half_tail (D Q : ℝ) (hD : 0 ≤ D) (hQ : 0 ≤ Q)
    {M : ℕ} (hM : 0 < M) (r : ℕ → ℂ)
    (hr : ∀ j, ‖r j‖ ≤ D / ((M : ℝ) + j + 1) + Q / ((M : ℝ) + j + 1) ^ 2) :
    Summable (fun j => ‖r j‖ ^ 2) ∧
      (∑' j, ‖r j‖ ^ 2) ≤ tailPrimitive D Q M := by
  have hp (K : ℕ) : (∑ j ∈ Finset.range K, ‖r j‖ ^ 2) ≤ tailPrimitive D Q M := by
    have hmajor := mixed_partial D Q hD hQ hM K
    have hlast : 0 ≤ tailPrimitive D Q ((M : ℝ) + K) := by
      unfold tailPrimitive
      positivity
    have hs := Finset.sum_le_sum (s := Finset.range K)
      (fun j _ => pow_le_pow_left₀ (norm_nonneg _) (hr j) 2)
    linarith
  exact ⟨summable_of_sum_range_le (fun j => sq_nonneg ‖r j‖) hp,
    Real.tsum_le_of_sum_range_le (fun j => sq_nonneg ‖r j‖) hp⟩

private theorem first_jet_defect_bound {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v : ℤ → ℂ) (e0 e1 B p : ℝ)
    (h0 : ‖∑ n ∈ S, v n‖ ≤ e0)
    (h1 : ‖∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * v n‖ ≤ e1)
    (hB : arithmeticBoundaryBudget c ≤ B) (hp : 0 < p) (hpi : p ≤ Real.pi)
    {m : ℤ} (hm : 0 < |(m : ℝ)|) :
    ‖couplingFirstJet c S v m‖ ≤ ((e1 + B * e0) / p) / |(m : ℝ)| := by
  have he0 : 0 ≤ e0 := (norm_nonneg _).trans h0
  have he1 : 0 ≤ e1 := (norm_nonneg _).trans h1
  have hb0 : 0 ≤ B := (abs_nonneg (arithmeticBoundarySymbol c m)).trans
    ((arithmetic_boundary_symbol_bound hc m).2.trans hB)
  have hs : ‖(arithmeticBoundarySymbol c m : ℂ)‖ ≤ B := by
    simpa only [Complex.norm_real, Real.norm_eq_abs] using
      (arithmetic_boundary_symbol_bound hc m).2.trans hB
  rw [first_jet_moment_identity, norm_div]
  have hn : ‖(∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * v n) -
      (arithmeticBoundarySymbol c m : ℂ) * ∑ n ∈ S, v n‖ ≤ e1 + B * e0 := by
    refine (norm_sub_le _ _).trans ?_
    rw [norm_mul]
    exact add_le_add h1 (mul_le_mul hs h0 (norm_nonneg _) hb0)
  rw [Complex.norm_real, Real.norm_eq_abs, abs_mul, abs_of_pos Real.pi_pos]
  calc
    _ ≤ (e1 + B * e0) / (Real.pi * |(m : ℝ)|) :=
      div_le_div_of_nonneg_right hn (by positivity)
    _ ≤ (e1 + B * e0) / (p * |(m : ℝ)|) :=
      div_le_div_of_nonneg_left (by positivity) (by positivity)
        (mul_le_mul_of_nonneg_right hpi hm.le)
    _ = _ := by simp only [div_eq_mul_inv, mul_inv_rev]; ring

private theorem first_jet_remainder_enclosure {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v : ℤ → ℂ) (N B p V : ℝ) (hN : 0 ≤ N)
    (hS : ∀ n ∈ S, |(n : ℝ)| ≤ N)
    (hB : arithmeticBoundaryBudget c ≤ B) (hp : 0 < p) (hpi : p ≤ Real.pi)
    (hV : (∑ n ∈ S, ‖v n‖) ≤ V)
    {m : ℤ} (hm : 0 < |(m : ℝ)|) (hsep : 2 * N ≤ |(m : ℝ)|) :
    ‖couplingColumn c S v m - couplingFirstJet c S v m‖ ≤
      (4 * B * N / p * V) / |(m : ℝ)| ^ 2 := by
  have hb0 : 0 ≤ arithmeticBoundaryBudget c :=
    (abs_nonneg (arithmeticBoundarySymbol c 0)).trans (arithmetic_boundary_symbol_bound hc 0).2
  have hB0 : 0 ≤ B := hb0.trans hB
  have hV0 : 0 ≤ V := (Finset.sum_nonneg fun _ _ => norm_nonneg _).trans hV
  have hgap : 0 < |(m : ℝ)| - N := by linarith
  have h := arithmetic_coupling_first_jet_error hc S v hN hS
    (show N < |(m : ℝ)| by linarith)
  have hden : |(m : ℝ)| ^ 2 ≤ 2 * |(m : ℝ)| * (|(m : ℝ)| - N) := by
    nlinarith [mul_nonneg hm.le (sub_nonneg.mpr hsep)]
  have hfrac : 2 * arithmeticBoundaryBudget c * N /
      (Real.pi * |(m : ℝ)| * (|(m : ℝ)| - N)) ≤
      4 * arithmeticBoundaryBudget c * N / (Real.pi * |(m : ℝ)| ^ 2) := by
    apply (div_le_div_iff₀ (by positivity) (by positivity)).mpr
    have ht := mul_le_mul_of_nonneg_left hden
      (show 0 ≤ 2 * arithmeticBoundaryBudget c * N * Real.pi by positivity)
    nlinarith [ht]
  have hup : 4 * arithmeticBoundaryBudget c * N / (Real.pi * |(m : ℝ)| ^ 2) ≤
      4 * B * N / (p * |(m : ℝ)| ^ 2) := by
    calc
      _ ≤ 4 * B * N / (Real.pi * |(m : ℝ)| ^ 2) :=
        div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_right
          (mul_le_mul_of_nonneg_left hB (by norm_num)) hN) (by positivity)
      _ ≤ _ := div_le_div_of_nonneg_left (by positivity) (by positivity)
        (mul_le_mul_of_nonneg_right hpi (sq_nonneg _))
  calc
    _ ≤ _ := h
    _ ≤ (4 * B * N / (p * |(m : ℝ)| ^ 2)) * V :=
      mul_le_mul (hfrac.trans hup) hV
        (Finset.sum_nonneg fun _ _ => norm_nonneg _) (by positivity)
    _ = _ := by simp only [div_eq_mul_inv, mul_inv_rev]; ring

/-- Nonzero boundary moments are permitted. Positive lower p for pi and
upper B for the actual arithmetic envelope have their correct inequality
directions. All exterior signs are retained and square summability is proved.
The output is the existing arithmeticResidualTail, not a replacement residual. -/
theorem arithmetic_residual_defect_tail_bound {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v : ℤ → ℂ) (N e0 e1 B p V H : ℝ)
    (hN : 0 ≤ N) (hS : ∀ n ∈ S, |(n : ℝ)| ≤ N)
    (h0 : ‖∑ n ∈ S, v n‖ ≤ e0)
    (h1 : ‖∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * v n‖ ≤ e1)
    (hB : arithmeticBoundaryBudget c ≤ B) (hp : 0 < p) (hpi : p ≤ Real.pi)
    (hV : (∑ n ∈ S, ‖v n‖) ≤ V) (eta w : ℂ) (heta : ‖eta‖ ≤ H)
    {M : ℕ} (hM : 0 < M) (hMN : 2 * N ≤ (M : ℝ)) (hw : ‖w‖ ≤ (M : ℝ) / 2) :
    let D := (e1 + B * e0) / p
    let Q := (4 / 3 : ℝ) * H + 4 * B * N / p * V
    Summable (fun j : ℕ => ‖arithmeticResidualTail c S v eta w M false j‖ ^ 2 +
      ‖arithmeticResidualTail c S v eta w M true j‖ ^ 2) ∧
      (∑' j : ℕ, ‖arithmeticResidualTail c S v eta w M false j‖ ^ 2 +
        ‖arithmeticResidualTail c S v eta w M true j‖ ^ 2) ≤ precisionTailBound D Q M := by
  let D := (e1 + B * e0) / p
  let Q := (4 / 3 : ℝ) * H + 4 * B * N / p * V
  have he0 : 0 ≤ e0 := (norm_nonneg _).trans h0
  have he1 : 0 ≤ e1 := (norm_nonneg _).trans h1
  have hB0 : 0 ≤ B := (abs_nonneg (arithmeticBoundarySymbol c 0)).trans
    ((arithmetic_boundary_symbol_bound hc 0).2.trans hB)
  have hV0 : 0 ≤ V := (Finset.sum_nonneg fun _ _ => norm_nonneg _).trans hV
  have hH0 : 0 ≤ H := (norm_nonneg _).trans heta
  have hD : 0 ≤ D := by dsimp [D]; positivity
  have hQ : 0 ≤ Q := by dsimp [Q]; positivity
  have hpoint (negative : Bool) (j : ℕ) :
      ‖arithmeticResidualTail c S v eta w M negative j‖ ≤
        D / ((M : ℝ) + j + 1) + Q / ((M : ℝ) + j + 1) ^ 2 := by
    have ha : |(exteriorMode M j negative : ℝ)| = (M : ℝ) + j + 1 := by
      have hz : 0 ≤ (M : ℝ) + j + 1 := by positivity
      cases negative <;> simp [exteriorMode, abs_of_nonneg hz]
    have hm : 0 < |(exteriorMode M j negative : ℝ)| := by rw [ha]; positivity
    have hsep : 2 * N ≤ |(exteriorMode M j negative : ℝ)| := by
      rw [ha]
      linarith [Nat.cast_nonneg j]
    have hj := first_jet_defect_bound hc S v e0 e1 B p h0 h1 hB hp hpi hm
    have hr := first_jet_remainder_enclosure hc S v N B p V hN hS hB hp hpi hV hm hsep
    rw [ha] at hj hr
    have hread := (exterior_cauchy_term_bound hM hw eta j).trans
      (mul_le_mul_of_nonneg_right heta (by positivity))
    have hcol := norm_add_le
      (couplingColumn c S v (exteriorMode M j negative) -
        couplingFirstJet c S v (exteriorMode M j negative))
      (couplingFirstJet c S v (exteriorMode M j negative))
    rw [sub_add_cancel] at hcol
    calc
      _ ≤ _ := norm_sub_le _ _
      _ ≤ H * (4 / (3 * ((M : ℝ) + j + 1) ^ 2)) +
          ((4 * B * N / p * V) / ((M : ℝ) + j + 1) ^ 2 +
            ((e1 + B * e0) / p) / ((M : ℝ) + j + 1)) :=
        add_le_add hread (hcol.trans (add_le_add hr hj))
      _ = _ := by dsimp [D, Q]; simp only [div_eq_mul_inv, mul_inv_rev]; ring
  obtain ⟨hp', hb'⟩ := mixed_half_tail D Q hD hQ hM
    (arithmeticResidualTail c S v eta w M false) (hpoint false)
  obtain ⟨hn', hc'⟩ := mixed_half_tail D Q hD hQ hM
    (arithmeticResidualTail c S v eta w M true) (hpoint true)
  refine ⟨hp'.add hn', ?_⟩
  rw [hp'.tsum_add hn']
  change _ ≤ 2 * tailPrimitive D Q M
  linarith

/-- End-to-end enclosure consumer. Rounding in both coefficients and the
symbol, in the readout numerator and in the complex frequency, is included.
The centers are exact mathematical values (e.g. decoded dyadic rationals).
No near-zero moment is replaced by an exact equality. -/
theorem rounded_arithmetic_residual_tail_bound {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v center symbolCenter : ℤ → ℂ) (ev es : ℤ → ℝ)
    (hev : ∀ n ∈ S, ‖v n - center n‖ ≤ ev n)
    (hes : ∀ n ∈ S, ‖(arithmeticBoundarySymbol c n : ℂ) - symbolCenter n‖ ≤ es n)
    (N e0 e1 B p V H W : ℝ) (hN : 0 ≤ N) (hS : ∀ n ∈ S, |(n : ℝ)| ≤ N)
    (h0 : ‖∑ n ∈ S, center n‖ + ∑ n ∈ S, ev n ≤ e0)
    (h1 : ‖∑ n ∈ S, symbolCenter n * center n‖ +
      ∑ n ∈ S, (‖symbolCenter n‖ * ev n + es n * ‖center n‖ + es n * ev n) ≤ e1)
    (hV : (∑ n ∈ S, (‖center n‖ + ev n)) ≤ V)
    (hB : arithmeticBoundaryBudget c ≤ B) (hp : 0 < p) (hpi : p ≤ Real.pi)
    (eta etaCenter w wCenter : ℂ) (ee ew : ℝ)
    (heta : ‖eta - etaCenter‖ ≤ ee) (hetaH : ‖etaCenter‖ + ee ≤ H)
    (hw : ‖w - wCenter‖ ≤ ew) (hwW : ‖wCenter‖ + ew ≤ W)
    {M : ℕ} (hM : 0 < M) (hMN : 2 * N ≤ (M : ℝ)) (hMW : 2 * W ≤ (M : ℝ)) :
    Summable (fun j : ℕ => ‖arithmeticResidualTail c S v eta w M false j‖ ^ 2 +
      ‖arithmeticResidualTail c S v eta w M true j‖ ^ 2) ∧
      (∑' j : ℕ, ‖arithmeticResidualTail c S v eta w M false j‖ ^ 2 +
        ‖arithmeticResidualTail c S v eta w M true j‖ ^ 2) ≤
          precisionTailBound ((e1 + B * e0) / p) ((4 / 3 : ℝ) * H + 4 * B * N / p * V) M := by
  obtain ⟨hm0, hm1, hmass⟩ := finite_moment_enclosures S v center
    (fun n => (arithmeticBoundarySymbol c n : ℂ)) symbolCenter ev es hev hes
  have hfreq : ‖w‖ ≤ (M : ℝ) / 2 := by
    have h := (norm_le_center_radius w wCenter ew hw).trans hwW
    linarith
  exact arithmetic_residual_defect_tail_bound hc S v N e0 e1 B p V H hN hS
    (hm0.trans h0) (hm1.trans h1) hB hp hpi (hmass.trans hV) eta w
    ((norm_le_center_radius eta etaCenter ee heta).trans hetaH) hM hMN hfreq

/-- Exact acceptance boundary after clearing the positive denominator. tau
is a squared-tail budget. Equality suffices for an upper bound; a nonzero
readout application must impose its own strict remaining margin. -/
theorem precision_tail_bound_iff (D Q tau : ℝ) {M : ℝ} (hM : 0 < M) :
    precisionTailBound D Q M ≤ tau ↔
      6 * D ^ 2 * M ^ 2 + 6 * D * Q * M + 2 * Q ^ 2 ≤ 3 * tau * M ^ 3 := by
  have hid : precisionTailBound D Q M =
      (6 * D ^ 2 * M ^ 2 + 6 * D * Q * M + 2 * Q ^ 2) / (3 * M ^ 3) := by
    unfold precisionTailBound
    field_simp [hM.ne']
    <;> ring
  rw [hid, div_le_iff₀ (show 0 < 3 * M ^ 3 by positivity)]
  ring_nf

/-- Sufficient precision/cutoff balance for a cubic squared-tail budget.
The condition D*M<=gamma*Q is explicitly required. A fixed nonzero D does
not by itself justify this cubic rate as M grows. -/
theorem precision_tail_bound_of_balance (D Q gamma M : ℝ)
    (hD : 0 ≤ D) (hQ : 0 ≤ Q) (hg : 0 ≤ gamma) (hM : 0 < M)
    (hbalance : D * M ≤ gamma * Q) :
    precisionTailBound D Q M ≤
      2 * (gamma ^ 2 + gamma + 1 / 3) * Q ^ 2 / M ^ 3 := by
  apply (precision_tail_bound_iff D Q _ hM).mpr
  have hsq := pow_le_pow_left₀ (mul_nonneg hD hM.le) hbalance 2
  have hcross := mul_le_mul_of_nonneg_right hbalance hQ
  have hid : 3 * (2 * (gamma ^ 2 + gamma + 1 / 3) * Q ^ 2 / M ^ 3) * M ^ 3 =
      6 * gamma ^ 2 * Q ^ 2 + 6 * gamma * Q ^ 2 + 2 * Q ^ 2 := by
    field_simp [hM.ne']
    <;> ring
  rw [hid]
  nlinarith

end D5.S3.Weil.ZetaBridge.WeilArithmeticResidualPrecision

end

namespace D5.S3.Weil.ZetaBridge.WeilArithmeticResidualPrecision

open D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingJet
open D5.S3.Weil.ZetaBridge.WeilArithmeticResidualTail
open scoped BigOperators

/-- Executable rational acceptance test. All arithmetic is exact. It checks
only nonnegative scalar budgets, positive cutoff, both separations, and the
cleared tail inequality. Analytic enclosure validity is still proved by the
caller; a false result means unaccepted, not a disproof of the true bound. -/
def residualTailCheck (M : ℕ) (N W D Q tau : ℚ) : Bool :=
  decide (0 < M ∧ 0 ≤ N ∧ 0 ≤ W ∧ 0 ≤ D ∧ 0 ≤ Q ∧ 0 ≤ tau ∧
    2 * N ≤ (M : ℚ) ∧ 2 * W ≤ (M : ℚ) ∧
    6 * D ^ 2 * (M : ℚ) ^ 2 + 6 * D * Q * (M : ℚ) + 2 * Q ^ 2 ≤ 3 * tau * (M : ℚ) ^ 3)

/-- Soundness of the rational scalar checker in real arithmetic. No float,
transcendental function or external numerical verdict is evaluated here. -/
theorem residual_tail_check_sound {M : ℕ} {N W D Q tau : ℚ}
    (h : residualTailCheck M N W D Q tau = true) :
    0 < M ∧ 2 * (N : ℝ) ≤ (M : ℝ) ∧ 2 * (W : ℝ) ≤ (M : ℝ) ∧
      precisionTailBound D Q M ≤ (tau : ℝ) := by
  have ht : 0 < M ∧ 0 ≤ N ∧ 0 ≤ W ∧ 0 ≤ D ∧ 0 ≤ Q ∧ 0 ≤ tau ∧
      2 * N ≤ (M : ℚ) ∧ 2 * W ≤ (M : ℚ) ∧
      6 * D ^ 2 * (M : ℚ) ^ 2 + 6 * D * Q * (M : ℚ) + 2 * Q ^ 2 ≤
        3 * tau * (M : ℚ) ^ 3 := by simpa only [residualTailCheck, decide_eq_true_eq] using h
  obtain ⟨hm, _, _, _, _, _, hn, hw, hb⟩ := ht
  refine ⟨hm, ?_, ?_, ?_⟩
  · exact_mod_cast hn
  · exact_mod_cast hw
  · apply (precision_tail_bound_iff (D : ℝ) (Q : ℝ) (tau : ℝ)
      (show 0 < (M : ℝ) by exact_mod_cast hm)).mpr
    exact_mod_cast hb

/-- Source enclosures and a successful rational tail check imply a bound on
all actual exterior residual coefficients. The checker supplies the cutoff
and frequency separations; coefficient, symbol and parameter enclosures stay
explicit. No success flag is substituted for those analytic proofs. -/
theorem rounded_residual_certificate_sound {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v center symbolCenter : ℤ → ℂ) (ev es : ℤ → ℝ)
    (hev : ∀ n ∈ S, ‖v n - center n‖ ≤ ev n)
    (hes : ∀ n ∈ S, ‖(arithmeticBoundarySymbol c n : ℂ) - symbolCenter n‖ ≤ es n)
    (N e0 e1 B p V H W tau : ℚ)
    (hN : 0 ≤ (N : ℝ)) (hS : ∀ n ∈ S, |(n : ℝ)| ≤ (N : ℝ))
    (h0 : ‖∑ n ∈ S, center n‖ + ∑ n ∈ S, ev n ≤ (e0 : ℝ))
    (h1 : ‖∑ n ∈ S, symbolCenter n * center n‖ +
      ∑ n ∈ S, (‖symbolCenter n‖ * ev n + es n * ‖center n‖ + es n * ev n) ≤ (e1 : ℝ))
    (hV : (∑ n ∈ S, (‖center n‖ + ev n)) ≤ (V : ℝ))
    (hB : arithmeticBoundaryBudget c ≤ (B : ℝ)) (hp : 0 < (p : ℝ))
    (hpi : (p : ℝ) ≤ Real.pi)
    (eta etaCenter w wCenter : ℂ) (ee ew : ℝ)
    (heta : ‖eta - etaCenter‖ ≤ ee) (hetaH : ‖etaCenter‖ + ee ≤ (H : ℝ))
    (hw : ‖w - wCenter‖ ≤ ew) (hwW : ‖wCenter‖ + ew ≤ (W : ℝ))
    {M : ℕ} (hcheck : residualTailCheck M N W ((e1 + B * e0) / p)
      ((4 / 3 : ℚ) * H + 4 * B * N / p * V) tau = true) :
    Summable (fun j : ℕ => ‖WeilArithmeticResidualTail.arithmeticResidualTail c S v eta w M false j‖ ^ 2 +
      ‖WeilArithmeticResidualTail.arithmeticResidualTail c S v eta w M true j‖ ^ 2) ∧
      (∑' j : ℕ, ‖WeilArithmeticResidualTail.arithmeticResidualTail c S v eta w M false j‖ ^ 2 +
        ‖WeilArithmeticResidualTail.arithmeticResidualTail c S v eta w M true j‖ ^ 2) ≤ (tau : ℝ) := by
  obtain ⟨hm, hmn, hmw, hb⟩ := residual_tail_check_sound hcheck
  obtain ⟨hs, he⟩ := rounded_arithmetic_residual_tail_bound hc S v center symbolCenter ev es
    hev hes N e0 e1 B p V H W hN hS h0 h1 hV hB hp hpi
    eta etaCenter w wCenter ee ew heta hetaH hw hwW hm hmn hmw
  refine ⟨hs, he.trans ?_⟩
  push_cast at hb
  exact hb

-- Exact scalar regression witnesses. They make no assertion about the
-- arithmetic symbol enclosures or about a physical operator instance.
example : residualTailCheck 1000 64 10 (1 / 1000000) 1 (1 / 1000000000) = true := by
  norm_num [residualTailCheck]

example : residualTailCheck 1000 64 10 (1 / 100) 1 (1 / 1000000000) = false := by
  norm_num [residualTailCheck]

example : residualTailCheck 0 0 0 0 0 0 = false := by
  norm_num [residualTailCheck]

example : residualTailCheck 100 64 10 0 0 1 = false := by
  norm_num [residualTailCheck]

example : residualTailCheck 100 10 51 0 0 1 = false := by
  norm_num [residualTailCheck]

#print axioms rounded_arithmetic_residual_tail_bound
#print axioms residual_tail_check_sound
#print axioms rounded_residual_certificate_sound

end D5.S3.Weil.ZetaBridge.WeilArithmeticResidualPrecision
