#print axioms recentered_trial_objective_bound
#print axioms recentered_dual_coefficient_bound


/-!
## Positive shifted-form transport

The following alternative USES the additional whole-domain certificate
`0 <= Re <iota f, M f>`. It is justified by an independently proved lower
bound A >= ell when M=A-ell*iota; ell may be negative. It is not an
assumption of unshifted Weil positivity at every window.

The old graph-residual route above remains available without this premise.
Here positive quadratic-form arithmetic transfers the coercive complement
and the READOUT INEQUALITY directly. No new trial is repaired, no norm of
M e is evaluated, and no projected infinite correction is thrown away.
-/

private theorem energy_smul_for_positive_transport (ι M : E →ₗ[ℂ] H)
    (f : E) (a : ℂ) :
    (⟪ι (a • f), M (a • f)⟫_ℂ).re =
      ‖a‖ ^ 2 * (⟪ι f, M f⟫_ℂ).re := by
  simp only [map_smul, inner_smul_left, inner_smul_right]
  simp only [← Complex.normSq_eq_norm_sq, Complex.normSq_apply,
    Complex.mul_re, Complex.mul_im, Complex.conj_re, Complex.conj_im]
  ring

private theorem positive_energy_young
    (ι M : E →ₗ[ℂ] H)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (hpositive : ∀ f : E, 0 ≤ (⟪ι f, M f⟫_ℂ).re)
    (f k : E) (a : ℂ) (t : ℝ) (ht : 0 < t) :
    (⟪ι (f - a • k), M (f - a • k)⟫_ℂ).re ≤
      (1 + t) * (⟪ι f, M f⟫_ℂ).re +
        (1 + 1 / t) * ‖a‖ ^ 2 * (⟪ι k, M k⟫_ℂ).re := by
  have hplus := energy_sub_smul ι M hsym ((t : ℂ) • f) k (-a)
  have hcross : ((-a) * ⟪ι ((t : ℂ) • f), M k⟫_ℂ).re =
      -t * (a * ⟪ι f, M k⟫_ℂ).re := by
    simp only [map_smul, inner_smul_left]
    simp only [Complex.mul_re, Complex.mul_im, Complex.neg_re, Complex.neg_im,
      Complex.conj_re, Complex.conj_im, Complex.ofReal_re, Complex.ofReal_im]
    ring
  rw [energy_smul_for_positive_transport, norm_neg, hcross,
    Complex.norm_real, Real.norm_eq_abs, sq_abs] at hplus
  have hn := hpositive (((t : ℂ) • f) - (-a) • k)
  rw [hplus] at hn
  rw [energy_sub_smul ι M hsym f k a]
  apply (mul_le_mul_left ht).mp
  have hid : t * ((1 + t) * (⟪ι f, M f⟫_ℂ).re +
      (1 + 1 / t) * ‖a‖ ^ 2 * (⟪ι k, M k⟫_ℂ).re) -
      t * ((⟪ι f, M f⟫_ℂ).re + ‖a‖ ^ 2 * (⟪ι k, M k⟫_ℂ).re -
        2 * (a * ⟪ι f, M k⟫_ℂ).re) =
      t ^ 2 * (⟪ι f, M f⟫_ℂ).re + ‖a‖ ^ 2 * (⟪ι k, M k⟫_ℂ).re +
        2 * t * (a * ⟪ι f, M k⟫_ℂ).re := by
    field_simp [ht.ne']
    <;> ring
  nlinarith

private theorem norm_add_square_young (x y : ℂ) (s : ℝ) (hs : 0 < s) :
    ‖x + y‖ ^ 2 ≤ (1 + s) * ‖x‖ ^ 2 + (1 + 1 / s) * ‖y‖ ^ 2 := by
  have ht := pow_le_pow_left₀ (norm_nonneg (x + y)) (norm_add_le x y) 2
  have hmul := mul_le_mul_of_nonneg_left ht hs.le
  have hid : s * ((1 + s) * ‖x‖ ^ 2 + (1 + 1 / s) * ‖y‖ ^ 2) -
      s * (‖x‖ + ‖y‖) ^ 2 = (s * ‖x‖ - ‖y‖) ^ 2 := by
    field_simp [hs.ne']
    <;> ring
  apply (mul_le_mul_left hs).mp
  nlinarith [sq_nonneg (s * ‖x‖ - ‖y‖)]

/-- A positive SHIFTED form transfers complement coercivity using the old
candidate's energy delta, rather than the norm of the genuine-model action.
The scalar t is any positive balancing parameter. The derived threshold
may be negative; its positivity is checked separately by the consumer. -/
theorem positive_form_complement_coercivity
    (ι M : E →ₗ[ℂ] H) (k e : E) (kappa delta eps t : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (hpositive : ∀ f : E, 0 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hk : ‖ι k‖ = 1) (hkenergy : (⟪ι k, M k⟫_ℂ).re ≤ delta)
    (hkappa : 0 ≤ kappa) (heps : 0 ≤ eps) (ht : 0 < t)
    (hd : ‖ι e - ι k‖ ≤ eps)
    (hcoercive : ∀ f : E, ⟪ι k, ι f⟫_ℂ = 0 →
      kappa * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re) :
    ∀ f : E, ⟪ι e, ι f⟫_ℂ = 0 →
      (kappa * (1 - eps ^ 2) / (1 + t) - delta * eps ^ 2 / t) * ‖ι f‖ ^ 2 ≤
        (⟪ι f, M f⟫_ℂ).re := by
  intro f hf
  let a : ℂ := ⟪ι k, ι f⟫_ℂ
  let v : E := f - a • k
  have hdelta : 0 ≤ delta := (hpositive k).trans hkenergy
  have htp : 0 < 1 + t := by linarith
  have hv : ⟪ι k, ι v⟫_ℂ = 0 := by
    simp only [v, map_sub, map_smul, inner_sub_right, inner_smul_right,
      unit_self (ι k) hk, mul_one, a, sub_self]
  have himage : ι v = off (ι k) (ι f) := by simp only [v, off, map_sub, map_smul, a]
  have hn : ‖ι v‖ ^ 2 = ‖ι f‖ ^ 2 - ‖a‖ ^ 2 := by
    rw [himage, off_norm_sq (ι k) (ι f) hk]
  have ha := near_orthogonal_overlap (ι e) (ι k) (ι f) eps
    (by simpa only [norm_sub_rev] using hd) hf
  have ha2 : ‖a‖ ^ 2 ≤ eps ^ 2 * ‖ι f‖ ^ 2 := by
    simpa only [mul_pow] using pow_le_pow_left₀ (norm_nonneg _) ha 2
  have hy := positive_energy_young ι M hsym hpositive f k a t ht
  have hqc := hcoercive v hv
  rw [hn] at hqc
  have henergy := mul_le_mul_of_nonneg_left hkenergy
    (by positivity : 0 ≤ (1 + 1 / t) * ‖a‖ ^ 2)
  have hcoef : 0 ≤ kappa + (1 + 1 / t) * delta := by positivity
  have hangle := mul_le_mul_of_nonneg_left ha2 hcoef
  have hcombined : (kappa - (kappa + (1 + 1 / t) * delta) * eps ^ 2) *
      ‖ι f‖ ^ 2 ≤ (1 + t) * (⟪ι f, M f⟫_ℂ).re := by
    change (⟪ι v, M v⟫_ℂ).re ≤ _ at hy
    nlinarith
  apply (mul_le_mul_left htp).mp
  calc
    _ = (kappa - (kappa + (1 + 1 / t) * delta) * eps ^ 2) * ‖ι f‖ ^ 2 := by
      field_simp [ht.ne', htp.ne']
      <;> ring
    _ ≤ _ := hcombined

/-- Transport an already proved energy-dual READOUT inequality directly.
No repaired trial, inverse, model Rayleigh residual or graph norm is an
input. The old full-space lower certificate is essential and explicit.
The gain G controls the old candidate's readout, and the same g occurs on
both complements. The two positive balancing parameters are independent. -/
theorem positive_form_readout_transport
    (ι M : E →ₗ[ℂ] H) (k e : E) (g : H) (kappa delta eps t s C G : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (hpositive : ∀ f : E, 0 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hk : ‖ι k‖ = 1) (hkenergy : (⟪ι k, M k⟫_ℂ).re ≤ delta)
    (hkappa : 0 ≤ kappa) (heps : 0 ≤ eps) (ht : 0 < t) (hs : 0 < s)
    (hd : ‖ι e - ι k‖ ≤ eps)
    (hcoercive : ∀ f : E, ⟪ι k, ι f⟫_ℂ = 0 →
      kappa * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hC : 0 ≤ C) (hG : ‖⟪g, ι k⟫_ℂ‖ ≤ G)
    (hreadout : ∀ f : E, ⟪ι k, ι f⟫_ℂ = 0 →
      ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤ C * (⟪ι f, M f⟫_ℂ).re)
    (hmargin : 0 < kappa * (1 - eps ^ 2) / (1 + t) - delta * eps ^ 2 / t) :
    let kp := kappa * (1 - eps ^ 2) / (1 + t) - delta * eps ^ 2 / t
    ∀ f : E, ⟪ι e, ι f⟫_ℂ = 0 →
      ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤
        ((1 + s) * (1 + t) * C + eps ^ 2 / kp *
          ((1 + s) * (1 + 1 / t) * C * delta + (1 + 1 / s) * G ^ 2)) *
            (⟪ι f, M f⟫_ℂ).re := by
  dsimp only
  intro f hf
  let kp := kappa * (1 - eps ^ 2) / (1 + t) - delta * eps ^ 2 / t
  let a : ℂ := ⟪ι k, ι f⟫_ℂ
  let v : E := f - a • k
  let Q := (⟪ι f, M f⟫_ℂ).re
  let B := (1 + s) * (1 + 1 / t) * C * delta + (1 + 1 / s) * G ^ 2
  have hdelta : 0 ≤ delta := (hpositive k).trans hkenergy
  have hG0 : 0 ≤ G := (norm_nonneg _).trans hG
  have hB : 0 ≤ B := by dsimp [B]; positivity
  have hv : ⟪ι k, ι v⟫_ℂ = 0 := by
    simp only [v, map_sub, map_smul, inner_sub_right, inner_smul_right,
      unit_self (ι k) hk, mul_one, a, sub_self]
  have hnew := positive_form_complement_coercivity ι M k e kappa delta eps t
    hsym hpositive hk hkenergy hkappa heps ht hd hcoercive f hf
  have hnorm : ‖ι f‖ ^ 2 ≤ Q / kp := by
    apply (le_div_iff₀ hmargin).mpr
    simpa only [mul_comm] using hnew
  have ha := near_orthogonal_overlap (ι e) (ι k) (ι f) eps
    (by simpa only [norm_sub_rev] using hd) hf
  have ha2 : ‖a‖ ^ 2 ≤ eps ^ 2 * Q / kp := by
    calc
      _ ≤ eps ^ 2 * ‖ι f‖ ^ 2 := by
        simpa only [mul_pow] using pow_le_pow_left₀ (norm_nonneg _) ha 2
      _ ≤ eps ^ 2 * (Q / kp) := mul_le_mul_of_nonneg_left hnorm (sq_nonneg eps)
      _ = _ := by ring
  have hdecomp : ⟪g, ι f⟫_ℂ = ⟪g, ι v⟫_ℂ + a * ⟪g, ι k⟫_ℂ := by
    simp only [v, map_sub, map_smul, inner_sub_right, inner_smul_right, sub_add_cancel]
  have hy := norm_add_square_young ⟪g, ι v⟫_ℂ (a * ⟪g, ι k⟫_ℂ) s hs
  rw [← hdecomp, norm_mul, mul_pow] at hy
  have hvread := mul_le_mul_of_nonneg_left (hreadout v hv)
    (by positivity : 0 ≤ 1 + s)
  have hyenergy := positive_energy_young ι M hsym hpositive f k a t ht
  have hqk := mul_le_mul_of_nonneg_left hkenergy
    (by positivity : 0 ≤ (1 + 1 / t) * ‖a‖ ^ 2)
  have hyenergy' : (⟪ι v, M v⟫_ℂ).re ≤
      (1 + t) * Q + (1 + 1 / t) * ‖a‖ ^ 2 * delta := by
    change (⟪ι v, M v⟫_ℂ).re ≤ _ at hyenergy
    dsimp [Q]
    linarith
  have hqvmul := mul_le_mul_of_nonneg_left hyenergy'
    (by positivity : 0 ≤ (1 + s) * C)
  have hG2 := mul_le_mul_of_nonneg_left
    (pow_le_pow_left₀ (norm_nonneg _) hG 2)
    (by positivity : 0 ≤ (1 + 1 / s) * ‖a‖ ^ 2)
  have hcore : ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤ (1 + s) * (1 + t) * C * Q + B * ‖a‖ ^ 2 := by
    dsimp [B]
    nlinarith
  calc
    _ ≤ (1 + s) * (1 + t) * C * Q + B * ‖a‖ ^ 2 := hcore
    _ ≤ (1 + s) * (1 + t) * C * Q + B * (eps ^ 2 * Q / kp) :=
      add_le_add_left (mul_le_mul_of_nonneg_left ha2 hB) _
    _ = _ := by dsimp [B, Q, kp]; ring

/-- A root-free scale criterion. Under eps^2*(kappa/2+delta)<=kappa/4,
the genuine complement retains at least kappa/4 and its readout coefficient
is bounded by 8*C+8*eps^2*G^2/kappa. Thus the additional normalized scale cost
is quadratic in eps and contains no full-model residual rho. -/
theorem positive_form_uniform_readout_bound
    (ι M : E →ₗ[ℂ] H) (k e : E) (g : H) (kappa delta eps C G : ℝ)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (hpositive : ∀ f : E, 0 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hk : ‖ι k‖ = 1) (hkenergy : (⟪ι k, M k⟫_ℂ).re ≤ delta)
    (hkappa : 0 < kappa) (heps : 0 ≤ eps) (hd : ‖ι e - ι k‖ ≤ eps)
    (hcoercive : ∀ f : E, ⟪ι k, ι f⟫_ℂ = 0 →
      kappa * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hC : 0 ≤ C) (hG : ‖⟪g, ι k⟫_ℂ‖ ≤ G)
    (hreadout : ∀ f : E, ⟪ι k, ι f⟫_ℂ = 0 →
      ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤ C * (⟪ι f, M f⟫_ℂ).re)
    (hangle : eps ^ 2 * (kappa / 2 + delta) ≤ kappa / 4) :
    ∀ f : E, ⟪ι e, ι f⟫_ℂ = 0 →
      (kappa / 4) * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re ∧
      ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤ (8 * C + 8 * eps ^ 2 * G ^ 2 / kappa) *
        (⟪ι f, M f⟫_ℂ).re := by
  intro f hf
  let kp := kappa * (1 - eps ^ 2) / 2 - delta * eps ^ 2
  have hdelta : 0 ≤ delta := (hpositive k).trans hkenergy
  have hkp : kappa / 4 ≤ kp := by dsimp [kp]; nlinarith
  have hkp0 : 0 < kp := lt_of_lt_of_le (by positivity) hkp
  have hgap := positive_form_complement_coercivity ι M k e kappa delta eps 1
    hsym hpositive hk hkenergy hkappa.le heps (by norm_num) hd hcoercive f hf
  have hgap' : kp * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re := by
    simpa only [one_add_one_eq_two, div_one] using hgap
  have hr := positive_form_readout_transport ι M k e g kappa delta eps 1 1 C G
    hsym hpositive hk hkenergy hkappa.le heps (by norm_num) (by norm_num) hd hcoercive
    hC hG hreadout (by simpa only [one_add_one_eq_two, div_one] using hkp0) f hf
  have hr' : ‖⟪g, ι f⟫_ℂ‖ ^ 2 ≤
      (4 * C + eps ^ 2 / kp * (4 * C * delta + 2 * G ^ 2)) *
        (⟪ι f, M f⟫_ℂ).re := by
    simpa only [one_add_one_eq_two, div_one, one_div_one,
      show (2 : ℝ) * 2 = 4 by norm_num] using hr
  have hepd : eps ^ 2 * delta ≤ kp := by
    have hnon := mul_nonneg (sq_nonneg eps) hkappa.le
    nlinarith
  have hratio : eps ^ 2 * delta / kp ≤ 1 := (div_le_iff₀ hkp0).mpr (by simpa using hepd)
  have hlast : 2 * eps ^ 2 * G ^ 2 / kp ≤ 2 * eps ^ 2 * G ^ 2 / (kappa / 4) :=
    div_le_div_of_nonneg_left (by positivity) (by positivity) hkp
  have hcap : 4 * C + eps ^ 2 / kp * (4 * C * delta + 2 * G ^ 2) ≤
      8 * C + 8 * eps ^ 2 * G ^ 2 / kappa := by
    calc
      _ = 4 * C + 4 * C * (eps ^ 2 * delta / kp) + 2 * eps ^ 2 * G ^ 2 / kp := by ring
      _ ≤ 4 * C + 4 * C + 2 * eps ^ 2 * G ^ 2 / (kappa / 4) := by
        have hc := mul_le_mul_of_nonneg_left hratio (by positivity : 0 ≤ 4 * C)
        linarith
      _ = _ := by field_simp [hkappa.ne']; ring
  exact ⟨(mul_le_mul_of_nonneg_right hkp (sq_nonneg _)).trans hgap',
    hr'.trans (mul_le_mul_of_nonneg_right hcap (hpositive f))⟩

/-- Exact arithmetic on the existing c=3 certificates. This certifies the
new scalar implications only: it does not reprove the original global
spectral lower bound, candidate energy or genuine-model approximation. -/
theorem prime_three_positive_form_budget :
    let ell : ℝ := 2252813807 / 40960000000000000
    let kappa := 3 / 250000 - ell
    let delta := 560909 / 10000000000000 - ell
    let eps : ℝ := 113 / 100000
    let t : ℝ := 1 / 100000
    let s : ℝ := 1 / 10000
    let kp := kappa * (1 - eps ^ 2) / (1 + t) - delta * eps ^ 2 / t
    let C := (1 + s) * (1 + t) * 103 + eps ^ 2 / kp *
      ((1 + s) * (1 + 1 / t) * 103 * delta + (1 + 1 / s) * (1 / 500 : ℝ) ^ 2)
    kappa * (99997 / 100000) < kp ∧ C < 5151 / 50 ∧
      (929549 / 15625000000000 - ell) * (5151 / 50) < (681 / 1000000 : ℝ) ^ 2 := by
  norm_num

#print axioms positive_form_complement_coercivity
#print axioms positive_form_readout_transport
#print axioms positive_form_uniform_readout_bound
#print axioms prime_three_positive_form_budget

end D5.S3.Weil.GroundMode.GenuineModelDualTransport
end
