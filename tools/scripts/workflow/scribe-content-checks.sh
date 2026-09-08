#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "usage: scribe-content-checks.sh REPORT [SCRIBE_DLL]" >&2
  exit 2
fi
REPORT="$1"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd -P)"
SCRIBE_DLL="${2:-$REPO_ROOT/tools/StrataLint.Scribe.Documents/bin/Release/net10.0/StrataLint.Scribe.Documents.dll}"
[[ -s "$REPORT" && -f "$SCRIBE_DLL" ]] || { echo "scribe-content-checks: report or candidate DLL missing" >&2; exit 2; }
cd "$REPO_ROOT"
run_scribe() {
  STRATALINT_LEAN_REPORT="$REPORT" dotnet "$SCRIBE_DLL" "$@"
}
# The pins are an authoritative projection test corpus, not generated Markdown freshness.
run_scribe projections --check --report "$REPORT"
run_scribe describe-report --check
run_scribe markdown-check --report "$REPORT"
