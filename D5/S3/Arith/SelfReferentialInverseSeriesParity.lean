/- GID: D5/S3/Arith/SelfReferentialInverseSeriesParity
   generality: I
   mirror-B: D5/B/S3/Arith/SelfReferentialInverseSeriesParity
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: Parity separation reduces A393170's inverse conditions to an Artin-Schreier equation. -/

import D5.S3.Arith.ArtinSchreierTracePowersOfTwo
import Mathlib.RingTheory.PowerSeries.Inverse

set_option autoImplicit false
set_option relaxedAutoImplicit false

open PowerSeries

namespace D5.S3.Arith.SelfReferentialInverseSeriesParity

private abbrev F2 := ZMod 2
private abbrev reduce := PowerSeries.map (Int.castRingHom F2)

private noncomputable def evenCoefficients (f : PowerSeries F2) : PowerSeries F2 :=
  PowerSeries.mk fun n => coeff (2 * n) f

private noncomputable def oddCoefficients (f : PowerSeries F2) : PowerSeries F2 :=
  PowerSeries.mk fun n => coeff (2 * n + 1) f

private theorem series_two_eq_zero : (2 : PowerSeries F2) = 0 := by
  simpa only [map_ofNat, map_zero] using
    congrArg (C (R := F2)) (CharTwo.two_eq_zero (R := F2))

private theorem reduce_invOfUnit (f : PowerSeries ℤ) (h0 : constantCoeff f = 1) :
    reduce (invOfUnit f 1) = invOfUnit (reduce f) 1 := by
  have hred0 : constantCoeff (reduce f) = 1 := by
    rw [← coeff_zero_eq_constantCoeff, coeff_map, coeff_zero_eq_constantCoeff, h0]
    rfl
  have hu : IsUnit (reduce f) := by
    rw [isUnit_iff_constantCoeff, hred0]
    exact isUnit_one
  apply hu.mul_left_cancel
  have hf := mul_invOfUnit f 1 (by simpa using h0)
  have hred := congrArg reduce hf
  have hred' : reduce f * reduce (invOfUnit f 1) = 1 := by
    simpa only [map_mul, map_one] using hred
  exact hred'.trans (mul_invOfUnit (reduce f) 1 (by simpa using hred0)).symm

private theorem even_expansion (b : PowerSeries F2)
    (h0 : constantCoeff b = 1)
    (heven : ∀ k : ℕ, 0 < k → coeff (2 * k) b = 0) :
    b = 1 + X * PowerSeries.expand 2 (by omega) (oddCoefficients b) := by
  ext n
  induction n using Nat.evenOddRec with
  | h0 => simp [coeff_zero_eq_constantCoeff, h0]
  | h_even n _ =>
      by_cases hn : n = 0
      · subst n
        simp [coeff_zero_eq_constantCoeff, h0]
      · have hz : coeff (2 * n) b = 0 := heven n (Nat.pos_of_ne_zero hn)
        have hshift :
            coeff (2 * n) (X * PowerSeries.expand 2 (by omega) (oddCoefficients b)) = 0 := by
          rw [show X * PowerSeries.expand 2 (by omega) (oddCoefficients b) =
            X ^ 1 * PowerSeries.expand 2 (by omega) (oddCoefficients b) by simp]
          rw [PowerSeries.coeff_X_pow_mul']
          rw [if_pos (by omega : 1 ≤ 2 * n), PowerSeries.coeff_expand]
          rw [if_neg (by omega : ¬2 ∣ 2 * n - 1)]
        simp [hz, hshift, hn]
  | h_odd n _ =>
      simp [oddCoefficients, PowerSeries.coeff_expand]

private theorem odd_expansion (c : PowerSeries F2)
    (hodd : ∀ k : ℕ, coeff (2 * k + 1) c = 0) :
    c = PowerSeries.expand 2 (by omega) (evenCoefficients c) := by
  ext n
  induction n using Nat.evenOddRec with
  | h0 => simp [evenCoefficients]
  | h_even n _ => simp [evenCoefficients, PowerSeries.coeff_expand]
  | h_odd n _ => simp [hodd, PowerSeries.coeff_expand]

private theorem separated_odd_parts
    (u v : PowerSeries F2)
    (h : PowerSeries.expand 2 (by omega) v *
        (1 + X * (1 + X * PowerSeries.expand 2 (by omega) u)) =
      1 + X * PowerSeries.expand 2 (by omega) u) :
    v = u := by
  have h' :
      PowerSeries.expand 2 (by omega) v +
          X * PowerSeries.expand 2 (by omega) v +
          X ^ 2 * PowerSeries.expand 2 (by omega) (v * u) =
        1 + X * PowerSeries.expand 2 (by omega) u := by
    rw [map_mul]
    linear_combination h
  ext n
  have hn := congrArg (coeff (2 * n + 1)) h'
  have hz : coeff (2 * n + 1)
      (X ^ 2 * PowerSeries.expand 2 (by omega) (v * u)) = 0 := by
    rw [PowerSeries.coeff_X_pow_mul']
    by_cases hn0 : n = 0
    · subst n
      simp
    · rw [if_pos (by omega : 2 ≤ 2 * n + 1), PowerSeries.coeff_expand]
      rw [if_neg (by omega : ¬2 ∣ 2 * n + 1 - 2)]
  rw [map_add, map_add, hz] at hn
  simpa [PowerSeries.coeff_expand, pow_two, mul_assoc] using hn

private theorem inverse_parity_relation
    (f b c : PowerSeries F2)
    (hf0 : constantCoeff f = 1)
    (hb : b = invOfUnit f 1)
    (hc : c = invOfUnit (f + X) 1)
    (hbeven : ∀ k : ℕ, 0 < k → coeff (2 * k) b = 0)
    (hcodd : ∀ k : ℕ, coeff (2 * k + 1) c = 0) :
    b = 1 + X * c := by
  have hb0 : constantCoeff b = 1 := by simp [hb]
  let u := oddCoefficients b
  let v := evenCoefficients c
  have hbexp : b = 1 + X * PowerSeries.expand 2 (by omega) u :=
    even_expansion b hb0 hbeven
  have hcexp : c = PowerSeries.expand 2 (by omega) v :=
    odd_expansion c hcodd
  have hbf : b * f = 1 := by
    rw [hb]
    exact invOfUnit_mul f 1 (by simpa using hf0)
  have hcf : c * (f + X) = 1 := by
    rw [hc]
    exact invOfUnit_mul (f + X) 1 (by simpa using hf0)
  have hrel : c * (1 + X * b) = b := by
    calc
      c * (1 + X * b) = c * ((f + X) * b) := by
        congr 1
        rw [add_mul, mul_comm f b, hbf]
      _ = b := by rw [← mul_assoc, hcf, one_mul]
  have huv : v = u := by
    apply separated_odd_parts u v
    simpa only [hbexp, hcexp] using hrel
  rw [hbexp, hcexp, huv]

/-- The inverse-coefficient conditions reduce in characteristic two to `F^2 + F = X`. -/
theorem generating_equation (A : PowerSeries ℤ)
    (h0 : constantCoeff A = 1)
    (hvanish : ∀ n : ℕ, 0 < n →
      coeff n (invOfUnit (A - C (n : ℤ) * X) 1) = 0) :
    (reduce A) ^ 2 + reduce A = X := by
  let f := reduce A
  let b := invOfUnit f 1
  let c := invOfUnit (f + X) 1
  have hf0 : constantCoeff f = 1 := by
    rw [← coeff_zero_eq_constantCoeff, coeff_map, coeff_zero_eq_constantCoeff, h0]
    rfl
  have hbeven : ∀ k : ℕ, 0 < k → coeff (2 * k) b = 0 := by
    intro k hk
    let g := A - C ((2 * k : ℕ) : ℤ) * X
    have hg0 : constantCoeff g = 1 := by simp [g, h0]
    have hkcast : (Int.castRingHom F2) ((2 * k : ℕ) : ℤ) = 0 := by
      change ((((2 * k : ℕ) : ℤ) : F2) = 0)
      apply ZMod.intCast_eq_zero_iff_even.mpr
      exact_mod_cast even_two_mul k
    have hgmap : reduce g = f := by
      change reduce (A - C ((2 * k : ℕ) : ℤ) * X) = reduce A
      rw [map_sub, map_mul, map_C, map_X, hkcast]
      simp
    have hi : reduce (invOfUnit g 1) = b := by
      rw [reduce_invOfUnit g hg0, hgmap]
    have hz := hvanish (2 * k) (by omega)
    have hzc := congrArg (Int.castRingHom F2) hz
    rw [← coeff_map, hi] at hzc
    simpa using hzc
  have hcodd : ∀ k : ℕ, coeff (2 * k + 1) c = 0 := by
    intro k
    let g := A - C ((2 * k + 1 : ℕ) : ℤ) * X
    have hg0 : constantCoeff g = 1 := by simp [g, h0]
    have hkcast : (Int.castRingHom F2) ((2 * k + 1 : ℕ) : ℤ) = 1 := by
      change ((((2 * k + 1 : ℕ) : ℤ) : F2) = 1)
      apply ZMod.intCast_eq_one_iff_odd.mpr
      exact_mod_cast odd_two_mul_add_one k
    have hgmap : reduce g = f + X := by
      change reduce (A - C ((2 * k + 1 : ℕ) : ℤ) * X) = reduce A + X
      rw [map_sub, map_mul, map_C, map_X, hkcast]
      simp only [map_one, one_mul]
      ext n
      exact CharTwo.sub_eq_add _ _
    have hi : reduce (invOfUnit g 1) = c := by
      rw [reduce_invOfUnit g hg0, hgmap]
    have hz := hvanish (2 * k + 1) (by omega)
    have hzc := congrArg (Int.castRingHom F2) hz
    rw [← coeff_map, hi] at hzc
    simpa using hzc
  have hbc : b = 1 + X * c :=
    inverse_parity_relation f b c hf0 rfl rfl hbeven hcodd
  have hbf : b * f = 1 := invOfUnit_mul f 1 (by simpa using hf0)
  have hcf : c * (f + X) = 1 := invOfUnit_mul (f + X) 1 (by simpa using hf0)
  have hone : 1 = f + X * f * c := by
    calc
      1 = b * f := hbf.symm
      _ = (1 + X * c) * f := by rw [hbc]
      _ = f + X * f * c := by ring
  have hquad : f + X = f ^ 2 := by
    calc
      f + X = (f + X) * 1 := by ring
      _ = (f + X) * (f + X * f * c) := by rw [← hone]
      _ = (f + X) * f + X * f * (c * (f + X)) := by ring
      _ = (f + X) * f + X * f := by rw [hcf, mul_one]
      _ = f ^ 2 + (2 : PowerSeries F2) * (X * f) := by ring
      _ = f ^ 2 := by rw [series_two_eq_zero, zero_mul, add_zero]
  change f ^ 2 + f = X
  calc
    f ^ 2 + f = (f + X) + f := by rw [hquad]
    _ = X := by linear_combination f * series_two_eq_zero

/-- The constant-one root of `F^2 + F = X` over `ZMod 2` is unique. -/
theorem generating_unique (F : PowerSeries F2)
    (h0 : constantCoeff F = 1) (hF : F ^ 2 + F = X) :
    F = D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinSeries := by
  let S := D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinSeries
  have hS : S ^ 2 + S = X :=
    D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinSeries_square_add
  have hS0 : constantCoeff S = 1 := by
    simp [S, D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinSeries,
      D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinCoeff]
  have hu : IsUnit (1 + F + S) := by
    rw [isUnit_iff_constantCoeff]
    convert isUnit_one
    simp [h0, hS0, CharTwo.add_self_eq_zero]
  have he : (1 + F + S) * (F - S) = (1 + F + S) * 0 := by
    calc
      (1 + F + S) * (F - S) = (F ^ 2 + F) - (S ^ 2 + S) := by ring
      _ = 0 := by rw [hF, hS, sub_self]
      _ = (1 + F + S) * 0 := by ring
  exact sub_eq_zero.mp (hu.mul_left_cancel he)

/-- Every normalized integer series satisfying the inverse conditions reduces to `artinSeries`. -/
theorem mod_two_identity (A : PowerSeries ℤ)
    (h0 : constantCoeff A = 1)
    (hvanish : ∀ n : ℕ, 0 < n →
      coeff n (invOfUnit (A - C (n : ℤ) * X) 1) = 0) :
    reduce A = D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinSeries :=
  generating_unique (reduce A) (by
    rw [← coeff_zero_eq_constantCoeff, coeff_map, coeff_zero_eq_constantCoeff, h0]
    rfl) (generating_equation A h0 hvanish)

/-- A constant-one root has coefficient one only at zero and powers of two. -/
theorem unit_constant_support (F : PowerSeries F2)
    (h0 : constantCoeff F = 1) (hF : F ^ 2 + F = X) (n : ℕ) :
    coeff n F = 1 ↔ n = 0 ∨ ∃ k : ℕ, n = 2 ^ k := by
  rw [generating_unique F h0 hF]
  by_cases hn : n = 0
  · subst n
    simp [D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinSeries,
      D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinCoeff]
  · have hi := congrArg (coeff n)
      D5.S3.Arith.ArtinSchreierTracePowersOfTwo.reducedSeries_eq_artinSeries
    simp only [coeff_map, coeff_mk] at hi
    rw [← hi]
    change ((D5.S3.Arith.ArtinSchreierTracePowersOfTwo.a n : F2) = 1) ↔
      n = 0 ∨ ∃ k : ℕ, n = 2 ^ k
    rw [ZMod.intCast_eq_one_iff_odd]
    simpa [hn] using
      D5.S3.Arith.ArtinSchreierTracePowersOfTwo.a396808_first_conjecture n
        (Nat.pos_of_ne_zero hn)

/-- OEIS A393170: every positive-index coefficient is odd exactly at powers of two. -/
theorem a393170_conjecture (A : PowerSeries ℤ)
    (h0 : constantCoeff A = 1)
    (hvanish : ∀ n : ℕ, 0 < n →
      coeff n (invOfUnit (A - C (n : ℤ) * X) 1) = 0)
    (n : ℕ) (hn : 0 < n) :
    Odd (coeff n A) ↔ ∃ k : ℕ, n = 2 ^ k := by
  rw [← ZMod.intCast_eq_one_iff_odd]
  have hi := congrArg (coeff n) (mod_two_identity A h0 hvanish)
  simp only [coeff_map] at hi
  change (((coeff n A : ℤ) : F2) =
    coeff n D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinSeries) at hi
  rw [hi]
  have hs := unit_constant_support
    D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinSeries (by
      simp [D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinSeries,
        D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinCoeff])
    D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinSeries_square_add n
  simpa [Nat.ne_of_gt hn] using hs

#print axioms generating_equation
#print axioms generating_unique
#print axioms mod_two_identity
#print axioms unit_constant_support
#print axioms a393170_conjecture

end D5.S3.Arith.SelfReferentialInverseSeriesParity
