/- GID: D5/S1/Recurrence/MultiplicativeExclusionResidueClass
   generality: I
   mirror-B: D5/B/S1/Recurrence/MultiplicativeExclusionResidueClass
   mirror-E: none(waiver:symbolic-unbounded-theorems)
   anchors: []
   utility: none
   digest: The multiplicative-exclusion sequence is 1, 3, then 3n-5. -/

import Mathlib.Tactic.NormNum

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S1.Recurrence.MultiplicativeExclusionResidueClass

/-- The atom's literal witness set: the exceptional value `3` together with
the arithmetic progression `3 * t + 1`. -/
def S : Set ℕ := {3} ∪ {x | ∃ t : ℕ, x = 3 * t + 1}

/-- Membership in the literal witness set is equivalent to its residue-class
description. -/
theorem mem_S_iff (x : ℕ) : x ∈ S ↔ (x = 3 ∨ x % 3 = 1) := by
  simp only [S, Set.mem_union, Set.mem_singleton_iff, Set.mem_ofPred_eq]
  constructor
  · rintro (rfl | ⟨t, rfl⟩)
    · exact Or.inl rfl
    · exact Or.inr (by omega)
  · rintro (rfl | hx)
    · exact Or.inl rfl
    · right
      exact ⟨x / 3, by omega⟩

private def InS (x : Nat) : Prop := x ∈ S

private def target (n : Nat) : Nat :=
  if n = 1 then 1 else if n = 2 then 3 else 3 * n - 5

private def candidateValue (a : Nat → Nat) (n x r : Nat) : Nat :=
  if r = n then x else a r

/- The internal proof predicate uses the subtraction-free form of the atom's
integer equality.  The public identity below connects it to literal subtraction. -/
private def Excluded (a : Nat → Nat) (n x : Nat) : Prop :=
  ∃ i j k, 1 ≤ i ∧ i ≤ j ∧ j ≤ k ∧ k ≤ n ∧
    x + candidateValue a n x k =
      candidateValue a n x i * candidateValue a n x j

private def Admissible (a : Nat → Nat) (n x : Nat) : Prop :=
  0 < x ∧ a (n - 1) < x ∧ ¬ Excluded a n x

/-- The literal one-based OEIS rule, totalized by `a 0 = 0`. At prospective
index `n`, every occurrence of index `n` in the exclusion test has value `x`. -/
def SatisfiesLiteralRule (a : Nat → Nat) : Prop :=
  a 0 = 0 ∧ a 1 = 1 ∧
    ∀ n, 2 ≤ n →
      (0 < a n ∧ a (n - 1) < a n ∧
        ∀ i j k, 1 ≤ i → i ≤ j → j ≤ k → k ≤ n →
          ((a n : Int) ≠
            ((if i = n then a n else a i : Nat) : Int) *
                ((if j = n then a n else a j : Nat) : Int) -
              ((if k = n then a n else a k : Nat) : Int))) ∧
      ∀ x,
        (0 < x ∧ a (n - 1) < x ∧
          ∀ i j k, 1 ≤ i → i ≤ j → j ≤ k → k ≤ n →
            ((x : Int) ≠
              ((if i = n then x else a i : Nat) : Int) *
                  ((if j = n then x else a j : Nat) : Int) -
                ((if k = n then x else a k : Nat) : Int))) →
          a n ≤ x

/-- Integer subtraction in the atom is equivalent to the subtraction-free
natural-number equality used by the internal exclusion predicate. -/
theorem literal_exclusion_iff_additive (x a b c : Nat) :
    ((x : Int) ≠ (a : Int) * b - c) ↔ x + c ≠ a * b := by
  constructor
  · intro h hAdd
    apply h
    apply eq_sub_iff_add_eq.mpr
    exact_mod_cast hAdd
  · intro h hSub
    apply h
    have hAdd : (x : Int) + c = (a : Int) * b := eq_sub_iff_add_eq.mp hSub
    exact_mod_cast hAdd

/-- The literal integer-subtraction rule is identical to the additive form
used in the proof of existence, leastness, and uniqueness. -/
theorem satisfiesLiteralRule_iff_additive (a : Nat → Nat) :
    SatisfiesLiteralRule a ↔
      a 0 = 0 ∧ a 1 = 1 ∧
        ∀ n, 2 ≤ n →
          (0 < a n ∧ a (n - 1) < a n ∧
            ∀ i j k, 1 ≤ i → i ≤ j → j ≤ k → k ≤ n →
              a n + (if k = n then a n else a k) ≠
                (if i = n then a n else a i) *
                  (if j = n then a n else a j)) ∧
          ∀ x,
            (0 < x ∧ a (n - 1) < x ∧
              ∀ i j k, 1 ≤ i → i ≤ j → j ≤ k → k ≤ n →
                x + (if k = n then x else a k) ≠
                  (if i = n then x else a i) *
                    (if j = n then x else a j)) →
              a n ≤ x := by
  simp only [SatisfiesLiteralRule, literal_exclusion_iff_additive]

private theorem admissible_iff_additive {a : Nat → Nat} {n x : Nat} :
    Admissible a n x ↔
      0 < x ∧ a (n - 1) < x ∧
        ∀ i j k, 1 ≤ i → i ≤ j → j ≤ k → k ≤ n →
          x + (if k = n then x else a k) ≠
            (if i = n then x else a i) * (if j = n then x else a j) := by
  constructor
  · intro h
    refine ⟨h.1, h.2.1, ?_⟩
    intro i j k hi1 hij hjk hkn heq
    apply h.2.2
    refine ⟨i, j, k, hi1, hij, hjk, hkn, ?_⟩
    simpa [candidateValue] using heq
  · rintro ⟨hpos, hprev, hnot⟩
    refine ⟨hpos, hprev, ?_⟩
    rintro ⟨i, j, k, hi1, hij, hjk, hkn, heq⟩
    apply hnot i j k hi1 hij hjk hkn
    simpa [candidateValue] using heq

private theorem isLeast_admissible_iff {a : Nat → Nat} {n z : Nat} :
    IsLeast {x | Admissible a n x} z ↔
      IsLeast {x |
        0 < x ∧ a (n - 1) < x ∧
          ∀ i j k, 1 ≤ i → i ≤ j → j ≤ k → k ≤ n →
            x + (if k = n then x else a k) ≠
              (if i = n then x else a i) * (if j = n then x else a j)} z := by
  constructor
  · intro h
    exact ⟨admissible_iff_additive.mp h.1,
      fun y hy ↦ h.2 (admissible_iff_additive.mpr hy)⟩
  · intro h
    exact ⟨admissible_iff_additive.mpr h.1,
      fun y hy ↦ h.2 (admissible_iff_additive.mp hy)⟩

private theorem target_zero : target 0 = 0 := by simp [target]
private theorem target_one : target 1 = 1 := by simp [target]
private theorem target_two : target 2 = 3 := by simp [target]

private theorem target_formula {n : Nat} (hn : 3 ≤ n) : target n = 3 * n - 5 := by
  have hn1 : n ≠ 1 := by omega
  have hn2 : n ≠ 2 := by omega
  simp [target, hn1, hn2]

private theorem target_pos {n : Nat} (hn : 1 ≤ n) : 0 < target n := by
  by_cases hn1 : n = 1
  · simp [target, hn1]
  by_cases hn2 : n = 2
  · simp [target, hn2]
  simp [target, hn1, hn2]
  omega

private theorem target_strictMonoOn {i j : Nat} (hi : 1 ≤ i) (hij : i < j) :
    target i < target j := by
  by_cases hi1 : i = 1
  · subst i
    by_cases hj2 : j = 2
    · subst j
      decide
    · rw [target_one, target_formula (by omega)]
      omega
  by_cases hi2 : i = 2
  · subst i
    rw [target_two, target_formula (by omega)]
    omega
  · rw [target_formula (by omega), target_formula (by omega)]
    omega

private theorem target_le_target {i j : Nat} (hi : 1 ≤ i) (hij : i ≤ j) :
    target i ≤ target j := by
  rcases hij.eq_or_lt with rfl | hij
  · exact le_rfl
  · exact (target_strictMonoOn hi hij).le

private theorem target_memS {n : Nat} (hn : 1 ≤ n) : InS (target n) := by
  rw [InS, mem_S_iff]
  by_cases hn1 : n = 1
  · simp [target, hn1]
  by_cases hn2 : n = 2
  · simp [target, hn2]
  simp [target, hn1, hn2]
  omega

private theorem memS_small {x : Nat} (hx : x = 3 ∨ x % 3 = 1) (h : x ≤ 3) :
    x = 1 ∨ x = 3 := by
  rcases hx with rfl | hx
  · exact Or.inr rfl
  · omega

private theorem residue_protection_core {x u v w : Nat}
    (hx4 : 4 ≤ x) (hx : InS x) (hu : InS u) (hv : InS v) (hw : InS w)
    (huv : u ≤ v) (hvw : v ≤ w) : x + w ≠ u * v := by
  rw [InS, mem_S_iff] at hx hu hv hw
  intro heq
  rcases hw with rfl | hw
  · have hv3 : v = 1 ∨ v = 3 := memS_small hv hvw
    rcases hv3 with rfl | rfl
    · have hu1 : u = 1 := by
        rcases memS_small hu (huv.trans (by decide)) with h | h <;> omega
      omega
    · rcases memS_small hu huv with rfl | rfl <;>
        rcases hx with rfl | hx <;> omega
  · rcases hv with rfl | hv
    · rcases memS_small hu huv with rfl | rfl <;>
        rcases hx with rfl | hx <;> omega
    · rcases hu with rfl | hu
      · rcases hx with rfl | hx <;> omega
      · have hprod : (u * v) % 3 = 1 := by
          simp [Nat.mul_mod, hu, hv]
        rcases hx with rfl | hx <;> omega

/-- Ordered values in the literal witness set `S` cannot exclude another
member at least four. The exceptional value `3` is controlled by order. -/
theorem residue_protection {x u v w : Nat}
    (hx4 : 4 ≤ x) (hx : x ∈ S) (hu : u ∈ S) (hv : v ∈ S)
    (hw : w ∈ S) (huv : u ≤ v) (hvw : v ≤ w) :
    x + w ≠ u * v := by
  exact residue_protection_core hx4 hx hu hv hw huv hvw

private theorem witness_9t {t : Nat} (ht : 1 ≤ t) :
    ∃ u v w, InS u ∧ InS v ∧ InS w ∧ u ≤ v ∧ v ≤ w ∧ w < 9 * t ∧
      9 * t + w = u * v := by
  refine ⟨4, 3 * t + 1, 3 * t + 4, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · rw [InS, mem_S_iff]; right; omega
  · rw [InS, mem_S_iff]; right; omega
  · rw [InS, mem_S_iff]; right; omega
  · omega
  · omega
  · omega
  · omega

private theorem witness_9t_add3 {t : Nat} (ht : 1 ≤ t) :
    ∃ u v w, InS u ∧ InS v ∧ InS w ∧ u ≤ v ∧ v ≤ w ∧ w < 9 * t + 3 ∧
      9 * t + 3 + w = u * v := by
  refine ⟨4, 3 * t + 1, 3 * t + 1, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · rw [InS, mem_S_iff]; right; omega
  · rw [InS, mem_S_iff]; right; omega
  · rw [InS, mem_S_iff]; right; omega
  · omega
  · omega
  · omega
  · omega

private theorem witness_9t_add6 {t : Nat} (ht : 1 ≤ t) :
    ∃ u v w, InS u ∧ InS v ∧ InS w ∧ u ≤ v ∧ v ≤ w ∧ w < 9 * t + 6 ∧
      9 * t + 6 + w = u * v := by
  refine ⟨4, 3 * t + 4, 3 * t + 10, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · rw [InS, mem_S_iff]; right; omega
  · rw [InS, mem_S_iff]; right; omega
  · rw [InS, mem_S_iff]; right; omega
  · omega
  · omega
  · omega
  · omega

private theorem witness_6t_add2 {t : Nat} (ht : 1 ≤ t) :
    ∃ u v w, InS u ∧ InS v ∧ InS w ∧ u ≤ v ∧ v ≤ w ∧ w < 6 * t + 2 ∧
      6 * t + 2 + w = u * v := by
  refine ⟨3, 3 * t + 1, 3 * t + 1, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · rw [InS, mem_S_iff]; exact Or.inl rfl
  · rw [InS, mem_S_iff]; right; omega
  · rw [InS, mem_S_iff]; right; omega
  · omega
  · omega
  · omega
  · omega

private theorem witness_6t_add5 {t : Nat} (ht : 1 ≤ t) :
    ∃ u v w, InS u ∧ InS v ∧ InS w ∧ u ≤ v ∧ v ≤ w ∧ w < 6 * t + 5 ∧
      6 * t + 5 + w = u * v := by
  refine ⟨3, 3 * t + 4, 3 * t + 7, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · rw [InS, mem_S_iff]; exact Or.inl rfl
  · rw [InS, mem_S_iff]; right; omega
  · rw [InS, mem_S_iff]; right; omega
  · omega
  · omega
  · omega
  · norm_num [Nat.mul_add, Nat.add_mul]
    omega

private def OrderedWitness (y : Nat) : Prop :=
  ∃ u v w, InS u ∧ InS v ∧ InS w ∧ u ≤ v ∧ v ≤ w ∧ w < y ∧ y + w = u * v

private theorem witness_of_not_memS_core {y : Nat} (hy : 7 ≤ y) (hymod : y % 3 ≠ 1) :
    OrderedWitness y := by
  by_cases hy0 : y % 3 = 0
  · have hrem : y % 9 = 0 ∨ y % 9 = 3 ∨ y % 9 = 6 := by omega
    rcases hrem with hrem | hrem | hrem
    · let t := y / 9
      have hyt : y = 9 * t := by omega
      have ht : 1 ≤ t := by omega
      simpa [OrderedWitness, hyt] using witness_9t ht
    · let t := y / 9
      have hyt : y = 9 * t + 3 := by omega
      have ht : 1 ≤ t := by omega
      simpa [OrderedWitness, hyt] using witness_9t_add3 ht
    · let t := y / 9
      have hyt : y = 9 * t + 6 := by omega
      have ht : 1 ≤ t := by omega
      simpa [OrderedWitness, hyt] using witness_9t_add6 ht
  · have hy2 : y % 3 = 2 := by omega
    have hrem : y % 6 = 2 ∨ y % 6 = 5 := by omega
    rcases hrem with hrem | hrem
    · let t := y / 6
      have hyt : y = 6 * t + 2 := by omega
      have ht : 1 ≤ t := by omega
      simpa [OrderedWitness, hyt] using witness_6t_add2 ht
    · let t := y / 6
      have hyt : y = 6 * t + 5 := by omega
      have ht : 1 ≤ t := by omega
      simpa [OrderedWitness, hyt] using witness_6t_add5 ht

/-- Every integer at least seven outside the literal witness set `S` has an
ordered exclusion witness inside `S` and strictly below the integer. -/
theorem witness_of_not_memS {y : Nat} (hy : 7 ≤ y)
    (hyS : y ∉ S) :
    ∃ u v w, u ∈ S ∧ v ∈ S ∧ w ∈ S ∧
      u ≤ v ∧ v ≤ w ∧ w < y ∧ y + w = u * v := by
  have hymod : y % 3 ≠ 1 := fun h ↦ hyS ((mem_S_iff y).2 (Or.inr h))
  simpa only [OrderedWitness, InS] using witness_of_not_memS_core hy hymod

private theorem index_of_memS {z n : Nat} (hz : InS z) (hn : 3 ≤ n)
    (hzlt : z < target n) : ∃ i, 1 ≤ i ∧ i < n ∧ target i = z := by
  rw [InS, mem_S_iff] at hz
  rcases hz with rfl | hz
  · exact ⟨2, by omega, by rw [target_formula hn] at hzlt; omega, target_two⟩
  · let t := z / 3
    have hzt : z = 3 * t + 1 := by omega
    by_cases ht : t = 0
    · refine ⟨1, by omega, by omega, ?_⟩
      rw [target_one]
      omega
    · have hit : 3 ≤ t + 2 := by omega
      have hnt : t + 2 < n := by
        rw [target_formula hn] at hzlt
        omega
      refine ⟨t + 2, by omega, hnt, ?_⟩
      rw [target_formula hit]
      omega

private theorem ordered_indices_of_values {n u v w : Nat} (hn : 3 ≤ n)
    (hu : InS u) (hv : InS v) (hw : InS w)
    (huv : u ≤ v) (hvw : v ≤ w) (hwlt : w < target n) :
    ∃ i j k, 1 ≤ i ∧ i ≤ j ∧ j ≤ k ∧ k < n ∧
      target i = u ∧ target j = v ∧ target k = w := by
  obtain ⟨i, hi1, hin, hiu⟩ := index_of_memS hu hn (lt_of_le_of_lt (huv.trans hvw) hwlt)
  obtain ⟨j, hj1, hjn, hjv⟩ := index_of_memS hv hn (lt_of_le_of_lt hvw hwlt)
  obtain ⟨k, hk1, hkn, hkw⟩ := index_of_memS hw hn hwlt
  have hij : i ≤ j := by
    by_contra h
    have hmono := target_strictMonoOn hj1 (by omega : j < i)
    rw [hiu, hjv] at hmono
    omega
  have hjk : j ≤ k := by
    by_contra h
    have hmono := target_strictMonoOn hk1 (by omega : k < j)
    rw [hjv, hkw] at hmono
    omega
  exact ⟨i, j, k, hi1, hij, hjk, hkn, hiu, hjv, hkw⟩

private theorem orderedWitness_excluded {n y : Nat} (hn : 3 ≤ n)
    (hy : OrderedWitness y) (hylt : y < target n) : Excluded target n y := by
  rcases hy with ⟨u, v, w, hu, hv, hw, huv, hvw, hwlt, heq⟩
  obtain ⟨i, j, k, hi1, hij, hjk, hkn, hiu, hjv, hkw⟩ :=
    ordered_indices_of_values hn hu hv hw huv hvw (hwlt.trans hylt)
  have hin : i < n := lt_of_le_of_lt hij (lt_of_le_of_lt hjk hkn)
  have hjn : j < n := lt_of_le_of_lt hjk hkn
  refine ⟨i, j, k, hi1, hij, hjk, hkn.le, ?_⟩
  simpa [candidateValue, ne_of_lt hin, ne_of_lt hjn, ne_of_lt hkn, hiu, hjv, hkw] using heq

private theorem candidateValue_target (n r : Nat) :
    candidateValue target n (target n) r = target r := by
  unfold candidateValue
  split
  · next h => subst r; rfl
  · rfl

private theorem target_not_excluded_of_ge_three {n : Nat} (hn : 3 ≤ n) :
    ¬ Excluded target n (target n) := by
  rintro ⟨i, j, k, hi1, hij, hjk, hkn, heq⟩
  have hj1 : 1 ≤ j := hi1.trans hij
  have hk1 : 1 ≤ k := hj1.trans hjk
  have hbad := residue_protection_core (x := target n)
    (by rw [target_formula hn]; omega) (target_memS (by omega))
    (target_memS hi1) (target_memS hj1) (target_memS hk1)
    (target_le_target hi1 hij) (target_le_target hj1 hjk)
  apply hbad
  simpa [candidateValue_target] using heq

private theorem target_not_excluded_two : ¬ Excluded target 2 (target 2) := by
  rintro ⟨i, j, k, hi1, hij, hjk, hkn, heq⟩
  have hi : i = 1 ∨ i = 2 := by omega
  have hj : j = 1 ∨ j = 2 := by omega
  have hk : k = 1 ∨ k = 2 := by omega
  rcases hi with rfl | rfl <;> rcases hj with rfl | rfl <;> rcases hk with rfl | rfl <;>
    norm_num [candidateValue, target] at heq

private theorem target_admissible {n : Nat} (hn : 2 ≤ n) : Admissible target n (target n) := by
  refine ⟨target_pos (by omega), target_strictMonoOn (by omega) (by omega), ?_⟩
  by_cases hn2 : n = 2
  · subst n
    exact target_not_excluded_two
  · exact target_not_excluded_of_ge_three (by omega)

private theorem two_excluded : Excluded target 2 2 := by
  refine ⟨2, 2, 2, by omega, by omega, by omega, by omega, ?_⟩
  norm_num [candidateValue, target]

private theorem five_excluded {n : Nat} (hn : 4 ≤ n) : Excluded target n 5 := by
  refine ⟨2, 2, 3, by omega, by omega, by omega, by omega, ?_⟩
  norm_num [candidateValue, target, show 2 ≠ n by omega, show 3 ≠ n by omega]

private theorem six_excluded {n : Nat} (hn : 4 ≤ n) : Excluded target n 6 := by
  refine ⟨2, 2, 2, by omega, by omega, by omega, by omega, ?_⟩
  norm_num [candidateValue, target, show 2 ≠ n by omega]

private theorem target_excludes_between {n y : Nat} (hn : 2 ≤ n)
    (hprev : target (n - 1) < y) (hylt : y < target n) : Excluded target n y := by
  by_cases hn2 : n = 2
  · subst n
    have hy : y = 2 := by norm_num [target] at hprev hylt ⊢; omega
    subst y
    exact two_excluded
  by_cases hn3 : n = 3
  · subst n
    norm_num [target] at hprev hylt
    omega
  by_cases hn4 : n = 4
  · subst n
    have hy : y = 5 ∨ y = 6 := by norm_num [target] at hprev hylt ⊢; omega
    rcases hy with rfl | rfl
    · exact five_excluded (by omega)
    · exact six_excluded (by omega)
  have hn3' : 3 ≤ n := by omega
  have hnprev : 3 ≤ n - 1 := by omega
  have hy7 : 7 ≤ y := by rw [target_formula hnprev] at hprev; omega
  have hymod : y % 3 ≠ 1 := by
    rw [target_formula hnprev] at hprev
    rw [target_formula hn3'] at hylt
    omega
  exact orderedWitness_excluded hn3' (witness_of_not_memS_core hy7 hymod) hylt

private theorem target_isLeast {n : Nat} (hn : 2 ≤ n) :
    IsLeast {x | Admissible target n x} (target n) := by
  refine ⟨target_admissible hn, ?_⟩
  intro y hy
  by_contra hnot
  have hylt : y < target n := by omega
  exact hy.2.2 (target_excludes_between hn hy.2.1 hylt)

private theorem target_satisfies_literal_rule : SatisfiesLiteralRule target := by
  apply (satisfiesLiteralRule_iff_additive target).2
  exact ⟨target_zero, target_one,
    fun n hn ↦ isLeast_admissible_iff.mp (target_isLeast hn)⟩

private theorem excluded_congr_history {a b : Nat → Nat} {n x : Nat}
    (h : ∀ r, 1 ≤ r → r < n → a r = b r) : Excluded a n x ↔ Excluded b n x := by
  have hcandidate (r : Nat) (hr1 : 1 ≤ r) (hrn : r ≤ n) :
      candidateValue a n x r = candidateValue b n x r := by
    unfold candidateValue
    split
    · rfl
    · next hrne => exact h r hr1 (lt_of_le_of_ne hrn hrne)
  constructor <;>
    rintro ⟨i, j, k, hi1, hij, hjk, hkn, heq⟩ <;>
    refine ⟨i, j, k, hi1, hij, hjk, hkn, ?_⟩ <;>
    simpa [hcandidate i hi1 (hij.trans (hjk.trans hkn)),
      hcandidate j (hi1.trans hij) (hjk.trans hkn),
      hcandidate k (hi1.trans (hij.trans hjk)) hkn] using heq

private theorem admissible_congr_history {a b : Nat → Nat} {n x : Nat} (hn : 2 ≤ n)
    (h : ∀ r, 1 ≤ r → r < n → a r = b r) : Admissible a n x ↔ Admissible b n x := by
  have hprev : a (n - 1) = b (n - 1) := h (n - 1) (by omega) (by omega)
  simp only [Admissible, hprev, excluded_congr_history h]

private theorem target_unique (a : Nat → Nat) (ha : SatisfiesLiteralRule a) : a = target := by
  have haAdditive := (satisfiesLiteralRule_iff_additive a).mp ha
  funext n
  induction n using Nat.strong_induction_on with
  | h n ih =>
      by_cases hn0 : n = 0
      · subst n
        exact ha.1.trans target_zero.symm
      by_cases hn1 : n = 1
      · subst n
        exact ha.2.1.trans target_one.symm
      have hn2 : 2 ≤ n := by omega
      have hhist : ∀ r, 1 ≤ r → r < n → a r = target r := by
        intro r _ hrn
        exact ih r hrn
      have hadm := isLeast_admissible_iff.mpr (haAdditive.2.2 n hn2)
      have ht := target_isLeast hn2
      apply le_antisymm
      · exact hadm.2 ((admissible_congr_history hn2 hhist).2 ht.1)
      · exact ht.2 ((admissible_congr_history hn2 hhist).1 hadm.1)

/-- A well-founded recursive realization of the literal greedy construction.
Each step uses `Nat.find` on the finite history, with an unreachable zero fallback. -/
noncomputable def sequence : Nat → Nat
  | 0 => 0
  | 1 => 1
  | n + 2 => by
      classical
      let history : Nat → Nat := fun r => if hr : r < n + 2 then sequence r else 0
      exact if hex : ∃ x, Admissible history (n + 2) x then Nat.find hex else 0
termination_by n => n
decreasing_by omega

private theorem sequence_eq_target (n : Nat) : sequence n = target n := by
  induction n using Nat.strong_induction_on with
  | h n ih =>
      rcases n with _ | _ | n
      · simp [sequence, target]
      · simp [sequence, target]
      · classical
        let history : Nat → Nat := fun r => if hr : r < n + 2 then sequence r else 0
        have hhist : ∀ r, 1 ≤ r → r < n + 2 → history r = target r := by
          intro r _ hr
          simp only [history, dif_pos hr]
          exact ih r (by omega)
        have hadmiff (x : Nat) :
            Admissible history (n + 2) x ↔ Admissible target (n + 2) x :=
          admissible_congr_history (by omega) hhist
        have htarget := target_admissible (n := n + 2) (by omega)
        have hex : ∃ x, Admissible history (n + 2) x :=
          ⟨target (n + 2), (hadmiff _).2 htarget⟩
        rw [sequence]
        change (if h : ∃ x, Admissible history (n + 2) x then Nat.find h else 0) =
          target (n + 2)
        rw [dif_pos hex]
        apply le_antisymm
        · exact Nat.find_min' hex ((hadmiff _).2 htarget)
        · exact (target_isLeast (n := n + 2) (by omega)).2
            ((hadmiff _).1 (Nat.find_spec hex))

/-- The recursively constructed sequence satisfies the literal candidate-inclusive rule. -/
theorem sequence_satisfies_literal_rule : SatisfiesLiteralRule sequence := by
  rw [show sequence = target from funext sequence_eq_target]
  exact target_satisfies_literal_rule

/-- The initial value required by the name line. -/
theorem sequence_one : sequence 1 = 1 := by
  rw [sequence_eq_target, target_one]

/-- The first value selected after the initial value. -/
theorem sequence_two : sequence 2 = 3 := by
  rw [sequence_eq_target, target_two]

/-- At every later index, `sequence n` is the least positive value above its
predecessor that passes the candidate-inclusive multiplicative exclusion test. -/
theorem sequence_recurrence (n : Nat) (hn : 2 ≤ n) :
    (0 < sequence n ∧ sequence (n - 1) < sequence n ∧
      ∀ i j k, 1 ≤ i → i ≤ j → j ≤ k → k ≤ n →
        ((sequence n : Int) ≠
          ((if i = n then sequence n else sequence i : Nat) : Int) *
              ((if j = n then sequence n else sequence j : Nat) : Int) -
            ((if k = n then sequence n else sequence k : Nat) : Int))) ∧
    ∀ x,
      (0 < x ∧ sequence (n - 1) < x ∧
        ∀ i j k, 1 ≤ i → i ≤ j → j ≤ k → k ≤ n →
          ((x : Int) ≠
            ((if i = n then x else sequence i : Nat) : Int) *
                ((if j = n then x else sequence j : Nat) : Int) -
              ((if k = n then x else sequence k : Nat) : Int))) →
        sequence n ≤ x := by
  exact sequence_satisfies_literal_rule.2.2 n hn

/-- There is exactly one totalized sequence satisfying the literal rule. -/
theorem literal_rule_unique : ∃! a : Nat → Nat, SatisfiesLiteralRule a := by
  refine ⟨sequence, sequence_satisfies_literal_rule, ?_⟩
  intro a ha
  exact (target_unique a ha).trans (funext sequence_eq_target).symm

/-- The OEIS A026488 conjecture: after `1, 3`, every term is congruent to one
modulo three, and the exact one-based formula is `3 * n - 5`. -/
theorem sequence_formula :
    sequence 2 = 3 ∧ ∀ n : Nat, 3 ≤ n → sequence n = 3 * n - 5 := by
  exact ⟨sequence_two, fun n hn ↦ (sequence_eq_target n).trans (target_formula hn)⟩

-- Fidelity witnesses: the candidate participates at n=2 and all public domains are inhabited.
example : Excluded target 2 2 := two_excluded
example :
    4 ≤ (4 : Nat) ∧ 4 ∈ S ∧ 4 ∈ S ∧ 4 ∈ S ∧ 4 ∈ S ∧ 4 ≤ 4 ∧ 4 ≤ 4 := by
  norm_num [mem_S_iff]
example : ∃ a : Nat → Nat, SatisfiesLiteralRule a :=
  ⟨sequence, sequence_satisfies_literal_rule⟩
example : ∃ y : Nat, 7 ≤ y ∧ y ∉ S := by
  refine ⟨8, by norm_num, ?_⟩
  rw [mem_S_iff]
  norm_num

#print axioms S
#print axioms mem_S_iff
#print axioms SatisfiesLiteralRule
#print axioms literal_exclusion_iff_additive
#print axioms satisfiesLiteralRule_iff_additive
#print axioms residue_protection
#print axioms witness_of_not_memS
#print axioms sequence
#print axioms sequence_satisfies_literal_rule
#print axioms sequence_one
#print axioms sequence_two
#print axioms sequence_recurrence
#print axioms literal_rule_unique
#print axioms sequence_formula

end D5.S1.Recurrence.MultiplicativeExclusionResidueClass
