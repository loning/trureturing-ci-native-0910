---
bibkey: pntplus2026mertens
authors: PrimeNumberTheoremAnd contributors
year: 2026
title: Mertens theorems in PrimeNumberTheoremAnd
doi: null
claim: The pinned upstream source proves Mertens III with the standard Lean axiom closure.
strata_touched: []
license: Apache-2.0
triage: anchor
---

# Mertens III Compatibility Measurement

Provenance: codex-cli implementation seat `mertens3-0907/attempt-1`,
dispatched by the consensus-rnd runner. No additional skill or review seat was
used by this worker; all measurements below are this worker's direct readings.
This is a literature port for the user-selected third-tier Robin/Gronwall
research line, not a new mathematical result.

## Source and Route

- Repository: <https://github.com/kimihiro64/PrimeNumberTheoremAnd>.
- Immutable commit: `6a380f0c4658c04a420a9eb00b1ed62a1e3fde01`.
- File: `PrimeNumberTheoremAnd/IEANTN/Mertens.lean`.
- The downloaded bytes equal the previous probe's `UpstreamMertens.lean`
  (`cmp`, exit 0). That probe recorded the AlexKontorovich repository name;
  both citations identify the same commit and source bytes in this reading.
- Reused `mertens-probe-0907/attempt-1/MertensCompat.lean`, its `runmake.mjs`,
  and its additive `probe.mk`. The normal root `lean` recipe is retained.
- Route `PrimeNumberTheoremAnd.EulerMaclaurin` to the existing
  `D5.S3.Weil.ZetaPntBase.EulerMaclaurin`; remove Architect blueprint metadata
  and one redundant `rfl`, as already done by the previous probe.

## Q1 Reading

Repository HEAD at measurement: `c32b86362c4bf8d27c07ffbfe23bca128f90b070`.
Lean `v4.33.0`; Mathlib `db584cd6d46c92f209a44c0f1c829460d327499d`.

Command: `make -f Makefile -f <attempt>/probe.mk lean PROBE=<attempt>/Q1.lean`.
Exit: 0. Wall time: 160.490721292 seconds, including the root project build.
The initial cache receipt reported both Mathlib and project layers warm;
this is not a cold-build timing or a prediction for CI.

The three task signatures were independently written as `example` types and
closed by the corresponding upstream constants, with no additional hypotheses.
All three type checks passed. The exact axiom output is:

```text
'Mertens.E₃.abs_le' depends on axioms: [propext, Classical.choice, Quot.sound]
'Mertens.E₃.bound''' depends on axioms: [propext, Classical.choice, Quot.sound]
'Mertens.E₃.bound'''' depends on axioms: [propext, Classical.choice, Quot.sound]
```

The final quote in each line closes Lean's quoted declaration name.
There is no `sorryAx` or custom axiom in any of these three closures.
One deprecation warning names `Set.mem_setOf_eq`; it is not an analytic gap.

Artifacts: `/var/folders/7r/h8yjr2y927n8m2kh38c18n9w0000gp/T/consensus-rnd/sshx/mertens3-0907/attempt-1/`.
The exact source, signatures and build output are `Q1.lean`, `q1.make.log`,
`q1.source.lean` and `q1.receipt.json` in that directory.

## Repository Search

At the measured HEAD, `git grep -n -P '\b(Mertens|Gronwall|ChebyshevMertens)\b'
-- D5` found weak product estimates in `PrimeGaps/EulerProducts`, hypotheses
in `Weil/ZetaCore/Hypotheses`, and provenance in the Euler-Maclaurin port.
These are not the sharp product asymptotic. The same word-boundary feature
was checked by `git grep -l -P '\btheorem\b' -- 'D5/**/*.lean'`: 3613 files.
These are lexical search readings, not a proof of global nonexistence.

Q1 establishes compatibility of the external source. It does not by itself
freeze a repository theorem or establish the Gronwall upper envelope.
