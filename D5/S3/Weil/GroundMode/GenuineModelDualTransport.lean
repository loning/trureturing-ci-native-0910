#print axioms centered_goal_corrected_ratio_bound
#print axioms projective_goal_corrected_ratio_bound


/-!
## Close the signed certificate on an actual invariant domain

The stronger even-sector lower bound may be used only after restricting the
actual domain. The following consumer performs that restriction before
calling the existing positive-form and projective proofs. The Fourier dual
residual remains a full Hilbert-space vector. A finite pairing enclosure
and the final original-model limit are then accounted for separately.
-/

/-- With one fixed trial and spectral center, only the centered Riesz vector
changes across the frequency set. Orthogonal projection is contractive, so
its complete dual residual has a whole-neighborhood bound. No discarded
Fourier modes or sampled-only boundary assertion enter this theorem. -/
theorem signed_goal_residual_neighborhood
    (ι M : E →ₗ[ℂ] H) (e v : E) (h h0 : H) (sigma S radius : ℝ)
    (he : ‖ι e‖ = 1) (hd : ‖h - h0‖ ≤ radius)
    (hS : let s0 := h0 - (M v - (sigma : ℂ) • ι v)
      ‖s0 - ⟪ι e, s0⟫_ℂ • ι e‖ ≤ S) :
    let s := h - (M v - (sigma : ℂ) • ι v)
    ‖s - ⟪ι e, s⟫_ℂ • ι e‖ ≤ S + radius := by
  let s0 := h0 - (M v - (sigma : ℂ) • ι v)
  have hid : h - (M v - (sigma : ℂ) • ι v) = s0 + (h - h0) := by
    dsimp [s0]
    module
  change ‖off (ι e) (h - (M v - (sigma : ℂ) • ι v))‖ ≤ _
  rw [hid, off_add]
  exact (norm_add_le _ _).trans
    (add_le_add hS ((off_contract (ι e) (h - h0) he).trans hd))

/-- A sector certificate is consumed on a genuine restricted linear domain.
Every candidate, model, eigenvector and trial is a member of that submodule.
The positive-form lower bound is first transported inside it, and then the
existing actual-eigenvector signed ratio theorem is applied. No even-sector
gap is promoted to the whole Hilbert space. -/
theorem sector_projective_signed_ratio_bound
    (F : Submodule ℂ E) (ι M : E →ₗ[ℂ] H) (k e u v : E) (g0 g : H)
    (kappa delta eps t lam nu sigma S eta V R G0 b b0 : ℝ)
    (hkF : k ∈ F) (heF : e ∈ F) (huF : u ∈ F) (hvF : v ∈ F)
    (hsym : ∀ x y : E, ⟪ι x, M y⟫_ℂ = ⟪M x, ι y⟫_ℂ)
    (hpositive : ∀ f ∈ F, 0 ≤ (⟪ι f, M f⟫_ℂ).re)
    (hk : ‖ι k‖ = 1) (he : ‖ι e‖ = 1) (hu : ι u ≠ 0)
    (hkenergy : (⟪ι k, M k⟫_ℂ).re ≤ delta)
    (hkappa : 0 ≤ kappa) (heps : 0 ≤ eps) (ht : 0 < t)
    (hd : ‖ι e - ι k‖ ≤ eps)
    (hcoercive : ∀ f ∈ F, ⟪ι k, ι f⟫_ℂ = 0 →
      kappa * ‖ι f‖ ^ 2 ≤ (⟪ι f, M f⟫_ℂ).re)
    (heigen : M u = (lam : ℂ) • ι u) (hlam0 : 0 ≤ lam)
    (hlam : lam ≤ delta)
    (hfit : delta < kappa * (1 - eps ^ 2) / (1 + t) - delta * eps ^ 2 / t)
    (heenergy : (⟪ι e, M e⟫_ℂ).re ≤ nu)
    (hnu : nu < kappa * (1 - eps ^ 2) / (1 + t) - delta * eps ^ 2 / t)
    (hR0 : 0 ≤ R)
    (hR : nu ≤ (kappa * (1 - eps ^ 2) / (1 + t) - delta * eps ^ 2 / t) * R ^ 2)
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
  let iF : F →ₗ[ℂ] H := ι.comp F.subtype
  let mF : F →ₗ[ℂ] H := M.comp F.subtype
  let kF : F := ⟨k, hkF⟩
  let eF : F := ⟨e, heF⟩
  let uF : F := ⟨u, huF⟩
  let vF : F := ⟨v, hvF⟩
  have hsF : ∀ x y : F, ⟪iF x, mF y⟫_ℂ = ⟪mF x, iF y⟫_ℂ :=
    fun x y => hsym x y
  have hpF : ∀ f : F, 0 ≤ (⟪iF f, mF f⟫_ℂ).re :=
    fun f => hpositive f f.property
  have hcF : ∀ f : F, ⟪iF kF, iF f⟫_ℂ = 0 →
      kappa * ‖iF f‖ ^ 2 ≤ (⟪iF f, mF f⟫_ℂ).re :=
    fun f hf => hcoercive f f.property hf
  have hgap := positive_form_complement_coercivity iF mF kF eF
    kappa delta eps t hsF hpF hk hkenergy hkappa heps ht hd hcF
  exact projective_goal_corrected_ratio_bound iF mF eF uF vF g0 g
    lam nu (kappa * (1 - eps ^ 2) / (1 + t) - delta * eps ^ 2 / t)
    sigma S eta V R G0 b b0 hsF he hu heigen hlam0 (hlam.trans_lt hfit)
    heenergy hnu hgap hR0 hR hv hV heta hG0 hb hb0 hmodel hanchor hS

/-- A computed complex pairing enclosure can replace the exact signed
pairing in the corrected output, paying its full radius at the model origin.
The output disk is translated; no sign of the actual output is inferred. -/
theorem finite_pairing_corrected_ratio_bound (x model D approx de : ℂ)
    (error q b0 : ℝ) (hb0 : 0 < b0) (hde : b0 ≤ ‖de‖)
    (herror : ‖x - model + D / de‖ ≤ error) (hpair : ‖D - approx‖ ≤ q) :
    ‖x - model + approx / de‖ ≤ error + q / b0 := by
  have hq : 0 ≤ q := (norm_nonneg _).trans hpair
  have hnoise : ‖(approx - D) / de‖ ≤ q / b0 := by
    rw [norm_div, norm_sub_rev]
    exact (div_le_div_of_nonneg_right hpair (norm_nonneg de)).trans
      (div_le_div_of_nonneg_left hq hb0 hde)
  have hid : x - model + approx / de =
      (x - model + D / de) + (approx - D) / de := by
    rw [sub_div]
    ring
  rw [hid]
  exact (norm_add_le _ _).trans (add_le_add herror hnoise)

/-- Terminal original-model closure for actual varying-domain eigenvectors.
The complete signed pairing and product remainder are the physical inputs;
the desired ratio-error estimate is derived by the preceding eigenmode
owner. Convergence of the original model is kept separate from convergence
of a corrected surrogate. No arithmetic all-scale rate is manufactured. -/
theorem signed_goal_original_model_uniform_limit
    {Z : Type*} (K : Set Z) (limit : Z → ℂ)
    {Hs Es : ℕ → Type*}
    [∀ n, NormedAddCommGroup (Hs n)] [∀ n, InnerProductSpace ℂ (Hs n)]
    [∀ n, AddCommGroup (Es n)] [∀ n, Module ℂ (Es n)]
    (ι M : ∀ n, Es n →ₗ[ℂ] Hs n) (e u : ∀ n, Es n)
    (v : ∀ n, Z → Es n) (g0 : ∀ n, Hs n) (g : ∀ n, Z → Hs n)
    (lam nu kap sigma S eta V R G0 b b0 B : ℕ → ℝ)
    (hsym : ∀ n x y, ⟪ι n x, M n y⟫_ℂ = ⟪M n x, ι n y⟫_ℂ)
    (he : ∀ n, ‖ι n (e n)‖ = 1) (hu : ∀ n, ι n (u n) ≠ 0)
    (heigen : ∀ n, M n (u n) = (lam n : ℂ) • ι n (u n))
    (hlam0 : ∀ n, 0 ≤ lam n) (hlam : ∀ n, lam n < kap n)
    (heenergy : ∀ n, (⟪ι n (e n), M n (e n)⟫_ℂ).re ≤ nu n)
    (hnu : ∀ n, nu n < kap n)
    (hgap : ∀ n f, ⟪ι n (e n), ι n f⟫_ℂ = 0 →
      kap n * ‖ι n f‖ ^ 2 ≤ (⟪ι n f, M n f⟫_ℂ).re)
    (hR0 : ∀ n, 0 ≤ R n) (hR : ∀ n, nu n ≤ kap n * R n ^ 2)
    (hv : ∀ n z, z ∈ K → ⟪ι n (e n), ι n (v n z)⟫_ℂ = 0)
    (hV : ∀ n z, z ∈ K → ‖ι n (v n z)‖ ≤ V n)
    (heta : ∀ n, |lam n - sigma n| ≤ eta n)
    (hG0 : ∀ n, ‖g0 n‖ ≤ G0 n)
    (hb : ∀ n, 0 < b n) (hb0 : ∀ n, 0 < b0 n)
    (hmodel : ∀ n, b0 n ≤ ‖⟪g0 n, ι n (e n)⟫_ℂ‖)
    (hanchor : ∀ n, b n + G0 n * R n ≤ b0 n)
    (hS : ∀ n z, z ∈ K →
      let h := g n z - conj (⟪g n z, ι n (e n)⟫_ℂ / ⟪g0 n, ι n (e n)⟫_ℂ) • g0 n
      let s := h - (M n (v n z) - (sigma n : ℂ) • ι n (v n z))
      ‖s - ⟪ι n (e n), s⟫_ℂ • ι n (e n)‖ ≤ S n)
    (hB : ∀ n z, z ∈ K →
      ‖⟪ι n (v n z), M n (e n) - (sigma n : ℂ) • ι n (e n)⟫_ℂ‖ ≤ B n)
    (hdefect : Tendsto (fun n => B n / b0 n) atTop (nhds 0))
    (hremainder : Tendsto (fun n => (S n + eta n * V n) * R n / b n +
      B n * G0 n * R n / (b0 n * b n)) atTop (nhds 0))
    (hlimit : TendstoUniformlyOn (fun n z =>
      ⟪g n z, ι n (e n)⟫_ℂ / ⟪g0 n, ι n (e n)⟫_ℂ) limit atTop K) :
    TendstoUniformlyOn (fun n z =>
      ⟪g n z, ι n (u n)⟫_ℂ / ⟪g0 n, ι n (u n)⟫_ℂ) limit atTop K := by
  have htotal : Tendsto (fun n => ((S n + eta n * V n) * R n / b n +
      B n * G0 n * R n / (b0 n * b n)) + B n / b0 n) atTop (nhds 0) := by
    simpa only [zero_add] using hremainder.add hdefect
  apply Metric.tendstoUniformlyOn_iff.mpr
  intro eps heps
  have hp := (tendsto_order.mp htotal).2 (eps / 2) (by linarith)
  have hm := Metric.tendstoUniformlyOn_iff.mp hlimit (eps / 2) (by linarith)
  filter_upwards [hp, hm] with n hn hmn z hz
  let de := ⟪g0 n, ι n (e n)⟫_ℂ
  let d := ⟪ι n (v n z), M n (e n) - (sigma n : ℂ) • ι n (e n)⟫_ℂ
  let x := ⟪g n z, ι n (u n)⟫_ℂ / ⟪g0 n, ι n (u n)⟫_ℂ
  let m := ⟪g n z, ι n (e n)⟫_ℂ / de
  have hbound := (projective_goal_corrected_ratio_bound (ι n) (M n) (e n) (u n)
    (v n z) (g0 n) (g n z) (lam n) (nu n) (kap n) (sigma n) (S n) (eta n)
    (V n) (R n) (G0 n) (b n) (b0 n) (hsym n) (he n) (hu n) (heigen n)
    (hlam0 n) (hlam n) (heenergy n) (hnu n) (hgap n) (hR0 n) (hR n)
    (hv n z hz) (hV n z hz) (heta n) (hG0 n) (hb n) (hb0 n)
    (hmodel n) (hanchor n) (hS n z hz)).2
  have hB0 : 0 ≤ B n := (norm_nonneg _).trans (hB n z hz)
  have hG00 : 0 ≤ G0 n := (norm_nonneg _).trans (hG0 n)
  have hRn := hR0 n
  have hbn := hb n
  have hb0n := hb0 n
  have hcoeff : 0 ≤ G0 n * R n / (b0 n * b n) := by positivity
  have hterm := mul_le_mul_of_nonneg_right (hB n z hz) hcoeff
  have hcorr : ‖x - m + d / de‖ ≤ (S n + eta n * V n) * R n / b n +
      B n * G0 n * R n / (b0 n * b n) := by
    change ‖x - m + d / de‖ ≤ _ at hbound
    exact hbound.trans (add_le_add le_rfl (by simpa only [mul_div_assoc, mul_assoc] using hterm))
  have hd : ‖d / de‖ ≤ B n / b0 n := by
    rw [norm_div]
    exact (div_le_div_of_nonneg_right (hB n z hz) (norm_nonneg de)).trans
      (div_le_div_of_nonneg_left hB0 (hb0 n) (hmodel n))
  have hraw : ‖x - m‖ < eps / 2 := by
    have hid : x - m = (x - m + d / de) - d / de := by ring
    rw [hid]
    exact ((norm_sub_le _ _).trans (add_le_add hcorr hd)).trans_lt hn
  have hmodelclose : ‖m - limit z‖ < eps / 2 := by
    have hh := hmn z hz
    simpa only [dist_eq_norm, norm_sub_rev] using hh
  have hnorm : ‖x - limit z‖ < eps := by
    have hid : x - limit z = (x - m) + (m - limit z) := by ring
    rw [hid]
    have hh := (norm_add_le (x - m) (m - limit z)).trans_lt
      (add_lt_add hraw hmodelclose)
    linarith
  simpa only [dist_eq_norm, norm_sub_rev] using hnorm

/-- Exact synthesis of separately recorded sector and signed-pairing inputs.
The stronger gap is used only on the even restricted domain. No fresh
spectral, Fourier-model or interval certificate is asserted by norm_num. -/
theorem prime_three_sector_signed_budget :
    let ell : ℝ := 2252813807 / 40960000000000000
    let kappa := 1 / 1000 - ell
    let delta := 560909 / 10000000000000 - ell
    let nu := 929549 / 15625000000000 - ell
    let eps : ℝ := 113 / 100000
    let kp := kappa * (1 - eps ^ 2) / (1 + 1 / 100000) - delta * eps ^ 2 / (1 / 100000)
    let eta := delta / 2
    let S : ℝ := 3572 / 100000 + (8 / 5) * (1 / 1000)
    let R : ℝ := 212 / 100000
    let b : ℝ := 802 / 1000
    let b0 : ℝ := 805 / 1000
    let D : ℝ := 544 / 100000000
    let q : ℝ := 6 / 1000000000
    delta < kp ∧ nu < kp ∧ nu < kp * R ^ 2 ∧
      b + (21 / 20) * R < b0 ∧
      (S + eta * 7) * R / b + D * (21 / 20) * R / (b0 * b) + q / b0 <
        99 / 1000000 ∧
      (99 / 1000000 : ℝ) + (D + q) / b0 < 53 / 500000 ∧
      (53 / 500000 : ℝ) < 7 / 50000 := by
  norm_num

#print axioms signed_goal_residual_neighborhood
#print axioms sector_projective_signed_ratio_bound
#print axioms finite_pairing_corrected_ratio_bound
#print axioms signed_goal_original_model_uniform_limit
#print axioms prime_three_sector_signed_budget

end D5.S3.Weil.GroundMode.GenuineModelDualTransport
end
