---
bibkey: hanna2026a397family
authors: Paul D. Hanna
year: 2026
title: "OEIS A397345, A397348 and A397346: exponential square-weight congruences"
doi: null
url: https://oeis.org/A397345
claim: "For q=5 and q=3, a(n) is odd iff n+1 is a power of two; for q=2, a(n) modulo eight repeats 4,2,0,2 from n=2."
strata_touched:
  - D5/S1/Recurrence/Residue/ParametricExponentialSquareCongruence
license: citation-only
triage: anchor
---

# Exponential square-weight family

Skill context: lean4. One Codex implementation worker, within the caller's
consensus-rnd:sshx implementation attempt. No independent review is claimed.
Caller numerical readings and the triage note are inputs, not worker verification.
Base: e7e63c615460da48effcb4a76f96a3a6730af75d.

## Source and scope

The source equation is A=exp(L), where L=x+sum(n>=2)
(q*n^2-1)*a(n)*x^n/(q*n^2), with a(0)=a(1)=1.
Targets: q=5 (A397345), q=3 (A397348), q=1 (A397242), q=2 (A397346).
Only the parity targets for odd q and the modulo-eight target for q=2 are in scope.

## Bind-only probe and correction of triage

The pinned repository already contains the frozen exact q=1 endpoint
`D5/S1/Recurrence/Residue/ExponentialSquareWeightCatalanParity.hanna_conjecture`,
statement_id sha256:acdcefdae4fd84e8d43561a16d92b3cbaec20efc7c2548b4a5b97aacff9255a9.
The one-line application to arbitrary n compiled in the warm tree. The same
module supplies the differential reading and rational uniqueness of the source.
This contradicts the triage's treatment of q=1 as requiring a new implementation.
For q=1: proof_shape=bind-only; escape_witness=none; admission_basis=none
(no new deposit). Its proof uses direct instantiation only; it has no new
intermediate declaration, no new non-normalization step, no distinct escape
statement, and no new live escape path (CLAUDE 3.2 conditions i-iv).

Pinned Mathlib's catalan_succ and PowerSeries.coeff_exp signatures were read;
the former was also checked by Lean. Text searches in the pinned Mathlib tree
for Catalan odd/parity theorem names did not find an exact endpoint. Pinned D5
has binary_catalan and the q=1 endpoint, which take priority over reproving them.
No complete binding for q=3,5 or the q=2 modulus-eight statement was located.

## Pre-registration, before new proof probes

Proposed live witnesses: normalized coefficients for odd q agree modulo two
with the frozen q=1 coefficients; for q=2 and n>=2, normalized coefficients
are 6 modulo eight at n=3 modulo four and 2 otherwise. The second invariant
uses endpoint separation and evaluation of the interior convolution.
A rational source bridge and uniqueness must accompany the integer definitions.

## Literature receipts

Worker retrieved the complete OEIS JSON for A397345 revision 16, A397348
revision 10, and A397346 revision 10. Each still labels the target Conjecture.
The given rational recurrence is formula (6) for A397345 and formula (7)
for A397348/A397346. The unrelated formula (6) in the latter two is not used.

Supplement beyond the triage's direct-A searches: authenticated GitHub code
searches A397345/A397348/A397346 with language:Lean returned zero results.
General code search found jOEIS A397346.java; its full source defines a
PolynomialFieldSequence via the source differential formula, with no modular
proof. The requested jOEIS A397345.java path returned 404. General Google and
DuckDuckGo retrievals returned JavaScript/challenge pages; Bing returned
unrelated Microsoft results. These are failed/unusable searches, not negative
proof evidence. The triage's direct-A-reference investigations are attributed
and were not repeated in full. No published proof of the remaining endpoints
was found in these limited successfully read sources.

## Evidence

Initial make lean-cache-ensure exit 0: status=present, both layers warm,
mathlib_missing_olean_files=0,
pin_sha256=sha256:6c4c682ffba051b5744fe7a75ccc99d7f3b20227b3b026f392f3315be0adaa4e.
The registered route is S1/Recurrence/Residue; before addition it contained
7 Lean files, below SL-003's limit 48. No domain directory was added.

## ASSUMED-UNVERIFIED

No exhaustive literature search, novelty priority, independent review,
full build, freeze, merge, or resolution of the three remaining targets is
claimed at this checkpoint. The q=1 bind probe is not a new theorem deposit.
Caller ranges n=0..120 (odd q) and n=2..120 (q=2) are caller measurements.
The triage's n<=200/Fraction computations were not run by this worker.

First proof checkpoint: normalized_mod_two and odd_parameter_parity compiled
without diagnostics; each axiom closure is exactly propext, Classical.choice,
Quot.sound. The new strong induction transports coefficients to the frozen
q=1 series, so Catalan pairing is reused. Source correspondence remains to be
verified for the new parameters; no original-source resolution is claimed yet.

Second proof checkpoint: the generic integer logarithmic derivative identity,
exact rational coefficient shape, and uniqueness for every nonzero integer q
compiled. The formal source reading is q*X*A'=M*A with M=q*X*L'; at degree one
q!=0 forces a(1)=1, and at each higher degree the diagonal cancellation forces
the new coefficient. All coefficient-weight subtraction is in Z or Q;
natural subtraction occurs only in bounded indices. The source's q=sqrt(5)
in its unrelated reversion formula is not our integer weight parameter q=5.

Third proof checkpoint: normalized_mod_eight and residues_q2 compiled with
standard three-axiom closures. For n>=3 the endpoint contributes
(2*n*(n-1)-1)*b(2,n-1), and the interior contributes
2*(n-2)*(n-1)-4 in ZMod(8). The arithmetic step has eight residue cases;
strong induction covers every index, not just the tested range.

Independent worker numeric probe: for q=1,3,5 all n=0..120 satisfy the parity
criterion; for q=2 all n=2..120 satisfy both normalized and original modulus-eight
criteria. Zero failures. Fraction-based successive logarithm coefficients through
degree 20 match each integer recurrence. The available OEIS data fields for
q=3,5,2 also match. First six a-values:
q=1: 1,1,2,15,244,6420;
q=3: 1,1,6,153,7932,650010;
q=5: 1,1,10,435,38020,5230600;
q=2: 1,1,4,66,2248,121690.

## Continuation verification (attempt 3)

The continuation worker read all five inherited commits, starting at
bb412c5f7e and ending at rescue commit 3ee13b7551. The checkpoints above are
the predecessor's reports, not independent continuation measurements.
No additional worker or independent review seat was started.

Own cache receipt: make lean-cache-ensure exited 0; status=present,
project_olean_state=warm, mathlib_olean_state=warm, missing Mathlib oleans=0,
with the same pin_sha256 recorded above. Before continuation additions the
registered Residue directories had 8 Lean files and 14 Blueprint files;
Library/Recurrence had 33 files. No domain directory is created.

The first full make lean (LAKE_JOBS=1) exited 2. Its only failing target was
this module: the two `by norm_num` terms in family_conjectures left Odd 5
and Odd 3 unsolved. All seven other printed theorem closures, including the
rescued source_iff, were the standard three axioms. The repair supplies
the explicit witnesses 2 and 1, removes one unused tactic, and shortens the
header digest. LEAN_NUM_THREADS=1 is also supplied on subsequent runs:
the pinned Lake/repository source search found no LAKE_JOBS consumer, so
LAKE_JOBS=1 alone is not claimed to impose a process concurrency limit.

Own online recheck on 2026-09-09: OEIS JSON revisions A397345=16,
A397348=10, A397242=23, A397346=10; every target comment still says
Conjecture. Also read the NAME, COMMENT, FORMULA, REFERENCE, LINK and XREF
fields of all direct A references in the dispatch: A397245=22, A397347=7,
A397349=14, A038464=17, A397241=12 and A397243=9. Those fields supply no
proof of the targeted parity or modulus-eight assertions. The formula (6)
errors in A397348/A397346 are confirmed by comparison with formula (3)
of A397349/A397347 respectively and are not used. Initial urllib requests
returned HTTP 403; curl with the encoded id query succeeded. These are
bounded source checks, not a certification that no proof exists anywhere.

Own pinned-library reads: Catalan/Basic.lean:61,102 and
PowerSeries/Exp.lean:55,70,88 plus PowerSeries/Derivative.lean:140.
exp_unique_of_derivative_eq_self only treats F'=F; it does not directly
solve the source equation with variable logarithmic derivative. The new
source_iff uses derivative_subst and derivative_exp plus coefficient
induction for the linear ODE. Authenticated GitHub code search for
`A397345 OR A397348 OR A397346 language:Lean` returned an empty list.
The earlier general-web/jOEIS searches above remain predecessor reports.

Continuation logs and downloaded JSON are in the worker artifact directory
`/var/folders/wv/ht3wzsj138b4sxl3q4t0xdr40000gn/T/consensus-rnd/sshx/a397family-cont-0909/attempt-3`.
The failed build is lean-inherited.log (EXIT=2); repaired build results,
numeric rechecks and remaining gates are recorded below as they finish.

Continuation checkpoint: lean-repaired.log ends in "Build completed
successfully (12782 jobs)" and EXIT=0. The repaired module has no warnings,
no sorryAx and standard-three-axiom closures for all eight printed theorems.
Thus the predecessor's parity and modulus-eight results, and the rescued
literal exponential equivalence, are now personally reverified.
Own exact numeric.json: all four integer recurrences checked through n=200,
all four independent Fraction/logarithm reconstructions through n=30, all
available source data (19,18,17,18 terms for q=1,3,5,2), and odd-parameter
Catalan parity through m=99 agree, with zero failures. Finite checks are
supporting evidence only; the Lean inductions prove the universal results.
