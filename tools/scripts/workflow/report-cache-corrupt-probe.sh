#!/usr/bin/env bash
# TEMPORARY reportcache0910 trigger-PR fixture. Close without merge; no production hook.
set -euo pipefail
export LC_ALL=C

MODE=report
case "${1:-}" in
  --judge-output-omissions) MODE=judge; shift ;;
  --engineering-output-omission) MODE=engineering; shift ;;
esac
if [[ "$MODE" == engineering ]]; then
  [[ $# == 1 ]] || exit 64
  SEED_REPORT=""
else
  [[ $# == 2 ]] || { echo 'usage: report-cache-corrupt-probe.sh [--judge-output-omissions] SEED_REPORT EMPTY_EVIDENCE_DIRECTORY | --engineering-output-omission EMPTY_EVIDENCE_DIRECTORY' >&2; exit 64; }
  SEED_REPORT="$1"
  shift
  [[ "$SEED_REPORT" == /* && -s "$SEED_REPORT" ]] || exit 64
fi
PROBE_REPOSITORY="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd -P)"
PROBE_EVIDENCE="$1"
[[ "$PROBE_EVIDENCE" == /* && -d "$PROBE_EVIDENCE" ]] || exit 64
[[ ! -e "$PROBE_EVIDENCE/source.before.sha256" && ! -e "$PROBE_EVIDENCE/exit-code" ]] || exit 64
for command in make dotnet python3 jq sha256sum cmp; do command -v "$command" >/dev/null; done
INPUT="$PROBE_REPOSITORY/tools/scripts/report/lean-report-input.sh"
ADAPTER="$PROBE_REPOSITORY/tools/scripts/report/lean-report-ci-baseline.sh"
SUFFIXES=('' .sha256 .input.attestation .provenance.json .materials.zip)
if [[ -n "$SEED_REPORT" ]]; then
  [[ -x "$INPUT" && -x "$ADAPTER" ]] || exit 64
  for suffix in "${SUFFIXES[@]}"; do test -s "${SEED_REPORT}${suffix}"; done
fi
PROBE_CACHE=""
PROBE_PRIVATE=""
OMITTED_PATH=""
OMITTED_HASH=""
CONSUMER_LOG=""
PROBE_CASE="$MODE-input"
completed=0

receipt() { printf '%s\n' "$*" | tee -a "$PROBE_EVIDENCE/omissions.txt"; }
file_hash() { sha256sum "$1" | cut -d ' ' -f 1; }
require_output() {
  [[ -f "$1" && -s "$1" ]] || {
    receipt "REPORT_CACHE_OMISSION_PROBE case=$PROBE_CASE coverage=failed reason=missing-initial-output path=$1"
    return 1
  }
}
omit_output() {
  require_output "$1"
  OMITTED_HASH="$(file_hash "$1")"
  receipt "REPORT_CACHE_OMISSION_PROBE case=$PROBE_CASE path=$1 initial_size=$(wc -c < "$1" | tr -d ' ') initial_sha256=$OMITTED_HASH"
  OMITTED_PATH="$1"
  mv -- "$OMITTED_PATH" "$PROBE_PRIVATE/omitted-output"
  test ! -e "$OMITTED_PATH"
  receipt "REPORT_CACHE_OMISSION_PROBE case=$PROBE_CASE omitted=true path=$OMITTED_PATH"
}
restore_omission() {
  [[ -n "$OMITTED_PATH" ]] || return 0
  # A normal engineering retry may have rebuilt this output and other bin/obj files.
  if [[ -f "$OMITTED_PATH" ]]; then
    receipt "REPORT_CACHE_OMISSION_PROBE case=$PROBE_CASE consumer_output_sha256=$(file_hash "$OMITTED_PATH")" || return 1
  fi
  mv -f -- "$PROBE_PRIVATE/omitted-output" "$OMITTED_PATH" || return 1
  local restored
  restored="$(file_hash "$OMITTED_PATH")" || return 1
  [[ "$restored" == "$OMITTED_HASH" ]] || return 1
  receipt "REPORT_CACHE_OMISSION_PROBE case=$PROBE_CASE restore=unchanged path=$OMITTED_PATH restored_sha256=$restored" || return 1
  OMITTED_PATH=""
}

source_fingerprint() {
  for suffix in "${SUFFIXES[@]}"; do sha256sum "${SEED_REPORT}${suffix}" || return $?; done
  if [[ -d "${SEED_REPORT}.logs" ]]; then
    find "${SEED_REPORT}.logs" -type f -exec sha256sum {} + | sort
  fi
}
finish() {
  local rc=$? preservation=not-applicable
  trap - EXIT HUP INT TERM
  set +e
  if [[ "$rc" == 0 && "$completed" != 1 ]]; then rc=1; fi
  if [[ -n "$CONSUMER_LOG" ]]; then
    cat "$CONSUMER_LOG"
    receipt "REPORT_CACHE_OMISSION_PROBE case=$PROBE_CASE consumer_exit=unavailable interruption_exit=$rc"
  fi
  restore_omission || rc=1
  if [[ -n "$SEED_REPORT" ]]; then
    preservation=changed
    if source_fingerprint > "$PROBE_EVIDENCE/source.after.sha256" \
      && cmp -s "$PROBE_EVIDENCE/source.before.sha256" "$PROBE_EVIDENCE/source.after.sha256"; then
      preservation=unchanged
    else
      [[ "$rc" != 0 ]] || rc=1
    fi
  fi
  if [[ -n "$PROBE_CACHE" ]]; then
    rm -rf -- "$PROBE_CACHE" || { [[ "$rc" != 0 ]] || rc=1; }
  fi
  if [[ -n "$PROBE_PRIVATE" && -z "$OMITTED_PATH" ]]; then
    rm -rf -- "$PROBE_PRIVATE" || rc=1
  fi
  printf '%s\n' "$rc" > "$PROBE_EVIDENCE/exit-code" || { [[ "$rc" != 0 ]] || rc=1; }
  if [[ "$MODE" == report ]]; then printf 'REPORT_CACHE_CORRUPT_PROBE exit=%s source=%s case=%s\n' "$rc" "$preservation" "$PROBE_CASE"; fi
  printf 'REPORT_CACHE_PROBE mode=%s case=%s exit=%s source=%s\n' "$MODE" "$PROBE_CASE" "$rc" "$preservation" || rc=1
  exit "$rc"
}
if [[ -n "$SEED_REPORT" ]]; then source_fingerprint > "$PROBE_EVIDENCE/source.before.sha256"; fi
trap finish EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

{
  printf 'event=%s run_id=%s run_attempt=%s base_ref=%s head_ref=%s\n' \
    "${GITHUB_EVENT_NAME:-local}" "${GITHUB_RUN_ID:-local}" "${GITHUB_RUN_ATTEMPT:-local}" \
    "${GITHUB_BASE_REF:-}" "${GITHUB_HEAD_REF:-}"
  printf 'workflow_ref=%s workflow_sha=%s\n' "${GITHUB_WORKFLOW_REF:-local}" "${GITHUB_WORKFLOW_SHA:-local}"
  git -C "$PROBE_REPOSITORY" rev-parse HEAD HEAD^1 HEAD:.github/workflows/ci.yml
} | tee "$PROBE_EVIDENCE/identity.txt"
CHECKED_BASE="$(git -C "$PROBE_REPOSITORY" rev-parse HEAD^1)"

prepare_omissions() {
  receipt "REPORT_CACHE_OMISSION_PROBE required_provenance=fresh-candidate-build build=${PROBE_BUILD_OUTCOME:-unavailable} judge_address=${PROBE_JUDGE_ADDRESS:-local} cache_hit=${PROBE_JUDGE_CACHE_HIT:-unavailable}"
  [[ "${PROBE_BUILD_OUTCOME:-}" == success ]] || {
    receipt "REPORT_CACHE_OMISSION_PROBE case=$PROBE_CASE coverage=failed reason=fresh-build-unavailable"
    return 1
  }
  PROBE_PRIVATE="$(mktemp -d "${RUNNER_TEMP:-${TMPDIR:-/tmp}}/reportcache0910-omission.XXXXXXXX")"
  PROBE_PRIVATE="$(cd "$PROBE_PRIVATE" && pwd -P)"
}

judge_omissions() {
  local cli="$PROBE_REPOSITORY/tools/StrataLint.Cli/bin/Release/net10.0" judge runtime consumer_rc
  PROBE_CASE=O1
  prepare_omissions
  require_output "$cli/StrataLint.dll"
  require_output "$cli/StrataLint.runtimeconfig.json"
  cp -R "$cli" "$PROBE_PRIVATE/cli"
  judge="$PROBE_PRIVATE/cli/StrataLint.dll"
  runtime="$PROBE_PRIVATE/cli/StrataLint.runtimeconfig.json"
  receipt "REPORT_CACHE_OMISSION_PROBE copied_from=$cli base=$CHECKED_BASE report=$SEED_REPORT"
  for PROBE_CASE in O1 O2; do
    if [[ "$PROBE_CASE" == O1 ]]; then omit_output "$judge"; else omit_output "$runtime"; test -s "$judge"; fi
    consumer_rc=0
    CONSUMER_LOG="$PROBE_EVIDENCE/$PROBE_CASE.log"
    /bin/bash "$PROBE_REPOSITORY/.github/scripts/harness-gate.sh" \
      --candidate "$PROBE_REPOSITORY" --base "$CHECKED_BASE" \
      --candidate-lean-report "$SEED_REPORT" --judge-dll "$judge" \
      > "$CONSUMER_LOG" 2>&1 || consumer_rc=$?
    printf '%s\n' "$consumer_rc" > "$PROBE_EVIDENCE/$PROBE_CASE.exit"
    cat "$CONSUMER_LOG"
    CONSUMER_LOG=""
    receipt "REPORT_CACHE_OMISSION_PROBE case=$PROBE_CASE consumer_exit=$consumer_rc owner=.github/scripts/harness-gate.sh"
    restore_omission
    if [[ "$PROBE_CASE" == O1 ]]; then
      if [[ "$consumer_rc" != 2 || "$(cat "$PROBE_EVIDENCE/O1.log")" != "harness-gate: external judge DLL '$judge' is absent" ]]; then
        receipt 'REPORT_CACHE_OMISSION_PROBE case=O1 coverage=failed reason=missing-judge-diagnostic'
        return 1
      fi
    elif [[ "$consumer_rc" == 0 || "$consumer_rc" == 3 ]] \
      || ! grep -F "'$runtime' was not found" "$PROBE_EVIDENCE/O2.log" \
      || ! grep -F 'libhostpolicy.' "$PROBE_EVIDENCE/O2.log" \
      || ! grep -E '^\[gate\] cached-judge[[:space:]]' "$PROBE_EVIDENCE/O2.log"; then
      receipt 'REPORT_CACHE_OMISSION_PROBE case=O2 coverage=failed reason=missing-native-runtime-diagnostic'
      return 1
    fi
    source_fingerprint > "$PROBE_EVIDENCE/source.after.sha256"
    cmp "$PROBE_EVIDENCE/source.before.sha256" "$PROBE_EVIDENCE/source.after.sha256"
    receipt "REPORT_CACHE_OMISSION_PROBE case=$PROBE_CASE coverage=verified seed=unchanged"
  done
}

if [[ "$MODE" == engineering ]]; then
  PROBE_CASE=O3
  prepare_omissions
  project='tools/tests/StrataLint.EngineeringScope.Tests/StrataLint.EngineeringScope.Tests.csproj'
  omit_output "$PROBE_REPOSITORY/tools/tests/StrataLint.EngineeringScope.Tests/bin/Release/net10.0/StrataLint.EngineeringScope.Tests.dll"
  consumer_rc=0
  CONSUMER_LOG="$PROBE_EVIDENCE/O3.log"
  /bin/bash "$PROBE_REPOSITORY/tools/scripts/workflow/engineering-test-execution-harness.sh" "$PROBE_REPOSITORY" \
    > "$CONSUMER_LOG" 2>&1 || consumer_rc=$?
  printf '%s\n' "$consumer_rc" > "$PROBE_EVIDENCE/O3.exit"
  cat "$CONSUMER_LOG"
  CONSUMER_LOG=""
  receipt "REPORT_CACHE_OMISSION_PROBE case=O3 consumer_exit=$consumer_rc owner=tools/scripts/workflow/engineering-test-execution-harness.sh"
  restore_omission
  if ! awk -v project="$project" '
    $0 == "ENGINEERING_TEST_PROJECT project=\"" project "\"" { selected=1 }
    $0 == "ENGINEERING_TEST_RETRY project=\"" project "\" reason=missing-build-output" { if (selected) retry=1 }
    index($0, "ENGINEERING_TEST_EXECUTED project=\"" project "\" evidence=trx executed=") == 1 {
      count=$0; sub(/^.* executed=/, "", count)
      if (retry && count ~ /^[1-9][0-9]*$/) executed=1
    }
    END { exit !(selected && retry && executed) }
  ' "$PROBE_EVIDENCE/O3.log" || [[ "$consumer_rc" != 0 ]]; then
    receipt 'REPORT_CACHE_OMISSION_PROBE case=O3 coverage=failed reason=selected-retry-execution-not-proven'
    exit 1
  fi
  receipt 'REPORT_CACHE_OMISSION_PROBE case=O3 coverage=verified'
  completed=1
  exit 0
fi

"$INPUT" verify --repository "$PROBE_REPOSITORY" --report "$SEED_REPORT"
if [[ "$MODE" == judge ]]; then judge_omissions; completed=1; exit 0; fi
PROBE_CASE=P0
PROBE_CACHE="$(mktemp -d "${RUNNER_TEMP:-${TMPDIR:-/tmp}}/reportcache0910-corrupt.XXXXXXXX")"
imported="$("$ADAPTER" --bundle "$SEED_REPORT" --cache-root "$PROBE_CACHE" --transport)"
# The existing optional adapter can exit zero on fallback; require its ready output.
test "$imported" = "$PROBE_CACHE"
address="$(jq -er '.input_address | ltrimstr("sha256:")' "${SEED_REPORT}.provenance.json")"
[[ "$address" =~ ^[0-9a-f]{64}$ ]]
entry="$PROBE_CACHE/$address/raw-lean-report.json"
test -s "$entry"
expected_rejection='lean-report-input: raw Lean report SHA is stale; run make lean-report first'
{
  printf 'payload=%s\nmutation=append literal \\nCORRUPT_REPORT_CACHE_PROBE_0910\\n; leave all sidecars unchanged\n' "$entry"
  printf 'expected_verifier_exit=2\nexpected_verifier_stderr=%s\n' "$expected_rejection"
  printf 'expected_make_receipt=LEAN_REPORT_CACHE status=miss reason=local-entry-unavailable input_address=sha256:%s\n' "$address"
  printf 'recovery_remote=0 (disabled; no Release HTTP outage simulated)\nreuse_remote=1 (normal default)\n'
  sha256sum "$entry"
} | tee "$PROBE_EVIDENCE/intent.txt"
for suffix in .sha256 .input.attestation .provenance.json .materials.zip; do
  sha256sum "${entry}${suffix}"
done > "$PROBE_EVIDENCE/entry-sidecars.sha256"
printf '\nCORRUPT_REPORT_CACHE_PROBE_0910\n' >> "$entry"
sha256sum "$entry" > "$PROBE_EVIDENCE/corrupt-payload.sha256"
sha256sum -c "$PROBE_EVIDENCE/entry-sidecars.sha256"
rejection_exit=0
"$INPUT" verify --repository "$PROBE_REPOSITORY" --report "$entry" \
  > "$PROBE_EVIDENCE/rejection.log" 2>&1 || rejection_exit=$?
printf '%s\n' "$rejection_exit" > "$PROBE_EVIDENCE/rejection.exit"
cat "$PROBE_EVIDENCE/rejection.log"
test "$rejection_exit" = 2
test "$(cat "$PROBE_EVIDENCE/rejection.log")" = "$expected_rejection"

# A same-run exact report hit may have skipped toolchain installation. Use the
# existing installer if necessary; make retains the normal Lean ensure/writer.
if [[ ! -x "$HOME/.elan/bin/lake" ]]; then
  /bin/bash "$PROBE_REPOSITORY/tools/scripts/workflow/install-lean-toolchain.sh" "$PROBE_REPOSITORY/lean-toolchain"
fi
export PATH="$HOME/.elan/bin:$PATH"
export LAKE_BIN="$HOME/.elan/bin/lake"
live_report="$PROBE_REPOSITORY/.lake/build/stratalint/raw-lean-report.json"
"$INPUT" modules --repository "$PROBE_REPOSITORY" > "$PROBE_EVIDENCE/modules.tsv"

for phase in recovery reuse; do
  remote=0
  mode=produced
  if [[ "$phase" == reuse ]]; then remote=1; mode=cached; fi
  printf 'REPORT_CACHE_CORRUPT_PROBE phase=%s remote=%s cache_root=%s command=make-lean-report\n' "$phase" "$remote" "$PROBE_CACHE"
  make_exit=0
  STRATALINT_REPORT_CACHE_ROOT="$PROBE_CACHE" STRATALINT_REPORT_CACHE_REMOTE="$remote" \
    make -C "$PROBE_REPOSITORY" lean-report > "$PROBE_EVIDENCE/$phase.log" 2>&1 || make_exit=$?
  printf '%s\n' "$make_exit" > "$PROBE_EVIDENCE/$phase.exit"
  cat "$PROBE_EVIDENCE/$phase.log"
  [[ "$make_exit" == 0 ]] || exit "$make_exit"
  "$INPUT" verify --repository "$PROBE_REPOSITORY" --report "$live_report"
  snapshot="$("$ADAPTER" --bundle "$live_report" --staging-directory "$PROBE_EVIDENCE/$phase" --transport)"
  test "$snapshot" = "$PROBE_EVIDENCE/$phase/raw-lean-report.json"
  jq -e --arg mode "$mode" --arg address "sha256:$address" \
    '.mode == $mode and .input_address == $address' "${snapshot}.provenance.json" >/dev/null
  # Carry the successful same-run report's complete contents into the oracle:
  # current-input verification, transport validation, then exact payload equality.
  for suffix in '' .input.attestation .materials.zip; do
    cmp "${SEED_REPORT}${suffix}" "${snapshot}${suffix}"
  done
  producer_count="$(awk '/^RAW_LEAN_REPORT / {n++} END {print n+0}' "$PROBE_EVIDENCE/$phase.log")"
  miss_count="$(awk '/^LEAN_REPORT_CACHE status=miss / {n++} END {print n+0}' "$PROBE_EVIDENCE/$phase.log")"
  hit_count="$(awk '/^LEAN_REPORT_CACHE status=hit / {n++} END {print n+0}' "$PROBE_EVIDENCE/$phase.log")"
  printf '%s producer_invocations=%s misses=%s hits=%s\n' "$phase" "$producer_count" "$miss_count" "$hit_count" \
    | tee -a "$PROBE_EVIDENCE/counts.txt"
  if [[ "$phase" == recovery ]]; then
    test "$producer_count:$miss_count:$hit_count" = 1:1:0
    grep -Fx "LEAN_REPORT_CACHE status=miss reason=local-entry-unavailable input_address=sha256:$address" "$PROBE_EVIDENCE/$phase.log"
    grep -Fx 'LEAN_REPORT_DELTA mode=full-fallback changed=0 added=0 removed=0 recheck=0' "$PROBE_EVIDENCE/$phase.log"
    test "$(cat "${live_report}.logs/inspect.exit.log")" = 0
    cp -R "${live_report}.logs" "$PROBE_EVIDENCE/recovery/producer-logs"
    "$INPUT" verify --repository "$PROBE_REPOSITORY" --report "$entry"
    cmp "$entry" "$live_report"
    # The fallback plan's recheck=0 is not the full inspector's module count.
    module_count="$(wc -l < "$PROBE_EVIDENCE/modules.tsv" | tr -d ' ')"
    printf 'recovery full_inspection_modules=%s\n' "$module_count" | tee -a "$PROBE_EVIDENCE/counts.txt"
    awk '/(^|[[:space:]])Built[[:space:]]/ {n++} END {printf "recovery build_Built_lines=%d (diagnostic only)\n", n+0}' \
      "${live_report}.logs/build.stdout.log" "${live_report}.logs/build.stderr.log" | tee -a "$PROBE_EVIDENCE/counts.txt"
  else
    test "$producer_count:$miss_count:$hit_count" = 0:0:1
    grep -Fx "LEAN_REPORT_CACHE status=hit mode=local-exact input_address=sha256:$address" "$PROBE_EVIDENCE/$phase.log"
    test ! -e "${live_report}.logs"
    delta_count="$(awk '/^LEAN_REPORT_DELTA/ {n++} END {print n+0}' "$PROBE_EVIDENCE/$phase.log")"
    test "$delta_count" = 0
    for suffix in '' .sha256 .input.attestation .materials.zip; do
      cmp "$PROBE_EVIDENCE/recovery/raw-lean-report.json$suffix" "${snapshot}${suffix}"
    done
    printf 'reuse full_inspection_modules=0\n' | tee -a "$PROBE_EVIDENCE/counts.txt"
  fi
done
"$INPUT" verify --repository "$PROBE_REPOSITORY" --report "$SEED_REPORT"
printf '%s\n' 'REPORT_CACHE_CORRUPT_PROBE recovery_and_reuse=verified'
judge_omissions
completed=1
