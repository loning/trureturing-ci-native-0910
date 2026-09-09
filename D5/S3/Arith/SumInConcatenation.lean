/- GID: D5/S3/Arith/SumInConcatenation
   generality: G
   mirror-B: D5/B/S3/Arith/SumInConcatenation
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: A359482 has no positive single-digit successor and is not a permutation. -/
import Mathlib.Data.Nat.Digits.Lemmas
import Mathlib.Data.List.Infix
import Mathlib.Order.Lattice.Nat
import Mathlib.Tactic

namespace D5.S3.Arith.SumInConcatenation

/-- Decimal digits, most significant first, with zero represented by [0]. -/
def D (x : ℕ) : List ℕ := if x = 0 then [0] else (Nat.digits 10 x).reverse

/-- The decimal sum occurs in the concatenation of the two decimal operands. -/
def Legal (x y : ℕ) : Prop := (D (x + y)).IsInfix (D x ++ D y)

instance (x y : ℕ) : Decidable (Legal x y) := inferInstanceAs
  (Decidable ((D (x + y)).IsInfix (D x ++ D y)))

private theorem legal_controls : Legal 1 10 ∧ Legal 10 99 ∧ Legal 99 889 := by decide

private theorem legal_reverse {x y : ℕ} (hx : 0 < x) (hy : 0 < y) :
    Legal x y ↔ (Nat.digits 10 (x + y)).IsInfix
      (Nat.digits 10 y ++ Nat.digits 10 x) := by
  simp only [Legal, D, Nat.ne_of_gt hx, Nat.ne_of_gt hy,
    show x + y ≠ 0 by omega, ↓reduceIte]
  rw [← List.reverse_append, List.reverse_infix]

private theorem shifted_digits_impossible (x d a : ℕ) (r : List ℕ)
    (hx : 0 < x) (hxrep : Nat.digits 10 x = r ++ [a])
    (hsum : Nat.digits 10 (x + d) = d :: r) : False := by
  have ha : a < 10 := Nat.digits_lt_base (by norm_num)
    (hxrep ▸ List.mem_append_right r (by simp))
  have hr : Nat.ofDigits 10 r < 10 ^ r.length :=
    Nat.ofDigits_lt_base_pow_length (by norm_num) (fun z hz =>
      Nat.digits_lt_base (by norm_num) (hxrep ▸ List.mem_append_left [a] hz))
  have heq := congrArg (Nat.ofDigits 10) hxrep
  have hval := congrArg (Nat.ofDigits 10) hsum
  simp only [Nat.ofDigits_digits, Nat.ofDigits_append, Nat.ofDigits_cons,
    Nat.ofDigits_nil, mul_zero, add_zero] at heq hval
  have hrot : 10 ^ r.length * a = 9 * Nat.ofDigits 10 r := by omega
  have hm := congrArg (· % 9) hrot
  simp [Nat.mul_mod, Nat.pow_mod] at hm
  have ha' : a = 0 ∨ a = 9 := by omega
  rcases ha' with rfl | rfl
  · simp only [mul_zero] at heq
    omega
  · omega

/-- No positive one-digit number can follow a positive operand under the substring rule. -/
theorem no_small_successor (x d : ℕ) (hx : 0 < x) (hd : 0 < d ∧ d < 10) :
    ¬ Legal x d := by
  intro h
  have hlen := Nat.le_length_digits_le 10 x (x + d) (by omega)
  have hin := (legal_reverse hx hd.1).mp h
  simp only [Nat.digits_of_lt 10 d (by omega) hd.2, List.singleton_append] at hin
  rcases List.infix_cons_iff.mp hin with hp | hi
  · obtain ⟨t, ht⟩ := hp
    have htlen := congrArg List.length ht
    simp only [List.length_append, List.length_cons] at htlen
    have htshort : t.length ≤ 1 := by omega
    cases t with
    | nil =>
      have hv := congrArg (Nat.ofDigits 10) ht
      simp only [List.append_nil, Nat.ofDigits_digits, Nat.ofDigits_cons] at hv
      omega
    | cons a t =>
      have : t = [] := by simpa using htshort
      subst t
      cases hs : Nat.digits 10 (x + d) with
      | nil => have := Nat.digits_eq_nil_iff_eq_zero.mp hs; omega
      | cons c r =>
        simp only [hs, List.cons_append, List.cons.injEq] at ht
        obtain ⟨hc, hr⟩ := ht
        subst c
        exact shifted_digits_impossible x d a r hx hr.symm hs
  · have he := hi.eq_of_length_le hlen
    have := Nat.digits.injective 10 he
    omega

#print axioms no_small_successor

end D5.S3.Arith.SumInConcatenation
