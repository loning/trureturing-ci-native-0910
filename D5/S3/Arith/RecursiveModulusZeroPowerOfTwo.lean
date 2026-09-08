/- GID: D5/S3/Arith/RecursiveModulusZeroPowerOfTwo
   generality: I
   mirror-B: none(waiver:formal-unit-only)
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: A coprime modular accumulator reaches zero exactly for powers of two. -/

import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Nat.ModEq

namespace D5.S3.Arith.RecursiveModulusZeroPowerOfTwo

/- The accumulator is indexed from zero: `t = 0` is the source's time `1`.
   Thus `b i j t` here denotes the source value `b(i,j,t+1)`. -/
def S (i j : ℕ) : ℕ → ℕ
  | 0 => i
  | t + 1 => S i j t + S i j t % j

def b (i j t : ℕ) : ℕ := S i j t % j

/-- The accumulator's residue is the doubling closed form at zero-based time `t`.
The source's one-based value `b(i,j,t+1)` is therefore `(2^t * i) mod j`. -/
theorem doubling_identity (i j t : ℕ) :
    S i j t % j = (2 ^ t * i) % j := by
  induction t with
  | zero => simp [S]
  | succ t ih =>
      calc
        S i j (t + 1) % j = (S i j t + S i j t % j) % j := by rfl
        _ = (2 * (S i j t % j)) % j := by
          have h : Nat.ModEq j (S i j t + S i j t % j) (2 * S i j t) := by
            calc
              S i j t + S i j t % j ≡ S i j t + S i j t [MOD j] :=
                (Nat.ModEq.refl _).add (Nat.mod_modEq _ _)
              _ = 2 * S i j t := by rw [two_mul]
          have hres : Nat.ModEq j (2 * S i j t) (2 * (S i j t % j)) :=
            Nat.ModEq.mul_left 2 (Nat.mod_modEq _ _).symm
          exact h.trans hres
        _ = (2 * ((2 ^ t * i) % j)) % j := by rw [ih]
        _ = (2 ^ (t + 1) * i) % j := by
          change Nat.ModEq j (2 * ((2 ^ t * i) % j)) (2 ^ (t + 1) * i)
          have h₁ : Nat.ModEq j (2 * ((2 ^ t * i) % j)) (2 * (2 ^ t * i)) :=
            Nat.ModEq.mul_left 2 (Nat.mod_modEq _ _)
          have h₂ : Nat.ModEq j (2 * (2 ^ t * i)) (2 ^ (t + 1) * i) := by
            rw [pow_succ]
            change (2 * (2 ^ t * i)) % j = ((2 ^ t * 2) * i) % j
            congr 1
            ac_rfl
          exact h₁.trans h₂

/-- If the modulus is a power of two, the zero-based sequence reaches zero. -/
theorem exists_zero_of_eq_pow_two (i j m : ℕ) (hij : j = 2 ^ m) :
    ∃ t : ℕ, b i j t = 0 := by
  refine ⟨m, ?_⟩
  rw [b, doubling_identity, hij]
  simp

/-- A zero in the sequence forces the modulus to be a power of two under coprimality. -/
theorem eq_pow_two_of_exists_zero (i j : ℕ) (hi : 0 < i) (hj : 1 ≤ j)
    (hji : j ≤ i) (hcop : Nat.Coprime i j) (hz : ∃ t : ℕ, b i j t = 0) :
    ∃ m : ℕ, j = 2 ^ m := by
  obtain ⟨t, ht⟩ := hz
  have hmod : (2 ^ t * i) % j = 0 := by
    rw [← doubling_identity]
    exact ht
  have hdvd : j ∣ 2 ^ t * i := Nat.dvd_of_mod_eq_zero hmod
  have hpowdvd : j ∣ 2 ^ t :=
    Nat.Coprime.dvd_of_dvd_mul_right hcop.symm hdvd
  obtain ⟨m, -, hm⟩ := (Nat.dvd_prime_pow Nat.prime_two).mp hpowdvd
  exact ⟨m, hm⟩

/-- For positive `i`, a bounded coprime pair reaches zero exactly when `j` is `2^m`.

The index is zero-based: `t = 0` corresponds to the source's `b(i,j,1)`, so
`∃ t` here is equivalent to the source quantifier `∃ t ≥ 1`. -/
theorem zero_iff_power_of_two (i j : ℕ) (hi : 0 < i) (hj : 1 ≤ j)
    (hji : j ≤ i) (hcop : Nat.Coprime i j) :
    (∃ t : ℕ, b i j t = 0) ↔ ∃ m : ℕ, j = 2 ^ m := by
  constructor
  · exact eq_pow_two_of_exists_zero i j hi hj hji hcop
  · rintro ⟨m, rfl⟩
    exact exists_zero_of_eq_pow_two i (2 ^ m) m rfl

end D5.S3.Arith.RecursiveModulusZeroPowerOfTwo
