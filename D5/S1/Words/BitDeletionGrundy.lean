/- GID: D5/S1/Words/BitDeletionGrundy
   generality: G
   mirror-B: D5/B/S1/Words/BitDeletionGrundy
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: kind=bounded-enumeration; basis=terminal=atom:22d4532992abbad0a21605c1622b0d4086266e7e0f1fd6bd35cf36aab73e3f30; result=D5/S1/Words/BitDeletionGrundy.wordGrundy_eq_formula
   digest: A finite automaton proves both OEIS A398916 bit-deletion conjectures. -/

import Mathlib.Data.Nat.Digits.Lemmas
import Mathlib.Tactic.FinCases

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S1.Words.BitDeletionGrundy

private abbrev Word := List Bool

/-- Remove all leading zeroes from an MSB-first binary word. -/
def normalize : Word -> Word
  | [] => []
  | false :: w => normalize w
  | true :: w => true :: w

/-- All positional one-symbol deletions, retaining duplicates at list level. -/
def erasures : Word -> List Word
  | [] => []
  | b :: w => w :: (erasures w).map (b :: ·)

private theorem normalize_length_le (w : Word) : (normalize w).length <= w.length := by
  induction w with
  | nil => simp [normalize]
  | cons b w ih =>
      cases b
      · exact ih.trans (Nat.le_succ _)
      · simp [normalize]

private theorem length_lt_of_mem_erasures {v w : Word} (hv : v ∈ erasures w) :
    v.length < w.length := by
  induction w generalizing v with
  | nil => simp [erasures] at hv
  | cons b w ih =>
      simp only [erasures, List.mem_cons, List.mem_map] at hv
      rcases hv with rfl | ⟨u, hu, rfl⟩
      · simp
      · simpa using Nat.succ_lt_succ (ih hu)

/-- A bounded search for the first natural outside a finite set. -/
def mexScan (used : Finset Nat) : Nat -> Nat -> Nat
  | 0, candidate => candidate
  | fuel + 1, candidate =>
      if candidate ∈ used then mexScan used fuel (candidate + 1) else candidate

/-- The minimum excluded natural number. -/
def mex (used : Finset Nat) : Nat :=
  mexScan used (used.card + 1) 0

private theorem mexScan_spec (used : Finset Nat) (fuel candidate : Nat)
    (hex : ∃ k, candidate ≤ k ∧ k < candidate + fuel ∧ k ∉ used) :
    mexScan used fuel candidate ∉ used ∧
      candidate ≤ mexScan used fuel candidate ∧
      ∀ k, candidate ≤ k → k < mexScan used fuel candidate → k ∈ used := by
  induction fuel generalizing candidate with
  | zero => omega
  | succ fuel ih =>
      simp only [mexScan]
      split_ifs with hc
      · have hex' : ∃ k, candidate + 1 ≤ k ∧ k < candidate + 1 + fuel ∧ k ∉ used := by
          rcases hex with ⟨k, hk0, hk1, hk2⟩
          refine ⟨k, ?_, by omega, hk2⟩
          by_contra hlt
          have : k = candidate := by omega
          exact hk2 (this ▸ hc)
        rcases ih (candidate + 1) hex' with ⟨hnot, hlo, hmin⟩
        refine ⟨hnot, by omega, ?_⟩
        intro k hk0 hk1
        by_cases hk : k = candidate
        · simpa [hk] using hc
        · exact hmin k (by omega) hk1
      · exact ⟨hc, le_rfl, by omega⟩

private theorem exists_not_mem_below_card_succ (used : Finset Nat) :
    ∃ k, k < used.card + 1 ∧ k ∉ used := by
  by_contra h
  have hsub : Finset.range (used.card + 1) ⊆ used := by
    intro k hk
    by_contra hknot
    exact h ⟨k, Finset.mem_range.mp hk, hknot⟩
  have hcard := Finset.card_le_card hsub
  simp only [Finset.card_range] at hcard
  omega

/-- The scanner returns an excluded value and every smaller value is present. -/
theorem mex_spec (used : Finset Nat) :
    mex used ∉ used ∧ ∀ k < mex used, k ∈ used := by
  rcases exists_not_mem_below_card_succ used with ⟨k, hk0, hk1⟩
  have hscan := mexScan_spec used (used.card + 1) 0
    ⟨k, Nat.zero_le k, by omega, hk1⟩
  exact ⟨hscan.1, fun j hj => hscan.2.2 j (Nat.zero_le j) hj⟩

private theorem mex_not_mem (used : Finset Nat) : mex used ∉ used := (mex_spec used).1

private theorem mem_of_lt_mex (used : Finset Nat) {k : Nat} (hk : k < mex used) : k ∈ used :=
  (mex_spec used).2 k hk

private def deletionWords (w : Word) : Finset Word := (erasures w).toFinset

/-- The normalized bit-deletion game's Grundy value on MSB-first words. -/
def wordGrundy (w : Word) : Nat :=
  match w with
  | [] => 0
  | false :: t => wordGrundy t
  | true :: t =>
      mex ((deletionWords (true :: t)).attach.image
        (fun v => wordGrundy (normalize v.1)))
termination_by w.length
decreasing_by
  · simp_wf
  · exact lt_of_le_of_lt (normalize_length_le v.1)
      (length_lt_of_mem_erasures (by simpa [deletionWords] using v.property))

@[simp] private theorem wordGrundy_nil : wordGrundy [] = 0 := by rw [wordGrundy]

@[simp] private theorem wordGrundy_zero_cons (w : Word) :
    wordGrundy (false :: w) = wordGrundy w := by rw [wordGrundy]

private theorem wordGrundy_one_cons (w : Word) :
    wordGrundy (true :: w) =
      mex ((deletionWords (true :: w)).attach.image
        (fun v => wordGrundy (normalize v.1))) := by rw [wordGrundy]

/-- Parity of word length: `false` is even and `true` is odd. -/
def parity : Word -> Bool
  | [] => false
  | _ :: w => !(parity w)

/-- The transition used when the suffix has even length. -/
def transition0 (h : Fin 4) : Fin 4 := if h = 1 then 3 else 1

/-- The transition used when the suffix has odd length. -/
def transition1 (h : Fin 4) : Fin 4 := if h = 0 then 2 else 0

def transition : Bool -> Fin 4 -> Fin 4
  | false => transition0
  | true => transition1

/-- Closed-form candidate read from the word from right to left. -/
def formula : Word -> Fin 4
  | [] => 0
  | false :: w => formula w
  | true :: w => transition (parity w) (formula w)

@[simp] private theorem parity_cons (b : Bool) (w : Word) : parity (b :: w) = !(parity w) := rfl
@[simp] private theorem formula_zero_cons (w : Word) : formula (false :: w) = formula w := rfl
@[simp] private theorem formula_one_cons (w : Word) :
    formula (true :: w) = transition (parity w) (formula w) := rfl

@[simp] private theorem parity_append_zero_zero (w : Word) :
    parity (w ++ [false, false]) = parity w := by
  induction w with
  | nil => rfl
  | cons b w ih => simp [parity, ih]

@[simp] theorem formula_append_zero_zero (w : Word) :
    formula (w ++ [false, false]) = formula w := by
  induction w with
  | nil => rfl
  | cons b w ih => cases b <;> simp [formula, ih]

private def deletionValues (w : Word) : Finset (Fin 4) :=
  (deletionWords w).image formula

@[ext] private structure AutomatonState where
  phase : Bool
  value : Fin 4
  moves : Finset (Fin 4)

private instance automatonStateDecidableEq : DecidableEq AutomatonState :=
  (show Function.Injective
      (fun s : AutomatonState => (s.phase, s.value, s.moves)) from by
    intro a b h
    cases a
    cases b
    simp_all).decidableEq

private def state (w : Word) : AutomatonState :=
  ⟨parity w, formula w, deletionValues w⟩

private def initial : AutomatonState := ⟨false, 0, ∅⟩

private def step0 (s : AutomatonState) : AutomatonState :=
  ⟨!s.phase, s.value, insert s.value s.moves⟩

private def step1 (s : AutomatonState) : AutomatonState :=
  ⟨!s.phase, transition s.phase s.value,
    insert s.value (s.moves.image (transition (!s.phase)))⟩

@[ext] private structure MoveCode where
  has0 : Bool
  has1 : Bool
  has2 : Bool
  has3 : Bool

private instance moveCodeDecidableEq : DecidableEq MoveCode :=
  (show Function.Injective
      (fun c : MoveCode => (c.has0, c.has1, c.has2, c.has3)) from by
    intro a b h
    cases a
    cases b
    simp_all).decidableEq

private def moveCode (moves : Finset (Fin 4)) : MoveCode :=
  ⟨decide (0 ∈ moves), decide (1 ∈ moves), decide (2 ∈ moves), decide (3 ∈ moves)⟩

private theorem moveCode_injective : Function.Injective moveCode := by
  intro a b h
  ext x
  fin_cases x
  · have hx := congrArg MoveCode.has0 h
    simpa [moveCode] using congrArg (fun q => q = true) hx
  · have hx := congrArg MoveCode.has1 h
    simpa [moveCode] using congrArg (fun q => q = true) hx
  · have hx := congrArg MoveCode.has2 h
    simpa [moveCode] using congrArg (fun q => q = true) hx
  · have hx := congrArg MoveCode.has3 h
    simpa [moveCode] using congrArg (fun q => q = true) hx

@[ext] private structure StateCode where
  phase : Bool
  value : Fin 4
  moves : MoveCode

private instance stateCodeDecidableEq : DecidableEq StateCode :=
  (show Function.Injective
      (fun s : StateCode => (s.phase, s.value, s.moves)) from by
    intro a b h
    cases a
    cases b
    simp_all).decidableEq

private def stateCode (s : AutomatonState) : StateCode :=
  ⟨s.phase, s.value, moveCode s.moves⟩

private theorem stateCode_injective : Function.Injective stateCode := by
  intro a b h
  apply AutomatonState.ext
  · exact congrArg StateCode.phase h
  · exact congrArg StateCode.value h
  · exact moveCode_injective (congrArg StateCode.moves h)

private def reachableList : List AutomatonState := [
  ⟨false, 0, ∅⟩,
  ⟨false, 0, {0}⟩,
  ⟨false, 0, {0, 1}⟩,
  ⟨false, 0, {0, 1, 2, 3}⟩,
  ⟨false, 0, {0, 1, 3}⟩,
  ⟨false, 0, {1}⟩,
  ⟨false, 0, {1, 2, 3}⟩,
  ⟨false, 0, {1, 3}⟩,
  ⟨false, 1, {0, 1}⟩,
  ⟨false, 1, {0, 1, 2}⟩,
  ⟨false, 1, {0, 1, 2, 3}⟩,
  ⟨false, 2, {0, 1}⟩,
  ⟨false, 2, {0, 1, 2}⟩,
  ⟨false, 2, {0, 1, 2, 3}⟩,
  ⟨false, 2, {0, 1, 3}⟩,
  ⟨false, 3, {0, 1, 2, 3}⟩,
  ⟨true, 0, {0}⟩,
  ⟨true, 0, {0, 1}⟩,
  ⟨true, 0, {0, 1, 2, 3}⟩,
  ⟨true, 0, {0, 1, 3}⟩,
  ⟨true, 1, {0}⟩,
  ⟨true, 1, {0, 1}⟩,
  ⟨true, 1, {0, 1, 2}⟩,
  ⟨true, 1, {0, 1, 2, 3}⟩,
  ⟨true, 1, {0, 2}⟩,
  ⟨true, 1, {0, 2, 3}⟩,
  ⟨true, 2, {0, 1, 2}⟩,
  ⟨true, 2, {0, 1, 2, 3}⟩,
  ⟨true, 3, {0, 1, 2}⟩,
  ⟨true, 3, {0, 1, 2, 3}⟩
]

private def reachable : Finset AutomatonState := reachableList.toFinset

private def reachableCodes : Finset StateCode := reachable.image stateCode

private theorem reachable_card : reachable.card = 30 := by decide

/-- One word realizing each state in `reachableList`, in the same order. -/
private def witnessWords : List Word := [
  [],
  [false, false],
  [false, false, true, true],
  [false, false, true, false, true, false],
  [false, false, true, false, false, true],
  [true, true],
  [true, false, true, false],
  [true, false, false, true],
  [false, true],
  [false, true, false, false],
  [false, true, false, true, false, true],
  [true, false],
  [false, false, true, false],
  [false, false, true, false, true, true],
  [true, false, true, true],
  [false, true, false, true],
  [false],
  [false, true, true],
  [false, true, false, true, false],
  [false, true, false, false, true],
  [true],
  [false, false, true],
  [false, false, true, false, false],
  [false, false, true, false, true, false, true],
  [true, false, false],
  [true, false, true, false, true],
  [false, true, false],
  [false, true, false, true, true],
  [true, false, true],
  [false, false, true, false, true]
]

private def witnessCodes : Finset StateCode :=
  (witnessWords.map (fun w => stateCode (state w))).toFinset

private theorem witness_codes_eq_reachableCodes : witnessCodes = reachableCodes := by
  set_option maxRecDepth 100000 in decide

private theorem reachable_state_realized (s : AutomatonState) (hs : s ∈ reachable) :
    ∃ w ∈ witnessWords, state w = s := by
  have hcode : stateCode s ∈ reachableCodes :=
    Finset.mem_image.mpr ⟨s, hs, rfl⟩
  rw [← witness_codes_eq_reachableCodes] at hcode
  have hlist : stateCode s ∈ witnessWords.map (fun w => stateCode (state w)) := by
    simpa [witnessCodes] using hcode
  rcases List.mem_map.mp hlist with ⟨w, hw, hws⟩
  exact ⟨w, hw, stateCode_injective hws⟩

private def reachableChunk0 := reachableList.take 5
private def reachableChunk1 := (reachableList.drop 5).take 5
private def reachableChunk2 := (reachableList.drop 10).take 5
private def reachableChunk3 := (reachableList.drop 15).take 5
private def reachableChunk4 := (reachableList.drop 20).take 5
private def reachableChunk5 := (reachableList.drop 25).take 5

private theorem reachableList_eq_chunks :
    reachableList = reachableChunk0 ++ reachableChunk1 ++ reachableChunk2 ++
      reachableChunk3 ++ reachableChunk4 ++ reachableChunk5 := by
  rfl

private theorem reachable_step0_chunk0 :
    reachableChunk0.all (fun s => decide (stateCode (step0 s) ∈ reachableCodes)) = true := by
  unfold reachableChunk0 reachableCodes reachable reachableList stateCode moveCode step0
  decide

private theorem reachable_step0_chunk1 :
    reachableChunk1.all (fun s => decide (stateCode (step0 s) ∈ reachableCodes)) = true := by
  unfold reachableChunk1 reachableCodes reachable reachableList stateCode moveCode step0
  decide

private theorem reachable_step0_chunk2 :
    reachableChunk2.all (fun s => decide (stateCode (step0 s) ∈ reachableCodes)) = true := by
  unfold reachableChunk2 reachableCodes reachable reachableList stateCode moveCode step0
  decide

private theorem reachable_step0_chunk3 :
    reachableChunk3.all (fun s => decide (stateCode (step0 s) ∈ reachableCodes)) = true := by
  unfold reachableChunk3 reachableCodes reachable reachableList stateCode moveCode step0
  decide

private theorem reachable_step0_chunk4 :
    reachableChunk4.all (fun s => decide (stateCode (step0 s) ∈ reachableCodes)) = true := by
  unfold reachableChunk4 reachableCodes reachable reachableList stateCode moveCode step0
  decide

private theorem reachable_step0_chunk5 :
    reachableChunk5.all (fun s => decide (stateCode (step0 s) ∈ reachableCodes)) = true := by
  unfold reachableChunk5 reachableCodes reachable reachableList stateCode moveCode step0
  decide

private abbrev reachableStep0Check : Bool :=
  reachableList.all (fun s => decide (stateCode (step0 s) ∈ reachableCodes))

private theorem reachable_step0_certificate : reachableStep0Check = true := by
  apply List.all_eq_true.mpr
  intro s hs
  rw [reachableList_eq_chunks] at hs
  rcases List.mem_append.mp hs with hs | hs
  · rcases List.mem_append.mp hs with hs | hs
    · rcases List.mem_append.mp hs with hs | hs
      · rcases List.mem_append.mp hs with hs | hs
        · rcases List.mem_append.mp hs with hs | hs
          · exact (List.all_eq_true.mp reachable_step0_chunk0) s hs
          · exact (List.all_eq_true.mp reachable_step0_chunk1) s hs
        · exact (List.all_eq_true.mp reachable_step0_chunk2) s hs
      · exact (List.all_eq_true.mp reachable_step0_chunk3) s hs
    · exact (List.all_eq_true.mp reachable_step0_chunk4) s hs
  · exact (List.all_eq_true.mp reachable_step0_chunk5) s hs

private theorem reachable_step0 (s : AutomatonState) (hs : s ∈ reachable) :
    step0 s ∈ reachable := by
  have hsList : s ∈ reachableList := by simpa [reachable] using hs
  have hc := (List.all_eq_true.mp reachable_step0_certificate) s hsList
  rcases Finset.mem_image.mp (of_decide_eq_true hc) with ⟨t, ht, hcode⟩
  have heq : t = step0 s := stateCode_injective hcode
  simpa [heq] using ht

private abbrev reachableStep1Check : Bool :=
  reachableList.all (fun s => decide (stateCode (step1 s) ∈ reachableCodes))

private theorem reachable_step1_chunk0 :
    reachableChunk0.all (fun s => decide (stateCode (step1 s) ∈ reachableCodes)) = true := by
  unfold reachableChunk0 reachableCodes reachable reachableList stateCode moveCode step1 transition
  decide

private theorem reachable_step1_chunk1 :
    reachableChunk1.all (fun s => decide (stateCode (step1 s) ∈ reachableCodes)) = true := by
  unfold reachableChunk1 reachableCodes reachable reachableList stateCode moveCode step1 transition
  decide

private theorem reachable_step1_chunk2 :
    reachableChunk2.all (fun s => decide (stateCode (step1 s) ∈ reachableCodes)) = true := by
  unfold reachableChunk2 reachableCodes reachable reachableList stateCode moveCode step1 transition
  decide

private theorem reachable_step1_chunk3 :
    reachableChunk3.all (fun s => decide (stateCode (step1 s) ∈ reachableCodes)) = true := by
  unfold reachableChunk3 reachableCodes reachable reachableList stateCode moveCode step1 transition
  decide

private theorem reachable_step1_chunk4 :
    reachableChunk4.all (fun s => decide (stateCode (step1 s) ∈ reachableCodes)) = true := by
  unfold reachableChunk4 reachableCodes reachable reachableList stateCode moveCode step1 transition
  decide

private theorem reachable_step1_chunk5 :
    reachableChunk5.all (fun s => decide (stateCode (step1 s) ∈ reachableCodes)) = true := by
  unfold reachableChunk5 reachableCodes reachable reachableList stateCode moveCode step1 transition
  decide

private theorem reachable_step1_certificate : reachableStep1Check = true := by
  apply List.all_eq_true.mpr
  intro s hs
  rw [reachableList_eq_chunks] at hs
  rcases List.mem_append.mp hs with hs | hs
  · rcases List.mem_append.mp hs with hs | hs
    · rcases List.mem_append.mp hs with hs | hs
      · rcases List.mem_append.mp hs with hs | hs
        · rcases List.mem_append.mp hs with hs | hs
          · exact (List.all_eq_true.mp reachable_step1_chunk0) s hs
          · exact (List.all_eq_true.mp reachable_step1_chunk1) s hs
        · exact (List.all_eq_true.mp reachable_step1_chunk2) s hs
      · exact (List.all_eq_true.mp reachable_step1_chunk3) s hs
    · exact (List.all_eq_true.mp reachable_step1_chunk4) s hs
  · exact (List.all_eq_true.mp reachable_step1_chunk5) s hs

private theorem reachable_step1 (s : AutomatonState) (hs : s ∈ reachable) :
    step1 s ∈ reachable := by
  have hsList : s ∈ reachableList := by simpa [reachable] using hs
  have hc := (List.all_eq_true.mp reachable_step1_certificate) s hsList
  rcases Finset.mem_image.mp (of_decide_eq_true hc) with ⟨t, ht, hcode⟩
  have heq : t = step1 s := stateCode_injective hcode
  simpa [heq] using ht

private def natMoves (s : AutomatonState) : Finset Nat := s.moves.image Fin.val

private theorem reachable_step1_mex_certificate :
    reachable.filter (fun s => mex (natMoves (step1 s)) = (step1 s).value.val) =
      reachable := by
  set_option maxRecDepth 100000 in decide

private theorem reachable_step1_mex (s : AutomatonState) (hs : s ∈ reachable) :
    mex (natMoves (step1 s)) = (step1 s).value.val := by
  have hm : s ∈ reachable.filter
      (fun s => mex (natMoves (step1 s)) = (step1 s).value.val) := by
    rw [reachable_step1_mex_certificate]
    exact hs
  exact (Finset.mem_filter.mp hm).2

private theorem parity_erase {w v : Word} (hv : v ∈ erasures w) :
    parity v = !(parity w) := by
  induction w generalizing v with
  | nil => simp [erasures] at hv
  | cons b w ih =>
      simp only [erasures, List.mem_cons, List.mem_map] at hv
      rcases hv with rfl | ⟨u, hu, rfl⟩
      · simp [parity]
      · simp [parity, ih hu]

private theorem deletionWords_cons (b : Bool) (w : Word) :
    deletionWords (b :: w) = insert w ((deletionWords w).image (b :: ·)) := by
  ext v
  simp [deletionWords, erasures]

private theorem deletionValues_zero_cons (w : Word) :
    deletionValues (false :: w) = insert (formula w) (deletionValues w) := by
  rw [deletionValues, deletionWords_cons, Finset.image_insert, Finset.image_image]
  simp [deletionValues, Function.comp_def, formula]

private theorem deletionValues_one_cons (w : Word) :
    deletionValues (true :: w) =
      insert (formula w) ((deletionValues w).image (transition (!(parity w)))) := by
  rw [deletionValues, deletionWords_cons, Finset.image_insert, Finset.image_image,
    deletionValues, Finset.image_image]
  congr 1
  apply Finset.image_congr
  intro v hv
  simp [formula, parity_erase (by
    simpa [deletionWords] using hv)]

private theorem state_nil : state [] = initial := rfl

private theorem state_zero_cons (w : Word) : state (false :: w) = step0 (state w) := by
  ext <;> simp [state, step0, parity, formula, deletionValues_zero_cons]

private theorem state_one_cons (w : Word) : state (true :: w) = step1 (state w) := by
  ext <;> simp [state, step1, parity, formula, deletionValues_one_cons]

private theorem state_mem_reachable (w : Word) : state w ∈ reachable := by
  induction w with
  | nil => decide
  | cons b w ih =>
      cases b
      · rw [state_zero_cons]
        exact reachable_step0 _ ih
      · rw [state_one_cons]
        exact reachable_step1 _ ih

private theorem formula_normalize (w : Word) : formula (normalize w) = formula w := by
  induction w with
  | nil => rfl
  | cons b w ih => cases b <;> simp [normalize, formula, ih]

theorem wordGrundy_eq_formula (w : Word) : wordGrundy w = (formula w).val := by
  induction hlen : w.length using Nat.strong_induction_on generalizing w with
  | h n ih =>
      subst hlen
      cases w with
      | nil => simp [formula]
      | cons b t =>
          cases b
          · simp only [wordGrundy, formula]
            exact ih t.length (by simp) t rfl
          · simp only [wordGrundy, formula]
            have hvals :
                (deletionWords (true :: t)).attach.image
                  (fun v => wordGrundy (normalize v.1)) =
                (deletionValues (true :: t)).image Fin.val := by
              ext x
              constructor
              · intro hx
                rcases Finset.mem_image.mp hx with ⟨v, _, rfl⟩
                refine Finset.mem_image.mpr ⟨formula v.1, ?_, ?_⟩
                · exact Finset.mem_image.mpr ⟨v.1, v.property, rfl⟩
                · rw [ih (normalize v.1).length]
                  · simp [formula_normalize]
                  · exact lt_of_le_of_lt (normalize_length_le _)
                      (length_lt_of_mem_erasures (by
                        simpa [deletionWords] using v.property))
                  · rfl
              · intro hx
                rcases Finset.mem_image.mp hx with ⟨y, hy, rfl⟩
                rcases Finset.mem_image.mp hy with ⟨v, hv, rfl⟩
                refine Finset.mem_image.mpr ⟨⟨v, hv⟩, Finset.mem_attach _ _, ?_⟩
                rw [ih (normalize v).length]
                · simp [formula_normalize]
                · exact lt_of_le_of_lt (normalize_length_le _)
                    (length_lt_of_mem_erasures (by
                      simpa [deletionWords] using hv))
                · rfl
            rw [hvals]
            have hcert := reachable_step1_mex (state t) (state_mem_reachable t)
            rw [← state_one_cons] at hcert
            simpa [natMoves, state] using hcert

/-- Mathlib digits are little-endian; reverse them for the entry's binary word. -/
private def binaryWord (n : Nat) : Word :=
  (Nat.digits 2 n).reverse.map (fun d => d = 1)

/-- OEIS A398916, defined by normalized one-bit deletion and mex. -/
def g (n : Nat) : Nat :=
  wordGrundy ((Nat.digits 2 n).reverse.map (fun d => d = 1))

/-- The natural-number game is the word game on the canonical MSB-first binary expansion. -/
theorem g_eq_wordGrundy (n : Nat) :
    g n = wordGrundy ((Nat.digits 2 n).reverse.map (fun d => d = 1)) := rfl

theorem g_le_three (n : Nat) : g n <= 3 := by
  rw [g, wordGrundy_eq_formula]
  exact Nat.le_of_lt_succ (formula (binaryWord n)).isLt

private theorem binaryWord_four_mul (n : Nat) (hn : n ≠ 0) :
    binaryWord (4 * n) = binaryWord n ++ [false, false] := by
  rw [show 4 * n = 2 ^ 2 * n by norm_num]
  unfold binaryWord
  rw [Nat.digits_base_pow_mul (b := 2) (k := 2) (m := n) (by decide)
    (Nat.pos_of_ne_zero hn)]
  simp

theorem g_four_mul (n : Nat) : g (4 * n) = g n := by
  by_cases hn : n = 0
  · simp [hn]
  · change wordGrundy (binaryWord (4 * n)) = wordGrundy (binaryWord n)
    rw [binaryWord_four_mul n hn, wordGrundy_eq_formula, wordGrundy_eq_formula,
      formula_append_zero_zero]

/-- Both conjectures recorded for OEIS A398916. -/
theorem conjectures :
    (∀ n : Nat, g n ≤ 3) ∧
      (∀ n : Nat, g (4 * n) = g n) := by
  exact ⟨g_le_three, g_four_mul⟩


end D5.S1.Words.BitDeletionGrundy
