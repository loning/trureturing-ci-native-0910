/- GID: D5/S1/Words/ParityCode/OddTopWeight
   generality: G
   mirror-B: D5/B/S1/Words/ParityCode/OddTopWeight
   mirror-E: none(waiver:unbounded-combinatorial-proof)
   anchors: []
   utility: none
   digest: Odd square binary matrices of top even row and column weight are counted by factorial. -/

import Mathlib.Data.Fintype.Perm
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.SetTheory.Cardinal.Finite
import Mathlib.Tactic

namespace D5.S1.Words.ParityCode.OddTopWeight

open scoped BigOperators

/-- The number of ones in a binary row. -/
def ones {n : ℕ} (r : Fin n → Bool) : ℕ :=
  ∑ j, if r j then 1 else 0

/-- Every row and every column has an even number of ones. -/
def EvenRowsCols {n : ℕ} (M : Fin n → Fin n → Bool) : Prop :=
  (∀ i, Even (ones (M i))) ∧ (∀ j, Even (ones (fun i => M i j)))

/-- The total number of ones, summed over all matrix entries. -/
def weight {n : ℕ} (M : Fin n → Fin n → Bool) : ℕ :=
  ∑ i, ones (M i)

private theorem ones_add_zeros {n : ℕ} (r : Fin n → Bool) :
    ones r + (Finset.univ.filter fun j => r j = false).card = n := by
  classical
  have hz : (∑ j : Fin n, if r j = false then 1 else 0 : ℕ) =
      (Finset.univ.filter fun j => r j = false).card := by
    simp
  rw [ones, ← hz, ← Finset.sum_add_distrib]
  have h (j : Fin n) : (if r j then 1 else 0) + (if r j = false then 1 else 0) = 1 := by
    cases r j <;> rfl
  simp_rw [h]
  simp

private theorem row_bound {n : ℕ} (hn : Odd n) (r : Fin n → Bool)
    (hr : Even (ones r)) : ones r ≤ n - 1 := by
  have h := ones_add_zeros r
  have hne : ones r ≠ n := fun heq => (Nat.not_even_iff_odd.mpr hn) (heq ▸ hr)
  omega

private theorem rows_saturated {n : ℕ} (hn : Odd n) (M : Fin n → Fin n → Bool)
    (hr : ∀ i, Even (ones (M i))) (hw : weight M = n * (n - 1)) :
    ∀ i, ones (M i) = n - 1 := by
  have hs : (∑ i, ones (M i)) = ∑ _ : Fin n, (n - 1) := by simpa [weight] using hw
  exact fun i => (Finset.sum_eq_sum_iff_of_le (fun j _ => row_bound hn (M j) (hr j))).mp
    hs i (Finset.mem_univ i)

private theorem row_unique_zero {n : ℕ} (hn : Odd n) (M : Fin n → Fin n → Bool)
    (hr : ∀ i, Even (ones (M i))) (hw : weight M = n * (n - 1)) (i : Fin n) :
    ∃! j, M i j = false := by
  have hc := ones_add_zeros (M i)
  rw [rows_saturated hn M hr hw i] at hc
  have hnpos : 0 < n := hn.pos
  have hz : (Finset.univ.filter fun j => M i j = false).card = 1 := by omega
  simpa using Finset.card_eq_one_iff_existsUnique.mp hz

end D5.S1.Words.ParityCode.OddTopWeight
