/- GID: D5/S3/Weil/ZetaBridge/WeilResidualHilbertAssembly
   generality: I
   mirror-B: D5/B/S3/Weil/ZetaBridge/WeilResidualHilbertAssembly
   mirror-E: none(waiver:coefficient-realization-with-separate-canonical-domain)
   anchors: []
   digest: Assemble finite residual balls and complete arithmetic tails into a unique Hilbert vector with a certified two-sided squared-norm interval. -/

import D5.S3.Weil.ZetaBridge.WeilEvenTraceRepair
import Mathlib.Analysis.InnerProductSpace.l2Space
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Tactic.Omega

/-!
The finite window contains 0 and +/-1,...,+/-M, each exactly once. The
exterior is the existing exteriorMode M j sign, starting at +/-(M+1).
We construct the entire coefficient function, prove square summability from
the already-owned arithmetic tail, then use Mathlib's HilbertBasis.repr
isometry to obtain existence, uniqueness and a complete norm interval.

Uniqueness concerns the full exact coefficient function, NOT a finite table
of approximate balls. A Hilbert basis is required, not merely an orthonormal
subfamily. Identification with g-A(v) still requires its actual coefficients
and operator-domain membership. No Fourier transform, Parseval theorem,
canonical Weil operator or spectral gap is redefined here.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S3.Weil.ZetaBridge.WeilResidualHilbertAssembly

open scoped BigOperators ComplexConjugate ComplexInnerProductSpace
open D5.S3.Weil.ZetaBridge.FiniteRationalTrialRepair
open D5.S3.Weil.ZetaBridge.WeilEvenTraceRepair
open D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingJet
open D5.S3.Weil.ZetaBridge.WeilArithmeticResidualTail
open D5.S3.Weil.ZetaBridge.WeilArithmeticResidualPrecision

/-- Sum a finite signed window, counting the central coordinate only once. -/
def signedWindowSum {R : Type*} [AddCommMonoid R] (M : ℕ) (f : ℤ → R) : R :=
  f 0 + ∑ j ∈ Finset.range M, (f ((j + 1 : ℕ) : ℤ) + f (-((j + 1 : ℕ) : ℤ)))

/-- Splice a finite window and two full exterior streams. Values of `inside`
outside the window are never used. Natural subtraction is used only after
the exterior test; the index theorem below rules out off-by-one truncation. -/
def spliceSignedCoefficients (M : ℕ) (inside : ℤ → ℂ)
    (tail : Bool → ℕ → ℂ) (m : ℤ) : ℂ :=
  if m.natAbs ≤ M then inside m
  else tail (decide (m < 0)) (m.natAbs - M - 1)

/-- Finite rational lower and upper squared-mass budgets. The center uses
x^2+y^2 exactly. The perturbation radius is 2*(|x|+|y|)*e+e^2, so the interval
collapses to the exact finite squared mass when the radii are zero. -/
def retainedMassInterval (M : ℕ) (center : ℤ → ℚ × ℚ) (e : ℤ → ℚ) : ℚ × ℚ :=
  (signedWindowSum M (fun m => max 0
     ((center m).1 ^ 2 + (center m).2 ^ 2 -
       (2 * (|(center m).1| + |(center m).2|) * e m + (e m) ^ 2))),
   signedWindowSum M (fun m => (center m).1 ^ 2 + (center m).2 ^ 2 +
     (2 * (|(center m).1| + |(center m).2|) * e m + (e m) ^ 2)))

/-- Exact matching on every retained and exterior coordinate. This is an
identity of the splice implementation, without a numerical tolerance. -/
theorem splice_signed_coordinates (M : ℕ) (inside : ℤ → ℂ) (tail : Bool → ℕ → ℂ) :
    (∀ m, m.natAbs ≤ M → spliceSignedCoefficients M inside tail m = inside m) ∧
      ∀ s j, spliceSignedCoefficients M inside tail (exteriorMode M j s) = tail s j := by
  refine ⟨fun m hm => if_pos hm, ?_⟩
  intro s j
  have hcast : (M : ℤ) + (j : ℤ) + 1 = ((M + j + 1 : ℕ) : ℤ) := by omega
  have hout : ¬M + j + 1 ≤ M := by omega
  have hindex : M + j + 1 - M - 1 = j := by omega
  have hpos : (0 : ℤ) < ((M + j + 1 : ℕ) : ℤ) := by omega
  cases s <;>
    simp [exteriorMode, spliceSignedCoefficients, hcast, hout, hindex,
      show ¬((M + j + 1 : ℕ) : ℤ) < 0 by omega,
      show -((M + j + 1 : ℕ) : ℤ) < 0 by omega]

private theorem window_mono (M : ℕ) (f g : ℤ → ℝ)
    (h : ∀ m, m.natAbs ≤ M → f m ≤ g m) :
    signedWindowSum M f ≤ signedWindowSum M g := by
  apply add_le_add (h 0 (by simp))
  apply Finset.sum_le_sum
  intro j hj
  have hji : j + 1 ≤ M := Nat.succ_le_iff.mpr (Finset.mem_range.mp hj)
  exact add_le_add (h _ (by simpa using hji)) (h _ (by simpa using hji))

private theorem window_congr {R : Type*} [AddCommMonoid R] (M : ℕ) (f g : ℤ → R)
    (h : ∀ m, m.natAbs ≤ M → f m = g m) : signedWindowSum M f = signedWindowSum M g := by
  unfold signedWindowSum
  rw [h 0 (by simp)]
  congr 1
  apply Finset.sum_congr rfl
  intro j hj
  have hji : j + 1 ≤ M := Nat.succ_le_iff.mpr (Finset.mem_range.mp hj)
  rw [h _ (by simpa using hji), h _ (by simpa using hji)]

/-- Square summability of the entire integer stream and its exact finite-plus-
infinite mass identity follow from summability of the two paired tails.
No full l2 membership or value of a divergent `tsum` is assumed. -/
theorem signed_square_mass_assembly (a : ℤ → ℂ) (M : ℕ)
    (ht : Summable (fun j : ℕ => ‖a (exteriorMode M j false)‖ ^ 2 +
      ‖a (exteriorMode M j true)‖ ^ 2)) :
    Summable (fun m : ℤ => ‖a m‖ ^ 2) ∧
      (∑' m : ℤ, ‖a m‖ ^ 2) = signedWindowSum M (fun m => ‖a m‖ ^ 2) +
        ∑' j : ℕ, (‖a (exteriorMode M j false)‖ ^ 2 + ‖a (exteriorMode M j true)‖ ^ 2) := by
  let f : ℤ → ℝ := fun m => ‖a m‖ ^ 2
  let v : ℕ → ℝ := fun j => f ((j + 1 : ℕ) : ℤ) + f (-((j + 1 : ℕ) : ℤ))
  have ht' : Summable (fun j : ℕ => v (j + M)) := by
    simpa [v, f, exteriorMode, Nat.cast_add, add_comm, add_left_comm, add_assoc] using ht
  have hv : Summable v := (summable_nat_add_iff M).mp ht'
  have hpos : Summable (fun j : ℕ => f ((j + 1 : ℕ) : ℤ)) :=
    Summable.of_nonneg_of_le (fun _ => sq_nonneg _) (fun _ => le_add_of_nonneg_right (sq_nonneg _)) hv
  have hneg : Summable (fun j : ℕ => f (-((j + 1 : ℕ) : ℤ))) :=
    Summable.of_nonneg_of_le (fun _ => sq_nonneg _) (fun _ => le_add_of_nonneg_left (sq_nonneg _)) hv
  have hpos0 : Summable (fun j : ℕ => f (j : ℤ)) :=
    (summable_nat_add_iff 1).mp hpos
  have hneg' : Summable (fun j : ℕ => f (-(j + 1))) := by
    simpa only [Nat.cast_add, Nat.cast_one] using hneg
  have hall : Summable f := Summable.of_nat_of_neg_add_one hpos0 hneg'
  refine ⟨hall, ?_⟩
  have hwhole : (∑' m : ℤ, f m) = f 0 + ∑' j : ℕ, v j := by
    rw [tsum_of_nat_of_neg_add_one hpos0 hneg', hpos0.tsum_eq_zero_add]
    rw [show (∑' j : ℕ, v j) =
        (∑' j : ℕ, f ((j + 1 : ℕ) : ℤ)) + ∑' j : ℕ, f (-((j + 1 : ℕ) : ℤ)) from
      hpos.tsum_add hneg]
    simp only [Nat.cast_add, Nat.cast_one, add_assoc]
  rw [hwhole, ← hv.sum_add_tsum_nat_add M]
  simp [signedWindowSum, v, f, exteriorMode, Nat.cast_add, add_comm, add_left_comm, add_assoc]

private theorem coefficient_ext {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    (b : HilbertBasis ℤ ℂ H) {x y : H}
    (h : ∀ m, ⟪b m, x⟫_ℂ = ⟪b m, y⟫_ℂ) : x = y := by
  apply b.repr.injective
  apply lp.ext
  intro m
  simpa only [b.repr_apply_apply] using h m

/-- The full exact coefficient stream has a unique Hilbert realization. Its
norm is the exact retained mass plus the complete exterior mass. Existence
comes from proved l2 membership and the existing HilbertBasis isometry. -/
theorem hilbert_realization_of_square_tail {H : Type*} [NormedAddCommGroup H]
    [InnerProductSpace ℂ H] (b : HilbertBasis ℤ ℂ H) (a : ℤ → ℂ) (M : ℕ)
    (ht : Summable (fun j : ℕ => ‖a (exteriorMode M j false)‖ ^ 2 +
      ‖a (exteriorMode M j true)‖ ^ 2)) :
    ∃! x : H, (∀ m, ⟪b m, x⟫_ℂ = a m) ∧
      ‖x‖ ^ 2 = signedWindowSum M (fun m => ‖a m‖ ^ 2) +
        ∑' j : ℕ, (‖a (exteriorMode M j false)‖ ^ 2 + ‖a (exteriorMode M j true)‖ ^ 2) := by
  obtain ⟨hs, hsplit⟩ := signed_square_mass_assembly a M ht
  have hm : Memℓp a 2 := memℓp_gen (by simpa using hs)
  let v : lp (fun _ : ℤ => ℂ) 2 := ⟨a, hm⟩
  let x : H := b.repr.symm v
  have hx (m : ℤ) : ⟪b m, x⟫_ℂ = a m := by
    rw [← b.repr_apply_apply]
    change b.repr (b.repr.symm v) m = a m
    rw [b.repr.apply_symm_apply]
    rfl
  have hn : ‖x‖ ^ 2 = ∑' m : ℤ, ‖a m‖ ^ 2 := by
    calc
      ‖x‖ ^ 2 = ‖v‖ ^ 2 := congrArg (fun r : ℝ => r ^ 2) (b.repr.symm.norm_map v)
      _ = _ := by
        simpa only [ENNReal.toReal_ofNat, Real.rpow_two] using
          lp.norm_rpow_eq_tsum (show 0 < (2 : ENNReal).toReal by norm_num) v
  refine ⟨x, ⟨hx, hn.trans hsplit⟩, ?_⟩
  intro y hy
  exact coefficient_ext b (fun m => (hy.1 m).trans (hx m).symm)

private theorem decode_norm_sq (z : ℚ × ℚ) :
    ‖decode z‖ ^ 2 = ((z.1 ^ 2 + z.2 ^ 2 : ℚ) : ℝ) := by
  rw [pow_two, Complex.norm_mul_self_eq_normSq]
  simp [decode, Complex.normSq_apply, pow_two]

private theorem scalar_ball_bounds (a : ℂ) (z : ℚ × ℚ) (e : ℚ)
    (h : ‖a - decode z‖ ≤ (e : ℝ)) :
    ((max 0 (z.1 ^ 2 + z.2 ^ 2 - (2 * (|z.1| + |z.2|) * e + e ^ 2)) : ℚ) : ℝ) ≤
      ‖a‖ ^ 2 ∧ ‖a‖ ^ 2 ≤
        ((z.1 ^ 2 + z.2 ^ 2 + (2 * (|z.1| + |z.2|) * e + e ^ 2) : ℚ) : ℝ) := by
  have he : 0 ≤ (e : ℝ) := (norm_nonneg _).trans h
  have hcenter : ‖decode z‖ ≤ ((|z.1| + |z.2| : ℚ) : ℝ) := by
    unfold decode
    calc
      _ ≤ ‖((z.1 : ℝ) : ℂ)‖ + ‖((z.2 : ℝ) : ℂ) * Complex.I‖ := norm_add_le _ _
      _ = _ := by simp [norm_mul, Complex.norm_real, Real.norm_eq_abs]
  have habove : ‖a‖ ≤ ((|z.1| + |z.2| + e : ℚ) : ℝ) := by
    have htri := norm_add_le (a - decode z) (decode z)
    rw [sub_add_cancel] at htri
    push_cast
    push_cast at hcenter
    linarith
  have hdiff : |‖a‖ - ‖decode z‖| ≤ (e : ℝ) :=
    (abs_norm_sub_norm_le a (decode z)).trans h
  have hsum : ‖a‖ + ‖decode z‖ ≤ (2 * (|z.1| + |z.2|) + e : ℚ) := by
    push_cast at hcenter habove ⊢
    linarith
  have hprod := mul_le_mul hdiff hsum
    (add_nonneg (norm_nonneg a) (norm_nonneg (decode z))) he
  have hid : |‖a‖ ^ 2 - ‖decode z‖ ^ 2| =
      |‖a‖ - ‖decode z‖| * (‖a‖ + ‖decode z‖) := by
    rw [show ‖a‖ ^ 2 - ‖decode z‖ ^ 2 =
      (‖a‖ - ‖decode z‖) * (‖a‖ + ‖decode z‖) by ring,
      abs_mul, abs_of_nonneg (add_nonneg (norm_nonneg _) (norm_nonneg _))]
  have herr : |‖a‖ ^ 2 - ((z.1 ^ 2 + z.2 ^ 2 : ℚ) : ℝ)| ≤
      ((2 * (|z.1| + |z.2|) * e + e ^ 2 : ℚ) : ℝ) := by
    rw [← decode_norm_sq z, hid]
    calc
      _ ≤ (e : ℝ) * ((2 * (|z.1| + |z.2|) + e : ℚ) : ℝ) := hprod
      _ = _ := by push_cast; ring
  obtain ⟨hl, hu⟩ := abs_le.mp herr
  constructor
  · push_cast
    apply max_le (sq_nonneg _)
    push_cast at hl
    linarith
  · push_cast at hu ⊢
    linarith

/-- Soundness of both finite rational bounds, including every retained
coefficient evaluation/rounding radius. Exact centers contribute their exact
squared moduli; no residual width from a rectangular norm bound remains. -/
theorem retained_mass_interval_sound (M : ℕ) (inside : ℤ → ℂ)
    (center : ℤ → ℚ × ℚ) (e : ℤ → ℚ)
    (h : ∀ m, m.natAbs ≤ M → ‖inside m - decode (center m)‖ ≤ (e m : ℝ)) :
    ((retainedMassInterval M center e).1 : ℝ) ≤
        signedWindowSum M (fun m => ‖inside m‖ ^ 2) ∧
      signedWindowSum M (fun m => ‖inside m‖ ^ 2) ≤
        ((retainedMassInterval M center e).2 : ℝ) := by
  constructor
  · have h' := window_mono M
      (fun m => ((max 0 ((center m).1 ^ 2 + (center m).2 ^ 2 -
        (2 * (|(center m).1| + |(center m).2|) * e m + (e m) ^ 2)) : ℚ) : ℝ))
      (fun m => ‖inside m‖ ^ 2) (fun m hm => (scalar_ball_bounds _ _ _ (h m hm)).1)
    simpa [retainedMassInterval, signedWindowSum] using h'
  · have h' := window_mono M (fun m => ‖inside m‖ ^ 2)
      (fun m => (((center m).1 ^ 2 + (center m).2 ^ 2 +
        (2 * (|(center m).1| + |(center m).2|) * e m + (e m) ^ 2) : ℚ) : ℝ))
      (fun m hm => (scalar_ball_bounds _ _ _ (h m hm)).2)
    simpa [retainedMassInterval, signedWindowSum] using h'

/-- With zero retained radii the interval collapses exactly. In particular,
refining the finite evaluations does not leave the old rectangular norm slack. -/
theorem retained_mass_interval_exact (M : ℕ) (center : ℤ → ℚ × ℚ) :
    retainedMassInterval M center (fun _ => 0) =
      (signedWindowSum M (fun m => (center m).1 ^ 2 + (center m).2 ^ 2),
       signedWindowSum M (fun m => (center m).1 ^ 2 + (center m).2 ^ 2)) := by
  have h (m : ℤ) : max 0 ((center m).1 ^ 2 + (center m).2 ^ 2) =
      (center m).1 ^ 2 + (center m).2 ^ 2 :=
    max_eq_right (add_nonneg (sq_nonneg _) (sq_nonneg _))
  simp [retainedMassInterval, h]

/-- Combine a finite table of complex balls with a complete summable tail.
The unique vector is selected by its ENTIRE exact spliced coefficient stream;
the balls alone do not imply uniqueness. The norm interval concerns all modes. -/
theorem hilbert_splice_interval {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    (b : HilbertBasis ℤ ℂ H) (M : ℕ) (inside : ℤ → ℂ) (tail : Bool → ℕ → ℂ)
    (center : ℤ → ℚ × ℚ) (e : ℤ → ℚ) (tau : ℝ)
    (hin : ∀ m, m.natAbs ≤ M → ‖inside m - decode (center m)‖ ≤ (e m : ℝ))
    (hs : Summable (fun j : ℕ => ‖tail false j‖ ^ 2 + ‖tail true j‖ ^ 2))
    (ht : (∑' j : ℕ, ‖tail false j‖ ^ 2 + ‖tail true j‖ ^ 2) ≤ tau) :
    ∃! x : H, (∀ m, ⟪b m, x⟫_ℂ = spliceSignedCoefficients M inside tail m) ∧
      ((retainedMassInterval M center e).1 : ℝ) ≤ ‖x‖ ^ 2 ∧
      ‖x‖ ^ 2 ≤ ((retainedMassInterval M center e).2 : ℝ) + tau := by
  let a := spliceSignedCoefficients M inside tail
  have ha := (splice_signed_coordinates M inside tail).2
  have hs' : Summable (fun j : ℕ => ‖a (exteriorMode M j false)‖ ^ 2 +
      ‖a (exteriorMode M j true)‖ ^ 2) := by simpa only [a, ha] using hs
  obtain ⟨x, ⟨hx, hn⟩, _⟩ := hilbert_realization_of_square_tail b a M hs'
  have hw : signedWindowSum M (fun m => ‖a m‖ ^ 2) =
      signedWindowSum M (fun m => ‖inside m‖ ^ 2) :=
    window_congr M _ _ (fun m hm => by rw [(splice_signed_coordinates M inside tail).1 m hm])
  rw [hw] at hn
  simp only [a, ha] at hn
  obtain ⟨hlo, hhi⟩ := retained_mass_interval_sound M inside center e hin
  have htn : 0 ≤ ∑' j : ℕ, ‖tail false j‖ ^ 2 + ‖tail true j‖ ^ 2 :=
    tsum_nonneg (fun _ => add_nonneg (sq_nonneg _) (sq_nonneg _))
  refine ⟨x, ⟨hx, by linarith, by linarith⟩, ?_⟩
  intro y hy
  exact coefficient_ext b (fun m => (hy.1 m).trans (hx m).symm)

/-- The existing exact even repair now produces a unique full Hilbert residual
from finite retained coefficients and the ORIGINAL arithmetic exterior.
Square summability and the exterior budget are derived from the old checker;
there is no independent full-residual or missing-mode norm assumption. -/
theorem even_repaired_hilbert_certificate {Hspace : Type*} [NormedAddCommGroup Hspace]
    [InnerProductSpace ℂ Hspace] (b : HilbertBasis ℤ ℂ Hspace) {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (k seed : ℤ → ℚ × ℚ) (hk : ∀ n ∈ S, k (-n) = k n)
    (N B p H W tau : ℚ) (hN : 0 ≤ (N : ℝ))
    (hS : ∀ n ∈ S, |(n : ℝ)| ≤ (N : ℝ))
    (hB : arithmeticBoundaryBudget c ≤ (B : ℝ)) (hp : 0 < (p : ℝ))
    (hpi : (p : ℝ) ≤ Real.pi) (eta w : ℂ)
    (heta : ‖eta‖ ≤ (H : ℝ)) (hw : ‖w‖ ≤ (W : ℝ)) {M : ℕ}
    (hcheck : residualTailCheck M N W 0
      ((4 / 3 : ℚ) * H + 4 * B * N / p * evenTrialMassBudget S k seed) tau = true)
    (inside : ℤ → ℂ) (center : ℤ → ℚ × ℚ) (e : ℤ → ℚ)
    (hin : ∀ m, m.natAbs ≤ M → ‖inside m - decode (center m)‖ ≤ (e m : ℝ)) :
    let t := repairedEvenTrial S k seed
    let tail := fun s j => arithmeticResidualTail c (symmetricSupport S)
      (fun n => decode (t n)) eta w M s j
    (∑ m ∈ symmetricSupport S, conj (decode (k m)) * decode (t m)) = 0 ∧
      ∃! x : Hspace, (∀ m, ⟪b m, x⟫_ℂ = spliceSignedCoefficients M inside tail m) ∧
        ((retainedMassInterval M center e).1 : ℝ) ≤ ‖x‖ ^ 2 ∧
        ‖x‖ ^ 2 ≤ ((retainedMassInterval M center e).2 : ℝ) + (tau : ℝ) := by
  obtain ⟨horth, hs, ht⟩ := even_repaired_residual_certificate hc S k seed hk
    N B p H W tau hN hS hB hp hpi eta w heta hw hcheck
  exact ⟨horth, hilbert_splice_interval b M inside _ center e tau hin hs ht⟩

/-- Once the computed coefficients have been proved to be those of an actual
residual R (for example g-A(v) for v in the true operator domain), the same
interval bounds R. Equality of all coordinates is used through the complete
Hilbert basis; finite coordinate matching alone is insufficient. -/
theorem identified_residual_interval {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    (b : HilbertBasis ℤ ℂ H) (a : ℤ → ℂ) (lo hi : ℝ)
    (hcertificate : ∃! x : H, (∀ m, ⟪b m, x⟫_ℂ = a m) ∧ lo ≤ ‖x‖ ^ 2 ∧ ‖x‖ ^ 2 ≤ hi)
    (R : H) (hR : ∀ m, ⟪b m, R⟫_ℂ = a m) : lo ≤ ‖R‖ ^ 2 ∧ ‖R‖ ^ 2 ≤ hi := by
  obtain ⟨x, ⟨hx, hbounds⟩, _⟩ := hcertificate
  have heq : R = x := coefficient_ext b (fun m => (hR m).trans (hx m).symm)
  simpa only [heq] using hbounds

#print axioms signed_square_mass_assembly
#print axioms hilbert_realization_of_square_tail
#print axioms even_repaired_hilbert_certificate

end D5.S3.Weil.ZetaBridge.WeilResidualHilbertAssembly
