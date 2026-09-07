/- GID: D5/S3/Weil/PrimeAddress/VonMangoldtRecurrence
   generality: I
   mirror-B: D5/B/S3/Weil/PrimeAddress/VonMangoldtRecurrence
   mirror-E: none(waiver:unbounded-existence-and-recurrence-obstruction)
   anchors: []
   utility: none
   digest: Arbitrarily late two-prime-factor zero windows rule out every eventual constant-coefficient linear recurrence for von Mangoldt. -/

import D5.S3.ArithUnits.FiniteWindowResidues
import D5.S3.Weil.PrimeAddress.PrimeAddress
import Mathlib.Data.Nat.Nth
import Mathlib.Data.Nat.Factorization.PrimePow
import Mathlib.Algebra.LinearRecurrence

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace D5.S3.Weil.PrimeAddress.VonMangoldtRecurrence

open D5.S3.ArithUnits.FiniteWindowResidues D5.S3.Weil.EulerProduct
open scoped BigOperators Function

/-- Every finite window occurs arbitrarily late with two distinct prime factors
at each position, and with disjoint prime pairs across positions. -/
theorem arbitrarily_late_two_prime_factor_window (r B : ℕ) :
    ∃ N ≥ B, ∃ a b : Fin r → ℕ,
      (∀ j, (a j).Prime ∧ (b j).Prime) ∧
      Function.Injective (fun x : Fin r × Bool => if x.2 then b x.1 else a x.1) ∧
      (∀ j, a j * b j ≠ 0) ∧
      Pairwise (Nat.Coprime on fun j => a j * b j) ∧
      (∀ j, a j * b j ∣ N + j) ∧
      (∀ j : Fin r, ¬ IsPrimePow (N + j)) := by
  classical
  let f := Nat.nth Nat.Prime
  have hf : Function.Injective f :=
    (Nat.nth_strictMono Nat.infinite_setOfPred_prime).injective
  have hp (n : ℕ) : (f n).Prime :=
    Nat.nth_mem_of_infinite Nat.infinite_setOfPred_prime n
  let a : Fin r → ℕ := fun j => f (2 * j)
  let b : Fin r → ℕ := fun j => f (2 * j + 1)
  have hab : Function.Injective
      (fun x : Fin r × Bool => if x.2 then b x.1 else a x.1) := by
    rintro ⟨i, s⟩ ⟨j, t⟩ h
    cases s <;> cases t <;> dsimp [a, b] at h
    all_goals have he := hf h
    all_goals first | omega | (have hij : i = j := Fin.ext (by omega); subst j; rfl)
  have hprime (j : Fin r) : (a j).Prime ∧ (b j).Prime := ⟨hp _, hp _⟩
  let m : Fin r → ℕ := fun j => a j * b j
  have hm (j : Fin r) : m j ≠ 0 :=
    Nat.mul_ne_zero (hprime j).1.ne_zero (hprime j).2.ne_zero
  have hcop : Pairwise (Nat.Coprime on m) := by
    intro i j hij
    have hcross (s t : Bool) :
        Nat.Coprime (if s then b i else a i) (if t then b j else a j) := by
      have hpi : (if s then b i else a i).Prime := by cases s <;> simp [hprime]
      have hpj : (if t then b j else a j).Prime := by cases t <;> simp [hprime]
      apply hpi.coprime_iff_not_dvd.mpr
      intro hdiv
      have he := hab (show (if (i, s).2 then b (i, s).1 else a (i, s).1) =
          (if (j, t).2 then b (j, t).1 else a (j, t).1) from
        (Nat.prime_dvd_prime_iff_eq hpi hpj).mp hdiv)
      exact hij (congrArg Prod.fst he)
    exact (Nat.coprime_mul_iff_left.mpr
      ⟨Nat.coprime_mul_iff_right.mpr ⟨hcross false false, hcross false true⟩,
       Nat.coprime_mul_iff_right.mpr ⟨hcross true false, hcross true true⟩⟩)
  let target : Fin r → ℕ := fun j => m j - j % m j
  obtain ⟨x, _, hx⟩ := finite_window_residues_realizable target m Finset.univ
    (fun j _ => hm j) (fun i _ j _ hij => hcop hij)
  let M := ∏ j, m j
  have hM : 0 < M := Finset.prod_pos (fun j _ => Nat.pos_of_ne_zero (hm j))
  let N := x + B * M
  have hBN : B ≤ N := by
    have hBM : B ≤ B * M := by
      calc B = B * 1 := (Nat.mul_one B).symm
           _ ≤ B * M := Nat.mul_le_mul_left B hM
    dsimp [N]
    omega
  have hd (j : Fin r) : m j ∣ N + j := by
    have hmM : m j ∣ M := Finset.dvd_prod_of_mem m (Finset.mem_univ j)
    have hshift : N ≡ x [MOD m j] :=
      Nat.add_modEq_left_iff.mpr (dvd_mul_of_dvd_right hmM B)
    have hres := (hshift.trans (hx j (Finset.mem_univ j))).add_right (j : ℕ)
    have hzero : target j + j ≡ 0 [MOD m j] := by
      change (m j - j % m j + j) % m j = 0 % m j
      have he : (m j - j % m j + j % m j) % m j = 0 := by
        rw [Nat.sub_add_cancel (Nat.mod_lt _ (Nat.pos_of_ne_zero (hm j))).le]
        exact Nat.mod_self _
      simpa only [Nat.add_mod, Nat.mod_mod, Nat.zero_mod] using he
    exact Nat.dvd_of_mod_eq_zero (hres.trans hzero)
  refine ⟨N, hBN, a, b, hprime, hab, hm, hcop, hd, ?_⟩
  intro j hpow
  obtain ⟨p, _, huniq⟩ := isPrimePow_iff_unique_prime_dvd.mp hpow
  have ha : a j = p := huniq (a j) ⟨(hprime j).1, (dvd_mul_right _ _).trans (hd j)⟩
  have hb : b j = p := huniq (b j) ⟨(hprime j).2, (dvd_mul_left _ _).trans (hd j)⟩
  have he := hab (show (if (j, false).2 then b (j, false).1 else a (j, false).1) =
      (if (j, true).2 then b (j, true).1 else a (j, true).1) from ha.trans hb.symm)
  have := congrArg Prod.snd he
  cases this

/-- The actual von Mangoldt reading has arbitrarily long and arbitrarily late zero windows. -/
theorem arbitrarily_late_vonMangoldt_zero_window (r B : ℕ) :
    ∃ N ≥ B, ∀ j < r, singleAddressReading (N + j) = 0 := by
  obtain ⟨N, hN, a, b, _, _, _, _, _, hpow⟩ :=
    arbitrarily_late_two_prime_factor_window r B
  exact ⟨N, hN, fun j hj => single_address_reading_spec.2 _ (hpow ⟨j, hj⟩)⟩

/-- Above every bound there is a prime whose reading is an explicitly positive real logarithm. -/
theorem arbitrarily_late_prime_reading_positive (B : ℕ) :
    ∃ p ≥ B, p.Prime ∧ singleAddressReading p = Real.log (p : ℝ) ∧
      0 < Real.log (p : ℝ) := by
  obtain ⟨p, hB, hp⟩ := Nat.exists_infinite_primes B
  have he : singleAddressReading p = Real.log (p : ℝ) := by
    simpa using single_address_reading_spec.1 p 1 hp (by decide)
  have hpos : 0 < singleAddressReading p :=
    ArithmeticFunction.vonMangoldt_pos_iff.mpr
      ((isPrimePow_nat_iff p).mpr ⟨p, 1, hp, by decide, pow_one p⟩)
  exact ⟨p, hB, hp, he, he ▸ hpos⟩

/-- Even complex constant coefficients cannot give an eventual recurrence for the real reading.
Order zero is included: its initial range and its recurrence sum are both empty. -/
theorem vonMangoldt_no_eventual_complex_linear_recurrence :
    ¬ ∃ (r : ℕ) (c : Fin r → ℂ) (N0 : ℕ), ∀ n ≥ N0,
      (singleAddressReading (n + r) : ℂ) =
        ∑ j : Fin r, c j * (singleAddressReading (n + j) : ℂ) := by
  rintro ⟨r, c, N0, hrec⟩
  obtain ⟨N, hN, hzero⟩ := arbitrarily_late_vonMangoldt_zero_window r N0
  let E : LinearRecurrence ℂ := ⟨r, c⟩
  let u : ℕ → ℂ := fun k => (singleAddressReading (N + k) : ℂ)
  have hu : E.IsSolution u := by
    intro k
    simpa [E, u, Nat.add_assoc] using hrec (N + k) (by omega)
  have hz : E.IsSolution (0 : ℕ → ℂ) := by intro k; simp
  have hu0 : u = 0 := (E.eq_iff_eqOn_range_order u 0 hu hz).mpr (by
    intro k hk
    have hk' : k < r := Finset.mem_range.mp hk
    simp [u, hzero k hk'])
  obtain ⟨p, hpN, hp⟩ := Nat.exists_infinite_primes (N + 1)
  have hv : singleAddressReading p = 0 := by
    have he := congrFun hu0 (p - N)
    have hind : N + (p - N) = p := by omega
    simpa [u, hind] using he
  exact zeta_has_no_silent_prime_address hp (show (1 : ℕ) ≠ 0 by decide)
    (by simpa using hv)

/-- The real-coefficient version follows by the explicit real-to-complex embedding. -/
theorem vonMangoldt_no_eventual_real_linear_recurrence :
    ¬ ∃ (r : ℕ) (c : Fin r → ℝ) (N0 : ℕ), ∀ n ≥ N0,
      singleAddressReading (n + r) =
        ∑ j : Fin r, c j * singleAddressReading (n + j) := by
  rintro ⟨r, c, N0, hrec⟩
  apply vonMangoldt_no_eventual_complex_linear_recurrence
  refine ⟨r, fun j => (c j : ℂ), N0, ?_⟩
  intro n hn
  simpa only [Complex.ofReal_sum, Complex.ofReal_mul] using
    congrArg Complex.ofReal (hrec n hn)

example : Nonempty (ℕ × ℕ) := ⟨(0, 0)⟩
example : Nonempty ℂ := ⟨0⟩
example : (LinearRecurrence.mk 0 (fun j => Fin.elim0 j) : LinearRecurrence ℂ).IsSolution 0 :=
  by intro n; simp
example : ∃ N ≥ 0, ∀ j < 0, singleAddressReading (N + j) = 0 :=
  arbitrarily_late_vonMangoldt_zero_window 0 0

#print axioms arbitrarily_late_two_prime_factor_window
#print axioms arbitrarily_late_vonMangoldt_zero_window
#print axioms arbitrarily_late_prime_reading_positive
#print axioms vonMangoldt_no_eventual_complex_linear_recurrence
#print axioms vonMangoldt_no_eventual_real_linear_recurrence

end D5.S3.Weil.PrimeAddress.VonMangoldtRecurrence
