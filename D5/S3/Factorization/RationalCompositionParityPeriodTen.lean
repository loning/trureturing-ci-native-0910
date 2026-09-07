/- GID: D5/S3/Factorization/RationalCompositionParityPeriodTen
   generality: I
   mirror-B: D5/B/S3/Factorization/RationalCompositionParityPeriodTen
   mirror-E: none(waiver:symbolic-unbounded-parity-theorems)
   anchors: []
   utility: none
   digest: A396093 has period ten modulo two, proving both parity conjectures. -/

import Mathlib.Algebra.LinearRecurrence
import Mathlib.Data.Nat.Periodic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.LinearCombination

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S3.Factorization.RationalCompositionParityPeriodTen

/-- The denominator coefficients expand the squared quartic in formula (2). -/
theorem denominator_expansion (x : Int) :
    (1 - 7 * x + 13 * x ^ 2 - 7 * x ^ 3 + x ^ 4) ^ 2 =
      1 - 14 * x + 75 * x ^ 2 - 196 * x ^ 3 + 269 * x ^ 4 - 196 * x ^ 5 +
        75 * x ^ 6 - 14 * x ^ 7 + x ^ 8 := by
  ring

/-- The numerator coefficients expand the factored numerator in formula (2). -/
theorem numerator_expansion (x : Int) :
    x * (1 - x) ^ 2 * (1 - 3 * x + x ^ 2) ^ 2 =
      x - 8 * x ^ 2 + 24 * x ^ 3 - 34 * x ^ 4 + 24 * x ^ 5 - 8 * x ^ 6 + x ^ 7 := by
  ring

/-- The order-eight recurrence belonging to the denominator in formula (2). -/
def recurrence : LinearRecurrence Int where
  order := 8
  coeffs := ![-1, 14, -75, 196, -269, 196, -75, 14]

/-- OEIS A396093, defined directly by its first eight values and order-eight recurrence. -/
def a : Nat -> Int
  | 0 => 0
  | 1 => 1
  | 2 => 6
  | 3 => 33
  | 4 => 174
  | 5 => 892
  | 6 => 4480
  | 7 => 22149
  | n + 8 =>
      14 * a (n + 7) - 75 * a (n + 6) + 196 * a (n + 5) -
        269 * a (n + 4) + 196 * a (n + 3) - 75 * a (n + 2) +
          14 * a (n + 1) - a n

private theorem a_recurrence (n : Nat) :
    a (n + 8) =
      14 * a (n + 7) - 75 * a (n + 6) + 196 * a (n + 5) -
        269 * a (n + 4) + 196 * a (n + 3) - 75 * a (n + 2) +
          14 * a (n + 1) - a n := by
  simp [a]

/-- The sequence `a` satisfies the denominator recurrence from formula (2). -/
theorem a_is_solution : recurrence.IsSolution a := by
  intro n
  change a (n + 8) =
    ∑ i : Fin 8,
      (![(-1 : Int), 14, -75, 196, -269, 196, -75, 14] : Fin 8 → Int) i *
        a (n + i)
  rw [Fin.sum_univ_eight]
  simp
  linear_combination a_recurrence n

/-- The homogeneous coefficient equations above degree seven in
`denominator * A = numerator`. -/
theorem rational_tail_equation (n : Nat) :
    a (n + 8) - 14 * a (n + 7) + 75 * a (n + 6) - 196 * a (n + 5) +
        269 * a (n + 4) - 196 * a (n + 3) + 75 * a (n + 2) -
          14 * a (n + 1) + a n = 0 := by
  linear_combination a_recurrence n

private theorem a_zero : a 0 = 0 := by
  rfl

private theorem a_one : a 1 = 1 := by
  rfl

private theorem a_two : a 2 = 6 := by
  rfl

private theorem a_three : a 3 = 33 := by
  rfl

private theorem a_four : a 4 = 174 := by
  rfl

private theorem a_five : a 5 = 892 := by
  rfl

private theorem a_six : a 6 = 4480 := by
  rfl

private theorem a_seven : a 7 = 22149 := by
  rfl

private theorem a_eight : a 8 = 108144 := by
  have h := a_recurrence 0
  norm_num [a_zero, a_one, a_two, a_three, a_four, a_five, a_six, a_seven] at h
  exact h

private theorem a_nine : a 9 = 522685 := by
  have h := a_recurrence 1
  norm_num [a_one, a_two, a_three, a_four, a_five, a_six, a_seven, a_eight] at h
  exact h

/-- The eight inhomogeneous coefficient equations in
`denominator * A = numerator`. -/
theorem initial_coefficient_equations :
    a 0 = 0 ∧
    a 1 - 14 * a 0 = 1 ∧
    a 2 - 14 * a 1 + 75 * a 0 = -8 ∧
    a 3 - 14 * a 2 + 75 * a 1 - 196 * a 0 = 24 ∧
    a 4 - 14 * a 3 + 75 * a 2 - 196 * a 1 + 269 * a 0 = -34 ∧
    a 5 - 14 * a 4 + 75 * a 3 - 196 * a 2 + 269 * a 1 - 196 * a 0 =
      24 ∧
    a 6 - 14 * a 5 + 75 * a 4 - 196 * a 3 + 269 * a 2 - 196 * a 1 +
      75 * a 0 = -8 ∧
    a 7 - 14 * a 6 + 75 * a 5 - 196 * a 4 + 269 * a 3 - 196 * a 2 +
      75 * a 1 - 14 * a 0 = 1 := by
  norm_num [a_zero, a_one, a_two, a_three, a_four, a_five, a_six, a_seven]

/-- In characteristic two, the order-eight recurrence keeps only the even lags. -/
theorem reduced_recurrence (n : Nat) :
    (a (n + 8) : ZMod 2) =
      (a n : ZMod 2) + a (n + 2) + a (n + 4) + a (n + 6) := by
  have h := congrArg (fun z : Int => (z : ZMod 2)) (a_recurrence n)
  push_cast at h
  have hdouble (z : ZMod 2) : z + z = 0 := by
    calc
      z + z = (2 : ZMod 2) * z := by ring
      _ = 0 := by rw [show (2 : ZMod 2) = 0 by decide]; simp
  have hneg (z : ZMod 2) : -z = z := by
    calc
      -z = -z + (z + z) := by rw [hdouble]; simp
      _ = z := by abel
  have h' : (a (n + 8) : ZMod 2) =
      (a (n + 6) : ZMod 2) + a (n + 4) + a (n + 2) + a n := by
    simpa [show (14 : ZMod 2) = 0 by decide,
      show (75 : ZMod 2) = 1 by decide,
      show (196 : ZMod 2) = 0 by decide,
      show (269 : ZMod 2) = 1 by decide,
      sub_eq_add_neg, hneg, Nat.add_assoc] using h
  calc
    (a (n + 8) : ZMod 2) =
        (a (n + 6) : ZMod 2) + a (n + 4) + a (n + 2) + a n := h'
    _ = (a n : ZMod 2) + a (n + 2) + a (n + 4) + a (n + 6) := by ac_rfl

/-- Two shifted reduced recurrences cancel in characteristic two, forcing period ten. -/
theorem parity_period_ten : Function.Periodic (fun n => (a n : ZMod 2)) 10 := by
  intro n
  have h0 := reduced_recurrence n
  have h2 := reduced_recurrence (n + 2)
  norm_num [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] at h2
  calc
    (a (n + 10) : ZMod 2) =
        (a (n + 2) : ZMod 2) + a (n + 4) + a (n + 6) + a (n + 8) := h2
    _ = (a n : ZMod 2) := by
      rw [h0]
      have hdouble (z : ZMod 2) : z + z = 0 := by
        calc
          z + z = (2 : ZMod 2) * z := by ring
          _ = 0 := by rw [show (2 : ZMod 2) = 0 by decide]; simp
      linear_combination hdouble (a (n + 2)) + hdouble (a (n + 4)) +
        hdouble (a (n + 6))

private theorem first_ten_values (i : Fin 10) :
    a i = (![0, 1, 6, 33, 174, 892, 4480, 22149, 108144, 522685] : Fin 10 -> Int) i := by
  fin_cases i <;>
    simp only [a_zero, a_one, a_two, a_three, a_four, a_five, a_six, a_seven,
      a_eight, a_nine] <;> decide

private theorem initial_parities (i : Fin 10) :
    (a i : ZMod 2) = (![0, 1, 0, 1, 0, 0, 0, 1, 0, 1] : Fin 10 -> ZMod 2) i := by
  fin_cases i <;>
    simp only [a_zero, a_one, a_two, a_three, a_four, a_five, a_six, a_seven,
      a_eight, a_nine] <;> decide

private theorem initial_parity_characterization (i : Fin 10) :
    ((a i : ZMod 2) = 1) ↔ i.val ∈ ({1, 3, 7, 9} : Finset Nat) := by
  rw [initial_parities]
  fin_cases i <;> decide

/-- For A396093, odd values occur exactly in residues 1, 3, 7, and 9 modulo ten. -/
theorem odd_iff_mod_ten (n : Nat) :
    Odd (a n) ↔ n % 10 ∈ ({1, 3, 7, 9} : Finset Nat) := by
  rw [← ZMod.intCast_eq_one_iff_odd]
  have hperiod := parity_period_ten.map_mod_nat n
  rw [← hperiod]
  let i : Fin 10 := ⟨n % 10, Nat.mod_lt n (by decide)⟩
  simpa [i] using initial_parity_characterization i

/-- OEIS conjecture 1: `a(2*n) is even for n >= 1`. -/
theorem even_at_even_index (n : Nat) (_hn : 1 <= n) : Even (a (2 * n)) := by
  rw [← Int.not_odd_iff_even]
  rw [odd_iff_mod_ten]
  simp only [Finset.mem_insert, Finset.mem_singleton]
  omega

/-- OEIS conjecture 2: `a(2*n-1) is even iff n is of the form 5*k-2
(k >= 1) for n >= 1`. -/
theorem even_at_odd_index_iff (n : Nat) (hn : 1 <= n) :
    Even (a (2 * n - 1)) ↔ ∃ k : Nat, 1 <= k ∧ n = 5 * k - 2 := by
  rw [← Int.not_odd_iff_even]
  rw [odd_iff_mod_ten]
  simp only [Finset.mem_insert, Finset.mem_singleton]
  constructor
  · intro h
    have hmod : n % 5 = 3 := by omega
    have hdiv := Nat.mod_add_div n 5
    refine ⟨n / 5 + 1, by omega, ?_⟩
    omega
  · rintro ⟨k, hk, rfl⟩
    omega

/-- The basic rational map in the OEIS definition. -/
def B (x : Rat) : Rat := x / (1 - x) ^ 2

/-- Formula (2) for the rational generating function. -/
def rationalA (x : Rat) : Rat :=
  x * (1 - x) ^ 2 * (1 - 3 * x + x ^ 2) ^ 2 /
    (1 - 7 * x + 13 * x ^ 2 - 7 * x ^ 3 + x ^ 4) ^ 2

private theorem one_sub_B (x : Rat) (hx : 1 - x ≠ 0) :
    1 - B x = (1 - 3 * x + x ^ 2) / (1 - x) ^ 2 := by
  simp only [B]
  field_simp
  ring

private theorem B_comp_two (x : Rat) (hx : 1 - x ≠ 0) :
    B (B x) = x * (1 - x) ^ 2 / (1 - 3 * x + x ^ 2) ^ 2 := by
  rw [B, one_sub_B x hx]
  simp only [B]
  field_simp

private theorem one_sub_B_comp_two (x : Rat) (hx : 1 - x ≠ 0)
    (hp : 1 - 3 * x + x ^ 2 ≠ 0) :
    1 - B (B x) =
      (1 - 7 * x + 13 * x ^ 2 - 7 * x ^ 3 + x ^ 4) /
        (1 - 3 * x + x ^ 2) ^ 2 := by
  rw [B_comp_two x hx]
  have hp2 : (1 - 3 * x + x ^ 2) ^ 2 ≠ 0 := pow_ne_zero 2 hp
  calc
    1 - x * (1 - x) ^ 2 / (1 - 3 * x + x ^ 2) ^ 2 =
        (1 - 3 * x + x ^ 2) ^ 2 / (1 - 3 * x + x ^ 2) ^ 2 -
          x * (1 - x) ^ 2 / (1 - 3 * x + x ^ 2) ^ 2 := by rw [div_self hp2]
    _ = ((1 - 3 * x + x ^ 2) ^ 2 - x * (1 - x) ^ 2) /
        (1 - 3 * x + x ^ 2) ^ 2 := by rw [sub_div]
    _ = (1 - 7 * x + 13 * x ^ 2 - 7 * x ^ 3 + x ^ 4) /
        (1 - 3 * x + x ^ 2) ^ 2 := by ring

/-- Away from the two displayed poles, formula (2) is the triple composition of `B`. -/
theorem rationalA_eq_triple_B (x : Rat)
    (hx : 1 - x ≠ 0)
    (hp : 1 - 3 * x + x ^ 2 ≠ 0) :
    rationalA x = B (B (B x)) := by
  rw [B]
  rw [one_sub_B_comp_two x hx hp, B_comp_two x hx]
  simp only [rationalA]
  field_simp [hp]

-- Fidelity witnesses: the quantified domains are inhabited and all hypotheses co-occur.
example : Nat := 0

example : Int := 0

example : ∃ n : Nat, 1 <= n := ⟨1, by decide⟩

example : ∃ x : Rat, 1 - x ≠ 0 ∧ 1 - 3 * x + x ^ 2 ≠ 0 := by
  exact ⟨0, by norm_num, by norm_num⟩

#print axioms denominator_expansion
#print axioms numerator_expansion
#print axioms a_is_solution
#print axioms rational_tail_equation
#print axioms initial_coefficient_equations
#print axioms reduced_recurrence
#print axioms parity_period_ten
#print axioms odd_iff_mod_ten
#print axioms even_at_even_index
#print axioms even_at_odd_index_iff
#print axioms rationalA_eq_triple_B

end D5.S3.Factorization.RationalCompositionParityPeriodTen
