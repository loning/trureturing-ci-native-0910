/- GID: D5/S3/Zeros/Convolution/GribinskiDegreeThree
   generality: G
   mirror-B: D5/B/S3/Zeros/Convolution/GribinskiDegreeThree
   mirror-E: none(waiver:symbolic-real-parameter-proof)
   anchors: []
   utility: none
   digest: Fixed-degree-three generalized rectangular convolution. -/

import Mathlib.RingTheory.Polynomial.Pochhammer
import Mathlib.Algebra.CubicDiscriminant
import Mathlib.Tactic

/-!
Definition 3.10 of Campbell, Morales, and Perales, arXiv:2502.00254v2,
specialized to m=3. The weight is the PRODUCT of two falling factorials.
The coefficient definition applies to arbitrary input polynomials before
specialization to root triples. The consistency theorem checks k=0,1,2,3.

This is a symbolic real-parameter development, not a finite enumeration or
an assertion about general m. See docs/reports/convolution/gribinski-m3-0909.md
for the first bind-only attempt, declaration classifications, and measurements.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

open Polynomial

namespace D5.S3.Zeros.Convolution.GribinskiDegreeThree

/-- The signed coefficient convention in fixed degree three. -/
def elementaryCoeff (p : Real[X]) (k : Nat) : Real :=
  (-1) ^ k * p.coeff (3 - k)

/-- The product prefactor from Definition 3.10, with m=3. -/
def weight (alpha : Real) (k : Nat) : Real :=
  (descPochhammer Real k).eval 3 * (descPochhammer Real k).eval (3 + alpha)

def normalizedCoeff (alpha : Real) (p : Real[X]) (k : Nat) : Real :=
  elementaryCoeff p k / weight alpha k

/-- The sum over i+j=k, indexed by i=0,...,k. -/
def convolutionCoeff (alpha : Real) (p q : Real[X]) (k : Nat) : Real :=
  weight alpha k * ((Finset.range (k + 1)).sum fun i =>
    normalizedCoeff alpha p i * normalizedCoeff alpha q (k - i))

/-- General degree-three coefficient convolution. -/
def boxplus3 (alpha : Real) (p q : Real[X]) : Real[X] :=
  C (convolutionCoeff alpha p q 0) * X ^ 3 -
    C (convolutionCoeff alpha p q 1) * X ^ 2 +
    C (convolutionCoeff alpha p q 2) * X - C (convolutionCoeff alpha p q 3)

def rootTriple (a b c : Real) : Real[X] := (X - C a) * (X - C b) * (X - C c)

/-- All four signed output coefficients agree with the defining convolution. -/
theorem definition_consistency (alpha : Real) (p q : Real[X]) (k : Nat) (hk : k <= 3) :
    elementaryCoeff (boxplus3 alpha p q) k = convolutionCoeff alpha p q k := by
  interval_cases k <;> norm_num [elementaryCoeff, boxplus3]

/-- The cross weight for the second elementary coefficient. -/
def kappa (alpha : Real) : Real := 2 * (alpha + 2) / (3 * (alpha + 3))

/-- The cross weight for the third elementary coefficient. -/
def rho (alpha : Real) : Real := (alpha + 1) / (3 * (alpha + 3))

private theorem weight_values (alpha : Real) :
    weight alpha 0 = 1 /\ weight alpha 1 = 3 * (alpha + 3) /\
      weight alpha 2 = 6 * (alpha + 3) * (alpha + 2) /\
      weight alpha 3 = 6 * (alpha + 3) * (alpha + 2) * (alpha + 1) := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> norm_num [weight, descPochhammer_succ_eval] <;> ring

private theorem rootTriple_coefficients (a b c : Real) :
    elementaryCoeff (rootTriple a b c) 0 = 1 /\
      elementaryCoeff (rootTriple a b c) 1 = a + b + c /\
      elementaryCoeff (rootTriple a b c) 2 = a * b + a * c + b * c /\
      elementaryCoeff (rootTriple a b c) 3 = a * b * c := by
  unfold rootTriple
  rw [Cubic.prod_X_sub_C_eq]
  norm_num [elementaryCoeff]

/-- Substitution of the two root triples into all four defining coefficient sums. -/
theorem convolution_coefficients (alpha a b c d e f : Real)
    (h1 : alpha ≠ -1) (h2 : alpha ≠ -2) (h3 : alpha ≠ -3) :
    convolutionCoeff alpha (rootTriple a b c) (rootTriple d e f) 0 = 1 /\
      convolutionCoeff alpha (rootTriple a b c) (rootTriple d e f) 1 =
        a + b + c + (d + e + f) /\
      convolutionCoeff alpha (rootTriple a b c) (rootTriple d e f) 2 =
        a * b + a * c + b * c + (d * e + d * f + e * f) +
          kappa alpha * (a + b + c) * (d + e + f) /\
      convolutionCoeff alpha (rootTriple a b c) (rootTriple d e f) 3 =
        a * b * c + d * e * f + rho alpha *
          ((a + b + c) * (d * e + d * f + e * f) +
            (a * b + a * c + b * c) * (d + e + f)) := by
  have ha1 : alpha + 1 ≠ 0 := by intro h; apply h1; linarith only [h]
  have ha2 : alpha + 2 ≠ 0 := by intro h; apply h2; linarith only [h]
  have ha3 : alpha + 3 ≠ 0 := by intro h; apply h3; linarith only [h]
  rcases weight_values alpha with ⟨w0, w1, w2, w3⟩
  rcases rootTriple_coefficients a b c with ⟨p0, p1, p2, p3⟩
  rcases rootTriple_coefficients d e f with ⟨q0, q1, q2, q3⟩
  refine ⟨?_, ?_, ?_, ?_⟩ <;>
    simp only [convolutionCoeff, Finset.sum_range_succ, Finset.sum_range_zero,
      normalizedCoeff, p0, p1, p2, p3, q0, q1, q2, q3, w0, w1, w2, w3] <;>
    norm_num [kappa, rho] <;> field_simp <;> ring

/-- The explicit cubic follows from the general Definition 3.10 coefficient operation. -/
theorem m3_explicit_coefficients (alpha a b c d e f : Real)
    (h1 : alpha ≠ -1) (h2 : alpha ≠ -2) (h3 : alpha ≠ -3) :
    boxplus3 alpha (rootTriple a b c) (rootTriple d e f) =
      X ^ 3 - C (a + b + c + (d + e + f)) * X ^ 2 +
        C (a * b + a * c + b * c + (d * e + d * f + e * f) +
          kappa alpha * (a + b + c) * (d + e + f)) * X -
        C (a * b * c + d * e * f + rho alpha *
          ((a + b + c) * (d * e + d * f + e * f) +
            (a * b + a * c + b * c) * (d + e + f))) := by
  rcases convolution_coefficients alpha a b c d e f h1 h2 h3 with ⟨h0, he1, he2, he3⟩
  simp [boxplus3, h0, he1, he2, he3]

#print axioms definition_consistency
#print axioms convolution_coefficients
#print axioms m3_explicit_coefficients

end D5.S3.Zeros.Convolution.GribinskiDegreeThree
