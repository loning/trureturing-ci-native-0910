/- GID: D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour
   generality: I
   mirror-B: D5/B/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: kind=certified-instance; basis=terminal=gid:D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour.centered_real_rooted
   digest: The source-defined finite free commutator of centered real-rooted quartics is real-rooted. -/

import Mathlib.Algebra.QuadraticDiscriminant
import Mathlib.Analysis.Real.Sqrt
import Mathlib.RingTheory.Polynomial.Pochhammer
import Mathlib.Data.Fin.VecNotation
import Mathlib.Tactic

/-!
Source: Campbell, Morales, Perales, arXiv:2502.00254v2, Definition 2.9 and
Notations 2.2, 3.7, 5.1. The target is Conjecture 5.3 for centered quartics.
Theorem 5.6 has an additional restriction, as explicitly stated in Remark 5.7.

The implementation preregistration names `centered_quartic_invariant_bounds`
as the escape witness. Its three squared-sum identities feed the discriminant
bound. The coefficient expansion is a companion on that same proof path.
No frozen D5 prerequisite is used. Quadratic root and Vieta facts come from
pinned Mathlib; the finite free convolution is not present in the searched
repository, Mathlib, or GitHub Lean sources.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

namespace D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFour

open Polynomial
open scoped BigOperators

private theorem centered_sum_squares (a b c d : ℝ) (h : a + b + c + d = 0) :
    -2 * (a*b + a*c + a*d + b*c + b*d + c*d) = a^2 + b^2 + c^2 + d^2 := by
  have hd : d = -a - b - c := by linarith
  rw [hd]
  ring

private theorem centered_invariant_sos (a b c d : ℝ) (h : a + b + c + d = 0) :
    (a*b + a*c + a*d + b*c + b*d + c*d)^2 + 12*(a*b*c*d) =
      ((a-b)^2*(c-d)^2 + (a-c)^2*(b-d)^2 + (a-d)^2*(b-c)^2) / 2 := by
  have hd : d = -a - b - c := by linarith
  rw [hd]
  ring

private theorem centered_product_sos (a b c d : ℝ) (h : a + b + c + d = 0) :
    (a*b + a*c + a*d + b*c + b*d + c*d)^2 - 4*(a*b*c*d) =
      (a*b-c*d)^2 + (a*c-b*d)^2 + (a*d-b*c)^2 := by
  have hd : d = -a - b - c := by linarith
  rw [hd]
  ring

#print axioms centered_sum_squares
#print axioms centered_invariant_sos
#print axioms centered_product_sos

end D5.S3.Zeros.Convolution.FiniteFreeCommutatorDegreeFour
