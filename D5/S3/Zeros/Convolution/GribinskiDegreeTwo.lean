/- GID: D5/S3/Zeros/Convolution/GribinskiDegreeTwo
   generality: G
   mirror-B: D5/B/S3/Zeros/Convolution/GribinskiDegreeTwo
   mirror-E: none(waiver:symbolic-real-parameter-proof)
   anchors: []
   utility: none
   digest: Degree-two rectangular convolution has the sharp range alpha > -1. -/

import Mathlib.Algebra.QuadraticDiscriminant
import Mathlib.Analysis.Real.Sqrt
import Mathlib.RingTheory.Polynomial.Pochhammer
import Mathlib.Tactic

/-!
Definition 3.10 of arXiv:2502.00254v2 uses the PRODUCT of the two falling
factorials. The general coefficient convolution is defined first, before
specializing the inputs to two linear factors. In particular, G1 is not a
definition of the operation. The normalized-coefficient identity below
checks all three coefficients, including the leading coefficient.

Library search (2026-09-07, Mathlib v4.33.0): the global declarations
exists_quadratic_eq_zero, vieta_formula_quadratic and
quadratic_ne_zero_of_discrim_ne_sq are used directly. The scalar Vieta theorem
supplies the complementary root and its sum/product identities.
Polynomial.roots and the Vieta coefficient/esymm bridges were
checked; signed coefficients also apply when the output has no real roots.
descPochhammer supplies the falling factorials. D5 and Mathlib searches for
Gribinski, boxplus, and rectangular convolution found no matching result;
GitHub Lean code searches for Gribinski and rectangular boxplus returned [].

The symbolic results address Conjecture 3.13 at m=2, including -1<alpha<0.
The source paper also proves the special parameter alpha=-1/2. No worldwide
priority claim is made. G4 refutes preservation at every admissible alpha<-1
using both prescribed input families. All eleven public statements are symbolic
general theorems, including the real-parameter counterexample families, so the
computational utility kind is none. All eleven have proof_shape: bind-only;
these uses supply neither an escape witness nor a deposit admission basis.

Companion obligations and actual directed edges (consumer -> prerequisite):
- definition_consistency is a prerequisite of normalized_coefficient_convolution (Definition 3.10, all k=0,1,2).
- normalized_coefficient_convolution consumes definition_consistency for Definition 3.10; no theorem here consumes its conclusion, retained for the general coefficient-agreement obligation and Scribe's definition-consistency block (narrative use only).
- discriminant_eq_output consumes g1_explicit_coefficients (G1/G2); no theorem here consumes its conclusion, retained to identify the discriminant of the actual output coefficients explicitly.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

open Polynomial

namespace D5.S3.Zeros.Convolution.GribinskiDegreeTwo

/-- The elementary coefficient convention in fixed degree two. -/
def elementaryCoeff (p : Real[X]) (k : Nat) : Real :=
  (-1) ^ k * p.coeff (2 - k)

/-- The product prefactor from Definition 3.10, with m=2. -/
def weight (alpha : Real) (k : Nat) : Real :=
  (descPochhammer Real k).eval 2 * (descPochhammer Real k).eval (2 + alpha)

def normalizedCoeff (alpha : Real) (p : Real[X]) (k : Nat) : Real :=
  elementaryCoeff p k / weight alpha k

/-- The sum over i+j=k, indexed by i=0,...,k. -/
def convolutionCoeff (alpha : Real) (p q : Real[X]) (k : Nat) : Real :=
  weight alpha k * ((Finset.range (k + 1)).sum fun i =>
    normalizedCoeff alpha p i * normalizedCoeff alpha q (k - i))

/-- General degree-two coefficient convolution, before assuming real roots. -/
def boxplus (alpha : Real) (p q : Real[X]) : Real[X] :=
  C (convolutionCoeff alpha p q 0) * X ^ 2 -
    C (convolutionCoeff alpha p q 1) * X + C (convolutionCoeff alpha p q 2)

def rootPair (a b : Real) : Real[X] := (X - C a) * (X - C b)

def kappa (alpha : Real) : Real := (alpha + 1) / (2 * (alpha + 2))

private theorem weight_values (alpha : Real) :
    weight alpha 0 = 1 /\ weight alpha 1 = 2 * (alpha + 2) /\
      weight alpha 2 = 2 * (alpha + 2) * (alpha + 1) := by
  norm_num [weight, descPochhammer_succ_eval]
  constructor <;> ring

private theorem weight_ne_zero (alpha : Real) (h1 : alpha ≠ -1) (h2 : alpha ≠ -2)
    (k : Nat) (hk : k <= 2) : weight alpha k ≠ 0 := by
  have ha1 : alpha + 1 ≠ 0 := by intro h; apply h1; linarith
  have ha2 : alpha + 2 ≠ 0 := by intro h; apply h2; linarith
  rcases weight_values alpha with ⟨w0, w1, w2⟩
  interval_cases k <;> simp_all

/-- Every reconstructed coefficient is exactly the defining convolution sum. -/
theorem definition_consistency (alpha : Real) (p q : Real[X]) (k : Nat) (hk : k <= 2) :
    elementaryCoeff (boxplus alpha p q) k = convolutionCoeff alpha p q k := by
  interval_cases k <;> simp [elementaryCoeff, boxplus]

/-- The normalized coefficients obey the corrected paper definition. -/
theorem normalized_coefficient_convolution (alpha : Real)
    (h1 : alpha ≠ -1) (h2 : alpha ≠ -2) (p q : Real[X]) (k : Nat) (hk : k <= 2) :
    normalizedCoeff alpha (boxplus alpha p q) k =
      (Finset.range (k + 1)).sum (fun i =>
        normalizedCoeff alpha p i * normalizedCoeff alpha q (k - i)) := by
  rw [normalizedCoeff, definition_consistency alpha p q k hk, convolutionCoeff]
  exact mul_div_cancel_left₀ _ (weight_ne_zero alpha h1 h2 k hk)

private theorem rootPair_coefficients (a b : Real) :
    elementaryCoeff (rootPair a b) 0 = 1 /\
      elementaryCoeff (rootPair a b) 1 = a + b /\
      elementaryCoeff (rootPair a b) 2 = a * b := by
  simp [elementaryCoeff, rootPair, mul_sub, sub_mul]

/-- The k=0,1,2 substitution in Definition 3.10, with all cross terms retained. -/
theorem convolution_coefficients (alpha a b c d : Real)
    (h1 : alpha ≠ -1) (h2 : alpha ≠ -2) :
    convolutionCoeff alpha (rootPair a b) (rootPair c d) 0 = 1 /\
      convolutionCoeff alpha (rootPair a b) (rootPair c d) 1 = a + b + c + d /\
      convolutionCoeff alpha (rootPair a b) (rootPair c d) 2 =
        a * b + c * d + kappa alpha * (a + b) * (c + d) := by
  have ha1 : alpha + 1 ≠ 0 := by intro h; apply h1; linarith
  have ha2 : alpha + 2 ≠ 0 := by intro h; apply h2; linarith
  rcases weight_values alpha with ⟨w0, w1, w2⟩
  rcases rootPair_coefficients a b with ⟨p0, p1, p2⟩
  rcases rootPair_coefficients c d with ⟨q0, q1, q2⟩
  simp only [convolutionCoeff, Finset.sum_range_succ, Finset.sum_range_zero,
    normalizedCoeff, p0, p1, p2, q0, q1, q2, w0, w1, w2]
  norm_num [kappa]
  constructor <;> field_simp <;> ring

/-- G1: the explicit polynomial follows from the general coefficient definition. -/
theorem g1_explicit_coefficients (alpha a b c d : Real)
    (h1 : alpha ≠ -1) (h2 : alpha ≠ -2) :
    boxplus alpha (rootPair a b) (rootPair c d) =
      X ^ 2 - C (a + b + c + d) * X +
        C (a * b + c * d + kappa alpha * (a + b) * (c + d)) := by
  rcases convolution_coefficients alpha a b c d h1 h2 with ⟨h0, he1, he2⟩
  simp [boxplus, h0, he1, he2]

/-- The actual coefficient discriminant, using Mathlib's discrim. -/
def discriminant (alpha a b c d : Real) : Real :=
  discrim 1 (-(a + b + c + d))
    (a * b + c * d + kappa alpha * (a + b) * (c + d))

/-- G1 identifies this discriminant with that of the actual output coefficients. -/
theorem discriminant_eq_output (alpha a b c d : Real)
    (h1 : alpha ≠ -1) (h2 : alpha ≠ -2) :
    discriminant alpha a b c d =
      discrim ((boxplus alpha (rootPair a b) (rootPair c d)).coeff 2)
        ((boxplus alpha (rootPair a b) (rootPair c d)).coeff 1)
        ((boxplus alpha (rootPair a b) (rootPair c d)).coeff 0) := by
  rw [g1_explicit_coefficients alpha a b c d h1 h2]
  simp only [coeff_add, coeff_sub, coeff_C_mul, coeff_X_pow, coeff_C, coeff_X]
  norm_num [discriminant]

/-- G2, including the bound and its attained value on both repeated-root inputs. -/
theorem g2_discriminant_bound (alpha a b c d : Real) :
    discriminant alpha a b c d = (a + b + c + d) ^ 2 - 4 * a * b -
      4 * c * d - 4 * kappa alpha * (a + b) * (c + d) /\
    2 * (a + b) * (c + d) * (1 - 2 * kappa alpha) <= discriminant alpha a b c d /\
    (a = b -> c = d -> discriminant alpha a b c d =
      2 * (a + b) * (c + d) * (1 - 2 * kappa alpha)) := by
  dsimp [discriminant, discrim]
  refine ⟨by ring, ?_, ?_⟩
  · nlinarith [sq_nonneg (a - b), sq_nonneg (c - d)]
  · intro hab hcd
    subst b
    subst d
    ring

private theorem kappa_range (alpha : Real) (ha : -1 < alpha) :
    0 < kappa alpha /\ kappa alpha < 1 / 2 := by
  have hd : 0 < 2 * (alpha + 2) := by linarith
  constructor
  · exact div_pos (by linarith) hd
  · rw [kappa, div_lt_iff₀ hd]
    linarith

private theorem nonnegative_factorization (S T : Real)
    (hs : 0 <= S) (ht : 0 <= T) (hd : 0 <= discrim 1 (-S) T) :
    ∃ r s : Real, 0 <= r /\ 0 <= s /\
      X ^ 2 - C S * X + C T = rootPair r s := by
  obtain ⟨r, hr⟩ := exists_quadratic_eq_zero (a := (1 : Real)) (b := -S) (c := T)
    one_ne_zero ⟨Real.sqrt (discrim 1 (-S) T), (Real.mul_self_sqrt hd).symm⟩
  obtain ⟨s, _, hsum, hprod⟩ := vieta_formula_quadratic
    (b := S) (c := T) (x := r)
    (by simpa only [one_mul, neg_mul, sub_eq_add_neg] using hr)
  have hnonneg : 0 <= r /\ 0 <= s := by
    rcases mul_nonneg_iff.mp (hprod.symm ▸ ht) with h | h
    · exact h
    · constructor <;> linarith [h.1, h.2]
  refine ⟨r, s, hnonneg.1, hnonneg.2, ?_⟩
  rw [← hsum, ← hprod]
  simp only [rootPair, map_add, map_mul]
  ring

/-- G3: all real alpha>-1, with no integrality or alpha>=0 restriction. -/
theorem g3_nonnegative_roots (alpha a b c d : Real) (halpha : -1 < alpha)
    (ha : 0 <= a) (hb : 0 <= b) (hc : 0 <= c) (hd : 0 <= d) :
    ∃ r s : Real, 0 <= r /\ 0 <= s /\
      boxplus alpha (rootPair a b) (rootPair c d) = rootPair r s := by
  rw [g1_explicit_coefficients alpha a b c d (by linarith) (by linarith)]
  rcases kappa_range alpha halpha with ⟨hkpos, hkhalf⟩
  apply nonnegative_factorization
  · positivity
  · positivity
  · have hlower : 0 <= 2 * (a + b) * (c + d) * (1 - 2 * kappa alpha) := by
      apply mul_nonneg (by positivity)
      linarith
    exact le_trans hlower (g2_discriminant_bound alpha a b c d).2.1

/-- The preservation assertion whose extension below -1 is refuted by G4. -/
def preservesNonnegativeRoots (alpha : Real) : Prop :=
  ∀ a b c d : Real, 0 <= a -> 0 <= b -> 0 <= c -> 0 <= d ->
    ∃ r s : Real, 0 <= r /\ 0 <= s /\
      boxplus alpha (rootPair a b) (rootPair c d) = rootPair r s

/-- G4's first family: (1,0,1,0), with negative constant coefficient. -/
theorem g4_negative_product (alpha : Real) (hlo : -2 < alpha) (hhi : alpha < -1) :
    (boxplus alpha (rootPair 1 0) (rootPair 1 0)).coeff 0 = kappa alpha /\
      kappa alpha < 0 /\
      ¬ ∃ r s : Real, 0 <= r /\ 0 <= s /\
        boxplus alpha (rootPair 1 0) (rootPair 1 0) = rootPair r s := by
  have hp := g1_explicit_coefficients alpha 1 0 1 0 (by linarith) (by linarith)
  have hk : kappa alpha < 0 := div_neg_of_neg_of_pos (by linarith) (by linarith)
  have hconst : (boxplus alpha (rootPair 1 0) (rootPair 1 0)).coeff 0 = kappa alpha := by
    rw [hp]
    simp
  refine ⟨hconst, hk, ?_⟩
  rintro ⟨r, s, hr, hs, heq⟩
  have hprod : kappa alpha = r * s := by
    calc
      kappa alpha = (boxplus alpha (rootPair 1 0) (rootPair 1 0)).coeff 0 := hconst.symm
      _ = (rootPair r s).coeff 0 := congrArg (fun p : Real[X] => p.coeff 0) heq
      _ = r * s := by simpa [elementaryCoeff] using (rootPair_coefficients r s).2.2
  nlinarith [mul_nonneg hr hs]

/-- G4's second family: (1,1,1,1), with negative discriminant and no real root. -/
theorem g4_negative_discriminant (alpha : Real) (halpha : alpha < -2) :
    discriminant alpha 1 1 1 1 = 8 * (1 - 2 * kappa alpha) /\
      discriminant alpha 1 1 1 1 < 0 /\
      ∀ x : Real, (boxplus alpha (rootPair 1 1) (rootPair 1 1)).eval x ≠ 0 := by
  have ha2 : alpha + 2 ≠ 0 := by linarith
  have hgap : 1 - 2 * kappa alpha = 1 / (alpha + 2) := by
    dsimp [kappa]
    field_simp
    ring
  have heq : discriminant alpha 1 1 1 1 = 8 * (1 - 2 * kappa alpha) := by
    convert (g2_discriminant_bound alpha 1 1 1 1).2.2 rfl rfl using 1
    ring
  have hneg : discriminant alpha 1 1 1 1 < 0 := by
    rw [heq, hgap]
    exact mul_neg_of_pos_of_neg (by norm_num) (div_neg_of_pos_of_neg (by norm_num) (by linarith))
  refine ⟨heq, hneg, ?_⟩
  intro x
  have hnoroot := quadratic_ne_zero_of_discrim_ne_sq
    (a := (1 : Real)) (b := -(1 + 1 + 1 + 1))
    (c := 1 * 1 + 1 * 1 + kappa alpha * (1 + 1) * (1 + 1))
    (fun t h => (sq_nonneg t).not_gt (h ▸ hneg)) x
  rw [g1_explicit_coefficients alpha 1 1 1 1 (by linarith) (by linarith)]
  convert hnoroot using 1
  simp [pow_two]
  ring

/-- G4: one of the two explicit families fails at every admissible alpha<-1. -/
theorem g4_parameter_range_sharp (alpha : Real)
    (_h1 : alpha ≠ -1) (h2 : alpha ≠ -2) (halpha : alpha < -1) :
    ∃ a b c d : Real, 0 <= a /\ 0 <= b /\ 0 <= c /\ 0 <= d /\
      ¬ ∃ r s : Real, 0 <= r /\ 0 <= s /\
        boxplus alpha (rootPair a b) (rootPair c d) = rootPair r s := by
  rcases lt_or_gt_of_ne h2 with h | h
  · refine ⟨1, 1, 1, 1, by norm_num, by norm_num, by norm_num, by norm_num, ?_⟩
    rintro ⟨r, s, _, _, heq⟩
    have hnonzero := (g4_negative_discriminant alpha h).2.2 r
    apply hnonzero
    rw [heq]
    simp [rootPair]
  · exact ⟨1, 0, 1, 0, by norm_num, by norm_num, by norm_num, by norm_num,
      (g4_negative_product alpha h halpha).2.2⟩

/-- The exact parameter range on the domain of Definition 3.10. -/
theorem preservation_iff (alpha : Real) (h1 : alpha ≠ -1) (h2 : alpha ≠ -2) :
    preservesNonnegativeRoots alpha ↔ -1 < alpha := by
  constructor
  · intro h
    by_contra hn
    have hlt : alpha < -1 := lt_of_le_of_ne (le_of_not_gt hn) h1
    obtain ⟨a, b, c, d, ha, hb, hc, hd, hbad⟩ := g4_parameter_range_sharp alpha h1 h2 hlt
    exact hbad (h a b c d ha hb hc hd)
  · intro h a b c d ha hb hc hd
    exact g3_nonnegative_roots alpha a b c d h ha hb hc hd

#print axioms definition_consistency
#print axioms normalized_coefficient_convolution
#print axioms convolution_coefficients
#print axioms discriminant_eq_output
#print axioms g1_explicit_coefficients
#print axioms g2_discriminant_bound
#print axioms g3_nonnegative_roots
#print axioms g4_negative_product
#print axioms g4_negative_discriminant
#print axioms g4_parameter_range_sharp
#print axioms preservation_iff

end D5.S3.Zeros.Convolution.GribinskiDegreeTwo
