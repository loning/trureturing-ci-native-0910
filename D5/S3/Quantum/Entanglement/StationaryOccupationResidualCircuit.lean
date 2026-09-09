/- GID: D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit
   generality: G
   mirror-B: D5/B/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Last-tail multiplicities give residual vectors whose local transitions determine every normalized occupation-circuit coefficient. -/

import D5.S3.Quantum.Entanglement.StationaryOccupationPadding

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section
open scoped BigOperators

namespace D5.S3.Quantum.Entanglement.StationaryOccupationResidualCircuit

open D5.S3.Quantum.Entanglement.StationaryOccupationPadding
open D5.S3.Quantum.Entanglement.SequentialRegisterCircuit
open D5.S3.Quantum.Entanglement.OccupancyWordSectors

section Target

/-- Fixed-unitary occupation preparation at the product-minus-maximum dimension. -/
def Target {A : Type*} [Fintype A] [DecidableEq A] [Nonempty A]
    (a : Multiset A) : Prop :=
  let d := (Finset.univ.prod fun i : A => a.count i + 1) -
    Finset.univ.sup a.count
  ∃ (blank : A) (U : Unitary (A × Fin d)) (x f : Space (Fin d)),
    ‖x‖ = 1 ∧ ‖f‖ = 1 ∧
    ∀ (w : Fin a.card → A) (k : Fin d),
      circuit (fun _ => U) a.card 0 (initialized blank a.card x) (w, k) =
        sectorVector a.card a w * f k

end Target

section LastTailMass

open D5.S3.Quantum.Entanglement.OccupancyWordSectors

variable {A : Type*} [Fintype A] [DecidableEq A]

def tailCount (head : A) (b : Multiset A) : ℕ :=
  ∑ i : {i : A // i ≠ head}, b.count i.val

theorem head_add_tail_count (head : A) (b : Multiset A) :
    b.count head + tailCount head b = b.card := by
  unfold tailCount
  rw [← Fintype.sum_eq_add_sum_subtype_ne b.count head]
  exact Multiset.sum_count_eq_card (fun _ _ => Finset.mem_univ _)

theorem tail_count_erase_head (head : A) (b : Multiset A) :
    tailCount head (b.erase head) = tailCount head b := by
  apply Finset.sum_congr rfl
  intro i _
  exact Multiset.count_erase_of_ne i.property b

theorem tail_count_erase_tail (head : A) (b : Multiset A) (i : A)
    (hi : i ≠ head) (hib : i ∈ b) :
    tailCount head (b.erase i) + 1 = tailCount head b := by
  have h1 := head_add_tail_count head b
  have h2 := head_add_tail_count head (b.erase i)
  have hc : (b.erase i).count head = b.count head :=
    Multiset.count_erase_of_ne (Ne.symm hi) b
  have hn : (b.erase i).card + 1 = b.card := by
    simpa using congrArg Multiset.card (Multiset.cons_erase hib)
  omega

/-- The ordinary last-tail weight, expressed using actual occupation-word multiplicity. -/
def lastTailMass (head : A) (b : Multiset A) : ℝ :=
  (tailCount head b : ℝ) * (multiplicity b.card b : ℝ) / (b.card : ℝ)

theorem last_tail_mass_nonneg (head : A) (b : Multiset A) : 0 ≤ lastTailMass head b := by
  unfold lastTailMass
  positivity

theorem last_tail_mass_pos (head : A) (b : Multiset A) (hR : 0 < tailCount head b) :
    0 < lastTailMass head b := by
  have hn : 0 < b.card := by have := head_add_tail_count head b; omega
  unfold lastTailMass
  exact div_pos (mul_pos (by exact_mod_cast hR)
    (by exact_mod_cast multiplicity_pos b rfl)) (by exact_mod_cast hn)

theorem erase_multiplicity_real (b : Multiset A) (i : A) (hi : i ∈ b) :
    (b.card : ℝ) * (multiplicity (b.erase i).card (b.erase i) : ℝ) =
      (b.count i : ℝ) * (multiplicity b.card b : ℝ) := by
  have hn : (b.erase i).card + 1 = b.card := by
    simpa using congrArg Multiset.card (Multiset.cons_erase hi)
  have hm := multiplicity_erase_mul (n := (b.erase i).card) hn.symm i hi
  rw [hn] at hm
  exact_mod_cast hm

theorem last_tail_mass_erase_head (head : A) (b : Multiset A)
    (hi : head ∈ b) (hR : 0 < tailCount head b) :
    lastTailMass head (b.erase head) =
      headProbability (b.count head) (tailCount head b) * lastTailMass head b := by
  have hsum := head_add_tail_count head b
  have hc : (b.erase head).card + 1 = b.card := by
    simpa using congrArg Multiset.card (Multiset.cons_erase hi)
  have hb : 0 < b.count head := Multiset.count_pos.mpr hi
  have hn : (0 : ℝ) < b.card := by exact_mod_cast (by omega : 0 < b.card)
  have he : (0 : ℝ) < (b.erase head).card := by
    exact_mod_cast (by omega : 0 < (b.erase head).card)
  have hcR : ((b.erase head).card : ℝ) + 1 = b.card := by exact_mod_cast hc
  have hsR : (b.count head : ℝ) + tailCount head b = b.card := by exact_mod_cast hsum
  have hm := erase_multiplicity_real b head hi
  unfold lastTailMass headProbability
  rw [tail_count_erase_head]
  have hd : (b.count head : ℝ) + tailCount head b - 1 = (b.erase head).card := by linarith
  rw [hd]
  field_simp [hn.ne', he.ne']
  nlinarith [congrArg (fun x : ℝ => (tailCount head b : ℝ) * x) hm]

theorem last_tail_mass_erase_tail (head : A) (b : Multiset A) (i : A)
    (hi : i ≠ head) (hib : i ∈ b) (hR : 2 ≤ tailCount head b) :
    lastTailMass head (b.erase i) =
      tailProbability (b.count head) (tailCount head b) (b.count i) * lastTailMass head b := by
  have hsum := head_add_tail_count head b
  have hc : (b.erase i).card + 1 = b.card := by
    simpa using congrArg Multiset.card (Multiset.cons_erase hib)
  have ht := tail_count_erase_tail head b i hi hib
  have hn : (0 : ℝ) < b.card := by exact_mod_cast (by omega : 0 < b.card)
  have he : (0 : ℝ) < (b.erase i).card := by
    exact_mod_cast (by omega : 0 < (b.erase i).card)
  have hr : (0 : ℝ) < tailCount head b := by exact_mod_cast (by omega : 0 < tailCount head b)
  have hcR : ((b.erase i).card : ℝ) + 1 = b.card := by exact_mod_cast hc
  have hsR : (b.count head : ℝ) + tailCount head b = b.card := by exact_mod_cast hsum
  have htR : (tailCount head (b.erase i) : ℝ) + 1 = tailCount head b := by exact_mod_cast ht
  have hm := erase_multiplicity_real b i hib
  unfold lastTailMass tailProbability
  have hd : (b.count head : ℝ) + tailCount head b - 1 = (b.erase i).card := by linarith
  rw [hd, show (tailCount head (b.erase i) : ℝ) = tailCount head b - 1 by linarith]
  field_simp [hn.ne', he.ne', hr.ne']
  nlinarith [congrArg (fun x : ℝ => ((tailCount head b : ℝ) - 1) * x) hm]

theorem last_tail_mass_singleton (head i : A) (hi : i ≠ head) :
    lastTailMass head ({i} : Multiset A) = 1 := by
  have hs := head_add_tail_count head ({i} : Multiset A)
  have ht : tailCount head ({i} : Multiset A) = 1 := by simpa [hi, Ne.symm hi] using hs
  have hm : multiplicity ({i} : Multiset A).card ({i} : Multiset A) = 1 := by
    rw [multiplicity_eq_factorial _ rfl]
    have hp : (∏ z : A, (({i} : Multiset A).count z).factorial) = 1 := by
      apply Finset.prod_eq_one
      intro z _
      by_cases hz : z = i <;> simp [hz]
    simp [hp]
  unfold lastTailMass
  rw [ht, hm]
  simp

theorem last_tail_mass_one (head : A) (b : Multiset A)
    (hR : tailCount head b = 1) : lastTailMass head b = 1 := by
  induction hn : b.card using Nat.strong_induction_on generalizing b with
  | h n ih =>
    by_cases hh : head ∈ b
    · have he : (b.erase head).card < n := by
        rw [Multiset.card_erase_of_mem hh, hn]
        have : b.card ≠ 0 := by
          intro hz
          have hb := Multiset.card_eq_zero.mp hz
          simpa [hb] using hh
        exact Nat.pred_lt (by simpa [hn] using this)
      have hr : tailCount head (b.erase head) = 1 := by
        rw [tail_count_erase_head, hR]
      have hm := ih _ he (b.erase head) hr rfl
      have hp : headProbability (b.count head) (tailCount head b) = 1 := by
        have hc : (b.count head : ℝ) ≠ 0 := by
          exact_mod_cast (Multiset.count_pos.mpr hh).ne'
        simp [headProbability, hR, hc]
      rw [last_tail_mass_erase_head head b hh (by omega), hp, one_mul] at hm
      exact hm
    · have hc : b.card = 1 := by
        simpa [Multiset.count_eq_zero.mpr hh, hR] using
          (head_add_tail_count head b).symm
      obtain ⟨i, rfl⟩ := Multiset.card_eq_one.mp hc
      apply last_tail_mass_singleton
      simpa [eq_comm] using hh

theorem last_tail_head_amplitude (head : A) (b : Multiset A)
    (hi : head ∈ b) (hR : 0 < tailCount head b) :
    (Real.sqrt (headProbability (b.count head) (tailCount head b)) : ℂ) *
      (Real.sqrt (lastTailMass head b) : ℂ) =
      (Real.sqrt (lastTailMass head (b.erase head)) : ℂ) := by
  have hr : (1 : ℝ) ≤ tailCount head b := by exact_mod_cast hR
  have hp : 0 ≤ headProbability (b.count head) (tailCount head b) := by
    unfold headProbability
    exact div_nonneg (Nat.cast_nonneg _) (by linarith [Nat.cast_nonneg (α := ℝ) (b.count head)])
  rw [last_tail_mass_erase_head head b hi hR, Real.sqrt_mul hp, Complex.ofReal_mul]

theorem last_tail_tail_amplitude (head : A) (b : Multiset A) (i : A)
    (hi : i ≠ head) (hib : i ∈ b) (hR : 2 ≤ tailCount head b) :
    (Real.sqrt (tailProbability (b.count head) (tailCount head b) (b.count i)) : ℂ) *
      (Real.sqrt (lastTailMass head b) : ℂ) =
      (Real.sqrt (lastTailMass head (b.erase i)) : ℂ) := by
  have hr : (2 : ℝ) ≤ tailCount head b := by exact_mod_cast hR
  have hp : 0 ≤ tailProbability (b.count head) (tailCount head b) (b.count i) := by
    unfold tailProbability
    apply div_nonneg
    · exact mul_nonneg (Nat.cast_nonneg _) (by linarith)
    · exact mul_nonneg (Nat.cast_nonneg _)
        (by linarith [Nat.cast_nonneg (α := ℝ) (b.count head)])
  rw [last_tail_mass_erase_tail head b i hi hib hR, Real.sqrt_mul hp, Complex.ofReal_mul]

end LastTailMass

section CircuitOutput

open D5.S3.Quantum.Entanglement.SequentialRegisterCircuit
open D5.S3.Quantum.Entanglement.OccupancyWordSectors

variable {A K : Type*} [Fintype A] [DecidableEq A] [Fintype K] [DecidableEq K]

def blankMemory (blank : A) : Space K →ₗᵢ[ℂ] Space (A × K) :=
  coordinateEmbedding (blankInjection blank (Function.Embedding.refl K))

theorem blank_memory_apply (blank : A) (x : Space K) (i : A) (k : K) :
    blankMemory blank x (i, k) = if i = blank then x k else 0 := by
  by_cases hi : i = blank
  · subst i
    simpa [blankMemory, blankInjection] using
      (coordinate_embedding_apply (blankInjection blank (Function.Embedding.refl K)) x k)
  · rw [if_neg hi]
    apply coordinate_embedding_off_range
    rintro ⟨j, hj⟩
    exact hi (congrArg Prod.fst hj).symm

theorem initialized_apply_all (blank : A) (n : ℕ) (x : Space K)
    (w : Fin n → A) (k : K) :
    initialized blank n x (w, k) = if w = (fun _ => blank) then x k else 0 := by
  classical
  conv_lhs => rw [basis_expansion x]
  simp only [map_sum, map_smul, initialize_basis]
  by_cases hw : w = (fun _ => blank) <;>
    simp [blankState, basis_apply, Prod.mk.injEq, hw]

theorem first_gate_initialized (blank : A) (n : ℕ) (U : Unitary (A × K))
    (x : Space K) (w : Fin (n + 1) → A) (k : K) :
    firstGate n U (initialized blank (n + 1) x) (w, k) =
      if Fin.tail w = (fun _ => blank) then U (blankMemory blank x) (w 0, k) else 0 := by
  rw [first_gate_apply]
  have hc (i : A) (u : Fin n → A) :
      Fin.cons i u = (fun _ => blank) ↔ i = blank ∧ u = (fun _ => blank) := by
    simp [funext_iff, Fin.forall_fin_succ]
  have hv : (WithLp.toLp 2 (fun p : A × K =>
      initialized blank (n + 1) x (Fin.cons p.1 (Fin.tail w), p.2))) =
      if Fin.tail w = (fun _ => blank) then blankMemory blank x else 0 := by
    ext p
    rcases p with ⟨i, j⟩
    by_cases ht : Fin.tail w = (fun _ => blank) <;>
      simp [initialized_apply_all, hc, ht, blank_memory_apply]
  rw [hv]
  split <;> simp_all

/-- Actual unitary circuit recursion on an arbitrary pure initial memory. -/
theorem circuit_initialized_step (blank : A) (U : ℕ → Unitary (A × K))
    (n t : ℕ) (x : Space K) (w : Fin (n + 1) → A) (k : K) :
    circuit U (n + 1) t (initialized blank (n + 1) x) (w, k) =
      circuit U n (t + 1)
        (initialized blank n (WithLp.toLp 2
          (fun j : K => U t (blankMemory blank x) (w 0, j)))) (Fin.tail w, k) := by
  simp only [circuit, LinearIsometryEquiv.trans_apply, tail_gate_apply]
  have hv : (WithLp.toLp 2 (fun p : Register A K n =>
      firstGate n (U t) (initialized blank (n + 1) x) (Fin.cons (w 0) p.1, p.2))) =
      initialized blank n (WithLp.toLp 2
        (fun j : K => U t (blankMemory blank x) (w 0, j))) := by
    ext p
    rcases p with ⟨u, j⟩
    simp [first_gate_initialized, initialized_apply_all]
  rw [hv]

theorem occupation_cons_eq {n : ℕ} (i : A) (w : Word A n) :
    occupation (Fin.cons i w) = i ::ₘ occupation w := by
  simp only [occupation, List.ofFn_cons]
  rfl

theorem occupation_head_tail_iff {n : ℕ} (w : Word A (n + 1)) (b : Multiset A) :
    occupation w = b ↔ w 0 ∈ b ∧ occupation (Fin.tail w) = b.erase (w 0) := by
  conv_lhs => rw [← Fin.cons_self_tail w, occupation_cons_eq]
  rw [← Multiset.singleton_add, add_comm ({w 0} : Multiset A),
    Multiset.add_singleton_eq_iff]

/-- Local residual equations imply every coefficient of the actual repeated circuit.
The local equations are construction obligations, not an assumed output theorem. -/
theorem circuit_output_of_residuals (blank : A) (U : Unitary (A × K))
    (a : Multiset A) (r : Multiset A → Space K) (f : Space K)
    (hzero : r 0 = f)
    (hstep : ∀ b, b ≤ a → b ≠ 0 → ∀ i k,
      U (blankMemory blank (r b)) (i, k) = if i ∈ b then r (b.erase i) k else 0) :
    ∀ n t b, b.card = n → b ≤ a → ∀ (w : Word A n) k,
      circuit (fun _ => U) n t (initialized blank n (r b)) (w, k) =
        if occupation w = b then f k else 0 := by
  intro n
  induction n with
  | zero =>
    intro t b hb hba w k
    have hb0 : b = 0 := Multiset.card_eq_zero.mp hb
    subst b
    have hw : w = (fun _ => blank) := Subsingleton.elim _ _
    simp [circuit, initialized_apply_all, hzero, hw, occupation]
  | succ n ih =>
    intro t b hb hba w k
    have hb0 : b ≠ 0 := by intro hz; simp [hz] at hb
    rw [circuit_initialized_step]
    have hv : (WithLp.toLp 2
        (fun j : K => U (blankMemory blank (r b)) (w 0, j))) =
        if w 0 ∈ b then r (b.erase (w 0)) else 0 := by
      ext j
      by_cases hi : w 0 ∈ b <;> simp [hstep b hba hb0, hi]
    rw [hv]
    by_cases hi : w 0 ∈ b
    · rw [if_pos hi]
      have hcard : (b.erase (w 0)).card = n := by
        simp [Multiset.card_erase_of_mem hi, hb]
      rw [ih (t + 1) (b.erase (w 0)) hcard ((Multiset.erase_le _ _).trans hba)]
      simp only [occupation_head_tail_iff w b, hi, true_and]
    · have hw : occupation w ≠ b := fun h => hi ((occupation_head_tail_iff w b).mp h).1
      simp [hi, hw]

theorem normalized_output_of_residuals (blank : A) (U : Unitary (A × K))
    (a : Multiset A) (r : Multiset A → Space K) (f : Space K)
    (hzero : r 0 = f)
    (hstep : ∀ b, b ≤ a → b ≠ 0 → ∀ i k,
      U (blankMemory blank (r b)) (i, k) = if i ∈ b then r (b.erase i) k else 0) :
    ∀ w k, circuit (fun _ => U) a.card 0
      (initialized blank a.card ((Real.sqrt (multiplicity a.card a : ℝ) : ℂ)⁻¹ • r a))
      (w, k) = sectorVector a.card a w * f k := by
  intro w k
  simp only [map_smul]
  change (Real.sqrt (multiplicity a.card a : ℝ) : ℂ)⁻¹ *
    circuit (fun _ => U) a.card 0 (initialized blank a.card (r a)) (w, k) = _
  rw [circuit_output_of_residuals blank U a r f hzero hstep a.card 0 a rfl le_rfl]
  by_cases hw : occupation w = a <;> simp [sectorVector, sectorWords, hw]

end CircuitOutput

section ResidualData

open D5.S1.Ledger.BoundedTimeSlice
open D5.S3.Quantum.Entanglement.SequentialRegisterCircuit
open D5.S3.Quantum.Entanglement.OccupancyWordSectors

variable {A : Type*} [Fintype A] [DecidableEq A]

/-- Replace only the head count; the tail occupation is unchanged. -/
def headSlice (head : A) (b : Multiset A) (h : ℕ) : Multiset A :=
  Multiset.replicate h head + b.filter (fun i => i ≠ head)

@[simp] theorem head_slice_count_head (head : A) (b : Multiset A) (h : ℕ) :
    (headSlice head b h).count head = h := by
  simp [headSlice, Multiset.count_filter]

theorem head_slice_count_tail (head : A) (b : Multiset A) (h : ℕ)
    (i : A) (hi : i ≠ head) : (headSlice head b h).count i = b.count i := by
  simp [headSlice, Multiset.count_filter, Multiset.count_replicate, hi, Ne.symm hi]

theorem head_slice_tail_count (head : A) (b : Multiset A) (h : ℕ) :
    tailCount head (headSlice head b h) = tailCount head b := by
  apply Finset.sum_congr rfl
  intro i _
  exact head_slice_count_tail head b h i.val i.property

theorem head_slice_card (head : A) (b : Multiset A) (h : ℕ) :
    (headSlice head b h).card = h + tailCount head b := by
  rw [← head_add_tail_count head, head_slice_count_head, head_slice_tail_count]

theorem head_slice_self (head : A) (b : Multiset A) :
    headSlice head b (b.count head) = b := by
  apply Multiset.ext.mpr
  intro i
  by_cases hi : i = head
  · subst i; exact head_slice_count_head head b _
  · exact head_slice_count_tail head b _ i hi

theorem head_slice_erase_head (head : A) (b : Multiset A) (h : ℕ) :
    (headSlice head b h).erase head = headSlice head b (h - 1) := by
  apply Multiset.ext.mpr
  intro i
  by_cases hi : i = head
  · subst i
    simp
  · rw [Multiset.count_erase_of_ne hi,
      head_slice_count_tail head b h i hi, head_slice_count_tail head b (h - 1) i hi]

theorem head_slice_erase_tail (head : A) (b : Multiset A) (h : ℕ)
    (i : A) (hi : i ≠ head) :
    (headSlice head b h).erase i = headSlice head (b.erase i) h := by
  apply Multiset.ext.mpr
  intro j
  by_cases hj : j = head
  · subst j
    rw [Multiset.count_erase_of_ne (Ne.symm hi)]
    simp
  · by_cases hji : j = i
    · subst j
      simp [head_slice_count_tail head _ _ i hi]
    · rw [Multiset.count_erase_of_ne hji,
        head_slice_count_tail head b h j hj,
        head_slice_count_tail head (b.erase i) h j hj,
        Multiset.count_erase_of_ne hji]

theorem head_slice_erase_head_source (head : A) (b : Multiset A) (h : ℕ) :
    headSlice head (b.erase head) h = headSlice head b h := by
  apply Multiset.ext.mpr
  intro i
  by_cases hi : i = head
  · subst i; simp
  · rw [head_slice_count_tail head _ _ i hi, head_slice_count_tail head _ _ i hi,
      Multiset.count_erase_of_ne hi]

theorem head_slice_le (head : A) (a b : Multiset A) (h : ℕ)
    (hb : b ≤ a) (hh : h ≤ a.count head) : headSlice head b h ≤ a := by
  apply Multiset.le_iff_count.mpr
  intro i
  by_cases hi : i = head
  · subst i; simpa using hh
  · rw [head_slice_count_tail head b h i hi]
    exact Multiset.le_iff_count.mp hb i

def residualTail (head : A) (a b : Multiset A) (hb : b ≤ a) :
    TailBox (fun i : TailAlphabet head => a.count i.val) :=
  fun i => ⟨b.count i.val, Nat.lt_succ_of_le (Multiset.le_iff_count.mp hb i.val)⟩

theorem residual_tail_sum (head : A) (a b : Multiset A) (hb : b ≤ a) :
    tailSum (residualTail head a b hb) = tailCount head b := rfl

def residualPositiveTail (head : A) (a b : Multiset A) (hb : b ≤ a)
    (hr : 0 < tailCount head b) : PositiveTail (fun i : TailAlphabet head => a.count i.val) :=
  ⟨residualTail head a b hb, by
    intro hz
    have hh := (tail_sum_eq_zero_iff _ _).mpr hz
    change tailCount head b = 0 at hh
    omega⟩

def residualHeadIndex (head : A) (a b : Multiset A) (hb : b ≤ a)
    (h : Fin (b.count head + 1)) : Fin (a.count head + 1) :=
  ⟨h.val, lt_of_lt_of_le h.isLt (Nat.add_le_add_right (Multiset.le_iff_count.mp hb head) 1)⟩

/-- Unnormalized residual amplitudes encode every possible last-tail position. -/
def paddingResidual (head : A) (a b : Multiset A) : Space (OccupationMemory a head) :=
  if hb : b ≤ a then
    if hr : 0 < tailCount head b then
      ∑ h : Fin (b.count head + 1),
        (Real.sqrt (lastTailMass head (headSlice head b h.val)) : ℂ) •
          basis (some (residualPositiveTail head a b hb hr, residualHeadIndex head a b hb h))
    else basis none
  else 0

theorem padding_residual_tail_free (head : A) (a b : Multiset A)
    (hb : b ≤ a) (hr : tailCount head b = 0) : paddingResidual head a b = basis none := by
  simp [paddingResidual, hb, hr]

theorem padding_residual_zero (head : A) (a : Multiset A) :
    paddingResidual head a 0 = basis none := by
  apply padding_residual_tail_free head a 0 (Multiset.zero_le _)
  simp [tailCount]

variable [Nonempty A]

def physicalResidual (a b : Multiset A) : Space (Fin (proposedDimension a)) :=
  coordinateEmbedding (physicalMemoryEquiv a).toEmbedding
    (paddingResidual (maximalHead a) a b)

theorem physical_residual_zero (a : Multiset A) :
    physicalResidual a 0 = physicalFinal a := by
  rw [physicalResidual, padding_residual_zero]
  exact coordinate_embedding_basis _ _

/-- Local transition relation for the residual vectors. -/
def ResidualStep (a : Multiset A) : Prop :=
  ∀ b, b ≤ a → b ≠ 0 → ∀ i k,
    physicalGate a (blankMemory (maximalHead a) (physicalResidual a b)) (i, k) =
      if i ∈ b then physicalResidual a (b.erase i) k else 0

theorem physical_residual_output (a : Multiset A) (hs : ResidualStep a) :
    ∀ w k, circuit (fun _ => physicalGate a) a.card 0
      (initialized (maximalHead a) a.card
        ((Real.sqrt (multiplicity a.card a : ℝ) : ℂ)⁻¹ • physicalResidual a a)) (w, k) =
      sectorVector a.card a w * physicalFinal a k :=
  normalized_output_of_residuals _ _ _ _ _ (physical_residual_zero a) hs

end ResidualData

section Sink

variable {A K : Type*} [Fintype A] [DecidableEq A] [Fintype K] [DecidableEq K]

theorem relabel_gate_sink {I : Type*} [Fintype I] [DecidableEq I]
    (H : ℕ) (c : I → ℕ) (eA : Option I ≃ A) (eK : PaddingMemory H c ≃ K) :
    relabelGate H c eA eK (basis (eA none, eK none)) = basis (eA none, eK none) := by
  ext q
  rcases q with ⟨i, k⟩
  obtain ⟨i, rfl⟩ := eA.surjective i
  rw [relabel_gate_coefficients]
  cases i <;>
    simp [relabelMatrix, weightedMatrix, relabelNext, relabelProbability,
      paddingNext, paddingProbability, basis_apply, Prod.mk.injEq, eA.injective.eq_iff, eq_comm]

theorem physical_gate_sink [Nonempty A] (a : Multiset A) :
    physicalGate a (basis (maximalHead a, physicalMemoryEquiv a none)) =
      basis (maximalHead a, physicalMemoryEquiv a none) :=
  relabel_gate_sink _ _ _ _

end Sink

section ResidualTransitions

open D5.S3.Quantum.Entanglement.SequentialRegisterCircuit
open D5.S3.Quantum.Entanglement.OccupancyWordSectors

variable {A : Type*} [Fintype A] [DecidableEq A]

theorem head_slice_head_amplitude (head : A) (b : Multiset A) (h : ℕ)
    (hh : 0 < h) (hr : 0 < tailCount head b) :
    (Real.sqrt (headProbability h (tailCount head b)) : ℂ) *
      (Real.sqrt (lastTailMass head (headSlice head b h)) : ℂ) =
      (Real.sqrt (lastTailMass head (headSlice head b (h - 1))) : ℂ) := by
  have hm : head ∈ headSlice head b h := by
    apply Multiset.count_pos.mp
    simpa using hh
  simpa only [head_slice_count_head, head_slice_tail_count, head_slice_erase_head] using
    last_tail_head_amplitude head (headSlice head b h) hm (by rwa [head_slice_tail_count])

theorem head_slice_tail_amplitude (head : A) (b : Multiset A) (h : ℕ) (i : A)
    (hi : i ≠ head) (hib : i ∈ b) (hr : 2 ≤ tailCount head b) :
    (Real.sqrt (tailProbability h (tailCount head b) (b.count i)) : ℂ) *
      (Real.sqrt (lastTailMass head (headSlice head b h)) : ℂ) =
      (Real.sqrt (lastTailMass head (headSlice head (b.erase i) h)) : ℂ) := by
  have hm : i ∈ headSlice head b h := by
    apply Multiset.count_pos.mp
    rw [head_slice_count_tail head b h i hi]
    exact Multiset.count_pos.mpr hib
  simpa only [head_slice_count_head, head_slice_tail_count,
    head_slice_count_tail head b h i hi, head_slice_erase_tail head b h i hi] using
    last_tail_tail_amplitude head (headSlice head b h) i hi hm
      (by rwa [head_slice_tail_count])

theorem head_slice_one_amplitude (head : A) (b : Multiset A) (h : ℕ)
    (hr : tailCount head b = 1) :
    (Real.sqrt (lastTailMass head (headSlice head b h)) : ℂ) = 1 := by
  rw [last_tail_mass_one head _ (by rwa [head_slice_tail_count])]
  simp

theorem tail_count_zero_iff (head : A) (b : Multiset A) :
    tailCount head b = 0 ↔ ∀ i, i ≠ head → b.count i = 0 := by
  simp only [tailCount, Finset.sum_eq_zero_iff, Finset.mem_univ, forall_true_left]
  constructor
  · intro h i hi
    exact h ⟨i, hi⟩
  · intro h i
    exact h i.val i.property

theorem tail_free_membership (head : A) (b : Multiset A)
    (hr : tailCount head b = 0) (hb : b ≠ 0) (i : A) : i ∈ b ↔ i = head := by
  have ht := (tail_count_zero_iff head b).mp hr
  constructor
  · intro hi
    by_contra hne
    exact (Multiset.count_pos.mpr hi).ne' (ht i hne)
  · intro hi
    subst i
    have hn : b.card ≠ 0 := fun hz => hb (Multiset.card_eq_zero.mp hz)
    have hs := head_add_tail_count head b
    apply Multiset.count_pos.mp
    omega

variable [Nonempty A]

theorem physical_residual_tail_free (a b : Multiset A) (hb : b ≤ a)
    (hr : tailCount (maximalHead a) b = 0) : physicalResidual a b = physicalFinal a := by
  rw [physicalResidual, padding_residual_tail_free _ _ _ hb hr]
  exact coordinate_embedding_basis _ _

theorem physical_residual_step_tail_free (a b : Multiset A)
    (hb : b ≤ a) (hb0 : b ≠ 0) (hr : tailCount (maximalHead a) b = 0) (i : A)
    (k : Fin (proposedDimension a)) :
    physicalGate a (blankMemory (maximalHead a) (physicalResidual a b)) (i, k) =
      if i ∈ b then physicalResidual a (b.erase i) k else 0 := by
  rw [physical_residual_tail_free a b hb hr]
  have he : blankMemory (maximalHead a) (physicalFinal a) =
      basis (maximalHead a, physicalMemoryEquiv a none) :=
    coordinate_embedding_basis _ _
  rw [he, physical_gate_sink]
  have hi := tail_free_membership (maximalHead a) b hr hb0 i
  by_cases hih : i = maximalHead a
  · subst i
    rw [if_pos (hi.mpr rfl)]
    rw [physical_residual_tail_free a (b.erase (maximalHead a))
      ((Multiset.erase_le _ _).trans hb) (by rwa [tail_count_erase_head])]
    simp [basis_apply, physicalFinal, Prod.mk.injEq]
  · rw [if_neg (fun hib => hih (hi.mp hib))]
    simp [basis_apply, Prod.mk.injEq, hih]

end ResidualTransitions

section Normalization

open D5.S3.Quantum.Entanglement.SequentialRegisterCircuit
open D5.S3.Quantum.Entanglement.OccupancyWordSectors

variable {A K : Type*} [Fintype A] [DecidableEq A] [Fintype K] [DecidableEq K]

theorem sector_space_norm (a : Multiset A) :
    ‖(WithLp.toLp 2 (sectorVector a.card a) : Space (Word A a.card))‖ = 1 := by
  let s : Space (Word A a.card) := WithLp.toLp 2 (sectorVector a.card a)
  have hi : inner ℂ s s = 1 := by
    rw [EuclideanSpace.inner_eq_star_dotProduct]
    change (∑ w, sectorVector a.card a w * star (sectorVector a.card a w)) = 1
    simpa only [if_pos rfl, ite_true, mul_comm] using sector_gram a a rfl
  have hs : ‖s‖ ^ 2 = 1 := by
    calc
      ‖s‖ ^ 2 = Complex.re (inner ℂ s s) := (inner_self_eq_norm_sq (𝕜 := ℂ) s).symm
      _ = 1 := by rw [hi]; rfl
  change ‖s‖ = 1
  nlinarith [norm_nonneg s]

/-- For an actual unitary circuit, the exact normalized output also proves the
normalization of its initial memory. -/
theorem initial_norm_of_sector_output (a : Multiset A) (blank : A)
    (U : Unitary (A × K)) (x : Space K) (sink : K)
    (hout : ∀ w k, circuit (fun _ => U) a.card 0 (initialized blank a.card x) (w, k) =
      sectorVector a.card a w * basis sink k) : ‖x‖ = 1 := by
  let e : Word A a.card ↪ Register A K a.card :=
    ⟨fun w => (w, sink), fun _ _ he => congrArg Prod.fst he⟩
  let s : Space (Word A a.card) := WithLp.toLp 2 (sectorVector a.card a)
  have heq : circuit (fun _ => U) a.card 0 (initialized blank a.card x) =
      coordinateEmbedding e s := by
    ext q
    rcases q with ⟨w, k⟩
    rw [hout]
    by_cases hk : k = sink
    · subst k
      change sectorVector a.card a w * basis sink sink = coordinateEmbedding e s (e w)
      rw [coordinate_embedding_apply]
      simp [s]
    · rw [coordinate_embedding_off_range e s (w, k) (by
        rintro ⟨v, hv⟩
        exact hk (congrArg Prod.snd hv).symm)]
      simp [basis_apply, hk]
  have hn := congrArg norm heq
  simp only [LinearIsometryEquiv.norm_map, LinearIsometry.norm_map] at hn
  exact hn.trans (sector_space_norm a)

variable [Nonempty A]

theorem target_of_residual_step (a : Multiset A) (hs : ResidualStep a) : Target a := by
  let x : Space (Fin (proposedDimension a)) :=
    (Real.sqrt (multiplicity a.card a : ℝ) : ℂ)⁻¹ • physicalResidual a a
  have ho := physical_residual_output a hs
  have hx : ‖x‖ = 1 := initial_norm_of_sector_output a (maximalHead a) (physicalGate a)
    x (physicalMemoryEquiv a none) ho
  exact ⟨maximalHead a, physicalGate a, x, physicalFinal a,
    hx, physical_final_norm a, ho⟩

end Normalization

end D5.S3.Quantum.Entanglement.StationaryOccupationResidualCircuit
