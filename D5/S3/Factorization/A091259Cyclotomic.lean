/- GID: D5/S3/Factorization/A091259Cyclotomic
   generality: I
   mirror-B: D5/B/S3/Factorization/A091259Cyclotomic
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Removing the unique possible factor of three leaves only one-mod-three divisors. -/

import D5.S3.Factorization.A091259Cancellation
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.Tactic.Positivity

namespace D5.S3.Factorization.A091259Cyclotomic

open D5.S3.Factorization.A091259Cancellation

def cyclotomicThree (t : ℕ) : ℕ := t ^ 2 + t + 1

theorem cyclotomicThree_mod (t : ℕ) :
    cyclotomicThree t % 3 = if t % 3 = 1 then 0 else 1 := by
  have h : t % 3 = 0 ∨ t % 3 = 1 ∨ t % 3 = 2 := by omega
  rcases h with h | h | h <;>
    simp [cyclotomicThree, Nat.add_mod, Nat.pow_mod, h]

theorem cyclotomicThree_div_three (t : ℕ) (ht : t % 3 = 1) :
    3 ∣ cyclotomicThree t ∧ (cyclotomicThree t / 3) % 3 = 1 := by
  have heq : t = 3 * (t / 3) + 1 := by omega
  have hpoly : cyclotomicThree t = 3 * (1 + 3 * (t / 3) + 3 * (t / 3) ^ 2) := by
    unfold cyclotomicThree
    conv_lhs => rw [heq]
    ring
  rw [hpoly]
  constructor
  · exact dvd_mul_right _ _
  · simp [Nat.add_mod]

theorem cyclotomicThree_prime_divisor {t q : ℕ} (hq : q.Prime)
    (hqt : q ∣ cyclotomicThree t) (hq3 : q ≠ 3) : q % 3 = 1 := by
  let : Fact q.Prime := ⟨hq⟩
  let : Fact (Nat.Prime 3) := ⟨by decide⟩
  have hz : (t : ZMod q) ^ 2 + t + 1 = 0 := by
    have h := (ZMod.natCast_eq_zero_iff (cyclotomicThree t) q).2 hqt
    simpa [cyclotomicThree] using h
  have ht0 : (t : ZMod q) ≠ 0 := by intro h; simp [h] at hz
  have ht1 : (t : ZMod q) ≠ 1 := by
    intro h
    have h3 : (3 : ZMod q) = 0 := by
      convert hz using 1
      rw [h]
      ring
    have hd : q ∣ 3 := (ZMod.natCast_eq_zero_iff 3 q).1 h3
    exact hq3 ((Nat.dvd_prime (by decide : Nat.Prime 3)).1 hd |>.resolve_left hq.ne_one)
  have hc : (t : ZMod q) ^ 3 = 1 := by
    apply sub_eq_zero.mp
    calc
      (t : ZMod q) ^ 3 - 1 = (t - 1) * (t ^ 2 + t + 1) := by ring
      _ = 0 := by rw [hz, mul_zero]
  have ho : orderOf (t : ZMod q) = 3 := orderOf_eq_prime hc ht1
  have hd := ZMod.orderOf_dvd_card_sub_one ht0
  rw [ho] at hd
  have hm := Nat.mod_eq_zero_of_dvd hd
  have := hq.two_le
  omega

def strippedThree (t : ℕ) : ℕ :=
  cyclotomicThree t / (if t % 3 = 1 then 3 else 1)

/-- The removed factor of three is exact; every remaining prime divisor is one modulo three. -/
theorem strippedThree_divisors (t : ℕ) :
    ∀ d, d ∣ strippedThree t → d % 3 = 1 := by
  have hm : strippedThree t % 3 = 1 := by
    by_cases ht : t % 3 = 1
    · simpa [strippedThree, ht] using (cyclotomicThree_div_three t ht).2
    · simp [strippedThree, ht, cyclotomicThree_mod]
  have hn : strippedThree t ≠ 0 := by intro h; simp [h] at hm
  have hd : strippedThree t ∣ cyclotomicThree t := by
    unfold strippedThree
    split
    · exact Nat.div_dvd_of_dvd (cyclotomicThree_div_three t ‹_›).1
    · simp
  intro d hdt
  apply mod_three_of_prime_divisors d (ne_zero_of_dvd_ne_zero hn hdt)
  intro q hq hqd
  apply cyclotomicThree_prime_divisor hq (hqd.trans (hdt.trans hd))
  intro heq
  subst q
  have hzero := Nat.mod_eq_zero_of_dvd (hqd.trans hdt)
  omega

#print axioms cyclotomicThree_mod
#print axioms cyclotomicThree_div_three
#print axioms cyclotomicThree_prime_divisor
#print axioms strippedThree_divisors

end D5.S3.Factorization.A091259Cyclotomic
