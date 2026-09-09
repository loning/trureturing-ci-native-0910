"""Measure the real frozen-key certificate without running disposition queries.

The two emit authorities are parseReport's validated rows and the frozen export.
This produces a key-accounting receipt, not a disposition classification report.
Run after make lean-cache-ensure and make lean on the measured candidate tree.
"""

import argparse
import hashlib
import json
import os
import pathlib
import subprocess
import sys

from emission import manifest_source, string, write_module
from pipeline import frozen_keys
from resources import run


def emit(report_path, bindings_path, directory):
    report_bytes = report_path.read_bytes()
    report = json.loads(report_bytes)
    source = manifest_source(json.loads(bindings_path.read_text()), frozen_keys(report),
        report["source_commit"], "sha256:" + hashlib.sha256(report_bytes).hexdigest(), "CensusRun.Root")
    write_module(directory, "CensusRun.Root", source)


def benchmark(repository, report, directory):
    directory.mkdir(parents=True, exist_ok=True)
    head = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=repository, text=True).strip()
    digest = "sha256:" + hashlib.sha256(report.read_bytes()).hexdigest()
    module = "LeanInformationAudit.Tests.Census.Manifest.Benchmark"
    driver = write_module(directory, "BenchmarkDriver", f"import {module}\n"
        f"#census_certificate_benchmark report {string(str(report))} head {string(head)} "
        f"digest {string(digest)} directory {string(str(directory))}\n")
    result = run(["lake", "env", "lean", "-DmaxHeartbeats=0", "-DmaxRecDepth=4000", str(driver)],
        directory, "certificate", cwd=repository, budget_gb=4,
        env=dict(os.environ, LEAN_NUM_THREADS="1"), phase_path=directory / "benchmark.phase")
    # The whole-path target is a profiling trigger, not a first-overrun stop.
    # Only the corrected compile/kernel phase has the owner's hard stop bar.
    kernel = result["phases"].get("compile_kernel", {})
    if kernel.get("wall_seconds", 0) > 120 or kernel.get("peak_rss_bytes", 0) > 4 * 1024 ** 3:
        raise RuntimeError("STOP: compile/kernel exceeds 120 s or 4 GiB; see certificate.resources.json")
    result["whole_path_target_met"] = result["wall_seconds"] <= 60 and result["peak_rss_bytes"] <= 2 * 1024 ** 3
    (directory / "target.json").write_text(json.dumps(result, indent=2) + "\n")
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--report", required=True, type=pathlib.Path)
    parser.add_argument("--directory", required=True, type=pathlib.Path)
    parser.add_argument("--bindings", type=pathlib.Path, help="Internal: emit from parseReport's validated rows")
    options = parser.parse_args()
    if options.bindings:
        emit(options.report, options.bindings, options.directory)
    else:
        repository = pathlib.Path(__file__).resolve().parents[3]
        benchmark(repository, options.report.resolve(), options.directory.resolve())


if __name__ == "__main__":
    main()
