/- GID: D5/S3/Arith/Congruence/NonsquarefreeAntirun
   generality: G
   mirror-B: D5/B/S3/Arith/Congruence/NonsquarefreeAntirun
   mirror-E: none(waiver:universal-bound-with-private-sharpness-example)
   anchors: [mathlib/module/Mathlib.Data.Nat.Squarefree]
   utility: none
   digest: Every full interval of nonsquarefree numbers with successive gaps greater than one has at most nine terms. -/

import Mathlib.Data.Nat.Squarefree
import Mathlib.Data.List.Pairwise
import Mathlib.Data.List.Chain
import Mathlib.Tactic

namespace D5.S3.Arith.Congruence.NonsquarefreeAntirun

/-- A strictly increasing list of nonsquarefree natural numbers containing every nonsquarefree
number between any two of its entries. In particular, this is an interval of positions in the
increasing enumeration, rather than an arbitrarily selected subsequence. -/
structure FullNonsquarefreeInterval (l : List ℕ) : Prop where
  increasing : l.Pairwise (· < ·)
  nonsquarefree : ∀ n ∈ l, ¬ Squarefree n
  full : ∀ a ∈ l, ∀ b ∈ l, ∀ n, a ≤ n → n ≤ b → ¬ Squarefree n → n ∈ l

private theorem no_neighbors {l : List ℕ} (hgap : l.IsChain (fun x y => x + 1 < y))
    {n : ℕ} (hn : n ∈ l) (hn1 : n + 1 ∈ l) : False := by
  let : Trans (fun x y : ℕ => x + 1 < y) (fun x y => x + 1 < y)
      (fun x y => x + 1 < y) := ⟨by omega⟩
  have hp := List.pairwise_iff_getElem.mp hgap.pairwise
  obtain ⟨i, hi, he⟩ := List.mem_iff_getElem.mp hn
  obtain ⟨j, hj, he1⟩ := List.mem_iff_getElem.mp hn1
  rcases lt_trichotomy i j with hij | hij | hij
  · have := hp i j hi hj hij
    omega
  · subst j
    omega
  · have := hp j i hj hi hij
    omega

private theorem not_squarefree_of_four_dvd {n : ℕ} (h : 4 ∣ n) : ¬ Squarefree n := by
  intro hs
  exact (Nat.squarefree_iff_prime_squarefree.mp hs 2 Nat.prime_two) h

private theorem not_squarefree_of_nine_dvd {n : ℕ} (h : 9 ∣ n) : ¬ Squarefree n := by
  intro hs
  exact (Nat.squarefree_iff_prime_squarefree.mp hs 3 Nat.prime_three) h

/-- An adjacent nonsquarefree pair cannot occur inside a full antirun. -/
private theorem upper_of_pair {l : List ℕ} (hf : FullNonsquarefreeInterval l)
    (hg : l.IsChain (fun x y => x + 1 < y)) {a b k : ℕ} (ha : a ∈ l) (hb : b ∈ l)
    (hak : a ≤ k) (hk : ¬ Squarefree k) (hk1 : ¬ Squarefree (k + 1)) : b ≤ k := by
  by_contra h
  have hkb : k + 1 ≤ b := by omega
  exact no_neighbors hg (hf.full a ha b hb k hak (by omega) hk)
    (hf.full a ha b hb (k + 1) (by omega) hkb hk1)

end D5.S3.Arith.Congruence.NonsquarefreeAntirun
