/- GID: D5/S1/Recurrence/Algebraic/CubicOddBisection
   generality: I
   mirror-B: D5/B/S1/Recurrence/Algebraic/CubicOddBisection
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: Polynomial elimination identifies the odd coefficients of two algebraic series. -/

import Mathlib.RingTheory.PowerSeries.Expand
import Mathlib.RingTheory.MvPowerSeries.NoZeroDivisors
import Mathlib.Algebra.Polynomial.Div
import Mathlib.Tactic.LinearCombination

open PowerSeries
namespace D5.S1.Recurrence.Algebraic.CubicOddBisection
private abbrev PS := PowerSeries ℚ
private def Agree (d : ℕ) (f g : PS) : Prop := ∀ n < d, coeff n f = coeff n g
private theorem agree_iff (d : ℕ) (f g : PS) :
    Agree d f g ↔ (X : PS) ^ d ∣ f - g := by
  simp [Agree, X_pow_dvd_iff, map_sub, sub_eq_zero]
private noncomputable def step (c : PS) (p : Polynomial PS) (f : PS) : PS :=
  c + X * p.eval f
private theorem step_agree (c : PS) (p : Polynomial PS) {d : ℕ} {f g : PS}
    (h : Agree d f g) : Agree (d + 1) (step c p f) (step c p g) := by
  apply (agree_iff _ _ _).mpr
  have hp := ((agree_iff _ _ _).mp h).trans (Polynomial.sub_dvd_eval_sub f g p)
  have hx := mul_dvd_mul_left (X : PS) hp
  simpa only [step, pow_succ', mul_sub, add_sub_add_left_eq_sub] using hx
private noncomputable def approximation (c : PS) (p : Polynomial PS) : ℕ → PS
  | 0 => c
  | k + 1 => step c p (approximation c p k)
private theorem approximation_stable (c : PS) (p : Polynomial PS) {d k : ℕ}
    (h : d ≤ k) : Agree d (approximation c p d) (approximation c p k) := by
  induction d generalizing k with
  | zero => intro n hn; omega
  | succ d ih =>
    cases k with
    | zero => omega
    | succ k => exact step_agree c p (ih (by omega))
private noncomputable def fixedSeries (c : PS) (p : Polynomial PS) : PS :=
  mk (fun n => coeff n (approximation c p (n + 1)))
private theorem fixed_agree (c : PS) (p : Polynomial PS) (d : ℕ) :
    Agree d (fixedSeries c p) (approximation c p d) := by
  intro n hn
  simpa only [fixedSeries, coeff_mk] using
    approximation_stable c p (by omega : n + 1 ≤ d) n (by omega)
private theorem fixed_equation (c : PS) (p : Polynomial PS) :
    fixedSeries c p = c + X * p.eval (fixedSeries c p) := by
  ext n
  exact (fixed_agree c p (n + 2) n (by omega)).trans
    (step_agree c p (fixed_agree c p (n + 1)) n (by omega)).symm

end D5.S1.Recurrence.Algebraic.CubicOddBisection
