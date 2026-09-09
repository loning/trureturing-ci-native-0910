/- GID: D5/S1/Words/Compositions/ZeroPrependedFirstSumsOddParts
   generality: G
   mirror-B: D5/B/S1/Words/Compositions/ZeroPrependedFirstSumsOddParts
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: Zero-prepended first sums of increasing partitions correspond to odd parts. -/

import D5.S1.Words.Compositions.FirstSumsPartitionCharacterization
import Mathlib.Combinatorics.Enumerative.Partition.Glaisher
import Mathlib.Combinatorics.Young.YoungDiagram

/-!
# Zero-prepended first sums and odd parts

The first-sums convention is the existing adjacent-sums definition. A positive
increasing preimage corresponds to the odd parts obtained by replacing each
column height h of its Ferrers diagram by 2*h-1. No zero rows are admitted.
-/

namespace D5.S1.Words.Compositions.ZeroPrependedFirstSumsOddParts

open FirstSumsPartitionCharacterization

/-- Adjacent sums after prepending zero to an increasing positive list. -/
def IsZeroPrependedFirstSums (y : List ℕ) : Prop :=
  ∃ s : List ℕ, s.Pairwise (· ≤ ·) ∧ (∀ x ∈ s, 0 < x) ∧ firstSums (0 :: s) = y

private theorem firstSums_injective (a : ℕ) :
    Function.Injective (fun s : List ℕ => firstSums (a :: s)) := by
  intro s t
  induction s generalizing a t with
  | nil => cases t <;> simp [firstSums]
  | cons b s ih =>
    cases t with
    | nil => simp [firstSums]
    | cons c t =>
      intro h
      have h' : a + b = a + c ∧ firstSums (b :: s) = firstSums (c :: t) :=
        List.cons.inj h
      have hbc : b = c := by omega
      subst c
      exact congrArg (List.cons b) (ih b h'.2)

private theorem firstSums_pos (a : ℕ) (s : List ℕ) (hs : ∀ x ∈ s, 0 < x) :
    ∀ x ∈ firstSums (a :: s), 0 < x := by
  induction s generalizing a with
  | nil => simp [firstSums]
  | cons b s ih =>
    intro x hx
    change x ∈ (a + b) :: firstSums (b :: s) at hx
    rcases List.mem_cons.mp hx with rfl | hx
    · have := hs b (by simp); omega
    · exact ih b (fun z hz => hs z (by simp [hz])) x hx

private theorem firstSums_sorted (a : ℕ) (s : List ℕ)
    (hs : (a :: s).Pairwise (· ≤ ·)) : (firstSums (a :: s)).Pairwise (· ≤ ·) := by
  induction s generalizing a with
  | nil => simp [firstSums]
  | cons b s ih =>
    change ((a + b) :: firstSums (b :: s)).Pairwise (· ≤ ·)
    cases s with
    | nil => simp [firstSums]
    | cons c s =>
      have hac : a ≤ c := (List.pairwise_cons.mp hs).1 c (by simp)
      have ht := ih b hs.of_cons
      change ((a + b) :: (b + c) :: firstSums (c :: s)).Pairwise (· ≤ ·)
      refine List.pairwise_cons.mpr ⟨?_, ht⟩
      intro x hx
      rcases List.mem_cons.mp hx with rfl | hx
      · omega
      · have hbx := (List.pairwise_cons.mp ht).1 x hx
        change b + c ≤ x at hbx
        omega

private theorem firstSums_sum (a : ℕ) (s : List ℕ) :
    (firstSums (a :: s)).sum + s.getLastD a = a + 2 * s.sum := by
  induction s generalizing a with
  | nil => simp [firstSums]
  | cons b s ih =>
    have h := ih b
    cases s with
    | nil => simp [firstSums]; omega
    | cons c s =>
      change a + b + (firstSums (b :: c :: s)).sum + (b :: c :: s).getLastD a =
        a + 2 * (b + (c :: s).sum)
      simpa only [List.getLastD_cons] using (by omega :
        a + b + (firstSums (b :: c :: s)).sum + (c :: s).getLastD b =
          a + 2 * (b + (c :: s).sum))

private theorem cellsOfRowLens_card (l : List ℕ) :
    (YoungDiagram.cellsOfRowLens l).card = l.sum := by
  induction l with
  | nil => simp [YoungDiagram.cellsOfRowLens]
  | cons a l ih =>
    rw [YoungDiagram.cellsOfRowLens, Finset.card_union_of_disjoint]
    · simpa using congrArg (a + ·) ih
    · apply Finset.disjoint_left.mpr
      intro x hx hy
      obtain ⟨y, _, rfl⟩ := Finset.mem_map.mp hy
      simpa using (Finset.mem_product.mp hx).1

private theorem rowLens_sum (d : YoungDiagram) : d.rowLens.sum = d.cells.card := by
  have h := cellsOfRowLens_card d.rowLens
  change (YoungDiagram.ofRowLens d.rowLens d.rowLens_sorted).cells.card = _ at h
  rw [YoungDiagram.ofRowLens_to_rowLens_eq_self] at h
  exact h.symm

private theorem transpose_sum (d : YoungDiagram) : d.transpose.rowLens.sum = d.rowLens.sum := by
  rw [rowLens_sum, rowLens_sum]
  simp [YoungDiagram.transpose]

end D5.S1.Words.Compositions.ZeroPrependedFirstSumsOddParts
