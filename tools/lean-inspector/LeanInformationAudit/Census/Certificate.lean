import Init

namespace LeanInformationAudit

/-- The kernel identity retains the full structured Name and decoded 256-bit id. -/
structure CensusKeyManifest where
  headSha : String
  reportSha256 : String
  censusRoot : Lean.Name
  keys : List (Lean.Name × Nat)
  deriving Repr, Inhabited

/-- Exactly one Nat comparison per adjacent pair. -/
def strictlyAscending : List Nat → Bool
  | a :: b :: rest => decide (a < b) && strictlyAscending (b :: rest)
  | _ => true

private theorem ascending_head {a : Nat} {xs : List Nat}
    (h : strictlyAscending (a :: xs) = true) : ∀ b, b ∈ xs → a < b := by
  induction xs generalizing a with
  | nil => intro b hb; cases hb
  | cons c cs ih =>
    have step : a < c ∧ strictlyAscending (c :: cs) = true := by
      simpa only [strictlyAscending, Bool.and_eq_true, decide_eq_true_eq] using h
    intro b hb
    cases List.mem_cons.mp hb with
    | inl eq => subst b; exact step.1
    | inr hb => exact Nat.lt_trans step.1 (ih step.2 b hb)

theorem strictlyAscending_nodup (xs : List Nat)
    (h : strictlyAscending xs = true) : xs.Nodup := by
  induction xs with
  | nil => exact List.nodup_nil
  | cons a xs ih =>
    apply List.nodup_cons.mpr
    refine ⟨?_, ?_⟩
    · intro ha
      exact Nat.lt_irrefl a (ascending_head h a ha)
    · apply ih
      cases xs with
      | nil => rfl
      | cons b rest => exact (Bool.and_eq_true_iff.mp h).2

/-- The flat certificate binds metadata, ordering, and independently emitted full keys. -/
def CensusKeyManifest.Certificate (m : CensusKeyManifest) (head sha : String)
    (root : Lean.Name) (reportKeys : List (Lean.Name × Nat)) : Prop :=
  m.headSha = head ∧ m.reportSha256 = sha ∧ m.censusRoot = root ∧
    strictlyAscending (m.keys.map Prod.snd) = true ∧ m.keys = reportKeys

end LeanInformationAudit
