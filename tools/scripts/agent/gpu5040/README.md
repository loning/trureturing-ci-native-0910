# GPU Trial History

Portable foreground Apple MPS search for the fixed real stationary isometry
occupation target `(4,2,1,1)`. The Householder parameterization, occupation DP,
Adam updates and independent NumPy CPU full-word verifier are retained from
the original research program. A scalar numerical result is not a proof of
exact attainability, exhaustive search, a quantum impossibility, or a bound.

## Prerequisites

Python 3.9 or later with `sqlite3` and POSIX `fcntl`; training requires Apple
silicon macOS, a working PyTorch MPS build, and NumPy. Install compatible Torch
and NumPy packages in the interpreter's normal environment before use. Tested
locally with Python 3.9.6, Torch 2.8.0 and NumPy 2.0.2. No dependency manager is
required. CPU checks need Torch and NumPy; history queries need neither.
Use `-B`, not `-I`: an isolated interpreter hides user-site Torch installations.

From the repository root:

```sh
PYTHON=/Applications/Xcode.app/Contents/Developer/usr/bin/python3
TOOL=tools/scripts/agent/gpu5040
STATE="$HOME/.local/state/gpu5040/state"
HISTORY="$HOME/.local/state/gpu5040/history.sqlite3"
export PYTORCH_ENABLE_MPS_FALLBACK=0
export OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 MKL_NUM_THREADS=1
```

The shared default is `${XDG_STATE_HOME:-$HOME/.local/state}/gpu5040`, containing
`history.sqlite3`, `gpu-verifier.lock`, and the default `state/`. `--state-dir`
does not change the default registry or GPU lock. `--history-db` selects explicit
independent knowledge; it does not permit concurrent GPU use. Resume retains the
checkpoint's recorded registry path and rejects a conflicting path.
`GPU5040_SHARED_ROOT` relocates the common root; every source copy on the same
machine must use the same value. These are local filesystem locks, not leases,
a distributed scheduler, or coordination with pre-registry workers.

All checkpoints, status, logs, locks and databases must remain outside source
directories and repository trees. Locks acquire the canonical state path first,
then the shared GPU/verifier lock, nonblocking. Never delete a lock file to unlock
it. A stopped process releases `fcntl` locks automatically.

## Run and Inspect

```sh
"$PYTHON" -B "$TOOL/gpu_worker.py" --state-dir "$STATE" --history-db "$HISTORY" \
  --dimensions 13,16 --seed-steps 100 --batch-steps 5 --max-steps 100
"$PYTHON" -B "$TOOL/gpu_worker.py" --state-dir "$STATE" --resume --max-steps 100
"$PYTHON" -B "$TOOL/gpu_worker.py" --state-dir "$STATE" --fresh-start --max-steps 100
"$PYTHON" -B "$TOOL/gpu_worker.py" --state-dir "$STATE" --status
"$PYTHON" -B "$TOOL/trial_history.py" --history-db "$HISTORY" --status completed --limit 100
"$PYTHON" -B "$TOOL/trial_history.py" --history-db "$HISTORY" --dimension 13
"$PYTHON" -B "$TOOL/gpu_worker.py" --state-dir "$STATE" --verify 13
```

`--max-steps` counts additional optimizer updates, never skipped trials.
`--max-seconds` is a soft invocation bound checked at boundaries and while
skipping. The full per-trial budget is `--seed-steps`, independent of invocation
bounds. `--forever` explicitly enables an unbounded foreground traversal.
Existing checkpoints auto-resume; `--resume` requires one. `--fresh-start`
inherits saved configuration unless overridden and begins a new traversal,
retaining the database and dimension bests. An unfinished checkpoint rejects
fresh-start with a `--resume` instruction; finish it with its original scientific
configuration and numerical runtime first.

An identity contains the physical model, actual dimension/seed, initialization,
all Adam settings, cosine schedule, full update budget, algorithm version,
float32 dtype and numerical runtime. NumPy's version belongs to verification
provenance, since the optimizer does not call NumPy. Identity excludes source hashes, executable and
state paths, invocation limits, logging/checkpoint cadence, verification trigger
settings and the MPS memory fraction. The source never feeds these operational
values or champion tensors into an optimizer update. Source/config hashes remain
provenance. Scientific code changes require an algorithm version change;
checkpoint layout compatibility uses a separate schema version.

Only exact completed optimization identities, or explicitly selected legacy
lineage exclusions, are skipped before model initialization. Interrupted and
failed claims remain unfinished; another state cannot steal them. Retry in the
recorded state with the same configuration, using `--resume` when it has a
checkpoint. History status is the last recorded state, not a process-liveness
probe; startup reconciles recoverable checkpoints before selection or fresh-start.

History stores one compact row per trial, including initial/final/best scalar
metrics and iterations. Dimension champions and candidate-digest CPU verification
records are separate. Verification is finite-precision evidence and is not a
condition for completed optimization. No per-step rows or per-trial tensors are
retained: state keeps `latest.pt`, at most one `best-D.pt` per dimension, and
bounded rotating logs. Champion paths can become unavailable if external state
is removed; a digest is not a retained tensor. The scalar database grows with
completed trials and should be retained/backed up while workers are stopped.

Terminal checkpoint publication fsyncs the file and directory before SQLite's
completion transaction (`synchronous=EXTRA`, rollback journal). A failed commit
leaves terminal recovery evidence intact; restart reconciles it idempotently.
Completed rows survive subsequent replacement of `latest.pt`. After a crash,
resume the worker directly to repair status before restarting the launcher.

## Pause and Repetition

```sh
touch "$STATE/STOP"
# Alternatively send SIGTERM or SIGINT to the owned foreground worker/launcher.
# After its graceful exit, remove only the STOP sentinel to allow another run:
rm "$STATE/STOP"
"$PYTHON" -B "$TOOL/gpu_bounded_launcher.py" --state-dir "$STATE" --history-db "$HISTORY"
```

The launcher runs one additional round of actual updates, deriving its budget
from saved dimensions and seed steps. Exit 0 requests existing launchd
`SuccessfulExit` repetition only after exact additional-update and fresh durable
checkpoint validation, bound to child PID, invocation UUID, progress and digest.
STOP, signals, failures, stale receipts and malformed status exit nonzero.
Signals are forwarded and the child is joined. This tool installs no service.
After changing source provenance, first run a bounded worker resume to publish a
new baseline status before enabling launcher repetition.

## Legacy Conversion

Pause the old worker and retain a separate stopped snapshot containing its exact
`gpu_worker.py`, `tensor_core.py`, original `PREREGISTRATION.md`, `latest.pt`, and
all `best-*.pt`. Old source-local locks cannot coordinate with the new shared
lock: root must quiesce the old service before any new MPS run. Keep the original
source/state and preregistration unchanged externally for recovery and provenance.

The converter requires `stopped.json` in that snapshot, supplied by its owner
after graceful exit. Its fields are `stopped: true`, `source_sha256` (SHA-256 of
worker name, NUL, worker bytes, core name, NUL, core bytes), `checkpoint_sha256`,
and `best_sha256` (a map of every retained best filename to its SHA-256).
The supported source hash is
`e2e66992c9e5209c8b37ccc3cae809d40764eee579b83e13e82a13833d284eb5`.
This marker attests snapshot acquisition; it cannot itself prove a process stopped.

```sh
SNAPSHOT="$HOME/.local/share/trureturing-research/gpu5040/retained-stopped-snapshot"
MIGRATED="$HOME/.local/state/gpu5040/migrated"
"$PYTHON" -B "$TOOL/legacy_conversion.py" --snapshot "$SNAPSHOT" \
  --state-dir "$MIGRATED" --history-db "$HISTORY"
"$PYTHON" -B "$TOOL/trial_history.py" --history-db "$HISTORY"
"$PYTHON" -B "$TOOL/gpu_worker.py" --state-dir "$MIGRATED" --resume --max-steps 1
```

Conversion validates known source, physical/configuration compatibility, exact
snapshot digests, schedule continuity, tensor shapes/dtypes and Adam state. It
preserves current parameters, optimizer, CPU/MPS RNG and dimension best tensors.
Retained champions and available verification results enter separate history
tables under the checked candidate digest; missing verifier provenance stays unknown.
It imports indices below `run_index`, and the current index only when
`iteration == seed_steps`. It infers nothing before the last fresh-start.
Missing prefix metrics/runtime are null; current legacy best metrics are marked
incomplete, not replaced with the dimension champion. Repeating the conversion
is idempotent and never resets later progress in its output state.

Unknown legacy runtime cannot define an exact modern identity. The conversion
returns a `lineage`; migrated resumes/fresh traversals retain it automatically.
A new state joins it only with `--legacy-lineage LINEAGE`. Exclusions compare
all known scientific fields within that explicit lineage. Independent campaigns
never match an unknown-field wildcard. Unrecorded legacy runtime fields remain
unknown even when the current tensors can be resumed.

Root should inspect conversion counts, run independent review and bounded MPS
checks, then point the existing service at the repo worker/launcher and migrated
external state. Repository publication, required checks and deployment are root's
operations; this implementation does not perform them.

## Local Checks

```sh
"$PYTHON" -B -m unittest discover -s "$TOOL" -p 'test_*.py' -v
"$PYTHON" -B "$TOOL/smoke_test.py"          # CPU numerical checks only
"$PYTHON" -B "$TOOL/smoke_test.py" --mps    # root only, after pausing old GPU work
```

Tests use external temporary synthetic state, fault injection and pipe barriers;
timeouts are infrastructure hang guards, not performance assertions. The MPS
smoke additionally compares resumed/continuous parameters, Adam moments and RNG,
and checks deduplication, CPU verification and launcher accounting. These Python
tests are local checks; existing ScriptTests are excluded from CI, and required
repository CI is not claimed to run this suite.
