/- GID: D5/S3/Arith/GoldenResource/IntegerFischerSelector
   generality: G
   mirror-B: D5/B/S3/Arith/GoldenResource/IntegerFischerSelector
   mirror-E: none(waiver:general-matrix-inequality)
   anchors: []
   utility: none
   digest: Fischer bounds give a dimension-independent gap for the integer log selector. -/

import D5.S3.Arith.GoldenResource.IntegerHadamard
import D5.S3.Arith.GoldenResource.DiscreteLogSelector
import Mathlib.LinearAlgebra.Matrix.Transvection

namespace D5.S3.Arith.GoldenResource.IntegerFischerSelector

open Matrix
open scoped ComplexOrder MatrixOrder

noncomputable section

variable {n : Type*} [Fintype n] [DecidableEq n]

private theorem real_hadamard {A : Matrix n n ℝ} (hA : A.PosDef) :
    A.det ≤ ∏ i, A i i :=
  (D5.S3.Arith.GoldenResource.IntegerHadamard.real_posDef_hadamard hA).1

private theorem prod_pair_complement (d : n → ℝ) {i j : n} (hij : i ≠ j) :
    ∏ l, d l = (d i * d j) * ∏ l ∈ Finset.univ \ {i, j}, d l := by
  have h := Finset.prod_sdiff (f := d) (Finset.subset_univ ({i, j} : Finset n))
  rw [Finset.prod_pair hij] at h
  simpa [mul_comm] using h.symm

/-- Fischer's determinant bound retaining a specified two-coordinate principal block. -/
theorem fischer_two_block (T : Matrix n n ℝ) (hT : T.PosDef) {i j : n} (hij : i ≠ j) :
    T.det ≤ (T i i * T j j - T i j * T j i) * ∏ l ∈ Finset.univ \ {i, j}, T l l := by
  let c := -T i j / T i i
  let Q := transvection i j c
  let S := Qᴴ * T * Q
  have hQ : Q.det = 1 := det_transvection_of_ne i j hij c
  have hS : S.PosDef := hT.conjTranspose_mul_mul_same
    (mulVec_injective_of_det_ne_zero (by rw [hQ]; exact one_ne_zero))
  have hQt : Qᴴ = transvection j i c := by
    simp [Q, transvection]
  have hd : S.det = T.det := by simp [S, det_mul, hQ]
  have hother (l : n) (hl : l ≠ j) : S l l = T l l := by
    simp only [S, hQt, Q, mul_transvection_apply_of_ne _ _ _ _ hl,
      transvection_mul_apply_of_ne _ _ _ _ hl]
  have hjj : S j j = T j j - T j i * T i j / T i i := by
    simp only [S, hQt, Q, mul_transvection_apply_same, transvection_mul_apply_same]
    dsimp [c]
    field_simp [ne_of_gt (hT.diag_pos (i := i))]
    ring
  have hp : ∏ l, S l l =
      (T i i * T j j - T i j * T j i) * ∏ l ∈ Finset.univ \ {i, j}, T l l := by
    rw [prod_pair_complement (fun l => S l l) hij, hother i hij, hjj]
    have hr : ∏ l ∈ Finset.univ \ {i, j}, S l l =
        ∏ l ∈ Finset.univ \ {i, j}, T l l := by
      apply Finset.prod_congr rfl
      intro l hl
      apply hother
      have hm : l ≠ i ∧ l ≠ j := by simpa using hl
      exact hm.2
    rw [hr]
    congr 1
    field_simp [ne_of_gt (hT.diag_pos (i := i))]
  simpa [hd, hp] using real_hadamard hS

/-- A nonzero off-diagonal integer entry gives a multiplicative determinant loss. -/
theorem integer_fischer_gap (T : Matrix n n ℤ)
    (hT : (T.map fun z => (z : ℝ)).PosDef) {i j : n}
    (hij : i ≠ j) (hoff : T i j ≠ 0) :
    T.det * (T i i * T j j) ≤ (T i i * T j j - 1) * ∏ l, T l l := by
  have hf := fischer_two_block (T.map fun z => (z : ℝ)) hT hij
  rw [← Int.cast_det] at hf
  simp only [Matrix.map_apply] at hf
  have hfi : T.det ≤ (T i i * T j j - T i j * T j i) *
      ∏ l ∈ Finset.univ \ {i, j}, T l l := by exact_mod_cast hf
  have hsym : T j i = T i j := by
    have h := hT.isHermitian.apply i j
    simpa using h
  have hsquare : 1 ≤ T i j * T j i := by
    rw [hsym]
    have h := sq_pos_of_ne_zero hoff
    nlinarith
  have hdiag := (IntegerHadamard.integer_posDef_hadamard T hT).1
  have hr : 0 ≤ ∏ l ∈ Finset.univ \ {i, j}, T l l :=
    Finset.prod_nonneg fun l _ => le_of_lt (hdiag l)
  have hbound : T.det ≤ (T i i * T j j - 1) *
      ∏ l ∈ Finset.univ \ {i, j}, T l l :=
    hfi.trans (mul_le_mul_of_nonneg_right (by linarith) hr)
  have hp := Finset.prod_sdiff (f := fun l => T l l)
    (Finset.subset_univ ({i, j} : Finset n))
  rw [Finset.prod_pair hij] at hp
  calc
    T.det * (T i i * T j j) ≤
        ((T i i * T j j - 1) * ∏ l ∈ Finset.univ \ {i, j}, T l l) *
          (T i i * T j j) :=
      mul_le_mul_of_nonneg_right hbound (le_of_lt (mul_pos (hdiag i) (hdiag j)))
    _ = (T i i * T j j - 1) * ∏ l, T l l := by rw [mul_assoc, hp]

/-- The smaller scalar endpoint margin and the two-coordinate determinant loss. -/
def selectorGap (k : ℕ) (p : ℝ) : ℝ :=
  min (min (Real.log ((k : ℝ) / (k - 1 : ℕ)) - p)
    (p - Real.log (((k + 1 : ℕ) : ℝ) / k)))
    (Real.log ((k : ℝ) ^ 2) - Real.log ((k : ℝ) ^ 2 - 1))

/-- On the strict price window, the two-coordinate loss is redundant. -/
theorem selectorGap_eq_min {k : ℕ} (hk : 2 ≤ k) {p : ℝ}
    (hlo : Real.log (((k + 1 : ℕ) : ℝ) / k) < p)
    (hhi : p < Real.log ((k : ℝ) / (k - 1 : ℕ))) :
    selectorGap k p =
      min (Real.log ((k : ℝ) / (k - 1 : ℕ)) - p)
          (p - Real.log (((k + 1 : ℕ) : ℝ) / k)) := by
  have hkpos : 0 < (k : ℝ) := by exact_mod_cast (show 0 < k by omega)
  have hmpos : 0 < ((k - 1 : ℕ) : ℝ) := by
    exact_mod_cast (show 0 < k - 1 by omega)
  have hppos : 0 < ((k + 1 : ℕ) : ℝ) := by positivity
  have hfactor : (k : ℝ) ^ 2 - 1 =
      ((k - 1 : ℕ) : ℝ) * ((k + 1 : ℕ) : ℝ) := by
    rw [Nat.cast_sub (show 1 ≤ k by omega), Nat.cast_add, Nat.cast_one]
    ring
  have hsum : (Real.log ((k : ℝ) / (k - 1 : ℕ)) - p) +
      (p - Real.log (((k + 1 : ℕ) : ℝ) / k)) =
      Real.log ((k : ℝ) ^ 2) - Real.log ((k : ℝ) ^ 2 - 1) := by
    rw [hfactor, Real.log_mul hmpos.ne' hppos.ne',
      Real.log_div hkpos.ne' hmpos.ne', Real.log_div hppos.ne' hkpos.ne', Real.log_pow]
    ring
  unfold selectorGap
  rw [← hsum]
  apply min_eq_left
  have ha := sub_pos.mpr hhi
  have hb := sub_pos.mpr hlo
  have hmin := min_le_left (Real.log ((k : ℝ) / (k - 1 : ℕ)) - p)
    (p - Real.log (((k + 1 : ℕ) : ℝ) / k))
  linarith

/-- The selector gap is positive throughout the strict price window. -/
theorem selectorGap_pos {k : ℕ} (hk : 2 ≤ k) {p : ℝ}
    (hlo : Real.log (((k + 1 : ℕ) : ℝ) / k) < p)
    (hhi : p < Real.log ((k : ℝ) / (k - 1 : ℕ))) :
    0 < selectorGap k p := by
  have hkR : (2 : ℝ) ≤ k := by exact_mod_cast hk
  have hs : 0 < (k : ℝ) ^ 2 - 1 := by nlinarith
  exact lt_min (lt_min (sub_pos.mpr hhi) (sub_pos.mpr hlo))
    (sub_pos.mpr (Real.strictMonoOn_log hs
      (show 0 < (k : ℝ) ^ 2 by nlinarith) (by linarith)))

private theorem integer_scalar_bound {k : ℕ} (hk : 2 ≤ k) {p : ℝ}
    (hlo : Real.log (((k + 1 : ℕ) : ℝ) / k) < p)
    (hhi : p < Real.log ((k : ℝ) / (k - 1 : ℕ)))
    (t : ℤ) (ht : 0 < t) :
    Real.log (t : ℝ) - p * t ≤ Real.log (k : ℝ) - p * k ∧
      (t ≠ (k : ℤ) → selectorGap k p ≤
        (Real.log (k : ℝ) - p * k) - (Real.log (t : ℝ) - p * t)) := by
  have hcZ := Int.toNat_of_nonneg (le_of_lt ht)
  have hc : (t.toNat : ℝ) = (t : ℝ) := by exact_mod_cast hcZ
  have hn : 0 < t.toNat := by omega
  have h := DiscreteLogSelector.discrete_log_unique_maximum hk hlo hhi t.toNat hn
  change (Real.log (t.toNat : ℝ) - p * t.toNat ≤ Real.log (k : ℝ) - p * k) ∧
    (t.toNat ≠ k → min (Real.log ((k : ℝ) / (k - 1 : ℕ)) - p)
      (p - Real.log (((k + 1 : ℕ) : ℝ) / k)) ≤
      (Real.log (k : ℝ) - p * k) - (Real.log (t.toNat : ℝ) - p * t.toNat)) at h
  rw [hc] at h
  refine ⟨h.1, fun hne => (min_le_left _ _).trans (h.2 ?_)⟩
  intro heq
  apply hne
  rw [heq] at hcZ
  exact hcZ.symm

/-- The strict scalar price window selects the scalar integer matrix, with a gap
depending only on the selected integer and the price, for every finite dimension. -/
theorem integer_log_unique_maximum {k : ℕ} (hk : 2 ≤ k) {p : ℝ}
    (hlo : Real.log (((k + 1 : ℕ) : ℝ) / k) < p)
    (hhi : p < Real.log ((k : ℝ) / (k - 1 : ℕ)))
    (T : Matrix n n ℤ) (hT : (T.map fun z => (z : ℝ)).PosDef) :
    0 < selectorGap k p ∧
      Real.log (T.det : ℝ) - p * (T.trace : ℝ) ≤
        (Fintype.card n : ℝ) * (Real.log (k : ℝ) - p * k) ∧
      (T ≠ (k : ℤ) • (1 : Matrix n n ℤ) →
        Real.log (T.det : ℝ) - p * (T.trace : ℝ) ≤
          (Fintype.card n : ℝ) * (Real.log (k : ℝ) - p * k) - selectorGap k p) := by
  let b := Real.log (k : ℝ) - p * k
  let f : n → ℝ := fun i => Real.log (T i i : ℝ) - p * (T i i : ℝ)
  have hdata := IntegerHadamard.integer_posDef_hadamard T hT
  have hd : 0 < (T.det : ℝ) := by exact_mod_cast hdata.2.1
  have hdiag (i : n) : 0 < (T i i : ℝ) := by exact_mod_cast hdata.1 i
  have hprod : 0 < ∏ i, (T i i : ℝ) := Finset.prod_pos fun i _ => hdiag i
  have hlog : Real.log (T.det : ℝ) ≤ ∑ i, Real.log (T i i : ℝ) := by
    calc
      Real.log (T.det : ℝ) ≤ Real.log (∏ i, (T i i : ℝ)) :=
        Real.log_le_log hd (by exact_mod_cast hdata.2.2.1)
      _ = ∑ i, Real.log (T i i : ℝ) := Real.log_prod fun i _ => (hdiag i).ne'
  have hscalar (i : n) : f i ≤ b ∧
      (T i i ≠ (k : ℤ) → selectorGap k p ≤ b - f i) :=
    integer_scalar_bound hk hlo hhi (T i i) (hdata.1 i)
  have hsum : ∑ i, f i = ∑ i, Real.log (T i i : ℝ) - p * (T.trace : ℝ) := by
    simp [f, Finset.sum_sub_distrib, ← Finset.mul_sum, Matrix.trace]
  have hsumle : ∑ i, f i ≤ (Fintype.card n : ℝ) * b := by
    simpa using Finset.sum_le_sum (s := Finset.univ) (fun i _ => (hscalar i).1)
  refine ⟨selectorGap_pos hk hlo hhi, ?_, ?_⟩
  · change Real.log (T.det : ℝ) - p * (T.trace : ℝ) ≤ (Fintype.card n : ℝ) * b
    linarith
  · intro hoff
    change Real.log (T.det : ℝ) - p * (T.trace : ℝ) ≤
      (Fintype.card n : ℝ) * b - selectorGap k p
    by_cases hall : ∀ i, T i i = (k : ℤ)
    · have hx : ∃ i j, i ≠ j ∧ T i j ≠ 0 := by
        by_contra! hz
        apply hoff
        ext i j
        by_cases hij : i = j
        · subst j
          simp [hall]
        · simp [hij, hz i j hij]
      obtain ⟨i, j, hij, hoffij⟩ := hx
      have hf := integer_fischer_gap T hT hij hoffij
      rw [hall i, hall j] at hf
      have hfR : (T.det : ℝ) * (k : ℝ) ^ 2 ≤
          ((k : ℝ) ^ 2 - 1) * ∏ l, (T l l : ℝ) := by
        simp only [pow_two]
        exact_mod_cast hf
      have hkR : (2 : ℝ) ≤ k := by exact_mod_cast hk
      have hk2 : 0 < (k : ℝ) ^ 2 := by nlinarith
      have hk2m : 0 < (k : ℝ) ^ 2 - 1 := by nlinarith
      have hlg := Real.log_le_log (mul_pos hd hk2) hfR
      rw [Real.log_mul hd.ne' hk2.ne', Real.log_mul hk2m.ne' hprod.ne',
        Real.log_prod (fun l _ => (hdiag l).ne')] at hlg
      have hsumEq : ∑ l, f l = (Fintype.card n : ℝ) * b := by
        simp [f, b, hall, mul_sub]
      have hgap : selectorGap k p ≤
          Real.log ((k : ℝ) ^ 2) - Real.log ((k : ℝ) ^ 2 - 1) := min_le_right _ _
      linarith
    · push Not at hall
      obtain ⟨i, hi⟩ := hall
      have hiGap := (hscalar i).2 hi
      have hsingle : b - f i ≤ ∑ l, (b - f l) :=
        Finset.single_le_sum (fun l _ => sub_nonneg.mpr (hscalar l).1) (Finset.mem_univ i)
      have hgapSum : ∑ l, (b - f l) = (Fintype.card n : ℝ) * b - ∑ l, f l := by
        simp [Finset.sum_sub_distrib]
      linarith

private theorem diagonal_single_loss {k : ℕ} (hk : 2 ≤ k) (p : ℝ)
    (i₀ : n) (t : ℤ) (ht : 0 < t) (hne : t ≠ (k : ℤ)) :
    ∃ T : Matrix n n ℤ, (T.map fun z => (z : ℝ)).PosDef ∧
      T ≠ (k : ℤ) • (1 : Matrix n n ℤ) ∧
      Real.log ((k : ℝ) ^ Fintype.card n) - p * ((Fintype.card n : ℝ) * k) -
        (Real.log (T.det : ℝ) - p * (T.trace : ℝ)) =
        (Real.log (k : ℝ) - p * k) - (Real.log (t : ℝ) - p * t) := by
  let d : n → ℤ := fun i => if i = i₀ then t else k
  have hd (i : n) : 0 < (d i : ℝ) := by
    dsimp [d]
    split_ifs
    · exact_mod_cast ht
    · exact_mod_cast (show 0 < k by omega)
  refine ⟨diagonal d, ?_, ?_, ?_⟩
  · rw [diagonal_map (Int.cast_zero : ((0 : ℤ) : ℝ) = 0)]
    exact Matrix.PosDef.diagonal hd
  · intro heq
    have hii := congrArg (fun A : Matrix n n ℤ => A i₀ i₀) heq
    exact hne (by simpa [d] using hii)
  · have hlog : Real.log ((diagonal d).det : ℝ) = ∑ i, Real.log (d i : ℝ) := by
      rw [det_diagonal, Int.cast_prod]
      exact Real.log_prod fun i _ => (hd i).ne'
    have htrace : ((diagonal d).trace : ℝ) = ∑ i, (d i : ℝ) := by
      simp [trace_diagonal]
    calc
      _ = ∑ i, ((Real.log (k : ℝ) - p * k) -
          (Real.log (d i : ℝ) - p * (d i : ℝ))) := by
        rw [hlog, htrace, Real.log_pow]
        simp only [Finset.sum_sub_distrib, Finset.sum_const, Finset.card_univ,
          nsmul_eq_mul, ← Finset.mul_sum]
        ring
      _ = (Real.log (k : ℝ) - p * k) - (Real.log (t : ℝ) - p * t) := by
        rw [Finset.sum_eq_single i₀]
        · simp [d]
        · intro j _ hj
          simp [d, hj]
        · simp

/-- In every nonempty finite dimension, a distinct positive definite integer matrix
attains exactly the selector gap by changing one diagonal entry to an adjacent integer. -/
theorem selectorGap_sharp {k : ℕ} (hk : 2 ≤ k) {p : ℝ}
    (hlo : Real.log (((k + 1 : ℕ) : ℝ) / k) < p)
    (hhi : p < Real.log ((k : ℝ) / (k - 1 : ℕ))) [Nonempty n] :
    ∃ T : Matrix n n ℤ, (T.map fun z => (z : ℝ)).PosDef ∧
      T ≠ (k : ℤ) • (1 : Matrix n n ℤ) ∧
      Real.log ((k : ℝ) ^ Fintype.card n) - p * ((Fintype.card n : ℝ) * k) -
        (Real.log (T.det : ℝ) - p * (T.trace : ℝ)) = selectorGap k p := by
  obtain ⟨i₀⟩ := ‹Nonempty n›
  have hkZ : (2 : ℤ) ≤ k := by exact_mod_cast hk
  have hkpos : 0 < (k : ℝ) := by exact_mod_cast (show 0 < k by omega)
  rw [selectorGap_eq_min hk hlo hhi]
  by_cases hmin : Real.log ((k : ℝ) / (k - 1 : ℕ)) - p ≤
      p - Real.log (((k + 1 : ℕ) : ℝ) / k)
  · rw [min_eq_left hmin]
    obtain ⟨T, hT, hne, hloss⟩ :=
      diagonal_single_loss hk p i₀ ((k : ℤ) - 1) (by omega) (by omega)
    refine ⟨T, hT, hne, hloss.trans ?_⟩
    have hmpos : 0 < ((k - 1 : ℕ) : ℝ) := by
      exact_mod_cast (show 0 < k - 1 by omega)
    rw [Real.log_div hkpos.ne' hmpos.ne',
      Nat.cast_sub (show 1 ≤ k by omega), Nat.cast_one]
    push_cast
    ring
  · rw [min_eq_right (le_of_not_ge hmin)]
    obtain ⟨T, hT, hne, hloss⟩ :=
      diagonal_single_loss hk p i₀ ((k : ℤ) + 1) (by omega) (by omega)
    refine ⟨T, hT, hne, hloss.trans ?_⟩
    have hppos : 0 < ((k + 1 : ℕ) : ℝ) := by positivity
    rw [Real.log_div hppos.ne' hkpos.ne']
    push_cast
    ring

#print axioms fischer_two_block
#print axioms integer_fischer_gap
#print axioms selectorGap_eq_min
#print axioms selectorGap_pos
#print axioms integer_log_unique_maximum
#print axioms selectorGap_sharp

end
end D5.S3.Arith.GoldenResource.IntegerFischerSelector
