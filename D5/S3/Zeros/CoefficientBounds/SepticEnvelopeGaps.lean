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
`gapA`, `gapB`, and `gapZ` are polynomial functions of arbitrary real gaps.
`gap_a_nonneg`, `gap_b_nonneg`, and `gap_z_nonneg` give their signs for every
nonnegative gap tuple. `gap_b_upper` and `gap_z_lower` are universal polynomial
inequalities. These declarations neither enumerate a bounded family nor
implement a checker, assume numerical premises, or certify a finite instance.
Their exact identities are checked by ring; utility is none.
The eight `aCoeff`, `bCoeff`, `zCoeff` functions and `upperCoeff0` through
`upperCoeff6` are polynomials in arbitrary real variables. `gap_a_first_gap`,
`gap_b_first_gap`, and `gap_z_first_gap` are universal coefficient identities.
These additional declarations also have no finite input domain, checker, or
numerical premise, and certify no finite instance.
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

set_option maxRecDepth 4096 in
set_option maxHeartbeats 4000000 in
-- Normalize the explicit square and positive quartic remainder.
theorem gap_b_upper (a b c d e f : ℝ)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hc : 0 ≤ c)
    (hd : 0 ≤ d) (he : 0 ≤ e) (hf : 0 ≤ f) :
    gapB a b c d e f ≤ 49*(gapA a b c d e f)^2/20 := by
  have hid : 49*(gapA a b c d e f)^2/20 - gapB a b c d e f =
      (2401/40)*(a^2-f^2)^2 +
      (2401 / 40) * (a * (a * (a * (17 * a + 60 * b + 48 * c + 36 * d + 24 * e + 12 * f) + b * (70 *
      b + 112 * c + 84 * d + 56 * e + 28 * f) + c * (40 * c + 60 * d + 40 * e + 20 * f) + d * (18 *
      d + 24 * e + 12 * f) + e * (4 * e + 4 * f)) + b * (b * (20 * b + 48 * c + 36 * d + 24 * e + 12
      * f) + c * (40 * c + 60 * d + 40 * e + 20 * f) + d * (24 * d + 32 * e + 16 * f) + e * (12 * e
      + 12 * f) + 4 * f ^ 2) + c * (d * (12 * d + 16 * e + 8 * f) + e * (16 * e + 16 * f) + 12 * f ^
      2) + d * (e * (20 * e + 20 * f) + 20 * f ^ 2) + e * (e * (8 * e + 12 * f) + 28 * f ^ 2) + 12 *
      f ^ 3) + b * (b * (b * (10 * b + 32 * c + 24 * d + 16 * e + 8 * f) + c * (40 * c + 60 * d + 40
      * e + 20 * f) + d * (24 * d + 32 * e + 16 * f) + e * (12 * e + 12 * f) + 4 * f ^ 2) + c * (d *
      (24 * d + 32 * e + 16 * f) + e * (32 * e + 32 * f) + 24 * f ^ 2) + d * (e * (40 * e + 40 * f)
      + 40 * f ^ 2) + e * (e * (16 * e + 24 * f) + 56 * f ^ 2) + 24 * f ^ 3) + c * (c * (d * (18 * d
      + 24 * e + 12 * f) + e * (24 * e + 24 * f) + 18 * f ^ 2) + d * (e * (60 * e + 60 * f) + 60 * f
      ^ 2) + e * (e * (24 * e + 36 * f) + 84 * f ^ 2) + 36 * f ^ 3) + d * (d * (e * (40 * e + 40 *
      f) + 40 * f ^ 2) + e * (e * (32 * e + 48 * f) + 112 * f ^ 2) + 48 * f ^ 3) + e * (e * (e * (10
      * e + 20 * f) + 70 * f ^ 2) + 60 * f ^ 3) + 17 * f ^ 4) := by
    unfold gapA gapB
    ring
  have h : 0 ≤ 49*(gapA a b c d e f)^2/20 - gapB a b c d e f := by
    rw [hid]
    positivity
  linarith only [h]

set_option maxRecDepth 4096 in
set_option maxHeartbeats 4000000 in
-- Normalize the degree-six positive lower remainder.
theorem gap_z_lower (a b c d e f : ℝ)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hc : 0 ≤ c)
    (hd : 0 ≤ d) (he : 0 ≤ e) (hf : 0 ≤ f) :
    120*gapA a b c d e f*gapB a b c d e f - 245*(gapA a b c d e f)^3
      ≤ 270*gapZ a b c d e f := by
  have hid : 270*gapZ a b c d e f -
      120*gapA a b c d e f*gapB a b c d e f + 245*(gapA a b c d e f)^3 =
      16807 * (a * (a * (a * (a * (a * (135 * a + 675 * b + 540 * c + 405 * d + 270 * e + 135 * f) +
      b * (1440 * b + 2304 * c + 1728 * d + 1152 * e + 576 * f) + c * (954 * c + 1431 * d + 954 * e
      + 477 * f) + d * (567 * d + 756 * e + 378 * f) + e * (279 * e + 279 * f) + 90 * f ^ 2) + b *
      (b * (1555 * b + 3732 * c + 2799 * d + 1866 * e + 933 * f) + c * (3180 * c + 4770 * d + 3180 *
      e + 1590 * f) + d * (1971 * d + 2628 * e + 1314 * f) + e * (1038 * e + 1038 * f) + 381 * f ^
      2) + c * (c * (848 * c + 1908 * d + 1272 * e + 636 * f) + d * (1674 * d + 2232 * e + 1116 * f)
      + e * (960 * e + 960 * f) + 402 * f ^ 2) + d * (d * (459 * d + 918 * e + 459 * f) + e * (882 *
      e + 882 * f) + 423 * f ^ 2) + e * (e * (268 * e + 402 * f) + 444 * f ^ 2) + 155 * f ^ 3) + b *
      (b * (b * (840 * b + 2688 * c + 2016 * d + 1344 * e + 672 * f) + c * (3534 * c + 5301 * d +
      3534 * e + 1767 * f) + d * (2277 * d + 3036 * e + 1518 * f) + e * (1269 * e + 1269 * f) + 510
      * f ^ 2) + c * (c * (1920 * c + 4320 * d + 2880 * e + 1440 * f) + d * (3978 * d + 5304 * e +
      2652 * f) + e * (2424 * e + 2424 * f) + 1098 * f ^ 2) + d * (d * (1134 * d + 2268 * e + 1134 *
      f) + e * (2310 * e + 2310 * f) + 1176 * f ^ 2) + e * (e * (732 * e + 1098 * f) + 1254 * f ^ 2)
      + 444 * f ^ 3) + c * (c * (c * (324 * c + 972 * d + 648 * e + 324 * f) + d * (1467 * d + 1956
      * e + 978 * f) + e * (984 * e + 984 * f) + 495 * f ^ 2) + d * (d * (891 * d + 1782 * e + 891 *
      f) + e * (1974 * e + 1974 * f) + 1083 * f ^ 2) + e * (e * (660 * e + 990 * f) + 1176 * f ^ 2)
      + 423 * f ^ 3) + d * (d * (d * (162 * d + 432 * e + 216 * f) + e * (819 * e + 819 * f) + 495 *
      f ^ 2) + e * (e * (588 * e + 882 * f) + 1098 * f ^ 2) + 402 * f ^ 3) + e * (e * (e * (129 * e
      + 258 * f) + 510 * f ^ 2) + 381 * f ^ 3) + 90 * f ^ 4) + b * (b * (b * (b * (75 * b + 300 * c
      + 225 * d + 150 * e + 75 * f) + c * (708 * c + 1062 * d + 708 * e + 354 * f) + d * (612 * d +
      816 * e + 408 * f) + e * (462 * e + 462 * f) + 258 * f ^ 2) + c * (c * (672 * c + 1512 * d +
      1008 * e + 504 * f) + d * (1890 * d + 2520 * e + 1260 * f) + e * (1512 * e + 1512 * f) + 882 *
      f ^ 2) + d * (d * (648 * d + 1296 * e + 648 * f) + e * (1638 * e + 1638 * f) + 990 * f ^ 2) +
      e * (e * (588 * e + 882 * f) + 1098 * f ^ 2) + 402 * f ^ 3) + c * (c * (c * (324 * c + 972 * d
      + 648 * e + 324 * f) + d * (1791 * d + 2388 * e + 1194 * f) + e * (1416 * e + 1416 * f) + 819
      * f ^ 2) + d * (d * (1080 * d + 2160 * e + 1080 * f) + e * (3054 * e + 3054 * f) + 1974 * f ^
      2) + e * (e * (1092 * e + 1638 * f) + 2310 * f ^ 2) + 882 * f ^ 3) + d * (d * (d * (216 * d +
      576 * e + 288 * f) + e * (1416 * e + 1416 * f) + 984 * f ^ 2) + e * (e * (1008 * e + 1512 * f)
      + 2424 * f ^ 2) + 960 * f ^ 3) + e * (e * (e * (231 * e + 462 * f) + 1269 * f ^ 2) + 1038 * f
      ^ 3) + 279 * f ^ 4) + c * (c * (c * (d * (216 * d + 288 * e + 144 * f) + e * (288 * e + 288 *
      f) + 216 * f ^ 2) + d * (d * (189 * d + 378 * e + 189 * f) + e * (1080 * e + 1080 * f) + 891 *
      f ^ 2) + e * (e * (432 * e + 648 * f) + 1134 * f ^ 2) + 459 * f ^ 3) + d * (d * (d * (108 * d
      + 288 * e + 144 * f) + e * (1194 * e + 1194 * f) + 978 * f ^ 2) + e * (e * (840 * e + 1260 *
      f) + 2652 * f ^ 2) + 1116 * f ^ 3) + e * (e * (e * (204 * e + 408 * f) + 1518 * f ^ 2) + 1314
      * f ^ 3) + 378 * f ^ 4) + d * (d * (d * (e * (324 * e + 324 * f) + 324 * f ^ 2) + e * (e *
      (336 * e + 504 * f) + 1440 * f ^ 2) + 636 * f ^ 3) + e * (e * (e * (177 * e + 354 * f) + 1767
      * f ^ 2) + 1590 * f ^ 3) + 477 * f ^ 4) + e * (e * (e * (e * (30 * e + 75 * f) + 672 * f ^ 2)
      + 933 * f ^ 3) + 576 * f ^ 4) + 135 * f ^ 5) + b * (b * (b * (b * (b * (25 * b + 120 * c + 90
      * d + 60 * e + 30 * f) + c * (354 * c + 531 * d + 354 * e + 177 * f) + d * (306 * d + 408 * e
      + 204 * f) + e * (231 * e + 231 * f) + 129 * f ^ 2) + c * (c * (448 * c + 1008 * d + 672 * e +
      336 * f) + d * (1260 * d + 1680 * e + 840 * f) + e * (1008 * e + 1008 * f) + 588 * f ^ 2) + d
      * (d * (432 * d + 864 * e + 432 * f) + e * (1092 * e + 1092 * f) + 660 * f ^ 2) + e * (e *
      (392 * e + 588 * f) + 732 * f ^ 2) + 268 * f ^ 3) + c * (c * (c * (324 * c + 972 * d + 648 * e
      + 324 * f) + d * (1791 * d + 2388 * e + 1194 * f) + e * (1416 * e + 1416 * f) + 819 * f ^ 2) +
      d * (d * (1080 * d + 2160 * e + 1080 * f) + e * (3054 * e + 3054 * f) + 1974 * f ^ 2) + e * (e
      * (1092 * e + 1638 * f) + 2310 * f ^ 2) + 882 * f ^ 3) + d * (d * (d * (216 * d + 576 * e +
      288 * f) + e * (1416 * e + 1416 * f) + 984 * f ^ 2) + e * (e * (1008 * e + 1512 * f) + 2424 *
      f ^ 2) + 960 * f ^ 3) + e * (e * (e * (231 * e + 462 * f) + 1269 * f ^ 2) + 1038 * f ^ 3) +
      279 * f ^ 4) + c * (c * (c * (d * (432 * d + 576 * e + 288 * f) + e * (576 * e + 576 * f) +
      432 * f ^ 2) + d * (d * (378 * d + 756 * e + 378 * f) + e * (2160 * e + 2160 * f) + 1782 * f ^
      2) + e * (e * (864 * e + 1296 * f) + 2268 * f ^ 2) + 918 * f ^ 3) + d * (d * (d * (216 * d +
      576 * e + 288 * f) + e * (2388 * e + 2388 * f) + 1956 * f ^ 2) + e * (e * (1680 * e + 2520 *
      f) + 5304 * f ^ 2) + 2232 * f ^ 3) + e * (e * (e * (408 * e + 816 * f) + 3036 * f ^ 2) + 2628
      * f ^ 3) + 756 * f ^ 4) + d * (d * (d * (e * (648 * e + 648 * f) + 648 * f ^ 2) + e * (e *
      (672 * e + 1008 * f) + 2880 * f ^ 2) + 1272 * f ^ 3) + e * (e * (e * (354 * e + 708 * f) +
      3534 * f ^ 2) + 3180 * f ^ 3) + 954 * f ^ 4) + e * (e * (e * (e * (60 * e + 150 * f) + 1344 *
      f ^ 2) + 1866 * f ^ 3) + 1152 * f ^ 4) + 270 * f ^ 5) + c * (c * (c * (c * (d * (162 * d + 216
      * e + 108 * f) + e * (216 * e + 216 * f) + 162 * f ^ 2) + d * (d * (189 * d + 378 * e + 189 *
      f) + e * (1080 * e + 1080 * f) + 891 * f ^ 2) + e * (e * (432 * e + 648 * f) + 1134 * f ^ 2) +
      459 * f ^ 3) + d * (d * (d * (162 * d + 432 * e + 216 * f) + e * (1791 * e + 1791 * f) + 1467
      * f ^ 2) + e * (e * (1260 * e + 1890 * f) + 3978 * f ^ 2) + 1674 * f ^ 3) + e * (e * (e * (306
      * e + 612 * f) + 2277 * f ^ 2) + 1971 * f ^ 3) + 567 * f ^ 4) + d * (d * (d * (e * (972 * e +
      972 * f) + 972 * f ^ 2) + e * (e * (1008 * e + 1512 * f) + 4320 * f ^ 2) + 1908 * f ^ 3) + e *
      (e * (e * (531 * e + 1062 * f) + 5301 * f ^ 2) + 4770 * f ^ 3) + 1431 * f ^ 4) + e * (e * (e *
      (e * (90 * e + 225 * f) + 2016 * f ^ 2) + 2799 * f ^ 3) + 1728 * f ^ 4) + 405 * f ^ 5) + d *
      (d * (d * (d * (e * (324 * e + 324 * f) + 324 * f ^ 2) + e * (e * (448 * e + 672 * f) + 1920 *
      f ^ 2) + 848 * f ^ 3) + e * (e * (e * (354 * e + 708 * f) + 3534 * f ^ 2) + 3180 * f ^ 3) +
      954 * f ^ 4) + e * (e * (e * (e * (120 * e + 300 * f) + 2688 * f ^ 2) + 3732 * f ^ 3) + 2304 *
      f ^ 4) + 540 * f ^ 5) + e * (e * (e * (e * (e * (25 * e + 75 * f) + 840 * f ^ 2) + 1555 * f ^
      3) + 1440 * f ^ 4) + 675 * f ^ 5) + 135 * f ^ 6) := by
    unfold gapA gapB gapZ
    ring
  have h : 0 ≤ 270*gapZ a b c d e f -
      120*gapA a b c d e f*gapB a b c d e f + 245*(gapA a b c d e f)^3 := by
    rw [hid]
    positivity
  linarith only [h]

def aCoeff0 (b c d e f : ℝ) : ℝ :=
  7 * (b * (5 * b + 8 * c + 6 * d + 4 * e + 2 * f) + c * (6 * c + 9 * d + 6 * e + 3 * f) + d * (6 *
  d + 8 * e + 4 * f) + e * (5 * e + 5 * f) + 3 * f ^ 2)

def aCoeff1 (b c d e f : ℝ) : ℝ :=
  7 * (5 * b + 4 * c + 3 * d + 2 * e + f)

def bCoeff0 (b c d e f : ℝ) : ℝ :=
  (2401 / 5) * (b * (b * (b * (5 * b + 16 * c + 12 * d + 8 * e + 4 * f) + c * (26 * c + 39 * d + 26
  * e + 13 * f) + d * (21 * d + 28 * e + 14 * f) + e * (15 * e + 15 * f) + 8 * f ^ 2) + c * (c * (24
  * c + 54 * d + 36 * e + 18 * f) + d * (48 * d + 64 * e + 32 * f) + e * (28 * e + 28 * f) + 12 * f
  ^ 2) + d * (d * (18 * d + 36 * e + 18 * f) + e * (26 * e + 26 * f) + 8 * f ^ 2) + e * (e * (8 * e
  + 12 * f) + 4 * f ^ 2)) + c * (c * (c * (9 * c + 27 * d + 18 * e + 9 * f) + d * (36 * d + 48 * e +
  24 * f) + e * (21 * e + 21 * f) + 9 * f ^ 2) + d * (d * (27 * d + 54 * e + 27 * f) + e * (39 * e +
  39 * f) + 12 * f ^ 2) + e * (e * (12 * e + 18 * f) + 6 * f ^ 2)) + d * (d * (d * (9 * d + 24 * e +
  12 * f) + e * (26 * e + 26 * f) + 8 * f ^ 2) + e * (e * (16 * e + 24 * f) + 8 * f ^ 2)) + e ^ 2 *
  (e * (5 * e + 10 * f) + 5 * f ^ 2))

def bCoeff1 (b c d e f : ℝ) : ℝ :=
  (2401 / 5) * (b * (b * (10 * b + 24 * c + 18 * d + 12 * e + 6 * f) + c * (26 * c + 39 * d + 26 * e
  + 13 * f) + d * (21 * d + 28 * e + 14 * f) + e * (15 * e + 15 * f) + 8 * f ^ 2) + c * (c * (12 * c
  + 27 * d + 18 * e + 9 * f) + d * (24 * d + 32 * e + 16 * f) + e * (14 * e + 14 * f) + 6 * f ^ 2) +
  d * (d * (9 * d + 18 * e + 9 * f) + e * (13 * e + 13 * f) + 4 * f ^ 2) + e * (e * (4 * e + 6 * f)
  + 2 * f ^ 2))

def bCoeff2 (b c d e f : ℝ) : ℝ :=
  (2401 / 5) * (b * (5 * b + 8 * c + 6 * d + 4 * e + 2 * f) + c * (8 * c + 12 * d + 8 * e + 4 * f) +
  d * (9 * d + 12 * e + 6 * f) + e * (8 * e + 8 * f) + 5 * f ^ 2)

def zCoeff0 (b c d e f : ℝ) : ℝ :=
  (33614 / 5) * (b * (b * (b * (b * (c * (2 * c + 3 * d + 2 * e + f) + d * (3 * d + 4 * e + 2 * f) +
  e * (3 * e + 3 * f) + 2 * f ^ 2) + c * (c * (8 * c + 18 * d + 12 * e + 6 * f) + d * (18 * d + 24 *
  e + 12 * f) + e * (12 * e + 12 * f) + 6 * f ^ 2) + d * (d * (8 * d + 16 * e + 8 * f) + e * (12 * e
  + 12 * f) + 4 * f ^ 2) + e * (e * (4 * e + 6 * f) + 2 * f ^ 2)) + c * (c * (c * (12 * c + 36 * d +
  24 * e + 12 * f) + d * (45 * d + 60 * e + 30 * f) + e * (24 * e + 24 * f) + 9 * f ^ 2) + d * (d *
  (30 * d + 60 * e + 30 * f) + e * (42 * e + 42 * f) + 12 * f ^ 2) + e * (e * (12 * e + 18 * f) + 6
  * f ^ 2)) + d * (d * (d * (9 * d + 24 * e + 12 * f) + e * (24 * e + 24 * f) + 6 * f ^ 2) + e * (e
  * (12 * e + 18 * f) + 6 * f ^ 2)) + e ^ 2 * (e * (3 * e + 6 * f) + 3 * f ^ 2)) + c * (c * (c * (c
  * (8 * c + 30 * d + 20 * e + 10 * f) + d * (48 * d + 64 * e + 32 * f) + e * (24 * e + 24 * f) + 8
  * f ^ 2) + d * (d * (44 * d + 88 * e + 44 * f) + e * (60 * e + 60 * f) + 16 * f ^ 2) + e * (e *
  (16 * e + 24 * f) + 8 * f ^ 2)) + d * (d * (d * (24 * d + 64 * e + 32 * f) + e * (60 * e + 60 * f)
  + 12 * f ^ 2) + e * (e * (24 * e + 36 * f) + 12 * f ^ 2)) + e ^ 2 * (e * (4 * e + 8 * f) + 4 * f ^
  2)) + d * (d * (d * (d * (6 * d + 20 * e + 10 * f) + e * (24 * e + 24 * f) + 4 * f ^ 2) + e * (e *
  (12 * e + 18 * f) + 6 * f ^ 2)) + e ^ 2 * (e * (2 * e + 4 * f) + 2 * f ^ 2))) + c * (c * (c * (c *
  (c * (2 * c + 9 * d + 6 * e + 3 * f) + d * (18 * d + 24 * e + 12 * f) + e * (9 * e + 9 * f) + 3 *
  f ^ 2) + d * (d * (22 * d + 44 * e + 22 * f) + e * (30 * e + 30 * f) + 8 * f ^ 2) + e * (e * (8 *
  e + 12 * f) + 4 * f ^ 2)) + d * (d * (d * (18 * d + 48 * e + 24 * f) + e * (45 * e + 45 * f) + 9 *
  f ^ 2) + e * (e * (18 * e + 27 * f) + 9 * f ^ 2)) + e ^ 2 * (e * (3 * e + 6 * f) + 3 * f ^ 2)) + d
  * (d * (d * (d * (9 * d + 30 * e + 15 * f) + e * (36 * e + 36 * f) + 6 * f ^ 2) + e * (e * (18 * e
  + 27 * f) + 9 * f ^ 2)) + e ^ 2 * (e * (3 * e + 6 * f) + 3 * f ^ 2))) + d ^ 2 * (d * (d * (d * (2
  * d + 8 * e + 4 * f) + e * (12 * e + 12 * f) + 2 * f ^ 2) + e * (e * (8 * e + 12 * f) + 4 * f ^
  2)) + e ^ 2 * (e * (2 * e + 4 * f) + 2 * f ^ 2)))

def zCoeff1 (b c d e f : ℝ) : ℝ :=
  (33614 / 5) * (b * (b * (b * (c * (4 * c + 6 * d + 4 * e + 2 * f) + d * (6 * d + 8 * e + 4 * f) +
  e * (6 * e + 6 * f) + 4 * f ^ 2) + c * (c * (12 * c + 27 * d + 18 * e + 9 * f) + d * (27 * d + 36
  * e + 18 * f) + e * (18 * e + 18 * f) + 9 * f ^ 2) + d * (d * (12 * d + 24 * e + 12 * f) + e * (18
  * e + 18 * f) + 6 * f ^ 2) + e * (e * (6 * e + 9 * f) + 3 * f ^ 2)) + c * (c * (c * (12 * c + 36 *
  d + 24 * e + 12 * f) + d * (45 * d + 60 * e + 30 * f) + e * (24 * e + 24 * f) + 9 * f ^ 2) + d *
  (d * (30 * d + 60 * e + 30 * f) + e * (42 * e + 42 * f) + 12 * f ^ 2) + e * (e * (12 * e + 18 * f)
  + 6 * f ^ 2)) + d * (d * (d * (9 * d + 24 * e + 12 * f) + e * (24 * e + 24 * f) + 6 * f ^ 2) + e *
  (e * (12 * e + 18 * f) + 6 * f ^ 2)) + e ^ 2 * (e * (3 * e + 6 * f) + 3 * f ^ 2)) + c * (c * (c *
  (c * (4 * c + 15 * d + 10 * e + 5 * f) + d * (24 * d + 32 * e + 16 * f) + e * (12 * e + 12 * f) +
  4 * f ^ 2) + d * (d * (22 * d + 44 * e + 22 * f) + e * (30 * e + 30 * f) + 8 * f ^ 2) + e * (e *
  (8 * e + 12 * f) + 4 * f ^ 2)) + d * (d * (d * (12 * d + 32 * e + 16 * f) + e * (30 * e + 30 * f)
  + 6 * f ^ 2) + e * (e * (12 * e + 18 * f) + 6 * f ^ 2)) + e ^ 2 * (e * (2 * e + 4 * f) + 2 * f ^
  2)) + d * (d * (d * (d * (3 * d + 10 * e + 5 * f) + e * (12 * e + 12 * f) + 2 * f ^ 2) + e * (e *
  (6 * e + 9 * f) + 3 * f ^ 2)) + e ^ 2 * (e * (e + 2 * f) + f ^ 2)))

def zCoeff2 (b c d e f : ℝ) : ℝ :=
  (33614 / 5) * (b * (b * (c * (2 * c + 3 * d + 2 * e + f) + d * (3 * d + 4 * e + 2 * f) + e * (3 *
  e + 3 * f) + 2 * f ^ 2) + c * (c * (4 * c + 9 * d + 6 * e + 3 * f) + d * (9 * d + 12 * e + 6 * f)
  + e * (6 * e + 6 * f) + 3 * f ^ 2) + d * (d * (4 * d + 8 * e + 4 * f) + e * (6 * e + 6 * f) + 2 *
  f ^ 2) + e * (e * (2 * e + 3 * f) + f ^ 2)) + c * (c * (c * (2 * c + 6 * d + 4 * e + 2 * f) + d *
  (9 * d + 12 * e + 6 * f) + e * (6 * e + 6 * f) + 3 * f ^ 2) + d * (d * (8 * d + 16 * e + 8 * f) +
  e * (12 * e + 12 * f) + 4 * f ^ 2) + e * (e * (4 * e + 6 * f) + 2 * f ^ 2)) + d * (d * (d * (3 * d
  + 8 * e + 4 * f) + e * (9 * e + 9 * f) + 3 * f ^ 2) + e * (e * (6 * e + 9 * f) + 3 * f ^ 2)) + e ^
  2 * (e * (2 * e + 4 * f) + 2 * f ^ 2))

set_option maxRecDepth 4096 in
set_option maxHeartbeats 4000000 in
-- Normalize the first-gap decomposition of the invariant.
theorem gap_a_first_gap (a b c d e f : ℝ) :
    gapA a b c d e f = aCoeff0 b c d e f +
      a*(aCoeff1 b c d e f + a*(21)) := by
  unfold gapA aCoeff0 aCoeff1
  ring

set_option maxRecDepth 4096 in
set_option maxHeartbeats 4000000 in
-- Normalize the first-gap decomposition of the invariant.
theorem gap_b_first_gap (a b c d e f : ℝ) :
    gapB a b c d e f = bCoeff0 b c d e f +
      a*(bCoeff1 b c d e f + a*(bCoeff2 b c d e f)) := by
  unfold gapB bCoeff0 bCoeff1 bCoeff2
  ring

set_option maxRecDepth 4096 in
set_option maxHeartbeats 4000000 in
-- Normalize the first-gap decomposition of the invariant.
theorem gap_z_first_gap (a b c d e f : ℝ) :
    gapZ a b c d e f = zCoeff0 b c d e f +
      a*(zCoeff1 b c d e f + a*(zCoeff2 b c d e f)) := by
  unfold gapZ zCoeff0 zCoeff1 zCoeff2
  ring

def upperCoeff0 (b c d e f : ℝ) : ℝ :=
  ((-5292 * (zCoeff0 b c d e f) * ((aCoeff0 b c d e f) ^ 2)) + (120 * (aCoeff0 b c d e f) *
  ((bCoeff0 b c d e f) ^ 2)) + (540 * (bCoeff0 b c d e f) * (zCoeff0 b c d e f)))

def upperCoeff1 (b c d e f : ℝ) : ℝ :=
  ((-5292 * (zCoeff1 b c d e f) * ((aCoeff0 b c d e f) ^ 2)) + (120 * (aCoeff1 b c d e f) *
  ((bCoeff0 b c d e f) ^ 2)) + (540 * (bCoeff0 b c d e f) * (zCoeff1 b c d e f)) + (540 * (bCoeff1 b
  c d e f) * (zCoeff0 b c d e f)) + (-10584 * (aCoeff0 b c d e f) * (aCoeff1 b c d e f) * (zCoeff0 b
  c d e f)) + (240 * (aCoeff0 b c d e f) * (bCoeff0 b c d e f) * (bCoeff1 b c d e f)))

def upperCoeff2 (b c d e f : ℝ) : ℝ :=
  ((2520 * ((bCoeff0 b c d e f) ^ 2)) + (-222264 * (aCoeff0 b c d e f) * (zCoeff0 b c d e f)) +
  (-5292 * (zCoeff0 b c d e f) * ((aCoeff1 b c d e f) ^ 2)) + (-5292 * (zCoeff2 b c d e f) *
  ((aCoeff0 b c d e f) ^ 2)) + (120 * (aCoeff0 b c d e f) * ((bCoeff1 b c d e f) ^ 2)) + (540 *
  (bCoeff0 b c d e f) * (zCoeff2 b c d e f)) + (540 * (bCoeff1 b c d e f) * (zCoeff1 b c d e f)) +
  (540 * (bCoeff2 b c d e f) * (zCoeff0 b c d e f)) + (-10584 * (aCoeff0 b c d e f) * (aCoeff1 b c d
  e f) * (zCoeff1 b c d e f)) + (240 * (aCoeff0 b c d e f) * (bCoeff0 b c d e f) * (bCoeff2 b c d e
  f)) + (240 * (aCoeff1 b c d e f) * (bCoeff0 b c d e f) * (bCoeff1 b c d e f)))

def upperCoeff3 (b c d e f : ℝ) : ℝ :=
  ((-222264 * (aCoeff0 b c d e f) * (zCoeff1 b c d e f)) + (-222264 * (aCoeff1 b c d e f) * (zCoeff0
  b c d e f)) + (-5292 * (zCoeff1 b c d e f) * ((aCoeff1 b c d e f) ^ 2)) + (120 * (aCoeff1 b c d e
  f) * ((bCoeff1 b c d e f) ^ 2)) + (540 * (bCoeff1 b c d e f) * (zCoeff2 b c d e f)) + (540 *
  (bCoeff2 b c d e f) * (zCoeff1 b c d e f)) + (5040 * (bCoeff0 b c d e f) * (bCoeff1 b c d e f)) +
  (-10584 * (aCoeff0 b c d e f) * (aCoeff1 b c d e f) * (zCoeff2 b c d e f)) + (240 * (aCoeff0 b c d
  e f) * (bCoeff1 b c d e f) * (bCoeff2 b c d e f)) + (240 * (aCoeff1 b c d e f) * (bCoeff0 b c d e
  f) * (bCoeff2 b c d e f)))

def upperCoeff4 (b c d e f : ℝ) : ℝ :=
  ((-2333772 * (zCoeff0 b c d e f)) + (2520 * ((bCoeff1 b c d e f) ^ 2)) + (-222264 * (aCoeff0 b c d
  e f) * (zCoeff2 b c d e f)) + (-222264 * (aCoeff1 b c d e f) * (zCoeff1 b c d e f)) + (-5292 *
  (zCoeff2 b c d e f) * ((aCoeff1 b c d e f) ^ 2)) + (120 * (aCoeff0 b c d e f) * ((bCoeff2 b c d e
  f) ^ 2)) + (540 * (bCoeff2 b c d e f) * (zCoeff2 b c d e f)) + (5040 * (bCoeff0 b c d e f) *
  (bCoeff2 b c d e f)) + (240 * (aCoeff1 b c d e f) * (bCoeff1 b c d e f) * (bCoeff2 b c d e f)))

def upperCoeff5 (b c d e f : ℝ) : ℝ :=
  ((-2333772 * (zCoeff1 b c d e f)) + (-222264 * (aCoeff1 b c d e f) * (zCoeff2 b c d e f)) + (120 *
  (aCoeff1 b c d e f) * ((bCoeff2 b c d e f) ^ 2)) + (5040 * (bCoeff1 b c d e f) * (bCoeff2 b c d e
  f)))

def upperCoeff6 (b c d e f : ℝ) : ℝ :=
  ((-2333772 * (zCoeff2 b c d e f)) + (2520 * ((bCoeff2 b c d e f) ^ 2)))

#print axioms gap_b_upper
#print axioms gap_z_lower

end D5.S3.Zeros.CoefficientBounds.SepticEnvelopeGaps
