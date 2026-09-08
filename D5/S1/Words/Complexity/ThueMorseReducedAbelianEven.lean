/- GID: D5/S1/Words/Complexity/ThueMorseReducedAbelianEven
   generality: G
   mirror-B: D5/B/S1/Words/Complexity/ThueMorseReducedAbelianEven
   mirror-E: none(waiver:pure-word-combinatorics)
   anchors: []
   utility: none
   digest: All-start alternation extrema and even reduced abelian complexity. -/

import D5.S1.Words.Complexity.ThueMorseReducedAbelianOdd
import Mathlib.Order.Lattice.Nat

namespace D5.S1.Words.Complexity

open private transition alternations alternations_le runs runs_le
  thueMorse_zero thueMorse_two_mul thueMorse_two_mul_add_one
  transition_two_mul transition_two_mul_add_one
  alternations_double_even alternations_double_odd
  from D5.S1.Words.Complexity.ThueMorseReducedAbelianOdd

/-- Minimum number of transitions in a factor with `n` edges, over all starts. -/
noncomputable def minAlternations (n : Nat) : Nat :=
  sInf (Set.range fun s => (reducedAbelianCode (n + 1) s).1 - 1)

/-- Maximum number of transitions in a factor with `n` edges, over all starts. -/
noncomputable def maxAlternations (n : Nat) : Nat :=
  sSup (Set.range fun s => (reducedAbelianCode (n + 1) s).1 - 1)

private theorem code_edges (n s : Nat) :
    (reducedAbelianCode (n + 1) s).1 - 1 = alternations n s := by
  simp [reducedAbelianCode, runs]

private theorem alt_bdd (n : Nat) : BddAbove (Set.range (alternations n)) :=
  ⟨n, by rintro _ ⟨s, rfl⟩; exact alternations_le n s⟩

private theorem min_attained (n : Nat) : ∃ s, alternations n s = minAlternations n := by
  simpa [minAlternations, code_edges] using
    (Nat.sInf_mem (Set.range_nonempty (alternations n)))

private theorem max_attained (n : Nat) : ∃ s, alternations n s = maxAlternations n := by
  simpa [maxAlternations, code_edges] using
    (Nat.sSup_mem (Set.range_nonempty (alternations n)) (alt_bdd n))

private theorem min_le_alt (n s : Nat) : minAlternations n ≤ alternations n s := by
  simpa [minAlternations, code_edges] using
    (Nat.sInf_le (Set.mem_range_self s) : sInf (Set.range (alternations n)) ≤ _)

private theorem alt_le_max (n s : Nat) : alternations n s ≤ maxAlternations n := by
  simpa [maxAlternations, code_edges] using
    (le_csSup (alt_bdd n) (Set.mem_range_self s))

private theorem extrema_bounds (n : Nat) :
    minAlternations n ≤ maxAlternations n ∧ maxAlternations n ≤ n := by
  obtain ⟨s, hs⟩ := max_attained n
  constructor
  · simpa [hs] using min_le_alt n s
  · simpa [hs] using alternations_le n s

private theorem transition_le_one (s : Nat) : transition s ≤ 1 := by
  unfold transition
  split <;> omega

private theorem alt_snoc (n s : Nat) :
    alternations (n + 1) s = alternations n s + transition (s + n) := by
  induction n generalizing s with
  | zero => simp [alternations]
  | succ n ih =>
      change transition s + alternations (n + 1) (s + 1) =
        (transition s + alternations n (s + 1)) + transition (s + (n + 1))
      rw [ih]
      simp only [Nat.add_assoc, Nat.add_left_comm, Nat.add_comm]

private theorem extrema_step (n : Nat) :
    minAlternations n ≤ minAlternations (n + 1) ∧
      maxAlternations n ≤ maxAlternations (n + 1) := by
  obtain ⟨s, hs⟩ := min_attained (n + 1)
  obtain ⟨t, ht⟩ := max_attained n
  have hmin := min_le_alt n s
  have hmax := alt_le_max (n + 1) t
  rw [alt_snoc] at hs hmax
  omega

private theorem alt_odd_even (n q : Nat) :
    alternations (2 * n + 1) (2 * q) = 2 * n + 1 - alternations n q := by
  rw [alternations, transition_two_mul, alternations_double_odd]
  have h := alternations_le n q
  omega

private theorem alt_odd_odd (n q : Nat) :
    alternations (2 * n + 1) (2 * q + 1) =
      2 * n + 1 - alternations (n + 1) q := by
  rw [alternations, transition_two_mul_add_one]
  rw [show 2 * q + 1 + 1 = 2 * (q + 1) by omega, alternations_double_even]
  have h := alternations_le n (q + 1)
  have ht := transition_le_one q
  simp only [alternations]
  omega

private theorem extrema_even (n : Nat) :
    minAlternations (2 * n) = 2 * n - maxAlternations n ∧
      maxAlternations (2 * n) = 2 * n - minAlternations n := by
  have hb := extrema_bounds n
  have formula (s : Nat) :
      alternations (2 * n) s = 2 * n - alternations n (s / 2) := by
    obtain ⟨q, rfl | rfl⟩ := s.even_or_odd'
    · simpa using alternations_double_even n q
    · simpa only [show (2 * q + 1) / 2 = q by omega] using alternations_double_odd n q
  obtain ⟨s, hs⟩ := min_attained (2 * n)
  obtain ⟨t, ht⟩ := max_attained (2 * n)
  obtain ⟨u, hu⟩ := min_attained n
  obtain ⟨v, hv⟩ := max_attained n
  have h1 := min_le_alt (2 * n) (2 * v)
  have h2 := alt_le_max (2 * n) (2 * u)
  have h3 := alt_le_max n (s / 2)
  have h4 := min_le_alt n (t / 2)
  rw [alternations_double_even, hv] at h1
  rw [alternations_double_even, hu] at h2
  rw [formula] at hs ht
  constructor <;> omega

private theorem extrema_odd (n : Nat) :
    minAlternations (2 * n + 1) = 2 * n + 1 - maxAlternations (n + 1) ∧
      maxAlternations (2 * n + 1) = 2 * n + 1 - minAlternations n := by
  have hb := extrema_bounds n
  have hb' := extrema_bounds (n + 1)
  have hstep := extrema_step n
  have bounds (s : Nat) :
      2 * n + 1 - maxAlternations (n + 1) ≤ alternations (2 * n + 1) s ∧
        alternations (2 * n + 1) s ≤ 2 * n + 1 - minAlternations n := by
    obtain ⟨q, rfl | rfl⟩ := s.even_or_odd'
    · rw [alt_odd_even]
      have h1 := min_le_alt n q
      have h2 := alt_le_max n q
      constructor <;> omega
    · rw [alt_odd_odd]
      have h1 := min_le_alt (n + 1) q
      have h2 := alt_le_max (n + 1) q
      constructor <;> omega
  obtain ⟨s, hs⟩ := min_attained (2 * n + 1)
  obtain ⟨t, ht⟩ := max_attained (2 * n + 1)
  obtain ⟨u, hu⟩ := max_attained (n + 1)
  obtain ⟨v, hv⟩ := min_attained n
  have h1 := (bounds s).1
  have h2 := (bounds t).2
  have h3 := min_le_alt (2 * n + 1) (2 * u + 1)
  have h4 := alt_le_max (2 * n + 1) (2 * v)
  rw [alt_odd_odd, hu] at h3
  rw [alt_odd_even, hv] at h4
  constructor <;> omega

private theorem thueMorse_triple_boundary (n : Nat) :
    (thueMorse (n + 1) = thueMorse (3 * (n + 1))) ↔
      (thueMorse n = thueMorse (3 * n + 2)) := by
  induction n using Nat.strong_induction_on with
  | h n ih =>
      obtain ⟨k, rfl | rfl⟩ := n.even_or_odd'
      · rw [show 3 * (2 * k + 1) = 2 * (3 * k + 1) + 1 by omega,
          show 3 * (2 * k) + 2 = 2 * (3 * k + 1) by omega]
        simp
      · rw [show 2 * k + 1 + 1 = 2 * (k + 1) by omega,
          show 3 * (2 * (k + 1)) = 2 * (3 * (k + 1)) by omega,
          show 3 * (2 * k + 1) + 2 = 2 * (3 * k + 2) + 1 by omega]
        simpa using ih k (by omega)

/-- The parity of the all-start transition spectrum width is a triple-index comparison. -/
theorem alternation_extrema_parity (n : Nat) :
    (minAlternations n + maxAlternations n) % 2 =
      if thueMorse n = thueMorse (3 * n) then 0 else 1 := by
  induction n using Nat.strong_induction_on with
  | h n ih =>
      by_cases hn : n = 0
      · subst n
        have hb := extrema_bounds 0
        simp only [Nat.mul_zero, ↓reduceIte]
        omega
      obtain ⟨k, rfl | rfl⟩ := n.even_or_odd'
      · have hi := ih k (by omega)
        have he := extrema_even k
        have hb := extrema_bounds k
        rw [show 3 * (2 * k) = 2 * (3 * k) by omega]
        simp only [thueMorse_two_mul]
        omega
      · obtain ⟨j, rfl | rfl⟩ := k.even_or_odd'
        · have hi := ih j (by omega)
          have he := extrema_even j
          have ho := extrema_odd j
          have hbig := extrema_odd (2 * j)
          have hb := extrema_bounds j
          rw [show 3 * (2 * (2 * j) + 1) = 2 * (2 * (3 * j) + 1) + 1 by omega]
          simp only [thueMorse_two_mul, thueMorse_two_mul_add_one]
          cases h0 : thueMorse j <;> cases h1 : thueMorse (3 * j) <;>
            simp [h0, h1] at hi ⊢ <;> omega
        · have hi := ih (j + 1) (by omega)
          have he := extrema_even (j + 1)
          have ho := extrema_odd j
          have hbig := extrema_odd (2 * j + 1)
          have hb := extrema_bounds (j + 1)
          have ht := thueMorse_triple_boundary j
          rw [show 3 * (2 * (2 * j + 1) + 1) = 2 * (2 * (3 * j + 2)) + 1 by omega]
          simp only [thueMorse_two_mul, thueMorse_two_mul_add_one, Bool.not_not]
          simp only [ht] at hi
          have heq : 2 * j + 1 + 1 = 2 * (j + 1) := by omega
          rw [heq] at hbig
          cases h0 : thueMorse j <;> cases h1 : thueMorse (3 * j + 2) <;>
            simp [h0, h1] at hi ⊢ <;> omega

#print axioms alternation_extrema_parity

end D5.S1.Words.Complexity
