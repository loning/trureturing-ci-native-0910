# CMP Conjecture 3.13, m = 4: feasibility probe

Repository: https://github.com/the-omega-institute/trureturing

Lane: #6160. arXiv standing issue: #6494. Stage: thinking, probe only.
Branch: `lane/math/gribinski-m4-probe-0909`.
Initial HEAD and observed origin/dev: `1a39ed9516aa510fbf8bf377e26c08c7146b3707`.

Provenance: no skill invoked; one Codex worker performed this probe. No
independent reviewer or multi-model consensus is claimed. The user's report of
the orchestrator's earlier checks is input, not this worker's measurement.

## Preregistration (before Q1 searches, Lean attempts, or symbolic expansion)

Read, in order: `tools/scripts/agent/probe-brief-note.txt`, sections IV and V of
`tools/scripts/agent/standing-math-loop.md` (also read the surrounding document),
then the complete `CLAUDE.md` and `agents/CONTEXT.md`. The existing decisions in
the standing loop are adopted, not reconsidered.

The stopping rules are fixed before running:

1. Q1 succeeds using only pinned Mathlib instantiation, frozen projections and
   normalization (including `sq_nonneg` and `linarith only`): stop, bind-only.
2. Q2 cannot supply a finite necessary-and-sufficient criterion for four
   nonnegative real roots: stop, `blocked-on-criterion`.
3. Q3 measures any one expanded inequality with more than 50,000 monomials:
   stop, `blocked-on-cost`. The m=3 certificate comparator is 20 weighted
   squares plus 767 positive monomials. Do not change the threshold afterwards.
4. Work starts becoming a complete proof: stop for exceeding probe scope.

Order: Q1, Q2, Q3, Q4. A triggered stop cancels subsequent investigation;
unreached questions and measurements will be marked as such in the final
report. Writing and publishing the report remains permitted after stopping.

Proposed escape candidate, not an established witness: an independent
coefficient/minor positivity identity for the m=4 convolution output, derived
from the eight input roots and alpha > -1, and used to discharge a real-root
criterion. Merely projecting `PSD <-> all roots real` does not provide that
identity. No elaborated proof or dependency closure exists at registration.

Scope: no complete m=4 proof, no new D5 module, no deposit, no freeze, no PR,
no `make cover`, no changes to `Meta/Digestion/**`, and no budget changes.
Build probes use `make lean`. Intermediate reports are committed and pushed.

## Initial environment receipt

- `git status --short --branch`: clean, branch as above, initially tracks
  `origin/dev`.
- `git rev-parse HEAD origin/dev`: both return the initial SHA above.
- `rg --files -g 'AGENTS.md' -g 'CLAUDE.md' -g '*Gribinski*'
  -g '*NewtonHankel*' -g 'Makefile' -g '*lean*.sh' -g '*loogle*'
  -g '*leansearch*'`: locates the three Gribinski modules, their frozen state
  paths, NewtonHankelRealRootCriterion and its state path, and the make wrappers.
  File-name discovery does not establish theorem applicability.
- `.lake` is absent before any Lean invocation; cache provisioning must precede
  compilation through the canonical make wrapper.

## Nonclaims

This probe has not proved m=4, does not claim m=4 is provable by the proposed
route, does not claim exhaustive search, and makes no implication claim about
RH or any larger conjecture. Unopened external pages will be marked
`ASSUMED-UNVERIFIED`.
