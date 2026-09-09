/- GID: D5/S3/Zeros/Convolution/EulerianSquareRow32
   generality: I
   mirror-B: D5/B/S3/Zeros/Convolution/EulerianSquareRow32
   mirror-E: none(waiver:kernel-checked-integer-certificate)
   anchors: []
   utility: kind=certified-instance; basis=terminal=gid:D5/S3/Zeros/Convolution/EulerianSquareRow32.certified_row32
   digest: The ordinary Eulerian matrix square has only real nonpositive roots in row 32. -/

/-
Mao--Wang, arXiv:2607.01572v1, Conjecture 4.1, PDF page 11.
Only A^2 at n = 32 is certified. The literature recheck and bind-only
failure are recorded in docs/reports/eulerian-square-row32-r19.md.
No worldwide priority claim is made.

All triangle entries are equality certificates for the imported row
definition, and bc_values checks the ordinary matrix product against bc.
The 32 rational endpoints give 31 negative roots of the degree-31
quotient. Together with zero these exhaust the degree of B 32.
-/

import D5.S3.Zeros.Convolution.EulerianSquareRow31
import Mathlib.Tactic.IntervalCases

open Polynomial
open D5.S3.Zeros.Convolution.EulerianSquareRow31

set_option maxRecDepth 10000
set_option maxHeartbeats 4000000
set_option backward.isDefEq.respectTransparency false

namespace D5.S3.Zeros.Convolution.EulerianSquareRow32

private theorem row_0 : row 0 =
  [1] := by
  rfl

theorem row_1 : row 1 =
  [0, 1] := by
  rw [row]
  simp only [row_0]
  decide

theorem row_2 : row 2 =
  [0, 1, 1] := by
  rw [row]
  simp only [row_1]
  decide

theorem row_3 : row 3 =
  [0, 1, 4, 1] := by
  rw [row]
  simp only [row_2]
  decide

theorem row_4 : row 4 =
  [0, 1, 11, 11, 1] := by
  rw [row]
  simp only [row_3]
  decide

theorem row_5 : row 5 =
  [0, 1, 26, 66, 26, 1] := by
  rw [row]
  simp only [row_4]
  decide

theorem row_6 : row 6 =
  [0, 1, 57, 302, 302, 57, 1] := by
  rw [row]
  simp only [row_5]
  decide

theorem row_7 : row 7 =
  [0, 1, 120, 1191, 2416, 1191, 120, 1] := by
  rw [row]
  simp only [row_6]
  decide

theorem row_8 : row 8 =
  [0, 1, 247, 4293, 15619, 15619, 4293, 247, 1] := by
  rw [row]
  simp only [row_7]
  decide

theorem row_9 : row 9 =
  [0, 1, 502, 14608, 88234, 156190, 88234, 14608, 502, 1] := by
  rw [row]
  simp only [row_8]
  decide

theorem row_10 : row 10 =
  [0, 1, 1013, 47840, 455192, 1310354, 1310354, 455192, 47840, 1013, 1] := by
  rw [row]
  simp only [row_9]
  decide

theorem row_11 : row 11 =
  [0, 1, 2036, 152637, 2203488, 9738114, 15724248, 9738114, 2203488, 152637, 2036, 1] := by
  rw [row]
  simp only [row_10]
  decide

theorem row_12 : row 12 =
  [0, 1, 4083, 478271, 10187685, 66318474, 162512286, 162512286, 66318474, 10187685, 478271,
   4083, 1] := by
  rw [row]
  simp only [row_11]
  decide

theorem row_13 : row 13 =
  [0, 1, 8178, 1479726, 45533450, 423281535, 1505621508, 2275172004, 1505621508, 423281535,
   45533450, 1479726, 8178, 1] := by
  rw [row]
  simp only [row_12]
  decide

theorem row_14 : row 14 =
  [0, 1, 16369, 4537314, 198410786, 2571742175, 12843262863, 27971176092, 27971176092,
   12843262863, 2571742175, 198410786, 4537314, 16369, 1] := by
  rw [row]
  simp only [row_13]
  decide

theorem row_15 : row 15 =
  [0, 1, 32752, 13824739, 848090912, 15041229521, 102776998928, 311387598411, 447538817472,
   311387598411, 102776998928, 15041229521, 848090912, 13824739, 32752, 1] := by
  rw [row]
  simp only [row_14]
  decide

theorem row_16 : row 16 =
  [0, 1, 65519, 41932745, 3572085255, 85383238549, 782115518299, 3207483178157, 6382798925475,
   6382798925475, 3207483178157, 782115518299, 85383238549, 3572085255, 41932745, 65519, 1] := by
  rw [row]
  simp only [row_15]
  decide

theorem row_17 : row 17 =
  [0, 1, 131054, 126781020, 14875399450, 473353301060, 5717291972382, 31055652948388,
   83137223185370, 114890380658550, 83137223185370, 31055652948388, 5717291972382,
   473353301060, 14875399450, 126781020, 131054, 1] := by
  rw [row]
  simp only [row_16]
  decide

theorem row_18 : row 18 =
  [0, 1, 262125, 382439924, 61403313100, 2575022097600, 40457344748072, 285997074307300,
   1006709967915228, 1865385657780650, 1865385657780650, 1006709967915228, 285997074307300,
   40457344748072, 2575022097600, 61403313100, 382439924, 262125, 1] := by
  rw [row]
  simp only [row_17]
  decide

theorem row_19 : row 19 =
  [0, 1, 524268, 1151775897, 251732291184, 13796160184500, 278794377854832, 2527925001876036,
   11485644635009424, 27862280567093358, 37307713155613000, 27862280567093358,
   11485644635009424, 2527925001876036, 278794377854832, 13796160184500, 251732291184,
   1151775897, 524268, 1] := by
  rw [row]
  simp only [row_18]
  decide

theorem row_20 : row 20 =
  [0, 1, 1048555, 3464764515, 1026509354985, 73008517581444, 1879708669896492,
   21598596303099900, 124748182104463860, 388588260723953310, 679562217794156938,
   679562217794156938, 388588260723953310, 124748182104463860, 21598596303099900,
   1879708669896492, 73008517581444, 1026509354985, 3464764515, 1048555, 1] := by
  rw [row]
  simp only [row_19]
  decide

theorem row_21 : row 21 =
  [0, 1, 2097130, 10414216090, 4168403181210, 382493246941965, 12446388300682056,
   179385804170146680, 1300365805079109480, 5119020713873609970, 11458681306629009100,
   14950368791471452636, 11458681306629009100, 5119020713873609970, 1300365805079109480,
   179385804170146680, 12446388300682056, 382493246941965, 4168403181210, 10414216090, 2097130,
   1] := by
  rw [row]
  simp only [row_20]
  decide

theorem row_22 : row 22 =
  [0, 1, 4194281, 31284590870, 16871482830550, 1987497491971605, 81180715002105741,
   1454842842001939656, 13093713503185076040, 64276307695970022450, 181134082346647020610,
   301958232385734088196, 301958232385734088196, 181134082346647020610, 64276307695970022450,
   13093713503185076040, 1454842842001939656, 81180715002105741, 1987497491971605,
   16871482830550, 31284590870, 4194281, 1] := by
  rw [row]
  simp only [row_21]
  decide

theorem row_23 : row 23 =
  [0, 1, 8388584, 93941852511, 68111623139600, 10258045633638475, 522859244868123336,
   11563972049049375189, 128027193497511642816, 774892471811506342650, 2711209131210050520400,
   5676283626749486238086, 7246997577257618116704, 5676283626749486238086,
   2711209131210050520400, 774892471811506342650, 128027193497511642816, 11563972049049375189,
   522859244868123336, 10258045633638475, 68111623139600, 93941852511, 8388584, 1] := by
  rw [row]
  simp only [row_22]
  decide

theorem row_24 : row 24 =
  [0, 1, 16777191, 282010106381, 274419271461131, 52652460630984375, 3332058336247871041,
   90359270750971846371, 1220805072813932520741, 9022467342263743368906,
   38735478389273100343750, 100396047731185055904546, 160755658074834738495566,
   160755658074834738495566, 100396047731185055904546, 38735478389273100343750,
   9022467342263743368906, 1220805072813932520741, 90359270750971846371, 3332058336247871041,
   52652460630984375, 274419271461131, 282010106381, 16777191, 1] := by
  rw [row]
  simp only [row_23]
  decide

theorem row_25 : row 25 =
  [0, 1, 33554406, 846416194536, 1103881308184906, 269025107855605626, 21045399230106913746,
   695824003645512474376, 11392907456028953400606, 101955892318210543172751,
   531714261368950897339996, 1685388700882132120106256, 3334612565134607644610436,
   4179647109945703200884716, 3334612565134607644610436, 1685388700882132120106256,
   531714261368950897339996, 101955892318210543172751, 11392907456028953400606,
   695824003645512474376, 21045399230106913746, 269025107855605626, 1103881308184906,
   846416194536, 33554406, 1] := by
  rw [row]
  simp only [row_24]
  decide

theorem row_26 : row 26 =
  [0, 1, 67108837, 2540053889352, 4434992805213952, 1369410928058096062, 131921922645609200622,
   5291676010120725595552, 104363915717496364217992, 1122675365072416049765667,
   7050392783099088207336727, 27046703891606667678608752, 65296181294847273536919072,
   101019988341178648636047412, 101019988341178648636047412, 65296181294847273536919072,
   27046703891606667678608752, 7050392783099088207336727, 1122675365072416049765667,
   104363915717496364217992, 5291676010120725595552, 131921922645609200622,
   1369410928058096062, 4434992805213952, 2540053889352, 67108837, 1] := by
  rw [row]
  simp only [row_25]
  decide

theorem row_27 : row 27 =
  [0, 1, 134217700, 7621839388981, 17800932514200256, 6949059474810401206,
   821658576290933317096, 39812092446402872381926, 940744845942385425654976,
   12086992684284175368032851, 90712084402294370969149276, 417370420120357843989420631,
   1216301437803873965300768896, 2292702567858031535322402436, 2828559673553002161809327536,
   2292702567858031535322402436, 1216301437803873965300768896, 417370420120357843989420631,
   90712084402294370969149276, 12086992684284175368032851, 940744845942385425654976,
   39812092446402872381926, 821658576290933317096, 6949059474810401206, 17800932514200256,
   7621839388981, 134217700, 1] := by
  rw [row]
  simp only [row_26]
  decide

theorem row_28 : row 28 =
  [0, 1, 268435427, 22869007827143, 71394276041525549, 35172519754392812174,
   5089779825666239130314, 296761135803220639649594, 8362012708913543725260254,
   127597831077405286825395179, 1136773705024343041684116929, 6223892140565234961328313909,
   21690914395692570931429377479, 49265956387016393404003534004, 73990373947612503295166622044,
   73990373947612503295166622044, 49265956387016393404003534004, 21690914395692570931429377479,
   6223892140565234961328313909, 1136773705024343041684116929, 127597831077405286825395179,
   8362012708913543725260254, 296761135803220639649594, 5089779825666239130314,
   35172519754392812174, 71394276041525549, 22869007827143, 268435427, 1] := by
  rw [row]
  simp only [row_27]
  decide

theorem row_29 : row 29 =
  [0, 1, 536870882, 68614271237958, 286171698369607914, 177647455673002199595,
   31382819428102862274060, 2194392886612867977544380, 73424846658979203874373100,
   1323982746583831999659021945, 13919693671791536153349072870, 90061513941680102366609674650,
   372321031278485080481062180110, 1009202977757986820086345359195,
   1824120537458837340596389252680, 2219711218428375098854998661320,
   1824120537458837340596389252680, 1009202977757986820086345359195,
   372321031278485080481062180110, 90061513941680102366609674650,
   13919693671791536153349072870, 1323982746583831999659021945, 73424846658979203874373100,
   2194392886612867977544380, 31382819428102862274060, 177647455673002199595,
   286171698369607914, 68614271237958, 536870882, 1] := by
  rw [row]
  simp only [row_28]
  decide

theorem row_30 : row 30 =
  [0, 1, 1073741793, 205857846098570, 1146539378801856522, 895677742522620803739,
   192738102960442228634235, 16113937872564544537388100, 637869809663929594478505540,
   13531191345752030482167405705, 167000574396175833526330189545,
   1269070526794311849099687878550, 6179021140233742910738329979670,
   19821417273866560109781608911515, 42694138146309498709817320643835,
   62481596875767023932367207962680, 62481596875767023932367207962680,
   42694138146309498709817320643835, 19821417273866560109781608911515,
   6179021140233742910738329979670, 1269070526794311849099687878550,
   167000574396175833526330189545, 13531191345752030482167405705, 637869809663929594478505540,
   16113937872564544537388100, 192738102960442228634235, 895677742522620803739,
   1146539378801856522, 205857846098570, 1073741793, 1] := by
  rw [row]
  simp only [row_29]
  decide

theorem row_31 : row 31 =
  [0, 1, 2147483616, 617604676807707, 4591921534898186048, 4509345275840754144789,
   1179716239068241512702624, 117616017681962867477572575, 5489692986252985824725358720,
   136451727734038655012512278765, 1967691953568303005870984820960,
   17466787857057122844149500644495, 99529664218691151910853717327040,
   375079826224706396731189185463425, 954503444977931063913511449420960,
   1663024301623766837052402570385395, 1999411100024544765835750654805760,
   1663024301623766837052402570385395, 954503444977931063913511449420960,
   375079826224706396731189185463425, 99529664218691151910853717327040,
   17466787857057122844149500644495, 1967691953568303005870984820960,
   136451727734038655012512278765, 5489692986252985824725358720, 117616017681962867477572575,
   1179716239068241512702624, 4509345275840754144789, 4591921534898186048, 617604676807707,
   2147483616, 1] := by
  rw [row]
  simp only [row_30]
  decide

theorem row_32 : row 32 =
  [0, 1, 4294967263, 1852878454931601, 18385596675220167695, 22675300182180919933289,
   7200049756857149438125047, 853984745989514351673276249, 46857944332072958284742184135,
   1359818181276419554906019118165, 22815309273565919123997630621195,
   235423889406131017414806173150565, 1561158515622493402657384121458875,
   6866631025295006195722533757565325, 20489564927960456432681754815698515,
   42126426533959261706229244645358205, 60261990727996752483262854173443875,
   60261990727996752483262854173443875, 42126426533959261706229244645358205,
   20489564927960456432681754815698515, 6866631025295006195722533757565325,
   1561158515622493402657384121458875, 235423889406131017414806173150565,
   22815309273565919123997630621195, 1359818181276419554906019118165,
   46857944332072958284742184135, 853984745989514351673276249, 7200049756857149438125047,
   22675300182180919933289, 18385596675220167695, 1852878454931601, 4294967263, 1] := by
  rw [row]
  simp only [row_31]
  decide

private def cs : List ℤ :=
  [263130836933693530167218012160000000, 47085703381823453661591054959076910952790,
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
   210800663574628765100280968850910608539602576, 1534758389880153393433794146840800392281266,
   5297601479135562895176083621300820144436, 7445614253570070471904033423974140206,
   3411366788482033071777525772640536, 411022457335040192944739680762,
   4642141673967474301531924, 9227077585458726210, 8589934526]

private noncomputable def H : ℝ[X] := hp cs

private theorem bc_values (k : ℕ) (hk : k ≤ 32) :
    bc 32 k = (0 :: (cs ++ [1])).getD k 0 := by
  interval_cases k <;>
    norm_num [bc, Finset.sum_Icc_succ_top, A,
      row_0, row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8, row_9, row_10, row_11,
       row_12, row_13, row_14, row_15, row_16, row_17, row_18, row_19, row_20, row_21, row_22,
       row_23, row_24, row_25, row_26, row_27, row_28, row_29, row_30, row_31, row_32,
       List.getD, cs]

/-- Exact matrix multiplication connects the certificate to the imported B. -/
theorem factor_row32 : B 32 = X * H := by
  norm_num [B, Finset.sum_range_succ, bc_values, H, cs, hp]
  simp only [map_ofNat]
  ring

private theorem H_degree : H.natDegree = 31 ∧ H ≠ 0 := hp_degree cs

/-- The certified row is monic of degree 32. -/
theorem row32_monic_degree : (B 32).Monic ∧ (B 32).natDegree = 32 := by
  rw [factor_row32]
  exact ⟨monic_X.mul (hp_monic cs),
    by rw [natDegree_X_mul H_degree.2, H_degree.1]⟩

/-- Zero is the remaining root after the negative quotient roots. -/
theorem row32_zero : (B 32).eval 0 = 0 := by
  rw [factor_row32]
  simp

private theorem sign_0 : H.eval ((-33822867456 : ℝ) / 1) < 0 := by
  convert eval_neg cs (-33822867456) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_1 : 0 < H.eval ((-7247757312 : ℝ) / 1) := by
  convert eval_pos cs (-7247757312) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_2 : H.eval ((-1241513984 : ℝ) / 1) < 0 := by
  convert eval_neg cs (-1241513984) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_3 : 0 < H.eval ((-385024 : ℝ) / 1) := by
  convert eval_pos cs (-385024) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_4 : H.eval ((-100352 : ℝ) / 1) < 0 := by
  convert eval_neg cs (-100352) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_5 : 0 < H.eval ((-6016 : ℝ) / 1) := by
  convert eval_pos cs (-6016) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_6 : H.eval ((-1920 : ℝ) / 1) < 0 := by
  convert eval_neg cs (-1920) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_7 : 0 < H.eval ((-528 : ℝ) / 1) := by
  convert eval_pos cs (-528) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_8 : H.eval ((-212 : ℝ) / 1) < 0 := by
  convert eval_neg cs (-212) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_9 : 0 < H.eval ((-102 : ℝ) / 1) := by
  convert eval_pos cs (-102) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_10 : H.eval ((-53 : ℝ) / 1) < 0 := by
  convert eval_neg cs (-53) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_11 : 0 < H.eval ((-61 : ℝ) / 2) := by
  convert eval_pos cs (-61) 2 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_12 : H.eval ((-37 : ℝ) / 2) < 0 := by
  convert eval_neg cs (-37) 2 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_13 : 0 < H.eval ((-12 : ℝ) / 1) := by
  convert eval_pos cs (-12) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_14 : H.eval ((-8 : ℝ) / 1) < 0 := by
  convert eval_neg cs (-8) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_15 : 0 < H.eval ((-45 : ℝ) / 8) := by
  convert eval_pos cs (-45) 8 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_16 : H.eval ((-4 : ℝ) / 1) < 0 := by
  convert eval_neg cs (-4) 1 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_17 : 0 < H.eval ((-23 : ℝ) / 8) := by
  convert eval_pos cs (-23) 8 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_18 : H.eval ((-33 : ℝ) / 16) < 0 := by
  convert eval_neg cs (-33) 16 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_19 : 0 < H.eval ((-3 : ℝ) / 2) := by
  convert eval_pos cs (-3) 2 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_20 : H.eval ((-35 : ℝ) / 32) < 0 := by
  convert eval_neg cs (-35) 32 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_21 : 0 < H.eval ((-25 : ℝ) / 32) := by
  convert eval_pos cs (-25) 32 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_22 : H.eval ((-35 : ℝ) / 64) < 0 := by
  convert eval_neg cs (-35) 64 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_23 : 0 < H.eval ((-49 : ℝ) / 128) := by
  convert eval_pos cs (-49) 128 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_24 : H.eval ((-1 : ℝ) / 4) < 0 := by
  convert eval_neg cs (-1) 4 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_25 : 0 < H.eval ((-5 : ℝ) / 32) := by
  convert eval_pos cs (-5) 32 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_26 : H.eval ((-23 : ℝ) / 256) < 0 := by
  convert eval_neg cs (-23) 256 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_27 : 0 < H.eval ((-23 : ℝ) / 512) := by
  convert eval_pos cs (-23) 512 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_28 : H.eval ((-9 : ℝ) / 512) < 0 := by
  convert eval_neg cs (-9) 512 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_29 : 0 < H.eval ((-39 : ℝ) / 8192) := by
  convert eval_pos cs (-39) 8192 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_30 : H.eval ((-35 : ℝ) / 65536) < 0 := by
  convert eval_neg cs (-35) 65536 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private theorem sign_31 : 0 < H.eval ((-47 : ℝ) / 8388608) := by
  convert eval_pos cs (-47) 8388608 (by norm_num)
    (by norm_num [hv, cs]) using 1 <;> norm_num [H]

private def ends (i : Fin 32) : ℚ :=
  ([(-33822867456 : ℚ) / 1, (-7247757312 : ℚ) / 1, (-1241513984 : ℚ) / 1, (-385024 : ℚ) / 1,
     (-100352 : ℚ) / 1, (-6016 : ℚ) / 1, (-1920 : ℚ) / 1, (-528 : ℚ) / 1, (-212 : ℚ) / 1,
     (-102 : ℚ) / 1, (-53 : ℚ) / 1, (-61 : ℚ) / 2, (-37 : ℚ) / 2, (-12 : ℚ) / 1, (-8 : ℚ) / 1,
     (-45 : ℚ) / 8, (-4 : ℚ) / 1, (-23 : ℚ) / 8, (-33 : ℚ) / 16, (-3 : ℚ) / 2, (-35 : ℚ) / 32,
     (-25 : ℚ) / 32, (-35 : ℚ) / 64, (-49 : ℚ) / 128, (-1 : ℚ) / 4, (-5 : ℚ) / 32,
     (-23 : ℚ) / 256, (-23 : ℚ) / 512, (-9 : ℚ) / 512, (-39 : ℚ) / 8192, (-35 : ℚ) / 65536,
     (-47 : ℚ) / 8388608] : List ℚ).getD i.val 0

private theorem ends_mono : StrictMono ends := by decide +kernel

private theorem ends_neg : ∀ i, ends i < 0 := by decide +kernel

private theorem H_certificate : H.Splits ∧ ∀ x : ℝ, H.eval x = 0 → x < 0 := by
  have hm : StrictMono (fun i => (ends i : ℝ)) := by
    intro i j hij
    exact Rat.cast_lt.mpr (ends_mono hij)
  have hn : ∀ i, (ends i : ℝ) < 0 := by
    intro i
    exact_mod_cast ends_neg i
  have hs : ∀ i : Fin 31,
      H.eval (ends i.castSucc : ℝ) * H.eval (ends i.succ : ℝ) < 0 := by
    intro i
    fin_cases i
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_0 sign_1)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_1 sign_2)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_2 sign_3)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_3 sign_4)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_4 sign_5)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_5 sign_6)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_6 sign_7)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_7 sign_8)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_8 sign_9)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_9 sign_10)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_10 sign_11)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_11 sign_12)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_12 sign_13)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_13 sign_14)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_14 sign_15)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_15 sign_16)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_16 sign_17)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_17 sign_18)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_18 sign_19)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_19 sign_20)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_20 sign_21)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_21 sign_22)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_22 sign_23)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_23 sign_24)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_24 sign_25)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_25 sign_26)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_26 sign_27)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_27 sign_28)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_28 sign_29)
    · simpa [ends, List.getD] using (mul_neg_of_pos_of_neg sign_29 sign_30)
    · simpa [ends, List.getD] using (mul_neg_of_neg_of_pos sign_30 sign_31)
  exact split_from_endpoints H 31 H_degree.2 H_degree.1 _ hm hn hs

/-- Conjecture 4.1 for the ordinary matrix square A^2 in row 32 only. -/
theorem certified_row32 : (B 32).Splits ∧
    ∀ x : ℝ, (B 32).eval x = 0 → x ≤ 0 := by
  obtain ⟨hsp, hnegative⟩ := H_certificate
  constructor
  · rw [factor_row32]
    exact splits_X_mul.mpr hsp
  · intro x hx
    rw [factor_row32, eval_mul, eval_X] at hx
    rcases mul_eq_zero.mp hx with h | h
    · exact h.le
    · exact (hnegative x h).le

#print axioms factor_row32
#print axioms row32_monic_degree
#print axioms row32_zero
#print axioms certified_row32

end D5.S3.Zeros.Convolution.EulerianSquareRow32
