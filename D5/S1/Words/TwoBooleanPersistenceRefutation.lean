/- GID: D5/S1/Words/TwoBooleanPersistenceRefutation
   generality: I
   mirror-B: D5/B/S1/Words/TwoBooleanPersistenceRefutation
   mirror-E: none(waiver:exact-finite-signed-permutation-refutation)
   anchors: []
   utility: kind=bounded-enumeration; basis=refutes=atom:9a5a16b3b4d71852121c8b2d9fdf137579ebf97b536c594833d16a20fa6b5216
   digest: The longest signed permutation in B2 is 2-boolean and globally contains 4321. -/

import Mathlib.Data.Fin.Rev

set_option autoImplicit false

namespace D5.S1.Words.TwoBooleanPersistenceRefutation

/-- A signed permutation on the ordered mirror carrier
`-n < ... < -1 < 1 < ... < n`, where negation is `Fin.rev`. -/
@[ext]
structure SignedPerm (n : Nat) where
  toEquiv : Equiv.Perm (Fin (2 * n))
  map_neg : forall i, toEquiv (Fin.rev i) = Fin.rev (toEquiv i)

private def SignedPerm.comp {n : Nat} (a b : SignedPerm n) : SignedPerm n where
  toEquiv := a.toEquiv.trans b.toEquiv
  map_neg := by
    intro i
    rw [Equiv.trans_apply, Equiv.trans_apply, a.map_neg, b.map_neg]

private def SignedPerm.one (n : Nat) : SignedPerm n where
  toEquiv := Equiv.refl _
  map_neg := by
    intro i
    rfl

/-- The two standard simple generators of `B_2`. -/
inductive Generator where
  | s0
  | s1

private instance generatorDecidableEq : DecidableEq Generator
  | .s0, .s0 => isTrue rfl
  | .s0, .s1 => isFalse (by intro h; cases h)
  | .s1, .s0 => isFalse (by intro h; cases h)
  | .s1, .s1 => isTrue rfl

/-- `s_0` changes the sign of the first window entry. -/
def simple0 : SignedPerm 2 where
  toEquiv := Equiv.swap (1 : Fin 4) (2 : Fin 4)
  map_neg := by decide

/-- `s_1` interchanges the two window entries and their negatives. -/
def simple1 : SignedPerm 2 where
  toEquiv := (Equiv.swap (0 : Fin 4) (1 : Fin 4)).trans
    (Equiv.swap (2 : Fin 4) (3 : Fin 4))
  map_neg := by decide

private def simple : Generator -> SignedPerm 2
  | .s0 => simple0
  | .s1 => simple1

/-- Evaluate a word in the two concrete simple generators. -/
def evalWord (word : List Generator) : SignedPerm 2 :=
  word.foldr (fun g acc => SignedPerm.comp (simple g) acc) (SignedPerm.one 2)

/-- A word is reduced when it evaluates to `w` and no word evaluating to `w`
is shorter. The comparison ranges over all words, not a stored table. -/
def IsReducedWord (word : List Generator) (w : SignedPerm 2) : Prop :=
  (forall i, (evalWord word).toEquiv i = w.toEquiv i) /\
    forall other,
      (forall i, (evalWord other).toEquiv i = w.toEquiv i) ->
        word.length <= other.length

/-- Every reduced decomposition uses each simple generator at most twice. -/
def TwoBoolean (w : SignedPerm 2) : Prop :=
  forall word, IsReducedWord word w -> forall g, word.count g <= 2

/-- The longest element of `B_2`, with window notation `(-1,-2)`. -/
def longest : SignedPerm 2 where
  toEquiv := Fin.revPerm
  map_neg := by
    intro i
    simp

private def alternating0 : List Generator := [.s0, .s1, .s0, .s1]
private def alternating1 : List Generator := [.s1, .s0, .s1, .s0]

private theorem short_target_words (word : List Generator) (hlen : word.length <= 4)
    (heval : forall i, (evalWord word).toEquiv i = longest.toEquiv i) :
    word = alternating0 \/ word = alternating1 := by
  cases word with
  | nil =>
      revert heval
      decide
  | cons g0 word =>
      cases word with
      | nil =>
          cases g0 <;> revert heval <;> decide
      | cons g1 word =>
          cases word with
          | nil =>
              cases g0 <;> cases g1 <;> revert heval <;> decide
          | cons g2 word =>
              cases word with
              | nil =>
                  cases g0 <;> cases g1 <;> cases g2 <;> revert heval <;> decide
              | cons g3 word =>
                  cases word with
                  | nil =>
                      cases g0 <;> cases g1 <;> cases g2 <;> cases g3 <;>
                        revert heval <;> decide
                  | cons g4 word =>
                      simp at hlen

private theorem target_word_length_ge_four (word : List Generator)
    (heval : forall i, (evalWord word).toEquiv i = longest.toEquiv i) :
    4 <= word.length := by
  by_contra hnot
  have hle : word.length <= 3 := Nat.le_of_lt_succ (Nat.lt_of_not_ge hnot)
  have hclass := short_target_words word (Nat.le_trans hle (by decide)) heval
  rcases hclass with h0 | h1
  · subst word
    simp [alternating0] at hle
  · subst word
    simp [alternating1] at hle

/-- The reduced words of the longest element are exactly the two alternating
words in the type-B generators. -/
theorem reduced_words_longest_iff (word : List Generator) :
    IsReducedWord word longest <->
      word = [.s0, .s1, .s0, .s1] \/ word = [.s1, .s0, .s1, .s0] := by
  change IsReducedWord word longest <-> word = alternating0 \/ word = alternating1
  constructor
  · intro h
    apply short_target_words word (h.2 alternating0 (by decide)) h.1
  · intro h
    constructor
    · rcases h with rfl | rfl <;> decide
    · intro other hother
      rcases h with rfl | rfl
      · simpa [alternating0] using target_word_length_ge_four other hother
      · simpa [alternating1] using target_word_length_ge_four other hother

/-- The longest element of `B_2` is 2-boolean. -/
theorem longest_twoBoolean : TwoBoolean longest := by
  intro word hword g
  rw [reduced_words_longest_iff] at hword
  rcases hword with rfl | rfl <;> cases g <;> decide

/-- The signed integer represented by a position in the ordered mirror carrier. -/
def mirrorValue {n : Nat} (i : Fin (2 * n)) : Int :=
  if i.1 < n then (i.1 : Int) - n else (i.1 - n + 1 : Nat)

/-- Evaluation of a signed permutation on a signed index. -/
def valueAt {n : Nat} (w : SignedPerm n) (i : Fin (2 * n)) : Int :=
  mirrorValue (w.toEquiv i)

private theorem valueAt_neg_size_two (w : SignedPerm 2) (i : Fin 4) :
    valueAt w (Fin.rev i) = -valueAt w i := by
  rw [valueAt, w.map_neg]
  exact (by decide : forall j : Fin 4,
    mirrorValue (n := 2) (Fin.rev j) = -mirrorValue (n := 2) j) _

private theorem concrete_action_tables :
    simple0.toEquiv 0 = 0 /\ simple0.toEquiv 1 = 2 /\
    simple0.toEquiv 2 = 1 /\ simple0.toEquiv 3 = 3 /\
    simple1.toEquiv 0 = 1 /\ simple1.toEquiv 1 = 0 /\
    simple1.toEquiv 2 = 3 /\ simple1.toEquiv 3 = 2 /\
    valueAt longest 0 = 2 /\ valueAt longest 1 = 1 /\
    valueAt longest 2 = -1 /\ valueAt longest 3 = -2 := by
  decide

/-- Two integer strings have the same relative order. -/
def OrderIsomorphic {k : Nat} (a b : Fin k -> Int) : Prop :=
  forall i j, a i < a j <-> b i < b j

private instance orderIsomorphicDecidable {k : Nat} (a b : Fin k -> Int) :
    Decidable (OrderIsomorphic a b) := by
  unfold OrderIsomorphic
  infer_instance

/-- Global containment from Levens--Lewis--Tenner Definition 2.4: the indices
may range over all positive and negative indices, in signed order. -/
def GloballyContains {n k : Nat} (w : SignedPerm n) (p : Fin k -> Int) : Prop :=
  exists indices : Fin k -> Fin (2 * n),
    (forall i j, i < j -> indices i < indices j) /\
      OrderIsomorphic (fun i => valueAt w (indices i)) p

/-- The unsigned pattern `3421`. -/
def pattern3421 (i : Fin 4) : Int :=
  match i.1 with
  | 0 => 3
  | 1 => 4
  | 2 => 2
  | _ => 1

/-- The unsigned pattern `4312`. -/
def pattern4312 (i : Fin 4) : Int :=
  match i.1 with
  | 0 => 4
  | 1 => 3
  | 2 => 1
  | _ => 2

/-- The unsigned pattern `4321`. -/
def pattern4321 (i : Fin 4) : Int := (4 : Int) - i.1

/-- The unsigned pattern `456123`. -/
def pattern456123 (i : Fin 6) : Int :=
  match i.1 with
  | 0 => 4
  | 1 => 5
  | 2 => 6
  | 3 => 1
  | 4 => 2
  | _ => 3

/-- Global avoidance of the four type-A forbidden patterns for 2-booleanity. -/
def AvoidsTwoBooleanPatterns (w : SignedPerm 2) : Prop :=
  Not (GloballyContains w pattern3421) /\
    Not (GloballyContains w pattern4312) /\
    Not (GloballyContains w pattern4321) /\
    Not (GloballyContains w pattern456123)

/-- On `-2 < -1 < 1 < 2`, the longest element has values
`2, 1, -1, -2`, so it globally contains `4321`. -/
theorem longest_globallyContains_4321 : GloballyContains longest pattern4321 := by
  exact ⟨fun i => i, by decide, by decide⟩

/-- The `B_2` longest element refutes persistence of the type-A avoidance
characterization: it is 2-boolean but globally contains forbidden `4321`. -/
theorem twoBoolean_persistence_refutation :
    exists w : SignedPerm 2, TwoBoolean w /\ GloballyContains w pattern4321 :=
  ⟨longest, longest_twoBoolean, longest_globallyContains_4321⟩

/-- Thus the type-B 2-boolean elements are not exactly the global avoiders of
the four patterns characterizing 2-boolean permutations in type A. -/
theorem twoBoolean_set_differs_from_global_avoiders :
    Not (forall w : SignedPerm 2, TwoBoolean w <-> AvoidsTwoBooleanPatterns w) := by
  intro h
  exact ((h longest).mp longest_twoBoolean).2.2.1 longest_globallyContains_4321

example : Nonempty (SignedPerm 2) := ⟨longest⟩
example : IsReducedWord [.s0, .s1, .s0, .s1] longest :=
  (reduced_words_longest_iff _).2 (Or.inl rfl)
example : TwoBoolean longest := longest_twoBoolean
example : GloballyContains longest pattern4321 := longest_globallyContains_4321
example : Not (AvoidsTwoBooleanPatterns longest) :=
  fun h => h.2.2.1 longest_globallyContains_4321

#print axioms reduced_words_longest_iff
#print axioms longest_twoBoolean
#print axioms longest_globallyContains_4321
#print axioms twoBoolean_persistence_refutation
#print axioms twoBoolean_set_differs_from_global_avoiders

end D5.S1.Words.TwoBooleanPersistenceRefutation
