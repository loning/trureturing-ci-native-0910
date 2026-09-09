/- GID: D5/S3/Factorization/TotientNondivisorRecords
   generality: I
   mirror-B: D5/B/S3/Factorization/TotientNondivisorRecords
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: kind=certified-instance; basis=terminal=atom:9e726c5245a778d8f8dc77c70c5148ded5d04aab99408bd530d14727851275fb; result=D5/S3/Factorization/TotientNondivisorRecords.exception_set_claim_false
   digest: Totient nondivisor values are lcm jumps, and 1275120 refutes the exception claim. -/

import Mathlib.Data.Nat.Totient
import Mathlib.Tactic.ReduceModChar

open scoped BigOperators

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S3.Factorization.TotientNondivisorRecords

/-- `BadTotient N m` says that `m` is at least two and its totient does not divide `N`. -/
def BadTotient (N m : ℕ) : Prop :=
  2 ≤ m ∧ ¬Nat.totient m ∣ N

private instance instDecidableBadTotient (N m : ℕ) : Decidable (BadTotient N m) := by
  unfold BadTotient
  infer_instance

private lemma exists_badTotient (N : ℕ) (hN : 0 < N) : ∃ m, BadTotient N m := by
  obtain ⟨p, hpN, hp⟩ := Nat.exists_infinite_primes (N + 2)
  refine ⟨p, by omega, ?_⟩
  rw [Nat.totient_prime hp]
  intro hdvd
  have := Nat.le_of_dvd hN hdvd
  omega

/-- The least `m ≥ 2` whose totient does not divide a positive `N`, totalized to zero at zero. -/
noncomputable def a (N : ℕ) : ℕ :=
  if hN : 0 < N then Nat.find (exists_badTotient N hN) else 0

private lemma a_eq_iff {N m : ℕ} (hN : 0 < N) :
    a N = m ↔ BadTotient N m ∧ ∀ k < m, ¬BadTotient N k := by
  simp only [a, dif_pos hN]
  exact Nat.find_eq_iff (exists_badTotient N hN)

/-- The range implementation of the power sum used below. -/
def powerSum (N k : ℕ) : ℕ :=
  ∑ j ∈ Finset.range k, j ^ N

/-- For `N ≥ 1`, the range implementation is the literal sum `∑_{1 ≤ j < k} j^N`. -/
theorem powerSum_eq_positive_index_sum (N k : ℕ) (hN : 1 ≤ N) :
    powerSum N k = ∑ j ∈ Finset.Ico 1 k, j ^ N := by
  rcases k with _ | k
  · simp [powerSum]
  rw [powerSum, Finset.range_eq_Ico,
    ← Finset.insert_Ico_add_one_left_eq_Ico (Nat.succ_pos k), Finset.sum_insert]
  · simp [zero_pow (by omega : N ≠ 0)]
  · simp

/-- The predicate that `k ≥ 2` divides the corresponding power sum
`∑_{1 ≤ j < k} j^N` when `N ≥ 1`, by `powerSum_eq_positive_index_sum`. -/
def PowerSumDivisor (N k : ℕ) : Prop :=
  2 ≤ k ∧ k ∣ powerSum N k

private instance instDecidablePowerSumDivisor (N k : ℕ) : Decidable (PowerSumDivisor N k) := by
  unfold PowerSumDivisor
  infer_instance

/-- The least `k ≥ 2` dividing the positive-index power sum `∑_{1 ≤ j < k} j^N`
when `N ≥ 1`, by `A095366_eq_literal`. -/
noncomputable def A095366 (N : ℕ) : ℕ :=
  sInf {k : ℕ | PowerSumDivisor N k}

/-- For `N ≥ 1`, `A095366` is the least `k > 1` dividing the literal atom-defined
sum `∑_{1 ≤ j < k} j^N`. -/
theorem A095366_eq_literal (N : ℕ) (hN : 1 ≤ N) :
    A095366 N = sInf {k : ℕ | 1 < k ∧ k ∣ ∑ j ∈ Finset.Ico 1 k, j ^ N} := by
  unfold A095366
  apply congrArg sInf
  ext k
  simp only [Set.mem_ofPred_eq, PowerSumDivisor]
  rw [powerSum_eq_positive_index_sum N k hN]
  omega

/-- The least common multiple of `φ(1), ..., φ(t)`, with the empty lcm at `t = 0`. -/
def L (t : ℕ) : ℕ :=
  (Finset.range t).lcm fun i ↦ Nat.totient (i + 1)

/-- The empty consecutive-totient lcm is one. -/
@[simp] theorem L_zero : L 0 = 1 := by
  simp [L]

/-- The consecutive-totient lcm divides `N` exactly when every totient in its range does. -/
theorem L_dvd_iff {t N : ℕ} :
    L t ∣ N ↔ ∀ j, 1 ≤ j → j ≤ t → Nat.totient j ∣ N := by
  rw [L, Finset.lcm_dvd_iff]
  constructor
  · intro h j hj1 hjt
    have hj : j - 1 ∈ Finset.range t := by
      simp only [Finset.mem_range]
      omega
    simpa [Nat.sub_add_cancel hj1] using h (j - 1) hj
  · intro h i hi
    apply h (i + 1)
    · omega
    · simp only [Finset.mem_range] at hi
      omega

private lemma L_pos (t : ℕ) : 0 < L t := by
  rw [Nat.pos_iff_ne_zero, L, Finset.lcm_ne_zero_iff]
  intro i hi
  exact (Nat.totient_pos.mpr (by omega)).ne'

private lemma L_mono_dvd {s t : ℕ} (hst : s ≤ t) : L s ∣ L t := by
  rw [L, L]
  exact Finset.lcm_mono (Finset.range_mono hst)

private lemma totient_dvd_L {j t : ℕ} (hj1 : 1 ≤ j) (hjt : j ≤ t) :
    Nat.totient j ∣ L t :=
  L_dvd_iff.mp dvd_rfl j hj1 hjt

/-- A strict consecutive lcm jump occurs exactly when the new totient is genuinely new. -/
theorem L_jump_iff_not_dvd {m : ℕ} (hm : 2 ≤ m) :
    L (m - 1) < L m ↔ ¬Nat.totient m ∣ L (m - 1) := by
  constructor
  · intro hjump htot
    have hback : L m ∣ L (m - 1) := by
      apply L_dvd_iff.mpr
      intro j hj1 hjm
      by_cases hEq : j = m
      · simpa [hEq] using htot
      · exact totient_dvd_L hj1 (by omega)
    have hforward : L (m - 1) ∣ L m := L_mono_dvd (by omega)
    exact (Nat.ne_of_lt hjump) (Nat.dvd_antisymm hforward hback)
  · intro htot
    have hdiv : L (m - 1) ∣ L m := L_mono_dvd (by omega)
    have hle : L (m - 1) ≤ L m := Nat.le_of_dvd (L_pos m) hdiv
    have hne : L (m - 1) ≠ L m := by
      intro heq
      apply htot
      rw [heq]
      exact totient_dvd_L (by omega) le_rfl
    exact lt_of_le_of_ne hle hne

/-- For `m ≥ 2`, the value `m` occurs in `a` exactly at a strict consecutive-totient lcm jump. -/
theorem range_iff_lcm_jump : ∀ m ≥ 2,
    (∃ N ≥ 1, a N = m) ↔ L (m - 1) < L m := by
  intro m hm
  rw [L_jump_iff_not_dvd hm]
  constructor
  · rintro ⟨N, hN, ha⟩
    have ha' := (a_eq_iff (by omega : 0 < N)).mp ha
    have hL : L (m - 1) ∣ N := by
      apply L_dvd_iff.mpr
      intro j hj1 hjm
      by_cases hj : j = 1
      · simp [hj]
      · have hj2 : 2 ≤ j := by omega
        by_contra hnot
        exact ha'.2 j (by omega) ⟨hj2, hnot⟩
    intro htot
    exact ha'.1.2 (htot.trans hL)
  · intro htot
    refine ⟨L (m - 1), by exact L_pos (m - 1), ?_⟩
    apply (a_eq_iff (L_pos (m - 1))).mpr
    constructor
    · exact ⟨hm, htot⟩
    · intro k hkm hkbad
      exact hkbad.2
        (totient_dvd_L (le_trans (by norm_num) hkbad.1) (Nat.le_sub_one_of_lt hkm))

theorem totients_lt_51_dvd_1275120 :
    ∀ i : Fin 51, 1 ≤ i.val → Nat.totient i.val ∣ 1275120 := by
  decide

theorem totient_51_eq_32 : Nat.totient 51 = 32 := by
  decide

theorem mod_1275120_32 : 1275120 % 32 = 16 := by
  norm_num

theorem mod_1275120_120 : 1275120 % 120 = 0 := by
  norm_num

private theorem totient_51_not_dvd_1275120 : ¬Nat.totient 51 ∣ 1275120 := by
  rw [totient_51_eq_32]
  intro hdvd
  have hzero := Nat.dvd_iff_mod_eq_zero.mp hdvd
  rw [mod_1275120_32] at hzero
  norm_num at hzero

/-- The least totient nondivisor of `1275120` is `51`. -/
theorem a_1275120 : a 1275120 = 51 := by
  apply (a_eq_iff (by norm_num)).mpr
  constructor
  · exact ⟨by norm_num, totient_51_not_dvd_1275120⟩
  · intro k hk hkbad
    exact hkbad.2
      (totients_lt_51_dvd_1275120 ⟨k, hk⟩ (le_trans (by norm_num) hkbad.1))

theorem powerSum_1275120_mod_51 :
    powerSum 1275120 51 ≡ 31 [MOD 51] := by
  rw [← ZMod.natCast_eq_natCast_iff]
  simp only [powerSum, Nat.cast_sum, Nat.cast_pow]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add]
  reduce_mod_char

private theorem powerSum_1275120_not_dvd_51 :
    ¬51 ∣ powerSum 1275120 51 := by
  intro hdvd
  have hzero : powerSum 1275120 51 % 51 = 0 := Nat.dvd_iff_mod_eq_zero.mp hdvd
  have hmod := powerSum_1275120_mod_51
  rw [Nat.ModEq] at hmod
  norm_num [hzero] at hmod

theorem powerSum_1275120_mod_53 :
    powerSum 1275120 53 ≡ 0 [MOD 53] := by
  rw [← ZMod.natCast_eq_natCast_iff]
  simp only [powerSum, Nat.cast_sum, Nat.cast_pow]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add]
  reduce_mod_char

private theorem powerSum_1275120_dvd_53 :
    53 ∣ powerSum 1275120 53 := by
  exact Nat.modEq_zero_iff_dvd.mp powerSum_1275120_mod_53

private theorem PowerSumDivisor_1275120_53 : PowerSumDivisor 1275120 53 :=
  ⟨by norm_num, powerSum_1275120_dvd_53⟩

/-- `51` is not the least divisor of `∑_{1 ≤ j < k} j^1275120`, with
`A095366_eq_literal` identifying this literal atom-defined object with `A095366`. -/
theorem A095366_1275120_ne_51 : A095366 1275120 ≠ 51 := by
  intro heq
  rw [A095366_eq_literal 1275120 (by norm_num)] at heq
  have hne :
      {k : ℕ | 1 < k ∧ k ∣ ∑ j ∈ Finset.Ico 1 k, j ^ 1275120}.Nonempty := by
    refine ⟨53, by norm_num, ?_⟩
    rw [← powerSum_eq_positive_index_sum 1275120 53 (by norm_num)]
    exact powerSum_1275120_dvd_53
  have hmem := Nat.sInf_mem hne
  rw [heq] at hmem
  apply powerSum_1275120_not_dvd_51
  rw [powerSum_eq_positive_index_sum 1275120 51 (by norm_num)]
  exact hmem.2

/-- The mod-120 certificate shows that `1275120` is not sixty times an odd number. -/
theorem not_exception_form : ¬∃ k : ℕ, 1275120 = 60 * (2 * k + 1) := by
  intro ⟨k, hk⟩
  have h := mod_1275120_120
  rw [hk] at h
  omega

/-- The value `1275120` refutes the claimed exception set for equality with `A095366`. -/
theorem exception_set_claim_false :
    a 1275120 = 51 ∧
      A095366 1275120 ≠ 51 ∧
      ¬∃ k : ℕ, 1275120 = 60 * (2 * k + 1) :=
  ⟨a_1275120, A095366_1275120_ne_51, not_exception_form⟩

end D5.S3.Factorization.TotientNondivisorRecords
