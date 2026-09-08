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

#print axioms definition_consistency

end D5.S3.Zeros.Convolution.GribinskiDegreeThree
