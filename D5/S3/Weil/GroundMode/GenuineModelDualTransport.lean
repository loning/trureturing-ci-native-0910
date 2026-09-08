#print axioms model_centered_projective_ratio_bound
#print axioms model_centered_normalized_uniform_limit
#print axioms prime_three_centered_budget


/-!
## Signed primal--dual defects for the same centered observable

The previous energy coefficient gives a robust sufficient rate. This section
keeps the complex residual pairing before taking a norm. Its remainder is a
product of the actual projective error and a complete dual residual, including
the independently bounded eigenvalue-shift uncertainty. No Galerkin
orthogonality, exact inverse, or discarded high-frequency residual is assumed.

The method is classical goal-oriented residual correction. Compare Wu--Zhang,
arXiv:2607.23850v1, Section 4, for corrected outputs with product remainders.
Their elliptic PDE hypotheses are not asserted for the Weil realization.
-/

/-- Repairing a trial along a unit Rayleigh model leaves its pairing with
the FULL model residual unchanged. Symmetry rewrites that pairing using the
actual action on the original trial. No finite-support claim is made for
either action. Symmetry derives the zero imaginary part of the Rayleigh pairing. -/
theorem model_repair_preserves_residual_pairing
    (ι M : E →ₗ[ℂ] H) (e v : E) (mu : ℝ) (beta : ℂ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (he : ‖ι e‖ = 1) (hmu : (⟪ι e, M e⟫_ℂ).re = mu) :
    ⟪ι (v - beta • e), M e - (mu : ℂ) • ι e⟫_ℂ =
      ⟪M v, ι e⟫_ℂ - (mu : ℂ) * ⟪ι v, ι e⟫_ℂ := by
  have hdiag : ⟪ι e, M e⟫_ℂ = (mu : ℂ) := by
    have hc : ⟪ι e, M e⟫_ℂ = conj ⟪ι e, M e⟫_ℂ :=
      (hsym e e).trans (inner_conj_symm (M e) (ι e)).symm
    have hi := congrArg Complex.im hc
    simp only [Complex.conj_im] at hi
    apply Complex.ext
    · simpa only [Complex.ofReal_re] using hmu
    · simp only [Complex.ofReal_im]
      linarith
  have hr : ⟪ι e, M e - (mu : ℂ) • ι e⟫_ℂ = 0 := by
    rw [inner_sub_right, inner_smul_right, hdiag, unit_self (ι e) he,
      mul_one, sub_self]
  rw [map_sub, map_smul, inner_sub_left, inner_smul_left, hr,
    mul_zero, sub_zero, inner_sub_right, inner_smul_right, hsym v e]

/-- Exact signed output identity for a domain eigenvector p aligned with e.
The arbitrary real shift sigma need not equal the unknown eigenvalue.
Its difference from lam is retained. The dual residual is projected only
because the actual error p-e is e-orthogonal, not because it is truncated. -/
theorem centered_goal_residual_identity
    (ι M : E →ₗ[ℂ] H) (e p v : E) (h : H) (lam sigma : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (heigen : M p = (lam : ℂ) • ι p)
    (hv : ⟪ι e, ι v⟫_ℂ = 0) (hzero : ⟪h, ι e⟫_ℂ = 0)
    (horth : ⟪ι e, ι (p - e)⟫_ℂ = 0) :
    let r := M e - (sigma : ℂ) • ι e
    let s := h - (M v - (sigma : ℂ) • ι v)
    ⟪h, ι p⟫_ℂ + ⟪ι v, r⟫_ℂ =
      ⟪s - ⟪ι e, s⟫_ℂ • ι e, ι (p - e)⟫_ℂ +
        ((lam - sigma : ℝ) : ℂ) * ⟪ι v, ι (p - e)⟫_ℂ := by
  let w : E := p - e
  let r := M e - (sigma : ℂ) • ι e
  let s := h - (M v - (sigma : ℂ) • ι v)
  have hve : ⟪ι v, ι e⟫_ℂ = 0 := inner_eq_zero_symm.mp hv
  have hMw : ⟪ι v, M w⟫_ℂ =
      (lam : ℂ) * ⟪ι v, ι w⟫_ℂ - ⟪ι v, r⟫_ℂ := by
    simp only [w, r, map_sub, heigen, inner_sub_right, inner_smul_right,
      hve, mul_zero, sub_zero]
  have hread : ⟪h, ι w⟫_ℂ = ⟪h, ι p⟫_ℂ := by
    simp only [w, map_sub, inner_sub_right, hzero, sub_zero]
  have hproj : ⟪s - ⟪ι e, s⟫_ℂ • ι e, ι w⟫_ℂ = ⟪s, ι w⟫_ℂ := by
    rw [inner_sub_left, inner_smul_left]
    change ⟪s, ι w⟫_ℂ - _ * ⟪ι e, ι (p - e)⟫_ℂ = _
    rw [horth, mul_zero, sub_zero]
  have hdual : ⟪s, ι w⟫_ℂ =
      ⟪h, ι p⟫_ℂ - ⟪ι v, M w⟫_ℂ + (sigma : ℂ) * ⟪ι v, ι w⟫_ℂ := by
    simp only [s, inner_sub_left, inner_smul_left, Complex.conj_ofReal]
    rw [← hsym v w, hread]
    ring
  change ⟪h, ι p⟫_ℂ + ⟪ι v, r⟫_ℂ =
    ⟪s - ⟪ι e, s⟫_ℂ • ι e, ι w⟫_ℂ +
      ((lam - sigma : ℝ) : ℂ) * ⟪ι v, ι w⟫_ℂ
  rw [hproj, hdual, hMw, Complex.ofReal_sub]
  ring

/-- The exact complex correction is -<v,r>. The certified disk around it
has radius (S+eta*V)*R. S is the norm bound for the COMPLETE projected dual
residual, eta bounds the real eigenvalue uncertainty, and R bounds the
actual error. No model residual norm is substituted for its signed pairing. -/
theorem centered_goal_residual_bound
    (ι M : E →ₗ[ℂ] H) (e p v : E) (h : H) (lam sigma S eta V R : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (heigen : M p = (lam : ℂ) • ι p)
    (hv : ⟪ι e, ι v⟫_ℂ = 0) (hzero : ⟪h, ι e⟫_ℂ = 0)
    (horth : ⟪ι e, ι (p - e)⟫_ℂ = 0)
    (hS : let s := h - (M v - (sigma : ℂ) • ι v)
      ‖s - ⟪ι e, s⟫_ℂ • ι e‖ ≤ S)
    (heta : |lam - sigma| ≤ eta) (hV : ‖ι v‖ ≤ V)
    (hR : ‖ι (p - e)‖ ≤ R) :
    ‖⟪h, ι p⟫_ℂ + ⟪ι v, M e - (sigma : ℂ) • ι e⟫_ℂ‖ ≤
      (S + eta * V) * R := by
  let s := h - (M v - (sigma : ℂ) • ι v)
  let w : E := p - e
  have hS0 : 0 ≤ S := (norm_nonneg _).trans hS
  have heta0 : 0 ≤ eta := (abs_nonneg _).trans heta
  have hV0 : 0 ≤ V := (norm_nonneg _).trans hV
  have hR0 : 0 ≤ R := (norm_nonneg _).trans hR
  have hfirst : ‖⟪s - ⟪ι e, s⟫_ℂ • ι e, ι w⟫_ℂ‖ ≤ S * R :=
    (norm_inner_le_norm _ _).trans (mul_le_mul hS hR (norm_nonneg _) hS0)
  have hsecond : ‖((lam - sigma : ℝ) : ℂ) * ⟪ι v, ι w⟫_ℂ‖ ≤ eta * (V * R) := by
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs]
    exact mul_le_mul heta ((norm_inner_le_norm _ _).trans
      (mul_le_mul hV hR (norm_nonneg _) hV0)) (norm_nonneg _) heta0
  rw [centered_goal_residual_identity ι M e p v h lam sigma hsym heigen hv hzero horth]
  exact (norm_add_le _ _).trans (by nlinarith only [hfirst, hsecond])

/-- Normalize the signed correction by the MODEL origin, which is known.
The denominator perturbation contributes a second product term and is not
silently replaced by the model value. Both actual and model anchors are
proved nonzero from b+G0*R<=b0<=|<g0,e>|. The p here is an actual aligned
eigenvector; the next consumer constructs it from an arbitrary eigenvector. -/
theorem centered_goal_corrected_ratio_bound
    (ι M : E →ₗ[ℂ] H) (e p v : E) (g0 g : H)
    (lam sigma S eta V R G0 b b0 : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (heigen : M p = (lam : ℂ) • ι p)
    (he : ‖ι e‖ = 1) (hpe : ⟪ι e, ι p⟫_ℂ = 1)
    (hv : ⟪ι e, ι v⟫_ℂ = 0)
    (hR : ‖ι (p - e)‖ ≤ R) (hV : ‖ι v‖ ≤ V)
    (heta : |lam - sigma| ≤ eta) (hG0 : ‖g0‖ ≤ G0)
    (hb : 0 < b) (hb0 : 0 < b0)
    (hmodel : b0 ≤ ‖⟪g0, ι e⟫_ℂ‖) (hanchor : b + G0 * R ≤ b0)
    (hS : let h := g - conj (⟪g, ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ) • g0
      let s := h - (M v - (sigma : ℂ) • ι v)
      ‖s - ⟪ι e, s⟫_ℂ • ι e‖ ≤ S) :
    ⟪g0, ι p⟫_ℂ ≠ 0 ∧
      ‖⟪g, ι p⟫_ℂ / ⟪g0, ι p⟫_ℂ - ⟪g, ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ +
        ⟪ι v, M e - (sigma : ℂ) • ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ‖ ≤
        (S + eta * V) * R / b +
          ‖⟪ι v, M e - (sigma : ℂ) • ι e⟫_ℂ‖ * G0 * R / (b0 * b) := by
  let de := ⟪g0, ι e⟫_ℂ
  let dp := ⟪g0, ι p⟫_ℂ
  let h := g - conj (⟪g, ι e⟫_ℂ / de) • g0
  let D := ⟪ι v, M e - (sigma : ℂ) • ι e⟫_ℂ
  have hG00 : 0 ≤ G0 := (norm_nonneg _).trans hG0
  have hR0 : 0 ≤ R := (norm_nonneg _).trans hR
  have hde : de ≠ 0 := norm_pos_iff.mp (hb0.trans_le hmodel)
  have horth : ⟪ι e, ι (p - e)⟫_ℂ = 0 := by
    rw [map_sub, inner_sub_right, hpe, unit_self (ι e) he, sub_self]
  have hdelta : ‖dp - de‖ ≤ G0 * R := by
    change ‖⟪g0, ι p⟫_ℂ - ⟪g0, ι e⟫_ℂ‖ ≤ _
    rw [← inner_sub_right, ← map_sub]
    exact (norm_inner_le_norm _ _).trans
      (mul_le_mul hG0 hR (norm_nonneg _) hG00)
  have hdpbound : b ≤ ‖dp‖ := by
    have ht := norm_sub_norm_le de dp
    rw [norm_sub_rev] at ht
    linarith
  have hdp : dp ≠ 0 := norm_pos_iff.mp (hb.trans_le hdpbound)
  obtain ⟨hz, hratio⟩ := model_centered_readout_identity g0 g (ι e) hde
  have hrem := centered_goal_residual_bound ι M e p v h lam sigma S eta V R
    hsym heigen hv hz horth hS heta hV hR
  have hS0 : 0 ≤ S := (norm_nonneg _).trans hS
  have heta0 : 0 ≤ eta := (abs_nonneg _).trans heta
  have hV0 : 0 ≤ V := (norm_nonneg _).trans hV
  have hiden : ⟪g, ι p⟫_ℂ / dp - ⟪g, ι e⟫_ℂ / de + D / de =
      (⟪h, ι p⟫_ℂ + D) / dp + D * (dp - de) / (de * dp) := by
    rw [hratio (ι p) hdp]
    change ⟪h, ι p⟫_ℂ / dp + D / de = _
    field_simp [hde, hdp]
    <;> ring
  have hfirst : ‖(⟪h, ι p⟫_ℂ + D) / dp‖ ≤ (S + eta * V) * R / b := by
    rw [norm_div]
    exact (div_le_div_of_nonneg_right hrem (norm_nonneg dp)).trans
      (div_le_div_of_nonneg_left (by positivity) hb hdpbound)
  have hsecond : ‖D * (dp - de) / (de * dp)‖ ≤ ‖D‖ * G0 * R / (b0 * b) := by
    rw [norm_div, norm_mul, norm_mul]
    have hden := mul_le_mul hmodel hdpbound hb.le (norm_nonneg de)
    calc
      _ ≤ (‖D‖ * (G0 * R)) / (‖de‖ * ‖dp‖) :=
        div_le_div_of_nonneg_right
          (mul_le_mul_of_nonneg_left hdelta (norm_nonneg D)) (by positivity)
      _ ≤ (‖D‖ * (G0 * R)) / (b0 * b) :=
        div_le_div_of_nonneg_left (by positivity) (mul_pos hb0 hb) hden
      _ = _ := by ring
  refine ⟨hdp, ?_⟩
  change ‖⟪g, ι p⟫_ℂ / dp - ⟪g, ι e⟫_ℂ / de + D / de‖ ≤ _
  rw [hiden]
  exact (norm_add_le _ _).trans (add_le_add hfirst hsecond)

/-- Construct the aligned eigenvector and its norm-error radius using the
existing Rayleigh enclosure, then consume the signed correction theorem.
Every occurrence of the target mode is the actual u. The complete dual
residual and signed model pairing remain quantities to certify, not a
supplied desired output estimate. The corrected model's own limiting
correction must vanish before identifying its limit with the original model. -/
theorem projective_goal_corrected_ratio_bound
    (ι M : E →ₗ[ℂ] H) (e u v : E) (g0 g : H)
    (lam nu kap sigma S eta V R G0 b b0 : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (he : ‖ι e‖ = 1) (hu : ι u ≠ 0)
    (heigen : M u = (lam : ℂ) • ι u)
    (hlam0 : 0 ≤ lam) (hlam : lam < kap)
    (heenergy : (⟪ι e, M e⟫_ℂ).re ≤ nu) (hnu : nu < kap)
    (hgap : ∀ f : E, ⟪ι e, ι f⟫_ℂ = 0 →
      kap * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hR0 : 0 ≤ R) (hR : nu ≤ kap * R ^ 2)
    (hv : ⟪ι e, ι v⟫_ℂ = 0) (hV : ‖ι v‖ ≤ V)
    (heta : |lam - sigma| ≤ eta) (hG0 : ‖g0‖ ≤ G0)
    (hb : 0 < b) (hb0 : 0 < b0)
    (hmodel : b0 ≤ ‖⟪g0, ι e⟫_ℂ‖) (hanchor : b + G0 * R ≤ b0)
    (hS : let h := g - conj (⟪g, ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ) • g0
      let s := h - (M v - (sigma : ℂ) • ι v)
      ‖s - ⟪ι e, s⟫_ℂ • ι e‖ ≤ S) :
    ⟪g0, ι u⟫_ℂ ≠ 0 ∧
      ‖⟪g, ι u⟫_ℂ / ⟪g0, ι u⟫_ℂ - ⟪g, ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ +
        ⟪ι v, M e - (sigma : ℂ) • ι e⟫_ℂ / ⟪g0, ι e⟫_ℂ‖ ≤
        (S + eta * V) * R / b +
          ‖⟪ι v, M e - (sigma : ℂ) • ι e⟫_ℂ‖ * G0 * R / (b0 * b) := by
  obtain ⟨ha, _, _, _, hnorm, _, _⟩ := projective_rayleigh_enclosure ι M e u
    0 nu kap lam hsym he hu heigen hlam0 hlam heenergy hnu hgap
  let alpha := ⟪ι e, ι u⟫_ℂ
  let p : E := alpha⁻¹ • u
  have hkap : 0 < kap := lt_of_le_of_lt hlam0 hlam
  have hnorm' : ‖ι (p - e)‖ ^ 2 ≤ nu / kap := by simpa only [sub_zero] using hnorm
  have hradius : ‖ι (p - e)‖ ≤ R := by
    have hh : nu / kap ≤ R ^ 2 := (div_le_iff₀ hkap).mpr (by simpa [mul_comm] using hR)
    nlinarith [hnorm'.trans hh, norm_nonneg (ι (p - e))]
  have hp : M p = (lam : ℂ) • ι p := by
    simp only [p, map_smul, heigen, smul_smul]
    rw [mul_comm (alpha⁻¹) (lam : ℂ)]
  have hpe : ⟪ι e, ι p⟫_ℂ = 1 := by
    simp only [p, map_smul, inner_smul_right]
    exact inv_mul_cancel₀ ha
  obtain ⟨hdp, hout⟩ := centered_goal_corrected_ratio_bound ι M e p v g0 g
    lam sigma S eta V R G0 b b0 hsym hp he hpe hv hradius hV heta hG0 hb hb0
    hmodel hanchor hS
  have hdu : ⟪g0, ι u⟫_ℂ ≠ 0 := by
    intro hz
    apply hdp
    simp only [p, map_smul, inner_smul_right, hz, mul_zero]
  have hrat : ⟪g, ι p⟫_ℂ / ⟪g0, ι p⟫_ℂ = ⟪g, ι u⟫_ℂ / ⟪g0, ι u⟫_ℂ := by
    simp only [p, map_smul, inner_smul_right]
    exact mul_div_mul_left _ _ (inv_ne_zero ha)
  exact ⟨hdu, by simpa only [hrat] using hout⟩

/-- A finite-head model pairing with both tails retained. The old finite
candidate is orthogonal to the action tail. Its distance to the true model
therefore bounds the tail pairing, while the separate model-approximation
error pays for replacing the head readout by a polynomial model. -/
theorem model_pairing_finite_head_bound (aHead aTail e eApprox k : H)
    (htail : ⟪aTail, k⟫_ℂ = 0) :
    ‖⟪aHead + aTail, e⟫_ℂ - ⟪aHead, eApprox⟫_ℂ‖ ≤
      ‖aTail‖ * ‖e - k‖ + ‖aHead‖ * ‖e - eApprox‖ := by
  have hid : ⟪aHead + aTail, e⟫_ℂ - ⟪aHead, eApprox⟫_ℂ =
      ⟪aTail, e - k⟫_ℂ + ⟪aHead, e - eApprox⟫_ℂ := by
    simp only [inner_add_left, inner_sub_right, htail, sub_zero]
    ring
  rw [hid]
  exact (norm_add_le _ _).trans
    (add_le_add (norm_inner_le_norm _ _) (norm_inner_le_norm _ _))

/-- Unit normalization and a certified captured head give an independent
upper bound on the entire model tail. The approximation radius is subtracted
before squaring. This is the finite-energy complement used by the numerical
pairing consumer; a small difference of two energies is not rounded inward. -/
theorem model_tail_sq_from_captured_head (eHead eTail approxHead : H) (gamma : ℝ)
    (hunit : ‖eHead + eTail‖ = 1) (horth : ⟪eHead, eTail⟫_ℂ = 0)
    (happrox : ‖eHead - approxHead‖ ≤ gamma)
    (hgamma : gamma ≤ ‖approxHead‖) :
    ‖eTail‖ ^ 2 ≤ 1 - (‖approxHead‖ - gamma) ^ 2 := by
  have hrev := norm_sub_norm_le approxHead eHead
  rw [norm_sub_rev] at hrev
  have hlow : ‖approxHead‖ - gamma ≤ ‖eHead‖ := by linarith
  have hsq := pow_le_pow_left₀ (sub_nonneg.mpr hgamma) hlow 2
  have hpy := norm_add_sq (𝕜 := ℂ) eHead eTail
  rw [hunit, horth] at hpy
  simp only [one_pow, Complex.zero_re, mul_zero, add_zero] at hpy
  linarith

/-- Exact rounded-budget consumer for the already identified c=3 data.
The scalar pairing interval, complete dual residual and inherited spectral
hypotheses remain independent premises of the analytic application. -/
theorem prime_three_goal_correction_budget :
    let ell : ℝ := 2252813807 / 40960000000000000
    let kap := 3 / 250000 - ell
    let delta := 560909 / 10000000000000 - ell
    let nu := 929549 / 15625000000000 - ell
    let eps : ℝ := 113 / 100000
    let kp := kap * (1 - eps ^ 2) / (1 + 1 / 100000) -
      delta * eps ^ 2 / (1 / 100000)
    let eta := delta / 2
    nu < kp * (194 / 10000 : ℝ) ^ 2 ∧
      784 / 1000 + (21 / 20 : ℝ) * (194 / 10000) ≤ 805 / 1000 ∧
      357 / 10000 + eta * 7 + eps * (13 / 1000) +
        eps * 7 * (458331 / 5000000000) < (3572 / 100000 : ℝ) ∧
      (3572 / 100000 + eta * 7) * (194 / 10000) / (784 / 1000) +
        (544 / 100000000 : ℝ) * (21 / 20) * (194 / 10000) /
          ((805 / 1000) * (784 / 1000)) +
        (6 / 1000000000 : ℝ) / (805 / 1000) < 885 / 1000000 ∧
      ((544 / 100000000 : ℝ) + (3572 / 100000 + eta * 7) *
        (194 / 10000)) / (784 / 1000) < 891 / 1000000 := by
  norm_num

#print axioms model_pairing_finite_head_bound
#print axioms model_tail_sq_from_captured_head
#print axioms prime_three_goal_correction_budget

#print axioms model_repair_preserves_residual_pairing
#print axioms centered_goal_residual_identity
#print axioms centered_goal_residual_bound
#print axioms centered_goal_corrected_ratio_bound
#print axioms projective_goal_corrected_ratio_bound

end D5.S3.Weil.GroundMode.GenuineModelDualTransport
end
