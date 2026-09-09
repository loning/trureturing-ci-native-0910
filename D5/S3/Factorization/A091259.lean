/- GID: D5/S3/Factorization/A091259
   generality: I
   mirror-B: D5/B/S3/Factorization/A091259
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: The reduced sigma-three over sigma-one numerator satisfies the A353816 criterion. -/

import D5.S3.Factorization.A091259PrimePower

/- Search receipts (2026-09-09):
   OEIS A091259 still labels Marcus's 2024-08-11 assertion a conjecture; A353816 explicitly
   states the prime-exponent criterion used below. The quadratic-form characterization is
   outside this theorem's scope. The three GoldenResource modules named in the task supply
   the existing sigma API pattern. Pinned Mathlib supplies multiplicative_factorization,
   sigma_apply_prime_pow, coprime_div_gcd_div_gcd, and orderOf_dvd_card_sub_one; these are reused.
   Repository and pinned-Mathlib searches found no A091259 theorem. Authenticated GitHub code
   search for A091259 language:Lean returned total_count=0. This is a bounded search receipt,
   not a claim that no proof exists anywhere. -/

namespace D5.S3.Factorization.A091259

open D5.S3.Factorization.A091259Cancellation
open D5.S3.Factorization.A091259Cyclotomic
open D5.S3.Factorization.A091259PrimePower
open Finset

def a353816FactorIndicator (n : ℕ) : ℕ :=
  if ∀ p ∈ n.primeFactors, p % 3 = 2 → Even (n.factorization p) then 1 else 0

theorem localNumerator_prod_mod (s : Finset ℕ) (e : ℕ → ℕ) :
    (∏ p ∈ s, localNumerator p (e p)) % 3 =
      if ∀ p ∈ s, p % 3 = 2 → Even (e p) then 1 else 0 := by
  induction s using Finset.induction_on with
  | empty => simp
  | @insert p s hp ih =>
      rw [prod_insert hp, Nat.mul_mod, localNumerator_mod, ih]
      simp only [forall_mem_insert]
      by_cases h1 : p % 3 = 2 → Even (e p)
      · by_cases h2 : ∀ q ∈ s, q % 3 = 2 → Even (e q)
        · rw [if_pos h1, if_pos h2, if_pos ⟨h1, h2⟩]
        · rw [if_pos h1, if_neg h2, if_neg (fun h => h2 h.2)]
      · rw [if_neg h1, zero_mul, if_neg (fun h => h1 h.1), Nat.zero_mod]

/-- Michel Marcus's A091259 conjecture, with the published A353816 factor criterion. -/
theorem a091259_mod_three (n : ℕ) (hn : 0 < n) :
    ((ArithmeticFunction.sigma 3) n /
       Nat.gcd ((ArithmeticFunction.sigma 3) n) ((ArithmeticFunction.sigma 1) n)) % 3
      = a353816FactorIndicator n := by
  let A := ∏ p ∈ n.primeFactors, localNumerator p (n.factorization p)
  let B := ∏ p ∈ n.primeFactors, strippedThree p
  have hB : ∀ d, d ∣ B → d % 3 = 1 := by
    dsimp [B]
    induction n.primeFactors using Finset.induction_on with
    | empty => simp
    | @insert p s hp ih =>
        rw [prod_insert hp]
        exact divisors_mul_mod_three (strippedThree_divisors p) ih
  have hcross : ArithmeticFunction.sigma 3 n * B = ArithmeticFunction.sigma 1 n * A := by
    dsimp [A, B]
    rw [(ArithmeticFunction.isMultiplicative_sigma (k := 3)).multiplicative_factorization _ hn.ne',
      (ArithmeticFunction.isMultiplicative_sigma (k := 1)).multiplicative_factorization _ hn.ne']
    simp only [Finsupp.prod, Nat.support_factorization, ← prod_mul_distrib]
    apply prod_congr rfl
    intro p hp
    exact localNumerator_cross (Nat.prime_of_mem_primeFactors hp) (n.factorization p)
  rw [reduced_numerator_mod_three (ArithmeticFunction.sigma_pos 1 n hn.ne') hB hcross]
  exact localNumerator_prod_mod n.primeFactors n.factorization

#print axioms localNumerator_prod_mod
#print axioms a091259_mod_three

end D5.S3.Factorization.A091259
