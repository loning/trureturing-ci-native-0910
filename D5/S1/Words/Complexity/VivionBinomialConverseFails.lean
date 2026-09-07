/- GID: D5/S1/Words/Complexity/VivionBinomialConverseFails
   generality: I
   mirror-B: D5/B/S1/Words/Complexity/VivionBinomialConverseFails
   mirror-E: none(waiver:pure-word-combinatorics)
   anchors: []
   utility: kind=certified-instance; basis=terminal=gid:D5/S1/Words/Complexity/VivionBinomialConverseFails.restricted_converse_fails
   digest: An explicit binary word has b_2 equal to p at every length while b_1(2) is less than p(2) and the word is not 1-balanced, answering Vivion's Section 7 Question 3 negatively; the plain converse was already known false and is not the contribution. -/

import D5.S1.Words.Complexity.MorseHedlund

set_option autoImplicit false
set_option relaxedAutoImplicit false

/-!
An explicit negative answer to Section 7, Question 3 of Leo Vivion,
"New examples of words for which binomial complexities and subword complexity
coincide", arXiv:2509.11172v2.

Immediately after Proposition 6, the paper itself already states that the plain
converse is false, using the eventually constant words `1^m 2^omega`. Those words
have `b_1 = p`: factors are determined by their letter counts (in particular, the
length-two factors `11`, `12`, `22`, when present, have distinct letter counts).
Question 3's restriction therefore excludes those examples. Our word `010111...`
instead has `b_1(2) = 2 < 3 = p(2)`, so it belongs to the restricted class.
The contribution formalized here is exactly this distinction, not the failure
of the plain converse, which is the paper's own observation. Neither Proposition 6
nor any identification from the paper is assumed: the three required properties
are proved directly from scattered-subword counts and the existing factor set.
-/

namespace D5.S1.Words.Complexity.VivionBinomialConverseFails

variable {A : Type*} [Fintype A] [DecidableEq A]

/-- Number of increasing position selections spelling `pattern` in `source`.
The recursion partitions selections according to whether the first position is used;
the empty pattern has one selection. Positions need not be consecutive. -/
def scatteredCount : List A → List A → Nat
  | [], _ => 1
  | _ :: _, [] => 0
  | letter :: pattern, first :: source =>
      scatteredCount (letter :: pattern) source +
        if letter = first then scatteredCount pattern source else 0

/-- All scattered-subword counts through length `k`, including the empty word. -/
def binomialProfile {n : Nat} (k : Nat) (factor : Fin n → A) :
    (length : Fin (k + 1)) → (Fin length.val → A) → Nat :=
  fun _ pattern => scatteredCount (List.ofFn pattern) (List.ofFn factor)

/-- Two factors are `k`-binomially equivalent exactly when all these counts agree. -/
def BinomialEquivalent {n : Nat} (k : Nat) (left right : Fin n → A) : Prop :=
  binomialProfile k left = binomialProfile k right

/-- The number of equivalence classes, represented by their distinct count profiles. -/
noncomputable def binomialComplexity (word : Nat → A) (k n : Nat) : Nat := by
  classical
  exact ((wordFactorSet word n).image (binomialProfile k)).card

/-- Every ordered pair of equally long factors has letter-count difference at most `c`.
Writing the bound additively avoids truncated subtraction on natural numbers. -/
def Balanced (word : Nat → A) (c : Nat) : Prop :=
  ∀ n i j letter, scatteredCount [letter] (List.ofFn (wordFactor word n i)) ≤
    scatteredCount [letter] (List.ofFn (wordFactor word n j)) + c

/-- The binary word `010111...`, with precisely two zero positions. -/
def witness (index : Nat) : Bool := if index = 0 ∨ index = 2 then false else true

private theorem factor_tail (n i : Nat) (hi : 3 ≤ i) :
    wordFactor witness n i = wordFactor witness n 3 := by
  funext position
  change (if i + position.val = 0 ∨ i + position.val = 2 then false else true) =
    (if 3 + position.val = 0 ∨ 3 + position.val = 2 then false else true)
  rw [if_neg (by omega), if_neg (by omega)]

private theorem factor_representative {n : Nat} {factor : Fin n → Bool}
    (hf : factor ∈ wordFactorSet witness n) :
    ∃ start : Fin 4, factor = wordFactor witness n start.val := by
  obtain ⟨start, rfl⟩ := mem_wordFactorSet.mp hf
  by_cases hs : start < 3
  · exact ⟨⟨start, by omega⟩, rfl⟩
  · exact ⟨3, factor_tail n start (by omega)⟩

private theorem factor_set (n : Nat) : wordFactorSet witness n =
    Finset.univ.image (fun start : Fin 4 => wordFactor witness n start.val) := by
  ext factor
  constructor
  · intro hf
    obtain ⟨start, rfl⟩ := factor_representative hf
    exact Finset.mem_image.mpr ⟨start, Finset.mem_univ _, rfl⟩
  · intro hf
    obtain ⟨start, _, rfl⟩ := Finset.mem_image.mp hf
    exact mem_wordFactorSet.mpr ⟨start.val, rfl⟩

private theorem counts_append_ones (source : List Bool) (tail : Nat) :
    scatteredCount [false] (source ++ List.replicate tail true) =
        scatteredCount [false] source ∧
    scatteredCount [true, false] (source ++ List.replicate tail true) =
        scatteredCount [true, false] source := by
  induction source with
  | nil =>
      induction tail with
      | zero => simp [scatteredCount]
      | succ tail ih => simp_all [List.replicate_succ, scatteredCount]
  | cons first source ih =>
      cases first <;> simp_all [scatteredCount]

private theorem factor_list (tail start : Nat) :
    List.ofFn (wordFactor witness (3 + tail) start) =
      List.ofFn (wordFactor witness 3 start) ++ List.replicate tail true := by
  rw [List.ofFn_add]
  congr 1
  rw [← List.ofFn_const]
  congr 1
  funext position
  change (if start + (3 + position.val) = 0 ∨ start + (3 + position.val) = 2
    then false else true) = true
  rw [if_neg (by omega)]

private theorem prefix_separation : Function.Injective (fun start : Fin 4 =>
    (scatteredCount [false] (List.ofFn (wordFactor witness 3 start.val)),
      scatteredCount [true, false] (List.ofFn (wordFactor witness 3 start.val)))) := by
  decide

private theorem large_separation (tail : Nat) {left right : Fin 4}
    (heq : binomialProfile 2 (wordFactor witness (3 + tail) left.val) =
      binomialProfile 2 (wordFactor witness (3 + tail) right.val)) : left = right := by
  have hzero := congrFun (congrFun heq (⟨1, by omega⟩ : Fin 3)) (fun _ => false)
  have hpair := congrFun (congrFun heq (⟨2, by omega⟩ : Fin 3)) ![true, false]
  change scatteredCount [false] (List.ofFn (wordFactor witness (3 + tail) left.val)) =
    scatteredCount [false] (List.ofFn (wordFactor witness (3 + tail) right.val)) at hzero
  change scatteredCount [true, false] (List.ofFn (wordFactor witness (3 + tail) left.val)) =
    scatteredCount [true, false] (List.ofFn (wordFactor witness (3 + tail) right.val)) at hpair
  rw [factor_list, factor_list, (counts_append_ones _ _).1,
    (counts_append_ones _ _).1] at hzero
  rw [factor_list, factor_list, (counts_append_ones _ _).2,
    (counts_append_ones _ _).2] at hpair
  exact prefix_separation (Prod.ext hzero hpair)

private theorem short_separation : ∀ n : Fin 3, ∀ left right : Fin 4,
    binomialProfile 2 (wordFactor witness n.val left.val) =
        binomialProfile 2 (wordFactor witness n.val right.val) →
      wordFactor witness n.val left.val = wordFactor witness n.val right.val := by
  decide

private theorem profile_injective (n : Nat) :
    Set.InjOn (binomialProfile (A := Bool) (n := n) 2)
      (wordFactorSet witness n : Set (Fin n → Bool)) := by
  intro left hl right hr heq
  obtain ⟨leftStart, rfl⟩ := factor_representative hl
  obtain ⟨rightStart, rfl⟩ := factor_representative hr
  by_cases hn : n < 3
  · exact short_separation ⟨n, hn⟩ leftStart rightStart heq
  · obtain ⟨tail, rfl⟩ : ∃ tail, n = 3 + tail := ⟨n - 3, by omega⟩
    rw [large_separation tail heq]

private theorem complexity_two (n : Nat) :
    binomialComplexity witness 2 n = (wordFactorSet witness n).card := by
  classical
  exact Finset.card_image_of_injOn (profile_injective n)

private theorem length_two_values :
    binomialComplexity witness 1 2 = 2 ∧ (wordFactorSet witness 2).card = 3 := by
  classical
  unfold binomialComplexity
  rw [factor_set]
  constructor <;> decide

private theorem not_balanced : ¬ Balanced witness 1 := by
  intro hb
  have impossible := hb 3 0 3 false
  change 2 ≤ 0 + 1 at impossible
  omega

/-- The witness answers Vivion's restricted converse question negatively:
`b_2 = p` at every length, but `b_1(2) < p(2)` and the word is not 1-balanced. -/
theorem restricted_converse_fails :
    (∀ n : Nat, binomialComplexity witness 2 n = (wordFactorSet witness n).card) ∧
    binomialComplexity witness 1 2 < (wordFactorSet witness 2).card ∧
    ¬ Balanced witness 1 := by
  refine ⟨complexity_two, ?_, not_balanced⟩
  rw [length_two_values.1, length_two_values.2]
  omega

#print axioms scatteredCount
#print axioms binomialProfile
#print axioms BinomialEquivalent
#print axioms binomialComplexity
#print axioms Balanced
#print axioms witness
#print axioms restricted_converse_fails

end D5.S1.Words.Complexity.VivionBinomialConverseFails
