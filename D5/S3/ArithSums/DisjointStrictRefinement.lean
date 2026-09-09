/- GID: D5/S3/ArithSums/DisjointStrictRefinement
   generality: G
   mirror-B: D5/B/S3/ArithSums/DisjointStrictRefinement
   mirror-E: none(waiver:general-finite-sum-criterion)
   anchors: []
   utility: none
   digest: A disjoint strict refinement is nontrivial exactly when a member is an outside sum. -/

import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Finset.Max
import Mathlib.Tactic

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S3.ArithSums.DisjointStrictRefinement

/-- Each member has one positive strict partition with that member as its sum;
blocks belonging to distinct members are disjoint. Values outside `S` are irrelevant. -/
def IsDisjointStrictRefinement (S : Finset ℕ) (blocks : ℕ → Finset ℕ) : Prop :=
  (∀ s ∈ S, (∀ t ∈ blocks s, 0 < t) ∧ (blocks s).sum id = s) ∧
    ∀ s ∈ S, ∀ r ∈ S, s ≠ r → Disjoint (blocks s) (blocks r)

/-- At least one member receives a block other than its trivial singleton partition. -/
def NontrivialDisjointRefinement (S : Finset ℕ) : Prop :=
  ∃ blocks : ℕ → Finset ℕ, IsDisjointStrictRefinement S blocks ∧
    ∃ s ∈ S, blocks s ≠ {s}

private lemma part_lt_of_nontrivial {T : Finset ℕ} {s t : ℕ}
    (hpos : ∀ u ∈ T, 0 < u) (hsum : T.sum id = s)
    (hne : T ≠ {s}) (ht : t ∈ T) : t < s := by
  have hle : t ≤ s := by
    exact (Finset.single_le_sum (f := id) (fun u _ => Nat.zero_le u) ht).trans hsum.le
  by_contra hnot
  have heq : t = s := by omega
  apply hne
  rw [← heq]
  apply Finset.eq_singleton_iff_unique_mem.mpr
  refine ⟨ht, ?_⟩
  intro u hu
  by_contra hut
  have he := Finset.sum_erase_add T id ht
  have hu' : u ∈ T.erase t := Finset.mem_erase.mpr ⟨hut, hu⟩
  have hule := Finset.single_le_sum (f := id) (fun v _ => Nat.zero_le v) hu'
  have hp := hpos u hu
  dsimp only [id] at he hule
  change (∑ x ∈ T, x) = s at hsum
  omega

end D5.S3.ArithSums.DisjointStrictRefinement
