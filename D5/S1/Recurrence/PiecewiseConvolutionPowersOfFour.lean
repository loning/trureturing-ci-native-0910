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


end D5.S1.Recurrence.PiecewiseConvolutionPowersOfFour
