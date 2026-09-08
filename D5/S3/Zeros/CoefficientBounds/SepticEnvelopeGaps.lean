/- GID: D5/S3/Zeros/CoefficientBounds/SepticEnvelopeGaps
   generality: G
   mirror-B: D5/B/S3/Zeros/CoefficientBounds/SepticEnvelopeGaps
   mirror-E: none(waiver:symbolic-polynomial-inequalities)
   anchors: []
   utility: none
   digest: Universal centered septic coefficient inequalities in nonnegative root gaps. -/

import Mathlib.Tactic

/-!
The six variables are one seventh of consecutive sorted root differences.
All declarations are universal polynomial identities or inequalities over real
variables. None is a bounded enumeration, checker, numerical reduction, or
certified finite instance. Certificates are polynomial identities checked by ring.
-/

noncomputable section

namespace D5.S3.Zeros.CoefficientBounds.SepticEnvelopeGaps

def gapA (a b c d e f : ℝ) : ℝ :=
  7 * (a * (3 * a + 5 * b + 4 * c + 3 * d + 2 * e + f) + b * (5 * b + 8 * c + 6 * d + 4 * e + 2 * f)
  + c * (6 * c + 9 * d + 6 * e + 3 * f) + d * (6 * d + 8 * e + 4 * f) + e * (5 * e + 5 * f) + 3 * f
  ^ 2)

def gapB (a b c d e f : ℝ) : ℝ :=
  (2401 / 5) * (a * (a * (b * (5 * b + 8 * c + 6 * d + 4 * e + 2 * f) + c * (8 * c + 12 * d + 8 * e
  + 4 * f) + d * (9 * d + 12 * e + 6 * f) + e * (8 * e + 8 * f) + 5 * f ^ 2) + b * (b * (10 * b + 24
  * c + 18 * d + 12 * e + 6 * f) + c * (26 * c + 39 * d + 26 * e + 13 * f) + d * (21 * d + 28 * e +
  14 * f) + e * (15 * e + 15 * f) + 8 * f ^ 2) + c * (c * (12 * c + 27 * d + 18 * e + 9 * f) + d *
  (24 * d + 32 * e + 16 * f) + e * (14 * e + 14 * f) + 6 * f ^ 2) + d * (d * (9 * d + 18 * e + 9 *
  f) + e * (13 * e + 13 * f) + 4 * f ^ 2) + e * (e * (4 * e + 6 * f) + 2 * f ^ 2)) + b * (b * (b *
  (5 * b + 16 * c + 12 * d + 8 * e + 4 * f) + c * (26 * c + 39 * d + 26 * e + 13 * f) + d * (21 * d
  + 28 * e + 14 * f) + e * (15 * e + 15 * f) + 8 * f ^ 2) + c * (c * (24 * c + 54 * d + 36 * e + 18
  * f) + d * (48 * d + 64 * e + 32 * f) + e * (28 * e + 28 * f) + 12 * f ^ 2) + d * (d * (18 * d +
  36 * e + 18 * f) + e * (26 * e + 26 * f) + 8 * f ^ 2) + e * (e * (8 * e + 12 * f) + 4 * f ^ 2)) +
  c * (c * (c * (9 * c + 27 * d + 18 * e + 9 * f) + d * (36 * d + 48 * e + 24 * f) + e * (21 * e +
  21 * f) + 9 * f ^ 2) + d * (d * (27 * d + 54 * e + 27 * f) + e * (39 * e + 39 * f) + 12 * f ^ 2) +
  e * (e * (12 * e + 18 * f) + 6 * f ^ 2)) + d * (d * (d * (9 * d + 24 * e + 12 * f) + e * (26 * e +
  26 * f) + 8 * f ^ 2) + e * (e * (16 * e + 24 * f) + 8 * f ^ 2)) + e ^ 2 * (e * (5 * e + 10 * f) +
  5 * f ^ 2))

def gapZ (a b c d e f : ℝ) : ℝ :=
  (33614 / 5) * (a * (a * (b * (b * (c * (2 * c + 3 * d + 2 * e + f) + d * (3 * d + 4 * e + 2 * f) +
  e * (3 * e + 3 * f) + 2 * f ^ 2) + c * (c * (4 * c + 9 * d + 6 * e + 3 * f) + d * (9 * d + 12 * e
  + 6 * f) + e * (6 * e + 6 * f) + 3 * f ^ 2) + d * (d * (4 * d + 8 * e + 4 * f) + e * (6 * e + 6 *
  f) + 2 * f ^ 2) + e * (e * (2 * e + 3 * f) + f ^ 2)) + c * (c * (c * (2 * c + 6 * d + 4 * e + 2 *
  f) + d * (9 * d + 12 * e + 6 * f) + e * (6 * e + 6 * f) + 3 * f ^ 2) + d * (d * (8 * d + 16 * e +
  8 * f) + e * (12 * e + 12 * f) + 4 * f ^ 2) + e * (e * (4 * e + 6 * f) + 2 * f ^ 2)) + d * (d * (d
  * (3 * d + 8 * e + 4 * f) + e * (9 * e + 9 * f) + 3 * f ^ 2) + e * (e * (6 * e + 9 * f) + 3 * f ^
  2)) + e ^ 2 * (e * (2 * e + 4 * f) + 2 * f ^ 2)) + b * (b * (b * (c * (4 * c + 6 * d + 4 * e + 2 *
  f) + d * (6 * d + 8 * e + 4 * f) + e * (6 * e + 6 * f) + 4 * f ^ 2) + c * (c * (12 * c + 27 * d +
  18 * e + 9 * f) + d * (27 * d + 36 * e + 18 * f) + e * (18 * e + 18 * f) + 9 * f ^ 2) + d * (d *
  (12 * d + 24 * e + 12 * f) + e * (18 * e + 18 * f) + 6 * f ^ 2) + e * (e * (6 * e + 9 * f) + 3 * f
  ^ 2)) + c * (c * (c * (12 * c + 36 * d + 24 * e + 12 * f) + d * (45 * d + 60 * e + 30 * f) + e *
  (24 * e + 24 * f) + 9 * f ^ 2) + d * (d * (30 * d + 60 * e + 30 * f) + e * (42 * e + 42 * f) + 12
  * f ^ 2) + e * (e * (12 * e + 18 * f) + 6 * f ^ 2)) + d * (d * (d * (9 * d + 24 * e + 12 * f) + e
  * (24 * e + 24 * f) + 6 * f ^ 2) + e * (e * (12 * e + 18 * f) + 6 * f ^ 2)) + e ^ 2 * (e * (3 * e
  + 6 * f) + 3 * f ^ 2)) + c * (c * (c * (c * (4 * c + 15 * d + 10 * e + 5 * f) + d * (24 * d + 32 *
  e + 16 * f) + e * (12 * e + 12 * f) + 4 * f ^ 2) + d * (d * (22 * d + 44 * e + 22 * f) + e * (30 *
  e + 30 * f) + 8 * f ^ 2) + e * (e * (8 * e + 12 * f) + 4 * f ^ 2)) + d * (d * (d * (12 * d + 32 *
  e + 16 * f) + e * (30 * e + 30 * f) + 6 * f ^ 2) + e * (e * (12 * e + 18 * f) + 6 * f ^ 2)) + e ^
  2 * (e * (2 * e + 4 * f) + 2 * f ^ 2)) + d * (d * (d * (d * (3 * d + 10 * e + 5 * f) + e * (12 * e
  + 12 * f) + 2 * f ^ 2) + e * (e * (6 * e + 9 * f) + 3 * f ^ 2)) + e ^ 2 * (e * (e + 2 * f) + f ^
  2))) + b * (b * (b * (b * (c * (2 * c + 3 * d + 2 * e + f) + d * (3 * d + 4 * e + 2 * f) + e * (3
  * e + 3 * f) + 2 * f ^ 2) + c * (c * (8 * c + 18 * d + 12 * e + 6 * f) + d * (18 * d + 24 * e + 12
  * f) + e * (12 * e + 12 * f) + 6 * f ^ 2) + d * (d * (8 * d + 16 * e + 8 * f) + e * (12 * e + 12 *
  f) + 4 * f ^ 2) + e * (e * (4 * e + 6 * f) + 2 * f ^ 2)) + c * (c * (c * (12 * c + 36 * d + 24 * e
  + 12 * f) + d * (45 * d + 60 * e + 30 * f) + e * (24 * e + 24 * f) + 9 * f ^ 2) + d * (d * (30 * d
  + 60 * e + 30 * f) + e * (42 * e + 42 * f) + 12 * f ^ 2) + e * (e * (12 * e + 18 * f) + 6 * f ^
  2)) + d * (d * (d * (9 * d + 24 * e + 12 * f) + e * (24 * e + 24 * f) + 6 * f ^ 2) + e * (e * (12
  * e + 18 * f) + 6 * f ^ 2)) + e ^ 2 * (e * (3 * e + 6 * f) + 3 * f ^ 2)) + c * (c * (c * (c * (8 *
  c + 30 * d + 20 * e + 10 * f) + d * (48 * d + 64 * e + 32 * f) + e * (24 * e + 24 * f) + 8 * f ^
  2) + d * (d * (44 * d + 88 * e + 44 * f) + e * (60 * e + 60 * f) + 16 * f ^ 2) + e * (e * (16 * e
  + 24 * f) + 8 * f ^ 2)) + d * (d * (d * (24 * d + 64 * e + 32 * f) + e * (60 * e + 60 * f) + 12 *
  f ^ 2) + e * (e * (24 * e + 36 * f) + 12 * f ^ 2)) + e ^ 2 * (e * (4 * e + 8 * f) + 4 * f ^ 2)) +
  d * (d * (d * (d * (6 * d + 20 * e + 10 * f) + e * (24 * e + 24 * f) + 4 * f ^ 2) + e * (e * (12 *
  e + 18 * f) + 6 * f ^ 2)) + e ^ 2 * (e * (2 * e + 4 * f) + 2 * f ^ 2))) + c * (c * (c * (c * (c *
  (2 * c + 9 * d + 6 * e + 3 * f) + d * (18 * d + 24 * e + 12 * f) + e * (9 * e + 9 * f) + 3 * f ^
  2) + d * (d * (22 * d + 44 * e + 22 * f) + e * (30 * e + 30 * f) + 8 * f ^ 2) + e * (e * (8 * e +
  12 * f) + 4 * f ^ 2)) + d * (d * (d * (18 * d + 48 * e + 24 * f) + e * (45 * e + 45 * f) + 9 * f ^
  2) + e * (e * (18 * e + 27 * f) + 9 * f ^ 2)) + e ^ 2 * (e * (3 * e + 6 * f) + 3 * f ^ 2)) + d *
  (d * (d * (d * (9 * d + 30 * e + 15 * f) + e * (36 * e + 36 * f) + 6 * f ^ 2) + e * (e * (18 * e +
  27 * f) + 9 * f ^ 2)) + e ^ 2 * (e * (3 * e + 6 * f) + 3 * f ^ 2))) + d ^ 2 * (d * (d * (d * (2 *
  d + 8 * e + 4 * f) + e * (12 * e + 12 * f) + 2 * f ^ 2) + e * (e * (8 * e + 12 * f) + 4 * f ^ 2))
  + e ^ 2 * (e * (2 * e + 4 * f) + 2 * f ^ 2)))

theorem gap_a_nonneg (a b c d e f : ℝ)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hc : 0 ≤ c)
    (hd : 0 ≤ d) (he : 0 ≤ e) (hf : 0 ≤ f) :
    0 ≤ gapA a b c d e f := by
  unfold gapA
  positivity

theorem gap_b_nonneg (a b c d e f : ℝ)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hc : 0 ≤ c)
    (hd : 0 ≤ d) (he : 0 ≤ e) (hf : 0 ≤ f) :
    0 ≤ gapB a b c d e f := by
  unfold gapB
  positivity

theorem gap_z_nonneg (a b c d e f : ℝ)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hc : 0 ≤ c)
    (hd : 0 ≤ d) (he : 0 ≤ e) (hf : 0 ≤ f) :
    0 ≤ gapZ a b c d e f := by
  unfold gapZ
  positivity

end D5.S3.Zeros.CoefficientBounds.SepticEnvelopeGaps
