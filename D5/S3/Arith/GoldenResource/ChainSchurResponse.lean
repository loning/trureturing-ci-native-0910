/- GID: D5/S3/Arith/GoldenResource/ChainSchurResponse
   generality: G
   mirror-B: D5/B/S3/Arith/GoldenResource/ChainSchurResponse
   mirror-E: none(waiver:general-matrix-family)
   anchors: []
   utility: none
   digest: Chain Schur responses have exact linear coefficients and a quadratic remainder. -/

import D5.S3.Arith.GoldenResource.ChainBlockPencil
import Mathlib.LinearAlgebra.Matrix.SchurComplement
import Mathlib.Analysis.Matrix.Normed

namespace D5.S3.Arith.GoldenResource.ChainSchurResponse

open Matrix TridiagonalChainInverse ChainBlockPencil
open scoped BigOperators Matrix.Norms.Operator

noncomputable section

/-- Two uses of the inverse-difference identity give an exact second-order remainder. -/
theorem inverse_first_order {ι : Type*} [Fintype ι] [DecidableEq ι]
    (A E : Matrix ι ι ℝ) (hA : IsUnit A) (hAE : IsUnit (A + E)) :
    (A + E)⁻¹ = A⁻¹ - A⁻¹ * E * A⁻¹ + A⁻¹ * E * A⁻¹ * E * (A + E)⁻¹ := by
  have h := Matrix.inv_sub_inv (show IsUnit A ↔ IsUnit (A + E) from
    ⟨fun _ => hAE, fun _ => hA⟩)
  rw [add_sub_cancel_left] at h
  have hfirst : (A + E)⁻¹ = A⁻¹ - A⁻¹ * E * (A + E)⁻¹ := by
    rw [← h]
    abel
  calc
    (A + E)⁻¹ = A⁻¹ - A⁻¹ * E * (A + E)⁻¹ := hfirst
    _ = A⁻¹ - A⁻¹ * E * (A⁻¹ - A⁻¹ * E * (A + E)⁻¹) := by
      conv_lhs => arg 2; arg 2; rw [hfirst]
    _ = _ := by noncomm_ring

/-- The first inverse column of one chain; chain length is `n + 1`. -/
def w (n : ℕ) : Fin (n + 1) → ℝ := (H (n + 1))⁻¹ *ᵥ Pi.single 0 1

/-- The common visible mass coefficient, using the Euclidean sum of squares. -/
def z (n : ℕ) : ℝ := 1 + ∑ i, w n i ^ 2

/-- Transfer from the first to the last vertex of one chain. -/
def t (n : ℕ) : ℝ := w n (Fin.last n)

/-- The endpoint square divided by the common mass coefficient. -/
def eta (n : ℕ) : ℝ := t n ^ 2 / z n

/-- The hidden spatial block is taken from the existing block pencil. -/
def hiddenSpatial (n : ℕ) (k b : ℝ) : Matrix (Hidden n) (Hidden n) ℝ :=
  (G n k b).submatrix Sum.inr Sum.inr

/-- The hidden perturbation of the mass matrix. -/
def perturbation (n : ℕ) (k b s μ : ℝ) : Matrix (Hidden n) (Hidden n) ℝ :=
  μ • hiddenSpatial n k b - s • 1

/-- The visible Schur response of the two-chain pencil. -/
def response (n : ℕ) (k b s μ : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  (1 + k * μ - s) • 1 -
    B n * (hiddenBlock n + perturbation n k b s μ)⁻¹ * (B n)ᵀ

/-- The negative spectral coefficient before normalization. -/
def Z (n : ℕ) : Matrix (Fin 2) (Fin 2) ℝ :=
  1 + (B n * (hiddenBlock n)⁻¹) * ((hiddenBlock n)⁻¹ * (B n)ᵀ)

/-- The spatial coefficient before normalization. -/
def C (n : ℕ) (k b : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  k • 1 + (B n * (hiddenBlock n)⁻¹) * hiddenSpatial n k b *
    ((hiddenBlock n)⁻¹ * (B n)ᵀ)

/-- The actual matrix product used for the normalized effective principal part. -/
def effective (n : ℕ) (k b : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  (Z n)⁻¹ * C n k b

/-- The signed exact Schur remainder has two explicit perturbation factors. -/
def remainder (n : ℕ) (k b s μ : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  -(B n * ((hiddenBlock n)⁻¹ * perturbation n k b s μ * (hiddenBlock n)⁻¹ *
    perturbation n k b s μ * (hiddenBlock n + perturbation n k b s μ)⁻¹) * (B n)ᵀ)

private theorem hidden_posDef (n : ℕ) : (hiddenBlock n).PosDef := by
  have he : (K n).submatrix Sum.inr Sum.inr = hiddenBlock n := by
    ext i j
    rfl
  rw [← he]
  exact (mass_posDef n).submatrix Sum.inr_injective

private theorem hidden_inverse (n : ℕ) :
    (hiddenBlock n)⁻¹ = fromBlocks (H (n + 1))⁻¹ 0 0 (H (n + 1))⁻¹ := by
  simpa [hiddenBlock] using
    inv_fromBlocks_zero₂₁_of_isUnit_iff (H (n + 1)) 0 (H (n + 1)) Iff.rfl

private def W (n : ℕ) : Matrix (Hidden n) (Fin 2) ℝ :=
  Sum.elim (fun i j => if j = 0 then w n i else 0)
    (fun i j => if j = 0 then 0 else w n i)

private theorem inverse_coupling (n : ℕ) : (hiddenBlock n)⁻¹ * (B n)ᵀ = W n := by
  rw [hidden_inverse]
  ext i j
  rcases i with i | i <;> fin_cases j <;>
    simp [Matrix.mul_apply, B, W, w, mulVec, dotProduct,
      Pi.single_apply]

private theorem coupling_inverse (n : ℕ) : B n * (hiddenBlock n)⁻¹ = (W n)ᵀ := by
  have hs : (hiddenBlock n)ᵀ = hiddenBlock n :=
    (isHermitian_iff_isSymm.mp (hidden_posDef n).isHermitian).eq
  have h := congrArg Matrix.transpose (inverse_coupling n)
  simpa only [transpose_mul, transpose_transpose, transpose_nonsing_inv, hs] using h

/-- The common mass coefficient is strictly positive. -/
theorem z_pos (n : ℕ) : 0 < z n := by
  have hs : 0 ≤ ∑ i, w n i ^ 2 := Finset.sum_nonneg fun _ _ => sq_nonneg _
  dsimp [z]
  linarith

/-- The endpoint formula reuses the inverse column of the chain. -/
theorem endpoint_formula (n : ℕ) : t n = 1 / (chainDet (n + 1) : ℝ) :=
  chain_endpoint_transfer n

/-- The negative spectral coefficient is the same scalar on both visible coordinates. -/
theorem Z_eq (n : ℕ) : Z n = z n • 1 := by
  rw [Z, coupling_inverse, inverse_coupling]
  ext i j
  change (1 : Matrix (Fin 2) (Fin 2) ℝ) i j +
    (∑ a, W n a i * W n a j) = z n * (1 : Matrix (Fin 2) (Fin 2) ℝ) i j
  fin_cases i <;> fin_cases j <;>
    simp [Fintype.sum_sum_type, W, z, pow_two]

#print axioms inverse_first_order
#print axioms z_pos
#print axioms endpoint_formula
#print axioms Z_eq

end

end D5.S3.Arith.GoldenResource.ChainSchurResponse
