import Init

namespace LeanInformationAudit

/-- Publication metadata is bound by the elaborator. The kernel claim below
contains only ids; Name-level `ExactlyCovers` is not claimed from this certificate. -/
structure CensusKeyManifest where
  headSha : String
  reportSha256 : String
  censusRoot : Lean.Name
  keys : List Nat
  deriving Repr, Inhabited

/-- A chunk contains at most 100 base-2^256 digits, least significant id first.
The explicit arity preserves leading zero digits. The binder checks the domain,
arity and packed literal against each independent wire authority. -/
def decodeIds : Nat → Nat → List Nat
  | 0, _ => []
  | k + 1, value => value % 2 ^ 256 :: decodeIds k (value / 2 ^ 256)

theorem decodeIds_length (k value : Nat) : (decodeIds k value).length = k := by
  induction k generalizing value with
  | zero => rfl
  | succ k ih => exact congrArg Nat.succ (ih _)

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

/-- Accounting over the id set: linear adjacent comparisons, requested count,
and equality with independently emitted report ids. Names, hex spelling and
metadata remain elaborator obligations; this is not Name-level `ExactlyCovers`.
Never decide `List.Nodup` or Finset equality here (quadratic). -/
def CensusKeyManifest.Certificate (ids : List Nat) (requested : Nat)
    (reportIds : List Nat) : Prop :=
  strictlyAscending ids = true ∧ ids.length = requested ∧ ids = reportIds

end LeanInformationAudit
