/- GID: D5/S3/Weil/ZetaBridge/WeilOrthogonalTrialPrecision
   generality: I
   mirror-B: D5/B/S3/Weil/ZetaBridge/WeilOrthogonalTrialPrecision
   mirror-E: none(waiver:exact-projection-and-certified-arithmetic-tail)
   anchors: []
   digest: Construct an exactly orthogonal finite trial with Mathlib projection and propagate its coefficient enclosures into the complete arithmetic tail certificate. -/

import D5.S3.Weil.ZetaBridge.WeilArithmeticResidualPrecision
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Algebra.Field.Subfield.Basic

/-!
The candidate coefficients k are fixed exact mathematical values. They need
not be normalized. The raw trial v may be enclosed by centers and radii.
The actual corrected trial is the standard Mathlib orthogonal projection,
zero-extended from the same finite support. Its coordinate formula uses only
field operations and conjugation; it never normalizes k with a square root.

The correction coefficient is enclosed using an absolute pairing residual
and a positive lower bound for the candidate's squared norm. The resulting
coordinate radii, including the correction error, are passed to the existing
rounding-aware arithmetic tail theorem and its rational acceptance test.
No exact-orthogonality premise is supplied for the raw trial. The construction
does not by itself identify the arithmetic column with the canonical Weil
operator or certify the interior residual, coercivity or a scale limit.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false
noncomputable section

namespace D5.S3.Weil.ZetaBridge.WeilOrthogonalTrialPrecision

open D5.S3.Weil.ZetaBridge.WeilArithmeticCouplingJet
open D5.S3.Weil.ZetaBridge.WeilArithmeticResidualTail
open D5.S3.Weil.ZetaBridge.WeilArithmeticResidualPrecision
open scoped BigOperators ComplexConjugate ComplexInnerProductSpace

private def coefficientVector (S : Finset ℤ) (v : ℤ → ℂ) : EuclideanSpace ℂ S :=
  WithLp.toLp 2 (fun n : S => v n)

private theorem coefficient_inner (S : Finset ℤ) (x y : ℤ → ℂ) :
    ⟪coefficientVector S x, coefficientVector S y⟫_ℂ =
      ∑ n ∈ S, conj (x n) * y n := by
  simp [coefficientVector, PiLp.inner_apply, RCLike.inner_apply,
    Finset.sum_coe_sort, mul_comm]

private theorem coefficient_norm_sq (S : Finset ℤ) (k : ℤ → ℂ) :
    ‖coefficientVector S k‖ ^ 2 = ∑ n ∈ S, ‖k n‖ ^ 2 := by
  rw [EuclideanSpace.norm_sq_eq]
  simp [coefficientVector, Finset.sum_coe_sort]

private theorem self_pairing (S : Finset ℤ) (k : ℤ → ℂ) :
    (∑ n ∈ S, conj (k n) * k n) = ((∑ n ∈ S, ‖k n‖ ^ 2 : ℝ) : ℂ) := by
  rw [← coefficient_inner, inner_self_eq_norm_sq_to_K, coefficient_norm_sq]

/-- The finite projection coefficient. It uses the actual self-pairing,
not a rounded normalization factor. Total division also handles k=0; the
precision theorem separately requires a strictly positive norm certificate. -/
def trialCorrection (S : Finset ℤ) (k v : ℤ → ℂ) : ℂ :=
  (∑ n ∈ S, conj (k n) * v n) / (∑ n ∈ S, conj (k n) * k n)

/-- The actual standard orthogonal projection on the finite coefficient
space, extended by zero. It is not a second projection theory. -/
def orthogonalTrial (S : Finset ℤ) (k v : ℤ → ℂ) : ℤ → ℂ :=
  fun n => if hn : n ∈ S then
    ((ℂ ∙ coefficientVector S k)ᗮ.starProjection (coefficientVector S v)) ⟨n, hn⟩
  else 0

/-- The field-arithmetic formula agrees with the actual Mathlib projection.
No nonzero-candidate assumption is needed for this totalized identity. -/
theorem orthogonal_trial_apply (S : Finset ℤ) (k v : ℤ → ℂ) {n : ℤ} (hn : n ∈ S) :
    orthogonalTrial S k v n = v n - trialCorrection S k v * k n := by
  have hvec : (ℂ ∙ coefficientVector S k)ᗮ.starProjection (coefficientVector S v) =
      coefficientVector S v - trialCorrection S k v • coefficientVector S k := by
    rw [Submodule.starProjection_orthogonal_val, Submodule.starProjection_singleton ℂ,
      coefficient_inner, coefficient_norm_sq]
    simp only [trialCorrection, self_pairing]
  simpa only [orthogonalTrial, dif_pos hn, hvec]

/-- Exact support and candidate orthogonality are conclusions of the
construction, even when the input pairing is nonzero. -/
theorem orthogonal_trial_constraints (S : Finset ℤ) (k v : ℤ → ℂ) :
    (∀ n, n ∉ S → orthogonalTrial S k v n = 0) ∧
      (∑ n ∈ S, conj (k n) * orthogonalTrial S k v n) = 0 := by
  have hvec : coefficientVector S (orthogonalTrial S k v) =
      (ℂ ∙ coefficientVector S k)ᗮ.starProjection (coefficientVector S v) := by
    ext n
    simp [coefficientVector, orthogonalTrial, n.property]
  have hmem := Submodule.starProjection_apply_mem
    ((ℂ ∙ coefficientVector S k)ᗮ) (coefficientVector S v)
  have horth : ⟪coefficientVector S k,
      (ℂ ∙ coefficientVector S k)ᗮ.starProjection (coefficientVector S v)⟫_ℂ = 0 :=
    hmem (coefficientVector S k) (Submodule.mem_span_singleton_self _)
  refine ⟨?_, ?_⟩
  · intro n hn
    simp [orthogonalTrial, hn]
  · rw [← hvec, coefficient_inner] at horth
    exact horth

/-- The corrected coefficients give genuinely orthogonal finite Hilbert
syntheses in any existing orthonormal family. No Fourier family is invented
or assumed to be orthonormal by this result. -/
theorem orthogonal_trial_synthesis {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℂ E] (e : ℤ → E) (he : Orthonormal ℂ e)
    (S : Finset ℤ) (k v : ℤ → ℂ) :
    ⟪∑ n ∈ S, k n • e n, ∑ n ∈ S, orthogonalTrial S k v n • e n⟫_ℂ = 0 := by
  rw [he.inner_sum]
  exact (orthogonal_trial_constraints S k v).2

/-- Every weighted finite moment is updated by the same correction. In
particular neither arithmetic boundary moment is silently left unchanged. -/
theorem orthogonal_trial_moment (S : Finset ℤ) (k v a : ℤ → ℂ) :
    (∑ n ∈ S, a n * orthogonalTrial S k v n) =
      (∑ n ∈ S, a n * v n) - trialCorrection S k v * ∑ n ∈ S, a n * k n := by
  rw [Finset.mul_sum, ← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro n hn
  rw [orthogonal_trial_apply S k v hn]
  ring

/-- No square-root field extension is needed. Conjugation-stable coefficient
subfields are preserved by the concrete projection formula. This is not a
floating-point implementation or an optimality statement. -/
theorem orthogonal_trial_mem_subfield (F : Subfield ℂ)
    (hconj : ∀ z : ℂ, z ∈ F → conj z ∈ F)
    (S : Finset ℤ) (k v : ℤ → ℂ)
    (hk : ∀ n ∈ S, k n ∈ F) (hv : ∀ n ∈ S, v n ∈ F) :
    ∀ n : ℤ, orthogonalTrial S k v n ∈ F := by
  have hbeta : trialCorrection S k v ∈ F :=
    F.div_mem
      (F.sum_mem fun n hn => F.mul_mem (hconj _ (hk n hn)) (hv n hn))
      (F.sum_mem fun n hn => F.mul_mem (hconj _ (hk n hn)) (hk n hn))
  intro n
  by_cases hn : n ∈ S
  · rw [orthogonal_trial_apply S k v hn]
    exact F.sub_mem (hv n hn) (F.mul_mem hbeta (hk n hn))
  · rw [(orthogonal_trial_constraints S k v).1 n hn]
    exact F.zero_mem

/-- Enclose the exact projection coefficient from an absolute residual of
its scalar equation, then propagate that error to every corrected coefficient.
The candidate k is fixed exactly. sigmaLo is a positive lower bound for its
squared norm, and b is an arbitrary exact center for the correction. -/
theorem orthogonal_trial_enclosures (S : Finset ℤ) (k v center : ℤ → ℂ)
    (ev : ℤ → ℝ) (hev : ∀ n ∈ S, ‖v n - center n‖ ≤ ev n)
    (b : ℂ) (eps sigmaLo : ℝ) (heps : 0 ≤ eps) (hlo : 0 < sigmaLo)
    (hsigma : sigmaLo ≤ ∑ n ∈ S, ‖k n‖ ^ 2)
    (hresidual : ‖(∑ n ∈ S, conj (k n) * center n) -
        b * ((∑ n ∈ S, ‖k n‖ ^ 2 : ℝ) : ℂ)‖ +
      (∑ n ∈ S, ‖k n‖ * ev n) ≤ eps * sigmaLo) :
    ‖trialCorrection S k v - b‖ ≤ eps ∧
      ∀ n ∈ S, ‖orthogonalTrial S k v n - (center n - b * k n)‖ ≤
        ev n + eps * ‖k n‖ := by
  let sigma : ℝ := ∑ n ∈ S, ‖k n‖ ^ 2
  let actual : ℂ := ∑ n ∈ S, conj (k n) * v n
  let approx : ℂ := ∑ n ∈ S, conj (k n) * center n
  have hpos : 0 < sigma := hlo.trans_le hsigma
  have hne : (sigma : ℂ) ≠ 0 := by exact_mod_cast hpos.ne'
  have hpair : ‖actual - approx‖ ≤ ∑ n ∈ S, ‖k n‖ * ev n := by
    dsimp only [actual, approx]
    rw [← Finset.sum_sub_distrib]
    refine (norm_sum_le _ _).trans (Finset.sum_le_sum ?_)
    intro n hn
    rw [← mul_sub, norm_mul, Complex.norm_conj]
    exact mul_le_mul_of_nonneg_left (hev n hn) (norm_nonneg _)
  have hnum : ‖actual - b * (sigma : ℂ)‖ ≤ eps * sigma := by
    calc
      _ = ‖(actual - approx) + (approx - b * (sigma : ℂ))‖ := by congr 1; ring
      _ ≤ ‖actual - approx‖ + ‖approx - b * (sigma : ℂ)‖ := norm_add_le _ _
      _ ≤ (∑ n ∈ S, ‖k n‖ * ev n) + ‖approx - b * (sigma : ℂ)‖ :=
        add_le_add_right hpair _
      _ ≤ eps * sigmaLo := by simpa only [approx, sigma, add_comm] using hresidual
      _ ≤ eps * sigma := mul_le_mul_of_nonneg_left hsigma heps
  have hid : trialCorrection S k v - b = (actual - b * (sigma : ℂ)) / (sigma : ℂ) := by
    unfold trialCorrection
    rw [self_pairing]
    change actual / (sigma : ℂ) - b = _
    field_simp [hne]
    <;> ring
  have hb : ‖trialCorrection S k v - b‖ ≤ eps := by
    rw [hid, norm_div, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hpos]
    exact (div_le_iff₀ hpos).mpr hnum
  refine ⟨hb, ?_⟩
  intro n hn
  rw [orthogonal_trial_apply S k v hn]
  have hid' : (v n - trialCorrection S k v * k n) - (center n - b * k n) =
      (v n - center n) - (trialCorrection S k v - b) * k n := by ring
  rw [hid']
  calc
    _ ≤ ‖v n - center n‖ + ‖(trialCorrection S k v - b) * k n‖ := norm_sub_le _ _
    _ ≤ ev n + eps * ‖k n‖ := by
      rw [norm_mul]
      exact add_le_add (hev n hn) (mul_le_mul_of_nonneg_right hb (norm_nonneg _))

/-- The same actual corrected trial has exact support and orthogonality AND
passes the complete rounding-aware arithmetic tail certificate. Source
bounds concern raw coefficients, an approximate scalar correction, symbols
and readout parameters; no orthogonality premise or projected-error oracle
is provided. All moment tests refer to the updated centers and radii. -/
theorem orthogonal_trial_residual_certificate {c : ℕ} (hc : 2 ≤ c)
    (S : Finset ℤ) (k v center symbolCenter : ℤ → ℂ) (ev es : ℤ → ℝ)
    (hev : ∀ n ∈ S, ‖v n - center n‖ ≤ ev n)
    (hes : ∀ n ∈ S, ‖(arithmeticBoundarySymbol c n : ℂ) - symbolCenter n‖ ≤ es n)
    (b : ℂ) (eps sigmaLo : ℝ) (heps : 0 ≤ eps) (hlo : 0 < sigmaLo)
    (hsigma : sigmaLo ≤ ∑ n ∈ S, ‖k n‖ ^ 2)
    (hresidual : ‖(∑ n ∈ S, conj (k n) * center n) -
        b * ((∑ n ∈ S, ‖k n‖ ^ 2 : ℝ) : ℂ)‖ +
      (∑ n ∈ S, ‖k n‖ * ev n) ≤ eps * sigmaLo)
    (N e0 e1 B p V H W tau : ℚ)
    (hN : 0 ≤ (N : ℝ)) (hS : ∀ n ∈ S, |(n : ℝ)| ≤ (N : ℝ))
    (h0 : ‖∑ n ∈ S, (center n - b * k n)‖ +
      ∑ n ∈ S, (ev n + eps * ‖k n‖) ≤ (e0 : ℝ))
    (h1 : ‖∑ n ∈ S, symbolCenter n * (center n - b * k n)‖ +
      ∑ n ∈ S, (‖symbolCenter n‖ * (ev n + eps * ‖k n‖) +
        es n * ‖center n - b * k n‖ + es n * (ev n + eps * ‖k n‖)) ≤ (e1 : ℝ))
    (hV : (∑ n ∈ S, (‖center n - b * k n‖ + (ev n + eps * ‖k n‖))) ≤ (V : ℝ))
    (hB : arithmeticBoundaryBudget c ≤ (B : ℝ)) (hp : 0 < (p : ℝ))
    (hpi : (p : ℝ) ≤ Real.pi)
    (eta etaCenter w wCenter : ℂ) (ee ew : ℝ)
    (heta : ‖eta - etaCenter‖ ≤ ee) (hetaH : ‖etaCenter‖ + ee ≤ (H : ℝ))
    (hw : ‖w - wCenter‖ ≤ ew) (hwW : ‖wCenter‖ + ew ≤ (W : ℝ))
    {M : ℕ} (hcheck : residualTailCheck M N W ((e1 + B * e0) / p)
      ((4 / 3 : ℚ) * H + 4 * B * N / p * V) tau = true) :
    (∀ n, n ∉ S → orthogonalTrial S k v n = 0) ∧
    (∑ n ∈ S, conj (k n) * orthogonalTrial S k v n) = 0 ∧
    Summable (fun j : ℕ => ‖arithmeticResidualTail c S (orthogonalTrial S k v) eta w M false j‖ ^ 2 +
      ‖arithmeticResidualTail c S (orthogonalTrial S k v) eta w M true j‖ ^ 2) ∧
    (∑' j : ℕ, ‖arithmeticResidualTail c S (orthogonalTrial S k v) eta w M false j‖ ^ 2 +
      ‖arithmeticResidualTail c S (orthogonalTrial S k v) eta w M true j‖ ^ 2) ≤ (tau : ℝ) := by
  have hnew := (orthogonal_trial_enclosures S k v center ev hev b eps sigmaLo
    heps hlo hsigma hresidual).2
  have htail := rounded_residual_certificate_sound hc S (orthogonalTrial S k v)
    (fun n => center n - b * k n) symbolCenter (fun n => ev n + eps * ‖k n‖) es
    hnew hes N e0 e1 B p V H W tau hN hS h0 h1 hV hB hp hpi
    eta etaCenter w wCenter ee ew heta hetaH hw hwW hcheck
  exact ⟨(orthogonal_trial_constraints S k v).1,
    (orthogonal_trial_constraints S k v).2, htail⟩

#print axioms orthogonal_trial_enclosures
#print axioms orthogonal_trial_residual_certificate

end D5.S3.Weil.ZetaBridge.WeilOrthogonalTrialPrecision
