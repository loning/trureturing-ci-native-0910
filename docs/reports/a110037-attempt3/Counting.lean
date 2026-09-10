import Mathlib

namespace A110037Counting
open Finset

def nonsquashingDistinctPartitions (n : ℕ) : Finset (Finset ℕ) :=
  ((Icc 1 n).powerset).filter fun s =>
    s.sum id = n ∧ ∀ p ∈ s, (s.filter (fun q => q < p)).sum id ≤ p

private theorem mem_parts {s : Finset ℕ} {n : ℕ} :
    s ∈ nonsquashingDistinctPartitions n ↔
      (∀ p ∈ s, 0 < p) ∧ s.sum id = n ∧
      ∀ p ∈ s, (s.filter (fun q => q < p)).sum id ≤ p := by
  simp only [nonsquashingDistinctPartitions, mem_filter, mem_powerset]
  constructor
  · rintro ⟨hb, hn, hns⟩
    exact ⟨fun p hp => (mem_Icc.mp (hb hp)).1, hn, hns⟩
  · rintro ⟨hp, hn, hns⟩
    refine ⟨?_, hn, hns⟩
    intro p hps
    exact mem_Icc.mpr ⟨hp p hps, hn ▸ single_le_sum (f := id) (fun _ _ => Nat.zero_le _) hps⟩

private theorem part_le_sum {s : Finset ℕ} {p : ℕ} (hp : p ∈ s) : p ≤ s.sum id :=
  single_le_sum (f := id) (fun _ _ => Nat.zero_le _) hp

private theorem subset_parts {s t : Finset ℕ} {n : ℕ}
    (hs : s ∈ nonsquashingDistinctPartitions n) (ht : t ⊆ s) :
    t ∈ nonsquashingDistinctPartitions (t.sum id) := by
  obtain ⟨hpos, _, hns⟩ := mem_parts.mp hs
  apply mem_parts.mpr
  refine ⟨fun p hp => hpos p (ht hp), rfl, ?_⟩
  intro p hp
  exact (sum_le_sum_of_subset (filter_subset_filter _ ht)).trans (hns p (ht hp))

private theorem insert_parts {s : Finset ℕ} {k p : ℕ}
    (hs : s ∈ nonsquashingDistinctPartitions k) (hp : 0 < p)
    (hk : k ≤ p) (hne : p ∉ s) :
    insert p s ∈ nonsquashingDistinctPartitions (p + k) := by
  obtain ⟨hpos, hsum, hns⟩ := mem_parts.mp hs
  have hlt : ∀ q ∈ s, q < p := by
    intro q hq
    have hqk := part_le_sum hq
    rw [hsum] at hqk
    exact lt_of_le_of_ne (hqk.trans hk) (by rintro rfl; exact hne hq)
  apply mem_parts.mpr
  refine ⟨?_, by rw [sum_insert hne, hsum]; rfl, ?_⟩
  · intro q hq
    rcases mem_insert.mp hq with rfl | hq
    · exact hp
    · exact hpos q hq
  · intro q hq
    rcases mem_insert.mp hq with heq | hqs
    · subst q
      have he : (insert p s).filter (fun q => q < p) = s := by
        ext q
        simp only [mem_filter, mem_insert]
        exact ⟨fun h => h.1.resolve_left (by omega), fun h => ⟨Or.inr h, hlt q h⟩⟩
      rw [he, hsum]
      exact hk
    · have he : (insert p s).filter (fun r => r < q) = s.filter (fun r => r < q) := by
        ext r
        simp only [mem_filter, mem_insert]
        constructor
        · rintro ⟨rfl | hr, hrq⟩
          · have := hlt q hqs
            omega
          · exact ⟨hr, hrq⟩
        · rintro ⟨hr, hrq⟩
          exact ⟨Or.inr hr, hrq⟩
      rw [he]
      exact hns q hqs

private def cumulative (m : ℕ) : Finset (Finset ℕ) :=
  (range (m + 1)).biUnion nonsquashingDistinctPartitions

private theorem mem_cumulative {s : Finset ℕ} {m : ℕ} :
    s ∈ cumulative m ↔
      s ∈ nonsquashingDistinctPartitions (s.sum id) ∧ s.sum id ≤ m := by
  simp only [cumulative, mem_biUnion, mem_range]
  constructor
  · rintro ⟨k, hk, hs⟩
    have he := (mem_parts.mp hs).2.1
    exact ⟨he.symm ▸ hs, by omega⟩
  · rintro ⟨hs, hm⟩
    exact ⟨s.sum id, by omega, hs⟩

private theorem card_cumulative (m : ℕ) :
    (cumulative m).card = ∑ k ∈ range (m + 1), (nonsquashingDistinctPartitions k).card := by
  apply card_biUnion
  intro i _ j _ hij
  apply disjoint_left.mpr
  intro s hsi hsj
  exact hij ((mem_parts.mp hsi).2.1.symm.trans (mem_parts.mp hsj).2.1)

private theorem erase_max_parts {s : Finset ℕ} {n : ℕ}
    (hs : s ∈ nonsquashingDistinctPartitions n) (hn : 0 < n) :
    ∃ t ∈ cumulative (n / 2), n - t.sum id ∉ t ∧ insert (n - t.sum id) t = s := by
  have hne : s.Nonempty := by
    by_contra h
    have he : s = ∅ := not_nonempty_iff_eq_empty.mp h
    have hsum := (mem_parts.mp hs).2.1
    simp [he] at hsum
    omega
  let p := s.max' hne
  have hp : p ∈ s := s.max'_mem hne
  let t := s.erase p
  have hfilter : s.filter (fun q => q < p) = t := by
    ext q
    simp only [mem_filter, t, mem_erase]
    constructor
    · rintro ⟨hq, hqp⟩
      exact ⟨by omega, hq⟩
    · rintro ⟨hqp, hq⟩
      exact ⟨hq, lt_of_le_of_ne (s.le_max' q hq) hqp⟩
  have ht_le : t.sum id ≤ p := by
    rw [← hfilter]
    exact (mem_parts.mp hs).2.2 p hp
  have hsum : t.sum id + p = n := by
    change (s.erase p).sum id + p = n
    exact (sum_erase_add s id hp).trans (mem_parts.mp hs).2.1
  have hep : n - t.sum id = p := by omega
  refine ⟨t, mem_cumulative.mpr ⟨subset_parts hs (erase_subset _ _), by omega⟩, ?_, ?_⟩
  · rw [hep]
    exact notMem_erase _ _
  · rw [hep]
    exact insert_erase hp

#print axioms erase_max_parts
end A110037Counting
