#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd -P)"

cd "$ROOT"
exec dotnet "$ROOT/tools/StrataLint.Cli/bin/Release/net10.0/StrataLint.dll" \
  worktree ensure-cache
