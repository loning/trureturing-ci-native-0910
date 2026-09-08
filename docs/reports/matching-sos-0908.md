# R2-MATCH: all-order matching SOS investigation

Provenance: this is the implementation worker of the user-supplied `consensus-rnd:sshx`
R2-MATCH brief for https://github.com/the-omega-institute/trureturing/issues/6377.
The worker did not invoke a local skill or delegate work. All results below are
single-worker measurements; no independent review or orchestrator verification
is claimed.

Base: `aee1eaff34f997e44f04147cee1010bb482c4c1b`.
Pinned Mathlib: `db584cd6d46c92f209a44c0f1c829460d327499d`; Lean `v4.33.0`.

## Verified Partial Result: Equation (5)

The source below was compiled at
`D5/S3/Zeros/Convolution/AlternatingFactorialSum.lean` by `make lean`.
The complete project build exited `0` (12580 jobs). All three printed theorem
axiom closures were exactly `propext`, `Classical.choice`, `Quot.sound`.
The proof quantifies over every `d h : Nat`. Numerical calibration is not a proof
premise. The factorial equality is stated over the rationals, with exact casts
of natural factorials; no rounding or truncated division occurs.

`proof_shape: bind-only` for these three partial theorems: inverse-series
identities, coefficient projections, factorial/choose rewrites and ring
normalization supply all their facts. `admission_basis: none` for an independent
freeze of this partial module. `escape_witness: none` for the partial module.
The task's proposed escape witness remains the full equation (2).
This is a source archive, not a deposit, and is not a proof of equation (2).

`utility: none` applies declaration by declaration:

- `opposite_inv_series_mul`: an arbitrary-degree identity over every commutative ring.
- `alternating_choose_convolution`: an arbitrary-parameter symbolic coefficient identity.
- `alternating_factorial_sum`: an arbitrary-parameter symbolic finite-sum identity.

None enumerates a bounded set of parameter instances, implements a checker,
reduces a theorem to unmet numerical premises, or certifies a numerical instance.
All other computational utility fields are `not-applicable(kind=none)`.

No positivity of the full Hermite matrix `H_0(R)` is asserted.
No `FiniteSymbolCriterion` hypothesis, `FiniteAdditiveSymbol.additive_splits`,
or in-flight Hermite parity module is used.

```lean
/- GID: D5/S3/Zeros/Convolution/AlternatingFactorialSum
   generality: G
   mirror-B: D5/B/S3/Zeros/Convolution/AlternatingFactorialSum
   mirror-E: none(waiver:symbolic-generating-function)
   anchors: []
   utility: none
   digest: Alternating factorial convolution from negative binomial series. -/

import Mathlib.RingTheory.PowerSeries.WellKnown
import Mathlib.RingTheory.PowerSeries.Expand
import Mathlib.Tactic

/-!
All declarations quantify over arbitrary natural degrees and ring coefficients.
The series identity and the two finite-sum identities are symbolic identities,
not bounded enumerations, checkers, numerical reductions, or certified instances.
This is step (5) of the matching-SOS task; it does not prove the matching identity.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section

namespace D5.S3.Zeros.Convolution.AlternatingFactorialSum

open PowerSeries
open scoped BigOperators

/-- The two opposite negative binomial series combine by square substitution. -/
theorem opposite_inv_series_mul {R : Type*} [CommRing R] (d : ℕ) :
    rescale (-1 : R) (invOneSubPow R d).val * (invOneSubPow R d).val =
      expand 2 (by norm_num) (invOneSubPow R d).val := by
  let a : PowerSeries R := (invOneSubPow R d).val
  let b : PowerSeries R := rescale (-1 : R) a
  let c : PowerSeries R := expand 2 (by norm_num) a
  have ha : (1 - X : PowerSeries R)^d * a = 1 := by
    change (1 - X : PowerSeries R)^d * (invOneSubPow R d).val = 1
    rw [← invOneSubPow_inv_eq_one_sub_pow]
    exact (invOneSubPow R d).inv_val
  have hb : (1 + X : PowerSeries R)^d * b = 1 := by
    simpa [b, map_mul, map_pow, map_sub, rescale_neg_one_X] using
      congrArg (rescale (-1 : R)) ha
  have hc : (1 - X^2 : PowerSeries R)^d * c = 1 := by
    simpa [c, map_mul, map_pow, map_sub] using
      congrArg (expand 2 (by norm_num) : PowerSeries R →ₐ[R] PowerSeries R) ha
  have hab : (b * a) * (1 - X^2 : PowerSeries R)^d = 1 := by
    rw [show (1 - X^2 : PowerSeries R) = (1 + X) * (1 - X) by ring, mul_pow]
    calc
      _ = ((1 + X)^d * b) * ((1 - X)^d * a) := by ring
      _ = 1 := by rw [ha, hb, one_mul]
  change b * a = c
  calc
    b * a = (b * a) * ((1 - X^2)^d * c) := by rw [hc, mul_one]
    _ = c := by rw [← mul_assoc, hab, one_mul]

/-- Coefficient extraction keeps both parameters unbounded. -/
theorem alternating_choose_convolution (d h : ℕ) :
    (∑ ell ∈ Finset.range (2*h+1), (-1 : ℚ)^ell *
      ((d+ell).choose d : ℚ) * ((d+(2*h-ell)).choose d : ℚ)) =
        ((d+h).choose d : ℚ) := by
  have hc := congrArg (coeff (2*h)) (opposite_inv_series_mul (R := ℚ) (d+1))
  rw [coeff_mul, Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk] at hc
  simpa only [coeff_rescale, invOneSubPow_val_succ_eq_mk_add_choose, coeff_mk,
    coeff_expand_mul, Nat.succ_eq_add_one] using hc

/-- The alternating factorial identity for every pair of natural parameters. -/
theorem alternating_factorial_sum (d h : ℕ) :
    (∑ ell ∈ Finset.range (2*h+1), (-1 : ℚ)^ell * ((2*h).choose ell : ℚ) *
      ((d+ell).factorial : ℚ) * ((d+2*h-ell).factorial : ℚ)) =
        ((2*h).factorial : ℚ) / (h.factorial : ℚ) *
          (d.factorial : ℚ) * ((d+h).factorial : ℚ) := by
  have hf (i : ℕ) :
      ((d+i).choose d : ℚ) * (d.factorial : ℚ) * (i.factorial : ℚ) =
        ((d+i).factorial : ℚ) := by
    exact_mod_cast (show (d+i).choose d * d.factorial * i.factorial = (d+i).factorial by
      simpa using Nat.choose_mul_factorial_mul_factorial (Nat.le_add_right d i))
  calc
    _ = ((2*h).factorial : ℚ) * (d.factorial : ℚ)^2 *
        ∑ ell ∈ Finset.range (2*h+1), (-1 : ℚ)^ell *
          ((d+ell).choose d : ℚ) * ((d+(2*h-ell)).choose d : ℚ) := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro ell hell
      have he : ell ≤ 2*h := by simpa only [Finset.mem_range, Nat.lt_succ_iff] using hell
      have hn : ((2*h).choose ell : ℚ) * (ell.factorial : ℚ) *
          ((2*h-ell).factorial : ℚ) = ((2*h).factorial : ℚ) := by
        exact_mod_cast Nat.choose_mul_factorial_mul_factorial he
      rw [show d+2*h-ell = d+(2*h-ell) by omega, ← hf ell, ← hf (2*h-ell)]
      calc
        _ = (-1 : ℚ)^ell *
            (((2*h).choose ell : ℚ) * (ell.factorial : ℚ) * ((2*h-ell).factorial : ℚ)) *
            (d.factorial : ℚ)^2 * ((d+ell).choose d : ℚ) *
            ((d+(2*h-ell)).choose d : ℚ) := by ring
        _ = _ := by rw [hn]; ring
    _ = ((2*h).factorial : ℚ) * (d.factorial : ℚ)^2 * ((d+h).choose d : ℚ) := by
      rw [alternating_choose_convolution]
    _ = _ := by
      rw [← hf h]
      have hh : (h.factorial : ℚ) ≠ 0 := by exact_mod_cast Nat.factorial_ne_zero h
      field_simp

#print axioms opposite_inv_series_mul
#print axioms alternating_choose_convolution
#print axioms alternating_factorial_sum

end D5.S3.Zeros.Convolution.AlternatingFactorialSum
```

