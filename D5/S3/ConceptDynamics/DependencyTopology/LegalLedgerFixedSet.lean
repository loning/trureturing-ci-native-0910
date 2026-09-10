/- GID: D5/S3/ConceptDynamics/DependencyTopology/LegalLedgerFixedSet
   generality: G
   mirror-B: D5/B/S3/ConceptDynamics/DependencyTopology/LegalLedgerFixedSet
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Fixed membership of legal proof ledgers under witness-preserving extensions. -/

import D5.S3.ConceptDynamics.DependencyTopology.DependencyReachabilityOrder
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Sum.Order

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S3.ConceptDynamics.DependencyTopology.LegalLedgerFixedSet

open DependencyReachabilityOrder (AcyclicEdge)

universe u v w x

/-- The source kernel, finite readouts, permitted axioms and model semantics. -/
structure KernelData (P : Type u) (Proof : Type v) (Ax : Type w) (Model : Type x) where
  accept : Proof → P → Bool
  axioms : Proof → Finset Ax
  refs : Proof → Finset P
  permitted : Set Ax
  neg : P → P
  models : Model → Set Ax → Prop
  holds : Model → P → Prop

variable {P : Type u} {Proof : Type v} {Ax : Type w} {Model : Type x}
variable (k : KernelData P Proof Ax Model)

/-- A permitted proof is accepted and uses only permitted axioms. -/
def Proved (p : P) : Prop :=
  ∃ π : Proof, k.accept π p = true ∧ ∀ a ∈ k.axioms π, a ∈ k.permitted

/-- A finite core with exact dependent witnesses and their acyclic reference graph. -/
structure CertifiedNodes where
  nodes : Finset P
  witness : {p // p ∈ nodes} → Proof
  accepted : ∀ p, k.accept (witness p) p.val = true
  allowed : ∀ p, ∀ a ∈ k.axioms (witness p), a ∈ k.permitted
  refsClosed : ∀ p, ∀ q ∈ k.refs (witness p), q ∈ nodes
  acyclic : AcyclicEdge (fun q p => ∃ hp : p ∈ nodes, q ∈ k.refs (witness ⟨p, hp⟩))

variable {k}

/-- Edges are the actual references of the selected witnesses. -/
def CertifiedNodes.edge (C : CertifiedNodes k) (q p : P) : Prop :=
  ∃ hp : p ∈ C.nodes, q ∈ k.refs (C.witness ⟨p, hp⟩)

/-- A certificate contains its certified proposition. -/
def Certificate (k : KernelData P Proof Ax Model) (p : P) :=
  {C : CertifiedNodes k // p ∈ C.nodes}

/-- A legal ledger has a certified core and an arbitrary disjoint registered frontier. -/
structure LegalLedger (k : KernelData P Proof Ax Model) where
  core : CertifiedNodes k
  frontier : Set P
  frontierDisjoint : ∀ p ∈ frontier, p ∉ core.nodes

/-- The source assumptions are premises, including soundness and consistency. -/
structure SourceLaws (k : KernelData P Proof Ax Model) : Prop where
  sound : ∀ p, Proved k p → ∀ M, k.models M k.permitted → k.holds M p
  certificates : ∀ p, Proved k p → Nonempty (Certificate k p)
  consistent : ∀ p, ¬ (Proved k p ∧ Proved k (k.neg p))

def Frozen (L : LegalLedger k) : Set P := {p | p ∈ L.core.nodes}

/-- Extensions retain nodes, derived edges, and the exact old witness at every old node. -/
def Extends (L L' : LegalLedger k) : Prop :=
  (∀ p, p ∈ L.core.nodes → p ∈ L'.core.nodes) ∧
  (∀ q p, L.core.edge q p → L'.core.edge q p) ∧
  (∀ p (h : p ∈ L.core.nodes) (h' : p ∈ L'.core.nodes),
    L'.core.witness ⟨p, h'⟩ = L.core.witness ⟨p, h⟩)

/-- Admissibility is required on every legal input to a total transformation. -/
def Admissible (T : LegalLedger k → LegalLedger k) : Prop := ∀ L, Extends L (T L)

def Fix (L : LegalLedger k) : Set P :=
  {p | ∀ T : LegalLedger k → LegalLedger k, Admissible T →
    (p ∈ Frozen L ↔ p ∈ Frozen (T L))}

private noncomputable def chosenWitness (A C : CertifiedNodes k) (p : P)
    (h : p ∈ A.nodes ∨ p ∈ C.nodes) : Proof := by
  classical
  exact if hp : p ∈ A.nodes then A.witness ⟨p, hp⟩
    else C.witness ⟨p, h.resolve_left hp⟩

private theorem chosen_acyclic (A C : CertifiedNodes k) :
    AcyclicEdge (fun q p => ∃ h : p ∈ A.nodes ∨ p ∈ C.nodes,
      q ∈ k.refs (chosenWitness A C p h)) := by
  classical
  let tag : P → P ⊕ P := fun p => if p ∈ A.nodes then Sum.inl p else Sum.inr p
  let r : (P ⊕ P) → (P ⊕ P) → Prop :=
    Sum.Lex (Relation.TransGen A.edge) (Relation.TransGen C.edge)
  let : Std.Irrefl (Relation.TransGen A.edge) := ⟨A.acyclic⟩
  let : Std.Irrefl (Relation.TransGen C.edge) := ⟨C.acyclic⟩
  have liftEdge : ∀ q p, (∃ h : p ∈ A.nodes ∨ p ∈ C.nodes,
      q ∈ k.refs (chosenWitness A C p h)) → r (tag q) (tag p) := by
    rintro q p ⟨h, href⟩
    by_cases hp : p ∈ A.nodes
    · have hrefA : q ∈ k.refs (A.witness ⟨p, hp⟩) := by
        simpa only [chosenWitness, dif_pos hp] using href
      have hq := A.refsClosed ⟨p, hp⟩ q hrefA
      simp only [tag, if_pos hp, if_pos hq]
      exact Sum.Lex.inl (Relation.TransGen.single ⟨hp, hrefA⟩)
    · have hrefC : q ∈ k.refs (C.witness ⟨p, h.resolve_left hp⟩) := by
        simpa only [chosenWitness, dif_neg hp] using href
      by_cases hq : q ∈ A.nodes
      · simp only [tag, if_neg hp, if_pos hq]
        exact Sum.Lex.sep q p
      · simp only [tag, if_neg hp, if_neg hq]
        exact Sum.Lex.inr (Relation.TransGen.single ⟨h.resolve_left hp, hrefC⟩)
  intro p hcycle
  have hc : Relation.TransGen r (tag p) (tag p) :=
    Relation.TransGen.lift tag liftEdge p p hcycle
  have hc' : r (tag p) (tag p) := by
    simpa only [Relation.transGen_eq_self] using hc
  exact irrefl (tag p) hc'

private noncomputable def appendCore (A C : CertifiedNodes k) : CertifiedNodes k := by
  classical
  refine {
    nodes := A.nodes ∪ C.nodes
    witness := fun p => chosenWitness A C p.val (Finset.mem_union.mp p.property)
    accepted := ?_
    allowed := ?_
    refsClosed := ?_
    acyclic := ?_ }
  · intro p
    by_cases hp : p.val ∈ A.nodes
    · simpa only [chosenWitness, dif_pos hp] using A.accepted ⟨p.val, hp⟩
    · simpa only [chosenWitness, dif_neg hp] using
        C.accepted ⟨p.val, (Finset.mem_union.mp p.property).resolve_left hp⟩
  · intro p a ha
    by_cases hp : p.val ∈ A.nodes
    · simp only [chosenWitness, dif_pos hp] at ha
      exact A.allowed ⟨p.val, hp⟩ a ha
    · simp only [chosenWitness, dif_neg hp] at ha
      exact C.allowed ⟨p.val, (Finset.mem_union.mp p.property).resolve_left hp⟩ a ha
  · intro p q hq
    by_cases hp : p.val ∈ A.nodes
    · simp only [chosenWitness, dif_pos hp] at hq
      exact Finset.mem_union_left _ (A.refsClosed ⟨p.val, hp⟩ q hq)
    · simp only [chosenWitness, dif_neg hp] at hq
      exact Finset.mem_union_right _
        (C.refsClosed ⟨p.val, (Finset.mem_union.mp p.property).resolve_left hp⟩ q hq)
  · intro p hcycle
    apply chosen_acyclic A C p
    apply Relation.TransGen.mono ?_ p p hcycle
    rintro q p ⟨hp, hq⟩
    exact ⟨Finset.mem_union.mp hp, hq⟩

/-- Append the certificate, preserving old witnesses on every overlap. -/
noncomputable def appendCertificate (L : LegalLedger k) (C : CertifiedNodes k) :
    LegalLedger k where
  core := appendCore L.core C
  frontier := L.frontier \ {p | p ∈ C.nodes}
  frontierDisjoint := by
    classical
    rintro p ⟨hp, hC⟩ hmem
    rcases Finset.mem_union.mp hmem with hA | hC'
    · exact L.frontierDisjoint p hp hA
    · exact hC hC'

private theorem appendCertificate_extends (L : LegalLedger k) (C : CertifiedNodes k) :
    Extends L (appendCertificate L C) := by
  classical
  refine ⟨fun p hp => Finset.mem_union_left _ hp, ?_, ?_⟩
  · rintro q p ⟨hp, hq⟩
    refine ⟨Finset.mem_union_left _ hp, ?_⟩
    simpa only [appendCertificate, appendCore, chosenWitness, dif_pos hp] using hq
  · intro p hp hp'
    simp only [appendCertificate, appendCore, chosenWitness, dif_pos hp]

/-- A total map: use the identity on inputs already containing the proposition. -/
noncomputable def addWithCertificate (p : P) (C : Certificate k p)
    (L : LegalLedger k) : LegalLedger k := by
  classical
  exact if p ∈ Frozen L then L else appendCertificate L C.val

/-- The concrete certificate map retains every old node, edge and witness. -/
theorem addWithCertificate_admissible (p : P) (C : Certificate k p) :
    Admissible (addWithCertificate p C) := by
  classical
  intro L
  by_cases hp : p ∈ Frozen L
  · simp only [addWithCertificate, if_pos hp]
    exact ⟨fun _ h => h, fun _ _ h => h, fun _ _ _ => rfl⟩
  · simpa only [addWithCertificate, if_neg hp] using appendCertificate_extends L C.val

private theorem frozen_proved (L : LegalLedger k) {p : P} (hp : p ∈ Frozen L) :
    Proved k p :=
  ⟨L.core.witness ⟨p, hp⟩, L.core.accepted ⟨p, hp⟩, L.core.allowed ⟨p, hp⟩⟩

/-- Under the source laws, fixed membership is exactly frozen or unprovable membership. -/
theorem fixed_eq_frozen_union_unprovable (laws : SourceLaws k) (L : LegalLedger k) :
    Fix L = Frozen L ∪ {p | ¬ Proved k p} := by
  classical
  ext p
  constructor
  · intro hfix
    by_cases hp : p ∈ Frozen L
    · exact Or.inl hp
    · right
      intro hproved
      obtain ⟨C⟩ := laws.certificates p hproved
      have hmem : p ∈ Frozen (addWithCertificate p C L) := by
        change p ∈ Frozen (if p ∈ Frozen L then L else appendCertificate L C.val)
        rw [if_neg hp]
        exact Finset.mem_union_right _ C.property
      exact hp ((hfix _ (addWithCertificate_admissible p C)).mpr hmem)
  · rintro (hf | hu) T hT
    · exact ⟨fun _ => (hT L).1 p hf, fun _ => hf⟩
    · exact ⟨fun h => (hu (frozen_proved L h)).elim,
        fun h => (hu (frozen_proved (T L) h)).elim⟩

end D5.S3.ConceptDynamics.DependencyTopology.LegalLedgerFixedSet
