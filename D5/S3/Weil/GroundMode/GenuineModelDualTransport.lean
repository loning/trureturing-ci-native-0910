/- GID: D5/S3/Weil/GroundMode/GenuineModelDualTransport
   generality: G
   mirror-B: D5/B/S3/Weil/GroundMode/GenuineModelDualTransport
   mirror-E: none(waiver:domain-level-recentering-with-complete-residual)
   anchors: []
   digest: Transfer candidate-complement coercivity and complete dual trials to a nearby genuine model with arbitrary Fourier support. -/

import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Module
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-!
# Recenter a full-domain certificate on the genuine model

A finite trial v orthogonal to k need not be orthogonal to a nearby genuine
prolate model e. Its repaired trial v-<e,v>e generally has infinite Fourier
support. These theorems retain the FULL action on that correction rather
than applying a finite-support exterior bound to it.

The target consumer is the actual full-residual energy-dual inequality in
CoerciveDualCertificate/ProjectiveEnergyDual (PR #5882). Its coefficient is
not redefined here. This owner proves the change-of-candidate bounds needed
to use that existing inequality with the SAME genuine prolate family.

The action is defined only on a complex-linear domain. Completeness, a
bounded extension, a new exact dual inverse and a uniform spectral gap are
not assumed. The model is required to be in that domain and its actual
Rayleigh residual must be bounded. Mere L2 proximity would not suffice.

The algebra is classical hyperplane elimination and residual control,
consistent with the full-exterior Feshbach-Schur methodology; no priority
or actual all-scale Weil/prolate convergence is claimed.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section
namespace D5.S3.Weil.GroundMode.GenuineModelDualTransport

open scoped InnerProductSpace ComplexConjugate

variable {H E : Type*}
variable [NormedAddCommGroup H] [InnerProductSpace ℂ H]
variable [AddCommGroup E] [Module ℂ E]

private def off (k x : H) : H := x - ⟪k, x⟫_ℂ • k

private theorem unit_self (k : H) (hk : ‖k‖ = 1) : ⟪k, k⟫_ℂ = 1 := by
  rw [inner_self_eq_norm_sq_to_K, hk]
  norm_num

private theorem off_add (k x y : H) : off k (x + y) = off k x + off k y := by
  simp only [off, inner_add_right]
    let ell : ℝ := 2252813807 / 40960000000000000
    let kappa := 3 / 250000 - ell
    let delta := 560909 / 10000000000000 - ell
    let eps : ℝ := 113 / 100000
    let t : ℝ := 1 / 100000
    let s : ℝ := 1 / 10000
    let kp := kappa * (1 - eps ^ 2) / (1 + t) - delta * eps ^ 2 / t
    let C := (1 + s) * (1 + t) * 103 + eps ^ 2 / kp *
      ((1 + s) * (1 + 1 / t) * 103 * delta + (1 + 1 / s) * (1 / 500 : ℝ) ^ 2)
    kappa * (99997 / 100000) < kp ∧ C < 5151 / 50 ∧
      (929549 / 15625000000000 - ell) * (5151 / 50) < (681 / 1000000 : ℝ) ^ 2 := by
  norm_num

#print axioms positive_form_complement_coercivity
#print axioms positive_form_readout_transport
#print axioms positive_form_uniform_readout_bound
#print axioms prime_three_positive_form_budget

end D5.S3.Weil.GroundMode.GenuineModelDualTransport
end
