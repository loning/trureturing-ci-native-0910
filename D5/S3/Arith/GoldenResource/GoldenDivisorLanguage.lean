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

/-- The four active primes of the full window at 5040. -/
def primes5040 : Finset Nat := {2, 3, 5, 7}

/-- The window lengths at the four primes are three, two, one, and one. -/
def lengths5040 (p : primes5040) : Nat := if p.val = 2 then 3 else if p.val = 3 then 2 else 1

private theorem primes_5040_prime : ∀ p ∈ primes5040, Nat.Prime p := by decide

/-- The prescribed Fibonacci exponents give the integer 5040. -/
theorem full_window_5040 : fullWindow primes5040 lengths5040 = 5040 := by decide

private def fourNamesEquiv : (∀ p : primes5040, GoldenName (lengths5040 p)) ≃
    GoldenName 3 × GoldenName 2 × GoldenName 1 × GoldenName 1 where
  toFun f := (f ⟨2, by decide⟩, f ⟨3, by decide⟩, f ⟨5, by decide⟩, f ⟨7, by decide⟩)
  invFun t p := by
    by_cases h2 : p.val = 2
    · simpa [lengths5040, h2] using t.1
    by_cases h3 : p.val = 3
    · simpa [lengths5040, h2, h3] using t.2.1
    by_cases h5 : p.val = 5
    · simpa [lengths5040, h2, h3] using t.2.2.1
    simpa [lengths5040, h2, h3] using t.2.2.2
  left_inv f := by
    funext ⟨p, hp⟩
    simp only [primes5040, Finset.mem_insert, Finset.mem_singleton] at hp
    rcases hp with rfl | rfl | rfl | rfl <;> rfl
  right_inv t := by rfl

/-- The divisor language at 5040 has the four stated golden-name factors. -/
theorem divisor_5040_golden_equiv :
    Nonempty (Div 5040 ≃ GoldenName 3 × GoldenName 2 × GoldenName 1 × GoldenName 1) := by
  obtain ⟨e⟩ := full_window_divisor_golden_equiv primes5040 primes_5040_prime lengths5040
  rw [full_window_5040] at e
  exact ⟨e.trans fourNamesEquiv⟩

/-- There are sixty positive divisors of 5040. -/
theorem divisor_5040_card : Nat.card (Div 5040) = 60 := by
  rw [← full_window_5040, full_window_divisor_card _ primes_5040_prime]
  decide

/-- Round an exponent down to the preceding Fibonacci window endpoint. -/
def b (a : Nat) : Nat := Nat.fib (Nat.greatestFib (a + 1)) - 1

/-- Zero has zero observed exponent. -/
theorem b_zero : b 0 = 0 := by decide

/-- Observation never increases an exponent. -/
theorem b_le (a : Nat) : b a ≤ a := by
  have := Nat.fib_greatestFib_le (a + 1)
  unfold b
  omega

/-- The exponent observation is monotone. -/
theorem b_monotone : Monotone b := fun _ _ hab =>
  Nat.sub_le_sub_right (Nat.fib_mono (Nat.greatestFib_mono (Nat.add_le_add_right hab 1))) 1

/-- An observed exponent is already a window endpoint. -/
theorem b_idempotent (a : Nat) : b (b a) = b a := by
  have hk : 2 ≤ Nat.greatestFib (a + 1) := Nat.le_greatestFib.mpr (by simp)
  have hf : 1 ≤ Nat.fib (Nat.greatestFib (a + 1)) := Nat.fib_pos.mpr (by omega)
  unfold b
  rw [Nat.sub_add_cancel hf, Nat.greatestFib_fib (by omega)]

/-- Observe a positive integer by rounding each prime exponent. -/
def Gobs (n : PNat) : Nat := n.val.factorization.prod (fun p a => p ^ b a)

/-- Prime-power reconstruction keeps the observed integer positive. -/
theorem Gobs_pos (n : PNat) : 0 < Gobs n :=
  Finset.prod_pos fun _p hp => pow_pos (Nat.prime_of_mem_primeFactors hp).pos _

/-- Every prime component of the observed factorization is the rounded component. -/
theorem Gobs_factorization (n : PNat) (p : Nat) :
    (Gobs n).factorization p = b (n.val.factorization p) := by
  let f := n.val.factorization.mapRange b b_zero
  have hf : f ≤ n.val.factorization := fun q => b_le (n.val.factorization q)
  have hprod : f.prod (fun p a => p ^ a) = Gobs n := by
    simp [f, Finsupp.prod_mapRange_index, Gobs]
  rw [← hprod, Nat.factorization_prod_pow_eq_self_of_le_factorization hf]
  rfl

/-- The observed integer divides the original integer. -/
theorem Gobs_dvd (n : PNat) : Gobs n ∣ n.val := by
  apply (Nat.factorization_le_iff_dvd (Gobs_pos n).ne' n.pos.ne').mp
  intro p
  rw [Gobs_factorization]
  exact b_le _

/-- Observing an observed positive integer leaves it unchanged. -/
theorem Gobs_idempotent (n : PNat) : Gobs ⟨Gobs n, Gobs_pos n⟩ = Gobs n := by
  apply Nat.eq_of_factorization_eq (Gobs_pos _).ne' (Gobs_pos n).ne'
  intro p
  calc
    _ = b ((Gobs n).factorization p) :=
      Gobs_factorization (⟨Gobs n, Gobs_pos n⟩ : PNat) p
    _ = b (b (n.val.factorization p)) := congrArg b (Gobs_factorization n p)
    _ = b (n.val.factorization p) := b_idempotent _
    _ = _ := (Gobs_factorization n p).symm

private theorem b_eq_zero (a : Nat) : b a = 0 ↔ a = 0 := by
  constructor
  · intro h
    by_contra ha
    have hm := b_monotone (show 1 ≤ a by omega)
    have hb : b 1 = 1 := by decide
    omega
  · rintro rfl
    exact b_zero

private theorem b_eq_one (a : Nat) : b a = 1 ↔ a = 1 := by
  constructor
  · intro h
    have hlo := b_le a
    have hhi : a < 2 := by
      by_contra ha
      have hm := b_monotone (show 2 ≤ a by omega)
      have hb : b 2 = 2 := by decide
      omega
    omega
  · rintro rfl
    decide

private theorem b_eq_two (a : Nat) : b a = 2 ↔ 2 ≤ a ∧ a ≤ 3 := by
  constructor
  · intro h
    have hlo := b_le a
    have hhi : a < 4 := by
      by_contra ha
      have hm := b_monotone (show 4 ≤ a by omega)
      have hb : b 4 = 4 := by decide
      omega
    omega
  · rintro ⟨hlo, hhi⟩
    interval_cases a <;> decide

private theorem b_eq_four (a : Nat) : b a = 4 ↔ 4 ≤ a ∧ a ≤ 6 := by
  constructor
  · intro h
    have hlo := b_le a
    have hhi : a < 7 := by
      by_contra ha
      have hm := b_monotone (show 7 ≤ a by omega)
      have hb : b 7 = 7 := by decide
      omega
    omega
  · rintro ⟨hlo, hhi⟩
    interval_cases a <;> decide

private theorem factorization_5040 (p : Nat) : (5040 : Nat).factorization p =
    if p = 2 then 4 else if p = 3 then 2 else if p = 5 ∨ p = 7 then 1 else 0 := by
  have hf : Nat.fib 5 - 1 = 4 ∧ Nat.fib 4 - 1 = 2 ∧ Nat.fib 3 - 1 = 1 := by decide
  by_cases hp : p ∈ primes5040
  · have he := prime_product_factorization primes5040 primes_5040_prime
      (fun q => Nat.fib (lengths5040 q + 2) - 1) ⟨p, hp⟩
    change (fullWindow primes5040 lengths5040).factorization p = _ at he
    rw [full_window_5040] at he
    simp only [primes5040, Finset.mem_insert, Finset.mem_singleton] at hp
    rcases hp with rfl | rfl | rfl | rfl <;>
      simpa [lengths5040, hf.1, hf.2.1, hf.2.2] using he
  · have he := prime_product_factorization_outside primes5040 primes_5040_prime
      (fun q => Nat.fib (lengths5040 q + 2) - 1) p hp
    change (fullWindow primes5040 lengths5040).factorization p = 0 at he
    rw [full_window_5040] at he
    simp only [primes5040, Finset.mem_insert, Finset.mem_singleton, not_or] at hp
    simpa [hp.1, hp.2.1, hp.2.2.1, hp.2.2.2] using he

private theorem decode_factorization (r : Fin 3 × Fin 2) (p : Nat) :
    (5040 * 2 ^ r.1.val * 3 ^ r.2.val).factorization p =
      (5040 : Nat).factorization p +
        (if 2 = p then r.1.val else 0) + (if 3 = p then r.2.val else 0) := by
  rw [Nat.factorization_mul (by positivity) (by positivity),
    Nat.factorization_mul (by decide) (by positivity)]
  simp [Nat.prime_two.factorization_pow, Nat.prime_three.factorization_pow,
    Finsupp.single_apply]

/-- The six values of the two free exponent coordinates. -/
theorem golden_fiber_5040_decode_image :
    Finset.univ.image (fun r : Fin 3 × Fin 2 => 5040 * 2 ^ r.1.val * 3 ^ r.2.val) =
      ({5040, 10080, 15120, 20160, 30240, 60480} : Finset Nat) := by decide

private theorem decode_observation (r : Fin 3 × Fin 2) :
    Gobs ⟨5040 * 2 ^ r.1.val * 3 ^ r.2.val, by positivity⟩ = 5040 := by
  apply Nat.eq_of_factorization_eq (Gobs_pos _).ne' (by decide)
  intro p
  apply (Gobs_factorization
    (⟨5040 * 2 ^ r.1.val * 3 ^ r.2.val, by positivity⟩ : PNat) p).trans
  change b ((5040 * 2 ^ r.1.val * 3 ^ r.2.val).factorization p) = _
  rw [decode_factorization, factorization_5040]
  by_cases h2 : p = 2
  · subst p
    change b (4 + r.1.val) = 4
    exact (b_eq_four _).mpr (by have := r.1.isLt; omega)
  by_cases h3 : p = 3
  · subst p
    change b (2 + r.2.val) = 2
    exact (b_eq_two _).mpr (by have := r.2.isLt; omega)
  by_cases h57 : p = 5 ∨ p = 7
  · simp [h2, h3, Ne.symm h2, Ne.symm h3, h57, (b_eq_one 1).mpr rfl]
  · simp [h2, h3, Ne.symm h2, Ne.symm h3, h57, b_zero]

/-- The value 5040 is itself a stable observation. -/
theorem Gobs_5040_fixed : Gobs ⟨5040, by decide⟩ = 5040 := by
  have h := decode_observation (⟨1, by decide⟩, ⟨0, by decide⟩)
  have hi := Gobs_idempotent
    (⟨5040 * 2 ^ 1 * 3 ^ 0, by decide⟩ : PNat)
  simpa only [h] using hi

/-- Exactly six positive integers have observed value 5040. -/
theorem golden_fiber_5040 (n : PNat) : Gobs n = 5040 ↔
    n.val ∈ ({5040, 10080, 15120, 20160, 30240, 60480} : Finset Nat) := by
  constructor
  · intro h
    have hd : 5040 ∣ n.val := h ▸ Gobs_dvd n
    have lower := (Nat.factorization_le_iff_dvd (by decide) n.pos.ne').mpr hd
    have hb (p : Nat) : b (n.val.factorization p) = (5040 : Nat).factorization p := by
      rw [← Gobs_factorization, h]
    have h2 := (b_eq_four _).mp (by simpa [factorization_5040] using hb 2)
    have h3 := (b_eq_two _).mp (by simpa [factorization_5040] using hb 3)
    have h5 := (b_eq_one _).mp (by simpa [factorization_5040] using hb 5)
    have h7 := (b_eq_one _).mp (by simpa [factorization_5040] using hb 7)
    have l2 : 4 ≤ n.val.factorization 2 := by simpa [factorization_5040] using lower 2
    have l3 : 2 ≤ n.val.factorization 3 := by simpa [factorization_5040] using lower 3
    let r : Fin 3 × Fin 2 :=
      (⟨n.val.factorization 2 - 4, by omega⟩, ⟨n.val.factorization 3 - 2, by omega⟩)
    have hn : 5040 * 2 ^ r.1.val * 3 ^ r.2.val = n.val := by
      apply Nat.eq_of_factorization_eq (by positivity) n.pos.ne'
      intro p
      rw [decode_factorization, factorization_5040]
      by_cases hp2 : p = 2
      · subst p
        simp [r, Nat.add_sub_of_le l2]
      by_cases hp3 : p = 3
      · subst p
        simp [r, Nat.add_sub_of_le l3]
      by_cases hp5 : p = 5
      · subst p
        simp [h5]
      by_cases hp7 : p = 7
      · subst p
        simp [h7]
      have hz : n.val.factorization p = 0 := (b_eq_zero _).mp
        (by simpa [factorization_5040, hp2, hp3, hp5, hp7] using hb p)
      simp [hp2, hp3, hp5, hp7, Ne.symm hp2, Ne.symm hp3, hz]
    rw [← golden_fiber_5040_decode_image]
    exact Finset.mem_image.mpr ⟨r, Finset.mem_univ r, hn⟩
  · intro hn
    by_cases hbase : n.val = 5040
    · have he : n = (⟨5040, by decide⟩ : PNat) := Subtype.ext hbase
      exact he ▸ Gobs_5040_fixed
    rw [← golden_fiber_5040_decode_image] at hn
    obtain ⟨r, _, hr⟩ := Finset.mem_image.mp hn
    have he : n = (⟨5040 * 2 ^ r.1.val * 3 ^ r.2.val, by positivity⟩ : PNat) :=
      Subtype.ext hr.symm
    exact he ▸ decode_observation r

example : ∀ p ∈ primes5040, Nat.Prime p := primes_5040_prime
example : Div 5040 := ⟨⟨1, by decide⟩, by decide⟩
example : ∀ p ∈ (∅ : Finset Nat), Nat.Prime p := by simp
example : ∀ p : primes5040, Fin (Nat.fib (lengths5040 p + 2)) :=
  fun p => ⟨0, Nat.fib_pos.mpr (by omega)⟩

#print axioms full_window_divisor_exponent_equiv
#print axioms full_window_divisor_card
#print axioms full_window_divisor_golden_equiv
#print axioms full_window_5040
#print axioms divisor_5040_golden_equiv
#print axioms divisor_5040_card
#print axioms b_zero
#print axioms b_le
#print axioms b_monotone
#print axioms b_idempotent
#print axioms Gobs_pos
#print axioms Gobs_factorization
#print axioms Gobs_dvd
#print axioms Gobs_idempotent
#print axioms golden_fiber_5040_decode_image
#print axioms Gobs_5040_fixed
#print axioms golden_fiber_5040

end D5.S3.Arith.GoldenResource.GoldenDivisorLanguage
