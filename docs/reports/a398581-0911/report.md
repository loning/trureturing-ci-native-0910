# A398581 implementation, attempt 1

## Provenance and scope

Codex primary worker, using the `lean4` skill; no delegated implementation or independent review yet. User-supplied orchestrator computations are reported evidence, not computations repeated by this worker. Tier 1. Target: for positive strictly increasing natural solutions of `5xyz = k(yz+xz+xy)`, a lexicographically least solution whose third coordinate is not maximal implies `k % 5 = 1`. No converse and no universal solvability claim.

Worktree `/Users/chronoai/trureturing-a398581`, branch `lane/math/a398581`; immutable starting base `343718ed191002a4708ccf381081f9b0c7a58e1a`. Toolchain `leanprover/lean4:v4.33.0`, mathlib `db584cd6d46c92f209a44c0f1c829460d327499d` read from repository configuration.

## Preregistered proof route

The proposed escape witness is the integer comparison of the least solution against solutions with larger first coordinate, using the small residual numerator `5x-k` in residues 0, 2, 3, 4. This remains ASSUMED-UNVERIFIED until proved. A non-1-residue counterexample stops the positive route. A finite check, or residue 4 alone, does not fulfill the target. No theory volume or atom will be created; any eventual freeze uses the existing uncovered deposit route.

## Search receipts

- D5: `rg -n -i 'A398581|egyptian|unit.fraction|erdos.straus' D5`. No A398581 statement found. Read all declarations of `ErdosStrausModularWitnesses`, `ErdosStrausResidueReduction`, and `PrimaryPseudoperfectPorts`, including their general public interfaces. The first two concern numerator 4 existence/scaling; the third concerns prime reciprocal sums and prime-extension identities. None supplies ordered numerator-5 extremality or a general comparison for arbitrary three-denominator solutions. A prose-only `SingleContextVisibleRemainderDimension` match is unrelated.
- Pinned mathlib and external search: pending. No search-complete claim.

## Verification and remaining obligations

No Lean attempt run yet. No theorem frozen. Build/cache receipts, exact declaration classifications, and final outcome will be appended after each completed unit.

## Unclaimed

No all-k solvability, converse, universal maximality theorem, literature novelty beyond checked sources, or independent review consensus is claimed. All unopened external pages and the brief's proposed proof route are ASSUMED-UNVERIFIED.
