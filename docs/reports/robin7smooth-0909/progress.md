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
- make -C tools dotnet: started; result pending.

## Current nonclaims

The target is not yet proved. No claim of provability, exhaustive search,
certified threshold, finite-range count, admission, or implication to/from RH.
External pages and the atom body have not yet been successfully opened.
