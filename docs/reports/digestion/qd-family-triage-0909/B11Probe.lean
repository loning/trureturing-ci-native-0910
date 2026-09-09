import D5.S3.Zeros.Jensen.NormalizedJensenDegreeLowering
import Mathlib.Algebra.Polynomial.Reverse
import Mathlib.Analysis.Calculus.Deriv.Polynomial
import Mathlib.Analysis.Complex.RealDeriv
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import D5.S3.Zeros.Jensen.SourceJensenPrincipalBlockObstruction
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


-- B1.1: the last source coefficient is already a frozen projection.
theorem b11_constant (d : ℕ) (hd : 1 ≤ d) :
    (Q (sourceJensenPolynomial d) d).eval 0 =
      (-1 : ℂ)^d * (d.factorial : ℂ) / (d : ℂ)^d * (sourceThetaCoefficient d : ℂ) := by
  rw [binding_at_zero,
    (D5.S3.Zeros.Jensen.SourceJensenPrincipalBlockObstruction.source_jensen_coeff_edges d hd).2.2.2]
  ring

theorem b11_source (d : ℕ) (hd : 2 ≤ d) (x : ℝ) :
    (Q (sourceJensenPolynomial d) d).eval (x : ℂ) =
      (∫ u in (0 : ℝ)..x, (d : ℂ) * alpha d ^ (d - 1) *
        (Q (sourceJensenPolynomial (d - 1)) (d - 1)).eval ((u : ℂ) / alpha d)) +
      (-1 : ℂ)^d * (d.factorial : ℂ) / (d : ℂ)^d * (sourceThetaCoefficient d : ℂ) := by
  let q := Q (sourceJensenPolynomial d) d
  have hFTC := intervalIntegral.integral_eq_sub_of_hasDerivAt
    (a := (0 : ℝ)) (b := x)
    (fun u _ => (q.hasDerivAt (u : ℂ)).comp_ofReal)
    ((q.derivative.continuous.comp Complex.continuous_ofReal).intervalIntegrable 0 x)
  have hder (u : ℝ) : q.derivative.eval (u : ℂ) =
      (d : ℂ) * alpha d ^ (d - 1) *
        (Q (sourceJensenPolynomial (d - 1)) (d - 1)).eval ((u : ℂ) / alpha d) := by
    simpa only [q, Polynomial.deriv] using b1_source d hd (u : ℂ)
  simp_rw [hder] at hFTC
  simpa only [q, Complex.ofReal_zero, b11_constant d (by omega), sub_add_cancel] using
    (eq_add_of_sub_eq hFTC.symm)

#print axioms b11_constant
#print axioms b11_source
end B1BindOnlyProbe
