/- GID: D5/S1/Words/Compositions/StrictFirstSumsGapfreeOddParts
   generality: G
   mirror-B: D5/B/S1/Words/Compositions/StrictFirstSumsGapfreeOddParts
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: Strict zero-prepended first sums correspond to gapfree odd partitions. -/

import D5.S1.Words.Compositions.ZeroPrependedFirstSumsOddParts

/-!
# Strict first sums and gapfree odd parts

The weak correspondence is reused from the frozen sibling. Its auxiliary
constants are private in a legacy (non-module-system) file, so `import all`
is unavailable. The local elaborator below returns the unique existing
constant; it creates no mathematical declaration and copies no proof.
This explicit coupling can disappear when an upstream public API is available.

The new content is the strict-row/complete-column-height characterization.
The empty partition is included: these counts have constant term one,
whereas the OEIS A053251 mock theta series has constant term zero.
-/

namespace D5.S1.Words.Compositions.StrictFirstSumsGapfreeOddParts

open FirstSumsPartitionCharacterization ZeroPrependedFirstSumsOddParts

open Lean Elab Term in
local elab "sibling% " n:ident : term => do
  let userName := `D5.S1.Words.Compositions.ZeroPrependedFirstSumsOddParts ++ n.getId
  let found := (← getEnv).constants.toList.filter
    (fun (name, _) => privateToUserName? name == some userName)
  match found with
  | [(name, info)] => return mkConst name (info.levelParams.map Level.param)
  | _ => throwError "Expected one frozen sibling declaration: {userName}"

/-- Adjacent sums after prepending zero to a strictly increasing positive list. -/
def IsStrictFirstSums (y : List ℕ) : Prop :=
  ∃ s : List ℕ, s.Pairwise (· < ·) ∧ (∀ x ∈ s, 0 < x) ∧ firstSums (0 :: s) = y

/-- The support is exactly `{1,3,...,2*k-1}` for some k, including k=0. -/
def GapfreeOdd (m : Multiset ℕ) : Prop :=
  ∃ k : ℕ, ∀ x : ℕ, x ∈ m ↔ ∃ i < k, x = 2 * i + 1

private theorem strict_implies_weak {y : List ℕ} (hy : IsStrictFirstSums y) :
    IsZeroPrependedFirstSums y := by
  obtain ⟨s, hs, hp, he⟩ := hy
  exact ⟨s, hs.imp (fun h => Nat.le_of_lt h), hp, he⟩

private theorem gapfree_implies_odd {m : Multiset ℕ} (hm : GapfreeOdd m) :
    ∀ x ∈ m, ¬ Even x := by
  obtain ⟨k, hk⟩ := hm
  intro x hx
  obtain ⟨i, _, rfl⟩ := (hk x).mp hx
  rw [Nat.even_iff]
  omega

private theorem rowLen_zero (d : YoungDiagram) (i : ℕ) (hi : d.colLen 0 ≤ i) :
    d.rowLen i = 0 := by
  have h : ¬ (i, 0) ∈ d := by rw [YoungDiagram.mem_iff_lt_colLen]; omega
  rw [YoungDiagram.mem_iff_lt_rowLen] at h
  omega

-- Height h occurs among the columns precisely at a strict drop after row h-1.
private theorem height_mem_iff (d : YoungDiagram) (h : ℕ) (hp : 0 < h) :
    h ∈ d.transpose.rowLens ↔ d.rowLen h < d.rowLen (h - 1) := by
  constructor
  · intro hm
    obtain ⟨j, hj, he⟩ := List.mem_map.mp hm
    change d.transpose.rowLen j = h at he
    rw [YoungDiagram.rowLen_transpose] at he
    have hmem : (h - 1, j) ∈ d := by rw [YoungDiagram.mem_iff_lt_colLen, he]; omega
    have hnmem : ¬ (h, j) ∈ d := by rw [YoungDiagram.mem_iff_lt_colLen, he]; omega
    rw [YoungDiagram.mem_iff_lt_rowLen] at hmem hnmem
    omega
  · intro hdrop
    have hmem : (h - 1, d.rowLen h) ∈ d :=
      YoungDiagram.mem_iff_lt_rowLen.mpr hdrop
    have hnmem : ¬ (h, d.rowLen h) ∈ d := by
      rw [YoungDiagram.mem_iff_lt_rowLen]; omega
    rw [YoungDiagram.mem_iff_lt_colLen] at hmem hnmem
    have he : d.colLen (d.rowLen h) = h := by omega
    have hj : d.rowLen h < d.rowLen 0 :=
      lt_of_lt_of_le hdrop (d.rowLen_anti 0 (h - 1) (Nat.zero_le _))
    apply List.mem_map.mpr
    refine ⟨d.rowLen h, ?_, ?_⟩
    · simpa [YoungDiagram.colLen_transpose] using hj
    · simpa [YoungDiagram.rowLen_transpose] using he

private theorem height_bounds (d : YoungDiagram) (h : ℕ)
    (hm : h ∈ d.transpose.rowLens) : 0 < h ∧ h ≤ d.colLen 0 := by
  refine ⟨d.transpose.pos_of_mem_rowLens h hm, ?_⟩
  obtain ⟨j, _, he⟩ := List.mem_map.mp hm
  change d.transpose.rowLen j = h at he
  rw [YoungDiagram.rowLen_transpose] at he
  rw [← he]
  exact d.colLen_anti 0 j (Nat.zero_le _)

private theorem max_height_mem (d : YoungDiagram) (hp : 0 < d.colLen 0) :
    d.colLen 0 ∈ d.transpose.rowLens := by
  have hmem : (0, 0) ∈ d := YoungDiagram.mem_iff_lt_colLen.mpr hp
  rw [YoungDiagram.mem_iff_lt_rowLen] at hmem
  apply List.mem_map.mpr
  refine ⟨0, ?_, YoungDiagram.rowLen_transpose d 0⟩
  simpa [YoungDiagram.colLen_transpose] using hmem

private theorem strict_rows_iff_heights (d : YoungDiagram) :
    d.rowLens.Pairwise (· > ·) ↔
      ∀ h : ℕ, h ∈ d.transpose.rowLens ↔ 0 < h ∧ h ≤ d.colLen 0 := by
  constructor
  · intro hs h
    refine ⟨height_bounds d h, ?_⟩
    rintro ⟨hp, hb⟩
    apply (height_mem_iff d h hp).mpr
    have hi : h - 1 < d.rowLens.length := by rw [YoungDiagram.length_rowLens]; omega
    by_cases hh : h < d.rowLens.length
    · have hd := List.pairwise_iff_getElem.mp hs (h - 1) h hi hh (by omega)
      simpa only [YoungDiagram.get_rowLens] using hd
    · rw [rowLen_zero d h (by rw [YoungDiagram.length_rowLens] at hh; omega)]
      have hm := List.getElem_mem hi
      have hp' := d.pos_of_mem_rowLens _ hm
      simpa only [YoungDiagram.get_rowLens] using hp'
  · intro hs
    apply List.pairwise_iff_getElem.mpr
    intro i j hi hj hij
    have hm := (hs (i + 1)).mpr ⟨by omega, by
      rw [YoungDiagram.length_rowLens] at hi hj
      omega⟩
    have hd := (height_mem_iff d (i + 1) (by omega)).mp hm
    have ha := d.rowLen_anti (i + 1) j (by omega)
    simp only [YoungDiagram.get_rowLens]
    simpa using lt_of_le_of_lt ha hd
