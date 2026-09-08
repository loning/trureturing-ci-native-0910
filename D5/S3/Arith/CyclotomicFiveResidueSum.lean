/- GID: D5/S3/Arith/CyclotomicFiveResidueSum
   generality: G
   mirror-B: D5/B/S3/Arith/CyclotomicFiveResidueSum
   mirror-E: none(waiver:symbolic-arithmetic-no-numerical-evidence)
   anchors: []
   utility: none
   digest: Exact sums of units whose fifth cyclotomic value is a unit. -/

import D5.S3.Arith.ChineseRemainder
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Data.Nat.Factorization.Induction
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

namespace D5.S3.Arith.CyclotomicFiveResidueSum

open scoped Classical

def phi5 (u : ℕ) : ℕ := u ^ 4 + u ^ 3 + u ^ 2 + u + 1

def goodUnits (n : ℕ) : Finset ℕ :=
  (Finset.Ico 1 n).filter fun u => Nat.Coprime u n ∧ Nat.Coprime (phi5 u) n

private def admissible (n u : ℕ) : Prop := Nat.Coprime u n ∧ Nat.Coprime (phi5 u) n

private instance (n u : ℕ) : Decidable (admissible n u) :=
  inferInstanceAs (Decidable (Nat.Coprime u n ∧ Nat.Coprime (phi5 u) n))

private def residueSum (n : ℕ) : ℕ :=
  ∑ u ∈ Finset.range n, if admissible n u then u else 0

private theorem residueSum_eq (n : ℕ) : residueSum n = ∑ u ∈ goodUnits n, u := by
  rw [goodUnits, Finset.sum_filter]
  symm
  apply Finset.sum_subset
  · intro u hu
    simp only [Finset.mem_Ico, Finset.mem_range] at *
    exact hu.2
  · intro u hu hnot
    have hu' := Finset.mem_range.mp hu
    have hn' : ¬(1 ≤ u ∧ u < n) := by simpa only [Finset.mem_Ico] using hnot
    have : u = 0 := by omega
    simp [this]

/-- The only zero of the fifth cyclotomic value modulo five is the class one. -/
theorem phi5_mod_five_eq_zero_iff (u : ℕ) : phi5 u % 5 = 0 ↔ u % 5 = 1 := by
  have h : u % 5 < 5 := Nat.mod_lt _ (by decide)
  have hm : phi5 u % 5 = phi5 (u % 5) % 5 := by
    simp [phi5, Nat.add_mod, Nat.pow_mod]
  rw [hm]
  interval_cases hmod : u % 5 <;> norm_num [phi5]

private theorem admissible_five_pow (a u : ℕ) :
    admissible (5 ^ (a + 1)) u ↔ 2 ≤ u % 5 := by
  have hp : Nat.Prime 5 := by decide
  simp only [admissible, Nat.coprime_pow_right_iff (Nat.succ_pos a)]
  rw [Nat.coprime_comm, hp.coprime_iff_not_dvd,
    Nat.coprime_comm (n := phi5 u), hp.coprime_iff_not_dvd,
    Nat.dvd_iff_mod_eq_zero, Nat.dvd_iff_mod_eq_zero, phi5_mod_five_eq_zero_iff]
  omega

private theorem block_sum (q : ℕ) :
    (∑ u ∈ Finset.range (5 * q), if 2 ≤ u % 5 then u else 0) =
      9 * q + 15 * ∑ j ∈ Finset.range q, j := by
  induction q with
  | zero => simp
  | succ q ih =>
    rw [Nat.mul_succ, Finset.sum_range_add, ih, Finset.sum_range_succ]
    norm_num [Finset.sum_range_succ, Nat.add_mod, Nat.mul_mod]
    ring

/-- Exact representative sum for every positive power of five. -/
theorem sum_goodUnits_five_pow (a : ℕ) :
    (∑ u ∈ goodUnits (5 ^ (a + 1)), u) =
      9 * 5 ^ a + 15 * (5 ^ a * (5 ^ a - 1) / 2) := by
  rw [← residueSum_eq]
  simp_rw [residueSum, admissible_five_pow]
  rw [pow_succ', block_sum, Finset.sum_range_id]

private theorem scaled_sum_five_pow_not_dvd (a b : ℕ) (hb : ¬5 ∣ b) :
    ¬5 ^ (a + 1) ∣ b * ∑ u ∈ goodUnits (5 ^ (a + 1)), u := by
  let q := 5 ^ a
  have hq : 0 < q := pow_pos (by decide) _
  have hs : (∑ u ∈ goodUnits (5 ^ (a + 1)), u) =
      9 * q + 15 * ∑ j ∈ Finset.range q, j := by
    rw [sum_goodUnits_five_pow, Finset.sum_range_id]
  have hsum := Finset.sum_range_id_mul_two q
  have hid : 2 * (∑ u ∈ goodUnits (5 ^ (a + 1)), u) = q * (15 * q + 3) := by
    rw [hs]
    have : q - 1 + 1 = q := Nat.sub_add_cancel hq
    nlinarith
  intro h
  have hd : q * 5 ∣ q * (b * (15 * q + 3)) := by
    have hh := dvd_mul_of_dvd_right h 2
    rw [show 2 * (b * ∑ u ∈ goodUnits (5 ^ (a + 1)), u) =
      b * (2 * ∑ u ∈ goodUnits (5 ^ (a + 1)), u) by ring, hid] at hh
    simpa [q, pow_succ, mul_assoc, mul_comm, mul_left_comm] using hh
  have hd' := (Nat.mul_dvd_mul_iff_left hq).mp hd
  have h3 : 5 ∣ b * 3 := by
    have hm := Nat.mod_eq_zero_of_dvd hd'
    apply Nat.dvd_of_mod_eq_zero
    simpa [Nat.mul_mod, Nat.add_mod] using hm
  exact (show Nat.Prime 5 by decide).not_dvd_mul hb (by decide) h3

/-- The conjectured nonvanishing for the entire family of powers of five. -/
theorem residue_sum_five_pow_ne_zero (a : ℕ) :
    (∑ u ∈ goodUnits (5 ^ (a + 1)), u) % (5 ^ (a + 1)) ≠ 0 := by
  simpa using scaled_sum_five_pow_not_dvd a 1 (by decide) ∘ Nat.dvd_of_mod_eq_zero

private def cyclo {R : Type*} [Semiring R] (x : R) : R :=
  x ^ 4 + x ^ 3 + x ^ 2 + x + 1

private def good {R : Type*} [Semiring R] (x : R) : Prop :=
  IsUnit x ∧ IsUnit (cyclo x)

private theorem good_cast (n u : ℕ) : good (u : ZMod n) ↔ admissible n u := by
  unfold good cyclo admissible phi5
  rw [show (u : ZMod n) ^ 4 + (u : ZMod n) ^ 3 + (u : ZMod n) ^ 2 + u + 1 =
    ((u ^ 4 + u ^ 3 + u ^ 2 + u + 1 : ℕ) : ZMod n) by push_cast; rfl]
  simp only [ZMod.isUnit_iff_coprime]

/-- This count includes the unique residue modulo one, as required by CRT. -/
def residueCount (n : ℕ) : ℕ :=
  ∑ u ∈ Finset.range n, if admissible n u then 1 else 0

private theorem sum_zmod {M : Type*} [AddCommMonoid M] (n : ℕ) [NeZero n]
    (f : ℕ → M) : (∑ x : ZMod n, f x.val) = ∑ u ∈ Finset.range n, f u := by
  cases n with
  | zero => exact (NeZero.ne 0 rfl).elim
  | succ n => exact Fin.sum_univ_eq_sum_range f (n + 1)

private theorem count_eq_zmod (n : ℕ) [NeZero n] :
    residueCount n = ∑ x : ZMod n, if good x then 1 else 0 := by
  classical
  rw [residueCount, ← sum_zmod]
  apply Finset.sum_congr rfl
  intro x _
  simp only [← good_cast, ZMod.natCast_zmod_val]

private theorem sum_eq_zmod (n : ℕ) [NeZero n] :
    (residueSum n : ZMod n) = ∑ x : ZMod n, if good x then x else 0 := by
  classical
  simp only [residueSum, Nat.cast_sum, Nat.cast_ite, Nat.cast_zero]
  rw [← sum_zmod]
  apply Finset.sum_congr rfl
  intro x _
  simp only [← good_cast, ZMod.natCast_zmod_val]

private theorem good_crt (m n : ℕ) (h : Nat.Coprime m n) (x : ZMod (m * n)) :
    good x ↔ good ((ZMod.chineseRemainder h x).1) ∧
      good ((ZMod.chineseRemainder h x).2) := by
  let e := ZMod.chineseRemainder h
  have hc : e (cyclo x) = cyclo (e x) := by simp [cyclo]
  rw [good, ← MulEquiv.isUnit_map (f := e),
    ← MulEquiv.isUnit_map (f := e) (x := cyclo x), hc]
  simp only [Prod.isUnit_iff]
  change (IsUnit (e x).1 ∧ IsUnit (e x).2) ∧
    (IsUnit (cyclo (e x).1) ∧ IsUnit (cyclo (e x).2)) ↔
      (IsUnit (e x).1 ∧ IsUnit (cyclo (e x).1)) ∧
        (IsUnit (e x).2 ∧ IsUnit (cyclo (e x).2))
  tauto

/-- CRT multiplies the admissible counts, including the modulus-one endpoint. -/
theorem residueCount_mul (m n : ℕ) [NeZero m] [NeZero n] (h : Nat.Coprime m n) :
    residueCount (m * n) = residueCount m * residueCount n := by
  classical
  rw [count_eq_zmod, count_eq_zmod, count_eq_zmod]
  have hb := ChineseRemainder.chinese_remainder_bijective m n h
  change Function.Bijective (ZMod.chineseRemainder h) at hb
  rw [Fintype.sum_bijective _ hb _
    (fun x : ZMod m × ZMod n => if good x.1 ∧ good x.2 then (1 : ℕ) else 0)
    (fun x => by simp only [good_crt m n h x])]
  rw [Fintype.sum_prod_type]
  simp_rw [show ∀ x : ZMod m, ∀ y : ZMod n,
    (if good x ∧ good y then (1 : ℕ) else 0) =
      (if good x then 1 else 0) * (if good y then 1 else 0) by
        intro x y; split_ifs <;> simp_all]
  simp only [Finset.sum_mul, Finset.mul_sum]
  exact Finset.sum_comm

/-- Projecting the sum through CRT gives each first-factor residue equal multiplicity. -/
theorem sum_goodUnits_mul_cast (m n : ℕ) [NeZero m] [NeZero n] (h : Nat.Coprime m n) :
    ((∑ u ∈ goodUnits (m * n), u : ℕ) : ZMod m) =
      residueCount n * ((∑ u ∈ goodUnits m, u : ℕ) : ZMod m) := by
  classical
  let e := ZMod.chineseRemainder h
  let f : ZMod (m * n) →+* ZMod m := (RingHom.fst _ _).comp e.toRingHom
  have hs := congrArg f (sum_eq_zmod (m * n))
  simp only [map_natCast, map_sum, apply_ite, map_zero] at hs
  rw [← residueSum_eq, ← residueSum_eq, hs, sum_eq_zmod]
  have hc : (residueCount n : ZMod m) =
      ∑ y : ZMod n, if good y then 1 else 0 := by
    rw [count_eq_zmod]
    simp only [Nat.cast_sum, Nat.cast_ite, Nat.cast_one, Nat.cast_zero]
  rw [hc]
  have hb := ChineseRemainder.chinese_remainder_bijective m n h
  change Function.Bijective e at hb
  rw [Fintype.sum_bijective _ hb _
    (fun x : ZMod m × ZMod n => if good x.1 ∧ good x.2 then x.1 else 0)
    (fun x => by simp only [good_crt m n h x]; rfl)]
  rw [Fintype.sum_prod_type]
  have hi (x : ZMod m) (y : ZMod n) :
      (if good x ∧ good y then x else 0) =
        (if good x then x else 0) * (if good y then 1 else 0) := by
    split_ifs <;> simp_all
  simp_rw [hi]
  rw [mul_comm]
  simp only [Finset.sum_mul, Finset.mul_sum]
  exact Finset.sum_comm

private theorem admissible_period (p k u : ℕ) :
    admissible p (p * k + u) ↔ admissible p u := by
  rw [← good_cast, ← good_cast]
  simp

private theorem count_blocks (p k : ℕ) :
    (∑ u ∈ Finset.range (p * k), if admissible p u then 1 else 0) =
      k * residueCount p := by
  induction k with
  | zero => simp
  | succ k ih =>
    rw [Nat.mul_succ, Finset.sum_range_add, ih]
    simp only [admissible_period]
    change k * residueCount p + residueCount p = (k + 1) * residueCount p
    ring

/-- Every admissible residue modulo a prime has equally many lifts to each positive power. -/
theorem residueCount_pow (p a : ℕ) :
    residueCount (p ^ (a + 1)) = p ^ a * residueCount p := by
  unfold residueCount
  simp only [admissible, Nat.coprime_pow_right_iff (Nat.succ_pos a)]
  change (∑ u ∈ Finset.range (p ^ (a + 1)), if admissible p u then 1 else 0) = _
  rw [pow_succ', count_blocks]
  rfl

#print axioms phi5_mod_five_eq_zero_iff
#print axioms sum_goodUnits_five_pow
#print axioms residue_sum_five_pow_ne_zero
#print axioms residueCount_mul
#print axioms sum_goodUnits_mul_cast
#print axioms residueCount_pow

end D5.S3.Arith.CyclotomicFiveResidueSum
