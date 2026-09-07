/- GID: D5/S3/Weil/GroundMode/InvariantSectorEnergyReadout
   generality: G
   mirror-B: D5/B/S3/Weil/GroundMode/InvariantSectorEnergyReadout
   mirror-E: none(waiver:actual-invariant-domain-with-separate-arithmetic-Schur-certificate)
   anchors: []
   digest: Lift an invariant-sector energy readout without paying the opposite-sector gap and transport its centered frequency budget. -/

import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Module
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-!
# Invariant-sector energy readouts

The involution acts on the actual linear operator domain. Compatibility with
its Hilbert-space isometry and the action gives an exact even/odd energy
split. An invariant readout can use its sector's dual coefficient on the
whole candidate complement when the opposite sector has nonnegative SHIFTED
energy. No claim upgrades an even-sector gap to a full-space gap.

For the Weil consumer the symmetry is spatial reflection, the candidate and
the centered even Fourier Riesz vector are fixed, and the independent old
global lower bound supplies opposite-sector shifted positivity. The new
computer-assisted even Schur bound retains the entire Fourier exterior.
Its arithmetic/domain identification and interval engine are separate from
these Candidate Lean proof scripts. No all-scale rate or RH claim is made.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

noncomputable section
namespace D5.S3.Weil.GroundMode.InvariantSectorEnergyReadout

open scoped InnerProductSpace ComplexConjugate

variable {H E : Type*}
variable [NormedAddCommGroup H] [InnerProductSpace ℂ H]
variable [AddCommGroup E] [Module ℂ E]

private def plusPart (J : E →ₗ[ℂ] E) (f : E) : E := (1 / 2 : ℂ) • (f + J f)
private def minusPart (J : E →ₗ[ℂ] E) (f : E) : E := (1 / 2 : ℂ) • (f - J f)

private theorem energy_half (ι M : E →ₗ[ℂ] H) (f : E) :
    (⟪ι ((1 / 2 : ℂ) • f), M ((1 / 2 : ℂ) • f)⟫_ℂ).re =
      (⟪ι f, M f⟫_ℂ).re / 4 := by
  simp only [map_smul, inner_smul_left, inner_smul_right]
  norm_num [Complex.mul_re, Complex.mul_im] <;> ring

private theorem fixed_readout_plus
    (ι : E →ₗ[ℂ] H) (J : E →ₗ[ℂ] E) (U : H →ₗ[ℂ] H)
    (hι : ∀ f, ι (J f) = U (ι f))
    (hU : ∀ x y, ⟪U x, U y⟫_ℂ = ⟪x, y⟫_ℂ)
    (g : H) (hg : U g = g) (f : E) :
    ⟪g, ι (plusPart J f)⟫_ℂ = ⟪g, ι f⟫_ℂ := by
  have hj : ⟪g, ι (J f)⟫_ℂ = ⟪g, ι f⟫_ℂ := by
    calc
      _ = ⟪U g, U (ι f)⟫_ℂ := by rw [hι, hg]
      _ = _ := hU g (ι f)
  simp only [plusPart, map_smul, map_add, inner_smul_right, inner_add_right, hj]
  ring

/-- The actual domain involution gives two invariant summands and an exact
energy decomposition. No spectral gap or positivity is used in this identity. -/
theorem invariant_sector_energy_split
    (ι M : E →ₗ[ℂ] H) (J : E →ₗ[ℂ] E) (U : H →ₗ[ℂ] H)
    (hJ : ∀ f, J (J f) = f)
    (hι : ∀ f, ι (J f) = U (ι f)) (hM : ∀ f, M (J f) = U (M f))
    (hU : ∀ x y, ⟪U x, U y⟫_ℂ = ⟪x, y⟫_ℂ) (f : E) :
    let p := (1 / 2 : ℂ) • (f + J f)
    let m := (1 / 2 : ℂ) • (f - J f)
    J p = p ∧ J m = -m ∧
      (⟪ι f, M f⟫_ℂ).re = (⟪ι p, M p⟫_ℂ).re + (⟪ι m, M m⟫_ℂ).re := by
  dsimp only
  have hp : J ((1 / 2 : ℂ) • (f + J f)) = (1 / 2 : ℂ) • (f + J f) := by
    simp only [map_smul, map_add, hJ]
    module
  have hm : J ((1 / 2 : ℂ) • (f - J f)) = -((1 / 2 : ℂ) • (f - J f)) := by
    simp only [map_smul, map_sub, hJ]
    module
  have henergy : (⟪ι (J f), M (J f)⟫_ℂ).re = (⟪ι f, M f⟫_ℂ).re := by
    rw [hι, hM, hU]
  have hsum : (⟪ι (f + J f), M (f + J f)⟫_ℂ).re +
      (⟪ι (f - J f), M (f - J f)⟫_ℂ).re =
      2 * (⟪ι f, M f⟫_ℂ).re + 2 * (⟪ι (J f), M (J f)⟫_ℂ).re := by
    simp only [map_add, map_sub, inner_add_left, inner_add_right,
      inner_sub_left, inner_sub_right, Complex.add_re, Complex.sub_re]
    ring
  refine ⟨hp, hm, ?_⟩
  rw [energy_half, energy_half]
  linarith

/-- An invariant readout pays only its own sector's dual coefficient.
Nonnegative energy on the opposite sector is essential, but its positive
gap is unnecessary. The full-space coercivity is not enlarged by this lift. -/
theorem invariant_sector_readout_lift
    (ι M : E →ₗ[ℂ] H) (J : E →ₗ[ℂ] E) (U : H →ₗ[ℂ] H)
    (hJ : ∀ f, J (J f) = f)
    (hι : ∀ f, ι (J f) = U (ι f)) (hM : ∀ f, M (J f) = U (M f))
    (hU : ∀ x y, ⟪U x, U y⟫_ℂ = ⟪x, y⟫_ℂ)
    (k : E) (hk : J k = k) (g : H) (hg : U g = g) (C : ℝ) (hC : 0 ≤ C)
    (hnegativeSector : ∀ f : E, J f = -f → 0 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hsector : ∀ f : E, J f = f → ⟪ι k, ι f⟫_ℂ = 0 →
      ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤ C * (⟪ι f, M f⟫_ℂ).re) :
    ∀ f : E, ⟪ι k, ι f⟫_ℂ = 0 →
      ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤ C * (⟪ι f, M f⟫_ℂ).re := by
  intro f hf
  let p := plusPart J f
  let m := minusPart J f
  obtain ⟨hp, hm, hsum⟩ := invariant_sector_energy_split ι M J U hJ hι hM hU f
  have hkU : U (ι k) = ι k := by rw [← hι, hk]
  have hkp : ⟪ι k, ι p⟫_ℂ = 0 := by
    rw [fixed_readout_plus ι J U hι hU (ι k) hkU f]
    exact hf
  have hgpair : ⟪g, ι p⟫_ℂ = ⟪g, ι f⟫_ℂ := fixed_readout_plus ι J U hι hU g hg f
  have hodd : 0 ≤ (⟪ι m, M m⟫_ℂ).re := hnegativeSector m hm
  have hle : (⟪ι p, M p⟫_ℂ).re ≤ (⟪ι f, M f⟫_ℂ).re := by
    change (⟪ι f, M f⟫_ℂ).re = (⟪ι p, M p⟫_ℂ).re + (⟪ι m, M m⟫_ℂ).re at hsum
    linarith
  have hbound := hsector p hp hkp
  rw [hgpair] at hbound
  exact hbound.trans (mul_le_mul_of_nonneg_left hle hC)

private theorem complex_norm_add_young (x y : ℂ) (s : ℝ) (hs : 0 < s) :
    ‖x + y‖ ^ 2 ≤ (1 + s) * ‖x‖ ^ 2 + (1 + 1 / s) * ‖y‖ ^ 2 := by
  have htri := pow_le_pow_left₀ (norm_nonneg _) (norm_add_le x y) 2
  have hcross : 2 * ‖x‖ * ‖y‖ ≤ s * ‖x‖ ^ 2 + ‖y‖ ^ 2 / s := by
    have hh := sq_nonneg (s * ‖x‖ - ‖y‖)
    have hd : 0 ≤ (s * ‖x‖ - ‖y‖) ^ 2 / s := div_nonneg hh hs.le
    have hi : (s * ‖x‖ - ‖y‖) ^ 2 / s =
        s * ‖x‖ ^ 2 - 2 * ‖x‖ * ‖y‖ + ‖y‖ ^ 2 / s := by
      field_simp [hs.ne']
      <;> ring
    rw [hi] at hd
    linarith
  nlinarith

/-- Uniform readout variation can be paid within the same coercive sector.
This supplies a whole frequency neighborhood from a centered full-residual
certificate and a genuine Riesz-vector variation bound. -/
theorem sector_readout_neighborhood
    (ι M : E →ₗ[ℂ] H) (J : E →ₗ[ℂ] E) (k : E)
    (g g' : H) (C kap radius s : ℝ) (hC : 0 ≤ C) (hkap : 0 < kap)
    (hradius : 0 ≤ radius) (hs : 0 < s) (hd : ‖g' - g‖ ≤ radius)
    (hgap : ∀ f : E, J f = f → ⟪ι k, ι f⟫_ℂ = 0 →
      kap * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hdual : ∀ f : E, J f = f → ⟪ι k, ι f⟫_ℂ = 0 →
      ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤ C * (⟪ι f, M f⟫_ℂ).re) :
    ∀ f : E, J f = f → ⟪ι k, ι f⟫_ℂ = 0 →
      ‖⟪g', ι f⟫_ℂ‖ ^ 2 ≤
        ((1 + s) * C + (1 + 1 / s) * radius ^ 2 / kap) * (⟪ι f, M f⟫_ℂ).re := by
  intro f hJf hf
  have hq := hgap f hJf hf
  have hnorm : ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re / kap := by
    apply (le_div_iff₀ hkap).mpr
    simpa only [mul_comm] using hq
  have hnoise : ‖⟪g' - g, ι f⟫_ℂ‖ ^ 2 ≤
      radius ^ 2 * ((⟪ι f, M f⟫_ℂ).re / kap) := by
    have hn := (norm_inner_le_norm (g' - g) (ι f)).trans
      (mul_le_mul_of_nonneg_right hd (norm_nonneg _))
    calc
      _ ≤ (radius * ‖ι f‖) ^ 2 := pow_le_pow_left₀ (norm_nonneg _) hn 2
      _ = radius ^ 2 * ‖ι f‖ ^ 2 := by ring
      _ ≤ _ := mul_le_mul_of_nonneg_left hnorm (sq_nonneg _)
  have hsum : ⟪g', ι f⟫_ℂ = ⟪g, ι f⟫_ℂ + ⟪g' - g, ι f⟫_ℂ := by
    rw [inner_sub_left]
    ring
  rw [hsum]
  have h := complex_norm_add_young ⟪g, ι f⟫_ℂ ⟪g' - g, ι f⟫_ℂ s hs
  calc
    _ ≤ _ := h
    _ ≤ (1 + s) * (C * (⟪ι f, M f⟫_ℂ).re) +
        (1 + 1 / s) * (radius ^ 2 * ((⟪ι f, M f⟫_ℂ).re / kap)) :=
      add_le_add (mul_le_mul_of_nonneg_left (hdual f hJf hf) (by positivity))
        (mul_le_mul_of_nonneg_left hnoise (by positivity))
    _ = _ := by ring

/-- The exact model-centered functional has a quantitative variation bound.
The model is unit and its origin denominator is explicit and nonzero. No
independent variation of the model ratio is silently discarded. -/
theorem centered_readout_variation (g0 g g' e : H) (he : ‖e‖ = 1)
    (hanchor : ⟪g0, e⟫_ℂ ≠ 0) :
    ‖(g' - conj (⟪g', e⟫_ℂ / ⟪g0, e⟫_ℂ) • g0) -
        (g - conj (⟪g, e⟫_ℂ / ⟪g0, e⟫_ℂ) • g0)‖ ≤
      ‖g' - g‖ * (1 + ‖g0‖ / ‖⟪g0, e⟫_ℂ‖) := by
  have hidentity :
      (g' - conj (⟪g', e⟫_ℂ / ⟪g0, e⟫_ℂ) • g0) -
        (g - conj (⟪g, e⟫_ℂ / ⟪g0, e⟫_ℂ) • g0) =
      (g' - g) - conj (⟪g' - g, e⟫_ℂ / ⟪g0, e⟫_ℂ) • g0 := by
    rw [inner_sub_left, sub_div, map_sub]
    module
  have hpair : ‖⟪g' - g, e⟫_ℂ‖ ≤ ‖g' - g‖ := by
    simpa only [he, mul_one] using norm_inner_le_norm (g' - g) e
  rw [hidentity]
  calc
    _ ≤ ‖g' - g‖ + ‖conj (⟪g' - g, e⟫_ℂ / ⟪g0, e⟫_ℂ) • g0‖ := norm_sub_le _ _
    _ = ‖g' - g‖ + (‖⟪g' - g, e⟫_ℂ‖ / ‖⟪g0, e⟫_ℂ‖) * ‖g0‖ := by
      rw [norm_smul, Complex.norm_conj, norm_div]
    _ ≤ ‖g' - g‖ + (‖g' - g‖ / ‖⟪g0, e⟫_ℂ‖) * ‖g0‖ :=
      add_le_add_left (mul_le_mul_of_nonneg_right
        (div_le_div_of_nonneg_right hpair (norm_nonneg _)) (norm_nonneg _)) _
    _ = _ := by ring

/-- Exact arithmetic on the independently certified even Schur threshold,
complete centered residual and full disk variation. It does not prove the
interval or arithmetic operator identifications which supply those numbers. -/
theorem prime_three_invariant_sector_budget :
    let ell : ℝ := 2252813807 / 40960000000000000
    let C := 1173667110482754901 / 1000000000000000000 +
      (238949697113753 / 200000000000000000 + 19725952049051 / 250000000000000000) /
        (1 / 1000 - ell)
    let diskC := (31 / 30 : ℝ) * (49 / 20) + 31 * (8 / 5000 : ℝ) ^ 2 / (999 / 1000000)
    let nu := 929549 / 15625000000000 - ell
    (999 / 1000000 : ℝ) < 1 / 1000 - ell ∧
      C < 49 / 20 ∧ diskC < 21 / 8 ∧
      (20001 / 20000 : ℝ) * (21 / 8) * nu / (39 / 50 : ℝ) ^ 2 < (7 / 50000 : ℝ) ^ 2 := by
  norm_num

#print axioms invariant_sector_energy_split
#print axioms invariant_sector_readout_lift
#print axioms sector_readout_neighborhood
#print axioms centered_readout_variation
#print axioms prime_three_invariant_sector_budget

end D5.S3.Weil.GroundMode.InvariantSectorEnergyReadout
end
