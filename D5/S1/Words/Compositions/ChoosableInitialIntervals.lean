/- GID: D5/S1/Words/Compositions/ChoosableInitialIntervals
   generality: G
   mirror-B: D5/B/S1/Words/Compositions/ChoosableInitialIntervals
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: Initial intervals of increasing parts admit distinct representatives exactly above the diagonal. -/

import Mathlib.Combinatorics.Enumerative.Partition.Basic
import Mathlib.Data.Fintype.Card

/-!
# Choosable initial intervals

OEIS A388711 compares choosable initial intervals with superdiagonal reversed
partitions. Reversed parts are weakly increasing. Lean indices are zero-based,
so the diagonal bound is `i + 1`. The list result also handles zero parts and
the empty list; Mathlib partitions themselves have positive parts.
-/

namespace D5.S1.Words.Compositions.ChoosableInitialIntervals

/-- Distinct positive representatives, each bounded by its corresponding part. -/
def ChoosableInitial (l : List ℕ) : Prop :=
  ∃ f : Fin l.length → ℕ, Function.Injective f ∧ ∀ i, 1 ≤ f i ∧ f i ≤ l.get i

/-- The one-based diagonal bound, expressed using zero-based list indices. -/
def Superdiagonal (l : List ℕ) : Prop := ∀ i : Fin l.length, (i : ℕ) + 1 ≤ l.get i

-- The first i+1 distinct representatives fit into the interval ending at l[i].
private theorem prefix_capacity (l : List ℕ) (hl : l.Pairwise (· ≤ ·))
    (f : Fin l.length → ℕ) (hf : Function.Injective f)
    (hb : ∀ i, 1 ≤ f i ∧ f i ≤ l.get i) (i : Fin l.length) :
    (i : ℕ) + 1 ≤ l.get i := by
  let e : Fin (i.val + 1) → Fin l.length :=
    fun j => ⟨j.val, lt_of_lt_of_le j.isLt (Nat.succ_le_of_lt i.isLt)⟩
  let g : Fin (i.val + 1) → Fin (l.get i) := fun j =>
    ⟨f (e j) - 1, by
      have hj : e j ≤ i := by show j.val ≤ i.val; omega
      have hm := hl.sortedLE.monotone_get hj
      have hp := hb (e j)
      omega⟩
  have hg : Function.Injective g := by
    intro a b hab
    have hv := congrArg Fin.val hab
    have ha := (hb (e a)).1
    have hb' := (hb (e b)).1
    have he : e a = e b := hf (by change f (e a) - 1 = f (e b) - 1 at hv; omega)
    exact Fin.ext (congrArg (fun x : Fin l.length => x.val) he)
  simpa only [Fintype.card_fin] using Fintype.card_le_of_injective g hg

/-- Increasing initial intervals are choosable exactly when their parts are superdiagonal. -/
theorem choosableInitial_iff_superdiagonal (l : List ℕ) (hl : l.Pairwise (· ≤ ·)) :
    ChoosableInitial l ↔ Superdiagonal l := by
  constructor
  · rintro ⟨f, hf, hb⟩ i
    exact prefix_capacity l hl f hf hb i
  · intro h
    refine ⟨fun i => i.val + 1, ?_, fun i => ⟨Nat.succ_pos _, h i⟩⟩
    intro i j hij
    change i.val + 1 = j.val + 1 at hij
    exact Fin.ext (by omega)

open scoped Classical in
/-- A388711: the two predicates count the same partitions of n into k positive parts. -/
theorem card_choosable_eq_superdiagonal (n k : ℕ) :
    ((Finset.univ : Finset (Nat.Partition n)).filter
      (fun p => p.parts.card = k ∧ ChoosableInitial (p.parts.sort (· ≤ ·)))).card =
    ((Finset.univ : Finset (Nat.Partition n)).filter
      (fun p => p.parts.card = k ∧ Superdiagonal (p.parts.sort (· ≤ ·)))).card := by
  congr 1
  apply Finset.filter_congr
  intro p _
  exact and_congr_right fun _ => choosableInitial_iff_superdiagonal _
    (Multiset.pairwise_sort p.parts (· ≤ ·))

#print axioms choosableInitial_iff_superdiagonal
#print axioms card_choosable_eq_superdiagonal

end D5.S1.Words.Compositions.ChoosableInitialIntervals
