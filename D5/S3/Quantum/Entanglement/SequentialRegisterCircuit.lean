/- GID: D5/S3/Quantum/Entanglement/SequentialRegisterCircuit
   generality: G
   mirror-B: D5/B/S3/Quantum/Entanglement/SequentialRegisterCircuit
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Actual unitary slot composition and its general finite-chain coefficients. -/

import Mathlib.Analysis.InnerProductSpace.PiL2
import D5.S3.Quantum.Entanglement.SequentialOccupationHistory

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section
open scoped BigOperators

namespace D5.S3.Quantum.Entanglement.SequentialRegisterCircuit

theorem exists_unitary_agree
    {E H : Type*} [NormedAddCommGroup E] [InnerProductSpace Complex E]
    [NormedAddCommGroup H] [InnerProductSpace Complex H] [FiniteDimensional Complex H]
    (source target : E →ₗᵢ[Complex] H) :
    ∃ U : H ≃ₗᵢ[Complex] H, ∀ x, U (source x) = target x := by
  let onRange := target.comp source.equivRange.symm.toLinearIsometry
  let extended := onRange.extend
  have hsurj : Function.Surjective extended :=
    LinearMap.surjective_of_injective extended.injective
  refine ⟨LinearIsometryEquiv.ofSurjective extended hsurj, ?_⟩
  intro x
  change extended (source x) = target x
  have h := LinearIsometry.extend_apply onRange (source.equivRange x)
  simpa [onRange, extended] using h

def matrixIsometry {E F : Type*} [Fintype E] [Fintype F] [DecidableEq E]
    (M : Matrix F E Complex) (hM : M.conjTranspose * M = 1) :
    EuclideanSpace Complex E →ₗᵢ[Complex] EuclideanSpace Complex F :=
  M.toEuclideanLin.isometryOfInner (by
    intro x y
    simp only [EuclideanSpace.inner_eq_star_dotProduct]
    change M.mulVec y.ofLp ⬝ᵥ star (M.mulVec x.ofLp) = y.ofLp ⬝ᵥ star x.ofLp
    rw [dotProduct_comm (M.mulVec y.ofLp), Matrix.star_mulVec, Matrix.dotProduct_mulVec,
      Matrix.vecMul_vecMul, hM, Matrix.vecMul_one, dotProduct_comm])

def coordinateMatrix {E F : Type*} [DecidableEq F] (e : E ↪ F) : Matrix F E Complex :=
  fun y x => if e x = y then 1 else 0

theorem coordinate_gram {E F : Type*} [Fintype F]
    [DecidableEq E] [DecidableEq F] (e : E ↪ F) :
    (coordinateMatrix e).conjTranspose * coordinateMatrix e = 1 := by
  ext i j
  simp [coordinateMatrix, Matrix.mul_apply, Matrix.conjTranspose_apply,
    Matrix.one_apply, e.injective.eq_iff, eq_comm]

def coordinateEmbedding {E F : Type*} [Fintype E] [Fintype F]
    [DecidableEq E] [DecidableEq F] (e : E ↪ F) :
    EuclideanSpace Complex E →ₗᵢ[Complex] EuclideanSpace Complex F :=
  matrixIsometry (coordinateMatrix e) (coordinate_gram e)

theorem coordinate_embedding_apply {E F : Type*} [Fintype E] [Fintype F]
    [DecidableEq E] [DecidableEq F] (e : E ↪ F) (x : EuclideanSpace Complex E) (j : E) :
    coordinateEmbedding e x (e j) = x j := by
  simp [coordinateEmbedding, matrixIsometry, Matrix.toEuclideanLin, Matrix.toLpLin_apply,
    Matrix.mulVec, dotProduct, coordinateMatrix, e.injective.eq_iff]

theorem coordinate_embedding_off_range {E F : Type*} [Fintype E] [Fintype F]
    [DecidableEq E] [DecidableEq F] (e : E ↪ F) (x : EuclideanSpace Complex E)
    (j : F) (hj : j ∉ Set.range e) :
    coordinateEmbedding e x j = 0 := by
  have h (i : E) : e i ≠ j := fun hi => hj ⟨i, hi⟩
  simp [coordinateEmbedding, matrixIsometry, Matrix.toEuclideanLin, Matrix.toLpLin_apply,
    Matrix.mulVec, dotProduct, coordinateMatrix, h]

def blankInjection {A E K : Type*} (blank : A) (e : E ↪ K) : E ↪ A × K :=
  ⟨fun j => (blank, e j), fun _ _ h => e.injective (congrArg Prod.snd h)⟩

def outputInjection {A F K : Type*} (f : F ↪ K) : A × F ↪ A × K :=
  (Function.Embedding.refl A).prodMap f

theorem rectangular_unitary
    {A E F K : Type*} [Fintype A] [Fintype E] [Fintype F] [Fintype K]
    [DecidableEq A] [DecidableEq E] [DecidableEq F] [DecidableEq K]
    (blank : A) (e : E ↪ K) (f : F ↪ K)
    (V : EuclideanSpace Complex E →ₗᵢ[Complex] EuclideanSpace Complex (A × F)) :
    ∃ U : EuclideanSpace Complex (A × K) ≃ₗᵢ[Complex] EuclideanSpace Complex (A × K),
      ∀ x, U (coordinateEmbedding (blankInjection blank e) x) =
        coordinateEmbedding (outputInjection f) (V x) :=
  exists_unitary_agree (coordinateEmbedding (blankInjection blank e))
    ((coordinateEmbedding (outputInjection f)).comp V)

theorem rectangular_unitary_coefficients
    {A E F K : Type*} [Fintype A] [Fintype E] [Fintype F] [Fintype K]
    [DecidableEq A] [DecidableEq E] [DecidableEq F] [DecidableEq K]
    (blank : A) (e : E ↪ K) (f : F ↪ K)
    (V : EuclideanSpace Complex E →ₗᵢ[Complex] EuclideanSpace Complex (A × F)) :
    ∃ U : EuclideanSpace Complex (A × K) ≃ₗᵢ[Complex] EuclideanSpace Complex (A × K),
      (∀ x, U (coordinateEmbedding (blankInjection blank e) x) =
        coordinateEmbedding (outputInjection f) (V x)) ∧
      (∀ x i j, U (coordinateEmbedding (blankInjection blank e) x) (i, f j) = V x (i, j)) ∧
      (∀ x i k, k ∉ Set.range f →
        U (coordinateEmbedding (blankInjection blank e) x) (i, k) = 0) := by
  obtain ⟨U, hU⟩ := rectangular_unitary blank e f V
  refine ⟨U, hU, ?_, ?_⟩
  · intro x i j
    rw [hU]
    exact coordinate_embedding_apply (outputInjection f) (V x) (i, j)
  · intro x i k hk
    rw [hU]
    apply coordinate_embedding_off_range
    rintro ⟨p, hp⟩
    exact hk ⟨p.2, congrArg Prod.snd hp⟩

theorem matrix_isometry_basis {E F : Type*} [Fintype E] [Fintype F] [DecidableEq E]
    (M : Matrix F E Complex) (hM : M.conjTranspose * M = 1) (b : E) (q : F) :
    matrixIsometry M hM (EuclideanSpace.basisFun E Complex b) q = M q b := by
  simp [matrixIsometry, Matrix.toEuclideanLin, Matrix.toLpLin_apply,
    EuclideanSpace.basisFun_apply]

theorem coordinate_embedding_basis {E F : Type*} [Fintype E] [Fintype F]
    [DecidableEq E] [DecidableEq F] (e : E ↪ F) (b : E) :
    coordinateEmbedding e (EuclideanSpace.basisFun E Complex b) =
      EuclideanSpace.basisFun F Complex (e b) := by
  ext q
  rw [coordinateEmbedding, matrix_isometry_basis]
  simp [coordinateMatrix, EuclideanSpace.basisFun_apply, eq_comm]


end D5.S3.Quantum.Entanglement.SequentialRegisterCircuit

namespace D5.S3.Quantum.Entanglement.SequentialRegisterCircuit

abbrev Space (I : Type*) [Fintype I] := EuclideanSpace Complex I
abbrev Unitary (I : Type*) [Fintype I] := Space I ≃ₗᵢ[Complex] Space I

def curry (B C : Type*) [Fintype B] [Fintype C] :
    Space (B × C) ≃ₗᵢ[Complex] PiLp 2 (fun _ : B => Space C) :=
  (LinearIsometryEquiv.piLpCongrLeft 2 Complex Complex (Equiv.sigmaEquivProd B C).symm).trans
    (LinearIsometryEquiv.piLpCurry Complex 2 (fun (_ : B) (_ : C) => Complex))

def block {B C : Type*} [Fintype B] [Fintype C] (U : Unitary C) : Unitary (B × C) :=
  (curry B C).trans ((LinearIsometryEquiv.piLpCongrRight 2 (fun _ : B => U)).trans
    (curry B C).symm)

def lift {R B C : Type*} [Fintype R] [Fintype B] [Fintype C]
    (e : R ≃ B × C) (U : Unitary C) : Unitary R :=
  (LinearIsometryEquiv.piLpCongrLeft 2 Complex Complex e).trans
    ((block U).trans (LinearIsometryEquiv.piLpCongrLeft 2 Complex Complex e).symm)

theorem lift_apply {R B C : Type*} [Fintype R] [Fintype B] [Fintype C]
    (e : R ≃ B × C) (U : Unitary C) (x : Space R) (r : R) :
    lift e U x r = U (WithLp.toLp 2 (fun j => x (e.symm ((e r).1, j)))) (e r).2 := by
  simp only [lift, LinearIsometryEquiv.trans_apply,
    LinearIsometryEquiv.piLpCongrLeft_symm, LinearIsometryEquiv.piLpCongrLeft_apply,
    Equiv.piCongrLeft', Equiv.symm_symm]
  rfl

variable {A K : Type*} [Fintype A] [Fintype K]

abbrev Register (A K : Type*) (n : Nat) := (Fin n → A) × K

def headRest (n : Nat) : Register A K (n + 1) ≃ A × Register A K n :=
  ((Fin.consEquiv (fun _ : Fin (n + 1) => A)).symm.prodCongr (Equiv.refl K)).trans
    (Equiv.prodAssoc A (Fin n → A) K)

def restHead (n : Nat) : Register A K (n + 1) ≃ (Fin n → A) × (A × K) :=
  (headRest n).trans ((Equiv.prodAssoc A (Fin n → A) K).symm.trans
    (((Equiv.prodComm A (Fin n → A)).prodCongr (Equiv.refl K)).trans
      (Equiv.prodAssoc (Fin n → A) A K)))

def firstGate (n : Nat) (U : Unitary (A × K)) : Unitary (Register A K (n + 1)) :=
  lift (restHead n) U

def tailGate (n : Nat) (U : Unitary (Register A K n)) :
    Unitary (Register A K (n + 1)) := lift (headRest n) U

theorem first_gate_apply (n : Nat) (U : Unitary (A × K))
    (x : Space (Register A K (n + 1))) (w : Fin (n + 1) → A) (k : K) :
    firstGate n U x (w, k) =
      U (WithLp.toLp 2 (fun p => x (Fin.cons p.1 (Fin.tail w), p.2))) (w 0, k) := by
  rw [firstGate, lift_apply]
  rfl

theorem tail_gate_apply (n : Nat) (U : Unitary (Register A K n))
    (x : Space (Register A K (n + 1))) (w : Fin (n + 1) → A) (k : K) :
    tailGate n U x (w, k) =
      U (WithLp.toLp 2 (fun p => x (Fin.cons (w 0) p.1, p.2))) (Fin.tail w, k) := by
  rw [tailGate, lift_apply]
  rfl

/-- Operator composition, with one common memory and every physical slot retained. -/
def circuit (U : Nat → Unitary (A × K)) : (n t : Nat) → Unitary (Register A K n)
  | 0, _ => .refl _ _
  | n + 1, t => (firstGate n (U t)).trans (tailGate n (circuit U n (t + 1)))

def basis {I : Type*} [Fintype I] (i : I) : Space I := EuclideanSpace.basisFun I Complex i

@[simp] theorem basis_apply {I : Type*} [Fintype I] [DecidableEq I] (i j : I) :
    basis i j = if j = i then 1 else 0 := by
  simp [basis, EuclideanSpace.basisFun_apply, eq_comm]

def blankState (blank : A) (n : Nat) (k : K) : Space (Register A K n) :=
  basis (fun _ => blank, k)

theorem basis_expansion {I : Type*} [Fintype I] (x : Space I) :
    x = ∑ i, x i • basis i := (EuclideanSpace.basisFun I Complex).sum_repr x |>.symm

open Classical in
theorem first_gate_blank (blank : A) (n : Nat) (U : Unitary (A × K))
    (j k : K) (w : Fin (n + 1) → A) :
    firstGate n U (blankState blank (n + 1) j) (w, k) =
      if Fin.tail w = (fun _ => blank) then U (basis (blank, j)) (w 0, k) else 0 := by
  classical
  rw [first_gate_apply]
  have hc (i : A) (u : Fin n → A) :
      Fin.cons i u = (fun _ => blank) ↔ i = blank ∧ u = (fun _ => blank) := by
    simp [funext_iff, Fin.forall_fin_succ]
  have hs : (WithLp.toLp 2 (fun p : A × K =>
      blankState blank (n + 1) j (Fin.cons p.1 (Fin.tail w), p.2))) =
      if Fin.tail w = (fun _ => blank) then basis (blank, j) else 0 := by
    ext p
    rcases p with ⟨i, l⟩
    by_cases h : Fin.tail w = (fun _ => blank) <;>
      simp [h, blankState, basis_apply, Prod.mk.injEq, hc]
  rw [hs]
  split <;> simp_all

theorem first_tail_blank (blank : A) (n : Nat) (U : Unitary (A × K))
    (V : Unitary (Register A K n)) (j k : K) (w : Fin (n + 1) → A) :
    ((firstGate n U).trans (tailGate n V)) (blankState blank (n + 1) j) (w, k) =
      ∑ l : K, U (basis (blank, j)) (w 0, l) *
        V (blankState blank n l) (Fin.tail w, k) := by
  classical
  simp only [LinearIsometryEquiv.trans_apply, tail_gate_apply]
  have hs : (WithLp.toLp 2 (fun p : Register A K n =>
      firstGate n U (blankState blank (n + 1) j) (Fin.cons (w 0) p.1, p.2))) =
      ∑ l : K, U (basis (blank, j)) (w 0, l) • blankState blank n l := by
    ext p
    rcases p with ⟨u, l⟩
    simp only [first_gate_blank, Fin.tail_cons, Fin.cons_zero]
    by_cases h : u = (fun _ => blank) <;>
      simp [h, blankState, basis_apply, Prod.mk.injEq]
  rw [hs]
  simp [map_sum]

theorem circuit_blank_succ (blank : A) (U : Nat → Unitary (A × K))
    (n t : Nat) (j k : K) (w : Fin (n + 1) → A) :
    circuit U (n + 1) t (blankState blank (n + 1) j) (w, k) =
      ∑ l : K, U t (basis (blank, j)) (w 0, l) *
        circuit U n (t + 1) (blankState blank n l) (Fin.tail w, k) :=
  first_tail_blank blank n (U t) (circuit U n (t + 1)) j k w

/-- The same full register, stopped after m gates; unvisited slots are retained. -/
def partialCircuit (U : Nat → Unitary (A × K)) :
    (n m t : Nat) → Unitary (Register A K n)
  | 0, _, _ => .refl _ _
  | _ + 1, 0, _ => .refl _ _
  | n + 1, m + 1, t => (firstGate n (U t)).trans
      (tailGate n (partialCircuit U n m (t + 1)))

theorem partial_circuit_all (U : Nat → Unitary (A × K)) (n t : Nat) :
    partialCircuit U n n t = circuit U n t := by
  induction n generalizing t with
  | zero => rfl
  | succ n ih => simp only [partialCircuit, circuit, ih]

def slotGate (U : Unitary (A × K)) : (n : Nat) → Fin n → Unitary (Register A K n)
  | 0, r => Fin.elim0 r
  | n + 1, r => Fin.cases (firstGate n U) (fun q => tailGate n (slotGate U n q)) r

theorem slot_gate_apply (U : Unitary (A × K)) (n : Nat) (r : Fin n)
    (x : Space (Register A K n)) (w : Fin n → A) (k : K) :
    slotGate U n r x (w, k) = U (WithLp.toLp 2
      (fun p => x (Function.update w r p.1, p.2))) (w r, k) := by
  induction n with
  | zero => exact Fin.elim0 r
  | succ n ih =>
    refine Fin.cases ?_ (fun q => ?_) r
    · simp only [slotGate, Fin.cases_zero, first_gate_apply]
      have hc (i : A) : Fin.cons i (Fin.tail w) = Function.update w 0 i := by
        ext j
        refine Fin.cases ?_ (fun q => ?_) j <;> simp [Function.update, Fin.tail]
      simp_rw [hc]
    · simp only [slotGate, Fin.cases_succ, tail_gate_apply, ih]
      have hc (i : A) : Fin.cons (w 0) (Function.update (Fin.tail w) q i) =
          Function.update w q.succ i := by
        have hq : (0 : Fin (n + 1)) ≠ q.succ := by
          intro h
          have hh := congrArg Fin.val h
          change 0 = q.val + 1 at hh
          omega
        ext j
        refine Fin.cases ?_ (fun z => ?_) j <;>
          simp [Function.update, Fin.tail, hq]
      simp_rw [hc]
      rfl

theorem tail_gate_refl (n : Nat) :
    tailGate (A := A) (K := K) n (.refl _ _) = .refl _ _ := by
  ext x p
  rcases p with ⟨w, k⟩
  simp [tail_gate_apply, Fin.cons_self_tail]

theorem tail_gate_trans (n : Nat) (U V : Unitary (Register A K n)) :
    tailGate n (U.trans V) = (tailGate n U).trans (tailGate n V) := by
  ext x p
  rcases p with ⟨w, k⟩
  simp [tail_gate_apply]

theorem partial_circuit_zero (U : Nat → Unitary (A × K)) (n t : Nat) :
    partialCircuit U n 0 t = .refl _ _ := by cases n <;> rfl

/-- Each successor applies one local gate on the same full Hilbert space. -/
theorem partial_circuit_succ_gate (U : Nat → Unitary (A × K))
    (n m t : Nat) (hm : m < n) :
    partialCircuit U n (m + 1) t = (partialCircuit U n m t).trans
      (slotGate (U (t + m)) n ⟨m, hm⟩) := by
  induction n generalizing m t with
  | zero => omega
  | succ n ih =>
    cases m with
    | zero => simp [partialCircuit, slotGate, partial_circuit_zero, tail_gate_refl]
    | succ m =>
      have hi : (⟨m + 1, hm⟩ : Fin (n + 1)) = (⟨m, by omega⟩ : Fin n).succ := rfl
      simp only [partialCircuit, slotGate, hi, Fin.cases_succ]
      rw [ih m (t + 1) (by omega), tail_gate_trans]
      have he : t + 1 + m = t + (m + 1) := by omega
      rw [he]
      exact LinearIsometryEquiv.trans_assoc _ _ _

theorem partial_circuit_blank_succ (blank : A) (U : Nat → Unitary (A × K))
    (n m t : Nat) (j k : K) (w : Fin (n + 1) → A) :
    partialCircuit U (n + 1) (m + 1) t (blankState blank (n + 1) j) (w, k) =
      ∑ l : K, U t (basis (blank, j)) (w 0, l) *
        partialCircuit U n m (t + 1) (blankState blank n l) (Fin.tail w, k) :=
  first_tail_blank blank n (U t) (partialCircuit U n m (t + 1)) j k w

theorem unused_slots_zero (blank : A) (U : Nat → Unitary (A × K))
    (n m t : Nat) (j k : K) (w : Fin n → A) (r : Fin n)
    (hr : m ≤ r.val) (hw : w r ≠ blank) :
    partialCircuit U n m t (blankState blank n j) (w, k) = 0 := by
  classical
  induction n generalizing m t j with
  | zero => exact Fin.elim0 r
  | succ n ih =>
    cases m with
    | zero =>
      have hn : w ≠ (fun _ => blank) := fun h => hw (congrFun h r)
      simp [partialCircuit, blankState, basis_apply, Prod.mk.injEq, hn]
    | succ m =>
      rw [partial_circuit_blank_succ]
      apply Finset.sum_eq_zero
      intro l _
      have hp : 0 < r.val := by omega
      have hr0 : r ≠ 0 := by intro h; simp [h] at hp
      have hw' : Fin.tail w (r.pred hr0) ≠ blank := by
        change w (r.pred hr0).succ ≠ blank
        simpa using hw
      rw [ih m (t + 1) l (Fin.tail w) (r.pred hr0) (by simp; omega) hw', mul_zero]

open D5.S3.Quantum.Entanglement.SequentialOccupationHistory

open Classical in
def unitaryChain (blank : A) (U : Nat → Unitary (A × K)) (terminal : K) :
    (n t : Nat) → FiniteChain A K
  | 0, _ => .terminal (fun j => if j = terminal then 1 else 0)
  | n + 1, t => .step (fun i j k => U t (basis (blank, j)) (i, k))
      (unitaryChain blank U terminal n (t + 1))

theorem circuit_basis_coefficients (blank : A) (U : Nat → Unitary (A × K))
    (n t : Nat) (j k : K) (w : Fin n → A) :
    circuit U n t (blankState blank n j) (w, k) =
      (unitaryChain blank U k n t).contract (List.ofFn w) j := by
  classical
  induction n generalizing t j with
  | zero =>
    have hw : w = (fun _ => blank) := Subsingleton.elim _ _
    simp [circuit, blankState, basis_apply, unitaryChain, FiniteChain.contract, hw, eq_comm]
  | succ n ih =>
    have hw : List.ofFn w = w 0 :: List.ofFn (Fin.tail w) := by
      conv_lhs => rw [← Fin.cons_self_tail w]
      exact List.ofFn_cons _ _
    simp only [circuit_blank_succ, unitaryChain, hw, FiniteChain.contract]
    simp_rw [ih]

open Classical in
def initialized (blank : A) (n : Nat) : Space K →ₗᵢ[Complex] Space (Register A K n) :=
  D5.S3.Quantum.Entanglement.SequentialRegisterCircuit.coordinateEmbedding
    (D5.S3.Quantum.Entanglement.SequentialRegisterCircuit.blankInjection
      (fun _ : Fin n => blank) (Function.Embedding.refl K))

theorem initialize_basis (blank : A) (n : Nat) (j : K) :
    initialized blank n (basis j) = blankState blank n j := by
  classical
  exact D5.S3.Quantum.Entanglement.SequentialRegisterCircuit.coordinate_embedding_basis _ j

theorem circuit_initialized_coefficients (blank : A) (U : Nat → Unitary (A × K))
    (n t : Nat) (x : Space K) (w : Fin n → A) (k : K) :
    circuit U n t (initialized blank n x) (w, k) =
      (unitaryChain blank U k n t).amplitude x.ofLp w := by
  conv_lhs => rw [basis_expansion x]
  simp only [map_sum, map_smul, initialize_basis]
  simp [circuit_basis_coefficients, FiniteChain.amplitude]

theorem initialized_norm (blank : A) (U : Nat → Unitary (A × K))
    (n t : Nat) (x : Space K) (hx : ‖x‖ = 1) :
    ‖initialized blank n x‖ = 1 ∧ ‖circuit U n t (initialized blank n x)‖ = 1 := by
  simp only [LinearIsometryEquiv.norm_map, LinearIsometry.norm_map, hx, and_self]

theorem blank_state_norm (blank : A) (n : Nat) (k : K) :
    ‖blankState blank n k‖ = 1 := (EuclideanSpace.basisFun _ Complex).norm_eq_one _

theorem circuit_blank_norm (blank : A) (U : Nat → Unitary (A × K))
    (n t : Nat) (k : K) : ‖circuit U n t (blankState blank n k)‖ = 1 := by
  rw [LinearIsometryEquiv.norm_map, blank_state_norm]

end D5.S3.Quantum.Entanglement.SequentialRegisterCircuit
