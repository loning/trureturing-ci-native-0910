/- GID: D5/S3/Weil/ZetaBridge/WeilArithmeticFullResidualTail
   generality: I
   mirror-B: D5/B/S3/Weil/ZetaBridge/WeilArithmeticFullResidualTail
   mirror-E: none(waiver:actual-arithmetic-full-residual-tail)
   anchors: []
   digest: Sum the actual arithmetic coupling jets over every omitted mode and control a full Cauchy-readout residual, retaining four boundary moments. -/

import D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingParityGram
import Mathlib.Tactic.Omega

/-!
# A full residual tail, distinct from a weighted dual pairing

The column and its second jet are the existing prime-pole-Gamma objects.
The paired identity and pointwise error are reused without changing them.
This owner proves square summability over the ENTIRE exterior, then bounds
an actual Cauchy-readout-minus-column residual. No tail of an unknown operator,
finite residual, exact dual inverse, or desired directional inequality is an
input. The four boundary moments are not set to zero.

The final residual coefficient is expressed on the integer Fourier lattice.
Its physical prefactor and its identification with a particular L2 operator
residual must be matched to the existing Fourier/basis/domain realization.
This file does not assert those analytic identifications, a spectral gap,
prolate approximation at unbounded scales, or RH.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section
namespace D5.S3.Weil.ZetaBridge.WeilArithmeticFullResidualTail

open scoped BigOperators
open D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingJet
open D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingSecondJet
open D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingParityGram

private def nTail (M j : ℕ) : ℕ := M + j + 1
private def invTail (M k j : ℕ) : ℝ := 1 / (nTail M j : ℝ) ^ (k + 2)

private theorem inverse_square_step {x : ℝ} (hx : 0 < x) :
    1 / (x + 1) ^ 2 ≤ 1 / x - 1 / (x + 1) := by
  have hx1 : x + 1 ≠ 0 := ne_of_gt (by linarith)
  have hid : (1 / x - 1 / (x + 1)) - 1 / (x + 1) ^ 2 =
      1 / (x * (x + 1) ^ 2) := by
    field_simp [hx.ne', hx1]
    <;> ring
  apply sub_nonneg.mp
  rw [hid]
  positivity

private theorem inverse_square_partial {M : ℕ} (hM : 0 < M) (K : ℕ) :
    (∑ j ∈ Finset.range K, invTail M 0 j) ≤
      1 / (M : ℝ) - 1 / ((M : ℝ) + (K : ℝ)) := by
  have hMr : 0 < (M : ℝ) := by exact_mod_cast hM
  induction K with
  | zero => simp
  | succ K ih =>
      rw [Finset.sum_range_succ]
      have hs := inverse_square_step (show 0 < (M : ℝ) + (K : ℝ) by positivity)
      dsimp [invTail, nTail] at ih ⊢
      simp only [Nat.cast_add, Nat.cast_one, Nat.cast_succ, ← add_assoc] at ih ⊢
      linarith

/-- Elementary summation internal to the arithmetic proof. The conservative
M^(-(k+1)) bound suffices; no asymptotic or numerical zeta value is used. -/
private theorem inverse_power_tail {M : ℕ} (hM : 0 < M) (k : ℕ) :
    Summable (invTail M k) ∧
      (∑' j : ℕ, invTail M k j) ≤ 1 / (M : ℝ) ^ (k + 1) := by
  have hMr : 0 < (M : ℝ) := by exact_mod_cast hM
  have h0 (j : ℕ) : 0 ≤ invTail M 0 j := by unfold invTail; positivity
  have hpartial (K : ℕ) : (∑ j ∈ Finset.range K, invTail M 0 j) ≤ 1 / (M : ℝ) := by
    have h := inverse_square_partial hM K
    have hn : 0 ≤ 1 / ((M : ℝ) + (K : ℝ)) := by positivity
    linarith
  have hs0 : Summable (invTail M 0) := summable_of_sum_range_le h0 hpartial
  have ht0 : (∑' j : ℕ, invTail M 0 j) ≤ 1 / (M : ℝ) :=
    Real.tsum_le_of_sum_range_le h0 hpartial
  have hdom (j : ℕ) : invTail M k j ≤ (1 / (M : ℝ) ^ k) * invTail M 0 j := by
    have hm : (M : ℝ) ≤ (nTail M j : ℝ) := by
      unfold nTail
      push_cast
      linarith [Nat.cast_nonneg j]
    have hnt : 0 < (nTail M j : ℝ) := lt_of_lt_of_le hMr hm
    have hpow : (M : ℝ) ^ k ≤ (nTail M j : ℝ) ^ k :=
      pow_le_pow_left₀ hMr.le hm k
    have hi := one_div_le_one_div_of_le (pow_pos hMr k) hpow
    calc
      _ = (1 / (nTail M j : ℝ) ^ k) * (1 / (nTail M j : ℝ) ^ 2) := by
        simp only [invTail, pow_add]
        field_simp [hnt.ne']
        <;> ring
      _ ≤ (1 / (M : ℝ) ^ k) * (1 / (nTail M j : ℝ) ^ 2) :=
        mul_le_mul_of_nonneg_right hi (by positivity)
      _ = _ := by simp only [invTail, zero_add]
  have hn (j : ℕ) : 0 ≤ invTail M k j := by unfold invTail; positivity
  have hs := Summable.of_nonneg_of_le hn hdom (hs0.mul_left (1 / (M : ℝ) ^ k))
  refine ⟨hs, ?_⟩
  calc
    _ ≤ ∑' j : ℕ, (1 / (M : ℝ) ^ k) * invTail M 0 j :=
      hs.tsum_le_tsum hdom (hs0.mul_left _)
    _ = (1 / (M : ℝ) ^ k) * ∑' j : ℕ, invTail M 0 j := by rw [tsum_mul_left]
    _ ≤ (1 / (M : ℝ) ^ k) * (1 / (M : ℝ)) :=
      mul_le_mul_of_nonneg_left ht0 (by positivity)
    _ = _ := by
      rw [pow_succ]
      field_simp [hMr.ne']
      <;> ring

private theorem norm_add_sq_le (x y : ℂ) :
    ‖x + y‖ ^ 2 ≤ 2 * ‖x‖ ^ 2 + 2 * ‖y‖ ^ 2 := by
  have ht := norm_add_le x y
  have ht2 := pow_le_pow_left₀ (norm_nonneg (x + y)) ht 2
  nlinarith [sq_nonneg (‖x‖ - ‖y‖)]

private theorem norm_sub_sq_le (x y : ℂ) :
    ‖x - y‖ ^ 2 ≤ 2 * ‖x‖ ^ 2 + 2 * ‖y‖ ^ 2 := by
  simpa only [sub_eq_add_neg, norm_neg] using norm_add_sq_le x (-y)

private def moment0 (S : Finset ℤ) (v : ℤ → ℂ) : ℂ := ∑ n ∈ S, v n
private def momentS (c : ℕ) (S : Finset ℤ) (v : ℤ → ℂ) : ℂ :=
  ∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * v n
private def moment1 (S : Finset ℤ) (v : ℤ → ℂ) : ℂ := ∑ n ∈ S, (n : ℂ) * v n
private def momentS1 (c : ℕ) (S : Finset ℤ) (v : ℤ → ℂ) : ℂ :=
  ∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * ((n : ℂ) * v n)
private def mass0 (c : ℕ) (S : Finset ℤ) (v : ℤ → ℂ) : ℝ :=
  arithmeticBoundaryBudget c ^ 2 * ‖moment0 S v‖ ^ 2 + ‖momentS c S v‖ ^ 2
private def mass1 (c : ℕ) (S : Finset ℤ) (v : ℤ → ℂ) : ℝ :=
  arithmeticBoundaryBudget c ^ 2 * ‖moment1 S v‖ ^ 2 + ‖momentS1 c S v‖ ^ 2
private def remainderCoefficient (c : ℕ) (S : Finset ℤ) (v : ℤ → ℂ)
    (N : ℝ) (M : ℕ) : ℝ :=
  (2 * arithmeticBoundaryBudget c * N ^ 2 * (M : ℝ) /
    (Real.pi * ((M : ℝ) - N))) * ∑ n ∈ S, ‖v n‖

/-- An explicit bound for the entire two-sided exterior column energy.
The private abbreviations expand to the four actual finite boundary moments.
Its three contributions have orders M^-1, M^-3 and M^-5 at fixed N. -/
def arithmeticColumnTailBudget (c : ℕ) (S : Finset ℤ) (v : ℤ → ℂ)
    (N : ℝ) (M : ℕ) : ℝ :=
  8 * mass0 c S v / (Real.pi ^ 2 * (M : ℝ)) +
  8 * mass1 c S v / (Real.pi ^ 2 * (M : ℝ) ^ 3) +
  4 * remainderCoefficient c S v N M ^ 2 / (M : ℝ) ^ 5

private theorem jet_pair_bound {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v : ℤ → ℂ) (m : ℕ) (hm : 0 < m) :
    ‖couplingSecondJet c S v (m : ℤ)‖ ^ 2 +
      ‖couplingSecondJet c S v (-(m : ℤ))‖ ^ 2 ≤
        4 * mass0 c S v / (Real.pi ^ 2 * (m : ℝ) ^ 2) +
        4 * mass1 c S v / (Real.pi ^ 2 * (m : ℝ) ^ 4) := by
  have hmr : 0 < (m : ℝ) := by exact_mod_cast hm
  have hmc : ‖(m : ℂ)‖ = (m : ℝ) := by simp
  let s : ℂ := (arithmeticBoundarySymbol c (m : ℤ) : ℂ)
  have hs : ‖s‖ ≤ arithmeticBoundaryBudget c := by
    simpa only [s, Complex.norm_real, Real.norm_eq_abs] using
      (arithmetic_boundary_symbol_bound hc (m : ℤ)).2
  have hs2 := pow_le_pow_left₀ (norm_nonneg _) hs 2
  have hp := norm_add_sq_le (-s * moment0 S v) (momentS1 c S v / (m : ℂ))
  have hn := norm_sub_sq_le (momentS c S v) (s * moment1 S v / (m : ℂ))
  simp only [norm_mul, norm_neg, norm_div, hmc, mul_pow, div_pow] at hp hn
  have h0 := mul_le_mul_of_nonneg_right hs2 (sq_nonneg ‖moment0 S v‖)
  have h1 := mul_le_mul_of_nonneg_right hs2 (sq_nonneg ‖moment1 S v‖)
  have h1' := div_le_div_of_nonneg_right h1 (sq_nonneg (m : ℝ))
  have hinside :
      ‖-s * moment0 S v + momentS1 c S v / (m : ℂ)‖ ^ 2 +
      ‖momentS c S v - s * moment1 S v / (m : ℂ)‖ ^ 2 ≤
      2 * mass0 c S v + 2 * mass1 c S v / (m : ℝ) ^ 2 := by
    dsimp [mass0, mass1]
    simp only [add_div, mul_div_assoc] at hp hn h1' ⊢
    nlinarith
  have hpai := arithmetic_second_jet_pair_energy c S v (m : ℤ)
    (by exact_mod_cast hm.ne')
  dsimp only at hpai
  simp only [Int.cast_natCast] at hpai
  rw [hpai]
  change (2 / (Real.pi ^ 2 * (m : ℝ) ^ 2)) *
      (‖-s * moment0 S v + momentS1 c S v / (m : ℂ)‖ ^ 2 +
       ‖momentS c S v - s * moment1 S v / (m : ℂ)‖ ^ 2) ≤ _
  calc
    _ ≤ (2 / (Real.pi ^ 2 * (m : ℝ) ^ 2)) *
      (2 * mass0 c S v + 2 * mass1 c S v / (m : ℝ) ^ 2) :=
        mul_le_mul_of_nonneg_left hinside (by positivity)
    _ = _ := by field_simp [Real.pi_ne_zero, hmr.ne']; ring

private theorem remainder_bound_at_cutoff {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v : ℤ → ℂ) {N : ℝ} (hN : 0 ≤ N)
    (hS : ∀ n ∈ S, |(n : ℝ)| ≤ N)
    (M : ℕ) (hNM : N < (M : ℝ)) (m : ℤ) (hMm : (M : ℝ) ≤ |(m : ℝ)|) :
    ‖couplingColumn c S v m - couplingSecondJet c S v m‖ ≤
      remainderCoefficient c S v N M / |(m : ℝ)| ^ 3 := by
  have hMp : 0 < (M : ℝ) := lt_of_le_of_lt hN hNM
  have hmp : 0 < |(m : ℝ)| := lt_of_lt_of_le hMp hMm
  have hgap : 0 < |(m : ℝ)| - N := by linarith
  have hcut : 0 < (M : ℝ) - N := sub_pos.mpr hNM
  have hb : 0 ≤ arithmeticBoundaryBudget c :=
    (abs_nonneg _).trans (arithmetic_boundary_symbol_bound hc m).2
  have hratio : 1 / (|(m : ℝ)| - N) ≤
      (M : ℝ) / (((M : ℝ) - N) * |(m : ℝ)|) := by
    apply (div_le_div_iff₀ hgap (mul_pos hcut hmp)).mpr
    nlinarith [mul_nonneg hN (sub_nonneg.mpr hMm)]
  have hl1 : 0 ≤ ∑ n ∈ S, ‖v n‖ := Finset.sum_nonneg (fun _ _ => norm_nonneg _)
  have he := arithmetic_coupling_second_jet_error hc S v hN hS (lt_of_lt_of_le hNM hMm)
  calc
    _ ≤ (2 * arithmeticBoundaryBudget c * N ^ 2 /
      (Real.pi * |(m : ℝ)| ^ 2 * (|(m : ℝ)| - N))) * ∑ n ∈ S, ‖v n‖ := he
    _ = ((2 * arithmeticBoundaryBudget c * N ^ 2 /
      (Real.pi * |(m : ℝ)| ^ 2)) * (1 / (|(m : ℝ)| - N))) * ∑ n ∈ S, ‖v n‖ := by
      field_simp [Real.pi_ne_zero, hmp.ne', hgap.ne']
      <;> ring
    _ ≤ ((2 * arithmeticBoundaryBudget c * N ^ 2 /
      (Real.pi * |(m : ℝ)| ^ 2)) *
      ((M : ℝ) / (((M : ℝ) - N) * |(m : ℝ)|))) * ∑ n ∈ S, ‖v n‖ :=
      mul_le_mul_of_nonneg_right
        (mul_le_mul_of_nonneg_left hratio (by positivity)) hl1
    _ = _ := by
      unfold remainderCoefficient
      field_simp [Real.pi_ne_zero, hmp.ne', hcut.ne']
      <;> ring

private theorem column_pair_bound {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v : ℤ → ℂ) {N : ℝ} (hN : 0 ≤ N)
    (hS : ∀ n ∈ S, |(n : ℝ)| ≤ N)
    (M : ℕ) (hNM : N < (M : ℝ)) (m : ℕ) (hMm : M ≤ m) :
    ‖couplingColumn c S v (m : ℤ)‖ ^ 2 + ‖couplingColumn c S v (-(m : ℤ))‖ ^ 2 ≤
      (8 * mass0 c S v / Real.pi ^ 2) * (1 / (m : ℝ) ^ 2) +
      (8 * mass1 c S v / Real.pi ^ 2) * (1 / (m : ℝ) ^ 4) +
      (4 * remainderCoefficient c S v N M ^ 2) * (1 / (m : ℝ) ^ 6) := by
  have hMp : 0 < (M : ℝ) := lt_of_le_of_lt hN hNM
  have hMm' : (M : ℝ) ≤ (m : ℝ) := by exact_mod_cast hMm
  have hmp : 0 < (m : ℝ) := lt_of_lt_of_le hMp hMm'
  have hmn : 0 < m := by exact_mod_cast hmp
  have hp := remainder_bound_at_cutoff hc S v hN hS M hNM (m : ℤ)
    (by simpa only [Int.cast_natCast, abs_of_pos hmp] using hMm')
  have hn := remainder_bound_at_cutoff hc S v hN hS M hNM (-(m : ℤ))
    (by simpa only [Int.cast_neg, Int.cast_natCast, abs_neg, abs_of_pos hmp] using hMm')
  simp only [Int.cast_natCast, Int.cast_neg, abs_neg, abs_of_pos hmp] at hp hn
  have hp2 := pow_le_pow_left₀ (norm_nonneg _) hp 2
  have hn2 := pow_le_pow_left₀ (norm_nonneg _) hn 2
  have hplus := norm_add_sq_le
    (couplingColumn c S v (m : ℤ) - couplingSecondJet c S v (m : ℤ))
    (couplingSecondJet c S v (m : ℤ))
  have hminus := norm_add_sq_le
    (couplingColumn c S v (-(m : ℤ)) - couplingSecondJet c S v (-(m : ℤ)))
    (couplingSecondJet c S v (-(m : ℤ)))
  rw [sub_add_cancel] at hplus hminus
  have hj := jet_pair_bound hc S v m hmn
  have hid : (remainderCoefficient c S v N M / (m : ℝ) ^ 3) ^ 2 =
      remainderCoefficient c S v N M ^ 2 / (m : ℝ) ^ 6 := by
    rw [div_pow, ← pow_mul]
    norm_num
  rw [hid] at hp2 hn2
  have hcombined :
      ‖couplingColumn c S v (m : ℤ)‖ ^ 2 +
        ‖couplingColumn c S v (-(m : ℤ))‖ ^ 2 ≤
        2 * (4 * mass0 c S v / (Real.pi ^ 2 * (m : ℝ) ^ 2) +
          4 * mass1 c S v / (Real.pi ^ 2 * (m : ℝ) ^ 4)) +
          4 * (remainderCoefficient c S v N M ^ 2 / (m : ℝ) ^ 6) := by
    linarith
  calc
    _ ≤ _ := hcombined
    _ = _ := by
      field_simp [Real.pi_ne_zero, hmp.ne']
      <;> ring

/-- Full two-sided square summability and an explicit tail budget for the
ACTUAL arithmetic column. All positive and negative modes beyond M occur.
No unexplained summability or tail estimate is supplied by the caller. -/
theorem arithmetic_column_full_tail {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v : ℤ → ℂ) {N : ℝ} (hN : 0 ≤ N)
    (hS : ∀ n ∈ S, |(n : ℝ)| ≤ N) (M : ℕ) (hNM : N < (M : ℝ)) :
    let f := fun j : ℕ =>
      ‖couplingColumn c S v ((M + j + 1 : ℕ) : ℤ)‖ ^ 2 +
      ‖couplingColumn c S v (-((M + j + 1 : ℕ) : ℤ))‖ ^ 2
    Summable f ∧ (∑' j : ℕ, f j) ≤ arithmeticColumnTailBudget c S v N M := by
  dsimp only
  have hMp : 0 < (M : ℝ) := lt_of_le_of_lt hN hNM
  have hM : 0 < M := by exact_mod_cast hMp
  obtain ⟨hs2, ht2⟩ := inverse_power_tail hM 0
  obtain ⟨hs4, ht4⟩ := inverse_power_tail hM 2
  obtain ⟨hs6, ht6⟩ := inverse_power_tail hM 4
  let a := 8 * mass0 c S v / Real.pi ^ 2
  let b := 8 * mass1 c S v / Real.pi ^ 2
  let d := 4 * remainderCoefficient c S v N M ^ 2
  have ha : 0 ≤ a := by unfold a mass0; positivity
  have hb : 0 ≤ b := by unfold b mass1; positivity
  have hd : 0 ≤ d := by unfold d; positivity
  have hs := ((hs2.mul_left a).add (hs4.mul_left b)).add (hs6.mul_left d)
  have hpoint (j : ℕ) :
      ‖couplingColumn c S v ((M + j + 1 : ℕ) : ℤ)‖ ^ 2 +
      ‖couplingColumn c S v (-((M + j + 1 : ℕ) : ℤ))‖ ^ 2 ≤
      a * invTail M 0 j + b * invTail M 2 j + d * invTail M 4 j := by
    exact column_pair_bound hc S v hN hS M hNM (M + j + 1) (by omega)
  have hf := Summable.of_nonneg_of_le (fun _ => add_nonneg (sq_nonneg _) (sq_nonneg _)) hpoint hs
  refine ⟨hf, ?_⟩
  calc
    _ ≤ ∑' j : ℕ, (a * invTail M 0 j + b * invTail M 2 j + d * invTail M 4 j) :=
      hf.tsum_le_tsum hpoint hs
    _ = a * (∑' j : ℕ, invTail M 0 j) + b * (∑' j : ℕ, invTail M 2 j) +
        d * (∑' j : ℕ, invTail M 4 j) := by
      rw [Summable.tsum_add ((hs2.mul_left a).add (hs4.mul_left b)) (hs6.mul_left d),
        Summable.tsum_add (hs2.mul_left a) (hs4.mul_left b)]
      simp only [tsum_mul_left]
    _ ≤ a * (1 / (M : ℝ) ^ (0 + 1)) + b * (1 / (M : ℝ) ^ (2 + 1)) +
        d * (1 / (M : ℝ) ^ (4 + 1)) :=
      add_le_add (add_le_add (mul_le_mul_of_nonneg_left ht2 ha)
        (mul_le_mul_of_nonneg_left ht4 hb)) (mul_le_mul_of_nonneg_left ht6 hd)
    _ = _ := by
      unfold a b d arithmeticColumnTailBudget
      norm_num only [pow_one]
      field_simp [Real.pi_ne_zero, hMp.ne']
      <;> ring

/-- An explicitly specified Fourier-lattice readout minus the actual column.
This introduces no new Fourier transform: pref and frequency are the physical
normalization data that a concrete L2 Fourier identification must supply. -/
def arithmeticReadoutResidual (c : ℕ) (S : Finset ℤ) (v : ℤ → ℂ)
    (pref frequency : ℂ) (m : ℤ) : ℂ :=
  pref / ((m : ℂ) ^ 2 - frequency ^ 2) - couplingColumn c S v m

private theorem cauchy_coefficient_bound (pref frequency : ℂ) (m : ℤ)
    (hm : 0 < |(m : ℝ)|) (hf : ‖frequency‖ ≤ |(m : ℝ)| / 2) :
    ‖pref / ((m : ℂ) ^ 2 - frequency ^ 2)‖ ^ 2 ≤
      (16 * ‖pref‖ ^ 2 / 9) * (1 / |(m : ℝ)| ^ 4) := by
  have ht := norm_sub_norm_le ((m : ℂ) ^ 2) (frequency ^ 2)
  have hf2 := pow_le_pow_left₀ (norm_nonneg _) hf 2
  have hcast : ‖(m : ℂ)‖ = |(m : ℝ)| := by simp
  simp only [norm_pow, hcast] at ht
  have hden : (3 / 4 : ℝ) * |(m : ℝ)| ^ 2 ≤ ‖(m : ℂ) ^ 2 - frequency ^ 2‖ := by
    nlinarith
  have hinv := div_le_div_of_nonneg_left (norm_nonneg pref) (by positivity) hden
  have hnorm : ‖pref / ((m : ℂ) ^ 2 - frequency ^ 2)‖ ≤
      4 * ‖pref‖ / (3 * |(m : ℝ)| ^ 2) := by
    rw [norm_div]
    convert hinv using 1
    field_simp [hm.ne']
    <;> ring
  have hs := pow_le_pow_left₀ (norm_nonneg _) hnorm 2
  convert hs using 1
  field_simp [hm.ne']
  <;> ring

/-- Complete residual tail, with physical Cauchy numerator, both signs,
all four boundary moments and the full uncomputed jet remainder retained.
This is an unweighted squared residual norm estimate, not the weighted
arithmetic dual pairing owned by WeilArithmeticFourierDualTail. -/
theorem arithmetic_full_residual_tail {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (v : ℤ → ℂ) {N : ℝ} (hN : 0 ≤ N)
    (hS : ∀ n ∈ S, |(n : ℝ)| ≤ N) (M : ℕ) (hNM : N < (M : ℝ))
    (pref frequency : ℂ) (hfrequency : ‖frequency‖ ≤ (M : ℝ) / 2) :
    let f := fun j : ℕ =>
      ‖arithmeticReadoutResidual c S v pref frequency ((M + j + 1 : ℕ) : ℤ)‖ ^ 2 +
      ‖arithmeticReadoutResidual c S v pref frequency (-((M + j + 1 : ℕ) : ℤ))‖ ^ 2
    Summable f ∧ (∑' j : ℕ, f j) ≤
      2 * arithmeticColumnTailBudget c S v N M +
        64 * ‖pref‖ ^ 2 / (9 * (M : ℝ) ^ 3) := by
  dsimp only
  have hMp : 0 < (M : ℝ) := lt_of_le_of_lt hN hNM
  have hM : 0 < M := by exact_mod_cast hMp
  obtain ⟨hsc, htc⟩ := arithmetic_column_full_tail hc S v hN hS M hNM
  obtain ⟨hsi, hti⟩ := inverse_power_tail hM 2
  let col := fun j : ℕ => ‖couplingColumn c S v ((M + j + 1 : ℕ) : ℤ)‖ ^ 2 +
      ‖couplingColumn c S v (-((M + j + 1 : ℕ) : ℤ))‖ ^ 2
  let K := 64 * ‖pref‖ ^ 2 / 9
  have hK : 0 ≤ K := by unfold K; positivity
  have hs := (hsc.mul_left 2).add (hsi.mul_left K)
  have hpoint (j : ℕ) :
      ‖arithmeticReadoutResidual c S v pref frequency ((M + j + 1 : ℕ) : ℤ)‖ ^ 2 +
      ‖arithmeticReadoutResidual c S v pref frequency (-((M + j + 1 : ℕ) : ℤ))‖ ^ 2 ≤
      2 * col j + K * invTail M 2 j := by
    let m : ℤ := (M + j + 1 : ℕ)
    have hm : 0 < (m : ℝ) := by
      dsimp [m]
      push_cast
      linarith [Nat.cast_nonneg j]
    have hMm : (M : ℝ) ≤ (m : ℝ) := by
      dsimp [m]
      push_cast
      linarith [Nat.cast_nonneg j]
    have hf : ‖frequency‖ ≤ |(m : ℝ)| / 2 := by rw [abs_of_pos hm]; linarith
    have hp := cauchy_coefficient_bound pref frequency m (by rwa [abs_of_pos hm]) hf
    have hn := cauchy_coefficient_bound pref frequency (-m)
      (by simpa only [Int.cast_neg, abs_neg, abs_of_pos hm] using hm)
      (by simpa only [Int.cast_neg, abs_neg] using hf)
    have hp' := norm_sub_sq_le (pref / ((m : ℂ) ^ 2 - frequency ^ 2)) (couplingColumn c S v m)
    have hn' := norm_sub_sq_le (pref / ((-m : ℂ) ^ 2 - frequency ^ 2)) (couplingColumn c S v (-m))
    simp only [Int.cast_neg, abs_neg, abs_of_pos hm] at hp hn
    dsimp [arithmeticReadoutResidual, col, K, invTail, nTail]
    change ‖pref / ((m : ℂ) ^ 2 - frequency ^ 2) - couplingColumn c S v m‖ ^ 2 +
      ‖pref / ((-m : ℂ) ^ 2 - frequency ^ 2) - couplingColumn c S v (-m)‖ ^ 2 ≤ _
    have hcast : (m : ℝ) = ((M + j + 1 : ℕ) : ℝ) := by
      simp only [m, Int.cast_natCast]
    rw [hcast] at hp hn
    nlinarith
  have hf := Summable.of_nonneg_of_le (fun _ => add_nonneg (sq_nonneg _) (sq_nonneg _)) hpoint hs
  refine ⟨hf, ?_⟩
  calc
    _ ≤ ∑' j : ℕ, (2 * col j + K * invTail M 2 j) := hf.tsum_le_tsum hpoint hs
    _ = 2 * (∑' j : ℕ, col j) + K * (∑' j : ℕ, invTail M 2 j) := by
      rw [Summable.tsum_add (hsc.mul_left 2) (hsi.mul_left K)]
      simp only [tsum_mul_left]
    _ ≤ 2 * arithmeticColumnTailBudget c S v N M + K * (1 / (M : ℝ) ^ (2 + 1)) :=
      add_le_add (mul_le_mul_of_nonneg_left htc (by norm_num))
        (mul_le_mul_of_nonneg_left hti hK)
    _ = _ := by
      unfold K
      norm_num only
      field_simp [hMp.ne']
      <;> ring

#print axioms arithmetic_column_full_tail
#print axioms arithmetic_full_residual_tail

end D5.S3.Weil.ZetaBridge.WeilArithmeticFullResidualTail
end
