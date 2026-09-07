/- GID: D5/S1/Digit/GreedyFloorSqrtRunBlocks
   generality: I
   mirror-B: D5/B/S1/Digit/GreedyFloorSqrtRunBlocks
   mirror-E: none(waiver:theorem-has-no-separate-numeric-evidence)
   anchors: []
   utility: none
   digest: The greedy floor-square-root sequence has exactly the conjectured decreasing runs. -/
import Mathlib.Data.Finset.Image
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.Linarith
set_option autoImplicit false
set_option relaxedAutoImplicit false
/-! The private `state` is the unbounded definition mechanism for `seq`, not a bounded
enumerator or certificate, so this module has no SL-031 computational utility record. -/
namespace D5.S1.Digit.GreedyFloorSqrtRunBlocks
private structure PrefixState where
  value : ℕ
  seen : Finset ℕ
private def initial : PrefixState := ⟨0, {0}⟩
private def initialOne : PrefixState := ⟨1, {0, 1}⟩
private def step (st : PrefixState) : PrefixState :=
  let candidate := st.value - 1
  let next := if candidate ∈ st.seen then st.value + Nat.sqrt st.value else candidate
  ⟨next, insert next st.seen⟩
private def state : ℕ → PrefixState
  | 0 => initial
  | 1 => initialOne
  | n + 2 => step (state (n + 1))
/-- A399084, defined by its literal history-dependent recurrence. -/
def seq (n : ℕ) : ℕ := (state n).value
/-- The sequence starts at zero. -/
@[simp] theorem seq_zero : seq 0 = 0 := rfl
/-- The second sequence value is one. -/
@[simp] theorem seq_one : seq 1 = 1 := rfl
private theorem state_seen (n : ℕ) :
    (state n).seen = Finset.image seq (Finset.range (n + 1)) := by
  induction n using Nat.twoStepInduction with
  | zero => simp [state, initial, seq]
  | one =>
      ext x
      simp only [state, initialOne, seq, Finset.mem_insert, Finset.mem_singleton,
        Finset.mem_image, Finset.mem_range]
      constructor
      · rintro (rfl | rfl)
        · exact ⟨0, by omega, rfl⟩
        · exact ⟨1, by omega, rfl⟩
      · rintro ⟨a, ha, hax⟩
        have : a = 0 ∨ a = 1 := by omega
        rcases this with rfl | rfl
        · exact Or.inl hax.symm
        · exact Or.inr hax.symm
  | more n _ ih =>
      rw [state]
      rw [Finset.range_add_one, Finset.image_insert]
      simp only [seq]
      rw [state]
      simp only [step]
      rw [ih]
/-- After the initial values, `seq` obeys the unused-predecessor-or-square-root-jump rule. -/
theorem seq_succ_succ (n : ℕ) :
    seq (n + 2) =
      if seq (n + 1) - 1 ∈ Finset.image seq (Finset.range ((n + 1) + 1)) then
        seq (n + 1) + Nat.sqrt (seq (n + 1))
      else
        seq (n + 1) - 1 := by
  simp only [seq, state, step, state_seen]
  rfl
/-- The first index in the four-block group with parameter `m`. -/
def groupStart (m : ℕ) : ℕ := m * m + m - 1
private def groupOf (n : ℕ) : ℕ := (Nat.sqrt (4 * n + 5) - 1) / 2
/-- The explicit four-block candidate for A399084. -/
def closedForm (n : ℕ) : ℕ :=
  if n < 5 then n
  else
    let m := groupOf n
    let s := groupStart m
    let r := n - s
    if r < m then s + m - 1 - r
    else if r = m then s + m
    else if r ≤ 2 * m then s + 3 * m + 1 - r
    else s + 2 * m + 1
private theorem groupStart_succ (m : ℕ) (hm : 1 ≤ m) :
    groupStart (m + 1) = groupStart m + 2 * m + 2 := by
  unfold groupStart
  have hs₁ : (m * m + m - 1) + 1 = m * m + m := by omega
  have hs₂ : ((m + 1) * (m + 1) + (m + 1) - 1) + 1 =
      (m + 1) * (m + 1) + (m + 1) := by omega
  nlinarith
private theorem sqrt_group_index (m r : ℕ) (hm : 2 ≤ m) (hr : r ≤ 2 * m + 1) :
    groupOf (groupStart m + r) = m := by
  unfold groupOf groupStart
  have hs : (m * m + m - 1) + 1 = m * m + m := by omega
  have hlo : (2 * m + 1) * (2 * m + 1) ≤ 4 * (m * m + m - 1 + r) + 5 := by
    nlinarith
  have hhi : 4 * (m * m + m - 1 + r) + 5 < (2 * m + 3) * (2 * m + 3) := by
    nlinarith
  have hlo' : 2 * m + 1 ≤ Nat.sqrt (4 * (m * m + m - 1 + r) + 5) :=
    Nat.le_sqrt.mpr hlo
  have hhi' : Nat.sqrt (4 * (m * m + m - 1 + r) + 5) < 2 * m + 3 :=
    Nat.sqrt_lt.mpr hhi
  omega
private theorem groupOf_bounds (n : ℕ) (hn : 5 ≤ n) :
    let m := groupOf n
    2 ≤ m ∧ groupStart m ≤ n ∧ n < groupStart (m + 1) := by
  let q := Nat.sqrt (4 * n + 5)
  let m := (q - 1) / 2
  have hq5 : 5 ≤ q := by
    apply Nat.le_sqrt.mpr
    dsimp [q]
    omega
  have hm2 : 2 ≤ m := by
    dsimp [m]
    omega
  have hq_cases : q = 2 * m + 1 ∨ q = 2 * m + 2 := by
    dsimp [m]
    omega
  have hq_sq : q * q ≤ 4 * n + 5 := by
    exact Nat.sqrt_le (4 * n + 5)
  have hn_q : 4 * n + 5 < (q + 1) * (q + 1) := by
    exact Nat.lt_succ_sqrt (4 * n + 5)
  have hs : (m * m + m - 1) + 1 = m * m + m := by omega
  have hs' : ((m + 1) * (m + 1) + (m + 1) - 1) + 1 =
      (m + 1) * (m + 1) + (m + 1) := by omega
  change 2 ≤ m ∧ groupStart m ≤ n ∧ n < groupStart (m + 1)
  refine ⟨hm2, ?_, ?_⟩
  · unfold groupStart
    rcases hq_cases with hq | hq <;> nlinarith
  · unfold groupStart
    rcases hq_cases with hq | hq <;> nlinarith
private theorem closedForm_four_blocks (m : ℕ) (hm : 2 ≤ m) :
    let s := groupStart m
    (∀ i < m, closedForm (s + i) = s + m - 1 - i) ∧
      closedForm (s + m) = s + m ∧
      (∀ i < m, closedForm (s + m + 1 + i) = s + 2 * m - i) ∧
      closedForm (s + 2 * m + 1) = s + 2 * m + 1 := by
  let s := groupStart m
  dsimp only [s]
  have hs_eq : groupStart m + 1 = m * m + m := by
    dsimp [groupStart]
    omega
  have hs5 : 5 ≤ groupStart m := by
    have hsq : 4 ≤ m * m := by nlinarith
    nlinarith
  have hgroup (r : ℕ) (hr : r ≤ 2 * m + 1) :
      groupOf (groupStart m + r) = m := sqrt_group_index m r hm hr
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro i hi
    have hi' : i ≤ 2 * m + 1 := by omega
    have hn5 : ¬groupStart m + i < 5 := by omega
    simp only [closedForm, if_neg hn5, hgroup i hi']
    have hsub : groupStart m + i - groupStart m = i := by omega
    rw [hsub]
    simp [hi]
  · have hm' : m ≤ 2 * m + 1 := by omega
    have hn5 : ¬groupStart m + m < 5 := by omega
    simp only [closedForm, if_neg hn5, hgroup m hm']
    have hsub : groupStart m + m - groupStart m = m := by omega
    rw [hsub]
    simp
  · intro i hi
    have hr : m + 1 + i ≤ 2 * m + 1 := by omega
    have hn5 : ¬groupStart m + m + 1 + i < 5 := by omega
    have harg : groupStart m + m + 1 + i = groupStart m + (m + 1 + i) := by omega
    have hn5' : ¬groupStart m + (m + 1 + i) < 5 := by omega
    rw [harg]
    simp only [closedForm, if_neg hn5', hgroup (m + 1 + i) hr]
    have hsub : groupStart m + (m + 1 + i) - groupStart m = m + 1 + i := by omega
    rw [hsub]
    simp only [if_neg (by omega : ¬m + 1 + i < m), if_neg (by omega : m + 1 + i ≠ m),
      if_pos (by omega : m + 1 + i ≤ 2 * m)]
    omega
  · have hr : 2 * m + 1 ≤ 2 * m + 1 := le_rfl
    have hn5 : ¬groupStart m + 2 * m + 1 < 5 := by omega
    have harg : groupStart m + 2 * m + 1 = groupStart m + (2 * m + 1) := by omega
    have hn5' : ¬groupStart m + (2 * m + 1) < 5 := by omega
    rw [harg]
    simp only [closedForm, if_neg hn5', hgroup (2 * m + 1) hr]
    have hsub : groupStart m + (2 * m + 1) - groupStart m = 2 * m + 1 := by omega
    rw [hsub]
    simp only [if_neg (by omega : ¬2 * m + 1 < m),
      if_neg (by omega : 2 * m + 1 ≠ m), if_neg (by omega : ¬2 * m + 1 ≤ 2 * m)]
    omega
private theorem closedForm_involutive (n : ℕ) : closedForm (closedForm n) = n := by
  by_cases hn : n < 5
  · simp [closedForm, hn]
  have hn5 : 5 ≤ n := by omega
  let m := groupOf n
  obtain ⟨hm, hlo, hhi⟩ := groupOf_bounds n hn5
  change 2 ≤ m at hm
  change groupStart m ≤ n at hlo
  change n < groupStart (m + 1) at hhi
  have hnext := groupStart_succ m (by omega)
  generalize hrdef : n - groupStart m = r
  have hnr : n = groupStart m + r := by
    omega
  have hr : r ≤ 2 * m + 1 := by
    omega
  obtain ⟨hfirst, hsingle, hthird, hfinal⟩ := closedForm_four_blocks m hm
  have hthird' (i : ℕ) (hi : i < m) :
      closedForm (groupStart m + (m + 1 + i)) = groupStart m + 2 * m - i := by
    simpa only [Nat.add_assoc] using hthird i hi
  have hfinal' :
      closedForm (groupStart m + (2 * m + 1)) = groupStart m + 2 * m + 1 := by
    simpa only [Nat.add_assoc] using hfinal
  by_cases hrm : r < m
  · let j := m - 1 - r
    have hj : j < m := by
      dsimp [j]
      omega
    have hvalue : groupStart m + m - 1 - r = groupStart m + j := by
      dsimp [j]
      omega
    rw [hnr, hfirst r hrm, hvalue, hfirst j hj]
    dsimp [j]
    omega
  by_cases hreq : r = m
  · rw [hnr, hreq, hsingle, hsingle]
  by_cases hr2m : r ≤ 2 * m
  · have hmr : m + 1 ≤ r := by omega
    let i := r - (m + 1)
    have hi : i < m := by
      dsimp [i]
      omega
    have hr_eq : r = m + 1 + i := by
      dsimp [i]
      omega
    let j := m - 1 - i
    have hj : j < m := by
      dsimp [j]
      omega
    have hvalue : groupStart m + 2 * m - i = groupStart m + m + 1 + j := by
      dsimp [j]
      omega
    rw [hnr, hr_eq, hthird' i hi, hvalue, hthird j hj]
    dsimp [i, j]
    omega
  · have hr_eq : r = 2 * m + 1 := by omega
    rw [hnr, hr_eq, hfinal', hfinal]
    omega
private theorem mem_closedForm_history (x n : ℕ) :
    x ∈ Finset.image closedForm (Finset.range n) ↔ closedForm x < n := by
  simp only [Finset.mem_image, Finset.mem_range]
  constructor
  · rintro ⟨k, hk, rfl⟩
    simpa only [closedForm_involutive] using hk
  · intro hx
    exact ⟨closedForm x, hx, closedForm_involutive x⟩
/-- Square bounds fixing every floor-square-root value used at a group boundary. -/
theorem interval_invariant (m : ℕ) (hm : 2 ≤ m) :
    let s := groupStart m
    m * m ≤ s - 1 ∧ m * m ≤ s ∧ m * m ≤ s + m ∧ m * m ≤ s + m + 1 ∧
      s - 1 < (m + 1) * (m + 1) ∧ s < (m + 1) * (m + 1) ∧
      s + m < (m + 1) * (m + 1) ∧ s + m + 1 < (m + 1) * (m + 1) ∧
      (m + 1) * (m + 1) ≤ s + 2 * m + 1 ∧
      s + 2 * m + 1 < (m + 2) * (m + 2) := by
  let s := groupStart m
  have hs : s + 1 = m * m + m := by
    dsimp [s, groupStart]
    omega
  have hs₁ : (s - 1) + 1 = s := by
    have : 1 ≤ s := by nlinarith
    omega
  dsimp only
  refine ⟨by nlinarith, by nlinarith, by nlinarith, by nlinarith, by nlinarith,
    by nlinarith, by nlinarith, by nlinarith, by nlinarith, by nlinarith⟩
private theorem sqrt_at_group_boundaries (m : ℕ) (hm : 2 ≤ m) :
    let s := groupStart m
    Nat.sqrt (s - 1) = m ∧ Nat.sqrt s = m ∧ Nat.sqrt (s + m) = m ∧
      Nat.sqrt (s + m + 1) = m ∧ Nat.sqrt (s + 2 * m + 1) = m + 1 := by
  let s := groupStart m
  obtain ⟨hlo₀, hlo₁, hlo₂, hlo₃, hhi₀, hhi₁, hhi₂, hhi₃, hlo₄, hhi₄⟩ :=
    interval_invariant m hm
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact (Nat.eq_sqrt.mpr ⟨hlo₀, hhi₀⟩).symm
  · exact (Nat.eq_sqrt.mpr ⟨hlo₁, hhi₁⟩).symm
  · exact (Nat.eq_sqrt.mpr ⟨hlo₂, hhi₂⟩).symm
  · exact (Nat.eq_sqrt.mpr ⟨hlo₃, hhi₃⟩).symm
  · exact (Nat.eq_sqrt.mpr ⟨hlo₄, hhi₄⟩).symm
private theorem closedForm_group_predecessors (m : ℕ) (hm : 2 ≤ m) :
    let s := groupStart m
    closedForm (s - 1) = s - 1 ∧ closedForm (s - 2) < s := by
  by_cases hm2 : m = 2
  · subst m
    norm_num [closedForm, groupStart, groupOf]
  · have hm3 : 3 ≤ m := by omega
    let q := m - 1
    have hmq : m = q + 1 := by
      dsimp [q]
      omega
    have hq : 2 ≤ q := by omega
    obtain ⟨_, _, hthird, hfinal⟩ := closedForm_four_blocks q hq
    have hend : groupStart q + 2 * q + 1 = groupStart m - 1 := by
      rw [hmq]
      have hs := groupStart_succ q (by omega)
      omega
    have htop : groupStart q + 2 * q = groupStart m - 2 := by
      rw [hmq]
      have hs := groupStart_succ q (by omega)
      omega
    have hpos : groupStart q + q + 1 < groupStart m := by
      rw [hmq]
      have hs := groupStart_succ q (by omega)
      omega
    constructor
    · rw [← hend]
      exact hfinal
    · have hthird0 := hthird 0 (by omega)
      rw [htop] at hthird0
      simp only [Nat.sub_zero, Nat.add_zero] at hthird0
      rw [← hthird0, closedForm_involutive]
      exact hpos
private theorem sub_pred_eq_sub_add_one (a i : ℕ) (hi : 0 < i) (hia : i ≤ a) :
    a - (i - 1) = a - i + 1 := by omega
private theorem final_offset (r m : ℕ) (hrle : r ≤ 2 * m + 1)
    (hrnot : ¬r ≤ 2 * m) : r = 2 * m + 1 := by omega
private theorem final_prev_index (s m N r : ℕ) (hm : 2 ≤ m)
    (hNr : N = s + r) (hr : r = 2 * m + 1) :
    N - 1 = s + m + 1 + (m - 1) := by omega
private theorem final_prev_value (s m : ℕ) (hm : 2 ≤ m) :
    s + 2 * m - (m - 1) = s + m + 1 := by omega
private theorem final_pred_lt (m : ℕ) (hm : 2 ≤ m) : m - 1 < m := by omega
private theorem final_candidate (s m : ℕ) : s + m + 1 - 1 = s + m := by omega
private theorem final_middle_lt (s m N r : ℕ) (hNr : N = s + r)
    (hr : r = 2 * m + 1) : s + m < N := by omega
private theorem final_jump_value (s m : ℕ) : s + 2 * m + 1 = s + m + 1 + m := by omega
set_option maxHeartbeats 1000000 in
/-- The closed form satisfies the literal history-dependent recurrence. -/
theorem closedForm_follows_rule (N : ℕ) (hN : 2 ≤ N) :
    closedForm N =
      if closedForm (N - 1) - 1 ∈ Finset.image closedForm (Finset.range N) then
        closedForm (N - 1) + Nat.sqrt (closedForm (N - 1))
      else
        closedForm (N - 1) - 1 := by
  by_cases hsmall : N < 5
  · simp only [mem_closedForm_history]
    have hsqrtThree : Nat.sqrt 3 = 1 :=
      (Nat.eq_sqrt.mpr (by norm_num)).symm
    interval_cases N <;>
      norm_num [closedForm, groupOf, groupStart, hsqrtThree]
  have hN5 : 5 ≤ N := by omega
  let m := groupOf N
  obtain ⟨hm, hlo, hhi⟩ := groupOf_bounds N hN5
  change 2 ≤ m at hm
  change groupStart m ≤ N at hlo
  change N < groupStart (m + 1) at hhi
  have hnext := groupStart_succ m (by omega)
  generalize hrdef : N - groupStart m = r
  have hNr : N = groupStart m + r := by omega
  have hrle : r ≤ 2 * m + 1 := by omega
  obtain ⟨hfirst, hsingle, hthird, hfinal⟩ := closedForm_four_blocks m hm
  obtain ⟨hsqrtPred, hsqrtFirst, hsqrtMiddle, hsqrtSecond, _⟩ :=
    sqrt_at_group_boundaries m hm
  obtain ⟨hfixedPred, hbeforePred⟩ := closedForm_group_predecessors m hm
  by_cases hr0 : r = 0
  · have hcur : closedForm N = groupStart m + m - 1 := by
      rw [hNr, hr0]
      simpa using hfirst 0 (by omega)
    have hprevIndex : N - 1 = groupStart m - 1 := by omega
    have hprev : closedForm (N - 1) = groupStart m - 1 := by
      rw [hprevIndex]
      exact hfixedPred
    have hcand : closedForm (N - 1) - 1 = groupStart m - 2 := by
      rw [hprev]
      omega
    have hmem : closedForm (N - 1) - 1 ∈
        Finset.image closedForm (Finset.range N) := by
      rw [mem_closedForm_history, hcand]
      omega
    rw [if_pos hmem, hcur, hprev, hsqrtPred]
    omega
  by_cases hrFirst : r < m
  · have hrpos : 0 < r := by omega
    have hcur : closedForm N = groupStart m + m - 1 - r := by
      rw [hNr]
      exact hfirst r hrFirst
    have hprevIndex : N - 1 = groupStart m + (r - 1) := by omega
    have hprev : closedForm (N - 1) = groupStart m + m - r := by
      calc
        closedForm (N - 1) = closedForm (groupStart m + (r - 1)) := by rw [hprevIndex]
        _ = groupStart m + m - 1 - (r - 1) := hfirst (r - 1) (by omega)
        _ = groupStart m + m - r := by omega
    have hcand : closedForm (N - 1) - 1 = closedForm N := by
      rw [hprev, hcur]
      omega
    have hnotmem : closedForm (N - 1) - 1 ∉
        Finset.image closedForm (Finset.range N) := by
      rw [mem_closedForm_history, hcand, closedForm_involutive]
      exact Nat.lt_irrefl N
    rw [if_neg hnotmem, hcur, hprev]
    omega
  by_cases hrMiddle : r = m
  · have hcur : closedForm N = groupStart m + m := by
      rw [hNr, hrMiddle]
      exact hsingle
    have hprevIndex : N - 1 = groupStart m + (m - 1) := by omega
    have hprev : closedForm (N - 1) = groupStart m := by
      calc
        closedForm (N - 1) = closedForm (groupStart m + (m - 1)) := by rw [hprevIndex]
        _ = groupStart m + m - 1 - (m - 1) := hfirst (m - 1) (by omega)
        _ = groupStart m := by omega
    have hmem : closedForm (N - 1) - 1 ∈
        Finset.image closedForm (Finset.range N) := by
      rw [mem_closedForm_history, hprev]
      have hcand : groupStart m - 1 = closedForm (groupStart m - 1) :=
        hfixedPred.symm
      rw [hcand, closedForm_involutive]
      omega
    rw [if_pos hmem, hcur, hprev, hsqrtFirst]
  by_cases hrSecondStart : r = m + 1
  · have hcur : closedForm N = groupStart m + 2 * m := by
      rw [hNr, hrSecondStart]
      simpa only [Nat.add_assoc, Nat.add_zero, Nat.sub_zero] using hthird 0 (by omega)
    have hprevIndex : N - 1 = groupStart m + m := by omega
    have hprev : closedForm (N - 1) = groupStart m + m := by
      rw [hprevIndex]
      exact hsingle
    have hfirst0 := hfirst 0 (by omega)
    simp only [Nat.add_zero, Nat.sub_zero] at hfirst0
    have hcandidatePreimage : closedForm (groupStart m + m - 1) = groupStart m := by
      have h := congrArg closedForm hfirst0
      have hh : groupStart m = closedForm (groupStart m + m - 1) := by
        simpa only [closedForm_involutive] using h
      exact hh.symm
    have hmem : closedForm (N - 1) - 1 ∈
        Finset.image closedForm (Finset.range N) := by
      rw [mem_closedForm_history, hprev, hcandidatePreimage]
      omega
    rw [if_pos hmem, hcur, hprev, hsqrtMiddle]
    omega
  by_cases hrSecond : r ≤ 2 * m
  · have hrLower : m + 2 ≤ r := by omega
    generalize hidef : r - (m + 1) = i
    have hi : 0 < i := by omega
    have him : i < m := by omega
    have hri : r = m + 1 + i := by omega
    have hcur : closedForm N = groupStart m + 2 * m - i := by
      rw [hNr, hri]
      simpa only [Nat.add_assoc] using hthird i him
    have hprevIndex : N - 1 = groupStart m + m + 1 + (i - 1) := by omega
    have hprev : closedForm (N - 1) = groupStart m + 2 * m - i + 1 := by
      calc
        closedForm (N - 1) = closedForm (groupStart m + m + 1 + (i - 1)) := by
          rw [hprevIndex]
        _ = groupStart m + 2 * m - (i - 1) := hthird (i - 1) (by omega)
        _ = groupStart m + 2 * m - i + 1 :=
          sub_pred_eq_sub_add_one _ i hi (by omega)
    have hcand : closedForm (N - 1) - 1 = closedForm N := by
      rw [hprev, hcur]
      omega
    have hnotmem : closedForm (N - 1) - 1 ∉
        Finset.image closedForm (Finset.range N) := by
      rw [mem_closedForm_history, hcand, closedForm_involutive]
      exact Nat.lt_irrefl N
    rw [if_neg hnotmem, hcur, hprev]
    omega
  · have hrFinal : r = 2 * m + 1 := final_offset r m hrle hrSecond
    have hcur : closedForm N = groupStart m + 2 * m + 1 := by
      rw [hNr, hrFinal]
      exact hfinal
    have hprevIndex : N - 1 = groupStart m + m + 1 + (m - 1) :=
      final_prev_index (groupStart m) m N r hm hNr hrFinal
    have hprev : closedForm (N - 1) = groupStart m + m + 1 := by
      calc
        closedForm (N - 1) = closedForm (groupStart m + m + 1 + (m - 1)) := by
          rw [hprevIndex]
        _ = groupStart m + 2 * m - (m - 1) :=
          hthird (m - 1) (final_pred_lt m hm)
        _ = groupStart m + m + 1 := final_prev_value (groupStart m) m hm
    have hmem : closedForm (N - 1) - 1 ∈
        Finset.image closedForm (Finset.range N) := by
      rw [mem_closedForm_history, hprev, final_candidate, hsingle]
      exact final_middle_lt (groupStart m) m N r hNr hrFinal
    rw [if_pos hmem]
    calc
      closedForm N = groupStart m + 2 * m + 1 := hcur
      _ = groupStart m + m + 1 + m := final_jump_value (groupStart m) m
      _ = closedForm (N - 1) + Nat.sqrt (closedForm (N - 1)) := by
        rw [hprev, hsqrtSecond]
/-- The literal recursive sequence equals the explicit four-block closed form. -/
theorem seq_eq_closedForm (n : ℕ) : seq n = closedForm n := by
  induction n using Nat.strong_induction_on with
  | h n ih =>
      rcases n with _ | n
      · rfl
      rcases n with _ | n
      · rfl
      rw [seq_succ_succ]
      have hprev : seq (n + 1) = closedForm (n + 1) := ih (n + 1) (by omega)
      have himage :
          Finset.image seq (Finset.range ((n + 1) + 1)) =
            Finset.image closedForm (Finset.range ((n + 1) + 1)) := by
        apply Finset.image_congr
        intro k hk
        exact ih k (by
          have := Finset.mem_range.mp hk
          omega)
      rw [hprev, himage]
      have hrule := closedForm_follows_rule (n + 2) (by omega)
      have hpred : n + 2 - 1 = n + 1 := by omega
      have hsum : n + 2 = n + 1 + 1 := by omega
      rw [hpred, hsum] at hrule
      exact hrule.symm
/-- Each parameter `m ≥ 2` gives decreasing blocks of lengths `m, 1, m, 1`. -/
theorem seq_four_blocks (m : ℕ) (hm : 2 ≤ m) :
    let s := groupStart m
    (∀ i < m, seq (s + i) = s + m - 1 - i) ∧
      seq (s + m) = s + m ∧
      (∀ i < m, seq (s + m + 1 + i) = s + 2 * m - i) ∧
      seq (s + 2 * m + 1) = s + 2 * m + 1 := by
  simpa only [seq_eq_closedForm] using closedForm_four_blocks m hm
/-- A nonempty decreasing run that cannot be extended to either side. -/
def IsMaximalDecreasingRun (a : ℕ → ℕ) (start len : ℕ) : Prop :=
  0 < len ∧
    (∀ j, j + 1 < len → a (start + j + 1) < a (start + j)) ∧
    (start = 0 ∨ ¬a start < a (start - 1)) ∧
    ¬a (start + len) < a (start + len - 1)
private def CanonicalRun (start len : ℕ) : Prop :=
  (start < 5 ∧ len = 1) ∨
    ∃ m, 2 ≤ m ∧
      ((start = groupStart m ∧ len = m) ∨
       (start = groupStart m + m ∧ len = 1) ∨
       (start = groupStart m + m + 1 ∧ len = m) ∨
       (start = groupStart m + 2 * m + 1 ∧ len = 1))
private theorem initial_run_maximal (k : ℕ) (hk : k < 5) :
    IsMaximalDecreasingRun seq k 1 := by
  have hsmall (n : ℕ) (hn : n < 5) : seq n = n := by
    rw [seq_eq_closedForm]
    simp only [closedForm, if_pos hn]
  have hseq5 : seq 5 = 6 := by
    obtain ⟨hfirst, _, _, _⟩ := seq_four_blocks 2 (by omega)
    norm_num [groupStart] at hfirst ⊢
    exact hfirst 0 (by omega)
  unfold IsMaximalDecreasingRun
  refine ⟨by omega, ?_, ?_, ?_⟩
  · intro j hj
    omega
  · by_cases hk0 : k = 0
    · exact Or.inl hk0
    · apply Or.inr
      rw [hsmall k hk, hsmall (k - 1) (by omega)]
      omega
  · rw [show k + 1 - 1 = k by omega, hsmall k hk]
    by_cases hk4 : k < 4
    · rw [hsmall (k + 1) (by omega)]
      omega
    · have : k = 4 := by omega
      subst k
      norm_num [hseq5]
private theorem first_run_maximal (m : ℕ) (hm : 2 ≤ m) :
    IsMaximalDecreasingRun seq (groupStart m) m := by
  let s := groupStart m
  obtain ⟨hfirst, hsingle, hthird, hfinal⟩ := seq_four_blocks m hm
  obtain ⟨hfixedPred, _⟩ := closedForm_group_predecessors m hm
  have hfirst0 : seq s = s + m - 1 := by
    simpa only [s, Nat.add_zero, Nat.sub_zero] using hfirst 0 (by omega)
  have hprev : seq (s - 1) = s - 1 := by
    rw [seq_eq_closedForm]
    exact hfixedPred
  have hlast : seq (s + m - 1) = s := by
    calc
      seq (s + m - 1) = seq (s + (m - 1)) := by
        congr 1
        omega
      _ = s + m - 1 - (m - 1) := hfirst (m - 1) (by omega)
      _ = s := by
        dsimp [s, groupStart]
        omega
  unfold IsMaximalDecreasingRun
  refine ⟨by omega, ?_, ?_, ?_⟩
  · intro j hj
    have hjm : j < m := by omega
    have hnext := hfirst (j + 1) hj
    have hnow := hfirst j hjm
    rw [show s + j + 1 = s + (j + 1) by omega, hnext, hnow]
    omega
  · exact Or.inr (by rw [hfirst0, hprev]; omega)
  · rw [show s + m - 1 = s + m - 1 by rfl, hsingle, hlast]
    omega
private theorem middle_singleton_maximal (m : ℕ) (hm : 2 ≤ m) :
    IsMaximalDecreasingRun seq (groupStart m + m) 1 := by
  let s := groupStart m
  obtain ⟨hfirst, hsingle, hthird, _⟩ := seq_four_blocks m hm
  have hlast : seq (s + m - 1) = s := by
    calc
      seq (s + m - 1) = seq (s + (m - 1)) := by
        congr 1
        omega
      _ = s + m - 1 - (m - 1) := hfirst (m - 1) (by omega)
      _ = s := by
        dsimp [s, groupStart]
        omega
  have hnext : seq (s + m + 1) = s + 2 * m := by
    simpa only [Nat.add_zero, Nat.sub_zero] using hthird 0 (by omega)
  unfold IsMaximalDecreasingRun
  refine ⟨by omega, ?_, ?_, ?_⟩
  · intro j hj
    omega
  · apply Or.inr
    rw [show s + m - 1 = s + m - 1 by rfl, hsingle, hlast]
    omega
  · rw [show s + m + 1 = s + m + 1 by rfl,
      show s + m + 1 - 1 = s + m by omega, hnext, hsingle]
    omega
private theorem second_run_maximal (m : ℕ) (hm : 2 ≤ m) :
    IsMaximalDecreasingRun seq (groupStart m + m + 1) m := by
  let s := groupStart m
  obtain ⟨_, hsingle, hthird, hfinal⟩ := seq_four_blocks m hm
  have hfirst : seq (s + m + 1) = s + 2 * m := by
    simpa only [Nat.add_zero, Nat.sub_zero] using hthird 0 (by omega)
  have hlast : seq (s + 2 * m) = s + m + 1 := by
    calc
      seq (s + 2 * m) = seq (s + m + 1 + (m - 1)) := by
        congr 1
        omega
      _ = s + 2 * m - (m - 1) := hthird (m - 1) (by omega)
      _ = s + m + 1 := final_prev_value s m hm
  unfold IsMaximalDecreasingRun
  refine ⟨by omega, ?_, ?_, ?_⟩
  · intro j hj
    have hjm : j < m := by omega
    have hnext := hthird (j + 1) hj
    have hnow := hthird j hjm
    rw [show s + m + 1 + j + 1 = s + m + 1 + (j + 1) by omega,
      hnext, hnow]
    omega
  · apply Or.inr
    rw [show s + m + 1 - 1 = s + m by omega, hfirst, hsingle]
    omega
  · rw [show s + m + 1 + m = s + 2 * m + 1 by omega, hfinal,
      show s + 2 * m + 1 - 1 = s + 2 * m by omega, hlast]
    omega
private theorem final_singleton_maximal (m : ℕ) (hm : 2 ≤ m) :
    IsMaximalDecreasingRun seq (groupStart m + 2 * m + 1) 1 := by
  let s := groupStart m
  obtain ⟨_, _, hthird, hfinal⟩ := seq_four_blocks m hm
  obtain ⟨hfirstNext, _, _, _⟩ := seq_four_blocks (m + 1) (by omega)
  have hlast : seq (s + 2 * m) = s + m + 1 := by
    calc
      seq (s + 2 * m) = seq (s + m + 1 + (m - 1)) := by
        congr 1
        omega
      _ = s + 2 * m - (m - 1) := hthird (m - 1) (by omega)
      _ = s + m + 1 := final_prev_value s m hm
  have hsNext : groupStart (m + 1) = s + 2 * m + 2 := by
    dsimp only [s]
    exact groupStart_succ m (by omega)
  have hnext : seq (s + 2 * m + 2) = s + 3 * m + 2 := by
    calc
      seq (s + 2 * m + 2) = seq (groupStart (m + 1) + 0) := by rw [hsNext]
      _ = groupStart (m + 1) + (m + 1) - 1 - 0 := hfirstNext 0 (by omega)
      _ = s + 3 * m + 2 := by rw [hsNext]; omega
  unfold IsMaximalDecreasingRun
  refine ⟨by omega, ?_, ?_, ?_⟩
  · intro j hj
    omega
  · apply Or.inr
    rw [show s + 2 * m + 1 - 1 = s + 2 * m by omega, hfinal, hlast]
    omega
  · rw [show s + 2 * m + 1 + 1 = s + 2 * m + 2 by omega,
      show s + 2 * m + 1 + 1 - 1 = s + 2 * m + 1 by omega, hnext, hfinal]
    omega
private theorem canonical_run_maximal {start len : ℕ}
    (h : CanonicalRun start len) : IsMaximalDecreasingRun seq start len := by
  rcases h with ⟨hstart, rfl⟩ | ⟨m, hm, h⟩
  · exact initial_run_maximal start hstart
  · rcases h with h | h | h | h
    · rw [h.1, h.2]
      exact first_run_maximal m hm
    · rw [h.1, h.2]
      exact middle_singleton_maximal m hm
    · rw [h.1, h.2]
      exact second_run_maximal m hm
    · rw [h.1, h.2]
      exact final_singleton_maximal m hm
private theorem canonical_run_covers (n : ℕ) :
    ∃ start len, CanonicalRun start len ∧ start ≤ n ∧ n < start + len := by
  by_cases hn : n < 5
  · exact ⟨n, 1, Or.inl ⟨hn, rfl⟩, le_rfl, by omega⟩
  · have hn5 : 5 ≤ n := by omega
    let m := groupOf n
    obtain ⟨hm, hlo, hhi⟩ := groupOf_bounds n hn5
    change 2 ≤ m at hm
    change groupStart m ≤ n at hlo
    change n < groupStart (m + 1) at hhi
    have hnext := groupStart_succ m (by omega)
    generalize hrdef : n - groupStart m = r
    have hnr : n = groupStart m + r := by omega
    have hrle : r ≤ 2 * m + 1 := by omega
    by_cases hfirst : r < m
    · refine ⟨groupStart m, m, Or.inr ⟨m, hm, Or.inl ⟨rfl, rfl⟩⟩, ?_, ?_⟩
      · omega
      · omega
    by_cases hmiddle : r = m
    · refine ⟨groupStart m + m, 1,
          Or.inr ⟨m, hm, Or.inr (Or.inl ⟨rfl, rfl⟩)⟩, ?_, ?_⟩
      · omega
      · omega
    by_cases hsecond : r ≤ 2 * m
    · refine ⟨groupStart m + m + 1, m,
          Or.inr ⟨m, hm, Or.inr (Or.inr (Or.inl ⟨rfl, rfl⟩))⟩, ?_, ?_⟩
      · omega
      · omega
    · have hfinal : r = 2 * m + 1 := final_offset r m hrle hsecond
      refine ⟨groupStart m + 2 * m + 1, 1,
        Or.inr ⟨m, hm, Or.inr (Or.inr (Or.inr ⟨rfl, rfl⟩))⟩, ?_, ?_⟩
      · omega
      · omega
private theorem maximal_runs_eq_of_overlap {a : ℕ → ℕ} {s l t k : ℕ}
    (hs : IsMaximalDecreasingRun a s l)
    (ht : IsMaximalDecreasingRun a t k)
    (htIn : t < s + l) (hsIn : s < t + k) : s = t ∧ l = k := by
  unfold IsMaximalDecreasingRun at hs ht
  rcases hs with ⟨hl, hsDown, hsLeft, hsRight⟩
  rcases ht with ⟨hk, htDown, htLeft, htRight⟩
  have hstart : s = t := by
    by_contra hne
    rcases lt_or_gt_of_ne hne with hst | hts
    · let j := t - s - 1
      have hj : j + 1 < l := by
        dsimp [j]
        omega
      have hdec := hsDown j hj
      have hnext : s + j + 1 = t := by
        dsimp [j]
        omega
      have hnow : s + j = t - 1 := by
        dsimp [j]
        omega
      rw [hnext, hnow] at hdec
      rcases htLeft with htZero | htNot
      · omega
      · exact htNot hdec
    · let j := s - t - 1
      have hj : j + 1 < k := by
        dsimp [j]
        omega
      have hdec := htDown j hj
      have hnext : t + j + 1 = s := by
        dsimp [j]
        omega
      have hnow : t + j = s - 1 := by
        dsimp [j]
        omega
      rw [hnext, hnow] at hdec
      rcases hsLeft with hsZero | hsNot
      · omega
      · exact hsNot hdec
  subst t
  refine ⟨rfl, Nat.le_antisymm ?_ ?_⟩
  · by_contra hnot
    have hkl : k < l := by omega
    have hdec := hsDown (k - 1) (by omega)
    have hnext : s + (k - 1) + 1 = s + k := by omega
    have hnow : s + (k - 1) = s + k - 1 := by omega
    rw [hnext, hnow] at hdec
    exact htRight hdec
  · by_contra hnot
    have hlk : l < k := by omega
    have hdec := htDown (l - 1) (by omega)
    have hnext : s + (l - 1) + 1 = s + l := by omega
    have hnow : s + (l - 1) = s + l - 1 := by omega
    rw [hnext, hnow] at hdec
    exact hsRight hdec
/-- The maximal decreasing runs have lengths `1,1,1,1,1`, then `m,1,m,1` for every `m ≥ 2`. -/
theorem maximal_decreasing_run_lengths (start len : ℕ) :
    IsMaximalDecreasingRun seq start len ↔
      (start < 5 ∧ len = 1) ∨
        ∃ m, 2 ≤ m ∧
          ((start = groupStart m ∧ len = m) ∨
           (start = groupStart m + m ∧ len = 1) ∨
           (start = groupStart m + m + 1 ∧ len = m) ∨
           (start = groupStart m + 2 * m + 1 ∧ len = 1)) := by
  change IsMaximalDecreasingRun seq start len ↔ CanonicalRun start len
  constructor
  · intro hmax
    obtain ⟨cstart, clen, hcanonical, hstart, hend⟩ := canonical_run_covers start
    have hcmax := canonical_run_maximal hcanonical
    have hlen : 0 < len := hmax.1
    have hclen : 0 < clen := hcmax.1
    have heq := maximal_runs_eq_of_overlap hmax hcmax (by omega) hend
    rw [heq.1, heq.2]
    exact hcanonical
  · exact canonical_run_maximal
/-- The first published terms agree with the literal history-dependent recursion. -/
example : (List.range 66).map seq =
    [0, 1, 2, 3, 4, 6, 5, 7, 9, 8, 10, 13, 12, 11, 14, 17, 16, 15, 18, 22, 21, 20,
      19, 23, 27, 26, 25, 24, 28, 33, 32, 31, 30, 29, 34, 39, 38, 37, 36, 35, 40,
      46, 45, 44, 43, 42, 41, 47, 53, 52, 51, 50, 49, 48, 54, 61, 60, 59, 58, 57,
      56, 55, 62, 69, 68, 67] := by
  rw [List.map_congr_left (fun _ _ => seq_eq_closedForm _)]
  native_decide
/-- A concrete admissible group index witnesses that the theorem's quantified domain is inhabited. -/
example : 2 ≤ (2 : ℕ) := by decide
end D5.S1.Digit.GreedyFloorSqrtRunBlocks
