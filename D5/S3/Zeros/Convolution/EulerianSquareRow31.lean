/- GID: D5/S3/Zeros/Convolution/EulerianSquareRow31
   generality: I
   mirror-B: D5/B/S3/Zeros/Convolution/EulerianSquareRow31
   mirror-E: none(waiver:kernel-checked-integer-certificate)
   anchors: []
   utility: kind=certified-instance; basis=terminal=gid:D5/S3/Zeros/Convolution/EulerianSquareRow31.certified_row31
   digest: The ordinary Eulerian matrix square has only real nonpositive roots in row 31. -/

/-
Mao--Wang, arXiv:2607.01572v1, Conjecture 4.1 (PDF p. 11), A^2 at n=31 only.
The paper reports the first 30 rows; no worldwide priority claim is made,
and we do not claim the authors have not computed row 31.

Before this module: scoped D5, pinned Mathlib and RealRooted searches found
no direct instance. Splitting/root-cardinality normalization and linarith
only with sq_nonneg/abs_nonneg failed in r14-impl-0907/attempt-2/BindOnly.lean.
The new facts are exact signs at 31 negative rational endpoints, not a
claim that the Eulerian transform preserves every real-rooted polynomial.

The endpoints and homogeneous Horner bridge are reused from
r14-probe-0907/attempt-1. All row values and matrix-product coefficients
below are equality certificates checked against the recursive definition.
The integer sign computations use norm_num; no native evaluation is trusted.
-/

import Mathlib.Algebra.Polynomial.Splits
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Data.List.GetD
import Mathlib.Topology.Algebra.Polynomial
import Mathlib.Topology.Order.IntermediateValue
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Choose
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Convert

open Polynomial Set

set_option maxRecDepth 10000
set_option maxHeartbeats 4000000
set_option backward.isDefEq.respectTransparency false

namespace D5.S3.Zeros.Convolution.EulerianSquareRow31

def row : ℕ → List ℤ
  | 0 => [1]
  | n + 1 => 0 :: (List.range (n + 1)).map (fun k =>
      ((n - k + 1 : ℕ) : ℤ) * (row n).getD k 0 +
        ((k + 1 : ℕ) : ℤ) * (row n).getD (k + 1) 0)

def A (n k : ℕ) : ℤ := (row n).getD k 0

def bc (n k : ℕ) : ℤ :=
  ∑ j ∈ Finset.Icc k n, A n j * A j k

noncomputable def B (n : ℕ) : ℝ[X] :=
  ∑ k ∈ Finset.range (n + 1), C (bc n k : ℝ) * X ^ k

private noncomputable def hp : List ℤ → ℝ[X]
  | [] => 1
  | c :: cs => C (c : ℝ) + X * hp cs

private def hv (a b : ℤ) : List ℤ → ℤ
  | [] => 1
  | c :: cs => c * b ^ (cs.length + 1) + a * hv a b cs

private theorem hp_degree (cs : List ℤ) :
    (hp cs).natDegree = cs.length ∧ hp cs ≠ 0 := by
  induction cs with
  | nil => simp [hp]
  | cons c cs ih =>
    have hd : (hp (c :: cs)).natDegree = (c :: cs).length := by
      rw [hp, natDegree_C_add, natDegree_X_mul ih.2, ih.1]
      rfl
    refine ⟨hd, fun hz => ?_⟩
    rw [hz, natDegree_zero] at hd
    simp at hd

private theorem hp_monic (cs : List ℤ) : (hp cs).Monic := by
  rw [Monic.def, leadingCoeff, (hp_degree cs).1]
  induction cs with
  | nil => simp [hp]
  | cons c cs ih => simpa [hp, coeff_X_mul] using ih

private theorem hv_spec (cs : List ℤ) (a b : ℤ) (x : ℝ)
    (hx : (a : ℝ) = (b : ℝ) * x) :
    (hv a b cs : ℝ) = (b : ℝ) ^ cs.length * (hp cs).eval x := by
  induction cs with
  | nil => simp [hv, hp]
  | cons c cs ih =>
    simp only [hv, hp, Int.cast_add, Int.cast_mul, Int.cast_pow,
      List.length_cons, eval_add, eval_C, eval_mul, eval_X]
    rw [ih, hx]
    ring

private theorem eval_pos (cs : List ℤ) (a b : ℤ) (hb : 0 < b)
    (hs : 0 < hv a b cs) : 0 < (hp cs).eval ((a : ℝ) / (b : ℝ)) := by
  have hbR : (0 : ℝ) < b := by exact_mod_cast hb
  have hx : (a : ℝ) = (b : ℝ) * ((a : ℝ) / (b : ℝ)) := by field_simp
  have he := hv_spec cs a b ((a : ℝ) / (b : ℝ)) hx
  have hi : (0 : ℝ) < (hv a b cs : ℝ) := by exact_mod_cast hs
  rw [he] at hi
  exact (mul_pos_iff_of_pos_left (pow_pos hbR _)).mp hi

private theorem eval_neg (cs : List ℤ) (a b : ℤ) (hb : 0 < b)
    (hs : hv a b cs < 0) : (hp cs).eval ((a : ℝ) / (b : ℝ)) < 0 := by
  have hbR : (0 : ℝ) < b := by exact_mod_cast hb
  have hx : (a : ℝ) = (b : ℝ) * ((a : ℝ) / (b : ℝ)) := by field_simp
  have he := hv_spec cs a b ((a : ℝ) / (b : ℝ)) hx
  have hi : (hv a b cs : ℝ) < 0 := by exact_mod_cast hs
  rw [he] at hi
  nlinarith [pow_pos hbR cs.length]

private theorem root_between (p : ℝ[X]) (a b : ℝ) (hab : a < b)
    (hs : p.eval a * p.eval b < 0) :
    ∃ x, a < x ∧ x < b ∧ p.eval x = 0 := by
  rcases mul_neg_iff.mp hs with h | h
  · obtain ⟨x, hx, hz⟩ := intermediate_value_Ioo' hab.le p.continuousOn
      (show (0 : ℝ) ∈ Ioo (p.eval b) (p.eval a) from ⟨h.2, h.1⟩)
    exact ⟨x, hx.1, hx.2, hz⟩
  · obtain ⟨x, hx, hz⟩ := intermediate_value_Ioo hab.le p.continuousOn
      (show (0 : ℝ) ∈ Ioo (p.eval a) (p.eval b) from h)
    exact ⟨x, hx.1, hx.2, hz⟩

private theorem split_from_endpoints (p : ℝ[X]) (d : ℕ) (hp0 : p ≠ 0)
    (hd : p.natDegree = d) (e : Fin (d + 1) → ℝ)
    (he : StrictMono e) (hne : ∀ i, e i < 0)
    (hs : ∀ i : Fin d, p.eval (e i.castSucc) * p.eval (e i.succ) < 0) :
    p.Splits ∧ ∀ x : ℝ, p.eval x = 0 → x < 0 := by
  classical
  have hex : ∀ i : Fin d, ∃ x, e i.castSucc < x ∧ x < e i.succ ∧ p.eval x = 0 := by
    intro i
    exact root_between p _ _ (he (by simp)) (hs i)
  choose r hr using hex
  have hrmono : StrictMono r := by
    intro i j hij
    have hle : i.succ ≤ j.castSucc := by
      simp only [Fin.le_iff_val_le_val, Fin.val_succ, Fin.val_castSucc]
      exact hij
    exact (hr i).2.1.trans_le ((he.monotone hle).trans (hr j).1.le)
  let s : Finset ℝ := Finset.univ.image r
  have hc : s.card = d := by
    simp [s, Finset.card_image_of_injective _ hrmono.injective]
  have hroot : ∀ x ∈ s, p.eval x = 0 := by
    intro x hx
    obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp hx
    exact (hr i).2.2
  have hroots : p.roots = s.val :=
    roots_eq_of_natDegree_le_card_of_ne_zero hroot (by omega) hp0
  refine ⟨splits_iff_card_roots.mpr ?_, ?_⟩
  · rw [hroots]
    simpa [hd] using hc
  · intro x hx
    have hmem : x ∈ s := by
      have := (mem_roots hp0).mpr hx
      simpa [hroots] using this
    obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp hmem
    exact (hr i).2.1.trans (hne i.succ)



/-- The stored triangle has precisely the entries from column zero through n. -/
theorem row_length (n : ℕ) : (row n).length = n + 1 := by
  cases n <;> simp [row]

/-- Initial condition from the source triangle. -/
theorem A_zero_zero : A 0 0 = 1 := rfl

/-- Entries outside the triangular support vanish. -/
theorem A_out_of_bounds (n k : ℕ) (h : n < k) : A n k = 0 := by
  exact List.getD_eq_default _ _ (by rw [row_length]; omega)

/-- Positive rows have zero constant entry. -/
theorem A_succ_zero (n : ℕ) : A (n + 1) 0 = 0 := rfl

/-- The source recurrence, with positive indices written as successors. -/
theorem A_recurrence (n k : ℕ) (hk : k ≤ n) :
    A (n + 1) (k + 1) = ((n - k + 1 : ℕ) : ℤ) * A n k +
      ((k + 1 : ℕ) : ℤ) * A n (k + 1) := by
  simp only [A, row, List.getD_cons_succ]
  rw [List.getD_eq_getElem _ _ (by simp; omega)]
  simp

private theorem row_0 : row 0 = [1] := by
  rfl

private theorem row_1 : row 1 = [0, 1] := by
  rw [row]
  simp only [row_0]
  decide

private theorem row_2 : row 2 = [0, 1, 1] := by
  rw [row]
  simp only [row_1]
  decide

private theorem row_3 : row 3 = [0, 1, 4, 1] := by
  rw [row]
  simp only [row_2]
  decide

private theorem row_4 : row 4 = [0, 1, 11, 11, 1] := by
  rw [row]
  simp only [row_3]
  decide

private theorem row_5 : row 5 = [0, 1, 26, 66, 26, 1] := by
  rw [row]
  simp only [row_4]
  decide

private theorem row_6 : row 6 = [0, 1, 57, 302, 302, 57, 1] := by
  rw [row]
  simp only [row_5]
  decide

private theorem row_7 : row 7 = [0, 1, 120, 1191, 2416, 1191, 120, 1] := by
  rw [row]
  simp only [row_6]
  decide

private theorem row_8 : row 8 = [0, 1, 247, 4293, 15619, 15619, 4293, 247, 1] := by
  rw [row]
  simp only [row_7]
  decide

private theorem row_9 : row 9 = [0, 1, 502, 14608, 88234, 156190, 88234, 14608, 502, 1] := by
  rw [row]
  simp only [row_8]
  decide

private theorem row_10 : row 10 = [0, 1, 1013, 47840, 455192, 1310354, 1310354, 455192, 47840, 1013, 1] := by
  rw [row]
  simp only [row_9]
  decide

private theorem row_11 : row 11 = [0, 1, 2036, 152637, 2203488, 9738114, 15724248, 9738114, 2203488, 152637, 2036, 1] := by
  rw [row]
  simp only [row_10]
  decide

private theorem row_12 : row 12 = [0, 1, 4083, 478271, 10187685, 66318474, 162512286, 162512286, 66318474, 10187685, 478271, 4083, 1] := by
  rw [row]
  simp only [row_11]
  decide

private theorem row_13 : row 13 = [0, 1, 8178, 1479726, 45533450, 423281535, 1505621508, 2275172004, 1505621508, 423281535, 45533450, 1479726, 8178, 1] := by
  rw [row]
  simp only [row_12]
  decide

private theorem row_14 : row 14 = [0, 1, 16369, 4537314, 198410786, 2571742175, 12843262863, 27971176092, 27971176092, 12843262863, 2571742175, 198410786, 4537314, 16369, 1] := by
  rw [row]
  simp only [row_13]
  decide

private theorem row_15 : row 15 = [0, 1, 32752, 13824739, 848090912, 15041229521, 102776998928, 311387598411, 447538817472, 311387598411, 102776998928, 15041229521, 848090912, 13824739, 32752, 1] := by
  rw [row]
  simp only [row_14]
  decide

private theorem row_16 : row 16 = [0, 1, 65519, 41932745, 3572085255, 85383238549, 782115518299, 3207483178157, 6382798925475, 6382798925475, 3207483178157, 782115518299, 85383238549, 3572085255, 41932745, 65519, 1] := by
  rw [row]
  simp only [row_15]
  decide

private theorem row_17 : row 17 = [0, 1, 131054, 126781020, 14875399450, 473353301060, 5717291972382, 31055652948388, 83137223185370, 114890380658550, 83137223185370, 31055652948388, 5717291972382, 473353301060, 14875399450, 126781020, 131054, 1] := by
  rw [row]
  simp only [row_16]
  decide

private theorem row_18 : row 18 = [0, 1, 262125, 382439924, 61403313100, 2575022097600, 40457344748072, 285997074307300, 1006709967915228, 1865385657780650, 1865385657780650, 1006709967915228, 285997074307300, 40457344748072, 2575022097600, 61403313100, 382439924, 262125, 1] := by
  rw [row]
  simp only [row_17]
  decide

private theorem row_19 : row 19 = [0, 1, 524268, 1151775897, 251732291184, 13796160184500, 278794377854832, 2527925001876036, 11485644635009424, 27862280567093358, 37307713155613000, 27862280567093358, 11485644635009424, 2527925001876036, 278794377854832, 13796160184500, 251732291184, 1151775897, 524268, 1] := by
  rw [row]
  simp only [row_18]
  decide

private theorem row_20 : row 20 = [0, 1, 1048555, 3464764515, 1026509354985, 73008517581444, 1879708669896492, 21598596303099900, 124748182104463860, 388588260723953310, 679562217794156938, 679562217794156938, 388588260723953310, 124748182104463860, 21598596303099900, 1879708669896492, 73008517581444, 1026509354985, 3464764515, 1048555, 1] := by
  rw [row]
  simp only [row_19]
  decide

private theorem row_21 : row 21 = [0, 1, 2097130, 10414216090, 4168403181210, 382493246941965, 12446388300682056, 179385804170146680, 1300365805079109480, 5119020713873609970, 11458681306629009100, 14950368791471452636, 11458681306629009100, 5119020713873609970, 1300365805079109480, 179385804170146680, 12446388300682056, 382493246941965, 4168403181210, 10414216090, 2097130, 1] := by
  rw [row]
  simp only [row_20]
  decide

private theorem row_22 : row 22 = [0, 1, 4194281, 31284590870, 16871482830550, 1987497491971605, 81180715002105741, 1454842842001939656, 13093713503185076040, 64276307695970022450, 181134082346647020610, 301958232385734088196, 301958232385734088196, 181134082346647020610, 64276307695970022450, 13093713503185076040, 1454842842001939656, 81180715002105741, 1987497491971605, 16871482830550, 31284590870, 4194281, 1] := by
  rw [row]
  simp only [row_21]
  decide

private theorem row_23 : row 23 = [0, 1, 8388584, 93941852511, 68111623139600, 10258045633638475, 522859244868123336, 11563972049049375189, 128027193497511642816, 774892471811506342650, 2711209131210050520400, 5676283626749486238086, 7246997577257618116704, 5676283626749486238086, 2711209131210050520400, 774892471811506342650, 128027193497511642816, 11563972049049375189, 522859244868123336, 10258045633638475, 68111623139600, 93941852511, 8388584, 1] := by
  rw [row]
  simp only [row_22]
  decide

private theorem row_24 : row 24 = [0, 1, 16777191, 282010106381, 274419271461131, 52652460630984375, 3332058336247871041, 90359270750971846371, 1220805072813932520741, 9022467342263743368906, 38735478389273100343750, 100396047731185055904546, 160755658074834738495566, 160755658074834738495566, 100396047731185055904546, 38735478389273100343750, 9022467342263743368906, 1220805072813932520741, 90359270750971846371, 3332058336247871041, 52652460630984375, 274419271461131, 282010106381, 16777191, 1] := by
  rw [row]
  simp only [row_23]
  decide

private theorem row_25 : row 25 = [0, 1, 33554406, 846416194536, 1103881308184906, 269025107855605626, 21045399230106913746, 695824003645512474376, 11392907456028953400606, 101955892318210543172751, 531714261368950897339996, 1685388700882132120106256, 3334612565134607644610436, 4179647109945703200884716, 3334612565134607644610436, 1685388700882132120106256, 531714261368950897339996, 101955892318210543172751, 11392907456028953400606, 695824003645512474376, 21045399230106913746, 269025107855605626, 1103881308184906, 846416194536, 33554406, 1] := by
  rw [row]
  simp only [row_24]
  decide

private theorem row_26 : row 26 = [0, 1, 67108837, 2540053889352, 4434992805213952, 1369410928058096062, 131921922645609200622, 5291676010120725595552, 104363915717496364217992, 1122675365072416049765667, 7050392783099088207336727, 27046703891606667678608752, 65296181294847273536919072, 101019988341178648636047412, 101019988341178648636047412, 65296181294847273536919072, 27046703891606667678608752, 7050392783099088207336727, 1122675365072416049765667, 104363915717496364217992, 5291676010120725595552, 131921922645609200622, 1369410928058096062, 4434992805213952, 2540053889352, 67108837, 1] := by
  rw [row]
  simp only [row_25]
  decide

private theorem row_27 : row 27 = [0, 1, 134217700, 7621839388981, 17800932514200256, 6949059474810401206, 821658576290933317096, 39812092446402872381926, 940744845942385425654976, 12086992684284175368032851, 90712084402294370969149276, 417370420120357843989420631, 1216301437803873965300768896, 2292702567858031535322402436, 2828559673553002161809327536, 2292702567858031535322402436, 1216301437803873965300768896, 417370420120357843989420631, 90712084402294370969149276, 12086992684284175368032851, 940744845942385425654976, 39812092446402872381926, 821658576290933317096, 6949059474810401206, 17800932514200256, 7621839388981, 134217700, 1] := by
  rw [row]
  simp only [row_26]
  decide

private theorem row_28 : row 28 = [0, 1, 268435427, 22869007827143, 71394276041525549, 35172519754392812174, 5089779825666239130314, 296761135803220639649594, 8362012708913543725260254, 127597831077405286825395179, 1136773705024343041684116929, 6223892140565234961328313909, 21690914395692570931429377479, 49265956387016393404003534004, 73990373947612503295166622044, 73990373947612503295166622044, 49265956387016393404003534004, 21690914395692570931429377479, 6223892140565234961328313909, 1136773705024343041684116929, 127597831077405286825395179, 8362012708913543725260254, 296761135803220639649594, 5089779825666239130314, 35172519754392812174, 71394276041525549, 22869007827143, 268435427, 1] := by
  rw [row]
  simp only [row_27]
  decide

private theorem row_29 : row 29 = [0, 1, 536870882, 68614271237958, 286171698369607914, 177647455673002199595, 31382819428102862274060, 2194392886612867977544380, 73424846658979203874373100, 1323982746583831999659021945, 13919693671791536153349072870, 90061513941680102366609674650, 372321031278485080481062180110, 1009202977757986820086345359195, 1824120537458837340596389252680, 2219711218428375098854998661320, 1824120537458837340596389252680, 1009202977757986820086345359195, 372321031278485080481062180110, 90061513941680102366609674650, 13919693671791536153349072870, 1323982746583831999659021945, 73424846658979203874373100, 2194392886612867977544380, 31382819428102862274060, 177647455673002199595, 286171698369607914, 68614271237958, 536870882, 1] := by
  rw [row]
  simp only [row_28]
  decide

private theorem row_30 : row 30 = [0, 1, 1073741793, 205857846098570, 1146539378801856522, 895677742522620803739, 192738102960442228634235, 16113937872564544537388100, 637869809663929594478505540, 13531191345752030482167405705, 167000574396175833526330189545, 1269070526794311849099687878550, 6179021140233742910738329979670, 19821417273866560109781608911515, 42694138146309498709817320643835, 62481596875767023932367207962680, 62481596875767023932367207962680, 42694138146309498709817320643835, 19821417273866560109781608911515, 6179021140233742910738329979670, 1269070526794311849099687878550, 167000574396175833526330189545, 13531191345752030482167405705, 637869809663929594478505540, 16113937872564544537388100, 192738102960442228634235, 895677742522620803739, 1146539378801856522, 205857846098570, 1073741793, 1] := by
  rw [row]
  simp only [row_29]
  decide

private theorem row_31 : row 31 = [0, 1, 2147483616, 617604676807707, 4591921534898186048, 4509345275840754144789, 1179716239068241512702624, 117616017681962867477572575, 5489692986252985824725358720, 136451727734038655012512278765, 1967691953568303005870984820960, 17466787857057122844149500644495, 99529664218691151910853717327040, 375079826224706396731189185463425, 954503444977931063913511449420960, 1663024301623766837052402570385395, 1999411100024544765835750654805760, 1663024301623766837052402570385395, 954503444977931063913511449420960, 375079826224706396731189185463425, 99529664218691151910853717327040, 17466787857057122844149500644495, 1967691953568303005870984820960, 136451727734038655012512278765, 5489692986252985824725358720, 117616017681962867477572575, 1179716239068241512702624, 4509345275840754144789, 4591921534898186048, 617604676807707, 2147483616, 1] := by
  rw [row]
  simp only [row_30]
  decide

private theorem bc_0 : bc 31 0 = 0 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_1 : bc 31 1 = 8222838654177922817725562880000000 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_2 : bc 31 2 = 1019876284891417752173780713582876237946 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_3 : bc 31 3 = 1722433429566956668281824835542923896205916 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_4 : bc 31 4 = 405637706696062415080341869015283875411961782 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_5 : bc 31 5 = 28198364303117108291430112702639043120328787864 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_6 : bc 31 6 = 810937844530080865006429740043073282895099918442 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_7 : bc 31 7 = 11587673272539162166057377698390773920304713986644 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_8 : bc 31 8 = 91953252951666778444661939448803582043672656738494 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_9 : bc 31 9 = 435637503228241467867288708411213493565493173373904 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_10 : bc 31 10 = 1293982676245829054087134284496488452042675801310994 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_11 : bc 31 11 = 2492126059038624767604504697400497198920770180098444 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_12 : bc 31 12 = 3183757818566788755420122943878673930923709949752934 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_13 : bc 31 13 = 2737604376527814482874529453853775285261087524531464 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_14 : bc 31 14 = 1597013198275474016887333987290999671095561346532154 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_15 : bc 31 15 = 633410698552433349016238220423832621485214787113924 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_16 : bc 31 16 = 170245174742652111688561800541415507048334552089614 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_17 : bc 31 17 = 30737693760899787608822549227482544446476545463104 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_18 : bc 31 18 = 3673662126252489465029100028113941617622904471394 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_19 : bc 31 19 = 284464974375394815446177873822531016790632651004 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_20 : bc 31 20 = 13853015704930641834137913315105491581148955574 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_21 : bc 31 21 = 407533634402543691448370786534145715279043704 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_22 : bc 31 22 = 6860122383063087444381556785744598531860874 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_23 : bc 31 23 = 61395892464596143970312293461693970417204 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_24 : bc 31 24 = 264197271671041675599697979000976556894 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_25 : bc 31 25 = 472415390050413610488823686058616224 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_26 : bc 31 26 = 284282358394432307516803727704834 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_27 : bc 31 27 = 46071312780052642916611697932 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_28 : bc 31 28 = 773659503129876993888790 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_29 : bc 31 29 = 2307078117635578902 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_30 : bc 31 30 = 4294967232 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private theorem bc_31 : bc 31 31 = 1 := by
  norm_num [bc, Finset.sum_Icc_succ_top, A, row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11, row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22, row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, List.getD]

private def cs : List ℤ :=
  [8222838654177922817725562880000000, 1019876284891417752173780713582876237946, 1722433429566956668281824835542923896205916, 405637706696062415080341869015283875411961782, 28198364303117108291430112702639043120328787864, 810937844530080865006429740043073282895099918442, 11587673272539162166057377698390773920304713986644, 91953252951666778444661939448803582043672656738494, 435637503228241467867288708411213493565493173373904, 1293982676245829054087134284496488452042675801310994, 2492126059038624767604504697400497198920770180098444, 3183757818566788755420122943878673930923709949752934, 2737604376527814482874529453853775285261087524531464, 1597013198275474016887333987290999671095561346532154, 633410698552433349016238220423832621485214787113924, 170245174742652111688561800541415507048334552089614, 30737693760899787608822549227482544446476545463104, 3673662126252489465029100028113941617622904471394, 284464974375394815446177873822531016790632651004, 13853015704930641834137913315105491581148955574, 407533634402543691448370786534145715279043704, 6860122383063087444381556785744598531860874, 61395892464596143970312293461693970417204, 264197271671041675599697979000976556894, 472415390050413610488823686058616224, 284282358394432307516803727704834, 46071312780052642916611697932, 773659503129876993888790, 2307078117635578902, 4294967232]

private noncomputable def H : ℝ[X] := hp cs

/-- Checked ordinary matrix product and the extracted zero root. -/
theorem factor_row31 : B 31 = X * H := by
  norm_num [B, Finset.sum_range_succ, bc_0, bc_1, bc_2, bc_3, bc_4, bc_5, bc_6, bc_7, bc_8, bc_9, bc_10, bc_11, bc_12, bc_13, bc_14, bc_15, bc_16, bc_17, bc_18, bc_19, bc_20, bc_21, bc_22, bc_23, bc_24, bc_25, bc_26, bc_27, bc_28, bc_29, bc_30, bc_31, H, cs, hp]
  simp only [map_ofNat]
  ring

private theorem H_degree : H.natDegree = 30 ∧ H ≠ 0 := hp_degree cs

/-- The certificate is for a monic polynomial of degree 31. -/
theorem row31_monic_degree : (B 31).Monic ∧ (B 31).natDegree = 31 := by
  rw [factor_row31]
  exact ⟨monic_X.mul (hp_monic cs), by rw [natDegree_X_mul H_degree.2, H_degree.1]⟩

private theorem sign_0 : 0 < H.eval ((-20952087472775824235368025761820633369787448936103936 : ℝ) / 1) := by
  convert eval_pos cs (-20952087472775824235368025761820633369787448936103936) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_1 : H.eval ((-3221225472 : ℝ) / 1) < 0 := by
  convert eval_neg cs (-3221225472) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_2 : 0 < H.eval ((-536870912 : ℝ) / 1) := by
  convert eval_pos cs (-536870912) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_3 : H.eval ((-229376 : ℝ) / 1) < 0 := by
  convert eval_neg cs (-229376) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_4 : 0 < H.eval ((-65536 : ℝ) / 1) := by
  convert eval_pos cs (-65536) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_5 : H.eval ((-4096 : ℝ) / 1) < 0 := by
  convert eval_neg cs (-4096) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_6 : 0 < H.eval ((-1280 : ℝ) / 1) := by
  convert eval_pos cs (-1280) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_7 : H.eval ((-384 : ℝ) / 1) < 0 := by
  convert eval_neg cs (-384) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_8 : 0 < H.eval ((-160 : ℝ) / 1) := by
  convert eval_pos cs (-160) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_9 : H.eval ((-80 : ℝ) / 1) < 0 := by
  convert eval_neg cs (-80) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_10 : 0 < H.eval ((-40 : ℝ) / 1) := by
  convert eval_pos cs (-40) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_11 : H.eval ((-24 : ℝ) / 1) < 0 := by
  convert eval_neg cs (-24) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_12 : 0 < H.eval ((-14 : ℝ) / 1) := by
  convert eval_pos cs (-14) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_13 : H.eval ((-10 : ℝ) / 1) < 0 := by
  convert eval_neg cs (-10) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_14 : 0 < H.eval ((-6 : ℝ) / 1) := by
  convert eval_pos cs (-6) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_15 : H.eval ((-4 : ℝ) / 1) < 0 := by
  convert eval_neg cs (-4) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_16 : 0 < H.eval ((-3 : ℝ) / 1) := by
  convert eval_pos cs (-3) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_17 : H.eval ((-2 : ℝ) / 1) < 0 := by
  convert eval_neg cs (-2) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_18 : 0 < H.eval ((-3 : ℝ) / 2) := by
  convert eval_pos cs (-3) 2 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_19 : H.eval ((-5 : ℝ) / 4) < 0 := by
  convert eval_neg cs (-5) 4 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_20 : 0 < H.eval ((-7 : ℝ) / 8) := by
  convert eval_pos cs (-7) 8 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_21 : H.eval ((-5 : ℝ) / 8) < 0 := by
  convert eval_neg cs (-5) 8 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_22 : 0 < H.eval ((-3 : ℝ) / 8) := by
  convert eval_pos cs (-3) 8 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_23 : H.eval ((-1 : ℝ) / 4) < 0 := by
  convert eval_neg cs (-1) 4 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_24 : 0 < H.eval ((-5 : ℝ) / 32) := by
  convert eval_pos cs (-5) 32 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_25 : H.eval ((-3 : ℝ) / 32) < 0 := by
  convert eval_neg cs (-3) 32 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_26 : 0 < H.eval ((-3 : ℝ) / 64) := by
  convert eval_pos cs (-3) 64 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_27 : H.eval ((-5 : ℝ) / 256) < 0 := by
  convert eval_neg cs (-5) 256 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_28 : 0 < H.eval ((-5 : ℝ) / 1024) := by
  convert eval_pos cs (-5) 1024 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_29 : H.eval ((-5 : ℝ) / 8192) < 0 := by
  convert eval_neg cs (-5) 8192 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_30 : 0 < H.eval ((-1 : ℝ) / 131072) := by
  convert eval_pos cs (-1) 131072 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private def ends (i : Fin 31) : ℚ :=
  ([(-20952087472775824235368025761820633369787448936103936 : ℚ) / 1, (-3221225472 : ℚ) / 1, (-536870912 : ℚ) / 1, (-229376 : ℚ) / 1, (-65536 : ℚ) / 1, (-4096 : ℚ) / 1, (-1280 : ℚ) / 1, (-384 : ℚ) / 1, (-160 : ℚ) / 1, (-80 : ℚ) / 1, (-40 : ℚ) / 1, (-24 : ℚ) / 1, (-14 : ℚ) / 1, (-10 : ℚ) / 1, (-6 : ℚ) / 1, (-4 : ℚ) / 1, (-3 : ℚ) / 1, (-2 : ℚ) / 1, (-3 : ℚ) / 2, (-5 : ℚ) / 4, (-7 : ℚ) / 8, (-5 : ℚ) / 8, (-3 : ℚ) / 8, (-1 : ℚ) / 4, (-5 : ℚ) / 32, (-3 : ℚ) / 32, (-3 : ℚ) / 64, (-5 : ℚ) / 256, (-5 : ℚ) / 1024, (-5 : ℚ) / 8192, (-1 : ℚ) / 131072] : List ℚ).getD i.val 0

private theorem ends_mono : StrictMono ends := by decide +kernel

private theorem ends_neg : ∀ i, ends i < 0 := by decide +kernel

private theorem H_certificate : H.Splits ∧ ∀ x : ℝ, H.eval x = 0 → x < 0 := by
  have hm : StrictMono (fun i => (ends i : ℝ)) := by
    intro i j hij
    exact Rat.cast_lt.mpr (ends_mono hij)
  have hn : ∀ i, (ends i : ℝ) < 0 := by
    intro i
    exact_mod_cast ends_neg i
  have hs : ∀ i : Fin 30,
      H.eval (ends i.castSucc : ℝ) * H.eval (ends i.succ : ℝ) < 0 := by
    intro i
    fin_cases i
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_0 sign_1)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_1 sign_2)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_2 sign_3)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_3 sign_4)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_4 sign_5)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_5 sign_6)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_6 sign_7)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_7 sign_8)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_8 sign_9)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_9 sign_10)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_10 sign_11)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_11 sign_12)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_12 sign_13)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_13 sign_14)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_14 sign_15)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_15 sign_16)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_16 sign_17)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_17 sign_18)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_18 sign_19)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_19 sign_20)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_20 sign_21)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_21 sign_22)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_22 sign_23)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_23 sign_24)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_24 sign_25)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_25 sign_26)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_26 sign_27)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_27 sign_28)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_28 sign_29)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_29 sign_30)
  exact split_from_endpoints H 30 H_degree.2 H_degree.1 _ hm hn hs

/-- Conjecture 4.1 for the ordinary matrix square A^2 in row 31. -/
theorem certified_row31 : (B 31).Splits ∧
    ∀ x : ℝ, (B 31).eval x = 0 → x ≤ 0 := by
  obtain ⟨hsp, hnegative⟩ := H_certificate
  constructor
  · rw [factor_row31]
    exact splits_X_mul.mpr hsp
  · intro x hx
    rw [factor_row31, eval_mul, eval_X] at hx
    rcases mul_eq_zero.mp hx with h | h
    · exact h.le
    · exact (hnegative x h).le

#print axioms A_recurrence
#print axioms factor_row31
#print axioms certified_row31

end D5.S3.Zeros.Convolution.EulerianSquareRow31
