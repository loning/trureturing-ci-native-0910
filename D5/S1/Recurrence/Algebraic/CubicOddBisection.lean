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

private noncomputable def pA : Polynomial PS :=
  3 * Polynomial.X - Polynomial.X ^ 2 +
    Polynomial.C (3 * X) * Polynomial.X ^ 2 +
    Polynomial.C (2 * X ^ 2) * Polynomial.X ^ 3
private noncomputable def pB : Polynomial PS :=
  8 * Polynomial.X ^ 2 - 3 * Polynomial.X - Polynomial.C (16 * X) * Polynomial.X ^ 3

private theorem pA_eval (f : PS) :
    pA.eval f = 3 * f - f ^ 2 + 3 * X * f ^ 2 + 2 * X ^ 2 * f ^ 3 := by
  simp [pA]
private theorem pB_eval (f : PS) :
    pB.eval f = 8 * f ^ 2 - 3 * f - 16 * X * f ^ 3 := by
  simp [pB]

/-- The branch at 1 of xA³-A²+3xA+1=0, constructed by coefficient iteration. -/
noncomputable def A : PowerSeries ℚ := 1 + 2 * X * fixedSeries 1 pA
/-- The normalized inverse series, constructed independently by its own equation. -/
noncomputable def B : PowerSeries ℚ := fixedSeries 1 pB

theorem A_equation : constantCoeff A = 1 ∧ X * A ^ 3 - A ^ 2 + 3 * X * A + 1 = 0 := by
  refine ⟨by simp [A], ?_⟩
  have h := fixed_equation 1 pA
  rw [pA_eval] at h
  dsimp only [A]
  linear_combination -4 * X * h

theorem B_equation : constantCoeff B = 1 ∧ B * (1 - 4 * X * B) ^ 2 = 1 - 3 * X * B := by
  have h := fixed_equation 1 pB
  rw [pB_eval] at h
  change B = 1 + X * (8 * B ^ 2 - 3 * B - 16 * X * B ^ 3) at h
  refine ⟨?_, ?_⟩
  · have hc := congrArg constantCoeff h
    simpa using hc
  · linear_combination h

end D5.S1.Recurrence.Algebraic.CubicOddBisection
