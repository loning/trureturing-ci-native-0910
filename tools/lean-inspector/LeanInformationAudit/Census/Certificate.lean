module

public import Init

public section

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
@[expose] def decodeIds : Nat → Nat → List Nat
  | 0, _ => []
  | k + 1, value => value % 2 ^ 256 :: decodeIds k (value / 2 ^ 256)

theorem decodeIds_length (k value : Nat) : (decodeIds k value).length = k := by
  induction k generalizing value with
  | zero => rfl
  | succ k ih => exact congrArg Nat.succ (ih _)

/-- Exactly one Nat comparison per adjacent pair. -/
@[expose] def strictlyAscending : List Nat → Bool
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
@[expose] def CensusKeyManifest.Certificate (ids : List Nat) (requested : Nat)
    (reportIds : List Nat) : Prop :=
  strictlyAscending ids = true ∧ ids.length = requested ∧ ids = reportIds

/-- The top `b` bits of a validated 256-bit id. -/
@[expose] def idPrefix (b id : Nat) : Nat := id / 2 ^ (256 - b)

@[expose] def inRange (k b : Nat) (ids : List Nat) : Bool :=
  ids.all (fun id => decide (idPrefix b id = k))

/-- One constructor per bucket, including empty buckets. Its indices ensure
that range order, the inventory lists, report lists and counts cannot drift. -/
inductive BucketCertificates (b : Nat) : Nat → List (List Nat) → List Nat → List (List Nat) → Prop
  | nil (k) : BucketCertificates b k [] [] []
  | cons {k inv rep n invs ns reps}
      (ascending : strictlyAscending inv = true) (range : inRange k b inv = true)
      (length : inv.length = n) (equality : inv = rep)
      (tail : BucketCertificates b (k + 1) invs ns reps) :
      BucketCertificates b k (inv :: invs) (n :: ns) (rep :: reps)

private theorem ascending_iff_pairwise (ids : List Nat) :
    strictlyAscending ids = true ↔ ids.Pairwise (· < ·) := by
  induction ids with
  | nil => simp [strictlyAscending]
  | cons a xs ih =>
    constructor
    · intro h
      refine List.pairwise_cons.mpr ⟨ascending_head h, ih.mp ?_⟩
      cases xs with
      | nil => rfl
      | cons c cs => exact (Bool.and_eq_true_iff.mp h).2
    · intro h
      cases xs with
      | nil => rfl
      | cons c cs =>
        have parts := List.pairwise_cons.mp h
        exact Bool.and_eq_true_iff.mpr ⟨decide_eq_true (parts.1 c (by simp)), ih.mpr parts.2⟩

private theorem range_prefix {k b : Nat} {ids : List Nat} (h : inRange k b ids = true)
    {id : Nat} (mem : id ∈ ids) : idPrefix b id = k :=
  of_decide_eq_true ((List.all_eq_true.mp h) id mem)

private theorem flatten_prefix_lower {b k invs ns reps}
    (h : BucketCertificates b k invs ns reps) :
    ∀ id ∈ invs.flatten, k ≤ idPrefix b id := by
  induction h with
  | nil => simp
  | @cons k inv rep n invs ns reps ordered range length equality tail ih =>
    intro id mem
    rcases List.mem_append.mp mem with mem | mem
    · exact Nat.le_of_eq (range_prefix range mem).symm
    · exact Nat.le_trans (Nat.le_succ k) (ih id mem)

/-- Join checked ranges without decoding or comparing any concrete ids. -/
theorem strictlyAscending_flatten_of_ranges {b k invs ns reps}
    (h : BucketCertificates b k invs ns reps) : strictlyAscending invs.flatten = true := by
  apply (ascending_iff_pairwise _).mpr
  induction h with
  | nil => exact List.Pairwise.nil
  | @cons k inv rep n invs ns reps ordered range length equality tail ih =>
    apply List.pairwise_append.mpr
    refine ⟨(ascending_iff_pairwise _).mp ordered, ih, ?_⟩
    intro x hx y hy
    have px := range_prefix range hx
    have py := flatten_prefix_lower tail y hy
    apply Nat.lt_of_not_ge
    intro hyx
    have le : idPrefix b y ≤ idPrefix b x := Nat.div_le_div_right hyx
    rw [px] at le
    exact Nat.not_succ_le_self k (Nat.le_trans py le)

/-- The generic list identity is in Init; only the per-bucket length equations
are substituted here. The assembly decides the sum of `N` count literals. -/
theorem length_flatten {b k invs ns reps} (h : BucketCertificates b k invs ns reps) :
    invs.flatten.length = ns.sum := by
  rw [List.length_flatten]
  induction h with
  | nil => rfl
  | cons ordered range length equality tail ih =>
    simp only [List.map_cons, List.sum_cons, length, ih]

theorem bucket_congruence {b k invs ns reps} (h : BucketCertificates b k invs ns reps) :
    invs = reps := by
  induction h with
  | nil => rfl
  | cons ordered range length equality tail ih => cases equality; cases ih; rfl

theorem certificate_of_buckets {b k invs ns reps requested}
    (h : BucketCertificates b k invs ns reps) (total : ns.sum = requested) :
    CensusKeyManifest.Certificate invs.flatten requested reps.flatten :=
  ⟨strictlyAscending_flatten_of_ranges h, (length_flatten h).trans total,
    congrArg List.flatten (bucket_congruence h)⟩

end LeanInformationAudit
