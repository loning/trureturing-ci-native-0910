/- GID: D5/S3/Arith/Congruence/PowerResidueRecursionFour
   generality: I
   mirror-B: D5/B/S3/Arith/Congruence/PowerResidueRecursionFour
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: The recursively defined A374911 sequence takes value four exactly at three and nine. -/

import Mathlib.NumberTheory.Multiplicity
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.LinearCombination


namespace D5.S3.Arith.Congruence.PowerResidueRecursionFour

private theorem two_pow_self_mod_ne_one {n : ℕ} (hn : 1 < n) : 2 ^ n % n ≠ 1 := by
  intro h
  let p := n.minFac
  have hp : p.Prime := Nat.minFac_prime (by omega)
  haveI : Fact p.Prime := ⟨hp⟩
  have hm : Nat.ModEq p (2 ^ n) 1 :=
    (show Nat.ModEq n (2 ^ n) 1 by simpa [Nat.ModEq, Nat.mod_eq_of_lt hn] using h).of_dvd
      (Nat.minFac_dvd n)
  have hz : (2 : ZMod p) ^ n = 1 := by
    simpa using (ZMod.natCast_eq_natCast_iff (2 ^ n) 1 p).mpr hm
  have hne : (2 : ZMod p) ≠ 0 := by
    intro heq
    simpa [heq, zero_pow (by omega : n ≠ 0)] using hz
  have hd₁ := orderOf_dvd_of_pow_eq_one hz
  have hd₂ := ZMod.orderOf_dvd_card_sub_one hne
  have hc : n.Coprime (p - 1) := Nat.coprime_of_lt_minFac (by have := hp.two_le; omega)
    (by have := hp.two_le; dsimp [p] at *; omega)
  have hd := Nat.dvd_gcd hd₁ hd₂
  rw [hc.gcd_eq_one] at hd
  have h21 : (2 : ZMod p) = 1 := orderOf_eq_one_iff.mp (Nat.dvd_one.mp hd)
  have h10 : (1 : ZMod p) = 0 := by linear_combination h21
  exact one_ne_zero h10

private theorem three_pow_dvd_two_pow_add_one (k : ℕ) : 3 ^ k ∣ 2 ^ (3 ^ k) + 1 := by
  haveI : Fact (Nat.Prime 3) := ⟨by decide⟩
  have h := padicValNat.pow_add_pow (p := 3) (x := 2) (y := 1)
    (by decide : Odd 3) (by decide) (by decide) ((by decide : Odd 3).pow : Odd (3 ^ k))
  have hv : padicValNat 3 (2 ^ (3 ^ k) + 1) = 1 + k := by
    simpa using h
  apply (padicValNat_dvd_iff_le (by positivity : 2 ^ (3 ^ k) + 1 ≠ 0)).mpr
  omega

end D5.S3.Arith.Congruence.PowerResidueRecursionFour
