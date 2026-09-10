import D5.S1.Recurrence.Residue.QuarticEGFFixedPoint
import Mathlib.RingTheory.PowerSeries.Schroder
import Mathlib.RingTheory.PowerSeries.NoZeroDivisors

open PowerSeries Finset
open D5.S1.Recurrence.Residue.IntegralEGFComposition
open D5.S1.Recurrence.Residue.QuarticEGFFixedPoint (encode eCoeff_encode eCoeff_ext)

namespace A338193

def f : ℕ → ℕ → ℕ
  | _, 0 => 1
  | 0, m + 1 => f 0 m + (m + 1) * f 1 m
  | j + 1, m + 1 => f j (m + 1) + (m + 1) * (f (j + 1) m + f (j + 2) m)
termination_by j m => (m, j)

noncomputable def F (j : ℕ) : PowerSeries ℚ := encode (fun m => f j m)
noncomputable def R : PowerSeries ℚ := largeSchroderSeries.map (Nat.castRingHom ℚ)

private theorem R_eq : R = 1 + X * R + X * R ^ 2 := by
  have h := congrArg (PowerSeries.map (Nat.castRingHom ℚ))
    largeSchroderSeries_eq_one_add_X_mul_largeSchroderSeries_add_X_mul_largeSchroderSeries_sq
  simpa only [map_add, map_one, map_mul, map_X, map_pow, R] using h

private theorem R_zero : constantCoeff R = 1 := by simp [R, ← coeff_zero_eq_constantCoeff, coeff_map]
private theorem F_zero (j : ℕ) : constantCoeff (F j) = 1 := by simp [F, f]
private theorem F_coeff (j m : ℕ) : eCoeff (F j) m = (f j m : ℚ) := eCoeff_encode _ _

private theorem row_eq (j : ℕ) : F (j + 1) = F j + X * (F (j + 1) + F (j + 2)) := by
  apply eCoeff_ext
  intro m
  cases m with
  | zero => simp [eCoeff_zero, F_zero]
  | succ m =>
    have hadd (a b : PowerSeries ℚ) (k : ℕ) : eCoeff (a+b) k = eCoeff a k + eCoeff b k := by
      simp [eCoeff, mul_add]
    rw [hadd, eCoeff_X_mul, hadd, F_coeff, F_coeff, F_coeff, F_coeff, f]
    push_cast
    ring

private theorem model_row (j : ℕ) : F 0 * R ^ (j+1) = F 0 * R ^ j +
    X * (F 0 * R ^ (j+1) + F 0 * R ^ (j+2)) := by
  have h := R_eq
  rw [pow_succ, show j+2 = (j+1)+1 by omega, pow_succ, pow_succ]
  linear_combination F 0 * R ^ j * h

private theorem row_factor (j : ℕ) : F j = F 0 * R ^ j := by
  have h : ∀ m j, coeff m (F j) = coeff m (F 0 * R ^ j) := by
    intro m
    induction m with
    | zero => intro j; simp [coeff_zero_eq_constantCoeff, F_zero, R_zero]
    | succ m ih =>
      intro j
      induction j with
      | zero => simp
      | succ j hj =>
        have hF := congrArg (coeff (m+1)) (row_eq j)
        have hG := congrArg (coeff (m+1)) (model_row j)
        simp only [map_add, coeff_succ_X_mul] at hF hG
        rw [hj, ih, ih] at hF
        exact hF.trans hG.symm
  ext m
  exact h m j

noncomputable def B : PowerSeries ℚ := F 0 * (1 - X * R)
private theorem B_zero : constantCoeff B = 1 := by simp [B, F_zero]
private theorem B_derivative : derivative ℚ B = F 0 := by
  have hb : B = F 0 - X * F 1 := by rw [row_factor 1]; simp only [pow_one, B]; ring
  apply eCoeff_ext
  intro m
  rw [eCoeff_derivative, hb]
  have hsub (a b : PowerSeries ℚ) (k : ℕ) : eCoeff (a-b) k = eCoeff a k - eCoeff b k := by
    simp [eCoeff, mul_sub]
  rw [hsub]
  rw [F_coeff, eCoeff_X_mul, F_coeff, F_coeff, f]
  push_cast
  ring

end A338193
