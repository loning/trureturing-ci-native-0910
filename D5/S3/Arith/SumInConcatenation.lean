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

end D5.S3.Arith.SumInConcatenation
