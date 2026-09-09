.PHONY: triage-probe
lean: triage-probe
triage-probe:
	@/bin/bash tools/scripts/worktree/lean-cache-run.sh lake env lean "$(PROBE)"
