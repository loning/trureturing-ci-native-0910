import D5.S3.Zeros.Jensen.NormalizedJensenDegreeLowering
import Mathlib.Algebra.Polynomial.Reverse
import Mathlib.Analysis.Calculus.Deriv.Polynomial
import Mathlib.Analysis.Complex.RealDeriv
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import D5.S3.Zeros.Jensen.SourceJensenPrincipalBlockObstruction
import Mathlib.Analysis.Complex.Polynomial.GaussLucas
import Mathlib.Analysis.Complex.Convex
import Mathlib.Tactic

set_option autoImplicit false
noncomputable section
open Polynomial
open D5.S3.Zeros.Jensen.NormalizedJensenDegreeLowering
namespace B1BindOnlyProbe

def alpha (d : ℕ) : ℂ := ((d - 1 : ℕ) : ℂ) / (d : ℂ)
def Q (p : ℂ[X]) (d : ℕ) : ℂ[X] := (p.comp (C (-1) * X)).reflect d

private theorem normalized_degree (a : ℕ → ℝ) (d : ℕ) (hd : 1 ≤ d) :
    (normalizedJensen a d).natDegree ≤ d := by
  rw [normalizedJensen_eq_fallingFactorial_sum a d hd]
  apply natDegree_sum_le_of_forall_le
  intro k hk
  exact (natDegree_C_mul_X_pow_le _ _).trans (by simpa using Finset.mem_range.mp hk)

private theorem alpha_ne_zero (d : ℕ) (hd : 2 ≤ d) : alpha d ≠ 0 := by
  apply div_ne_zero <;> exact_mod_cast (show _ ≠ 0 by omega)

private theorem reflect_transport (p r : ℂ[X]) (d : ℕ) (hd : 2 ≤ d)
    (hp : p.natDegree ≤ d) (hr : r.natDegree ≤ d - 1)
    (h : p - C ((d : ℂ)⁻¹) * X * p.derivative = r.comp (C (alpha d) * X)) :
    (Q p d).derivative =
      C ((d : ℂ) * alpha d ^ (d - 1)) * (Q r (d - 1)).comp (C ((alpha d)⁻¹) * X) := by
  have hd0 : (d : ℂ) ≠ 0 := by exact_mod_cast (show d ≠ 0 by omega)
  have ha0 := alpha_ne_zero d hd
  have hder (f : ℂ[X]) (n : ℕ) : (X * f.derivative).coeff n = f.coeff n * (n : ℂ) := by
    cases n <;> simp [coeff_X_mul, coeff_derivative]
  ext k
  by_cases hk : k < d
  · have hk1 : k + 1 ≤ d := by omega
    have hk2 : k ≤ d - 1 := by omega
    have hind : d - 1 - k = d - (k + 1) := by omega
    have hcoeff := congrArg (fun f : ℂ[X] => f.coeff (d - (k + 1))) h
    simp only [coeff_sub, mul_assoc, coeff_C_mul, hder, comp_C_mul_X_coeff] at hcoeff
    simp only [Q, coeff_derivative, coeff_reflect, revAt_le hk1, coeff_C_mul,
      comp_C_mul_X_coeff, revAt_le hk2, hind]
    have hcast : ((d - (k + 1) : ℕ) : ℂ) = (d : ℂ) - ((k : ℂ) + 1) := by
      rw [Nat.cast_sub hk1]
      push_cast
      rfl
    rw [hcast] at hcoeff
    have hpow : alpha d ^ (d - 1) * (alpha d)⁻¹ ^ k = alpha d ^ (d - (k + 1)) := by
      rw [← hind, pow_sub₀ (alpha d) ha0 hk2, inv_pow]
    calc
      _ = (d : ℂ) * (r.coeff (d - (k + 1)) * alpha d ^ (d - (k + 1))) *
          (-1 : ℂ) ^ (d - (k + 1)) := by
        field_simp at hcoeff
        linear_combination (-1 : ℂ) ^ (d - (k + 1)) * hcoeff
      _ = _ := by rw [← hpow]; ring
  · have hk1 : d < k + 1 := by omega
    have hk2 : d - 1 < k := by omega
    simp only [Q, coeff_derivative, coeff_reflect, revAt_eq_self_of_lt hk1,
      coeff_C_mul, comp_C_mul_X_coeff, revAt_eq_self_of_lt hk2]
    rw [coeff_eq_zero_of_natDegree_lt (hp.trans_lt hk1),
      coeff_eq_zero_of_natDegree_lt (hr.trans_lt hk2)]
    simp

-- B5 for every real coefficient sequence; the source is a direct specialization.
theorem b1_polynomial (a : ℕ → ℝ) (d : ℕ) (hd : 2 ≤ d) :
    (Q (normalizedJensen a d) d).derivative =
      C ((d : ℂ) * alpha d ^ (d - 1)) *
        (Q (normalizedJensen a (d - 1)) (d - 1)).comp (C ((alpha d)⁻¹) * X) := by
  exact reflect_transport _ _ d hd (normalized_degree a d (by omega))
    (normalized_degree a (d - 1) (by omega)) (normalizedJensen_degree_lowering a d hd)

-- The reciprocal identity is restricted to nonzero arguments.
theorem reciprocal_binding (p : ℂ[X]) (d : ℕ) (hp : p.natDegree ≤ d)
    (x : ℂ) (hx : x ≠ 0) : (Q p d).eval x = x ^ d * p.eval (-1 / x) := by
  have hneg : (p.comp (C (-1) * X)).natDegree ≤ d := by
    apply natDegree_comp_le.trans
    calc
      _ ≤ p.natDegree * 1 := Nat.mul_le_mul_left _ (by
        simpa using (natDegree_mul_le (p := C (-1 : ℂ)) (q := X)))
      _ ≤ d := by simpa using hp
  letI : Invertible (x⁻¹) := invertibleOfNonzero (inv_ne_zero hx)
  have h := eval₂_reflect_mul_pow (RingHom.id ℂ) (x⁻¹) d
    (p.comp (C (-1) * X)) hneg
  simp only [invOf_eq_inv, inv_inv, eval₂_id, eval_comp, eval_mul, eval_C,
    eval_X, neg_one_mul] at h
  change (Q p d).eval x * x⁻¹ ^ d = p.eval (-x⁻¹) at h
  calc
    _ = ((Q p d).eval x * x⁻¹ ^ d) * x ^ d := by simp [inv_pow, hx]
    _ = p.eval (-x⁻¹) * x ^ d := by rw [h]
    _ = _ := by simp [div_eq_mul_inv, mul_comm]

-- At zero, evaluate the reflected polynomial, never a totalized reciprocal.
theorem binding_at_zero (p : ℂ[X]) (d : ℕ) :
    (Q p d).eval 0 = p.coeff d * (-1) ^ d := by
  rw [← coeff_zero_eq_eval_zero]
  simp only [Q, coeff_reflect, revAt_zero, comp_C_mul_X_coeff]

theorem b1_eval (a : ℕ → ℝ) (d : ℕ) (hd : 2 ≤ d) (x : ℂ) :
    (Q (normalizedJensen a d) d).derivative.eval x =
      (d : ℂ) * alpha d ^ (d - 1) *
        (Q (normalizedJensen a (d - 1)) (d - 1)).eval (x / alpha d) := by
  rw [b1_polynomial a d hd]
  simp only [eval_mul, eval_C, eval_comp, eval_X, div_eq_mul_inv]
  rw [mul_comm ((alpha d)⁻¹) x]

theorem b1_source (d : ℕ) (hd : 2 ≤ d) (x : ℂ) :
    deriv (fun x => (Q (sourceJensenPolynomial d) d).eval x) x =
      (d : ℂ) * alpha d ^ (d - 1) *
        (Q (sourceJensenPolynomial (d - 1)) (d - 1)).eval (x / alpha d) := by
  rw [Polynomial.deriv, sourceJensenPolynomial_eq_normalizedJensen d (by omega),
    sourceJensenPolynomial_eq_normalizedJensen (d - 1) (by omega)]
  exact b1_eval sourceThetaCoefficient d hd x

theorem source_binding (d : ℕ) (hd : 1 ≤ d) (x : ℂ) (hx : x ≠ 0) :
    (Q (sourceJensenPolynomial d) d).eval x =
      x ^ d * (sourceJensenPolynomial d).eval (-1 / x) := by
  apply reciprocal_binding _ d _ x hx
  rw [sourceJensenPolynomial_eq_normalizedJensen d hd]
  exact normalized_degree sourceThetaCoefficient d hd



-- Universal root predicates include all multiplicities and make the zero polynomial non-real-rooted.
def RealRoots (p : ℂ[X]) : Prop := ∀ z : ℂ, p.eval z = 0 → z.im = 0

theorem real_neg_reciprocal (z : ℂ) (hz : z.im = 0) : (-1/z).im = 0 := by
  simp [Complex.div_im, hz]

theorem neg_reciprocal_invol (z : ℂ) : (-1 : ℂ)/(-1/z) = z := by
  simp [div_eq_mul_inv]

theorem reflect_real_iff (p : ℂ[X]) (d : ℕ) (hp : p.natDegree ≤ d) :
    RealRoots (Q p d) ↔ RealRoots p := by
  constructor
  · intro h z hz
    by_cases hz0 : z = 0
    · simp [hz0]
    have hw : (-1 : ℂ)/z ≠ 0 := div_ne_zero (by norm_num) hz0
    have hroot : (Q p d).eval (-1/z) = 0 := by
      rw [reciprocal_binding p d hp _ hw, neg_reciprocal_invol, hz, mul_zero]
    simpa only [neg_reciprocal_invol] using real_neg_reciprocal _ (h _ hroot)
  · intro h z hz
    by_cases hz0 : z = 0
    · simp [hz0]
    rw [reciprocal_binding p d hp z hz0] at hz
    have hr := (mul_eq_zero.mp hz).resolve_left (pow_ne_zero _ hz0)
    simpa only [neg_reciprocal_invol] using real_neg_reciprocal _ (h _ hr)

theorem real_derivative (p : ℂ[X]) (hp : 0 < p.degree) (hr : RealRoots p) :
    RealRoots p.derivative := by
  intro z hz
  have hd : p.derivative ≠ 0 := derivative_ne_zero.mpr
    (Nat.ne_of_gt (natDegree_pos_iff_degree_pos.mpr hp))
  have hroot : z ∈ p.derivative.rootSet ℂ := by
    simpa only [mem_rootSet, coe_aeval_eq_eval] using And.intro hd hz
  have hh := p.rootSet_derivative_subset_convexHull_rootSet hp hroot
  have hs₁ : p.rootSet ℂ ⊆ {w : ℂ | w.im ≤ 0} := by
    intro w hw
    have := (mem_rootSet.mp hw).2
    exact (hr w (by simpa using this)).le
  have hs₂ : p.rootSet ℂ ⊆ {w : ℂ | 0 ≤ w.im} := by
    intro w hw
    have := (mem_rootSet.mp hw).2
    exact (hr w (by simpa using this)).ge
  exact le_antisymm (convexHull_min hs₁ (convex_halfSpace_im_le 0) hh)
    (convexHull_min hs₂ (convex_halfSpace_im_ge 0) hh)

theorem positive_derivative (p : ℂ[X]) (hp : 0 < p.degree)
    (hr : ∀ z : ℂ, p.eval z = 0 → z.im = 0 ∧ 0 < z.re) :
    ∀ z : ℂ, p.derivative.eval z = 0 → z.im = 0 ∧ 0 < z.re := by
  intro z hz
  refine ⟨real_derivative p hp (fun w hw => (hr w hw).1) z hz, ?_⟩
  have hd : p.derivative ≠ 0 := derivative_ne_zero.mpr
    (Nat.ne_of_gt (natDegree_pos_iff_degree_pos.mpr hp))
  have hroot : z ∈ p.derivative.rootSet ℂ := by
    simpa only [mem_rootSet, coe_aeval_eq_eval] using And.intro hd hz
  apply convexHull_min (t := {w : ℂ | 0 < w.re}) _ (convex_halfSpace_re_gt 0)
    (p.rootSet_derivative_subset_convexHull_rootSet hp hroot)
  intro w hw
  exact (hr w (by simpa using (mem_rootSet.mp hw).2)).2

theorem source_real_descent (d : ℕ) (hd : 2 ≤ d) (h0 : sourceThetaCoefficient 0 = 1)
    (hp : RealRoots (sourceJensenPolynomial d)) :
    RealRoots (sourceJensenPolynomial (d-1)) := by
  have hpdeg (k : ℕ) (hk : 1 ≤ k) : (sourceJensenPolynomial k).natDegree ≤ k := by
    rw [sourceJensenPolynomial_eq_normalizedJensen k hk]
    exact normalized_degree _ k hk
  have hq := (reflect_real_iff _ d (hpdeg d (by omega))).mpr hp
  have htop : (Q (sourceJensenPolynomial d) d).coeff d = 1 := by
    simp only [Q, coeff_reflect, revAt_self, comp_C_mul_X_coeff]
    rw [(D5.S3.Zeros.Jensen.SourceJensenPrincipalBlockObstruction.source_jensen_coeff_edges d (by omega)).1, h0]
    simp
  have hqdeg : 0 < (Q (sourceJensenPolynomial d) d).degree := by
    apply natDegree_pos_iff_degree_pos.mp
    have := le_natDegree_of_ne_zero (by rw [htop]; exact one_ne_zero)
    omega
  have hqder := real_derivative _ hqdeg hq
  apply (reflect_real_iff _ (d-1) (hpdeg _ (by omega))).mp
  intro z hz
  have hscaled : (Q (sourceJensenPolynomial d) d).derivative.eval (alpha d*z) = 0 := by
    rw [sourceJensenPolynomial_eq_normalizedJensen d (by omega), b1_eval _ d hd]
    rw [mul_div_cancel_left₀ z (alpha_ne_zero d hd)]
    rw [← sourceJensenPolynomial_eq_normalizedJensen (d-1) (by omega), hz, mul_zero]
  have hh := hqder (alpha d*z) hscaled
  have haim : (alpha d).im = 0 := by simp [alpha, Complex.div_im]
  have hare : (alpha d).re ≠ 0 := by
    intro hre
    apply alpha_ne_zero d hd
    apply Complex.ext <;> simp [hre, haim]
  simp only [Complex.mul_im, haim, zero_mul, add_zero] at hh
  exact (mul_eq_zero.mp hh).resolve_left hare

theorem source_real_antitone (h0 : sourceThetaCoefficient 0 = 1) :
    Antitone (fun n : ℕ => RealRoots (sourceJensenPolynomial (n+1))) := by
  apply antitone_nat_of_succ_le
  intro n
  simpa only [Nat.add_sub_cancel] using source_real_descent (n+1+1) (by omega) h0

theorem source_failure_upward (h0 : sourceThetaCoefficient 0 = 1)
    (m d : ℕ) (hm : 1 ≤ m) (hmd : m ≤ d)
    (hbad : ∃ z : ℂ, (sourceJensenPolynomial m).eval z = 0 ∧ z.im ≠ 0) :
    ∃ z : ℂ, (sourceJensenPolynomial d).eval z = 0 ∧ z.im ≠ 0 := by
  have hb : ¬ RealRoots (sourceJensenPolynomial m) := by
    obtain ⟨z,hz,hi⟩ := hbad
    exact fun h => hi (h z hz)
  have hh : ¬ RealRoots (sourceJensenPolynomial d) := by
    intro h
    apply hb
    have ht := source_real_antitone h0 (show m-1 ≤ d-1 by omega)
    have hh : RealRoots (sourceJensenPolynomial (d-1+1)) := by
      simpa only [Nat.sub_add_cancel (show 1 ≤ d by omega)] using h
    simpa only [Nat.sub_add_cancel hm] using ht hh
  simpa only [RealRoots, not_forall, not_imp] using hh

theorem source_minimal_failure (h0 : sourceThetaCoefficient 0 = 1)
    (hex : ∃ d : ℕ, 1 ≤ d ∧ ¬ RealRoots (sourceJensenPolynomial d)) :
    ∃ d₀ : ℕ, 1 ≤ d₀ ∧ ¬ RealRoots (sourceJensenPolynomial d₀) ∧
      (∀ k, 1 ≤ k → k < d₀ → RealRoots (sourceJensenPolynomial k)) ∧
      (∀ d, d₀ ≤ d → ¬ RealRoots (sourceJensenPolynomial d)) := by
  classical
  let d₀ := Nat.find hex
  have hd₀ := Nat.find_spec hex
  refine ⟨d₀, hd₀.1, hd₀.2, ?_, ?_⟩
  · intro k hk hkd
    exact Classical.byContradiction (fun h => (Nat.find_min hex hkd) ⟨hk,h⟩)
  · intro d hdd hdgood
    apply hd₀.2
    have ht := source_real_antitone h0 (show d₀-1 ≤ d-1 by omega)
    have hh : RealRoots (sourceJensenPolynomial (d-1+1)) := by
      simpa only [Nat.sub_add_cancel (show 1 ≤ d by omega)] using hdgood
    simpa only [Nat.sub_add_cancel hd₀.1] using ht hh

def NonnegativeRoots (p : ℂ[X]) : Prop :=
  ∀ z : ℂ, p.eval z = 0 → z.im = 0 ∧ 0 ≤ z.re

def NegativeRoots (p : ℂ[X]) : Prop :=
  ∀ z : ℂ, p.eval z = 0 → z.im = 0 ∧ z.re < 0

theorem nonnegative_derivative (p : ℂ[X]) (hp : 0 < p.degree)
    (hr : NonnegativeRoots p) : NonnegativeRoots p.derivative := by
  intro z hz
  refine ⟨real_derivative p hp (fun w hw => (hr w hw).1) z hz, ?_⟩
  have hd : p.derivative ≠ 0 := derivative_ne_zero.mpr
    (Nat.ne_of_gt (natDegree_pos_iff_degree_pos.mpr hp))
  have hroot : z ∈ p.derivative.rootSet ℂ := by
    simpa only [mem_rootSet, coe_aeval_eq_eval] using And.intro hd hz
  apply convexHull_min (t := {w : ℂ | 0 ≤ w.re}) _ (convex_halfSpace_re_ge 0)
    (p.rootSet_derivative_subset_convexHull_rootSet hp hroot)
  intro w hw
  exact (hr w (by simpa using (mem_rootSet.mp hw).2)).2

-- A degree deficit gives zero roots of Q; retaining them is essential.
theorem reflect_nonnegative_of_negative (p : ℂ[X]) (d : ℕ)
    (hp : p.natDegree ≤ d) (hr : NegativeRoots p) : NonnegativeRoots (Q p d) := by
  intro z hz
  by_cases hz0 : z = 0
  · simp [hz0]
  rw [reciprocal_binding p d hp z hz0] at hz
  have hw := hr (-1/z) ((mul_eq_zero.mp hz).resolve_left (pow_ne_zero _ hz0))
  have him : z.im = 0 := by
    simpa only [neg_reciprocal_invol] using real_neg_reciprocal _ hw.1
  refine ⟨him, ?_⟩
  have hre : z.re ≠ 0 := by
    intro h
    exact hz0 (Complex.ext h him)
  have hneg : -(z.re) / Complex.normSq z < 0 := by
    simpa [Complex.div_re] using hw.2
  have hn : 0 < Complex.normSq z := Complex.normSq_pos.mpr hz0
  have := (div_neg_iff_of_pos_right hn).mp hneg
  linarith only [this]

theorem negative_of_reflect_nonnegative (p : ℂ[X]) (d : ℕ)
    (hp : p.natDegree ≤ d) (hzero : p.eval 0 ≠ 0)
    (hr : NonnegativeRoots (Q p d)) : NegativeRoots p := by
  intro z hz
  have hz0 : z ≠ 0 := by intro h; subst z; exact hzero hz
  have hw0 : (-1 : ℂ)/z ≠ 0 := div_ne_zero (by norm_num) hz0
  have hroot : (Q p d).eval (-1/z) = 0 := by
    rw [reciprocal_binding p d hp _ hw0, neg_reciprocal_invol, hz, mul_zero]
  have hw := hr _ hroot
  have him : z.im = 0 := by
    simpa only [neg_reciprocal_invol] using real_neg_reciprocal _ hw.1
  refine ⟨him, ?_⟩
  have hneq : (-1/z : ℂ).re ≠ 0 := by
    intro h
    exact hw0 (Complex.ext h hw.1)
  have hpos : 0 < (-1/z : ℂ).re := lt_of_le_of_ne hw.2 (Ne.symm hneq)
  have hn : 0 < Complex.normSq z := Complex.normSq_pos.mpr hz0
  have : 0 < -(z.re) / Complex.normSq z := by
    simpa [Complex.div_re] using hpos
  have := (div_pos_iff_of_pos hn).mp this
  linarith only [this]

theorem source_negative_descent (d : ℕ) (hd : 2 ≤ d)
    (h0 : sourceThetaCoefficient 0 = 1)
    (hp : NegativeRoots (sourceJensenPolynomial d)) :
    NegativeRoots (sourceJensenPolynomial (d-1)) := by
  have hpdeg (k : ℕ) (hk : 1 ≤ k) : (sourceJensenPolynomial k).natDegree ≤ k := by
    rw [sourceJensenPolynomial_eq_normalizedJensen k hk]
    exact normalized_degree _ k hk
  have hq := reflect_nonnegative_of_negative _ d (hpdeg d (by omega)) hp
  have htop : (Q (sourceJensenPolynomial d) d).coeff d = 1 := by
    simp only [Q, coeff_reflect, revAt_self, comp_C_mul_X_coeff]
    rw [(D5.S3.Zeros.Jensen.SourceJensenPrincipalBlockObstruction.source_jensen_coeff_edges d (by omega)).1, h0]
    simp
  have hqdeg : 0 < (Q (sourceJensenPolynomial d) d).degree := by
    apply natDegree_pos_iff_degree_pos.mp
    have := le_natDegree_of_ne_zero (by rw [htop]; exact one_ne_zero)
    omega
  have hqder := nonnegative_derivative _ hqdeg hq
  have hzero : (sourceJensenPolynomial (d-1)).eval 0 ≠ 0 := by
    rw [← coeff_zero_eq_eval_zero,
      (D5.S3.Zeros.Jensen.SourceJensenPrincipalBlockObstruction.source_jensen_coeff_edges (d-1) (by omega)).1, h0]
    simp
  apply negative_of_reflect_nonnegative _ (d-1) (hpdeg _ (by omega)) hzero
  intro z hz
  have hscaled : (Q (sourceJensenPolynomial d) d).derivative.eval (alpha d*z) = 0 := by
    rw [sourceJensenPolynomial_eq_normalizedJensen d (by omega), b1_eval _ d hd]
    rw [mul_div_cancel_left₀ z (alpha_ne_zero d hd)]
    rw [← sourceJensenPolynomial_eq_normalizedJensen (d-1) (by omega), hz, mul_zero]
  have hh := hqder _ hscaled
  have haim : (alpha d).im = 0 := by simp [alpha, Complex.div_im]
  have hare : 0 < (alpha d).re := by
    simp only [alpha, Complex.div_re, Complex.natCast_re, Complex.natCast_im,
      mul_zero, add_zero, Complex.normSq_natCast]
    positivity
  simp only [Complex.mul_im, Complex.mul_re, haim, zero_mul, add_zero, sub_zero] at hh
  exact ⟨(mul_eq_zero.mp hh.1).resolve_left (ne_of_gt hare),
    (mul_nonneg_iff_of_pos_left hare).mp hh.2⟩

#print axioms source_negative_descent
#print axioms reflect_real_iff
#print axioms positive_derivative
#print axioms source_real_descent
#print axioms source_failure_upward
#print axioms source_minimal_failure
end B1BindOnlyProbe
