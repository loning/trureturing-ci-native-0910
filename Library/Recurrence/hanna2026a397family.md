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
