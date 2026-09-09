import Mathlib

open Polynomial

namespace Triage75

noncomputable def weight (d k : Nat) : Real :=
  (d.descFactorial k : Real) / (d : Real) ^ k

noncomputable def model (a : Nat -> Real) (d : Nat) : Polynomial Real :=
  (Finset.range (d + 1)).sum (fun k => Polynomial.monomial k (weight d k * a k))

noncomputable def recover (n d : Nat) (p : Polynomial Real) : Polynomial Real :=
  (Finset.range (n + 1)).sum (fun k => Polynomial.monomial k (weight n k / weight d k * p.coeff k))

theorem readback (a : Nat -> Real) (n d : Nat) (hd : 0 < d) (hnd : n <= d) :
    recover n d (model a d) = model a n := by
  have hcoeff (k : Nat) (hk : k <= d) : (model a d).coeff k = weight d k * a k := by
    simp [model, Polynomial.finsetSum_coeff, Polynomial.coeff_monomial,
      Finset.mem_range, Nat.lt_succ_iff, hk]
  unfold recover
  apply Finset.sum_congr rfl
  intro k hk
  have hkd : k <= d := (Nat.le_of_lt_succ (Finset.mem_range.mp hk)).trans hnd
  have hpos : (0 : Real) < (d.descFactorial k : Real) := by
    exact_mod_cast (Nat.descFactorial_pos.mpr hkd)
  have hdReal : Ne (d : Real) 0 := by exact_mod_cast (Nat.ne_of_gt hd)
  have hw : Ne (weight d k) 0 := div_ne_zero (ne_of_gt hpos) (pow_ne_zero _ hdReal)
  rw [hcoeff k hkd]
  congr 1
  field_simp [hw]

#print axioms readback

end Triage75
