/- GID: D5/S3/Factorization/A091259Cancellation
   generality: I
   mirror-B: D5/B/S3/Factorization/A091259Cancellation
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Denominators with only one-mod-three divisors preserve reduced numerator residues. -/

import Mathlib.Data.Nat.Factorization.Induction
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

namespace D5.S3.Factorization.A091259Cancellation

theorem mod_three_of_prime_divisors (n : ℕ) (hn : n ≠ 0)
    (h : ∀ p, p.Prime → p ∣ n → p % 3 = 1) : n % 3 = 1 := by
  induction n using induction_on_primes with
  | zero => exact (hn rfl).elim
  | one => rfl
  | prime_mul p a hp ih =>
      have ha : a ≠ 0 := by intro ha; simp [ha] at hn
      rw [Nat.mul_mod, h p hp (dvd_mul_right p a),
        ih ha (fun q hq hqa => h q hq (dvd_mul_of_dvd_right hqa p))]

theorem divisors_mul_mod_three {a b : ℕ}
    (ha : ∀ d, d ∣ a → d % 3 = 1) (hb : ∀ d, d ∣ b → d % 3 = 1) :
    ∀ d, d ∣ a * b → d % 3 = 1 := by
  have ha0 : a ≠ 0 := by intro h; simpa [h] using ha a dvd_rfl
  have hb0 : b ≠ 0 := by intro h; simpa [h] using hb b dvd_rfl
  intro d hd
  apply mod_three_of_prime_divisors d (ne_zero_of_dvd_ne_zero (mul_ne_zero ha0 hb0) hd)
  intro p hp hpd
  rcases hp.dvd_mul.mp (hpd.trans hd) with hpa | hpb
  · exact ha p hpa
  · exact hb p hpb

/-- Cancellation removes only divisors of the supplied denominator, all congruent to one. -/
theorem reduced_numerator_mod_three {a b A B : ℕ} (hb : 0 < b)
    (hB : ∀ d, d ∣ B → d % 3 = 1) (hcross : a * B = b * A) :
    (a / Nat.gcd a b) % 3 = A % 3 := by
  let g := Nat.gcd a b
  let x := a / g
  let y := b / g
  have hg : 0 < g := Nat.gcd_pos_of_pos_right a hb
  have hgA : g * x = a := Nat.mul_div_cancel' (Nat.gcd_dvd_left a b)
  have hgB : g * y = b := Nat.mul_div_cancel' (Nat.gcd_dvd_right a b)
  have hxy : x * B = y * A := by
    apply Nat.eq_of_mul_eq_mul_left hg
    calc
      g * (x * B) = a * B := by rw [← mul_assoc, hgA]
      _ = b * A := hcross
      _ = g * (y * A) := by rw [← mul_assoc, hgB]
  have hc : Nat.Coprime x y := Nat.coprime_div_gcd_div_gcd hg
  have hyB : y ∣ B := hc.symm.dvd_mul_left.mp (hxy ▸ dvd_mul_right y A)
  obtain ⟨t, ht⟩ := hyB
  have hy : 0 < y := by
    apply Nat.pos_of_ne_zero
    intro h
    rw [h, mul_zero] at hgB
    omega
  have hA : A = x * t := by
    apply Nat.eq_of_mul_eq_mul_left hy
    rw [← hxy, ht]
    ac_rfl
  have htmod : t % 3 = 1 := hB t (ht ▸ dvd_mul_left t y)
  change x % 3 = A % 3
  rw [hA, Nat.mul_mod, htmod, mul_one, Nat.mod_mod]

#print axioms mod_three_of_prime_divisors
#print axioms divisors_mul_mod_three
#print axioms reduced_numerator_mod_three

end D5.S3.Factorization.A091259Cancellation
