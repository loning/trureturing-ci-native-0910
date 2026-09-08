/- GID: D5/S3/Factorization/PrefixLcmNotFactorialPrimorial
   generality: I
   mirror-B: D5/B/S3/Factorization/PrefixLcmNotFactorialPrimorial
   mirror-E: none(waiver:the-certificate-is-entirely-formal)
   anchors: []
   utility: kind=certified-instance; basis=refutes=atom:21402387e1e50c568e84d2e5b06c1e589458694df510c063d6b4a59d103f9fb1; result=D5/S3/Factorization/PrefixLcmNotFactorialPrimorial.not_forall_prime_pow_lcmUpto_factorial_mul_distinctPrimorial
   digest: The prefix lcm at 5^69 is not a factorial product times a product of distinct primorials. -/

import Mathlib.Data.Nat.Choose.Factorization
import Mathlib.NumberTheory.Chebyshev
import Mathlib.NumberTheory.Primorial
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.NormNum.Prime

open scoped BigOperators

namespace D5.S3.Factorization.PrefixLcmNotFactorialPrimorial

/-- A product of factorials, where repetition is allowed. -/
def IsFactorialProduct (J : ℕ) : Prop :=
  ∃ l : Multiset ℕ, J = (l.map Nat.factorial).prod

/-- A product of primorials indexed by distinct primes. -/
def IsDistinctPrimorialProduct (P : ℕ) : Prop :=
  ∃ S : Finset ℕ, (∀ q ∈ S, Nat.Prime q) ∧ P = ∏ q ∈ S, primorial q

private def score (z : ℕ) : ℤ :=
  3 * ((z.factorization 2 : ℕ) - (z.factorization 3 : ℕ) : ℤ) +
  1 * ((z.factorization 3 : ℕ) - (z.factorization 5 : ℕ) : ℤ) -
  6 * ((z.factorization 5 : ℕ) - (z.factorization 7 : ℕ) : ℤ) -
  7 * ((z.factorization 7 : ℕ) - (z.factorization 11 : ℕ) : ℤ) -
  8 * ((z.factorization 11 : ℕ) - (z.factorization 13 : ℕ) : ℤ) -
  5 * ((z.factorization 13 : ℕ) - (z.factorization 17 : ℕ) : ℤ) -
  12 * ((z.factorization 17 : ℕ) - (z.factorization 19 : ℕ) : ℤ) -
  12 * ((z.factorization 19 : ℕ) - (z.factorization 23 : ℕ) : ℤ) -
  7 * ((z.factorization 23 : ℕ) - (z.factorization 29 : ℕ) : ℤ) +
  0 * ((z.factorization 29 : ℕ) - (z.factorization 31 : ℕ) : ℤ) -
  6 * ((z.factorization 31 : ℕ) - (z.factorization 37 : ℕ) : ℤ)

private lemma score_mul {a b : ℕ} (ha : a ≠ 0) (hb : b ≠ 0) :
    score (a * b) = score a + score b := by
  simp only [score, Nat.factorization_mul ha hb, Finsupp.add_apply, Nat.cast_add]
  ring

private lemma lcm_factorization_eq (p e : ℕ) (hp : Nat.Prime p)
    (hlow : p ^ e ≤ 5 ^ 69) (hhigh : 5 ^ 69 < p ^ (e + 1)) :
    (Nat.lcmUpto (5 ^ 69)).factorization p = e := by
  rw [Nat.factorization_lcmUpto _ hp]
  exact Nat.log_eq_of_pow_le_of_lt_pow hlow hhigh

private lemma lcm_factorization_two :
    (Nat.lcmUpto (5 ^ 69)).factorization 2 = 160 :=
  lcm_factorization_eq 2 160 (by decide) (by norm_num) (by norm_num)

private lemma score_lcm : score (Nat.lcmUpto (5 ^ 69)) = -65 := by
  have h2 := lcm_factorization_two
  have h3 : (Nat.lcmUpto (5 ^ 69)).factorization 3 = 101 :=
    lcm_factorization_eq 3 101 (by decide) (by norm_num) (by norm_num)
  have h5 : (Nat.lcmUpto (5 ^ 69)).factorization 5 = 69 :=
    lcm_factorization_eq 5 69 (by decide) (by norm_num) (by norm_num)
  have h7 : (Nat.lcmUpto (5 ^ 69)).factorization 7 = 57 :=
    lcm_factorization_eq 7 57 (by decide) (by norm_num) (by norm_num)
  have h11 : (Nat.lcmUpto (5 ^ 69)).factorization 11 = 46 :=
    lcm_factorization_eq 11 46 (by decide) (by norm_num) (by norm_num)
  have h13 : (Nat.lcmUpto (5 ^ 69)).factorization 13 = 43 :=
    lcm_factorization_eq 13 43 (by decide) (by norm_num) (by norm_num)
  have h17 : (Nat.lcmUpto (5 ^ 69)).factorization 17 = 39 :=
    lcm_factorization_eq 17 39 (by decide) (by norm_num) (by norm_num)
  have h19 : (Nat.lcmUpto (5 ^ 69)).factorization 19 = 37 :=
    lcm_factorization_eq 19 37 (by decide) (by norm_num) (by norm_num)
  have h23 : (Nat.lcmUpto (5 ^ 69)).factorization 23 = 35 :=
    lcm_factorization_eq 23 35 (by decide) (by norm_num) (by norm_num)
  have h29 : (Nat.lcmUpto (5 ^ 69)).factorization 29 = 32 :=
    lcm_factorization_eq 29 32 (by decide) (by norm_num) (by norm_num)
  have h31 : (Nat.lcmUpto (5 ^ 69)).factorization 31 = 32 :=
    lcm_factorization_eq 31 32 (by decide) (by norm_num) (by norm_num)
  have h37 : (Nat.lcmUpto (5 ^ 69)).factorization 37 = 30 :=
    lcm_factorization_eq 37 30 (by decide) (by norm_num) (by norm_num)
  simp only [score, h2, h3, h5, h7, h11, h13, h17, h19, h23, h29, h31, h37]
  norm_num

private def factorialValuation (p k : ℕ) : ℕ :=
  ∑ i ∈ Finset.Ico 1 8, k / p ^ i

private def factorialScore (k : ℕ) : ℤ :=
  3 * ((factorialValuation 2 k : ℕ) - (factorialValuation 3 k : ℕ) : ℤ) +
  1 * ((factorialValuation 3 k : ℕ) - (factorialValuation 5 k : ℕ) : ℤ) -
  6 * ((factorialValuation 5 k : ℕ) - (factorialValuation 7 k : ℕ) : ℤ) -
  7 * ((factorialValuation 7 k : ℕ) - (factorialValuation 11 k : ℕ) : ℤ) -
  8 * ((factorialValuation 11 k : ℕ) - (factorialValuation 13 k : ℕ) : ℤ) -
  5 * ((factorialValuation 13 k : ℕ) - (factorialValuation 17 k : ℕ) : ℤ) -
  12 * ((factorialValuation 17 k : ℕ) - (factorialValuation 19 k : ℕ) : ℤ) -
  12 * ((factorialValuation 19 k : ℕ) - (factorialValuation 23 k : ℕ) : ℤ) -
  7 * ((factorialValuation 23 k : ℕ) - (factorialValuation 29 k : ℕ) : ℤ) +
  0 * ((factorialValuation 29 k : ℕ) - (factorialValuation 31 k : ℕ) : ℤ) -
  6 * ((factorialValuation 31 k : ℕ) - (factorialValuation 37 k : ℕ) : ℤ)

private lemma score_factorial_eq (k : ℕ) (hk : k ≤ 163) :
    score k.factorial = factorialScore k := by
  have h2 : Nat.log 2 k < 8 :=
    (Nat.log_monotone hk).trans_lt
      (Nat.log_lt_of_lt_pow (by norm_num) (by norm_num))
  have h3 : Nat.log 3 k < 8 :=
    (Nat.log_monotone hk).trans_lt
      (Nat.log_lt_of_lt_pow (by norm_num) (by norm_num))
  have h5 : Nat.log 5 k < 8 :=
    (Nat.log_monotone hk).trans_lt
      (Nat.log_lt_of_lt_pow (by norm_num) (by norm_num))
  have h7 : Nat.log 7 k < 8 :=
    (Nat.log_monotone hk).trans_lt
      (Nat.log_lt_of_lt_pow (by norm_num) (by norm_num))
  have h11 : Nat.log 11 k < 8 :=
    (Nat.log_monotone hk).trans_lt
      (Nat.log_lt_of_lt_pow (by norm_num) (by norm_num))
  have h13 : Nat.log 13 k < 8 :=
    (Nat.log_monotone hk).trans_lt
      (Nat.log_lt_of_lt_pow (by norm_num) (by norm_num))
  have h17 : Nat.log 17 k < 8 :=
    (Nat.log_monotone hk).trans_lt
      (Nat.log_lt_of_lt_pow (by norm_num) (by norm_num))
  have h19 : Nat.log 19 k < 8 :=
    (Nat.log_monotone hk).trans_lt
      (Nat.log_lt_of_lt_pow (by norm_num) (by norm_num))
  have h23 : Nat.log 23 k < 8 :=
    (Nat.log_monotone hk).trans_lt
      (Nat.log_lt_of_lt_pow (by norm_num) (by norm_num))
  have h29 : Nat.log 29 k < 8 :=
    (Nat.log_monotone hk).trans_lt
      (Nat.log_lt_of_lt_pow (by norm_num) (by norm_num))
  have h31 : Nat.log 31 k < 8 :=
    (Nat.log_monotone hk).trans_lt
      (Nat.log_lt_of_lt_pow (by norm_num) (by norm_num))
  have h37 : Nat.log 37 k < 8 :=
    (Nat.log_monotone hk).trans_lt
      (Nat.log_lt_of_lt_pow (by norm_num) (by norm_num))
  simp only [score, factorialScore, factorialValuation]
  rw [Nat.factorization_factorial (p := 2) (by decide) h2,
    Nat.factorization_factorial (p := 3) (by decide) h3,
    Nat.factorization_factorial (p := 5) (by decide) h5,
    Nat.factorization_factorial (p := 7) (by decide) h7,
    Nat.factorization_factorial (p := 11) (by decide) h11,
    Nat.factorization_factorial (p := 13) (by decide) h13,
    Nat.factorization_factorial (p := 17) (by decide) h17,
    Nat.factorization_factorial (p := 19) (by decide) h19,
    Nat.factorization_factorial (p := 23) (by decide) h23,
    Nat.factorization_factorial (p := 29) (by decide) h29,
    Nat.factorization_factorial (p := 31) (by decide) h31,
    Nat.factorization_factorial (p := 37) (by decide) h37]

set_option maxRecDepth 100000 in
set_option trace.profiler.threshold 1000 in
set_option trace.profiler true in
private lemma factorialScore_nonneg_bounded :
    ∀ k : Fin 164, 0 ≤ factorialScore k := by
  decide

private lemma score_factorial_nonneg (k : ℕ) (hk : k ≤ 163) :
    0 ≤ score k.factorial := by
  rw [score_factorial_eq k hk]
  exact factorialScore_nonneg_bounded ⟨k, by omega⟩

private lemma factorial_164_factorization_two :
    (Nat.factorial 164).factorization 2 = 161 := by
  have hlog : Nat.log 2 164 < 8 :=
    Nat.log_lt_of_lt_pow (by norm_num) (by norm_num)
  rw [Nat.factorization_factorial (p := 2) (by decide) hlog]
  decide

private lemma factorial_index_le_163 (k : ℕ)
    (hk : k.factorial ∣ Nat.lcmUpto (5 ^ 69)) : k ≤ 163 := by
  by_contra hbound
  have h164k : 164 ≤ k := by omega
  have hleft := (Nat.factorization_le_iff_dvd
    (Nat.factorial_ne_zero 164) (Nat.factorial_ne_zero k)).2
      (Nat.factorial_dvd_factorial h164k) 2
  have hright := (Nat.factorization_le_iff_dvd
    (Nat.factorial_ne_zero k) (Nat.lcmUpto_ne_zero (5 ^ 69))).2 hk 2
  rw [factorial_164_factorization_two] at hleft
  rw [lcm_factorization_two] at hright
  omega

private lemma score_factorial_multiset_nonneg (l : Multiset ℕ)
    (hbound : ∀ k ∈ l, k ≤ 163) :
    0 ≤ score (l.map Nat.factorial).prod := by
  induction l using Multiset.induction_on with
  | empty => simp [score]
  | @cons k l ih =>
      have hk : k ≤ 163 := hbound k (by simp)
      have hl : ∀ m ∈ l, m ≤ 163 := by
        intro m hm
        exact hbound m (by simp [hm])
      have hprod : (l.map Nat.factorial).prod ≠ 0 := by
        apply Multiset.prod_ne_zero
        simp only [Multiset.mem_map, not_exists, not_and]
        intro m _
        exact Nat.factorial_ne_zero m
      rw [Multiset.map_cons, Multiset.prod_cons,
        score_mul (Nat.factorial_ne_zero k) hprod]
      exact add_nonneg (score_factorial_nonneg k hk) (ih hl)

private lemma factorization_primorial (p q : ℕ) (hp : Nat.Prime p) :
    (primorial q).factorization p = if p ≤ q then 1 else 0 := by
  by_cases hpq : p ≤ q
  · rw [if_pos hpq]
    exact Nat.factorization_eq_one_of_squarefree
      (squarefree_primorial q) hp (hp.dvd_primorial_iff.mpr hpq)
  · rw [if_neg hpq]
    apply Nat.factorization_eq_zero_of_not_dvd
    exact hpq ∘ hp.dvd_primorial_iff.mp

private lemma factorization_primorial_product (S : Finset ℕ) (p : ℕ)
    (hp : Nat.Prime p) :
    ((∏ q ∈ S, primorial q).factorization p) = (S.filter (p ≤ ·)).card := by
  rw [Nat.factorization_prod_apply]
  · simp [factorization_primorial p, hp]
  · intro q hq
    exact primorial_ne_zero q

private lemma primorial_product_gap (S : Finset ℕ)
    (hS : ∀ q ∈ S, Nat.Prime q) (p r : ℕ)
    (hp : Nat.Prime p) (hr : Nat.Prime r) (hpr : p < r)
    (hnext : ∀ q, Nat.Prime q → p ≤ q → q < r → q = p) :
    let P := ∏ q ∈ S, primorial q
    P.factorization r ≤ P.factorization p ∧
      P.factorization p ≤ P.factorization r + 1 := by
  classical
  dsimp only
  rw [factorization_primorial_product S p hp,
    factorization_primorial_product S r hr]
  constructor
  · apply Finset.card_le_card
    intro q hq
    simp only [Finset.mem_filter] at hq ⊢
    exact ⟨hq.1, hpr.le.trans hq.2⟩
  · calc
      (S.filter (p ≤ ·)).card ≤
          (insert p (S.filter (r ≤ ·))).card := Finset.card_le_card (by
        intro q hq
        simp only [Finset.mem_filter] at hq
        by_cases hrq : r ≤ q
        · exact Finset.mem_insert_of_mem (by
            simp only [Finset.mem_filter]
            exact ⟨hq.1, hrq⟩)
        · have hqp : q = p := hnext q (hS q hq.1) hq.2 (lt_of_not_ge hrq)
          simpa [hqp])
      _ ≤ (S.filter (r ≤ ·)).card + 1 := Finset.card_insert_le _ _

private lemma score_primorial_product_ge (S : Finset ℕ)
    (hS : ∀ q ∈ S, Nat.Prime q) :
    (-63 : ℤ) ≤ score (∏ q ∈ S, primorial q) := by
  have h23 := primorial_product_gap S hS 2 3 (by decide) (by decide)
    (by norm_num) (by omega)
  have h35 := primorial_product_gap S hS 3 5 (by decide) (by decide)
    (by norm_num) (by
      intro q hq h3 h5
      interval_cases q <;> norm_num at hq <;> omega)
  have h57 := primorial_product_gap S hS 5 7 (by decide) (by decide)
    (by norm_num) (by
      intro q hq h5 h7
      interval_cases q <;> norm_num at hq <;> omega)
  have h711 := primorial_product_gap S hS 7 11 (by decide) (by decide)
    (by norm_num) (by
      intro q hq h7 h11
      interval_cases q <;> norm_num at hq <;> omega)
  have h1113 := primorial_product_gap S hS 11 13 (by decide) (by decide)
    (by norm_num) (by
      intro q hq h11 h13
      interval_cases q <;> norm_num at hq <;> omega)
  have h1317 := primorial_product_gap S hS 13 17 (by decide) (by decide)
    (by norm_num) (by
      intro q hq h13 h17
      interval_cases q <;> norm_num at hq <;> omega)
  have h1719 := primorial_product_gap S hS 17 19 (by decide) (by decide)
    (by norm_num) (by
      intro q hq h17 h19
      interval_cases q <;> norm_num at hq <;> omega)
  have h1923 := primorial_product_gap S hS 19 23 (by decide) (by decide)
    (by norm_num) (by
      intro q hq h19 h23
      interval_cases q <;> norm_num at hq <;> omega)
  have h2329 := primorial_product_gap S hS 23 29 (by decide) (by decide)
    (by norm_num) (by
      intro q hq h23 h29
      interval_cases q <;> norm_num at hq <;> omega)
  have h2931 := primorial_product_gap S hS 29 31 (by decide) (by decide)
    (by norm_num) (by
      intro q hq h29 h31
      interval_cases q <;> norm_num at hq <;> omega)
  have h3137 := primorial_product_gap S hS 31 37 (by decide) (by decide)
    (by norm_num) (by
      intro q hq h31 h37
      interval_cases q <;> norm_num at hq <;> omega)
  simp only [score]
  omega

/-- The prefix lcm at the prime power `5^69` refutes the proposed factorization
as a product of factorials and a product of distinct primorials. -/
theorem prefixLcm_5_pow_69_not_factorial_mul_distinctPrimorial :
    ¬ ∃ J P : ℕ, IsFactorialProduct J ∧ IsDistinctPrimorialProduct P ∧
      Nat.lcmUpto (5 ^ 69) = J * P := by
  rintro ⟨J, P, ⟨l, hJ⟩, ⟨S, hS, hP⟩, hproduct⟩
  have hJ0 : J ≠ 0 := by
    rw [hJ]
    apply Multiset.prod_ne_zero
    intro hzero
    rcases Multiset.mem_map.mp hzero with ⟨k, _, hk⟩
    exact Nat.factorial_ne_zero k hk
  have hP0 : P ≠ 0 := by
    rw [hP]
    exact Finset.prod_ne_zero_iff.mpr fun q hq ↦ primorial_ne_zero q
  have hbound : ∀ k ∈ l, k ≤ 163 := by
    intro k hk
    apply factorial_index_le_163
    have hkJ : k.factorial ∣ J := by
      rw [hJ]
      exact Multiset.dvd_prod (Multiset.mem_map.mpr ⟨k, hk, rfl⟩)
    rw [hproduct]
    exact hkJ.trans (dvd_mul_right J P)
  have hJscore : 0 ≤ score J := by
    rw [hJ]
    exact score_factorial_multiset_nonneg l hbound
  have hPscore : (-63 : ℤ) ≤ score P := by
    rw [hP]
    exact score_primorial_product_ge S hS
  have hadd : score (Nat.lcmUpto (5 ^ 69)) = score J + score P := by
    rw [hproduct, score_mul hJ0 hP0]
  rw [score_lcm] at hadd
  omega

/-- The certified prime-power instance refutes the universal factorization claim. -/
theorem not_forall_prime_pow_lcmUpto_factorial_mul_distinctPrimorial :
    ¬ ∀ X : ℕ, IsPrimePow X →
      ∃ J P : ℕ, IsFactorialProduct J ∧ IsDistinctPrimorialProduct P ∧
        Nat.lcmUpto X = J * P := by
  intro hforall
  apply prefixLcm_5_pow_69_not_factorial_mul_distinctPrimorial
  exact hforall (5 ^ 69)
    (Nat.prime_five.isPrimePow.pow (by norm_num : 69 ≠ 0))

#print axioms IsFactorialProduct
#print axioms IsDistinctPrimorialProduct
#print axioms prefixLcm_5_pow_69_not_factorial_mul_distinctPrimorial
#print axioms not_forall_prime_pow_lcmUpto_factorial_mul_distinctPrimorial

end D5.S3.Factorization.PrefixLcmNotFactorialPrimorial
