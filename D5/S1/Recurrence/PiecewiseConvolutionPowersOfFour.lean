/- GID: D5/S1/Recurrence/PiecewiseConvolutionPowersOfFour
   generality: I
   mirror-B: D5/B/S1/Recurrence/PiecewiseConvolutionPowersOfFour
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: The piecewise square and fourth-power convolution is odd at base-four repunits. -/

import D5.S1.Recurrence.ConvolutionRecurrenceOddPowersOfTwo
import Mathlib.RingTheory.PowerSeries.Expand
import Mathlib.Algebra.BigOperators.Intervals
open Finset PowerSeries
open D5.S1.Recurrence.ConvolutionRecurrenceOddPowersOfTwo (convolution_pairing)

namespace D5.S1.Recurrence.PiecewiseConvolutionPowersOfFour

private theorem pow_coeff_congr {R : Type*} [Semiring R] {f g : PowerSeries R}
    (n p : ℕ) (h : ∀ i ≤ n, coeff i f = coeff i g) : coeff n (f^p) = coeff n (g^p) := by
  induction p generalizing n with
  | zero => rfl
  | succ p ih =>
    rw [pow_succ, pow_succ, coeff_mul, coeff_mul]
    apply sum_congr rfl
    intro x hx
    have hb := Finset.mem_antidiagonal.mp hx
    rw [ih x.1 (fun i hi => h i (by omega)), h x.2 (by omega)]

noncomputable def seq (n : ℕ) : ℕ :=
  Nat.lt_wfRel.wf.fix (fun n rec => if n = 0 then 1 else
    coeff (n-1) ((mk (fun i => if hi : i < n then rec i hi else 0) : PowerSeries ℕ) ^
      (if Even n then 2 else 4))) n

private theorem seq_eq (n : ℕ) : seq n = if n=0 then 1 else
    coeff (n-1) ((mk (fun i => if i < n then seq i else 0) : PowerSeries ℕ) ^
      (if Even n then 2 else 4)) := by
  exact Nat.lt_wfRel.wf.fix_eq _ n
noncomputable def series : PowerSeries ℕ := mk seq

theorem seq_zero : seq 0 = 1 := by rw [seq_eq]; simp

theorem seq_recurrence {n : ℕ} (hn : 0<n) :
    seq n = coeff (n-1) (series ^ (if Even n then 2 else 4)) := by
  rw [seq_eq, if_neg (by omega)]
  apply pow_coeff_congr
  intro i hi
  simp only [series, coeff_mk, if_pos (by omega : i<n)]


private theorem square_even_coeff (f : PowerSeries (ZMod 2))
    (hf : coeff 0 f = 0) {m : ℕ} (hm : 1 ≤ m) :
    coeff (2*m) (f^2) = coeff m f ^ 2 := by
  rw [pow_two, coeff_mul, Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk,
    sum_range_succ]
  rw [sum_range_eq_add_Ico (fun k => coeff k f * coeff (2*m-k) f)
    (by omega : 0 < 2*m)]
  simp only [hf, zero_mul, Nat.sub_self, mul_zero, zero_add, add_zero]
  have he : Ico 1 (2*m) = Icc 1 (2*m-1) := by ext k; simp; omega
  rw [he]
  exact convolution_pairing (fun k => coeff k f) hm

private theorem square_odd_coeff (f : PowerSeries (ZMod 2)) (j : ℕ) :
    coeff (2*j+1) (f^2) = 0 := by
  let g : PowerSeries (ZMod 2) := X * f.expand 2 (by decide)
  have hg0 : coeff 0 g = 0 := by simp [g, coeff_zero_eq_constantCoeff]
  have hgmid : coeff (2*(j+1)) g = 0 := by
    dsimp [g]
    rw [← pow_one (X : PowerSeries (ZMod 2)), coeff_X_pow_mul', if_pos (by omega)]
    apply coeff_expand_of_not_dvd
    omega
  have h := square_even_coeff g hg0 (m := 2*(j+1)) (by omega)
  rw [hgmid, zero_pow (by decide : 2 ≠ 0)] at h
  have he : g^2 = X^2 * (f^2).expand 2 (by decide) := by
    dsimp [g]
    rw [mul_pow, map_pow]
  rw [he, coeff_X_pow_mul', if_pos (by omega),
    show 2*(2*(j+1))-2 = 2*(2*j+1) by omega, coeff_expand_mul] at h
  exact h

private noncomputable def binary : PowerSeries (ZMod 2) :=
  series.map (Nat.castRingHom (ZMod 2))

private theorem binary_coeff (n : ℕ) : coeff n binary = (seq n : ZMod 2) := by
  simp [binary, series, coeff_map]

private theorem binary_recurrence {n : ℕ} (hn : 0<n) :
    (seq n : ZMod 2) = coeff (n-1) (binary ^ (if Even n then 2 else 4)) := by
  have h := congrArg (Nat.castRingHom (ZMod 2)) (seq_recurrence hn)
  rw [binary, ← map_pow, coeff_map]
  exact h

/-- Every positive even index has an even sequence value. -/
theorem seq_even_index_zero (j : ℕ) : (seq (2*j+2) : ZMod 2) = 0 := by
  rw [binary_recurrence (by omega), if_pos (show Even (2*j+2) from ⟨j+1, by omega⟩),
    show 2*j+2-1 = 2*j+1 by omega]
  exact square_odd_coeff binary j

#print axioms seq_even_index_zero

end D5.S1.Recurrence.PiecewiseConvolutionPowersOfFour
