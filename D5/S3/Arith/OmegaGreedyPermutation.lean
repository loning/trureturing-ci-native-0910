/- GID: D5/S3/Arith/OmegaGreedyPermutation
   generality: G
   mirror-B: D5/B/S3/Arith/OmegaGreedyPermutation
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: The least-unused multiple sequence indexed by distinct prime factor counts is a permutation. -/
import Mathlib.NumberTheory.ArithmeticFunction.Misc
import Mathlib.Data.Nat.Prime.Nth
import Mathlib.Data.Nat.Prime.Infinite
import Mathlib.Data.Nat.Squarefree
import Mathlib.Data.Set.Finite.Lattice
import Mathlib.Order.Lattice.Nat
import Mathlib.Tactic

open scoped ArithmeticFunction.omega
namespace D5.S3.Arith.OmegaGreedyPermutation

noncomputable def prime (r : ℕ) : ℕ := Nat.nth Nat.Prime r

private theorem prime_prime (r : ℕ) : (prime r).Prime :=
  Nat.nth_mem_of_infinite Nat.infinite_setOfPred_prime r

noncomputable def next (q : ℕ) (used : Finset ℕ) : ℕ :=
  sInf {y | 0 < y ∧ y ∉ used ∧ q ∣ y}

private theorem next_spec (q : ℕ) (used : Finset ℕ) (hq : 0 < q) :
    0 < next q used ∧ next q used ∉ used ∧ q ∣ next q used := by
  apply Nat.sInf_mem (s := {y | 0 < y ∧ y ∉ used ∧ q ∣ y})
  refine ⟨q * (used.sup id + 1), Nat.mul_pos hq (by omega), ?_, dvd_mul_right _ _⟩
  intro hm
  have hb := Finset.le_sup (f := id) hm
  dsimp only [id] at hb
  have := Nat.le_mul_of_pos_left (used.sup id + 1) hq
  omega

noncomputable def state : ℕ → ℕ × Finset ℕ
  | 0 => (2, {1, 2})
  | k + 1 =>
      let y := next (prime (ω (state k).1 - 1)) (state k).2
      (y, insert y (state k).2)

noncomputable def b (n : ℕ) : ℕ := (state n).1
noncomputable def q (n : ℕ) : ℕ := prime (ω (b n) - 1)
noncomputable def seq (n : ℕ) : ℕ := if n ≤ 1 then 1 else b (n - 2)

private theorem step_spec (n : ℕ) :
    0 < b (n + 1) ∧ b (n + 1) ∉ (state n).2 ∧ q n ∣ b (n + 1) :=
  next_spec _ _ (prime_prime _).pos

private theorem b_ge_two (n : ℕ) : 2 ≤ b n := by
  cases n with
  | zero => decide
  | succ n =>
    exact (prime_prime _).two_le.trans
      (Nat.le_of_dvd (step_spec n).1 (step_spec n).2.2)

private theorem used_eq (n : ℕ) :
    (state n).2 = insert 1 ((Finset.range (n + 1)).image b) := by
  induction n with
  | zero => simp [state, b]
  | succ n ih =>
    change insert (b (n + 1)) (state n).2 = _
    rw [ih, Finset.range_add_one (n := n + 1), Finset.image_insert, Finset.insert_comm]

private theorem b_mem_used {i n : ℕ} (hi : i ≤ n) : b i ∈ (state n).2 := by
  rw [used_eq]
  exact Finset.mem_insert_of_mem (Finset.mem_image.mpr ⟨i, by simp; omega, rfl⟩)

private theorem b_injective : Function.Injective b := by
  suffices h : ∀ i j, i < j → b i ≠ b j by
    intro i j he
    rcases lt_trichotomy i j with hi | hi | hi
    · exact (h i j hi he).elim
    · exact hi
    · exact (h j i hi he.symm).elim
  intro i j hij he
  obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : j ≠ 0)
  exact (step_spec k).2.1 (he ▸ b_mem_used (by omega))

private theorem step_le {n m : ℕ} (hm : 0 < m) (hu : m ∉ (state n).2)
    (hd : q n ∣ m) : b (n + 1) ≤ m :=
  Nat.sInf_le ⟨hm, hu, hd⟩

private theorem queue_exhausts (p : ℕ) (hp : p.Prime)
    (hi : {n | q n = p}.Infinite) {m : ℕ} (hm : 0 < m) (hd : p ∣ m) :
    ∃ i, b i = m := by
  by_contra hn
  push Not at hn
  apply hi
  apply Set.Finite.of_injOn (f := fun n => b (n + 1)) (t := Set.Iic m)
  · intro n hq
    apply step_le hm
    · rw [used_eq]
      simp only [Finset.mem_insert, Finset.mem_image, Finset.mem_range, not_or, not_exists]
      refine ⟨?_, fun i he => ?_⟩
      · intro he
        subst m
        exact hp.not_dvd_one hd
      · exact hn i he.2
    · simpa only [Set.mem_ofPred_eq] using hq ▸ hd
  · intro i _ j _ he
    have := b_injective he
    omega
  · exact Set.finite_Iic m

#print axioms queue_exhausts
end D5.S3.Arith.OmegaGreedyPermutation
