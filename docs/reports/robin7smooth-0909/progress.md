# Robin inequality for the entire 7-smooth family

Provenance: no skill; one Codex implementation worker, direct execution and
self-checks; no independent review or multi-model consensus claimed.
LANE: #6160. Baseline: a8809894ea0f1dac06913ed56e09db6223d7ddfa.
Branch: lane/math/robin7smooth-0909.
Atom: c3316916b643d8cf28de3e1b451f7f3ba61d1337f85a87b7eb42cc1568f9621f.

## Preregistered task and stops

First attempt: pinned Mathlib instantiation, frozen projections and normalized
rewriting only (including sq_nonneg and linarith only). Success means bind-only
and immediate stop without a new module.
Otherwise measure the threshold and the finite 7-smooth interval before writing
a proof. More than 5,000 interval members means blocked-on-cost. A counterexample
means immediate stop and report. The intended target quantifies over all four
natural exponents, with product strictly greater than 5040; a single certificate
does not discharge it. Atom bytes still await successful canonical reading.

Proposed escape witness, conditional on a failed bind-only attempt: a uniform
strict divisor-sum bound for all products of powers of 2, 3, 5, 7, combined with
a certified analytic tail and private handling of the measured finite interval.
No public positive bounded-enumeration declaration is planned.
No deposit, cover, freezing, budget changes, new domain, or auto-merge authorized.

## Initial evidence

- Read tools/scripts/agent/probe-brief-note.txt first, then all of CLAUDE.md,
  agents/CONTEXT.md and tools/scripts/agent/deposit-brief-note.txt.
- git status --short --branch: clean; branch tracks origin/dev.
- make show-atom ATOM_ID=<full atom>: exit 2, CLI executable absent in this tree.
- make -C tools build: exit 2, no such target. Correct canonical target is dotnet.
- make -C tools dotnet: exit 0, zero warnings/errors.
- Canonical show-atom retry: exit 0; coverage_gids=[]; the raw text states
  sigma(n)/n < exp(gamma_E) log log n for n=2^a 3^b 5^c 7^d>5040,
  and explicitly permits arbitrarily large exponents. No brief/body discrepancy.
- make lean-cache-ensure: exit 0, seeded by clonefile from the main checkout,
  project and Mathlib states warm; no bare lake invocation.

## Library searches and the first proof attempt

Pinned Lean v4.33.0; Mathlib db584cd6d46c92f209a44c0f1c829460d327499d.
Read RobinRationalBasis.lean in full and its frozen state:
D5/S3/Arith/GoldenResource/RobinRationalBasis,
statement_id sha256:6dcafd483a23c78180a3518807013e46c0dccfcb211d2d5f442207eb1ee621c2.
Its robin_delta_10080_pos applies only to 10080; robinPositiveJudge_sound
requires a certificate and analytic brackets for the same individual n.

Search receipts (textual candidate discovery, not exhaustive semantic claims):

- rg -n '\b(robin|Robin|robinDelta|RobinPositiveJudge)\w*\b|7.smooth'
  D5 --glob '*.lean' --glob '!SevenSmoothBindProbe.lean': 112 matching lines.
- Same word-boundary/alternation features, positive control:
  rg -n '\b(robin_delta_10080_pos|robinPositiveJudge_sound)\b'
  D5/S3/Arith/GoldenResource/RobinRationalBasis.lean: 6 matching lines.
- rg -n '\b(robin|Robin)\w*\b|7.smooth'
  .lake/packages/mathlib/Mathlib/NumberTheory --glob '*.lean': 0, exit 1.
  Whole Mathlib matches include author names; they are not Robin inequalities.
- Mathlib positive control with the same word boundaries found
  sigma_one_apply_prime_pow, isMultiplicative_sigma and Euler constant bounds.
- gh search code '5040 sigma language:Lean' --limit 50: six files. Opened
  project-numina/LeanTriathlon at 2aede4209c203ae9901eff870744e4b77dc6173f,
  LiveLeanTriathlonSorry/RobinTheorem/All.lean: RH equivalence ends in sorry.
  Opened the other number-theory candidate, open_problems at
  ae68b78aab261523b3c6af2c415d39a3501b9a8e,
  math/riemann_hypothesis/lean/CertificateEquivalence.lean: Robin is an axiom.
  Neither supplies an admissible proof. Other four search hits not opened.
- gh search code '"smooth" "5040" language:Lean' --limit 30: one algebraic
  geometry path, not opened. Search service is available; completeness unclaimed.

A temporary example-only Lean probe was run through make lean. It attempted
direct single-point reuse, normalization and linarith only with sq_nonneg,
then attempts the frozen checker at the universal product. No public theorem
or admitted proof was introduced. The probe was removed after reading
the actual diagnostics. Its log is attempt-1/bind-only-build.log.

Result: exit 2, required target SevenSmoothBindProbe failed. The restricted
linarith attempt failed to contradict robinDelta(product) <= 0. The frozen
10080 log-log bracket has the wrong argument for the universal product.
The single-instance checker application also hit the default recursion limit;
no budget was changed. This is a failed bind-only attempt, not a proof that
every possible bind-only proof is impossible. No RH premise is available or used.

## Current nonclaims

The target is not yet proved. No claim of provability, exhaustive search,
certified threshold, finite-range count, admission, or implication to/from RH.
External pages and the atom body have not yet been successfully opened.
