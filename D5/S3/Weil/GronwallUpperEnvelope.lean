/- GID: D5/S3/Weil/GronwallUpperEnvelope
   generality: G
   mirror-B: none(waiver:formal-unit-only)
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Assemble the eventual Gronwall upper envelope from Mertens III. -/

import D5.S3.Weil.Mertens.Third
import Mathlib.NumberTheory.ArithmeticFunction.Misc
import Mathlib.Algebra.Order.BigOperators.GroupWithZero.Finset
import Mathlib.Algebra.Field.GeomSum

/-!
The upper half of Gronwall's theorem, using the frozen Mertens III port.
Proof shape: bind-only. Admission basis: rule-11-upstream-wrapper.
The API obligation is the first named Gronwall consumer promised by the
Mertens III port in #6171. No lower-limsup construction or limsup equality
is asserted here. The finite estimates reuse the proofs recorded in
gronwall-step1-0907/attempt-1 and gronwall-step2-0907/attempt-1.

Companion edges (consumer -> prerequisite):
sigma_split -> small_prime_product_le;
large_prime_product_le -> large_prime_count_le;
sigma_split -> large_prime_product_le;
gronwall_upper_envelope -> sigma_split.
-/

set_option autoImplicit false

namespace D5.S3.Weil.GronwallUpperEnvelope

open Finset Filter Real Asymptotics
open scoped BigOperators Topology

/-- Padding the small prime divisors by all primes up to the cutoff. -/
theorem small_prime_product_le (n : ℕ) (y : ℝ) :
    (∏ p ∈ n.primeFactors.filter (fun p : ℕ => (p : ℝ) ≤ y),
      (1 - 1 / (p : ℝ))⁻¹) ≤
      ∏ p ∈ Ioc (0 : ℕ) ⌊y⌋₊ with p.Prime, (1 - 1 / (p : ℝ))⁻¹ := by
  have hfactor (p : ℕ) (hp : p.Prime) : (1 : ℝ) ≤ (1 - 1 / (p : ℝ))⁻¹ := by
    have hp1 : (1 : ℝ) < p := by
      simpa only [Nat.cast_one] using (Nat.cast_lt (α := ℝ)).2 hp.one_lt
    have hrecip : 1 / (p : ℝ) < 1 := by
      simpa only [one_div] using inv_lt_one_of_one_lt₀ hp1
    exact (one_le_inv₀ (sub_pos.mpr hrecip)).2
      (sub_le_self 1 (div_nonneg zero_le_one (Nat.cast_nonneg p)))
  exact Finset.prod_le_prod_of_subset_of_one_le
    (fun p hp =>
      Finset.mem_filter.mpr
        ⟨Finset.mem_Ioc.mpr
          ⟨(Nat.prime_of_mem_primeFactors (Finset.mem_filter.mp hp).1).pos,
            Nat.le_floor (Finset.mem_filter.mp hp).2⟩,
          Nat.prime_of_mem_primeFactors (Finset.mem_filter.mp hp).1⟩)
    (fun p hp => le_trans zero_le_one
      (hfactor p (Nat.prime_of_mem_primeFactors (Finset.mem_filter.mp hp).1)))
    (fun p hp _ => hfactor p (Finset.mem_filter.mp hp).2)

end D5.S3.Weil.GronwallUpperEnvelope
