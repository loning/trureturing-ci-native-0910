/- GID: D5/S3/Arith/DivisorGibbs/CofinalDivisibility
   generality: G
   mirror-B: D5/B/S3/Arith/DivisorGibbs/CofinalDivisibility
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: A joint prime-index and exponent cutoff gives a cofinal divisibility ladder. -/

import Mathlib.Data.Nat.Factorization.Basic
import Mathlib.Data.Nat.Fib.Basic
import Mathlib.NumberTheory.PrimeCounting

/- Library-search audit trail (2026-09-07):
   1. D5 searches: nth/count Prime, factorization, divisors, fib, cofinal, primorial.
      All 24 public declarations in ZetaGibbs, EulerLogBridge, PrimeMarginalEntropy,
      and ZetaPrimeProductCommonBoundary were enumerated and their types queried by LSP.
      They concern integer sums, prime sums, marginals, or probability thresholds.
      PrimeSequenceCode supplies injection, HorizontalCompletenessDepth and
      PrimorialWitnessBound supply CRT size bounds, and HiddenArithmeticWeightFormula
      concerns a fixed divisor carrier. GlobalPrimeExponentRealizability and
      FiniteMarginalGlobalSupportContrast concern probability laws. None supplies
      this deterministic cutoff. CofinalWindowFamily assumes coverage; the
      CofinalTailDiscipline theorem consumes that assumption.
   2. Mathlib v4.33.0, db584cd6d46c92f209a44c0f1c829460d327499d:
      exact component hits used below: Nat.nth_count, Nat.prime_nth_prime,
      Nat.le_fib_self, Nat.fib_mono, Nat.factorization_prod,
      Nat.factorization_le_iff_dvd, Nat.factorization_pow_self, Finset.le_sup,
      Finset.single_le_sum, Finset.prod_dvd_prod_of_dvd, Finset.prod_range_succ.
      Nat.nth_strictMono and Nat.primorial_dvd_primorial were also inspected;
      neither gives exponent coverage. Filter.tendsto_atTop_finset_of_monotone
      requires pointwise coverage. Searches for eventual/cofinal divisibility
      found no exact target.
   3. Online GitHub/Reservoir searches via NyxID/Tavily for Lean cofinal
      divisibility, Nat.nth/fib/prod, and prime factorization found no exact
      formalization in the returned results. Reservoir IMO and STIR use standard
      arithmetic APIs; rxdoi/Autoformalization concerns Project Euler computations.
      GitHub code-search proxy was unavailable (HTTP 400, failed credential).
      This is a scoped search receipt, not an exhaustive claim about the ecosystem.
   Proof shape: content. The preregistered conclusion is produced by cutoff_dvd:
   one support supremum bounds both prime indices and all exponents, then the
   factorization comparison gives divisibility. step_dvd is the requested
   companion clause. No global ladder or cutoff definition is introduced. -/

namespace D5.S3.Arith.DivisorGibbs.CofinalDivisibility

open scoped BigOperators

/-- The explicit joint index/exponent cutoff covers every positive integer at
every later level, and successive Fibonacci prime-power products divide one another. -/
theorem cofinal_divisibility_ladder (n : ℕ) (hn : 1 ≤ n) :
    let M : ℕ → ℕ := fun k =>
      ∏ j ∈ Finset.range k, Nat.nth Nat.Prime j ^ (Nat.fib (k + 2) - 1)
    let K := max 3 (1 + n.factorization.support.sup
      (fun p => max (Nat.count Nat.Prime p) (n.factorization p)))
    (∀ k, K ≤ k → n ∣ M k) ∧ (∀ k, M k ∣ M (k + 1)) := by
  classical
  dsimp only
  have cutoff_dvd (k : ℕ)
      (hk : max 3 (1 + n.factorization.support.sup
        (fun p => max (Nat.count Nat.Prime p) (n.factorization p))) ≤ k) :
      n ∣ ∏ j ∈ Finset.range k, Nat.nth Nat.Prime j ^ (Nat.fib (k + 2) - 1) := by
    have nonzero (j : ℕ) : Nat.nth Nat.Prime j ^ (Nat.fib (k + 2) - 1) ≠ 0 :=
      pow_ne_zero _ (Nat.prime_nth_prime j).ne_zero
    apply (Nat.factorization_le_iff_dvd (by omega)
      (Finset.prod_ne_zero_iff.mpr fun j _ => nonzero j)).mp
    intro p
    by_cases hp : p ∈ n.factorization.support
    · have prime_p : p.Prime := Nat.prime_of_mem_primeFactors
        (by simpa only [Nat.support_factorization] using hp)
      have joint_bound : max (Nat.count Nat.Prime p) (n.factorization p) ≤
          n.factorization.support.sup
            (fun q => max (Nat.count Nat.Prime q) (n.factorization q)) :=
        Finset.le_sup (f := fun q => max (Nat.count Nat.Prime q) (n.factorization q)) hp
      have index_bound : Nat.count Nat.Prime p < k := by omega
      have fib_bound : k + 2 ≤ Nat.fib (k + 2) := Nat.le_fib_self (by omega)
      have exponent_bound : n.factorization p ≤ Nat.fib (k + 2) - 1 := by omega
      rw [Nat.factorization_prod (fun j _ => nonzero j), Finsupp.finsetSum_apply]
      calc
        n.factorization p ≤ Nat.fib (k + 2) - 1 := exponent_bound
        _ = (Nat.nth Nat.Prime (Nat.count Nat.Prime p) ^
            (Nat.fib (k + 2) - 1)).factorization p := by
          rw [Nat.nth_count prime_p, Nat.factorization_pow_self prime_p]
        _ ≤ ∑ j ∈ Finset.range k,
            (Nat.nth Nat.Prime j ^ (Nat.fib (k + 2) - 1)).factorization p :=
          Finset.single_le_sum
            (fun j _ => Nat.zero_le
              ((Nat.nth Nat.Prime j ^ (Nat.fib (k + 2) - 1)).factorization p))
            (Finset.mem_range.mpr index_bound)
    · rw [Finsupp.notMem_support_iff.mp hp]
      exact Nat.zero_le _
  have step_dvd (k : ℕ) :
      (∏ j ∈ Finset.range k, Nat.nth Nat.Prime j ^ (Nat.fib (k + 2) - 1)) ∣
        ∏ j ∈ Finset.range (k + 1), Nat.nth Nat.Prime j ^ (Nat.fib (k + 1 + 2) - 1) := by
    rw [Finset.prod_range_succ]
    apply dvd_mul_of_dvd_left
    apply Finset.prod_dvd_prod_of_dvd
    intro j _
    exact pow_dvd_pow _ (Nat.sub_le_sub_right (Nat.fib_mono (by omega)) 1)
  exact ⟨cutoff_dvd, step_dvd⟩

#print axioms cofinal_divisibility_ladder

end D5.S3.Arith.DivisorGibbs.CofinalDivisibility
