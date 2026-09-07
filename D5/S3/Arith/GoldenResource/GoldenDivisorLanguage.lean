/- GID: D5/S3/Arith/GoldenResource/GoldenDivisorLanguage
   generality: I
   mirror-B: D5/B/S3/Arith/GoldenResource/GoldenDivisorLanguage
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: kind=certified-instance; basis=terminal=atom:8095f57ef998fdbda3d18bfc28a0ac6f95397ad7112061af63f72d2e1307d417
   digest: Prime exponents identify full-window divisors with golden names and distinguish the 5040 observation fiber. -/

import D5.S3.Observer.GoldenCoding.FiniteZeckendorfEulerIdentity
import Mathlib.Data.Nat.Factorization.Basic
import Mathlib.Data.Nat.Fib.Zeckendorf

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

namespace D5.S3.Arith.GoldenResource.GoldenDivisorLanguage

open scoped BigOperators
open D5.S0.Tower.GoldenNames
open D5.S3.Observer.GoldenCoding.FiniteZeckendorfEulerIdentity

/-- Positive divisors of a natural number. -/
abbrev Div (m : Nat) := {d : PNat // d.val ∣ m}

/-- The integer whose prime exponents fill the specified Fibonacci windows. -/
def fullWindow (S : Finset Nat) (L : S → Nat) : Nat :=
  ∏ p : S, p.val ^ (Nat.fib (L p + 2) - 1)

private def primeProduct (S : Finset Nat) (a : S → Nat) : Nat := ∏ p : S, p.val ^ a p

private theorem prime_product_pos (S : Finset Nat) (hS : ∀ p ∈ S, Nat.Prime p)
    (a : S → Nat) : 0 < primeProduct S a :=
  Finset.prod_pos fun p _ => pow_pos (hS p.val p.property).pos _

private theorem prime_product_factorization (S : Finset Nat)
    (hS : ∀ p ∈ S, Nat.Prime p) (a : S → Nat) (p : S) :
    (primeProduct S a).factorization p.val = a p := by
  classical
  unfold primeProduct
  rw [Nat.factorization_prod (fun q _ => pow_ne_zero _ (hS q.val q.property).ne_zero),
    Finsupp.finsetSum_apply, Finset.sum_eq_single p]
  · simp [(hS p.val p.property).factorization_pow]
  · intro q _ hqp
    have hval : q.val ≠ p.val := fun h => hqp (Subtype.ext h)
    simp [(hS q.val q.property).factorization_pow, hval]
  · simp

private theorem prime_product_factorization_outside (S : Finset Nat)
    (hS : ∀ p ∈ S, Nat.Prime p) (a : S → Nat) (q : Nat) (hq : q ∉ S) :
    (primeProduct S a).factorization q = 0 := by
  classical
  unfold primeProduct
  rw [Nat.factorization_prod (fun p _ => pow_ne_zero _ (hS p.val p.property).ne_zero),
    Finsupp.finsetSum_apply]
  apply Finset.sum_eq_zero
  intro p _
  have hpq : p.val ≠ q := fun h => hq (h ▸ p.property)
  simp [(hS p.val p.property).factorization_pow, hpq]

private theorem divisor_exponent_lt (S : Finset Nat) (hS : ∀ p ∈ S, Nat.Prime p)
    (L : S → Nat) (d : Div (fullWindow S L)) (p : S) :
    d.val.val.factorization p.val < Nat.fib (L p + 2) := by
  have hm := prime_product_pos S hS (fun p => Nat.fib (L p + 2) - 1)
  have hle := (Nat.factorization_le_iff_dvd d.val.pos.ne' hm.ne').mpr d.property p.val
  have he := prime_product_factorization S hS (fun p => Nat.fib (L p + 2) - 1) p
  rw [he] at hle
  have hpos : 0 < Nat.fib (L p + 2) := Nat.fib_pos.mpr (by omega)
  omega

private def exponentEquiv (S : Finset Nat) (hS : ∀ p ∈ S, Nat.Prime p)
    (L : S → Nat) : Div (fullWindow S L) ≃ (∀ p : S, Fin (Nat.fib (L p + 2))) where
  toFun d p := ⟨d.val.val.factorization p.val, divisor_exponent_lt S hS L d p⟩
  invFun r := ⟨⟨primeProduct S (fun p => (r p).val), prime_product_pos S hS _⟩, by
    apply Finset.prod_dvd_prod_of_dvd
    intro p _
    exact Nat.pow_dvd_pow _ (Nat.le_sub_one_of_lt (r p).isLt)⟩
  left_inv d := by
    apply Subtype.ext
    apply Subtype.ext
    apply Nat.eq_of_factorization_eq (prime_product_pos S hS _).ne' d.val.pos.ne'
    intro q
    by_cases hq : q ∈ S
    · exact prime_product_factorization S hS _ ⟨q, hq⟩
    · rw [prime_product_factorization_outside S hS _ q hq]
      have hm := prime_product_pos S hS (fun p => Nat.fib (L p + 2) - 1)
      have hle := (Nat.factorization_le_iff_dvd d.val.pos.ne' hm.ne').mpr d.property q
      have hz := prime_product_factorization_outside S hS
        (fun p => Nat.fib (L p + 2) - 1) q hq
      exact (Nat.eq_zero_of_le_zero (hz ▸ hle)).symm
  right_inv r := by
    funext p
    apply Fin.ext
    exact prime_product_factorization S hS _ p

/-- The coordinates of the divisor equivalence are exactly the prime multiplicities. -/
theorem full_window_divisor_exponent_equiv (S : Finset Nat)
    (hS : ∀ p ∈ S, Nat.Prime p) (L : S → Nat) :
    ∃ e : Div (fullWindow S L) ≃ (∀ p : S, Fin (Nat.fib (L p + 2))),
      ∀ d p, (e d p).val = d.val.val.factorization p.val :=
  ⟨exponentEquiv S hS L, fun _ _ => rfl⟩

/-- Each independent prime contributes the size of its Fibonacci window. -/
theorem full_window_divisor_card (S : Finset Nat)
    (hS : ∀ p ∈ S, Nat.Prime p) (L : S → Nat) :
    Nat.card (Div (fullWindow S L)) = ∏ p : S, Nat.fib (L p + 2) := by
  obtain ⟨e, _⟩ := full_window_divisor_exponent_equiv S hS L
  rw [Nat.card_congr e, Nat.card_pi]
  simp only [Nat.card_fin]

/-- Finite Zeckendorf coding transports every prime coordinate to a golden name. -/
theorem full_window_divisor_golden_equiv (S : Finset Nat)
    (hS : ∀ p ∈ S, Nat.Prime p) (L : S → Nat) :
    Nonempty (Div (fullWindow S L) ≃ (∀ p : S, GoldenName (L p))) := by
  obtain ⟨e, _⟩ := full_window_divisor_exponent_equiv S hS L
  let names : ∀ p : S, GoldenName (L p) ≃ Fin (Nat.fib (L p + 2)) := fun p =>
    Equiv.ofBijective _ (finite_zeckendorf_interval_and_euler (L p)).1
  exact ⟨e.trans (Equiv.piCongrRight fun p => (names p).symm)⟩

#print axioms full_window_divisor_exponent_equiv
#print axioms full_window_divisor_card
#print axioms full_window_divisor_golden_equiv

end D5.S3.Arith.GoldenResource.GoldenDivisorLanguage
