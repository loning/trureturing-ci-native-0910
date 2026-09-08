/- GID: D5/S3/Arith/GoldenResource/GoldenCell5040Shape
   generality: G
   mirror-B: D5/B/S3/Arith/GoldenResource/GoldenCell5040Shape
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: [mathlib/module/Mathlib.Data.Nat.Factorization.Basic]
   utility: none
   digest: The power congruence forces prime exponent windows and a coprime residual factor. -/

import Mathlib.Data.Nat.Factorization.Basic
import Mathlib.Data.Nat.ModEq
import Mathlib.Data.ZMod.Basic
import Mathlib.GroupTheory.OrderOfElement
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.NormNum

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S3.Arith.GoldenResource.GoldenCell5040Shape

private theorem three_order_128 : orderOf (3 : ZMod 128) = 32 := by
  apply (orderOf_eq_iff (by decide : 0 < 32)).2
  constructor
  · decide
  · intro k hk hkpos
    interval_cases k <;> decide

private theorem three_order_25 : orderOf (3 : ZMod 25) = 20 := by
  apply (orderOf_eq_iff (by decide : 0 < 20)).2
  constructor
  · decide
  · intro k hk hkpos
    interval_cases k <;> decide

private theorem three_order_49 : orderOf (3 : ZMod 49) = 42 := by
  apply (orderOf_eq_iff (by decide : 0 < 42)).2
  constructor
  · decide
  · intro k hk hkpos
    interval_cases k <;> decide

private theorem residue_one_of_order {n m k : Nat}
    (hmod : Nat.ModEq n (3 ^ n) 2241) (hm : m ∣ n)
    (horder : orderOf (3 : ZMod m) = k) (hk : k ∣ n) : Nat.ModEq m 2241 1 := by
  have hpow : (3 : ZMod m) ^ n = 1 :=
    orderOf_dvd_iff_pow_eq_one.mp (horder ▸ hk)
  have hres : Nat.ModEq m (3 ^ n) 1 :=
    (ZMod.natCast_eq_natCast_iff _ _ _).mp (by
      simpa only [Nat.cast_pow, Nat.cast_ofNat, Nat.cast_one] using hpow)
  exact (hmod.of_dvd hm).symm.trans hres

-- These exclusions apply to every symbolic exponent n, with no search bound on n.
private theorem excluded_prime_powers {n : Nat}
    (h5040 : 5040 ∣ n) (hmod : Nat.ModEq n (3 ^ n) 2241) :
    n ≠ 0 ∧ ¬128 ∣ n ∧ ¬81 ∣ n ∧ ¬25 ∣ n ∧ ¬49 ∣ n ∧ ¬83 ∣ n := by
  have hn : n ≠ 0 := by
    intro hz
    subst n
    norm_num [Nat.ModEq] at hmod
  have hn4 : 4 ≤ n := by
    have := Nat.le_of_dvd (Nat.pos_of_ne_zero hn) h5040
    omega
  refine ⟨hn, ?_, ?_, ?_, ?_, ?_⟩
  · intro hd
    exact (by decide : ¬Nat.ModEq 128 2241 1)
      (residue_one_of_order hmod hd three_order_128
        ((by decide : 32 ∣ 128).trans hd))
  · intro hd
    have hp : 81 ∣ 3 ^ n := pow_dvd_pow (3 : Nat) hn4
    exact (by decide : ¬81 ∣ 2241) ((hmod.dvd_iff hd).mp hp)
  · intro hd
    exact (by decide : ¬Nat.ModEq 25 2241 1)
      (residue_one_of_order hmod hd three_order_25
        ((by decide : 20 ∣ 5040).trans h5040))
  · intro hd
    exact (by decide : ¬Nat.ModEq 49 2241 1)
      (residue_one_of_order hmod hd three_order_49
        ((by decide : 42 ∣ 5040).trans h5040))
  · intro hd
    have hp : 83 ∣ 3 ^ n := (hmod.dvd_iff hd).mpr (by decide)
    exact (by decide : ¬83 ∣ 3) ((by decide : Nat.Prime 83).dvd_of_dvd_pow hp)

/-- The congruence bounds the old prime exponents and excludes the prime 83. -/
theorem modEq_2241_factorization {n : Nat}
    (h5040 : 5040 ∣ n) (hmod : Nat.ModEq n (3 ^ n) 2241) :
    n ≠ 0 ∧ 4 ≤ n.factorization 2 ∧ n.factorization 2 ≤ 6 ∧
      2 ≤ n.factorization 3 ∧ n.factorization 3 ≤ 3 ∧
      n.factorization 5 = 1 ∧ n.factorization 7 = 1 ∧ n.factorization 83 = 0 := by
  obtain ⟨hn, h128, h81, h25, h49, h83⟩ := excluded_prime_powers h5040 hmod
  have h2lo : 4 ≤ n.factorization 2 :=
    (Nat.prime_two.pow_dvd_iff_le_factorization hn).mp
      ((by decide : 2 ^ 4 ∣ 5040).trans h5040)
  have h3lo : 2 ≤ n.factorization 3 :=
    (Nat.prime_three.pow_dvd_iff_le_factorization hn).mp
      ((by decide : 3 ^ 2 ∣ 5040).trans h5040)
  have h5lo : 1 ≤ n.factorization 5 :=
    ((by decide : Nat.Prime 5).dvd_iff_one_le_factorization hn).mp
      ((by decide : 5 ∣ 5040).trans h5040)
  have h7lo : 1 ≤ n.factorization 7 :=
    ((by decide : Nat.Prime 7).dvd_iff_one_le_factorization hn).mp
      ((by decide : 7 ∣ 5040).trans h5040)
  have h2hi : ¬7 ≤ n.factorization 2 := by
    intro h
    exact h128 ((Nat.prime_two.pow_dvd_iff_le_factorization hn).mpr h)
  have h3hi : ¬4 ≤ n.factorization 3 := by
    intro h
    exact h81 ((Nat.prime_three.pow_dvd_iff_le_factorization hn).mpr h)
  have h5hi : ¬2 ≤ n.factorization 5 := by
    intro h
    exact h25 (((by decide : Nat.Prime 5).pow_dvd_iff_le_factorization hn).mpr h)
  have h7hi : ¬2 ≤ n.factorization 7 := by
    intro h
    exact h49 (((by decide : Nat.Prime 7).pow_dvd_iff_le_factorization hn).mpr h)
  exact ⟨hn, h2lo, by omega, h3lo, by omega, by omega, by omega,
    Nat.factorization_eq_zero_of_not_dvd h83⟩

#print axioms modEq_2241_factorization

end D5.S3.Arith.GoldenResource.GoldenCell5040Shape
