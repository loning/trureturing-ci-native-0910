/- GID: D5/S3/Zeros/Convolution/EulerianSquareRow33
   generality: I
   mirror-B: D5/B/S3/Zeros/Convolution/EulerianSquareRow33
   mirror-E: none(waiver:kernel-checked-integer-certificate)
   anchors: []
   utility: kind=certified-instance; basis=terminal=gid:D5/S3/Zeros/Convolution/EulerianSquareRow33.certified_row33
   digest: Row 33 of the ordinary Eulerian matrix square, via quotient interlacing. -/

/-
Mao--Wang, arXiv:2607.01572v1, Conjecture 4.1, PDF page 11.
Only A^2 at row 33 is addressed. See docs/reports/eulerian-square-row33-r7.md.
The quotient anchor is certified_row32. Integer interval Horner certificates
fix H33's signs at the roots of H32; the full Wronskian is not needed.
-/

import D5.S3.Zeros.Convolution.EulerianSquareRow32

open Polynomial Set
open D5.S3.Zeros.Convolution.EulerianSquareRow31

set_option maxRecDepth 10000
set_option backward.isDefEq.respectTransparency false

namespace D5.S3.Zeros.Convolution.EulerianSquareRow33

private def fcs : List Int :=
  [263130836933693530167218012160000000,
   47085703381823453661591054959076910952790,
   100546863089033328021527337890661745193218232,
   28407331014736007464594069835755063889603026394,
   2311337756948528115640702435316737598733567630188,
   76827924416885136103087963533602196224267529320182,
   1260911706746060744067902988188012215101397657564144,
   11463399630084806473141860010939382830368452310922066,
   62223325254559961106437034251505884257337330507469076,
   212192031802847509859927282920058565419957684252552206,
   470955328989688918964856089308307851105587333615402136,
   697105151252854234118100400102774747823778822081113386,
   699412140028858102675603637470792010445853358213434876,
   480293592728746765312377526051571470379753849452410406,
   226690480065555419873956774126325445229725036493429696,
   73473051546800601081988796291439727931805393683444866,
   16257565733802243641461816088402363141038543065440356,
   2429013889072185371037074162442642569537373456328126,
   240970015683788044133108646790229106002104584453736,
   15503316424521566773175824262149874533525726441306,
   626552492152974422570415758047339615959689963596,
   15241735516184287731485849485385529221129206486,
   210800663574628765100280968850910608539602576,
   1534758389880153393433794146840800392281266,
   5297601479135562895176083621300820144436,
   7445614253570070471904033423974140206,
   3411366788482033071777525772640536,
   411022457335040192944739680762,
   4642141673967474301531924,
   9227077585458726210,
   8589934526]

private def gcs : List Int :=
  [8683317618811886495518194401280000000,
   2241763184688973922578069091086790725179962,
   6050565602901020595427410594055048272159032436,
   2048429971067835559820713099925111540154976149710,
   194712406950088520382381334725714485237506257478048,
   7462549877863941500085045622206089704191102622761506,
   140260270633211090253871008344982553763208323528596780,
   1455884488820789793081815521240022697861028476981216694,
   9018210691665865052555292866395481381298286959113376376,
   35146391887594100018912592356594356295319268923822744586,
   89423884525690297687270099275520884983952070015871020036,
   152434382908715734949356402320217943403422052664080438046,
   177200655024783805395384799222207913023575325723702296016,
   142072470550615413038780953661034723652121715358142588146,
   79030719952274280853899842104799870547719209865155282396,
   30536922926888992360153994501012340419614259283044625286,
   8168132757170382576581910885893651546472914348279179816,
   1500397782831681325767757600648051041696238656432171226,
   186822585429774921110524352356723333464729924334330036,
   15476683518926866372188154251504463939525843447131886,
   831546282905874538289314626841839257019611182700416,
   28009338329629508818164472421023311181245898211266,
   565442761821594237134337383237046225913700881036,
   6443964101232390813496815526982443267933725526,
   38251755579366862536956888318992399159031896,
   106086195140797293960381431564905374903466,
   117338825613347462747167091707608742852,
   40932083257620465718309154913928798,
   3670077947931929412240055610232,
   27853616165478421672605874,
   36904605254939934666,
   17179869116]

/-- The degree-31 quotient of the existing row 32 polynomial. -/
noncomputable def H32 : Real[X] := hp fcs

/-- The degree-32 quotient of the existing row 33 polynomial. -/
noncomputable def H33 : Real[X] := hp gcs

private theorem row_33 : row 33 =
  [0,
   1,
   8589934558,
   5558768508779956,
   73597973054528618810,
   113909683214485984529600,
   43835206946243962386882374,
   6172294565361743496542310012,
   397067158052311039421442655554,
   13409812239789599951272726666860,
   260788729086293260557720765047910,
   3114414896759457331414813408943700,
   23913227754404803215014345266818930,
   122050532156907442000198005398985600,
   424186529497346513971995242571085710,
   1021198131640637597814392011178644860,
   1722467529259214750444332070391549690,
   2048907684751889584430937041897091750,
   1722467529259214750444332070391549690,
   1021198131640637597814392011178644860,
   424186529497346513971995242571085710,
   122050532156907442000198005398985600,
   23913227754404803215014345266818930,
   3114414896759457331414813408943700,
   260788729086293260557720765047910,
   13409812239789599951272726666860,
   397067158052311039421442655554,
   6172294565361743496542310012,
   43835206946243962386882374,
   113909683214485984529600,
   73597973054528618810,
   5558768508779956,
   8589934558,
   1] := by
  rw [row]
  simp only [EulerianSquareRow32.row_32]
  decide

set_option maxHeartbeats 4000000 in
-- The finite matrix product contains 34 exact coefficient computations.
private theorem bc_values (k : Nat) (hk : k <= 33) :
    bc 33 k = (0 :: (gcs ++ [1])).getD k 0 := by
  interval_cases k <;>
    norm_num [bc, Finset.sum_Icc_succ_top, A,
      EulerianSquareRow32.row_1,
      EulerianSquareRow32.row_2,
      EulerianSquareRow32.row_3,
      EulerianSquareRow32.row_4,
      EulerianSquareRow32.row_5,
      EulerianSquareRow32.row_6,
      EulerianSquareRow32.row_7,
      EulerianSquareRow32.row_8,
      EulerianSquareRow32.row_9,
      EulerianSquareRow32.row_10,
      EulerianSquareRow32.row_11,
      EulerianSquareRow32.row_12,
      EulerianSquareRow32.row_13,
      EulerianSquareRow32.row_14,
      EulerianSquareRow32.row_15,
      EulerianSquareRow32.row_16,
      EulerianSquareRow32.row_17,
      EulerianSquareRow32.row_18,
      EulerianSquareRow32.row_19,
      EulerianSquareRow32.row_20,
      EulerianSquareRow32.row_21,
      EulerianSquareRow32.row_22,
      EulerianSquareRow32.row_23,
      EulerianSquareRow32.row_24,
      EulerianSquareRow32.row_25,
      EulerianSquareRow32.row_26,
      EulerianSquareRow32.row_27,
      EulerianSquareRow32.row_28,
      EulerianSquareRow32.row_29,
      EulerianSquareRow32.row_30,
      EulerianSquareRow32.row_31,
      EulerianSquareRow32.row_32,
      row_33, List.getD, gcs]

/-- This quotient is definitionally the quotient in the existing certificate. -/
theorem factor_row32 : B 32 = X * H32 := by
  exact EulerianSquareRow32.factor_row32

set_option maxHeartbeats 4000000 in
-- Expanding the certified coefficients requires a large polynomial normalization.
/-- Exact ordinary matrix multiplication binds the new certificate to B 33. -/
theorem factor_row33 : B 33 = X * H33 := by
  norm_num [B, Finset.sum_range_succ, bc_values, H33, gcs, hp]
  simp only [map_ofNat]
  ring

private theorem H32_degree : H32.natDegree = 31 ∧ H32 ≠ 0 := hp_degree fcs

private theorem H33_degree : H33.natDegree = 32 ∧ H33 ≠ 0 := hp_degree gcs

private theorem H32_anchor : H32.Splits ∧
    ∀ x : Real, H32.eval x = 0 → x < 0 := by
  obtain ⟨hs, hn⟩ := EulerianSquareRow32.certified_row32
  rw [factor_row32, splits_X_mul] at hs
  refine ⟨hs, ?_⟩
  intro x hx
  have hn' : x <= 0 := hn x (by simp [factor_row32, hx])
  refine lt_of_le_of_ne hn' ?_
  intro he
  subst x
  norm_num [H32, fcs, hp] at hx

private def boxHorner (a b d : Int) : List Int → Int × Int
  | [] => (1, 1)
  | c :: cs =>
      let q := boxHorner a b d cs
      (c * d ^ (cs.length + 1) + min (a * q.2) (b * q.2),
       c * d ^ (cs.length + 1) + max (a * q.1) (b * q.1))

private theorem mul_box {a b t l u v : Real} (ht : t <= 0)
    (ha : a <= t) (hb : t <= b) (hl : l <= v) (hu : v <= u) :
    min (a * u) (b * u) <= t * v ∧ t * v <= max (a * l) (b * l) := by
  constructor
  · apply le_trans _ (mul_le_mul_of_nonpos_left hu ht)
    rcases le_total 0 u with h | h
    · exact (min_le_left _ _).trans (mul_le_mul_of_nonneg_right ha h)
    · exact (min_le_right _ _).trans (mul_le_mul_of_nonpos_right hb h)
  · apply le_trans (mul_le_mul_of_nonpos_left hl ht)
    rcases le_total 0 l with h | h
    · exact (mul_le_mul_of_nonneg_right hb h).trans (le_max_right _ _)
    · exact (mul_le_mul_of_nonpos_right ha h).trans (le_max_left _ _)

private theorem boxHorner_spec (cs : List Int) (a b d : Int) (x : Real)
    (ha : (a : Real) <= d * x) (hb : (d : Real) * x <= b) (hb0 : b <= 0) :
    ((boxHorner a b d cs).1 : Real) <= (d : Real) ^ cs.length * (hp cs).eval x ∧
    (d : Real) ^ cs.length * (hp cs).eval x <= (boxHorner a b d cs).2 := by
  induction cs with
  | nil => simp [boxHorner, hp]
  | cons c cs ih =>
    have ht : (d : Real) * x <= 0 := hb.trans (by exact_mod_cast hb0)
    have h := mul_box ht ha hb ih.1 ih.2
    have he : (d : Real) ^ (cs.length + 1) * (hp (c :: cs)).eval x =
        (c : Real) * (d : Real) ^ (cs.length + 1) +
          ((d : Real) * x) * ((d : Real) ^ cs.length * (hp cs).eval x) := by
      simp only [hp, eval_add, eval_C, eval_mul, eval_X, pow_succ]
      ring
    simp only [boxHorner, List.length_cons, Int.cast_add, Int.cast_mul,
      Int.cast_pow, Int.cast_min, Int.cast_max]
    rw [he]
    constructor <;> linarith only [h.1, h.2]

private theorem root_between_split (p : Real[X]) (hs : p.Splits) (hm : p.Monic)
    (a b : Real) (hab : a < b) (hv : p.eval a * p.eval b < 0) :
    ∃ x, a < x ∧ x < b ∧ p.eval x = 0 := by
  classical
  by_contra h
  push Not at h
  have hp : 0 <= (p.roots.map (fun x => (a - x) * (b - x))).prod := by
    apply Multiset.prod_nonneg
    intro y hy
    obtain ⟨x, hx, rfl⟩ := Multiset.mem_map.mp hy
    have hr := (mem_roots hm.ne_zero).mp hx
    by_cases ha : a < x
    · have hb : b <= x := le_of_not_gt (fun hbx => h x ha hbx hr)
      exact mul_nonneg_of_nonpos_of_nonpos (by linarith) (by linarith)
    · have hx : x <= a := le_of_not_gt ha
      exact mul_nonneg (by linarith) (by linarith)
  rw [Multiset.prod_map_mul,
    ← hs.eval_eq_prod_roots_of_monic hm a,
    ← hs.eval_eq_prod_roots_of_monic hm b] at hp
  exact (not_lt_of_ge hp) hv

private theorem sign_change_from_hv (cs : List Int) (a b d : Int) (hd : 0 < d)
    (h : hv a d cs * hv b d cs < 0) :
    (hp cs).eval ((a : Real) / d) * (hp cs).eval ((b : Real) / d) < 0 := by
  rcases mul_neg_iff.mp h with h | h
  · exact mul_neg_of_pos_of_neg (eval_pos cs a d hd h.1) (eval_neg cs b d hd h.2)
  · exact mul_neg_of_neg_of_pos (eval_neg cs a d hd h.1) (eval_pos cs b d hd h.2)


private def boxes (i : Fin 31) : Int × Int × Int :=
  ([(-10569646080, -7247757312, 1),
    (-1992294400, -1241513984, 1),
    (-921553, -770048, 2),
    (-118144, -100352, 1),
    (-6753, -6016, 1),
    (-2048, -1920, 1),
    (-4311, -4224, 8),
    (-13805, -13726, 64),
    (-26442, -26387, 256),
    (-54321, -54272, 1024),
    (-251341, -251296, 8192),
    (-38548, -38545, 2048),
    (-398299, -398286, 32768),
    (-66944, -66943, 8192),
    (-2966353, -2966334, 524288),
    (-2099076, -2099063, 524288),
    (-3016078, -3016069, 1048576),
    (-4373229, -4373216, 2097152),
    (-3181017, -3181008, 2097152),
    (-4615496, -4615483, 4194304),
    (-829485, -829480, 1048576),
    (-2345270, -2345255, 4194304),
    (-807100, -807079, 2097152),
    (-266904, -266887, 1048576),
    (-20807, -20804, 131072),
    (-23773, -23756, 262144),
    (-5934, -5911, 131072),
    (-590, -583, 32768),
    (-1353, -1248, 262144),
    (-837, -560, 1048576),
    (-4809, -376, 67108864)] : List (Int × Int × Int)).getD i.val (0, 0, 1)

private def lower (i : Fin 31) : Rat := (boxes i).1 / ((boxes i).2.2 : Rat)
private def upper (i : Fin 31) : Rat := (boxes i).2.1 / ((boxes i).2.2 : Rat)
private def leftEnd : Rat := -274877906944
private def rightEnd : Rat := -1 / 1099511627776

private theorem boxes_proper : ∀ i,
    0 < (boxes i).2.2 ∧ (boxes i).1 < (boxes i).2.1 ∧ (boxes i).2.1 < 0 := by
  decide +kernel

private theorem boxes_ordered : ∀ i j, i < j → upper i < lower j := by
  decide +kernel

private theorem boxes_outer : ∀ i, leftEnd < lower i ∧ upper i < rightEnd := by
  decide +kernel

set_option maxHeartbeats 4000000 in
-- Each of the 31 cases checks two endpoint signs and one interval enclosure.
private theorem numeric_signs : ∀ i,
    hv (boxes i).1 (boxes i).2.2 fcs * hv (boxes i).2.1 (boxes i).2.2 fcs < 0 ∧
      (if i.val % 2 = 0 then (boxHorner (boxes i).1 (boxes i).2.1 (boxes i).2.2 gcs).2 < 0
       else 0 < (boxHorner (boxes i).1 (boxes i).2.1 (boxes i).2.2 gcs).1) := by
  intro i
  fin_cases i <;> norm_num [boxes, List.getD, hv, boxHorner, fcs, gcs]

private theorem left_positive : 0 < H33.eval (leftEnd : Real) := by
  convert eval_pos gcs (-274877906944) 1 (by norm_num)
    (by norm_num [hv, gcs]) using 1; norm_num [H33, leftEnd]

private theorem right_positive : 0 < H33.eval (rightEnd : Real) := by
  convert eval_pos gcs (-1) 1099511627776 (by norm_num)
    (by norm_num [hv, gcs]) using 1; norm_num [H33, rightEnd]

private theorem signs_in_boxes (i : Fin 31) (x : Real)
    (ha : (lower i : Real) < x) (hb : x < (upper i : Real)) :
    if i.val % 2 = 0 then H33.eval x < 0 else 0 < H33.eval x := by
  have hd : (0 : Real) < (boxes i).2.2 := by exact_mod_cast (boxes_proper i).1
  have ha' : ((boxes i).1 : Real) <= ((boxes i).2.2 : Real) * x := by
    rw [mul_comm]
    apply (div_le_iff₀ hd).mp
    simpa [lower] using ha.le
  have hb' : ((boxes i).2.2 : Real) * x <= ((boxes i).2.1 : Real) := by
    rw [mul_comm]
    apply (le_div_iff₀ hd).mp
    simpa [upper] using hb.le
  have h := boxHorner_spec gcs (boxes i).1 (boxes i).2.1 (boxes i).2.2 x
    ha' hb' (boxes_proper i).2.2.le
  have hc := (numeric_signs i).2
  have hpow := pow_pos hd gcs.length
  change _ <= (↑(boxes i).2.2 : Real) ^ gcs.length * H33.eval x ∧
    (↑(boxes i).2.2 : Real) ^ gcs.length * H33.eval x <= _ at h
  split_ifs with he
  · rw [if_pos he] at hc
    have hn : ((boxHorner (boxes i).1 (boxes i).2.1 (boxes i).2.2 gcs).2 : Real) < 0 := by
      exact_mod_cast hc
    nlinarith only [h.2, hn, hpow]
  · rw [if_neg he] at hc
    have hp : (0 : Real) < (boxHorner (boxes i).1 (boxes i).2.1 (boxes i).2.2 gcs).1 := by
      exact_mod_cast hc
    exact (mul_pos_iff_of_pos_left hpow).mp (hp.trans_le h.1)

private theorem predecessor_roots : ∃ r : Fin 31 → Real,
    StrictMono r ∧ (∀ i, H32.eval (r i) = 0) ∧ (∀ i, r i < 0) ∧
    (∀ i, (leftEnd : Real) < r i ∧ r i < (rightEnd : Real)) ∧
    (∀ i, if i.val % 2 = 0 then H33.eval (r i) < 0 else 0 < H33.eval (r i)) := by
  have hex : ∀ i : Fin 31, ∃ x,
      (lower i : Real) < x ∧ x < (upper i : Real) ∧ H32.eval x = 0 := by
    intro i
    have hd : (0 : Real) < (boxes i).2.2 := by exact_mod_cast (boxes_proper i).1
    apply root_between_split H32 H32_anchor.1 (hp_monic fcs)
    · simp only [lower, upper, Rat.cast_div, Rat.cast_intCast]
      exact (div_lt_div_iff_of_pos_right hd).mpr (by exact_mod_cast (boxes_proper i).2.1)
    · simpa [H32, lower, upper] using
        sign_change_from_hv fcs (boxes i).1 (boxes i).2.1 (boxes i).2.2
          (boxes_proper i).1 (numeric_signs i).1
  choose r hr using hex
  refine ⟨r, ?_, fun i => (hr i).2.2, fun i => H32_anchor.2 _ (hr i).2.2, ?_, ?_⟩
  · intro i j hij
    exact (hr i).2.1.trans ((Rat.cast_lt.mpr (boxes_ordered i j hij)).trans (hr j).1)
  · intro i
    exact ⟨(Rat.cast_lt.mpr (boxes_outer i).1).trans (hr i).1,
      (hr i).2.1.trans (Rat.cast_lt.mpr (boxes_outer i).2)⟩
  · intro i
    exact signs_in_boxes i (r i) (hr i).1 (hr i).2.1

private noncomputable def ends (a b : Real) (r : Fin 31 → Real) : Fin 33 → Real :=
  Fin.cons a (Fin.snoc r b)

private theorem ends_mono (a b : Real) (r : Fin 31 → Real) (hm : StrictMono r)
    (hl : ∀ i, a < r i) (hr : ∀ i, r i < b) : StrictMono (ends a b r) := by
  apply Fin.strictMono_iff_lt_succ.mpr
  intro i
  fin_cases i
  all_goals first | exact hl 0 | exact hr 30 | exact hm (by decide)

private theorem ends_negative (a b : Real) (r : Fin 31 → Real) (ha : a < 0)
    (hb : b < 0) (hr : ∀ i, r i < 0) : ∀ i, ends a b r i < 0 := by
  intro i
  refine Fin.cases ?_ (fun j => ?_) i
  · exact ha
  · refine Fin.lastCases ?_ (fun k => ?_) j
    · exact hb
    · simpa only [ends, Fin.cons_succ, Fin.snoc_castSucc] using hr k

private theorem end_signs (q : Real[X]) (a b : Real) (r : Fin 31 → Real)
    (ha : 0 < q.eval a) (hb : 0 < q.eval b)
    (hr : ∀ i, if i.val % 2 = 0 then q.eval (r i) < 0 else 0 < q.eval (r i)) :
    ∀ i : Fin 33,
      if i.val % 2 = 0 then 0 < q.eval (ends a b r i) else q.eval (ends a b r i) < 0 := by
  intro i
  fin_cases i
  · exact ha
  · exact hr (0 : Fin 31)
  · exact hr (1 : Fin 31)
  · exact hr (2 : Fin 31)
  · exact hr (3 : Fin 31)
  · exact hr (4 : Fin 31)
  · exact hr (5 : Fin 31)
  · exact hr (6 : Fin 31)
  · exact hr (7 : Fin 31)
  · exact hr (8 : Fin 31)
  · exact hr (9 : Fin 31)
  · exact hr (10 : Fin 31)
  · exact hr (11 : Fin 31)
  · exact hr (12 : Fin 31)
  · exact hr (13 : Fin 31)
  · exact hr (14 : Fin 31)
  · exact hr (15 : Fin 31)
  · exact hr (16 : Fin 31)
  · exact hr (17 : Fin 31)
  · exact hr (18 : Fin 31)
  · exact hr (19 : Fin 31)
  · exact hr (20 : Fin 31)
  · exact hr (21 : Fin 31)
  · exact hr (22 : Fin 31)
  · exact hr (23 : Fin 31)
  · exact hr (24 : Fin 31)
  · exact hr (25 : Fin 31)
  · exact hr (26 : Fin 31)
  · exact hr (27 : Fin 31)
  · exact hr (28 : Fin 31)
  · exact hr (29 : Fin 31)
  · exact hr (30 : Fin 31)
  · exact hb

private theorem end_changes (q : Real[X]) (e : Fin 33 → Real)
    (hs : ∀ i, if i.val % 2 = 0 then 0 < q.eval (e i) else q.eval (e i) < 0) :
    ∀ i : Fin 32, q.eval (e i.castSucc) * q.eval (e i.succ) < 0 := by
  intro i
  have h0 := hs i.castSucc
  have h1 := hs i.succ
  fin_cases i <;> norm_num at h0 h1 ⊢
  all_goals first | exact mul_neg_of_pos_of_neg h0 h1 | exact mul_neg_of_neg_of_pos h0 h1

private theorem roots_complete (p : Real[X]) (n : Nat) (hp : p ≠ 0) (hd : p.natDegree = n)
    (r : Fin n → Real) (hm : StrictMono r) (hr : ∀ i, p.eval (r i) = 0) :
    ∀ x, p.eval x = 0 ↔ ∃ i, r i = x := by
  classical
  let S : Finset Real := Finset.univ.image r
  have hc : S.card = n := by
    simp [S, Finset.card_image_of_injective _ hm.injective]
  have hroots : p.roots = S.val :=
    roots_eq_of_natDegree_le_card_of_ne_zero (by
      intro x hx
      obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp hx
      exact hr i) (by omega) hp
  intro x
  change p.IsRoot x ↔ _
  rw [← mem_roots hp, hroots]
  simp [S]

private theorem roots_strictMono (e : Fin 33 → Real) (s : Fin 32 → Real) (he : StrictMono e)
    (hs : ∀ i, e i.castSucc < s i ∧ s i < e i.succ) : StrictMono s := by
  intro i j hij
  have hle : i.succ ≤ j.castSucc := by
    simp only [Fin.le_iff_val_le_val, Fin.val_succ, Fin.val_castSucc]
    exact hij
  exact (hs i).2.trans_le ((he.monotone hle).trans (hs j).1.le)

private theorem roots_interlaced (a b : Real) (r : Fin 31 → Real) (s : Fin 32 → Real)
    (hs : ∀ i, ends a b r i.castSucc < s i ∧ s i < ends a b r i.succ) :
    ∀ i : Fin 31, s i.castSucc < r i ∧ r i < s i.succ := by
  intro i
  constructor
  · simpa only [ends, Fin.cons_succ, Fin.snoc_castSucc] using (hs i.castSucc).2
  · simpa only [ends, ← Fin.succ_castSucc, Fin.cons_succ, Fin.snoc_castSucc]
      using (hs i.succ).1

/-- The complete negative root lists of H32 and H33 strictly interlace. -/
theorem quotient_interlacing : H33.Splits ∧
    ∃ r : Fin 31 → Real, ∃ s : Fin 32 → Real,
      StrictMono r ∧ StrictMono s ∧
      (∀ x, H32.eval x = 0 ↔ ∃ i, r i = x) ∧
      (∀ x, H33.eval x = 0 ↔ ∃ i, s i = x) ∧
      (∀ i, s i.castSucc < r i ∧ r i < s i.succ) ∧ (∀ i, s i < 0) := by
  obtain ⟨r, hrm, hrr, hrn, hrb, hrs⟩ := predecessor_roots
  let e := ends (leftEnd : Real) (rightEnd : Real) r
  have he : StrictMono e := ends_mono _ _ r hrm (fun i => (hrb i).1) (fun i => (hrb i).2)
  have hen : ∀ i, e i < 0 := ends_negative _ _ r
    (by norm_num [leftEnd]) (by norm_num [rightEnd]) hrn
  have hes : ∀ i : Fin 32, H33.eval (e i.castSucc) * H33.eval (e i.succ) < 0 :=
    end_changes H33 e (end_signs H33 _ _ r left_positive right_positive hrs)
  have hsp := (split_from_endpoints H33 32 H33_degree.2 H33_degree.1 e he hen hes).1
  have hex : ∀ i : Fin 32, ∃ x, e i.castSucc < x ∧ x < e i.succ ∧ H33.eval x = 0 := by
    intro i
    exact root_between_split H33 hsp (hp_monic gcs) _ _ (he (by simp)) (hes i)
  choose s hs using hex
  have hsm : StrictMono s := roots_strictMono e s he (fun i => ⟨(hs i).1, (hs i).2.1⟩)
  refine ⟨hsp, r, s, hrm, hsm,
    roots_complete H32 31 H32_degree.2 H32_degree.1 r hrm hrr,
    roots_complete H33 32 H33_degree.2 H33_degree.1 s hsm (fun i => (hs i).2.2),
    roots_interlaced _ _ r s (fun i => ⟨(hs i).1, (hs i).2.1⟩), ?_⟩
  intro i
  exact (hs i).2.1.trans (hen i.succ)

/-- Conjecture 4.1 for the ordinary matrix square A^2 in row 33 only. -/
theorem certified_row33 : (B 33).Splits ∧
    ∀ x : Real, (B 33).eval x = 0 → x ≤ 0 := by
  obtain ⟨hsp, r, s, _, _, _, hroots, _, hneg⟩ := quotient_interlacing
  constructor
  · rw [factor_row33]
    exact splits_X_mul.mpr hsp
  · intro x hx
    rw [factor_row33, eval_mul, eval_X] at hx
    rcases mul_eq_zero.mp hx with h | h
    · exact h.le
    · obtain ⟨i, rfl⟩ := (hroots x).mp h
      exact (hneg i).le

#print axioms factor_row32
#print axioms quotient_interlacing
#print axioms certified_row33

#print axioms numeric_signs
#print axioms signs_in_boxes
#print axioms factor_row33

end D5.S3.Zeros.Convolution.EulerianSquareRow33
