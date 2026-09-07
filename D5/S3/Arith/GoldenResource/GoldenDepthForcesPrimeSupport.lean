/- GID: D5/S3/Arith/GoldenResource/GoldenDepthForcesPrimeSupport
   generality: I
   mirror-B: D5/B/S3/Arith/GoldenResource/GoldenDepthForcesPrimeSupport
   mirror-E: none(waiver:evidence-not-specified-by-formal-manifest)
   anchors: []
   utility: none
   digest: Two-adic depth forces prime divisibility through an explicit logarithmic bound. -/

import D5.S3.Arith.GoldenResource.GoldenResourcePriceInterval

/- Library-search audit trail (2026-09-07):
   D5 searches at 6634808834, preceded by positive theorem controls, found the frozen
   price criterion, layer decrease, geometric bound and first-layer prime decrease,
   but no criterion with (p + 1) * log p <= (2^(k+1) - 2) * log 2.
   Pinned Mathlib v4.33.0 Log.Basic and Lean LSP confirm log_lt_sub_one_of_pos,
   log_inv and one_sub_inv_le_log_of_pos (the last is only non-strict).
   The alternative lt_log_one_add_of_pos bounds by 2*x/(x+2), not the source expression.
   Loogle independently confirms the strict upper bound; GitHub Lean code search
   for colossally returned no hits, with a positive Mathlib code-search control.
   No matching theorem was found in those searched scopes.

   Preregistered escape witness 30: strict reciprocal logarithm estimates separate
   the first layer at p from the kth layer at 2. Both estimates below are on the
   live path from the price inequality to the contradiction with an unadopted layer.
   The frozen geometric upper bound does not provide this strict separation.
   Computational content: none; arbitrary N, p, k, with no finite enumeration.
   Signature echo: retain the positive-natural hypothesis; derive k >= 1 from the
   displayed bound, since its right side vanishes at k = 0. No extra depth-domain
   hypothesis is imposed. Equality in the displayed bound is allowed. -/

namespace D5.S3.Arith.GoldenResource.GoldenDepthForcesPrimeSupport

open D5.S3.Arith.GoldenResourceOptimalInteger
open D5.S3.Arith.GoldenResource.GoldenResourceThresholdCriterion
open D5.S3.Arith.GoldenResource.GoldenResourcePriceInterval

/-- Sufficient two-adic depth forces every prime below the explicit logarithmic threshold. -/
theorem prime_dvd_of_two_adic_depth (N p k : ℕ) (hN : 1 ≤ N)
    (hCA : IsColossallyAbundant N) (hp : Nat.Prime p)
    (hdepth : k ≤ N.factorization 2)
    (hprice : ((p : ℝ) + 1) * Real.log (p : ℝ) ≤
      ((2 : ℝ) ^ (k + 1) - 2) * Real.log 2) : p ∣ N := by
  have hpPos : (0 : ℝ) < p := by exact_mod_cast hp.pos
  have hpLog : 0 < Real.log (p : ℝ) :=
    Real.log_pos (by exact_mod_cast hp.one_lt)
  have htwoLog : 0 < Real.log (2 : ℝ) := Real.log_pos (by norm_num)
  have hleftPos : 0 < ((p : ℝ) + 1) * Real.log (p : ℝ) :=
    mul_pos (by positivity) hpLog
  have hk : 1 ≤ k := by
    by_contra h
    have hk0 : k = 0 := by omega
    simp only [hk0, Nat.zero_add, pow_one, sub_self, zero_mul] at hprice
    exact (not_le_of_gt hleftPos) hprice
  have hscale : 0 < (2 : ℝ) ^ (k + 1) - 2 :=
    (mul_pos_iff_of_pos_right htwoLog).mp (hleftPos.trans_le hprice)
  have hpow : 1 < (2 : ℝ) ^ k := by
    rw [pow_succ] at hscale
    linarith
  have htwoEq : goldenLayerMarginal 2 k =
      Real.log (1 + 1 / ((2 : ℝ) ^ (k + 1) - 2)) / Real.log 2 := by
    unfold goldenLayerMarginal
    simp only [Nat.cast_ofNat]
    congr 2
    have hpow0 : (2 : ℝ) ^ k ≠ 0 := pow_ne_zero _ (by norm_num)
    have hpow1 : (2 : ℝ) ^ k - 1 ≠ 0 := (sub_pos.mpr hpow).ne'
    have hscale0 : (2 : ℝ) ^ k * 2 - 2 ≠ 0 := by
      simpa only [pow_succ] using hscale.ne'
    rw [inv_pow, inv_pow, pow_succ]
    field_simp [hpow0, hpow1, hscale0]
    <;> ring
  have htwoUpper : goldenLayerMarginal 2 k <
      1 / (((2 : ℝ) ^ (k + 1) - 2) * Real.log 2) := by
    rw [htwoEq]
    have hx : 0 < 1 / ((2 : ℝ) ^ (k + 1) - 2) := one_div_pos.mpr hscale
    have hlog := Real.log_lt_sub_one_of_pos (by positivity :
      0 < 1 + 1 / ((2 : ℝ) ^ (k + 1) - 2)) (by linarith :
      1 + 1 / ((2 : ℝ) ^ (k + 1) - 2) ≠ 1)
    rw [← div_div]
    exact (div_lt_div_iff_of_pos_right htwoLog).mpr (by linarith)
  have hiLt : (p : ℝ)⁻¹ < 1 :=
    (inv_lt_one₀ hpPos).mpr (by exact_mod_cast hp.one_lt)
  have hfirstEq : goldenLayerMarginal p 1 =
      Real.log (1 + (p : ℝ)⁻¹) / Real.log p := by
    unfold goldenLayerMarginal
    congr 2
    simp only [pow_one]
    apply (div_eq_iff (sub_pos.mpr hiLt).ne').mpr
    ring
  have hxOne : 1 < 1 + (p : ℝ)⁻¹ :=
    lt_add_of_pos_right 1 (inv_pos.mpr hpPos)
  have hxPos : 0 < 1 + (p : ℝ)⁻¹ := by positivity
  have hlogInv := Real.log_lt_sub_one_of_pos (inv_pos.mpr hxPos)
    (ne_of_lt ((inv_lt_one₀ hxPos).mpr hxOne))
  rw [Real.log_inv] at hlogInv
  have hreciprocal : 1 - (1 + (p : ℝ)⁻¹)⁻¹ = 1 / ((p : ℝ) + 1) := by
    field_simp
    <;> ring
  have hprimeLower : 1 / (((p : ℝ) + 1) * Real.log p) <
      goldenLayerMarginal p 1 := by
    rw [hfirstEq, ← div_div]
    exact (div_lt_div_iff_of_pos_right hpLog).mpr (by linarith)
  obtain ⟨lambda, hlambda, hopt⟩ := hCA
  obtain ⟨hnext, hlast⟩ := (golden_resource_optimal_iff_layer_thresholds hlambda hN).mp hopt
  have htwoDvd : 2 ∣ N := Nat.dvd_of_factorization_pos (by omega)
  have hlastLe : goldenLayerMarginal 2 (N.factorization 2) ≤ goldenLayerMarginal 2 k := by
    rcases hdepth.eq_or_lt with heq | hlt
    · rw [heq]
    · exact (golden_layer_strict_decrease Nat.prime_two hk hlt).le
  have hgap : lambda < goldenLayerMarginal p 1 := calc
    lambda ≤ goldenLayerMarginal 2 k := (hlast 2 Nat.prime_two htwoDvd).trans hlastLe
    _ < 1 / (((2 : ℝ) ^ (k + 1) - 2) * Real.log 2) := htwoUpper
    _ ≤ 1 / (((p : ℝ) + 1) * Real.log p) := one_div_le_one_div_of_le hleftPos hprice
    _ < goldenLayerMarginal p 1 := hprimeLower
  by_contra hnot
  have hreject := hnext p hp
  rw [Nat.factorization_eq_zero_of_not_dvd hnot, Nat.zero_add] at hreject
  exact (not_lt_of_ge hreject) hgap

#print axioms prime_dvd_of_two_adic_depth

end D5.S3.Arith.GoldenResource.GoldenDepthForcesPrimeSupport
