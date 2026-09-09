/- GID: D5/S1/Words/Compositions/TrimmedAlternatingPartitions
   generality: G
   mirror-B: D5/B/S1/Words/Compositions/TrimmedAlternatingPartitions
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: Trimmed alternating sums are distinct exactly for partitions with strict tails. -/

import Mathlib.Combinatorics.Enumerative.Partition.Basic
import Mathlib.Data.Fintype.Card

/-!
# Trimmed alternating sums of partitions

The accumulator is an integer: natural subtraction would change the problem.
The initial accumulator is excluded from the output. Ordinary partition parts
are sorted decreasingly; only the tail is required to decrease strictly.
-/

namespace D5.S1.Words.Compositions.TrimmedAlternatingPartitions

/-- The recurrence `s_j = q_j - s_(j-1)`, excluding the initial value. -/
def sumsFrom (z : ℤ) : List ℕ → List ℤ
  | [] => []
  | a :: q => ((a : ℤ) - z) :: sumsFrom ((a : ℤ) - z) q

/-- Trimmed zero-based alternating partial sums, computed in the integers. -/
def trimmedSums (q : List ℕ) : List ℤ := sumsFrom 0 q

-- Two steps lower the nonpositive endpoint; the positive endpoint stays below B-z.
private theorem strict_bounds (q : List ℕ) (hs : q.Pairwise (· > ·))
    (hp : ∀ a ∈ q, 0 < a) (z B : ℤ) (hz : z ≤ 0)
    (hb : ∀ a ∈ q, (a : ℤ) < B) :
    ∀ x ∈ sumsFrom z q, x < z ∨ (0 < x ∧ x < B - z) := by
  induction q using List.twoStepInduction generalizing z B with
  | nil => simp [sumsFrom]
  | singleton a =>
    have ha := hp a (by simp)
    have haB := hb a (by simp)
    simp only [sumsFrom, List.mem_cons, List.not_mem_nil, or_false]
    intro x hx
    subst x
    right
    constructor <;> omega
  | cons_cons a b q ih =>
    have ha := hp a (by simp)
    have haB := hb a (by simp)
    have hab : b < a := (List.pairwise_cons.mp hs).1 b (by simp)
    have ht := ih hs.of_cons.of_cons (fun c hc => hp c (by simp [hc]))
      ((b : ℤ) - ((a : ℤ) - z)) (b : ℤ) (by omega)
      (fun c hc => by
        have := (List.pairwise_cons.mp hs.of_cons).1 c hc
        omega)
    simp only [sumsFrom, List.mem_cons]
    intro x hx
    rcases hx with rfl | rfl | hx
    · right; constructor <;> omega
    · left; omega
    · rcases ht x hx with h | ⟨hpos, hbound⟩
      · left; omega
      · right; constructor <;> omega

private theorem start_not_mem (q : List ℕ) (hs : q.Pairwise (· > ·))
    (hp : ∀ a ∈ q, 0 < a) (z : ℤ)
    (hz : z ≤ 0 ∨ ∀ a ∈ q, (a : ℤ) ≤ z) : z ∉ sumsFrom z q := by
  cases q with
  | nil => simp [sumsFrom]
  | cons a q =>
    have ha := hp a (by simp)
    rcases hz with hz | hz
    · have hb : ∀ c ∈ a :: q, (c : ℤ) < (a : ℤ) + 1 := by
        intro c hc
        rcases List.mem_cons.mp hc with rfl | hc
        · omega
        · have := (List.pairwise_cons.mp hs).1 c hc
          omega
      intro h
      rcases strict_bounds (a :: q) hs hp z ((a : ℤ) + 1) hz hb z h with h | h
      · omega
      · omega
    · have haz := hz a (by simp)
      simp only [sumsFrom, List.mem_cons, not_or]
      constructor
      · omega
      · intro h
        have ht := strict_bounds q hs.of_cons
          (fun c hc => hp c (by simp [hc])) ((a : ℤ) - z) a (by omega)
          (fun c hc => by
            have := (List.pairwise_cons.mp hs).1 c hc
            omega) z h
        rcases ht with ht | ht <;> omega

private theorem nodup_from_strict_tail (q : List ℕ) (hs : q.Pairwise (· ≥ ·))
    (hp : ∀ a ∈ q, 0 < a) (ht : q.tail.Pairwise (· > ·)) (z : ℤ)
    (hz : z ≤ 0 ∨ ∀ a ∈ q, (a : ℤ) ≤ z) : (sumsFrom z q).Nodup := by
  induction q generalizing z with
  | nil => simp [sumsFrom]
  | cons a q ih =>
    have hq : q.Pairwise (· > ·) := ht
    have hpq : ∀ b ∈ q, 0 < b := fun b hb => hp b (by simp [hb])
    have hz' : (a : ℤ) - z ≤ 0 ∨ ∀ b ∈ q, (b : ℤ) ≤ (a : ℤ) - z := by
      rcases hz with hz | hz
      · right
        intro b hb
        have := (List.pairwise_cons.mp hs).1 b hb
        omega
      · left
        have := hz a (by simp)
        omega
    exact List.nodup_cons.mpr ⟨start_not_mem q hq hpq _ hz',
      ih hs.of_cons hpq hq.tail _ hz'⟩

private theorem strict_tail_from_nodup (q : List ℕ) (hs : q.Pairwise (· ≥ ·))
    (z : ℤ) (hn : (sumsFrom z q).Nodup) : q.tail.Pairwise (· > ·) := by
  induction q generalizing z with
  | nil => simp
  | cons a q ih =>
    have hq := ih hs.of_cons ((a : ℤ) - z) hn.of_cons
    cases q with
    | nil => simp
    | cons b q =>
      cases q with
      | nil => simp
      | cons c q =>
        have hbc : c ≤ b := (List.pairwise_cons.mp hs.of_cons).1 c (by simp)
        have hne : b ≠ c := by
          intro he
          have hf := (List.nodup_cons.mp hn).1
          apply hf
          simp only [sumsFrom, List.mem_cons]
          right
          left
          omega
        change (b :: c :: q).Pairwise (· > ·)
        rw [List.pairwise_cons_cons_iff_of_trans]
        exact ⟨by omega, hq⟩

/-- Distinct trimmed alternating sums are equivalent to strict decrease of the tail. -/
theorem trimmedSums_nodup_iff_strict_tail (q : List ℕ)
    (hs : q.Pairwise (· ≥ ·)) (hp : ∀ a ∈ q, 0 < a) :
    (trimmedSums q).Nodup ↔ q.tail.Pairwise (· > ·) := by
  exact ⟨strict_tail_from_nodup q hs 0,
    fun ht => nodup_from_strict_tail q hs hp ht 0 (Or.inl le_rfl)⟩

#print axioms trimmedSums_nodup_iff_strict_tail

end D5.S1.Words.Compositions.TrimmedAlternatingPartitions
