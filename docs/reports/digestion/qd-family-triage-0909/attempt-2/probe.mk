.PHONY: qd-triage-probe
lean: qd-triage-probe
qd-triage-probe:
	@/bin/bash tools/scripts/worktree/lean-cache-run.sh lake env lean "$(PROBE)"
