/- GID: D5/S3/Factorization/TwinPrimeSigmaGcdDivisibility
   generality: I
   mirror-B: D5/B/S3/Factorization/TwinPrimeSigmaGcdDivisibility
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Every twin-prime center with prime sigma-gcd is divisible by 18. -/

import Mathlib.NumberTheory.ArithmeticFunction.Misc
import Mathlib.Tactic

namespace D5.S3.Factorization.TwinPrimeSigmaGcdDivisibility

local notation "σ" => ArithmeticFunction.sigma 1

theorem even_center {k : ℕ} (hk : 1 < k) (hp : Nat.Prime (k - 1))
    (hq : Nat.Prime (k + 1)) : 2 ∣ k := by
  by_contra hnot
  have hodd : k % 2 = 1 := by omega
  have hsub : (k - 1) % 2 = 0 := by omega
  have hadd : (k + 1) % 2 = 0 := by omega
  rcases hp.eq_two_or_odd with heq | hpodd
  · rcases hq.eq_two_or_odd with heq' | hqodd
    · omega
    · omega
  · omega

theorem three_center {k : ℕ} (hk : 1 < k) (hp : Nat.Prime (k - 1))
    (hq : Nat.Prime (k + 1)) (hg : Nat.Prime (Nat.gcd k (σ k)))
    (heven : 2 ∣ k) : 3 ∣ k := by
  by_cases hsmall : k < 6
  · have hk_cases : k = 2 ∨ k = 3 ∨ k = 4 ∨ k = 5 := by omega
    rcases hk_cases with rfl | rfl | rfl | rfl
    · norm_num at hp
    · norm_num
    · have hs : σ 4 = 7 := by
        rw [show 4 = 2 ^ 2 by norm_num,
          ArithmeticFunction.sigma_one_apply_prime_pow (by norm_num : Nat.Prime 2)]
        norm_num
      rw [hs] at hg
      norm_num at hg
    · norm_num at hp
  have hsub : 3 < k - 1 := by omega
  have hadd : 3 < k + 1 := by omega
  have hsub3 : (k - 1) % 3 ≠ 0 := by
    intro h
    have hd : 3 ∣ k - 1 := Nat.dvd_of_mod_eq_zero h
    rcases (Nat.dvd_prime hp).1 hd with h1 | heq
    · norm_num at h1
    · omega
  have hadd3 : (k + 1) % 3 ≠ 0 := by
    intro h
    have hd : 3 ∣ k + 1 := Nat.dvd_of_mod_eq_zero h
    rcases (Nat.dvd_prime hq).1 hd with h1 | heq
    · norm_num at h1
    · omega
  by_cases hzero : k % 3 = 0
  · exact Nat.dvd_of_mod_eq_zero hzero
  have hlt : k % 3 < 3 := Nat.mod_lt _ (by norm_num)
  have hpos : 0 < k % 3 := Nat.pos_of_ne_zero hzero
  interval_cases hres : k % 3 <;> omega

private lemma sigma_three_factor {k m : ℕ} (hk : k = 3 * m) (hm : ¬3 ∣ m) :
    4 ∣ σ k := by
  have hc : Nat.Coprime 3 m :=
    (Nat.Prime.coprime_iff_not_dvd (by norm_num : Nat.Prime 3)).2 hm
  rw [hk]
  rw [ArithmeticFunction.isMultiplicative_sigma.map_mul_of_coprime hc]
  have hsig : ArithmeticFunction.sigma 1 3 = 4 := by
    convert ArithmeticFunction.sigma_one_apply_prime_pow (p := 3) (i := 1)
      (by norm_num : Nat.Prime 3) using 1 <;> norm_num
  rw [hsig]
  exact dvd_mul_of_dvd_left (dvd_refl 4) _

private lemma sigma_two_factor {k r : ℕ} (hk : k = 2 * r) (hr : ¬2 ∣ r) :
    3 ∣ σ k := by
  have hc : Nat.Coprime 2 r :=
    (Nat.Prime.coprime_iff_not_dvd (by norm_num : Nat.Prime 2)).2 hr
  rw [hk]
  rw [ArithmeticFunction.isMultiplicative_sigma.map_mul_of_coprime hc]
  have hsig : ArithmeticFunction.sigma 1 2 = 3 := by
    convert ArithmeticFunction.sigma_one_apply_prime_pow (p := 2) (i := 1)
      (by norm_num : Nat.Prime 2) using 1 <;> norm_num
  rw [hsig]
  exact dvd_mul_of_dvd_left (dvd_refl 3) _

private lemma not_prime_of_dvd_four {d : ℕ} (hd : Nat.Prime d) (h : 4 ∣ d) : False := by
  have h2 : 2 ∣ d := dvd_trans (by norm_num) h
  rcases (Nat.dvd_prime hd).1 h2 with h1 | rfl
  · norm_num at h1
  · norm_num at h

private lemma not_prime_of_dvd_six {d : ℕ} (hd : Nat.Prime d) (h : 6 ∣ d) : False := by
  have h2 : 2 ∣ d := dvd_trans (by norm_num) h
  have h3 : 3 ∣ d := dvd_trans (by norm_num) h
  rcases (Nat.dvd_prime hd).1 h2 with h1 | rfl
  · norm_num at h1
  · norm_num at h3

/-- A single factor of three forces a composite divisor of the sigma-gcd. -/
theorem four_or_six_dvd_gcd {k : ℕ} (heven : 2 ∣ k) (hthree : 3 ∣ k)
    (h9 : ¬9 ∣ k) : 4 ∣ Nat.gcd k (σ k) ∨ 6 ∣ Nat.gcd k (σ k) := by
  let m := k / 3
  have hkm : k = 3 * m := by
    dsimp [m]
    omega
  have hm : ¬3 ∣ m := by
    intro hm
    apply h9
    rw [hkm]
    rcases hm with ⟨t, ht⟩
    refine ⟨t, ?_⟩
    omega
  have hs4 : 4 ∣ σ k := sigma_three_factor hkm hm
  by_cases h4 : 4 ∣ k
  · exact Or.inl (Nat.dvd_gcd h4 hs4)
  · let r := k / 2
    have hkr : k = 2 * r := by
      dsimp [r]
      omega
    have hr : ¬2 ∣ r := by
      intro hr
      apply h4
      rw [hkr]
      rcases hr with ⟨t, ht⟩
      refine ⟨t, ?_⟩
      omega
    have hs3 : 3 ∣ σ k := sigma_two_factor hkr hr
    have hs6 : 6 ∣ Nat.gcd k (σ k) :=
      Nat.Coprime.mul_dvd_of_dvd_of_dvd (by norm_num)
        (Nat.dvd_gcd heven (dvd_trans (by norm_num) hs4))
        (Nat.dvd_gcd hthree hs3)
    exact Or.inr hs6

/-- Every term of OEIS A394757 is divisible by 18. -/
theorem sigma_gcd_divisibility {k : ℕ} (hk : 1 < k) (hp : Nat.Prime (k - 1))
    (hq : Nat.Prime (k + 1)) (hg : Nat.Prime (Nat.gcd k (σ k))) : 18 ∣ k := by
  have heven : 2 ∣ k := even_center hk hp hq
  have hthree : 3 ∣ k := three_center hk hp hq hg heven
  have h9 : 9 ∣ k := by
    by_contra h9
    rcases four_or_six_dvd_gcd heven hthree h9 with h4 | h6
    · exact not_prime_of_dvd_four hg h4
    · exact not_prime_of_dvd_six hg h6
  exact Nat.Coprime.mul_dvd_of_dvd_of_dvd (by norm_num : Nat.Coprime 2 9) heven h9

#print axioms sigma_gcd_divisibility
#print axioms even_center
#print axioms three_center
#print axioms four_or_six_dvd_gcd

end D5.S3.Factorization.TwinPrimeSigmaGcdDivisibility
