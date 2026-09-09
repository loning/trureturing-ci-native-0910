/- GID: D5/S3/Arith/Paths/MonotoneOnePaths
   generality: I
   mirror-B: D5/B/S3/Arith/Paths/MonotoneOnePaths
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: The mean number of all-one monotone paths in a uniform binary square matrix. -/

import Mathlib.Data.Finset.Powerset
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Data.Rat.Cast.Order
import Mathlib.Tactic

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S3.Arith.Paths.MonotoneOnePaths

open Finset

/-- A path across a (k+1)-square, encoded by the positions of its k east steps. -/
abbrev Path (k : ℕ) := ↥((range (2 * k)).powersetCard k)

private theorem path_subset {k : ℕ} (p : Path k) : p.val ⊆ range (2 * k) :=
  (mem_powersetCard.mp p.property).1

private theorem path_card {k : ℕ} (p : Path k) : p.val.card = k :=
  (mem_powersetCard.mp p.property).2

/-- At time t, count east and south steps in the prefix of length t. -/
def pathCell {k : ℕ} (p : Path k) (t : Fin (2 * k + 1)) : Fin (k + 1) × Fin (k + 1) :=
  (⟨(range t.val ∩ p.val).card, by
      have := card_le_card (inter_subset_right : range t.val ∩ p.val ⊆ p.val)
      rw [path_card p] at this
      omega⟩,
   ⟨(range t.val \ p.val).card, by
      have ht : range t.val ⊆ range (2 * k) := range_mono (by omega)
      have := card_le_card (sdiff_subset_sdiff_left p.val ht)
      rw [card_sdiff_of_subset (path_subset p), card_range, path_card p] at this
      omega⟩)

private theorem pathCell_rank {k : ℕ} (p : Path k) (t : Fin (2 * k + 1)) :
    (pathCell p t).1.val + (pathCell p t).2.val = t.val := by
  simpa [pathCell] using card_inter_add_card_sdiff (range t.val) p.val

private theorem pathCell_injective {k : ℕ} (p : Path k) :
    Function.Injective (pathCell p) := by
  intro t u h
  apply Fin.ext
  rw [← pathCell_rank p t, ← pathCell_rank p u, h]

/-- The set of cells actually visited by the path, including both endpoints. -/
def pathCells {k : ℕ} (p : Path k) : Finset (Fin (k + 1) × Fin (k + 1)) :=
  univ.image (pathCell p)

private theorem pathCells_card {k : ℕ} (p : Path k) : (pathCells p).card = 2 * k + 1 := by
  rw [pathCells, card_image_of_injective _ (pathCell_injective p)]
  simp

/-- Count precisely the east/south paths whose visited cells are all true.
The empty matrix branch is outside the positive-size mean theorem. -/
def pathCount : {n : ℕ} → (Fin n × Fin n → Bool) → ℕ
  | 0, _ => 0
  | k + 1, M => (univ.filter fun p : Path k => ∀ c ∈ pathCells p, M c = true).card

end D5.S3.Arith.Paths.MonotoneOnePaths
