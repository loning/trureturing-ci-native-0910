/- GID: D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation
   generality: G
   mirror-B: D5/B/S3/Quantum/Entanglement/OccupationPhysicalPreparation
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Fixed-register occupation circuits attain the necessary pure-memory dimension. -/

import D5.S3.Quantum.Entanglement.SequentialRegisterCircuit

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section
open scoped BigOperators

namespace D5.S3.Quantum.Entanglement.OccupationPhysicalPreparation

open D5.S3.Quantum.Entanglement.SequentialRegisterCircuit

open D5.S3.Quantum.Entanglement.OccupancyWordSectors
open D5.S3.Quantum.Entanglement.CoherentHistorySchmidt
open D5.S3.Quantum.Entanglement.SequentialOccupationHistory

variable {A : Type*} [DecidableEq A]

theorem boundary_card_le_maximum (a : Multiset A) (t : Nat) (ht : t ≤ a.card) :
    Fintype.card (Boundary a t) ≤ boundaryMaximum a := by
  rw [Fintype.card_coe]
  exact Finset.le_sup (s := Finset.range (a.card + 1))
    (f := fun k => (boundaries a k).card) (by simpa using Nat.lt_succ_of_le ht)

def boundaryEmbedding (a : Multiset A) (t : Nat) (ht : t ≤ a.card) :
    Boundary a t ↪ Fin (boundaryMaximum a) :=
  Classical.choice (Function.Embedding.nonempty_of_card_le
    (by simpa using boundary_card_le_maximum a t ht))

variable [Fintype A]

theorem fixed_register_next_step_coefficients
    {K : Type*} [Fintype K] [DecidableEq K]
    (blank : A) (a : Multiset A) (t : Nat) (ht : t < a.card)
    (e : Boundary a t ↪ K) (f : Boundary a (t + 1) ↪ K) :
    ∃ U : EuclideanSpace Complex (A × K) ≃ₗᵢ[Complex] EuclideanSpace Complex (A × K),
      (∀ x, U (coordinateEmbedding (blankInjection blank e) x) =
        coordinateEmbedding (outputInjection f)
          (Matrix.toEuclideanLin (nextStep a t) x)) ∧
      (∀ b i c, U (EuclideanSpace.basisFun (A × K) Complex (blank, e b)) (i, f c) =
        nextStep a t (i, c) b) ∧
      (∀ b i k, k ∉ Set.range f →
        U (EuclideanSpace.basisFun (A × K) Complex (blank, e b)) (i, k) = 0) := by
  let V := matrixIsometry (nextStep a t) (next_step_gram ht)
  obtain ⟨U, hU, hc, hz⟩ := rectangular_unitary_coefficients blank e f V
  refine ⟨U, hU, ?_, ?_⟩
  · intro b i c
    have h := hc (EuclideanSpace.basisFun (Boundary a t) Complex b) i c
    rw [coordinate_embedding_basis] at h
    exact h.trans (matrix_isometry_basis (nextStep a t) (next_step_gram ht) b (i, c))
  · intro b i k hk
    have h := hz (EuclideanSpace.basisFun (Boundary a t) Complex b) i k hk
    rw [coordinate_embedding_basis] at h
    exact h

def occupationUnitary (blank : A) (a : Multiset A) (t : Fin a.card) :
    EuclideanSpace Complex (A × Fin (boundaryMaximum a)) ≃ₗᵢ[Complex]
      EuclideanSpace Complex (A × Fin (boundaryMaximum a)) :=
  Classical.choose (fixed_register_next_step_coefficients blank a t t.isLt
    (boundaryEmbedding a t (Nat.le_of_lt t.isLt))
    (boundaryEmbedding a (t + 1) (Nat.succ_le_of_lt t.isLt)))

theorem occupation_unitary_agrees (blank : A) (a : Multiset A) (t : Fin a.card) :
    (∀ x, occupationUnitary blank a t
      (coordinateEmbedding (blankInjection blank
        (boundaryEmbedding a t (Nat.le_of_lt t.isLt))) x) =
      coordinateEmbedding (outputInjection
        (boundaryEmbedding a (t + 1) (Nat.succ_le_of_lt t.isLt)))
        (Matrix.toEuclideanLin (nextStep a t) x)) ∧
    (∀ b i c, occupationUnitary blank a t
      (EuclideanSpace.basisFun (A × Fin (boundaryMaximum a)) Complex
        (blank, boundaryEmbedding a t (Nat.le_of_lt t.isLt) b))
      (i, boundaryEmbedding a (t + 1) (Nat.succ_le_of_lt t.isLt) c) =
      nextStep a t (i, c) b) ∧
    (∀ b i k, k ∉ Set.range (boundaryEmbedding a (t + 1) (Nat.succ_le_of_lt t.isLt)) →
      occupationUnitary blank a t
        (EuclideanSpace.basisFun (A × Fin (boundaryMaximum a)) Complex
          (blank, boundaryEmbedding a t (Nat.le_of_lt t.isLt) b)) (i, k) = 0) :=
  Classical.choose_spec (fixed_register_next_step_coefficients blank a t t.isLt
    (boundaryEmbedding a t (Nat.le_of_lt t.isLt))
    (boundaryEmbedding a (t + 1) (Nat.succ_le_of_lt t.isLt)))

theorem fixed_register_steps (blank : A) (a : Multiset A) :
    ∃ e : (t : Fin (a.card + 1)) → Boundary a t ↪ Fin (boundaryMaximum a),
    ∃ U : Fin a.card →
      (EuclideanSpace Complex (A × Fin (boundaryMaximum a)) ≃ₗᵢ[Complex]
        EuclideanSpace Complex (A × Fin (boundaryMaximum a))),
    ∀ (t : Fin a.card) b i c,
      U t (EuclideanSpace.basisFun (A × Fin (boundaryMaximum a)) Complex
        (blank, e t.castSucc b)) (i, e t.succ c) = nextStep a t (i, c) b := by
  refine ⟨fun t => boundaryEmbedding a t (Nat.lt_succ_iff.mp t.isLt),
    occupationUnitary blank a, ?_⟩
  intro t b i c
  exact (occupation_unitary_agrees blank a t).2.1 b i c

theorem fixed_register_5040_steps :
    ∃ e : (t : Fin 9) → Boundary occupation5040 t ↪ Fin 12,
    ∃ U : Fin 8 →
      (EuclideanSpace Complex (Option (Fin 3) × Fin 12) ≃ₗᵢ[Complex]
        EuclideanSpace Complex (Option (Fin 3) × Fin 12)),
    ∀ (t : Fin 8) b i c,
      U t (EuclideanSpace.basisFun (Option (Fin 3) × Fin 12) Complex
        (none, e t.castSucc b)) (i, e t.succ c) = nextStep occupation5040 t (i, c) b := by
  let e : (t : Fin 9) → Boundary occupation5040 t ↪ Fin 12 := fun t =>
    Classical.choice (Function.Embedding.nonempty_of_card_le (by
      simpa [occupation_5040_boundary_maximum] using
        boundary_card_le_maximum occupation5040 t (by rw [occupation_5040_card]; omega)))
  have h (t : Fin 8) := fixed_register_next_step_coefficients none occupation5040 t
    (by rw [occupation_5040_card]; exact t.isLt) (e t.castSucc) (e t.succ)
  choose U hU using h
  exact ⟨e, U, fun t => (hU t).2.1⟩


end D5.S3.Quantum.Entanglement.OccupationPhysicalPreparation

namespace D5.S3.Quantum.Entanglement.OccupationPhysicalPreparation

open D5.S3.Quantum.Entanglement.SequentialRegisterCircuit

open D5.S3.Quantum.Entanglement.OccupancyWordSectors
open D5.S3.Quantum.Entanglement.CoherentHistorySchmidt
open D5.S3.Quantum.Entanglement.SequentialOccupationHistory

variable {A : Type*} [Fintype A] [DecidableEq A]

def terminalBoundary (a : Multiset A) : Boundary a a.card :=
  ⟨a, by simp [boundaries]⟩

omit [Fintype A] in
theorem boundary_terminal_unique (a : Multiset A) (b : Boundary a a.card) :
    b = terminalBoundary a := by
  apply Subtype.ext
  exact Multiset.eq_of_le_of_card_le (boundary_spec a a.card b).1
    (boundary_spec a a.card b).2.ge

def terminalMemory (a : Multiset A) : Fin (boundaryMaximum a) :=
  boundaryEmbedding a a.card le_rfl (terminalBoundary a)

def occupationGates (blank : A) (a : Multiset A) (t : Nat) :
    Unitary (A × Fin (boundaryMaximum a)) :=
  if h : t < a.card then occupationUnitary blank a ⟨t, h⟩ else .refl _ _

theorem occupation_gate_sum (blank : A) (a : Multiset A) (t : Nat) (ht : t < a.card)
    (b : Boundary a t) (i : A) (v : Fin (boundaryMaximum a) → Complex) :
    (∑ k, occupationGates blank a t
      (basis (blank, boundaryEmbedding a t ht.le b)) (i, k) * v k) =
    ∑ c : Boundary a (t + 1), nextStep a t (i, c) b *
      v (boundaryEmbedding a (t + 1) (Nat.succ_le_of_lt ht) c) := by
  let e := boundaryEmbedding a (t + 1) (Nat.succ_le_of_lt ht)
  apply (Fintype.sum_of_injective e e.injective _ _ ?_ ?_).symm
  · intro k hk
    have hz := (occupation_unitary_agrees blank a ⟨t, ht⟩).2.2 b i k hk
    simp only [occupationGates, dif_pos ht, basis, hz, zero_mul]
  · intro c
    have hc := (occupation_unitary_agrees blank a ⟨t, ht⟩).2.1 b i c
    simp only [occupationGates, dif_pos ht, basis, hc, e]

theorem occupation_circuit_coefficients (blank : A) (a : Multiset A)
    (n t : Nat) (h : a.card = t + n) (b : Boundary a t)
    (w : Fin n → A) (k : Fin (boundaryMaximum a)) :
    circuit (occupationGates blank a) n t
      (blankState blank n (boundaryEmbedding a t (by omega) b)) (w, k) =
      contraction a n t w b * (if k = terminalMemory a then 1 else 0) := by
  induction n generalizing t with
  | zero =>
    have ht : t = a.card := by omega
    subst t
    have hb := boundary_terminal_unique a b
    have hw : w = (fun _ => blank) := Subsingleton.elim _ _
    simp [circuit, blankState, basis_apply, contraction, hb, hw,
      terminalMemory, terminalBoundary]
    rfl
  | succ n ih =>
    have ht : t < a.card := by omega
    rw [circuit_blank_succ, occupation_gate_sum blank a t ht]
    simp_rw [ih (t + 1) (by omega)]
    simp only [contraction, Finset.sum_mul, mul_assoc]

theorem fixed_register_sufficiency (blank : A) (a : Multiset A) :
    let initial := blankState blank a.card
      (boundaryEmbedding a 0 (Nat.zero_le _) (initialBoundary a))
    let output := circuit (occupationGates blank a) a.card 0 initial
    ‖initial‖ = 1 ∧ ‖output‖ = 1 ∧
      ∀ (w : Fin a.card → A) (k : Fin (boundaryMaximum a)),
        output (w, k) = sectorVector a.card a w *
          (if k = terminalMemory a then 1 else 0) := by
  dsimp only
  refine ⟨blank_state_norm _ _ _, circuit_blank_norm _ _ _ _ _, ?_⟩
  intro w k
  rw [occupation_circuit_coefficients blank a a.card 0 (by omega),
    history_sequential_preparation]

omit [Fintype A] in
private theorem boundary_range_congr (a : Multiset A) (r s : Nat)
    (hr : r ≤ a.card) (hs : s ≤ a.card) (h : r = s) :
    Set.range (boundaryEmbedding a r hr) = Set.range (boundaryEmbedding a s hs) := by
  subst s
  rfl

theorem occupation_reachable_memory (blank : A) (a : Multiset A)
    (n m t : Nat) (hm : m ≤ n) (ht : t + m ≤ a.card) (b : Boundary a t)
    (w : Fin n → A) (k : Fin (boundaryMaximum a))
    (hk : k ∉ Set.range (boundaryEmbedding a (t + m) ht)) :
    partialCircuit (occupationGates blank a) n m t
      (blankState blank n (boundaryEmbedding a t (by omega) b)) (w, k) = 0 := by
  induction m generalizing n t with
  | zero =>
    have hkb : k ≠ boundaryEmbedding a t (by omega) b := by
      intro h
      exact hk ⟨b, h.symm⟩
    cases n <;> simp [partialCircuit, blankState, basis_apply, Prod.mk.injEq, hkb]
  | succ m ih =>
    cases n with
    | zero => omega
    | succ n =>
      have ht' : t < a.card := by omega
      rw [partial_circuit_blank_succ, occupation_gate_sum blank a t ht']
      apply Finset.sum_eq_zero
      intro c _
      have hk' : k ∉ Set.range (boundaryEmbedding a (t + 1 + m) (by omega)) := by
        have he : t + 1 + m = t + (m + 1) := by omega
        rw [boundary_range_congr a _ _ _ ht he]
        exact hk
      rw [ih n (t + 1) (by omega) (by omega) c (Fin.tail w) hk', mul_zero]

theorem zero_length_sufficiency :
    let k0 := terminalMemory (0 : Multiset A)
    let initial : Space (Register A (Fin (boundaryMaximum (0 : Multiset A))) 0) :=
      basis (Fin.elim0, k0)
    let U : Nat → Unitary (A × Fin (boundaryMaximum (0 : Multiset A))) := fun _ => .refl _ _
    ‖initial‖ = 1 ∧ ‖circuit U 0 0 initial‖ = 1 ∧
      ∀ (w : Fin 0 → A) (k : Fin (boundaryMaximum (0 : Multiset A))),
        circuit U 0 0 initial (w, k) = sectorVector 0 0 w *
          (if k = k0 then 1 else 0) := by
  dsimp only
  have hn := (EuclideanSpace.basisFun
    (Register A (Fin (boundaryMaximum (0 : Multiset A))) 0) Complex).norm_eq_one
      (Fin.elim0, terminalMemory (0 : Multiset A))
  refine ⟨hn, hn, ?_⟩
  intro w k
  have hw : w = Fin.elim0 := Subsingleton.elim _ _
  have he : (Fin.elim0 : Fin 0 → A) = default := Subsingleton.elim _ _
  simp [circuit, basis_apply, Prod.mk.injEq, hw, sectorVector, sectorWords,
    occupation, D5.S3.Quantum.Entanglement.OccupancyWordSectors.multiplicity, he]

/-- The zero-length witness has an empty physical word and needs no alphabet symbol. -/
theorem fixed_register_sufficiency_all (a : Multiset A) :
    ∃ (slots : Fin a.card → A) (k0 kL : Fin (boundaryMaximum a))
      (U : Nat → Unitary (A × Fin (boundaryMaximum a))),
      (∀ i j, slots i = slots j) ∧
      ‖basis (slots, k0)‖ = 1 ∧ ‖circuit U a.card 0 (basis (slots, k0))‖ = 1 ∧
      ∀ (w : Fin a.card → A) (k : Fin (boundaryMaximum a)),
        circuit U a.card 0 (basis (slots, k0)) (w, k) = sectorVector a.card a w *
          (if k = kL then 1 else 0) := by
  by_cases ha : a = 0
  · subst a
    refine ⟨Fin.elim0, terminalMemory 0, terminalMemory 0, fun _ => .refl _ _, ?_, ?_⟩
    · intro i; exact Fin.elim0 i
    · exact zero_length_sufficiency
  · obtain ⟨blank, _⟩ := Multiset.exists_mem_of_ne_zero ha
    refine ⟨fun _ => blank, boundaryEmbedding a 0 (Nat.zero_le _) (initialBoundary a),
      terminalMemory a, occupationGates blank a, fun _ _ => rfl, ?_⟩
    exact fixed_register_sufficiency blank a

theorem fixed_register_sufficiency_dimensions (blank : A) (a : Multiset A)
    (n d : Nat) (hn : a.card = n) (hd : boundaryMaximum a = d) :
    ∃ (k0 kL : Fin d) (U : Nat → Unitary (A × Fin d)),
      ‖blankState blank n k0‖ = 1 ∧ ‖circuit U n 0 (blankState blank n k0)‖ = 1 ∧
      ∀ (w : Fin n → A) (k : Fin d),
        circuit U n 0 (blankState blank n k0) (w, k) = sectorVector n a w *
          (if k = kL then 1 else 0) := by
  subst n
  subst d
  exact ⟨boundaryEmbedding a 0 (Nat.zero_le _) (initialBoundary a),
    terminalMemory a, occupationGates blank a, fixed_register_sufficiency blank a⟩

theorem fixed_register_5040_sufficiency :
    ∃ (k0 kL : Fin 12) (U : Nat → Unitary (Option (Fin 3) × Fin 12)),
      ‖blankState (none : Option (Fin 3)) 8 k0‖ = 1 ∧
      ‖circuit U 8 0 (blankState none 8 k0)‖ = 1 ∧
      ∀ (w : Fin 8 → Option (Fin 3)) (k : Fin 12),
        circuit U 8 0 (blankState none 8 k0) (w, k) = sectorVector 8 occupation5040 w *
          (if k = kL then 1 else 0) :=
  fixed_register_sufficiency_dimensions none occupation5040 8 12
    occupation_5040_card occupation_5040_boundary_maximum

end D5.S3.Quantum.Entanglement.OccupationPhysicalPreparation

namespace D5.S3.Quantum.Entanglement.OccupationPhysicalPreparation

open D5.S3.Quantum.Entanglement.SequentialRegisterCircuit

open D5.S3.Quantum.Entanglement.OccupancyWordSectors
open D5.S3.Quantum.Entanglement.CoherentHistorySchmidt
open D5.S3.Quantum.Entanglement.SequentialOccupationHistory

variable {A K : Type*} [Fintype A] [Fintype K]

theorem unitary_chain_length (blank : A) (U : Nat → Unitary (A × K))
    (terminal : K) (n t : Nat) :
    (unitaryChain blank U terminal n t).length = n := by
  induction n generalizing t with
  | zero => rfl
  | succ n ih => simp only [unitaryChain, FiniteChain.length, ih]

theorem unitary_chain_bond_card (blank : A) (U : Nat → Unitary (A × K))
    (terminal : K) (n t r : Nat) (hr : r ≤ n) :
    Fintype.card ((unitaryChain blank U terminal n t).cutBond r) = Fintype.card K := by
  induction r generalizing n t with
  | zero => rfl
  | succ r ih =>
    cases n with
    | zero => omega
    | succ n =>
      calc
        _ = Fintype.card ((unitaryChain blank U terminal n (t + 1)).cutBond r) :=
          Fintype.card_congr (Equiv.refl _)
        _ = Fintype.card K := ih n (t + 1) (by omega)

omit [Fintype A] in
theorem constant_bond_maximum (c : FiniteChain A K)
    (hc : ∀ r, r ≤ c.length → Fintype.card (c.cutBond r) = Fintype.card K) :
    c.maximumBond = Fintype.card K := by
  unfold FiniteChain.maximumBond
  calc
    _ = (Finset.range (c.length + 1)).sup (fun _ => Fintype.card K) := by
      apply Finset.sup_congr rfl
      intro r hr
      exact hc r (by have := Finset.mem_range.mp hr; omega)
    _ = _ := Finset.sup_const ⟨0, by simp⟩ _

theorem unitary_chain_maximum_bond (blank : A) (U : Nat → Unitary (A × K))
    (terminal : K) (n t : Nat) :
    (unitaryChain blank U terminal n t).maximumBond = Fintype.card K := by
  apply constant_bond_maximum
  intro r hr
  rw [unitary_chain_length] at hr
  exact unitary_chain_bond_card blank U terminal n t r hr

omit [Fintype A] in
theorem amplitude_div_initial (c : FiniteChain A K) (initial : K → Complex)
    (z : Complex) {n : Nat} (w : Word A n) :
    c.amplitude (fun j => initial j / z) w = c.amplitude initial w / z := by
  simp only [FiniteChain.amplitude, div_mul_eq_mul_div, Finset.sum_div]

theorem normalized_coordinate_exists (y : Space K) (hy : ‖y‖ = 1) :
    ∃ k, y k ≠ 0 := by
  by_contra! h
  have hz : y = 0 := by ext k; exact h k
  simp [hz] at hy

open Classical in
/-- Initialization at an actual physical word, including the empty word. -/
def slotInitialized {n : Nat} (slots : Word A n) :
    Space K →ₗᵢ[Complex] Space (Register A K n) :=
  D5.S3.Quantum.Entanglement.SequentialRegisterCircuit.coordinateEmbedding
    (D5.S3.Quantum.Entanglement.SequentialRegisterCircuit.blankInjection
      slots (Function.Embedding.refl K))

theorem slot_initialized_apply {n : Nat} (slots : Word A n) (x : Space K) (k : K) :
    slotInitialized slots x (slots, k) = x k := by
  classical
  exact D5.S3.Quantum.Entanglement.SequentialRegisterCircuit.coordinate_embedding_apply _ x k

theorem slot_initialized_basis {n : Nat} (slots : Word A n) (k : K) :
    slotInitialized slots (basis k) = basis (slots, k) := by
  classical
  exact D5.S3.Quantum.Entanglement.SequentialRegisterCircuit.coordinate_embedding_basis _ k

theorem slot_initialized_constant (blank : A) (n : Nat) (x : Space K) :
    slotInitialized (fun _ : Fin n => blank) x = initialized blank n x := rfl

/-- Physical output determines the algebraic chain; the cap is a terminal coordinate. -/
theorem circuit_to_chain (n : Nat) (slots : Word A n)
    (hslots : ∀ i j, slots i = slots j)
    (U : Nat → Unitary (A × K)) (x y : Space K) (hy : ‖y‖ = 1)
    (psi : Word A n → Complex)
    (hout : ∀ w k, circuit U n 0 (slotInitialized slots x) (w, k) = psi w * y k) :
    ∃ (c : FiniteChain A K) (initial : K → Complex),
      c.length = n ∧
      (∀ r, r ≤ n → Fintype.card (c.cutBond r) = Fintype.card K) ∧
      (∀ w : Word A n, c.amplitude initial w = psi w) ∧
      c.maximumBond = Fintype.card K := by
  classical
  obtain ⟨k, hk⟩ := normalized_coordinate_exists y hy
  cases n with
  | zero =>
    let c : FiniteChain A K := .terminal (fun j => if j = k then 1 else 0)
    have hb (r : Nat) (hr : r ≤ 0) :
        Fintype.card (c.cutBond r) = Fintype.card K := by
      have he : r = 0 := by omega
      subst r
      rfl
    refine ⟨c, fun j => x j / y k, rfl, hb, ?_, constant_bond_maximum c hb⟩
    intro w
    have hw : w = slots := Subsingleton.elim _ _
    have ho : x k = psi w * y k := by
      have h := hout w k
      rw [hw] at h ⊢
      change slotInitialized slots x (slots, k) = psi slots * y k at h
      rw [slot_initialized_apply] at h
      exact h
    simp only [c, FiniteChain.amplitude, FiniteChain.contract, List.ofFn_zero,
      mul_ite, mul_one, mul_zero, Finset.sum_ite_eq', Finset.mem_univ, if_true]
    exact (div_eq_iff hk).mpr ho
  | succ n =>
    let blank := slots 0
    have hs : slots = (fun _ => blank) := funext (fun i => hslots i 0)
    let c := unitaryChain blank U k (n + 1) 0
    refine ⟨c, fun j => x j / y k, unitary_chain_length _ _ _ _ _,
      unitary_chain_bond_card _ _ _ _ _, ?_, unitary_chain_maximum_bond _ _ _ _ _⟩
    intro w
    rw [amplitude_div_initial]
    apply (div_eq_iff hk).mpr
    rw [← circuit_initialized_coefficients]
    simpa only [hs, slot_initialized_constant] using hout w k

variable [DecidableEq A]

/-- Membership describes actual normalized pure preparations, without a rank premise. -/
structure Preparation (a : Multiset A) (K : Type*) [Fintype K] where
  slots : Word A a.card
  slots_constant : ∀ i j, slots i = slots j
  initialMemory : Space K
  terminalMemory : Space K
  initial_norm : ‖initialMemory‖ = 1
  terminal_norm : ‖terminalMemory‖ = 1
  gates : Nat → Unitary (A × K)
  output_eq : ∀ w k,
    circuit gates a.card 0 (slotInitialized slots initialMemory) (w, k) =
      sectorVector a.card a w * terminalMemory k

theorem preparation_norms (a : Multiset A) (p : Preparation a K) :
    ‖slotInitialized p.slots p.initialMemory‖ = 1 ∧
    ‖circuit p.gates a.card 0 (slotInitialized p.slots p.initialMemory)‖ = 1 := by
  simp only [LinearIsometryEquiv.norm_map, LinearIsometry.norm_map, p.initial_norm, and_self]

theorem preparation_to_chain (a : Multiset A) (p : Preparation a K) :
    ∃ (c : FiniteChain A K) (initial : K → Complex),
      c.length = a.card ∧
      (∀ r, r ≤ a.card → Fintype.card (c.cutBond r) = Fintype.card K) ∧
      (∀ w : Word A a.card, c.amplitude initial w = sectorVector a.card a w) ∧
      c.maximumBond = Fintype.card K :=
  circuit_to_chain a.card p.slots p.slots_constant p.gates p.initialMemory
    p.terminalMemory p.terminal_norm (sectorVector a.card a) p.output_eq

theorem physical_memory_necessity (a : Multiset A) (p : Preparation a K) :
    boundaryMaximum a ≤ Fintype.card K := by
  obtain ⟨c, initial, hlen, _, hexact, hmax⟩ := preparation_to_chain a p
  rw [← hmax]
  exact maximum_bond_necessity c initial a hlen hexact

theorem physical_cut_necessity (a : Multiset A) (p : Preparation a K)
    (t : Nat) (ht : t ≤ a.card) :
    (coefficientMatrix a t (a.card - t)).rank = (boundaries a t).card ∧
      (boundaries a t).card ≤ Fintype.card K := by
  refine ⟨coefficient_rank (by omega), ?_⟩
  simpa only [Fintype.card_coe] using
    (D5.S3.Quantum.Entanglement.OccupationPhysicalPreparation.boundary_card_le_maximum
      a t ht).trans (physical_memory_necessity a p)

end D5.S3.Quantum.Entanglement.OccupationPhysicalPreparation

namespace D5.S3.Quantum.Entanglement.OccupationPhysicalPreparation

open D5.S3.Quantum.Entanglement.SequentialRegisterCircuit

open D5.S3.Quantum.Entanglement.OccupancyWordSectors
open D5.S3.Quantum.Entanglement.CoherentHistorySchmidt

variable {A K : Type*} [Fintype A] [DecidableEq A] [Fintype K]

/-- The set is defined by actual preparations on each finite complex dimension. -/
def achievablePhysicalMemories (a : Multiset A) : Set Nat :=
  {d | Nonempty (Preparation a (Fin d))}

theorem preparation_of_basis [DecidableEq K] (a : Multiset A) (slots : Word A a.card)
    (k0 kL : K) (U : Nat → Unitary (A × K))
    (hslots : ∀ i j, slots i = slots j)
    (hout : ∀ w k, circuit U a.card 0 (basis (slots, k0)) (w, k) =
      sectorVector a.card a w * (if k = kL then 1 else 0)) :
    Nonempty (Preparation a K) := by
  classical
  refine ⟨{
    slots := slots
    slots_constant := hslots
    initialMemory := basis k0
    terminalMemory := basis kL
    initial_norm := (EuclideanSpace.basisFun K Complex).norm_eq_one k0
    terminal_norm := (EuclideanSpace.basisFun K Complex).norm_eq_one kL
    gates := U
    output_eq := ?_ }⟩
  intro w k
  simpa only [slot_initialized_basis, basis_apply] using hout w k

theorem physical_attainment (a : Multiset A) :
    boundaryMaximum a ∈ achievablePhysicalMemories a := by
  obtain ⟨slots, k0, kL, U, hs, _, _, hout⟩ := fixed_register_sufficiency_all a
  exact preparation_of_basis a slots k0 kL U hs hout

theorem physical_memory_minimum (a : Multiset A) :
    IsLeast (achievablePhysicalMemories a) (boundaryMaximum a) := by
  refine ⟨physical_attainment a, ?_⟩
  intro d hd
  obtain ⟨p⟩ := hd
  simpa only [Fintype.card_fin] using physical_memory_necessity a p

theorem preparation_of_basis_dimensions (a : Multiset A) (n d : Nat)
    (hn : a.card = n) (blank : A) (k0 kL : Fin d)
    (U : Nat → Unitary (A × Fin d))
    (hout : ∀ (w : Word A n) k, circuit U n 0 (blankState blank n k0) (w, k) =
      sectorVector n a w * (if k = kL then 1 else 0)) :
    d ∈ achievablePhysicalMemories a := by
  subst n
  exact preparation_of_basis a (fun _ => blank) k0 kL U (fun _ _ => rfl) hout

/-- This companion uses the already compiled eight-slot, twelve-memory circuit. -/
theorem physical_5040_attainment :
    12 ∈ achievablePhysicalMemories occupation5040 := by
  obtain ⟨k0, kL, U, _, _, hout⟩ := fixed_register_5040_sufficiency
  exact preparation_of_basis_dimensions occupation5040 8 12 occupation_5040_card
    none k0 kL U hout

theorem physical_5040_memory_minimum :
    IsLeast (achievablePhysicalMemories occupation5040) 12 := by
  refine ⟨physical_5040_attainment, ?_⟩
  rw [← occupation_5040_boundary_maximum]
  exact (physical_memory_minimum occupation5040).2

end D5.S3.Quantum.Entanglement.OccupationPhysicalPreparation

namespace D5.S3.Quantum.Entanglement.OccupationPhysicalPreparation

open D5.S3.Quantum.Entanglement.SequentialRegisterCircuit

open D5.S3.Quantum.Entanglement.OccupancyWordSectors
open D5.S3.Quantum.Entanglement.CoherentHistorySchmidt
open D5.S3.Quantum.Entanglement.SequentialOccupationHistory

variable {A : Type*} [Fintype A] [DecidableEq A]

/-- A clause assembly from existing word sectors and the physical minimum. -/
theorem coherent_history_clause_assembly (a : Multiset A) (t s : Nat)
    (h : a.card = t + s) :
    (∀ (u : Word A t) (v : Word A s),
      sectorVector (t + s) a (Fin.append u v) = ∑ b : Boundary a t,
        (Real.sqrt ((∏ z : A, ((a.count z).choose (b.val.count z) : Real)) /
          ((t + s).choose t : Real)) : Complex) *
          sectorVector t b.val u * sectorVector s (a - b.val) v) ∧
    multiplicity (t + s) a = Nat.factorial (t + s) /
      ∏ z : A, Nat.factorial (a.count z) ∧
    (∑ w : Word A (t + s), star (sectorVector (t + s) a w) *
      sectorVector (t + s) a w = 1) ∧
    (∀ b : Boundary a t,
      multiplicity t b.val = Nat.factorial t / ∏ z : A, Nat.factorial (b.val.count z)) ∧
    (∀ b : Boundary a t,
      multiplicity s (a - b.val) = Nat.factorial s /
        ∏ z : A, Nat.factorial ((a - b.val).count z)) ∧
    (∀ b : Boundary a t,
      (multiplicity t b.val : Real) * multiplicity s (a - b.val) /
          multiplicity (t + s) a =
        (∏ z : A, ((a.count z).choose (b.val.count z) : Real)) /
          ((t + s).choose t : Real)) ∧
    (∀ b : Boundary a t, 0 < schmidtCoefficient a t s b) ∧
    (∀ b : Boundary a t,
      0 < (∏ z : A, ((a.count z).choose (b.val.count z) : Real)) /
        ((t + s).choose t : Real)) ∧
    (∀ b c : Boundary a t,
      (∑ u : Word A t, star (sectorVector t b.val u) * sectorVector t c.val u =
        if b = c then 1 else 0) ∧
      (∑ v : Word A s, star (sectorVector s (a - b.val) v) *
        sectorVector s (a - c.val) v = if b = c then 1 else 0)) ∧
    (coefficientMatrix a t s).rank = (boundaries a t).card ∧
    (Finset.range (a.card + 1)).sup
      (fun r => (coefficientMatrix a r (a.card - r)).rank) = boundaryMaximum a ∧
    IsLeast (achievableMaximumBonds a) (boundaryMaximum a) ∧
    IsLeast (achievablePhysicalMemories a) (boundaryMaximum a) := by
  refine ⟨?_, multiplicity_eq_factorial a h, ?_, ?_, ?_, ?_,
    schmidt_coefficient_pos h, ?_, cut_sector_gram h,
    coefficient_rank h, history_max_schmidt_rank a,
    minimum_maximum_bond_characterization a, physical_memory_minimum a⟩
  · intro u v
    rw [← coefficient_eq_uniform_word, normalized_coefficient_factorization h]
    simp_rw [schmidt_coefficient_eq_sqrt_binomial h]
  · simpa using sector_gram a a h
  · intro b
    exact multiplicity_eq_factorial b.val (boundary_spec a t b).2
  · intro b
    exact multiplicity_eq_factorial (a - b.val) (complement_card h b)
  · intro b
    rw [← schmidt_coefficient_sq]
    exact schmidt_coefficient_sq_binomial h b
  · intro b
    rw [← schmidt_coefficient_sq_binomial h b]
    exact sq_pos_of_pos (schmidt_coefficient_pos h b)

/-- The numerical values are transported from the existing boundary results. -/
theorem coherent_history_5040_clause_assembly :
    (List.range 9).map (fun t => (coefficientMatrix occupation5040 t (8 - t)).rank) =
      [1, 4, 8, 11, 12, 11, 8, 4, 1] ∧
    (Finset.range 9).sup (fun t => (coefficientMatrix occupation5040 t (8 - t)).rank) = 12 ∧
    (coefficientMatrix occupation5040 4 4).rank = 12 ∧
    IsLeast (achievableMaximumBonds occupation5040) 12 ∧
    IsLeast (achievablePhysicalMemories occupation5040) 12 :=
  ⟨history_5040_rank_sequence, history_5040_max_schmidt_rank.1,
    history_5040_max_schmidt_rank.2, history_5040_minimum_maximum_bond,
    physical_5040_memory_minimum⟩

end D5.S3.Quantum.Entanglement.OccupationPhysicalPreparation
