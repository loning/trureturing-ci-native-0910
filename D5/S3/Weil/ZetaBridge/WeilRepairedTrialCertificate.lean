/- GID: D5/S3/Weil/ZetaBridge/WeilRepairedTrialCertificate
   generality: I
   mirror-B: D5/B/S3/Weil/ZetaBridge/WeilRepairedTrialCertificate
   mirror-E: none(waiver:exact-repair-and-certified-arithmetic-tail)
   anchors: []
   digest: Recompute rational moment budgets after exact orthogonal repair and certify the same repaired arithmetic residual. -/

import D5.S3.Weil.ZetaBridge.FiniteRationalTrialRepair
import D5.S3.Weil.ZetaBridge.WeilArithmeticResidualPrecision

/-!
The repaired trial is interpreted as exact rational-complex data. Only the
actual real arithmetic symbol requires per-coordinate enclosure radii.
The moment centers and l1 mass are recomputed from the returned trial, not
carried over from the original numerical seed. The existing rational checker
is reused. Candidate orthogonality, support, moment bounds and the infinite
tail conclusion all concern the same output of `repairTrial`.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S3.Weil.ZetaBridge.WeilRepairedTrialCertificate

open D5.S3.Weil.ZetaBridge.FiniteRationalTrialRepair
open D5.S3.Weil.ZetaBridge.WeilArithmeticResidualPrecision
open D5.S3.Weil.ZetaBridge.WeilArithmeticResidualTail
open D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingJet
open scoped BigOperators ComplexConjugate ComplexInnerProductSpace

/-- Computable rational upper bounds (E0,E1,V) from the actual stored trial.
The symbol centers are real rationals; es are their absolute error radii.
Complex moduli are safely enclosed by sums of absolute real/imaginary parts. -/
def rationalMomentBudgets (S : Finset ℤ) (v : ℤ → ℚ × ℚ)
    (symbolCenter es : ℤ → ℚ) : ℚ × ℚ × ℚ :=
  (|∑ n ∈ S, (v n).1| + |∑ n ∈ S, (v n).2|,
   |∑ n ∈ S, symbolCenter n * (v n).1| + |∑ n ∈ S, symbolCenter n * (v n).2| +
     ∑ n ∈ S, es n * (|(v n).1| + |(v n).2|),
   ∑ n ∈ S, (|(v n).1| + |(v n).2|))

private theorem norm_decode_le (z : ℚ × ℚ) :
    ‖decode z‖ ≤ ((|z.1| + |z.2| : ℚ) : ℝ) := by
  unfold decode
  calc
    _ ≤ ‖((z.1 : ℝ) : ℂ)‖ + ‖((z.2 : ℝ) : ℂ) * Complex.I‖ := norm_add_le _ _
    _ = _ := by simp [norm_mul, Complex.norm_real, Real.norm_eq_abs]

private theorem sum_decode (S : Finset ℤ) (v : ℤ → ℚ × ℚ) :
    (∑ n ∈ S, decode (v n)) = decode (∑ n ∈ S, (v n).1, ∑ n ∈ S, (v n).2) := by
  simp [decode, Finset.sum_add_distrib, Finset.sum_mul]

private theorem weighted_sum_decode (S : Finset ℤ) (v : ℤ → ℚ × ℚ) (s : ℤ → ℚ) :
    (∑ n ∈ S, (s n : ℂ) * decode (v n)) =
      decode (∑ n ∈ S, s n * (v n).1, ∑ n ∈ S, s n * (v n).2) := by
  rw [← sum_decode S (fun n => (s n * (v n).1, s n * (v n).2))]
  apply Finset.sum_congr rfl
  intro n _
  simp only [decode]
  push_cast
  ring

/-- Soundness of the recomputed rational budgets for the actual arithmetic
symbol. The exact stored trial incurs no fictitious coefficient-rounding
radius. All real symbol enclosures remain explicit hypotheses. -/
theorem rational_moment_budgets_sound (c : ℕ) (S : Finset ℤ) (v : ℤ → ℚ × ℚ)
    (s es : ℤ → ℚ)
    (hs : ∀ n ∈ S, ‖(arithmeticBoundarySymbol c n : ℂ) - (s n : ℂ)‖ ≤ (es n : ℝ)) :
    let E := rationalMomentBudgets S v s es
    ‖∑ n ∈ S, decode (v n)‖ ≤ (E.1 : ℝ) ∧
      ‖∑ n ∈ S, (arithmeticBoundarySymbol c n : ℂ) * decode (v n)‖ ≤ (E.2.1 : ℝ) ∧
      (∑ n ∈ S, ‖decode (v n)‖) ≤ (E.2.2 : ℝ) := by
  have he0 (n) (hn : n ∈ S) : 0 ≤ (es n : ℝ) := (norm_nonneg _).trans (hs n hn)
  obtain ⟨_, hmoment, _⟩ := finite_moment_enclosures S
    (fun n => decode (v n)) (fun n => decode (v n))
    (fun n => (arithmeticBoundarySymbol c n : ℂ)) (fun n => (s n : ℂ))
    (fun _ => 0) (fun n => (es n : ℝ)) (by intros; simp) hs
  simp only [mul_zero, add_zero, zero_add] at hmoment
  refine ⟨?_, ?_, ?_⟩
  · rw [sum_decode]
    exact norm_decode_le _
  · have hcenter : ‖∑ n ∈ S, (s n : ℂ) * decode (v n)‖ ≤
        ((|∑ n ∈ S, s n * (v n).1| + |∑ n ∈ S, s n * (v n).2| : ℚ) : ℝ) := by
      rw [weighted_sum_decode]
      exact norm_decode_le _
    have herr := Finset.sum_le_sum (s := S) fun n hn =>
      mul_le_mul_of_nonneg_left (norm_decode_le (v n)) (he0 n hn)
    have hout := hmoment.trans (add_le_add hcenter herr)
    simpa only [rationalMomentBudgets, Rat.cast_add, Rat.cast_sum, Rat.cast_mul] using hout
  · have hout := Finset.sum_le_sum (s := S) fun n _ => norm_decode_le (v n)
    simpa only [rationalMomentBudgets, Rat.cast_sum] using hout

/-- End-to-end certificate for the same repaired trial: finite support and
exact complex candidate orthogonality are derived from the algorithm, while
all moments and mass are computed rationally from its output. A successful
existing tail check yields square summability and the complete exterior
bound. No input horth, moment bound or coefficient-mass bound is requested.
The actual arithmetic symbol/envelope, parameter bounds and eventual
operator/basis identification are not certified by the rational checker. -/
theorem repaired_arithmetic_residual_certificate {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (k v t : ℤ → ℚ × ℚ) (hrepair : repairTrial S k v = some t)
    (s es : ℤ → ℚ)
    (hs : ∀ n ∈ S, ‖(arithmeticBoundarySymbol c n : ℂ) - (s n : ℂ)‖ ≤ (es n : ℝ))
    (N B p H W tau : ℚ) (hN : 0 ≤ (N : ℝ))
    (hS : ∀ n ∈ S, |(n : ℝ)| ≤ (N : ℝ))
    (hB : arithmeticBoundaryBudget c ≤ (B : ℝ)) (hp : 0 < (p : ℝ))
    (hpi : (p : ℝ) ≤ Real.pi) (eta w : ℂ)
    (heta : ‖eta‖ ≤ (H : ℝ)) (hw : ‖w‖ ≤ (W : ℝ)) {M : ℕ}
    (hcheck : let E := rationalMomentBudgets S t s es
      residualTailCheck M N W ((E.2.1 + B * E.1) / p)
        ((4 / 3 : ℚ) * H + 4 * B * N / p * E.2.2) tau = true) :
    (∀ n, n ∉ S → t n = (0, 0)) ∧
      (∑ n ∈ S, conj (decode (k n)) * decode (t n)) = 0 ∧
      Summable (fun j : ℕ => ‖arithmeticResidualTail c S (fun n => decode (t n)) eta w M false j‖ ^ 2 +
        ‖arithmeticResidualTail c S (fun n => decode (t n)) eta w M true j‖ ^ 2) ∧
      (∑' j : ℕ, ‖arithmeticResidualTail c S (fun n => decode (t n)) eta w M false j‖ ^ 2 +
        ‖arithmeticResidualTail c S (fun n => decode (t n)) eta w M true j‖ ^ 2) ≤ (tau : ℝ) := by
  let E := rationalMomentBudgets S t s es
  obtain ⟨hm, hmn, hmw, hbound⟩ := residual_tail_check_sound hcheck
  obtain ⟨h0, h1, hmass⟩ := rational_moment_budgets_sound c S t s es hs
  have hfreq : ‖w‖ ≤ (M : ℝ) / 2 := by linarith [hw, hmw]
  obtain ⟨hsum, htail⟩ := arithmetic_residual_defect_tail_bound hc S (fun n => decode (t n))
    N E.1 E.2.1 B p E.2.2 H hN hS h0 h1 hB hp hpi hmass eta w heta hm hmn hfreq
  refine ⟨(repair_coordinates S k v t hrepair).1,
    (repair_orthogonal_and_norm_le S k v t hrepair).1, hsum, htail.trans ?_⟩
  push_cast at hbound
  exact hbound

#print axioms rational_moment_budgets_sound
#print axioms repaired_arithmetic_residual_certificate

end D5.S3.Weil.ZetaBridge.WeilRepairedTrialCertificate
