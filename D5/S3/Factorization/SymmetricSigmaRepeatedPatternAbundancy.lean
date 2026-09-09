/- GID: D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy
   generality: G
   mirror-B: D5/B/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Paired odd divisors force strict sigma bounds between two and eight-thirds. -/

import Mathlib.Algebra.Ring.GeomSum
import Mathlib.NumberTheory.ArithmeticFunction.Misc
import Mathlib.Tactic.IntervalCases

set_option autoImplicit false
set_option relaxedAutoImplicit false

open scoped BigOperators

namespace D5.S3.Factorization.SymmetricSigmaRepeatedPatternAbundancy

/-!
This module proves a repository-derived conditional theorem from the divisor-form membership
criterion transcribed from Hartmut F. W. Hoft's OEIS A392096 comment dated 2025-12-30. The
comment also asserts equivalence with a symmetric-representation width pattern; that
equivalence is ASSUMED-UNVERIFIED and is not formalized here.
-/

/-- The odd divisors, grouped as consecutive gap-separated pairs. -/
structure DivisorPairs (D q : ℕ) where
  D_pos : 0 < D
  count : ℕ
  count_ge_two : 2 ≤ count
  lower : ℕ → ℕ
  upper : ℕ → ℕ
  lower_zero : lower 0 = 1
  upper_last : upper (count - 1) = q
  divisors_eq : q.divisors =
    (Finset.range count).image lower ∪ (Finset.range count).image upper
  within : ∀ i, i < count → lower i < upper i ∧ upper i < D * lower i
  gap_succ : ∀ i, i + 1 < count → D * upper i < lower (i + 1)

/-- The repository transcription of Hoft's divisor-form membership criterion. -/
def Member (n : ℕ) : Prop :=
  ∃ m q : ℕ, 1 ≤ m ∧ Odd q ∧ n = 2 ^ m * q ∧
    Nonempty (DivisorPairs (2 ^ (m + 1)) q)

namespace DivisorPairs

variable {D q : ℕ} (P : DivisorPairs D q)

private theorem lower_mem (i : ℕ) (hi : i < P.count) : P.lower i ∈ q.divisors := by
  rw [P.divisors_eq]
  exact Finset.mem_union_left _ (Finset.mem_image.mpr ⟨i, Finset.mem_range.mpr hi, rfl⟩)

private theorem upper_mem (i : ℕ) (hi : i < P.count) : P.upper i ∈ q.divisors := by
  rw [P.divisors_eq]
  exact Finset.mem_union_right _ (Finset.mem_image.mpr ⟨i, Finset.mem_range.mpr hi, rfl⟩)

private theorem lower_dvd (_hq : q ≠ 0) (i : ℕ) (hi : i < P.count) : P.lower i ∣ q := by
  exact (Nat.mem_divisors.mp (P.lower_mem i hi)).1

private theorem upper_dvd (_hq : q ≠ 0) (i : ℕ) (hi : i < P.count) : P.upper i ∣ q := by
  exact (Nat.mem_divisors.mp (P.upper_mem i hi)).1

private theorem lower_pos (hq : 0 < q) (i : ℕ) (hi : i < P.count) : 0 < P.lower i :=
  Nat.pos_of_dvd_of_pos (P.lower_dvd hq.ne' i hi) hq

private theorem upper_pos (hq : 0 < q) (i : ℕ) (hi : i < P.count) : 0 < P.upper i :=
  Nat.pos_of_dvd_of_pos (P.upper_dvd hq.ne' i hi) hq

private theorem locate (hq : q ≠ 0) {x : ℕ} (hx : x ∣ q) :
    ∃ i < P.count, P.lower i = x ∨ P.upper i = x := by
  have hxmem : x ∈ q.divisors := Nat.mem_divisors.mpr ⟨hx, hq⟩
  rw [P.divisors_eq] at hxmem
  simp only [Finset.mem_union, Finset.mem_image, Finset.mem_range] at hxmem
  rcases hxmem with ⟨i, hi, rfl⟩ | ⟨i, hi, rfl⟩
  · exact ⟨i, hi, Or.inl rfl⟩
  · exact ⟨i, hi, Or.inr rfl⟩

private theorem lower_lt (i k : ℕ) (hik : i < k) (hk : k < P.count) :
    P.lower i < P.lower k := by
  have hstep : ∀ t, t + 1 < P.count → P.lower t < P.lower (t + 1) := by
    intro t ht
    have hw := (P.within t (by omega)).1
    have hscale := Nat.le_mul_of_pos_left (P.upper t) P.D_pos
    have hg := P.gap_succ t ht
    omega
  have hbase : P.lower i < P.lower (i + 1) := hstep i (by omega)
  have hle : i + 1 ≤ k := by omega
  induction k, hle using Nat.le_induction with
  | base => exact hbase
  | succ k hle ih =>
      exact lt_trans (ih (by omega) (by omega)) (hstep k (by omega))

private theorem gap (i k : ℕ) (hik : i < k) (hk : k < P.count) :
    D * P.upper i < P.lower k := by
  rcases eq_or_lt_of_le (show i + 1 ≤ k by omega) with h | h
  · subst k
    exact P.gap_succ i hk
  · exact (P.gap_succ i (by omega)).trans (P.lower_lt (i + 1) k h hk)

private theorem lower_injective : Set.InjOn P.lower (Finset.range P.count : Set ℕ) := by
  intro i hi k hk heq
  have hi' : i ∈ Finset.range P.count := hi
  have hk' : k ∈ Finset.range P.count := hk
  replace hi := Finset.mem_range.mp hi'
  replace hk := Finset.mem_range.mp hk'
  rcases lt_trichotomy i k with hik | rfl | hki
  · have hw := (P.within i hi).1
    have hg := P.gap i k hik hk
    have hscale := Nat.le_mul_of_pos_left (P.upper i) P.D_pos
    omega
  · rfl
  · have hw := (P.within k hk).1
    have hg := P.gap k i hki hi
    have hscale := Nat.le_mul_of_pos_left (P.upper k) P.D_pos
    omega

private theorem upper_injective : Set.InjOn P.upper (Finset.range P.count : Set ℕ) := by
  intro i hi k hk heq
  have hi' : i ∈ Finset.range P.count := hi
  have hk' : k ∈ Finset.range P.count := hk
  replace hi := Finset.mem_range.mp hi'
  replace hk := Finset.mem_range.mp hk'
  rcases lt_trichotomy i k with hik | rfl | hki
  · have hw := (P.within k hk).1
    have hwi := (P.within i hi).1
    have hg := P.gap i k hik hk
    have hscale := Nat.le_mul_of_pos_left (P.upper i) P.D_pos
    omega
  · rfl
  · have hw := (P.within i hi).1
    have hg := P.gap k i hki hi
    have hscale := Nat.le_mul_of_pos_left (P.upper k) P.D_pos
    omega

private theorem images_disjoint :
    Disjoint ((Finset.range P.count).image P.lower)
      ((Finset.range P.count).image P.upper) := by
  rw [Finset.disjoint_left]
  intro x hxl hxu
  simp only [Finset.mem_image, Finset.mem_range] at hxl hxu
  rcases hxl with ⟨i, hi, rfl⟩
  rcases hxu with ⟨k, hk, heq⟩
  rcases lt_trichotomy i k with hik | rfl | hki
  · have hw := (P.within k hk).1
    have hwi := (P.within i hi).1
    have hg := P.gap i k hik hk
    have hscale := Nat.le_mul_of_pos_left (P.upper i) P.D_pos
    omega
  · exact (P.within i hi).1.ne' heq
  · have hg := P.gap k i hki hi
    have hscale := Nat.le_mul_of_pos_left (P.upper k) P.D_pos
    omega

private theorem sum_divisors_eq :
    ∑ d ∈ q.divisors, d =
      (∑ i ∈ Finset.range P.count, P.lower i) +
        ∑ i ∈ Finset.range P.count, P.upper i := by
  rw [P.divisors_eq, Finset.sum_union P.images_disjoint]
  rw [Finset.sum_image P.lower_injective, Finset.sum_image P.upper_injective]

private theorem minFac_data (hqodd : Odd q) :
    let p := q.minFac
    Nat.Prime p ∧ p = P.upper 0 ∧ p < D ∧ ¬p * p ∣ q := by
  have hq : 0 < q := hqodd.pos
  have hzero : 0 < P.count := lt_of_lt_of_le (by decide) P.count_ge_two
  have hq1 : q ≠ 1 := by
    have hb0dvd := P.upper_dvd hq.ne' 0 hzero
    have hb0 := (P.within 0 hzero).1
    rw [P.lower_zero] at hb0
    intro h
    subst q
    have := Nat.le_of_dvd (by decide : 0 < 1) hb0dvd
    omega
  let p := q.minFac
  have hp : Nat.Prime p := Nat.minFac_prime hq1
  have hpdvd : p ∣ q := Nat.minFac_dvd q
  have hp2 : 2 ≤ p := hp.two_le
  have hb0dvd := P.upper_dvd hq.ne' 0 hzero
  have hb02 : 2 ≤ P.upper 0 := by
    have := (P.within 0 hzero).1
    rw [P.lower_zero] at this
    omega
  have hpleb0 : p ≤ P.upper 0 := Nat.minFac_le_of_dvd hb02 hb0dvd
  obtain ⟨k, hk, hloc⟩ := P.locate hq.ne' hpdvd
  have hpk : k = 0 := by
    by_contra hne
    have hk0 : 0 < k := by omega
    have hg := P.gap 0 k hk0 hk
    have hscale := Nat.le_mul_of_pos_left (P.upper 0) P.D_pos
    rcases hloc with hl | hu
    · rw [hl] at hg
      omega
    · have hw := (P.within k hk).1
      rw [hu] at hw
      omega
  subst k
  have hpb0 : p = P.upper 0 := by
    rcases hloc with hl | hu
    · rw [P.lower_zero] at hl
      omega
    · exact hu.symm
  have hpD : p < D := by
    rw [hpb0]
    simpa [P.lower_zero] using (P.within 0 hzero).2
  have hpsq : ¬p * p ∣ q := by
    intro hdiv
    obtain ⟨k, hk, hloc⟩ := P.locate hq.ne' hdiv
    have hk0 : 0 < k := by
      by_contra hnot
      have : k = 0 := by omega
      subst k
      rcases hloc with hl | hu
      · rw [P.lower_zero] at hl
        nlinarith
      · rw [← hpb0] at hu
        nlinarith
    have hg := P.gap 0 k hk0 hk
    rw [← hpb0] at hg
    rcases hloc with hl | hu
    · rw [hl] at hg
      nlinarith
    · have hw := (P.within k hk).1
      rw [hu] at hw
      nlinarith
  exact ⟨hp, hpb0, hpD, hpsq⟩

private theorem upper_eq_minFac_mul_lower (hqodd : Odd q) :
    ∀ i < P.count, P.upper i = q.minFac * P.lower i := by
  let p := q.minFac
  have hq : 0 < q := hqodd.pos
  obtain ⟨hp, hpb0, hpD, hpsq⟩ := P.minFac_data hqodd
  intro i
  induction i using Nat.strong_induction_on with
  | h i ih =>
      intro hi
      have hai_dvd := P.lower_dvd hq.ne' i hi
      have hai_pos := P.lower_pos hq i hi
      have hp_not_dvd_ai : ¬p ∣ P.lower i := by
        intro hpai
        obtain ⟨t, ht⟩ := hpai
        have htpos : 0 < t := by
          rw [ht] at hai_pos
          exact Nat.pos_of_mul_pos_left hai_pos
        have htdvd_ai : t ∣ P.lower i := ⟨p, by simpa [Nat.mul_comm] using ht⟩
        have htdvd_q : t ∣ q := htdvd_ai.trans hai_dvd
        have htlt : t < P.lower i := by
          rw [ht]
          nlinarith [hp.two_le]
        obtain ⟨k, hk, hloc⟩ := P.locate hq.ne' htdvd_q
        have hki : k < i := by
          by_contra hnot
          have hik : i ≤ k := by omega
          rcases eq_or_lt_of_le hik with rfl | hik
          · rcases hloc with hkl | hku
            · omega
            · have hw := (P.within i hi).1
              omega
          · have hg := P.gap i k hik hk
            have hwi := (P.within i hi).1
            have hscale := Nat.le_mul_of_pos_left (P.upper i) P.D_pos
            rcases hloc with hkl | hku
            · omega
            · have hw := (P.within k hk).1
              omega
        have hkcount : k < P.count := hk
        have ihk := ih k hki hkcount
        rcases hloc with hkl | hku
        · have heq : P.upper k = P.lower i := by
            rw [ihk, hkl]
            exact ht.symm
          have hg := P.gap k i hki hi
          have hscale := Nat.le_mul_of_pos_left (P.upper k) P.D_pos
          omega
        · have hpp_dvd_ai : p * p ∣ P.lower i := by
            refine ⟨P.lower k, ?_⟩
            rw [ht, ← hku, ihk]
            ac_rfl
          exact hpsq (hpp_dvd_ai.trans hai_dvd)
      have hpai_coprime : p.Coprime (P.lower i) :=
        hp.coprime_iff_not_dvd.mpr hp_not_dvd_ai
      have hpai_dvd : p * P.lower i ∣ q :=
        hpai_coprime.mul_dvd_of_dvd_of_dvd (Nat.minFac_dvd q) hai_dvd
      have hpaigt : P.lower i < p * P.lower i := by
        nlinarith [hp.two_le]
      have hpaiD : p * P.lower i < D * P.lower i := by
        nlinarith
      obtain ⟨k, hk, hloc⟩ := P.locate hq.ne' hpai_dvd
      have hki : k = i := by
        rcases lt_trichotomy k i with hki | hki | hik
        · have hg := P.gap k i hki hi
          have hscale := Nat.le_mul_of_pos_left (P.upper k) P.D_pos
          rcases hloc with hkl | hku
          · have hw := (P.within k hk).1
            omega
          · omega
        · exact hki
        · have hg := P.gap i k hik hk
          have hw := (P.within i hi).1
          have hmul := (Nat.mul_lt_mul_left P.D_pos).2 hw
          rcases hloc with hkl | hku
          · nlinarith
          · have hwk := (P.within k hk).1
            nlinarith
      subst k
      rcases hloc with hkl | hku
      · nlinarith
      · simpa [p] using hku

private theorem sum_upper_eq (hqodd : Odd q) :
    (∑ i ∈ Finset.range P.count, P.upper i) =
      q.minFac * ∑ i ∈ Finset.range P.count, P.lower i := by
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i hi
  rw [P.upper_eq_minFac_mul_lower hqodd i (Finset.mem_range.mp hi)]

end DivisorPairs

/-- The least prime factor lies below the pair scale and its square does not divide the odd part. -/
theorem divisor_pairs_minFac_bound {D q : ℕ} (P : DivisorPairs D q) (hqodd : Odd q) :
    q.minFac < D ∧ ¬q.minFac * q.minFac ∣ q := by
  obtain ⟨_, _, hpD, hpsq⟩ := P.minFac_data hqodd
  exact ⟨hpD, hpsq⟩

/-- Every upper entry is the least prime factor times its paired lower entry. -/
theorem divisor_pairs_upper_pair_shape {D q : ℕ} (P : DivisorPairs D q)
    (hqodd : Odd q) :
    ∀ i < P.count, P.upper i = q.minFac * P.lower i := by
  exact P.upper_eq_minFac_mul_lower hqodd

/-- Summing the consecutive divisor gaps gives the strict telescoping estimate. -/
theorem divisor_pairs_gap_telescoping {D q : ℕ} (P : DivisorPairs D q)
    (hqodd : Odd q) :
    (D * q.minFac - 1) * (∑ i ∈ Finset.range P.count, P.lower i) <
      D * q.minFac * P.lower (P.count - 1) := by
  let p := q.minFac
  let S := ∑ i ∈ Finset.range P.count, P.lower i
  let r := P.lower (P.count - 1)
  have hj : 2 ≤ P.count := P.count_ge_two
  have hlast : P.count = (P.count - 1) + 1 := by omega
  have hrange :
      S = (∑ i ∈ Finset.range (P.count - 1), P.lower i) + r := by
    dsimp [S, r]
    conv_lhs => rw [hlast, Finset.sum_range_succ]
  have hshift :
      (∑ i ∈ Finset.range (P.count - 1), P.lower (i + 1)) + P.lower 0 = S := by
    dsimp [S]
    rw [hlast]
    exact (Finset.sum_range_succ' P.lower (P.count - 1)).symm
  have htel :
      D * p * (∑ i ∈ Finset.range (P.count - 1), P.lower i) <
        ∑ i ∈ Finset.range (P.count - 1), P.lower (i + 1) := by
    rw [Finset.mul_sum]
    apply Finset.sum_lt_sum_of_nonempty
    · exact ⟨0, Finset.mem_range.mpr (by omega)⟩
    · intro i hi
      have hii : i < P.count - 1 := Finset.mem_range.mp hi
      have hi1 : i + 1 < P.count := by omega
      have hpair := divisor_pairs_upper_pair_shape P hqodd i (by omega)
      have hgap := P.gap i (i + 1) (by omega) hi1
      dsimp [p] at hpair hgap ⊢
      rw [hpair] at hgap
      simpa [Nat.mul_assoc] using hgap
  have hRpos : 0 < D * p := by
    have hp : Nat.Prime p := by
      simpa [p] using (P.minFac_data hqodd).1
    exact Nat.mul_pos P.D_pos hp.pos
  have hRsub : D * p = (D * p - 1) + 1 := by omega
  rw [P.lower_zero] at hshift
  change (D * p - 1) * S < D * p * r
  nlinarith

/-- The lower-bound coefficient is large enough when the least prime lies below the scale. -/
theorem lower_coefficient_bound {D p : ℕ} (hpD : p < D) :
    D * p ≤ (D - 1) * (p + 1) := by
  have hDsub : D = (D - 1) + 1 := by omega
  nlinarith

/-- The upper-bound coefficient comparison holds from the scale and prime lower bounds. -/
theorem upper_coefficient_bound {D p : ℕ} (hD : 4 ≤ D) (hp : 3 ≤ p) :
    3 * ((D - 1) * (p + 1)) ≤ 4 * (D * p - 1) := by
  have hDsub : D = (D - 1) + 1 := by omega
  have hRpos : 0 < D * p := Nat.mul_pos (by omega) (by omega)
  have hRsub : D * p = (D * p - 1) + 1 := by omega
  nlinarith

set_option maxHeartbeats 800000 in
-- The final natural-number coefficient comparison uses several nonlinear inequalities at once.
/-- The division-free natural-number form of the conditional sigma bounds. -/
theorem a392096_sigma_bounds_nat {n : ℕ} (hn : Member n) :
    2 * n < ArithmeticFunction.sigma 1 n ∧
      3 * ArithmeticFunction.sigma 1 n < 8 * n := by
  rcases hn with ⟨m, q, hm, hqodd, rfl, ⟨P⟩⟩
  let D := 2 ^ (m + 1)
  let p := q.minFac
  let S := ∑ i ∈ Finset.range P.count, P.lower i
  let r := P.lower (P.count - 1)
  have hj : 2 ≤ P.count := P.count_ge_two
  have hq : 0 < q := hqodd.pos
  obtain ⟨hp, hpb0, _, _⟩ := P.minFac_data hqodd
  obtain ⟨hpD, hpsq⟩ := divisor_pairs_minFac_bound P hqodd
  change Nat.Prime p at hp
  change p = P.upper 0 at hpb0
  change p < D at hpD
  change ¬p * p ∣ q at hpsq
  have hp3 : 3 ≤ p := by
    have hp2 := hp.two_le
    have hpne2 : p ≠ 2 := by
      intro heq
      have : 2 ∣ q := by simpa [p, heq] using Nat.minFac_dvd q
      exact hqodd.not_two_dvd_nat this
    omega
  have hD4 : 4 ≤ D := by
    dsimp [D]
    have : 1 + 1 ≤ m + 1 := by omega
    exact Nat.pow_le_pow_right (by decide : 0 < 2) this
  have hlast : P.count = (P.count - 1) + 1 := by omega
  have hrange :
      S = (∑ i ∈ Finset.range (P.count - 1), P.lower i) + r := by
    dsimp [S, r]
    conv_lhs => rw [hlast, Finset.sum_range_succ]
  have hrpos : 0 < r := P.lower_pos hq (P.count - 1) (by omega)
  have hSgt : r < S := by
    have hfirst : 0 < ∑ i ∈ Finset.range (P.count - 1), P.lower i := by
      have hzero : 0 ∈ Finset.range (P.count - 1) := Finset.mem_range.mpr (by omega)
      have := Finset.single_le_sum (fun i _ => Nat.zero_le (P.lower i)) hzero
      rw [P.lower_zero] at this
      omega
    omega
  have hRpos : 0 < D * p := by positivity
  have htelescoped := divisor_pairs_gap_telescoping P hqodd
  change (D * p - 1) * S < D * p * r at htelescoped
  have hqpr : q = p * r := by
    have hpair := P.upper_eq_minFac_mul_lower hqodd (P.count - 1) (by omega)
    rw [P.upper_last] at hpair
    exact hpair
  have hsigmaq : ArithmeticFunction.sigma 1 q = (p + 1) * S := by
    rw [ArithmeticFunction.sigma_one_apply, P.sum_divisors_eq]
    rw [P.sum_upper_eq hqodd]
    dsimp [p, S]
    ring
  have hcop : (2 ^ m).Coprime q := (Nat.coprime_two_left.mpr hqodd).pow_left m
  have hsigman :
      ArithmeticFunction.sigma 1 (2 ^ m * q) = (D - 1) * (p + 1) * S := by
    rw [ArithmeticFunction.isMultiplicative_sigma.map_mul_of_coprime hcop]
    rw [ArithmeticFunction.sigma_one_apply_prime_pow Nat.prime_two]
    rw [Nat.geomSum_eq (m := 2) (by decide) (m + 1), hsigmaq]
    simp [D, Nat.mul_assoc]
  have hlcoeff : D * p ≤ (D - 1) * (p + 1) := lower_coefficient_bound hpD
  have hucoeff : 3 * ((D - 1) * (p + 1)) ≤ 4 * (D * p - 1) :=
    upper_coefficient_bound hD4 hp3
  have hlower : D * p * r < (D - 1) * (p + 1) * S := by
    have h1 : D * p * r < D * p * S :=
      (Nat.mul_lt_mul_left hRpos).2 hSgt
    have h2 := Nat.mul_le_mul_right S hlcoeff
    nlinarith
  have hupper : 3 * ((D - 1) * (p + 1) * S) < 4 * (D * p * r) := by
    have h1 := Nat.mul_le_mul_right S hucoeff
    have h2 := (Nat.mul_lt_mul_left (by decide : 0 < 4)).2 htelescoped
    nlinarith
  rw [hsigman]
  rw [hqpr]
  have hD : D = 2 * 2 ^ m := by
    dsimp [D]
    rw [pow_succ]
    ring
  constructor <;> nlinarith

/-- Hoft's source-form strict abundancy interval, interpreted over the rationals. -/
theorem a392096_sigma_bounds {n : ℕ} (hn : Member n) :
    2 * (n : ℚ) < ArithmeticFunction.sigma 1 n ∧
      (ArithmeticFunction.sigma 1 n : ℚ) < 8 * n / 3 := by
  obtain ⟨hlower, hupper⟩ := a392096_sigma_bounds_nat hn
  constructor
  · exact_mod_cast hlower
  · apply (lt_div_iff₀ (by norm_num : (0 : ℚ) < 3)).2
    exact_mod_cast (show ArithmeticFunction.sigma 1 n * 3 < 8 * n by
      simpa [Nat.mul_comm] using hupper)

#print axioms DivisorPairs
#print axioms Member
#print axioms divisor_pairs_minFac_bound
#print axioms divisor_pairs_upper_pair_shape
#print axioms divisor_pairs_gap_telescoping
#print axioms lower_coefficient_bound
#print axioms upper_coefficient_bound
#print axioms a392096_sigma_bounds_nat
#print axioms a392096_sigma_bounds

section FidelityAudit

-- The first published term has pairs (1, 3) and (13, 39) at D = 4.
example : Member 78 := by
  refine ⟨1, 39, by norm_num, by decide, by norm_num, ⟨?_⟩⟩
  refine
    { D_pos := by norm_num
      count := 2
      count_ge_two := by norm_num
      lower := fun i => if i = 0 then 1 else 13
      upper := fun i => if i = 0 then 3 else 39
      lower_zero := by simp
      upper_last := by norm_num
      divisors_eq := by decide
      within := ?_
      gap_succ := ?_ }
  · intro i hi
    have : i = 0 ∨ i = 1 := by omega
    rcases this with rfl | rfl <;> norm_num
  · intro i hi
    have hi' : i = 0 := by omega
    subst i
    norm_num

-- Twelve is outside the predicate; its odd part cannot supply two separated pairs.
example : ¬Member 12 := by
  rintro ⟨m, q, hm, hqodd, heq, ⟨P⟩⟩
  have hq : 0 < q := hqodd.pos
  have hpow : 2 ^ m ≤ 12 := by
    rw [heq]
    exact Nat.le_mul_of_pos_right (2 ^ m) hq
  have hmle : m ≤ 3 := by
    by_contra hnot
    have h4m : 4 ≤ m := by omega
    have hp16 : 16 ≤ 2 ^ m := by
      simpa using Nat.pow_le_pow_right (by decide : 0 < 2) h4m
    omega
  interval_cases m
  · obtain ⟨t, ht⟩ := hqodd
    rw [ht] at heq
    norm_num at heq
    omega
  · norm_num at heq
    have hq3 : q = 3 := by omega
    subst q
    have hj : 2 ≤ P.count := P.count_ge_two
    have hzero : 0 < P.count := by omega
    have hone : 1 < P.count := by omega
    have hu0dvd := P.upper_dvd (by decide : 3 ≠ 0) 0 hzero
    have hu0gt : 1 < P.upper 0 := by
      simpa [P.lower_zero] using (P.within 0 hzero).1
    have hu0eq : P.upper 0 = 3 := by
      rcases (Nat.dvd_prime (by decide : Nat.Prime 3)).mp hu0dvd with h | h
      · omega
      · exact h
    have hl1dvd := P.lower_dvd (by decide : 3 ≠ 0) 1 hone
    have hl1pos : 0 < P.lower 1 := Nat.pos_of_dvd_of_pos hl1dvd (by decide)
    have hl1le : P.lower 1 ≤ 3 := Nat.le_of_dvd (by decide) hl1dvd
    have hgap := P.gap 0 1 (by omega) hone
    norm_num [hu0eq] at hgap
    omega
  · norm_num at heq
    omega

end FidelityAudit

end D5.S3.Factorization.SymmetricSigmaRepeatedPatternAbundancy
