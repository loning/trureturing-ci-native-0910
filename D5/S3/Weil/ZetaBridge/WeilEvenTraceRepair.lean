/- GID: D5/S3/Weil/ZetaBridge/WeilEvenTraceRepair
   generality: I
   mirror-B: D5/B/S3/Weil/ZetaBridge/WeilEvenTraceRepair
   mirror-E: none(waiver:coefficient-construction-with-separate-operator-domain)
   anchors: []
   digest: Construct exact rational even zero-trace candidate-orthogonal trials and certify their complete cubic residual tails without symbol enclosures. -/

import D5.S3.Weil.ZetaBridge.FiniteRationalTrialRepair
import D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingParityGram

/-!
The actual arithmetic symbol, rational one-vector repair and complete tail
checker retain their existing owners. The construction works in parameters
of V_n + V_(-n) - 2 V_0. Candidate orthogonality reduces to one pairing with
k_n-k_0. A zero contrast is a redundant constraint, so its seed is retained.
All three exact constraints concern the same returned rational trial.

For positive S these are independent positive-frequency parameters. The
identities and safety theorem work for any finite S, including empty S.
Parameter-space norm contraction is not asserted for the lifted norm.
The coefficient tail theorem does not construct the canonical Fourier basis,
prove operator-domain membership or certify an interior residual.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S3.Weil.ZetaBridge.WeilEvenTraceRepair

open scoped BigOperators ComplexConjugate
open D5.S3.Weil.ZetaBridge.FiniteRationalTrialRepair
open D5.S3.Weil.ZetaBridge.WeilOrthogonalTrialPrecision
open D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingJet
open D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingParityGram
open D5.S3.Weil.ZetaBridge.WeilArithmeticResidualTail
open D5.S3.Weil.ZetaBridge.WeilArithmeticResidualPrecision

/-- The support of the zero-trace even coefficient synthesis. -/
def symmetricSupport (S : Finset ℤ) : Finset ℤ :=
  insert 0 (S ∪ S.image (fun n => -n))

/-- Finite additive synthesis of the stencils delta_n+delta_(-n)-2delta_0.
The same executable definition applies to rational pairs and complex values. -/
def evenTraceLift {A : Type*} [AddCommGroup A] (S : Finset ℤ)
    (u : ℤ → A) (m : ℤ) : A :=
  ∑ n ∈ S, ((if m = n then u n else 0) + (if m = -n then u n else 0) -
    (if m = 0 then u n + u n else 0))

/-- Repair the single contrast pairing. The original repair returns none
exactly when the contrast vanishes on S; then this constraint is redundant. -/
def repairedEvenParameters (S : Finset ℤ) (k seed : ℤ → ℚ × ℚ) : ℤ → ℚ × ℚ :=
  (repairTrial S (fun n => k n - k 0) seed).getD seed

/-- The returned trial is exact rational-complex data on the full signed support. -/
def repairedEvenTrial (S : Finset ℤ) (k seed : ℤ → ℚ × ℚ) : ℤ → ℚ × ℚ :=
  evenTraceLift S (repairedEvenParameters S k seed)

/-- A rational upper bound on the full signed coefficient l1 mass.
The mass is recomputed from the corrected parameters. -/
def evenTrialMassBudget (S : Finset ℤ) (k seed : ℤ → ℚ × ℚ) : ℚ :=
  4 * ∑ n ∈ S, (|(repairedEvenParameters S k seed n).1| +
    |(repairedEvenParameters S k seed n).2|)

private theorem mem_support (S : Finset ℤ) {n : ℤ} (hn : n ∈ S) :
    n ∈ symmetricSupport S := by
  simp only [symmetricSupport, Finset.mem_insert, Finset.mem_union]
  exact Or.inr (Or.inl hn)

private theorem neg_mem_support (S : Finset ℤ) {n : ℤ} (hn : n ∈ S) :
    -n ∈ symmetricSupport S := by
  simp only [symmetricSupport, Finset.mem_insert, Finset.mem_union]
  exact Or.inr (Or.inr (Finset.mem_image.mpr ⟨n, hn, rfl⟩))

private theorem zero_mem_support (S : Finset ℤ) : 0 ∈ symmetricSupport S := by
  simp [symmetricSupport]

private theorem lift_supported {A : Type*} [AddCommGroup A]
    (S : Finset ℤ) (u : ℤ → A) (m : ℤ) (hm : m ∉ symmetricSupport S) :
    evenTraceLift S u m = 0 := by
  have hm0 : m ≠ 0 := fun h => hm (h.symm ▸ zero_mem_support S)
  unfold evenTraceLift
  apply Finset.sum_eq_zero
  intro n hn
  have hmn : m ≠ n := fun h => hm (h.symm ▸ mem_support S hn)
  have hmneg : m ≠ -n := fun h => hm (h.symm ▸ neg_mem_support S hn)
  simp [hm0, hmn, hmneg]

private theorem lift_even {A : Type*} [AddCommGroup A]
    (S : Finset ℤ) (u : ℤ → A) (m : ℤ) :
    evenTraceLift S u (-m) = evenTraceLift S u m := by
  unfold evenTraceLift
  apply Finset.sum_congr rfl
  intro n _
  have h1 : (-m = n) ↔ (m = -n) := by
    constructor <;> intro h <;> simpa using congrArg Neg.neg h
  simp only [h1, neg_inj, neg_eq_zero]
  rw [add_comm]

private theorem decode_add (x y : ℚ × ℚ) : decode (x + y) = decode x + decode y := by
  simp [decode] <;> ring

private theorem decode_sub (x y : ℚ × ℚ) : decode (x - y) = decode x - decode y := by
  simp [decode] <;> ring

private theorem decode_sum {ι : Type*} (S : Finset ι) (u : ι → ℚ × ℚ) :
    decode (∑ n ∈ S, u n) = ∑ n ∈ S, decode (u n) := by
  classical
  induction S using Finset.induction_on with
  | empty => simp [decode]
  | @insert n S hn ih => simp only [Finset.sum_insert hn, decode_add, ih]

private theorem decode_lift (S : Finset ℤ) (u : ℤ → ℚ × ℚ) (m : ℤ) :
    decode (evenTraceLift S u m) = evenTraceLift S (fun n => decode (u n)) m := by
  unfold evenTraceLift
  rw [decode_sum]
  apply Finset.sum_congr rfl
  intro n _
  rw [decode_sub, decode_add]
  split_ifs <;> simp [decode_add, decode]

private theorem decode_injective : Function.Injective decode := by
  intro x y h
  have hr := congrArg Complex.re h
  have hi := congrArg Complex.im h
  have hr' : (x.1 : ℝ) = (y.1 : ℝ) := by simpa [decode] using hr
  have hi' : (x.2 : ℝ) = (y.2 : ℝ) := by simpa [decode] using hi
  apply Prod.ext
  · exact_mod_cast hr'
  · exact_mod_cast hi'

/-- Exact weighted-moment transport for the actual finite synthesis.
The identity includes the central coefficient and both signed frequencies. -/
theorem even_trace_lift_moment (S : Finset ℤ) (u a : ℤ → ℂ) :
    (∑ m ∈ symmetricSupport S, a m * evenTraceLift S u m) =
      ∑ n ∈ S, (a n + a (-n) - (a 0 + a 0)) * u n := by
  simp only [evenTraceLift, Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro n hn
  have hp := mem_support S hn
  have hn' := neg_mem_support S hn
  have hz := zero_mem_support S
  simp [mul_add, mul_sub, mul_ite, Finset.sum_add_distrib,
    Finset.sum_sub_distrib, hp, hn', hz]
  <;> ring

/-- The contrast pairing vanishes for every seed, including the redundant
zero-contrast branch. No exact pairing premise is required of the input. -/
theorem repaired_even_parameters_pairing (S : Finset ℤ) (k seed : ℤ → ℚ × ℚ) :
    (∑ n ∈ S, conj (decode (k n - k 0)) *
      decode (repairedEvenParameters S k seed n)) = 0 := by
  cases h : repairTrial S (fun n => k n - k 0) seed with
  | none =>
      have hz : ∀ n ∈ S, k n - k 0 = (0, 0) := by
        intro n hn
        by_contra hne
        have hs := (repair_defined_iff S (fun n => k n - k 0) seed).mpr ⟨n, hn, hne⟩
        simp [h] at hs
      apply Finset.sum_eq_zero
      intro n hn
      simp [hz n hn, decode]
  | some u =>
      simpa only [repairedEvenParameters, h, Option.getD_some] using
        (repair_orthogonal_and_norm_le S (fun n => k n - k 0) seed u h).1

/-- Already feasible parameters are retained on S. Thus the repair does not
exclude or perturb any previously feasible trial in this stencil family. -/
theorem repaired_even_parameters_fix (S : Finset ℤ) (k seed : ℤ → ℚ × ℚ)
    (hpair : (∑ n ∈ S, conj (decode (k n - k 0)) * decode (seed n)) = 0) :
    ∀ n ∈ S, repairedEvenParameters S k seed n = seed n := by
  intro n hn
  cases h : repairTrial S (fun j => k j - k 0) seed with
  | none => simp [repairedEvenParameters, h]
  | some u =>
      have heq := congrFun (repair_eq_existing_trial S (fun j => k j - k 0) seed u h) n
      rw [orthogonal_trial_apply _ _ _ hn] at heq
      have hb : trialCorrection S (fun j => decode (k j - k 0))
          (fun j => decode (seed j)) = 0 := by
        simp [trialCorrection, hpair]
      rw [hb, zero_mul, sub_zero] at heq
      simpa only [repairedEvenParameters, h, Option.getD_some] using decode_injective heq

/-- The returned rational trial has all three exact constraints together.
Actual-symbol cancellation uses its existing proved oddness, not a table of
approximate symbol values. The fixed candidate is even on the selected pairs. -/
theorem even_repaired_trial_constraints (c : ℕ) (S : Finset ℤ)
    (k seed : ℤ → ℚ × ℚ) (hk : ∀ n ∈ S, k (-n) = k n) :
    let t := repairedEvenTrial S k seed
    (∀ m, m ∉ symmetricSupport S → t m = (0, 0)) ∧
      (∀ m, t (-m) = t m) ∧
      (∑ m ∈ symmetricSupport S, decode (t m)) = 0 ∧
      (∑ m ∈ symmetricSupport S, (arithmeticBoundarySymbol c m : ℂ) * decode (t m)) = 0 ∧
      (∑ m ∈ symmetricSupport S, conj (decode (k m)) * decode (t m)) = 0 := by
  let u := repairedEvenParameters S k seed
  have hdecode (m : ℤ) : decode (repairedEvenTrial S k seed m) =
      evenTraceLift S (fun n => decode (u n)) m := decode_lift S u m
  have hzero : arithmeticBoundarySymbol c 0 = 0 := by
    have h := arithmetic_boundary_symbol_neg c 0
    simp only [neg_zero] at h
    linarith
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · intro m hm
    exact lift_supported S u m hm
  · exact lift_even S u
  · simp_rw [hdecode]
    have h := even_trace_lift_moment S (fun n => decode (u n)) (fun _ => 1)
    simpa using h
  · simp_rw [hdecode]
    rw [even_trace_lift_moment]
    apply Finset.sum_eq_zero
    intro n _
    simp [arithmetic_boundary_symbol_neg, hzero]
  · simp_rw [hdecode]
    rw [even_trace_lift_moment]
    calc
      _ = 2 * ∑ n ∈ S, conj (decode (k n - k 0)) * decode (u n) := by
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro n hn
        rw [hk n hn, decode_sub, map_sub]
        ring
      _ = 0 := by rw [repaired_even_parameters_pairing]; ring

private theorem stencil_norm_bound (z : ℂ) (n m : ℤ) :
    ‖(if m = n then z else 0) + (if m = -n then z else 0) -
      (if m = 0 then z + z else 0)‖ ≤
      (if m = n then ‖z‖ else 0) + (if m = -n then ‖z‖ else 0) +
      (if m = 0 then 2 * ‖z‖ else 0) := by
  have h := (norm_sub_le
    ((if m = n then z else 0) + (if m = -n then z else 0))
    (if m = 0 then z + z else 0)).trans
      (add_le_add_right (norm_add_le _ _) _)
  have hz := norm_add_le z z
  split_ifs at h ⊢ <;> simp only [norm_zero] at h ⊢ <;> linarith

private theorem lift_mass_bound (S : Finset ℤ) (u : ℤ → ℂ) :
    (∑ m ∈ symmetricSupport S, ‖evenTraceLift S u m‖) ≤ 4 * ∑ n ∈ S, ‖u n‖ := by
  calc
    _ ≤ ∑ m ∈ symmetricSupport S, ∑ n ∈ S,
        ‖(if m = n then u n else 0) + (if m = -n then u n else 0) -
          (if m = 0 then u n + u n else 0)‖ :=
      Finset.sum_le_sum fun m _ => norm_sum_le _ _
    _ = ∑ n ∈ S, ∑ m ∈ symmetricSupport S,
        ‖(if m = n then u n else 0) + (if m = -n then u n else 0) -
          (if m = 0 then u n + u n else 0)‖ := Finset.sum_comm
    _ ≤ ∑ n ∈ S, 4 * ‖u n‖ := by
      apply Finset.sum_le_sum
      intro n hn
      have hp := mem_support S hn
      have hn' := neg_mem_support S hn
      have hz := zero_mem_support S
      have h := Finset.sum_le_sum (s := symmetricSupport S)
        (fun m _ => stencil_norm_bound (u n) n m)
      have h' : (∑ m ∈ symmetricSupport S,
          ‖(if m = n then u n else 0) + (if m = -n then u n else 0) -
            (if m = 0 then u n + u n else 0)‖) ≤
          ‖u n‖ + ‖u n‖ + 2 * ‖u n‖ := by
        simpa [Finset.sum_add_distrib, hp, hn', hz] using h
      linarith
    _ = _ := (Finset.mul_sum ..).symm

private theorem norm_decode_le (z : ℚ × ℚ) :
    ‖decode z‖ ≤ ((|z.1| + |z.2| : ℚ) : ℝ) := by
  unfold decode
  calc
    _ ≤ ‖((z.1 : ℝ) : ℂ)‖ + ‖((z.2 : ℝ) : ℂ) * Complex.I‖ := norm_add_le _ _
    _ = _ := by simp [norm_mul, Complex.norm_real, Real.norm_eq_abs]

/-- Recompute a safe rational full-coefficient mass after the simultaneous
repair. No full-coefficient norm contraction or optimizer is assumed. -/
theorem even_repaired_trial_mass_bound (S : Finset ℤ) (k seed : ℤ → ℚ × ℚ) :
    (∑ m ∈ symmetricSupport S, ‖decode (repairedEvenTrial S k seed m)‖) ≤
      (evenTrialMassBudget S k seed : ℝ) := by
  simp only [repairedEvenTrial, decode_lift]
  refine (lift_mass_bound S _).trans ?_
  have h := mul_le_mul_of_nonneg_left
    (Finset.sum_le_sum (s := S) fun n _ => norm_decode_le (repairedEvenParameters S k seed n))
    (by norm_num : (0 : ℝ) ≤ 4)
  simpa [evenTrialMassBudget] using h

/-- A complete cubic squared-tail certificate for the same exact output.
Neither symbol values/radii, input orthogonality nor input zero moments are
premises. Their required equalities are derived from the construction.
The global arithmetic envelope, support and readout bounds remain explicit.
The existing rational checker is called with D=0; tau is squared tail mass. -/
theorem even_repaired_residual_certificate {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (k seed : ℤ → ℚ × ℚ) (hk : ∀ n ∈ S, k (-n) = k n)
    (N B p H W tau : ℚ) (hN : 0 ≤ (N : ℝ))
    (hS : ∀ n ∈ S, |(n : ℝ)| ≤ (N : ℝ))
    (hB : arithmeticBoundaryBudget c ≤ (B : ℝ)) (hp : 0 < (p : ℝ))
    (hpi : (p : ℝ) ≤ Real.pi) (eta w : ℂ)
    (heta : ‖eta‖ ≤ (H : ℝ)) (hw : ‖w‖ ≤ (W : ℝ)) {M : ℕ}
    (hcheck : residualTailCheck M N W 0
      ((4 / 3 : ℚ) * H + 4 * B * N / p * evenTrialMassBudget S k seed) tau = true) :
    let t := repairedEvenTrial S k seed
    (∑ m ∈ symmetricSupport S, conj (decode (k m)) * decode (t m)) = 0 ∧
      Summable (fun j : ℕ =>
        ‖arithmeticResidualTail c (symmetricSupport S) (fun n => decode (t n)) eta w M false j‖ ^ 2 +
        ‖arithmeticResidualTail c (symmetricSupport S) (fun n => decode (t n)) eta w M true j‖ ^ 2) ∧
      (∑' j : ℕ,
        ‖arithmeticResidualTail c (symmetricSupport S) (fun n => decode (t n)) eta w M false j‖ ^ 2 +
        ‖arithmeticResidualTail c (symmetricSupport S) (fun n => decode (t n)) eta w M true j‖ ^ 2) ≤
          (tau : ℝ) := by
  obtain ⟨_, _, hzero, hsymbol, horth⟩ := even_repaired_trial_constraints c S k seed hk
  have hfull : ∀ m ∈ symmetricSupport S, |(m : ℝ)| ≤ (N : ℝ) := by
    intro m hm
    rcases Finset.mem_insert.mp hm with hm | hm
    · subst m
      simpa using hN
    · rcases Finset.mem_union.mp hm with hm | hm
      · exact hS m hm
      · obtain ⟨n, hn, rfl⟩ := Finset.mem_image.mp hm
        simpa using hS n hn
  obtain ⟨hM, hMN, hMW, hbudget⟩ := residual_tail_check_sound hcheck
  have hfreq : ‖w‖ ≤ (M : ℝ) / 2 := by linarith
  obtain ⟨hsum, htail⟩ := arithmetic_residual_defect_tail_bound hc (symmetricSupport S)
    (fun n => decode (repairedEvenTrial S k seed n)) N 0 0 B p
    (evenTrialMassBudget S k seed) H hN hfull
    (by rw [hzero]; simp) (by rw [hsymbol]; simp) hB hp hpi
    (even_repaired_trial_mass_bound S k seed) eta w heta hM hMN hfreq
  refine ⟨horth, hsum, htail.trans ?_⟩
  push_cast at hbudget
  simpa only [mul_zero, add_zero, zero_div] using hbudget

-- Nonzero exact example and the redundant-contrast branch, without floating point.
example : repairedEvenTrial {1, 2}
    (fun n => ((n.natAbs : ℚ), (0 : ℚ)))
    (fun n => if n = 1 then ((1 : ℚ), (0 : ℚ)) else (0, 0)) 1 = (4 / 5, 0) := by
  norm_num [repairedEvenTrial, repairedEvenParameters, evenTraceLift,
    repairTrial, rationalGram, rationalCorrection]

example : repairedEvenTrial {1, 2} (fun _ => ((7 : ℚ), (0 : ℚ)))
    (fun n => if n = 1 then ((1 : ℚ), (0 : ℚ)) else (0, 0)) 0 = (-2, 0) := by
  norm_num [repairedEvenTrial, repairedEvenParameters, evenTraceLift,
    repairTrial, rationalGram]

#print axioms repaired_even_parameters_pairing
#print axioms even_repaired_trial_constraints
#print axioms even_repaired_residual_certificate

end D5.S3.Weil.ZetaBridge.WeilEvenTraceRepair
