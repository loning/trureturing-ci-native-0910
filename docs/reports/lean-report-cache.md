# Lean report cache

`make lean-report` produces or reuses the canonical report at
`.lake/build/stratalint/raw-lean-report.json`, together with its required sidecars
and statement materials. Its separate report cache is enabled by default and can
reuse bundles across local worktrees or acquire a shared GitHub Release seed.

| Command | Behavior |
|---|---|
| `make lean-report` | Reuse a current report or run ordinary report production, using a compatible seed when available. |
| `make lean-report-cache-from-github` | Acquire a compatible bundle into the report cache, accepting a compatible local seed before downloading. Run `make lean-report` afterward to obtain the current report. |
| `make lean-report-cache-to-github` | Publish the existing current bundle at `.lake/build/stratalint/raw-lean-report.json`, without a Lean build. |

To publish another existing bundle, use
`make lean-report-cache-to-github LEAN_REPORT=/absolute/path/report.json`.
Relative `LEAN_REPORT` paths are resolved by make. The report must match this
worktree's current inputs and have all adjacent bundle files; publication does
not regenerate them. Remote acquisition and publication use `gh`; authenticate
it for the selected repository, for example with `gh auth login` or `GH_TOKEN`.
Remote acquisition needs read access and publication needs contents write access.
Input addressing also uses the repository's .NET SDK and Python tooling.

Report keys come from the existing
[canonical input owner](../../tools/scripts/report/lean-report-input.sh): the
declared producer/inspector closure, Lean source bytes, and Lean
toolchain/manifest/lakefile configuration. Commit IDs and worktree names are not
cache keys. The Release compatibility prefix binds the producer, resident
inspector, and configuration coordinates while allowing source differences for
incremental production.

Normal report production follows these paths:

1. An exact local entry supplies the complete bundle after the
   [pair producer](../../tools/scripts/lean-report-pair.sh) checks its report hash,
   input attestation, and provenance against the current tree.
2. After an exact miss, a local bundle with matching producer/inspector and
   configuration coordinates can seed the existing
   [delta producer](../../tools/lean-inspector/delta.py). It compares current
   module source hashes and rechecks changes and affected dependents, including
   declared refutation-claim dependencies, while retaining unchanged records
   and materials. A source-stale seed is not a current report.
3. If no compatible local seed is found, automatic acquisition tries the shared
   Release's exact asset and then its newest compatible source seed. A fetched
   exact bundle can satisfy the report directly; a compatible seed goes through
   ordinary incremental production. Successful production stores the complete
   bundle for later reuse.

Rejected local entries and failed automatic acquisition fall through to ordinary
production. Missing assets, rejected transport bundles, authentication/network
failures, and transfer timeouts are cache misses on that automatic path. Cache
write failures are diagnostic; actual production, output I/O, and consumer
validation failures still fail normally. Explicit acquisition or publication
returns failure when that requested action cannot succeed.

`LEAN_REPORT_CACHE` receipts distinguish `local-exact`, `local-seed`, remote
`exact`/`seed`, miss reasons, and publication results. `LEAN_REPORT_DELTA_PLAN`
and `LEAN_REPORT_DELTA` report reuse/delta/full-fallback decisions with
changed, added, removed, and rechecked module counts.

The [cache helper](../../tools/scripts/report/lean-report-cache.sh) selects these
default roots:

| Environment | Default report cache root |
|---|---|
| Local | `${XDG_CACHE_HOME:-$HOME/.cache}/stratalint-lean-report-cache` |
| `CI=true` or `CI=1` | `${RUNNER_TEMP:-${TMPDIR:-/tmp}}/stratalint-lean-report-cache` |

| Setting | Supported use |
|---|---|
| `STRATALINT_REPORT_CACHE_ROOT` | Set an absolute directory to override the root. Keep this report store separate from Lean build/dependency stores. The root must be owned by the current UID and not writable by group/others. |
| `STRATALINT_REPORT_CACHE_REMOTE=0` | Disable automatic remote acquisition for normal `make lean-report`, which defaults to `1`; local reuse continues. The explicit acquisition target still requests acquisition. |
| `STRATALINT_REPORT_CACHE_REPO` | Select the GitHub repository; default `the-omega-institute/trureturing`. |
| `STRATALINT_REPORT_CACHE_TRANSFER_TIMEOUT_SECONDS` | Per-upload/download timeout, default `1800`. Use a canonical decimal integer from `1` through `86400`. Metadata requests have a separate 30-second bound; CI job limits still apply. |

Shared storage uses the dedicated Release tag `lean-report-cache-v1`, created
with `--latest=false`. Each content-addressed ZIP has a transport SHA-256 sidecar
and contains the normalized `raw-lean-report.json` plus `.sha256`,
`.input.attestation`, `.provenance.json`, and `.materials.zip`. Process logs are
excluded from reusable bundles. The
[transport helper](../../tools/scripts/report/lean-report-cache.py)
checks archive membership, digests, input coordinates, and ZIP integrity, and
delegates report parsing to the existing delta owner. Report schema and semantic
acceptance remain with the existing consumers. Transport validation alone does
not prove that the materials semantically cover every report declaration.

In [CI](../../.github/workflows/ci.yml), PR and dev runs first try the existing
Actions report cache keyed by the canonical repository input address. A
validated exact hit serves the report before Lean toolchain restoration and
the Lean build. A prefix restore is only a possible delta seed. The ordinary
production step explicitly uses
`$RUNNER_TEMP/canonical-lean-report-delta-cache`, stages the Actions bundle there,
and enables optional Release fallback with `STRATALINT_REPORT_CACHE_REMOTE=1`
and a read token. CI can still build Lean before this pair-level Release fetch.
Normal `make lean-report` also requires an available `lake` executable and runs
the existing Lean cache ensure before staging its report.

The optional `publish-lean-report-cache` job runs only on dev pushes after
`candidate-engineering`, `lean-inspect`, and `baseline-admission` succeed. It
checks out that producer commit, downloads its report artifact, and calls the
publication make target with `GH_TOKEN` and job-scoped `contents: write`.
`continue-on-error: true` keeps publication failure outside the required checks.
The existing dev Actions report save also remains available.

The report cache cooperates through existing make and producer entry points;
Lean cache keys/helpers, `.lake/build` and `.lake/packages` ownership, ensure,
and writer behavior remain separate. See
[Lean cache ownership](lean-cache-ownership.md) for those boundaries, including
the existing CI Lean restore-action failure gap and the unverified mathlib
regeneration caveat.
