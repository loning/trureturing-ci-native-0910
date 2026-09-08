/- GID: D5/S1/Recurrence/Parity/SubsetSumModSixDoubling
   generality: I
   mirror-B: D5/B/S1/Recurrence/Parity/SubsetSumModSixDoubling
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: Subset sums modulo six satisfy the doubling conjecture of OEIS A068012. -/

import Mathlib

namespace D5.S1.Recurrence.Parity.SubsetSumModSixDoubling

open Finset

/-- The number of subsets of `{1, ..., n}` with the given sum modulo six. -/
def C (n : ℕ) (r : ZMod 6) : ℕ :=
  ((Icc 1 n).powerset.filter fun (s : Finset ℕ) => (∑ x ∈ s, (x : ZMod 6)) = r).card

/-- OEIS A068012, including the empty subset and the index zero. -/
def a (n : ℕ) : ℕ := C n 0

private def countIn (s : Finset ℕ) (r : ZMod 6) : ℕ :=
  (s.powerset.filter fun (t : Finset ℕ) => (∑ x ∈ t, (x : ZMod 6)) = r).card

private theorem count_insert (s : Finset ℕ) (x : ℕ) (hx : x ∉ s) (r : ZMod 6) :
    countIn (insert x s) r = countIn s r + countIn s (r - x) := by
  unfold countIn
  simp only [card_eq_sum_ones, sum_filter]
  rw [sum_powerset_insert hx]
  congr 1
  apply sum_congr rfl
  intro t ht
  have hxt : x ∉ t := fun h => hx (mem_powerset.mp ht h)
  rw [sum_insert hxt]
  simp only [eq_sub_iff_add_eq, add_comm]

private theorem interval_succ (n : ℕ) : Icc 1 (n + 1) = insert (n + 1) (Icc 1 n) := by
  ext x
  simp only [mem_Icc, mem_insert]
  omega

/-- Adding the last element splits subsets into the two possible membership cases. -/
theorem count_succ (n : ℕ) (r : ZMod 6) :
    C (n + 1) r = C n r + C n (r - (n + 1 : ℕ)) := by
  change countIn (Icc 1 (n + 1)) r = _
  rw [interval_succ, count_insert _ _ (by simp)]
  rfl

/-- Once element three is available, residues separated by three have equal counts. -/
theorem count_three_periodic (m : ℕ) (hm : 3 ≤ m) (r : ZMod 6) :
    C m r = C m (r + 3) := by
  have hthree : 3 ∈ Icc 1 m := mem_Icc.mpr ⟨by omega, hm⟩
  have split (t : ZMod 6) := count_insert ((Icc 1 m).erase 3) 3 (by simp) t
  simp only [insert_erase hthree] at split
  change countIn (Icc 1 m) r = countIn (Icc 1 m) (r + 3)
  rw [split r, split (r + 3)]
  have hr : r - 3 = r + 3 := by
    rw [sub_eq_add_neg, show -(3 : ZMod 6) = 3 by decide]
  simp only [Nat.cast_ofNat, add_sub_cancel_right, hr, add_comm]

#print axioms count_succ
#print axioms count_three_periodic

end D5.S1.Recurrence.Parity.SubsetSumModSixDoubling
