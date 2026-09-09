/- GID: D5/S3/Arith/NormalizedColumnParityPowersOfTwo
   generality: I
   mirror-B: D5/B/S3/Arith/NormalizedColumnParityPowersOfTwo
   mirror-E: none(waiver:unbounded-symbolic-proof)
   anchors: []
   utility: none
   digest: The normalized A144637 column is integral and odd exactly at positive powers of two. -/
import D5.S3.Arith.ArtinSchreierQuadraticRootUniqueness
import D5.S3.Arith.ArtinSchreierTracePowersOfTwo
set_option autoImplicit false
set_option relaxedAutoImplicit false
open PowerSeries
open Finset
namespace D5.S3.Arith.NormalizedColumnParityPowersOfTwo
noncomputable section
private abbrev F2 := ZMod 2
private abbrev reduce := PowerSeries.map (Int.castRingHom F2)
private abbrev rationalize := PowerSeries.map (Int.castRingHom ℚ)
private def source {R : Type*} [CommRing R] (y : PowerSeries R) : PowerSeries R :=
  C (36 : R) * y ^ 3 + C (3 : R) * y ^ 2 + (1 + C (6 : R) * X) * y
private def step {R : Type*} [CommRing R] (y : PowerSeries R) : PowerSeries R :=
  X ^ 2 - C (36 : R) * y ^ 3 - C (3 : R) * y ^ 2 - C (6 : R) * (X * y)
private theorem map_source {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (y : PowerSeries R) :
    PowerSeries.map f (source y) = source (PowerSeries.map f y) := by
  simp only [source, map_add, map_mul, map_pow, map_one, map_X, map_ofNat]
private theorem coeff_square_congr {R : Type*} [CommRing R]
    (u v : PowerSeries R) (n : ℕ)
    (hu0 : coeff 0 u = 0) (hv0 : coeff 0 v = 0)
    (h : ∀ k : ℕ, k < n → coeff k u = coeff k v) :
    coeff n (u ^ 2) = coeff n (v ^ 2) := by
  simp only [pow_two, coeff_mul]
  apply Finset.sum_congr rfl
  rintro ⟨i, j⟩ hij
  have hij' : i + j = n := Finset.mem_antidiagonal.mp hij
  by_cases hi : i = n
  · subst i
    have hj : j = 0 := by omega
    subst j
    simp [hu0, hv0]
  by_cases hj : j = n
  · subst j
    have hi0 : i = 0 := by omega
    subst i
    simp [hu0, hv0]
  rw [h i (by omega), h j (by omega)]
private theorem coeff_cube_congr {R : Type*} [CommRing R]
    (u v : PowerSeries R) (n : ℕ)
    (hu0 : coeff 0 u = 0) (hv0 : coeff 0 v = 0)
    (h : ∀ k : ℕ, k < n → coeff k u = coeff k v) :
    coeff n (u ^ 3) = coeff n (v ^ 3) := by
  have hu20 : coeff 0 (u ^ 2) = 0 := by
    rw [coeff_zero_eq_constantCoeff, map_pow, ← coeff_zero_eq_constantCoeff, hu0]
    simp
  have hv20 : coeff 0 (v ^ 2) = 0 := by
    rw [coeff_zero_eq_constantCoeff, map_pow, ← coeff_zero_eq_constantCoeff, hv0]
    simp
  rw [show u ^ 3 = u ^ 2 * u by ring, show v ^ 3 = v ^ 2 * v by ring,
    coeff_mul, coeff_mul]
  apply Finset.sum_congr rfl
  rintro ⟨i, j⟩ hij
  have hij' : i + j = n := Finset.mem_antidiagonal.mp hij
  by_cases hj0 : j = 0
  · subst j
    simp [hu0, hv0]
  by_cases hjn : j = n
  · subst j
    have hi0 : i = 0 := by omega
    subst i
    simp [hu20, hv20]
  rw [coeff_square_congr u v i hu0 hv0 (fun k hk => h k (by omega)),
    h j (by omega)]
private theorem coeff_step_congr {R : Type*} [CommRing R]
    (u v : PowerSeries R) (n : ℕ)
    (hu0 : coeff 0 u = 0) (hv0 : coeff 0 v = 0)
    (h : ∀ k : ℕ, k < n → coeff k u = coeff k v) :
    coeff n (step u) = coeff n (step v) := by
  have h2 := coeff_square_congr u v n hu0 hv0 h
  have h3 := coeff_cube_congr u v n hu0 hv0 h
  have hX : coeff n (X * u) = coeff n (X * v) := by
    rw [show X * u = X ^ 1 * u by simp, show X * v = X ^ 1 * v by simp,
      coeff_X_pow_mul', coeff_X_pow_mul']
    split_ifs with hn
    · exact h (n - 1) (by omega)
    · rfl
  simp only [step, map_sub, coeff_C_mul]
  rw [h2, h3, hX]
private noncomputable def solutionCoeff (n : ℕ) : ℤ :=
  coeff n (step (PowerSeries.mk fun k =>
    if _hk : k < n then solutionCoeff k else 0))
termination_by n
decreasing_by omega
private noncomputable def solutionPrefix (n : ℕ) : PowerSeries ℤ :=
  PowerSeries.mk fun k => if k < n then solutionCoeff k else 0
private noncomputable def solutionSeries : PowerSeries ℤ :=
  PowerSeries.mk solutionCoeff
private theorem solutionCoeff_eq (n : ℕ) :
    solutionCoeff n = coeff n (step (solutionPrefix n)) := by
  rw [solutionCoeff]
  rfl
@[simp] private theorem solutionCoeff_zero : solutionCoeff 0 = 0 := by
  rw [solutionCoeff]
  simp [step]
@[simp] private theorem coeff_solutionPrefix (n k : ℕ) :
    coeff k (solutionPrefix n) = if k < n then solutionCoeff k else 0 := by
  simp [solutionPrefix]
@[simp] private theorem coeff_solutionSeries (n : ℕ) :
    coeff n solutionSeries = solutionCoeff n := by
  simp [solutionSeries]
private theorem solution_fixedpoint : solutionSeries = step solutionSeries := by
  ext n
  rw [coeff_solutionSeries, solutionCoeff_eq]
  symm
  apply coeff_step_congr solutionSeries (solutionPrefix n) n
  · simpa only [coeff_solutionSeries] using solutionCoeff_zero
  · simp
  · intro k hk
    simp [hk]
private theorem fixedpoint_of_source {R : Type*} [CommRing R]
    (y : PowerSeries R) (hy : source y = X ^ 2) : y = step y := by
  unfold source step at *
  linear_combination hy
private theorem source_solution_unique {R : Type*} [CommRing R]
    (u v : PowerSeries R)
    (hu0 : constantCoeff u = 0) (hv0 : constantCoeff v = 0)
    (hu : source u = X ^ 2) (hv : source v = X ^ 2) : u = v := by
  have huf := fixedpoint_of_source u hu
  have hvf := fixedpoint_of_source v hv
  ext n
  induction n using Nat.strong_induction_on with
  | h n ih =>
      calc
        coeff n u = coeff n (step u) := congrArg (coeff n) huf
        _ = coeff n (step v) := coeff_step_congr u v n
          (by simpa [coeff_zero_eq_constantCoeff] using hu0)
          (by simpa [coeff_zero_eq_constantCoeff] using hv0) ih
        _ = coeff n v := (congrArg (coeff n) hvf).symm
private theorem solution_constantCoeff : constantCoeff solutionSeries = 0 := by
  rw [← coeff_zero_eq_constantCoeff]
  simp

private theorem solution_equation : source solutionSeries = X ^ 2 := by
  have h := solution_fixedpoint
  unfold step source at *
  linear_combination h

/-- The normalized cubic equation has a zero-constant integer power-series solution. -/
theorem normalized_solution_exists : ∃ z : PowerSeries ℤ,
    constantCoeff z = 0 ∧
      C (36 : ℤ) * z ^ 3 + C (3 : ℤ) * z ^ 2 +
        (1 + C (6 : ℤ) * X) * z = X ^ 2 := by
  exact ⟨solutionSeries, solution_constantCoeff, solution_equation⟩

private theorem rational_solution_constantCoeff :
    constantCoeff (rationalize solutionSeries) = 0 := by
  rw [← coeff_zero_eq_constantCoeff, coeff_map, coeff_zero_eq_constantCoeff,
    solution_constantCoeff]
  rfl

private theorem rational_solution_equation :
    source (rationalize solutionSeries) = X ^ 2 := by
  calc
    source (rationalize solutionSeries) = rationalize (source solutionSeries) :=
      (map_source (Int.castRingHom ℚ) solutionSeries).symm
    _ = rationalize (X ^ 2) := congrArg rationalize solution_equation
    _ = X ^ 2 := by simp [rationalize]

/-- The zero-constant rational hypothesis package for the normalized equation is inhabited. -/
theorem rational_solution_exists : ∃ y : PowerSeries ℚ,
    constantCoeff y = 0 ∧
      C (36 : ℚ) * y ^ 3 + C (3 : ℚ) * y ^ 2 +
        (1 + C (6 : ℚ) * X) * y = X ^ 2 := by
  exact ⟨rationalize solutionSeries, rational_solution_constantCoeff,
    rational_solution_equation⟩

private theorem reduced_solution_equation :
    (reduce solutionSeries) ^ 2 + reduce solutionSeries = X ^ 2 := by
  have hsource : source (reduce solutionSeries) = X ^ 2 := by
    calc
      source (reduce solutionSeries) = reduce (source solutionSeries) :=
        (map_source (Int.castRingHom F2) solutionSeries).symm
      _ = reduce (X ^ 2) := congrArg reduce solution_equation
      _ = X ^ 2 := by simp [reduce]
  have h36base : (36 : F2) = 0 := by decide
  have h3base : (3 : F2) = 1 := by decide
  have h6base : (6 : F2) = 0 := by decide
  have h36 : C (36 : F2) = (0 : PowerSeries F2) := by
    simpa only [map_zero] using congrArg (C (R := F2)) h36base
  have h3 : C (3 : F2) = (1 : PowerSeries F2) := by
    simpa only [map_one] using congrArg (C (R := F2)) h3base
  have h6 : C (6 : F2) = (0 : PowerSeries F2) := by
    simpa only [map_zero] using congrArg (C (R := F2)) h6base
  rw [source, h36, h3, h6] at hsource
  simpa using hsource

/-- A rational solution is the image of an integer series whose reduction obeys the quadratic. -/
theorem integral_reduction (y : PowerSeries ℚ)
    (h0 : constantCoeff y = 0)
    (hy : C (36 : ℚ) * y ^ 3 + C (3 : ℚ) * y ^ 2 +
      (1 + C (6 : ℚ) * X) * y = X ^ 2) :
    ∃ z : PowerSeries ℤ, rationalize z = y ∧ constantCoeff z = 0 ∧
      (reduce z) ^ 2 + reduce z = X ^ 2 := by
  have heq : y = rationalize solutionSeries :=
    source_solution_unique y (rationalize solutionSeries) h0
      rational_solution_constantCoeff hy rational_solution_equation
  exact ⟨solutionSeries, heq.symm, solution_constantCoeff, reduced_solution_equation⟩

private abbrev artinCoeff :=
  D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinCoeff

private abbrev artinSeries :=
  D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinSeries

@[simp] private theorem artinCoeff_even (n : ℕ) :
    artinCoeff (2 * n) = artinCoeff n := by
  simp [artinCoeff, D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinCoeff,
    Nat.evenOddRec_even]

@[simp] private theorem artinCoeff_odd (n : ℕ) :
    artinCoeff (2 * n + 1) = if n = 0 then 1 else 0 := by
  simp [artinCoeff, D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinCoeff,
    Nat.evenOddRec_odd]

private theorem two_mul_zero_or_power_iff (n : ℕ) :
    (2 * n = 0 ∨ ∃ r, 2 * n = 2 ^ r) ↔ (n = 0 ∨ ∃ r, n = 2 ^ r) := by
  constructor
  · rintro (hzero | ⟨r, hr⟩)
    · exact Or.inl (by omega)
    · cases r with
      | zero => simp at hr
      | succ r =>
          right
          refine ⟨r, ?_⟩
          simp only [pow_succ] at hr
          omega
  · rintro (rfl | ⟨r, rfl⟩)
    · exact Or.inl rfl
    · right
      refine ⟨r + 1, ?_⟩
      simp [pow_succ, Nat.mul_comm]

private theorem two_mul_add_one_zero_or_power_iff (n : ℕ) :
    (2 * n + 1 = 0 ∨ ∃ r, 2 * n + 1 = 2 ^ r) ↔ n = 0 := by
  constructor
  · rintro (hzero | ⟨r, hr⟩)
    · omega
    · cases r with
      | zero => simpa using hr
      | succ r =>
          simp only [pow_succ] at hr
          omega
  · rintro rfl
    right
    exact ⟨0, rfl⟩

private theorem artinCoeff_eq_one_iff (n : ℕ) :
    artinCoeff n = 1 ↔ n = 0 ∨ ∃ r, n = 2 ^ r := by
  induction n using Nat.evenOddRec with
  | h0 => simp [artinCoeff,
      D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinCoeff]
  | h_even n ih =>
      rw [artinCoeff_even, ih, ← two_mul_zero_or_power_iff]
  | h_odd n ih =>
      rw [artinCoeff_odd, two_mul_add_one_zero_or_power_iff]
      by_cases hn : n = 0 <;> simp [hn]

private def artinTail : PowerSeries F2 := artinSeries ^ 2 + 1

private theorem series_two_eq_zero : (2 : PowerSeries F2) = 0 := by
  simpa only [map_ofNat, map_zero] using
    congrArg (C (R := F2)) (CharTwo.two_eq_zero (R := F2))

private theorem artinSeries_square_eq : artinSeries ^ 2 = X + artinSeries := by
  have hS := D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinSeries_square_add
  have hself : artinSeries + artinSeries = 0 := by
    ext n
    simp only [map_add, map_zero]
    exact CharTwo.add_self_eq_zero _
  calc
    artinSeries ^ 2 = (artinSeries ^ 2 + artinSeries) + artinSeries := by
      rw [add_assoc, hself, add_zero]
    _ = X + artinSeries := by rw [hS]

private theorem artinTail_eq : artinTail = X + artinSeries + 1 := by
  unfold artinTail
  rw [artinSeries_square_eq]

private theorem artinTail_constantCoeff : constantCoeff artinTail = 0 := by
  simp [artinTail, artinSeries,
    D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinSeries,
    D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinCoeff,
    CharTwo.add_self_eq_zero]

private theorem artinTail_equation : artinTail ^ 2 + artinTail = X ^ 2 := by
  have hS := D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinSeries_square_add
  have hsq := congrArg (fun z : PowerSeries F2 => z ^ 2) hS
  calc
    artinTail ^ 2 + artinTail = (artinSeries ^ 2 + artinSeries) ^ 2 := by
      unfold artinTail
      linear_combination (artinSeries ^ 2 - artinSeries ^ 3 + 1) * series_two_eq_zero
    _ = X ^ 2 := hsq

@[simp] private theorem coeff_artinSeries (n : ℕ) :
    coeff n artinSeries = artinCoeff n := by
  simp [artinSeries, D5.S3.Arith.ArtinSchreierTracePowersOfTwo.artinSeries]

private theorem artinTail_support (n : ℕ) :
    coeff n artinTail = 1 ↔ ∃ k : ℕ, 0 < k ∧ n = 2 ^ k := by
  by_cases hn0 : n = 0
  · subst n
    constructor
    · rw [coeff_zero_eq_constantCoeff, artinTail_constantCoeff]
      norm_num
    · rintro ⟨k, hk, hpow⟩
      have hp : 0 < 2 ^ k := pow_pos (by omega) k
      omega
  by_cases hn1 : n = 1
  · subst n
    have hone : artinCoeff 1 = 1 := by
      simpa using artinCoeff_odd 0
    have hc : coeff 1 artinTail = 0 := by
      rw [artinTail_eq]
      simp only [map_add, coeff_one_X, coeff_artinSeries, coeff_one,
        one_ne_zero, if_false, add_zero]
      exact CharTwo.add_self_eq_zero 1
    rw [hc]
    simp only [zero_ne_one, false_iff]
    rintro ⟨k, hk, hpow⟩
    have hp : 1 < 2 ^ k := one_lt_pow₀ (by omega) (Nat.ne_of_gt hk)
    omega
  have hc : coeff n artinTail = artinCoeff n := by
    rw [artinTail_eq]
    simp [PowerSeries.coeff_X, hn0, hn1]
  rw [hc, artinCoeff_eq_one_iff]
  simp only [hn0, false_or]
  constructor
  · rintro ⟨k, hk⟩
    refine ⟨k, ?_, hk⟩
    by_contra hk0
    have hkzero : k = 0 := Nat.eq_zero_of_not_pos hk0
    subst k
    exact hn1 (by simpa only [pow_zero] using hk)
  · rintro ⟨k, hk, hpow⟩
    exact ⟨k, hpow⟩

/-- Every zero-constant root of `F^2+F=X^2` is supported at positive powers of two. -/
theorem zero_constant_quadratic_support (F : PowerSeries F2)
    (h0 : constantCoeff F = 0) (hF : F ^ 2 + F = X ^ 2) (n : ℕ) :
    coeff n F = 1 ↔ ∃ k : ℕ, 0 < k ∧ n = 2 ^ k := by
  rw [D5.S3.Arith.ArtinSchreierQuadraticRootUniqueness.quadratic_root_unique
    (X ^ 2) F artinTail hF artinTail_equation
    (h0.trans artinTail_constantCoeff.symm)]
  exact artinTail_support n

/-- OEIS A144637: normalized coefficients are integral and odd exactly at positive powers of two. -/
theorem a144637_parity (y : PowerSeries ℚ)
    (h0 : constantCoeff y = 0)
    (hy : C (36 : ℚ) * y ^ 3 + C (3 : ℚ) * y ^ 2 +
      (1 + C (6 : ℚ) * X) * y = X ^ 2) :
    ∃ z : PowerSeries ℤ, rationalize z = y ∧ ∀ n : ℕ,
      Odd (coeff n z) ↔ ∃ k : ℕ, 0 < k ∧ n = 2 ^ k := by
  obtain ⟨z, hzy, hz0, hz⟩ := integral_reduction y h0 hy
  refine ⟨z, hzy, ?_⟩
  intro n
  rw [← ZMod.intCast_eq_one_iff_odd]
  have hc : ((PowerSeries.coeff n z : ℤ) : F2) = coeff n (reduce z) := by
    simp [reduce]
  rw [hc]
  exact zero_constant_quadratic_support (reduce z)
    (by
      rw [← coeff_zero_eq_constantCoeff, coeff_map,
        coeff_zero_eq_constantCoeff, hz0]
      rfl)
    hz n

example : Nonempty (PowerSeries ℚ) := ⟨0⟩

example : ∃ y : PowerSeries ℚ,
    constantCoeff y = 0 ∧
      C (36 : ℚ) * y ^ 3 + C (3 : ℚ) * y ^ 2 +
        (1 + C (6 : ℚ) * X) * y = X ^ 2 :=
  rational_solution_exists

example : ∃ F : PowerSeries F2,
    constantCoeff F = 0 ∧ F ^ 2 + F = X ^ 2 :=
  ⟨artinTail, artinTail_constantCoeff, artinTail_equation⟩

example : ∃ n : ℕ, ∃ k : ℕ, 0 < k ∧ n = 2 ^ k :=
  ⟨2, 1, by norm_num⟩

#print axioms normalized_solution_exists
#print axioms rational_solution_exists
#print axioms integral_reduction
#print axioms zero_constant_quadratic_support
#print axioms a144637_parity

end

end D5.S3.Arith.NormalizedColumnParityPowersOfTwo
