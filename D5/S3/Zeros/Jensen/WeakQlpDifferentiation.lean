/- GID: D5/S3/Zeros/Jensen/WeakQlpDifferentiation
   generality: I
   mirror-B: D5/B/S3/Zeros/Jensen/WeakQlpDifferentiation
   mirror-E: none(waiver:exact-polynomial-identities)
   anchors: []
   utility: kind=certified-instance; basis=refutes=gid:D5/S3/Zeros/Jensen/WeakQlpDifferentiation.Question62Claim; result=D5/S3/Zeros/Jensen/WeakQlpDifferentiation.question62_refuted; claim=D5/S3/Zeros/Jensen/WeakQlpDifferentiation.Question62Claim
   digest: A rational cubic refutes differentiation closure of the weak q-Laguerre-Polya class. -/

import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Algebra.Polynomial.Splits
import Mathlib.Algebra.Polynomial.Degree.SmallDegree
import Mathlib.Algebra.QuadraticDiscriminant
import Mathlib.Data.Real.Basic
import Mathlib.Tactic

namespace D5.S3.Zeros.Jensen.WeakQlpDifferentiation

noncomputable section
open Polynomial

/-- The normalized q-Borel transform on real polynomials. For an ordinary
coefficient `c_k`, the exponential coefficient is `a_k = k! * c_k`, so the
factorial below is essential. The denominator is `(q;q)_k`. This is equation
(1.6), p. 3, of Dimitrov--Shapiro, arXiv:2606.17864v1, using (1.3), p. 2.
Only `0 < q < 1` is used in the closure claim; outside this interval the
definition uses Lean's total division. -/
def qBorel (q : ℝ) : ℝ[X] →ₗ[ℝ] ℝ[X] :=
  Polynomial.lsum fun k => (LinearMap.id : ℝ →ₗ[ℝ] ℝ).smulRight
    (monomial k ((Nat.factorial k : ℝ) * q ^ (k * (k - 1) / 2) *
      (1 - q) ^ k / ∏ j ∈ Finset.range k, (1 - q ^ (j + 1))))

/-- The ordinary coefficients of the counterexample at `q = 1/2`. -/
def halfCounterexample : ℝ[X] :=
  monomial 0 1 + monomial 1 3 + monomial 2 (9 / 2) + monomial 3 (7 / 2)

-- Anonymous normalization self-test; the sole named theorem will be the refutation.
example : qBorel (1 / 2) halfCounterexample = (X + 1) ^ 3 := by
  norm_num [qBorel, halfCounterexample, Polynomial.lsum_apply, Polynomial.sum_add_index,
    Polynomial.sum_monomial_index, add_smul, Nat.factorial, Finset.prod_range_succ]
  norm_num [Polynomial.sum, show (1 : ℝ[X]).support = {0} by
    simpa only [C_1] using support_C (one_ne_zero : (1 : ℝ) ≠ 0),
    smul_monomial, smul_eq_mul]
  norm_num [← C_mul_X_pow_eq_monomial, smul_eq_C_mul, map_ofNat]
  ring

end
end D5.S3.Zeros.Jensen.WeakQlpDifferentiation
