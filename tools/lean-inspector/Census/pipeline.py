"""Report-only census, never a gate. status=complete means accounting completion
only. Observed rows are unclassified: never certified, never a closed reason,
and never AC-023. Lean owns registration queries and certification."""

from __future__ import annotations

import json
import pathlib
import argparse
import hashlib
import os
import re
import subprocess
import sys
import time


def parse_request(value):
    if not isinstance(value, dict) or set(value) != {"root", "report"}:
        raise ValueError("census request requires exactly root and report")
    if any(not isinstance(item, str) or not item for item in value.values()):
        raise ValueError("census request values must be nonempty strings")
    return value


def validate_summary(summary, *, requested, accounted):
    if summary["requested_keys"] != requested or summary["counts"]["accounted"] != accounted:
        raise ValueError("publication requested/accounted denominator mismatch")
    complete = accounted == requested
    if summary["status"] != ("complete" if complete else "partial"):
        raise ValueError("publication accounting status mismatch")
    certified_complete = complete and summary["counts"]["certified"] == accounted
    if summary["certified_complete"] is not certified_complete:
        raise ValueError("publication certified_complete does not use the full requested key set")


def validate_fixture_export(report):
    if report.get("source_commit") != "fixture-head":
        raise ValueError("explicit input is synthetic fixture only; production revisions are rejected")
    for node in report["nodes"]:
        if not re.fullmatch(r"LeanInformationAudit/Tests/(?:[A-Za-z_][A-Za-z_0-9]*/)*[A-Za-z_][A-Za-z_0-9]*\.lean",
                            node["repo_path"]):
            raise ValueError("explicit input requires a synthetic fixture module path")


def frozen_keys(report):
    result = []
    identities = set()
    for node in report["nodes"]:
        if node["freeze_status"] not in ("frozen", "proven-not-yet-frozen"):
            raise ValueError("invalid freeze status")
        if node["freeze_status"] != "frozen":
            continue
        module = node["repo_path"].removesuffix(".lean").replace("/", ".")
        for declaration in node["declarations"]:
            if declaration["kind"] != "theorem":
                continue
            identity = declaration["statement_id"]
            if identity in identities:
                raise ValueError("duplicate statement identity")
            identities.add(identity)
            result.append((module, declaration["declaration_name_key"], identity))
    return sorted(result)


def read_keys(data):
    value = json.loads(data)
    if not isinstance(value, list) or any(
            not isinstance(row, list) or len(row) != 3
            or any(not isinstance(item, str) or not item for item in row) for row in value):
        raise ValueError("expected module, structured declaration name, statement identity triples")
    return value


def exported_path(log):
    receipts = [line for line in log.splitlines() if line.startswith("TRUTH_EXPORT ")]
    if len(receipts) != 1 or not receipts[0].partition(" out=")[2]:
        raise ValueError("truth-export did not emit exactly one output-path receipt")
    return pathlib.Path(receipts[0].partition(" out=")[2]).resolve()


def execute(options):
    from phases import read, write
    from resources import run
    from streaming import canonical, freshness, replay, root_definitions
    import shutil

    repository = pathlib.Path(__file__).resolve().parents[3]
    directory = pathlib.Path(options.output).resolve()
    directory.mkdir(parents=True, exist_ok=False)
    started = time.monotonic()
    state = {"status": "running", "rss_budget_gib": 4, "concurrency": 1, "phases": {},
             "replay": "not-run", "assumed_unverified": []}
    env = dict(os.environ)

    def save():
        state["wall_seconds"] = round(time.monotonic() - started, 3)
        write(directory / "run.json", state)

    def step(command, label, *, build=False, design_limit_gb=None):
        print("CENSUS_STEP " + label, flush=True)
        census_seconds = sum(value["wall_seconds"] for value in state["phases"].values()
                             if value["rss_budget_gib"] is not None)
        result = run(command, directory / "logs", label, cwd=repository, env=env,
                     budget_gb=None if build else 4, design_limit_gb=design_limit_gb,
                     wall_limit_s=max(1, 1200 - census_seconds))
        state["phases"][label] = result
        if build:
            log = (directory / "logs" / (label + ".log")).read_text()
            state["phases"][label]["built"] = len(re.findall(r"^.*\[\d+/\d+\] Built ", log, re.M))
        save()
        return result

    def io_phase(phase, label):
        return step([sys.executable, str(repository / "tools/lean-inspector/Census/phases.py"),
                     phase, str(repository), str(directory)], label)

    def lean(program, arguments, label, design_limit_gb=None):
        return step([lean_binary, "-DmaxRecDepth=100000", "-DmaxHeartbeats=0", "--run",
                     str(repository / "tools/lean-inspector/Census" / program), *map(str, arguments)],
                    label, design_limit_gb=design_limit_gb)

    try:
        if options.fixture_truth_export:
            validate_fixture_export(read(options.fixture_truth_export))
        step(["make", "lean-cache-ensure"], "cache_ensure", build=True)
        freshness(lambda command, label: step(command, label, build=True))
        # Resolve Lake's search paths once; time the Lean census process itself.
        env = json.loads(subprocess.check_output(["lake", "env", sys.executable, "-c",
            "import os,json;print(json.dumps(dict(os.environ)))"], cwd=repository, env=env))
        lean_binary = shutil.which("lean", path=env["PATH"])
        env["LEAN_NUM_THREADS"] = "1"
        env["LEAN_SRC_PATH"] = str(repository / "tools/lean-inspector") + os.pathsep + str(repository)
        if options.fixture_truth_export:
            report_path = pathlib.Path(options.fixture_truth_export).resolve()
        else:
            step(["git", "diff", "--exit-code", "HEAD", "--", "D5", "lean-toolchain",
                  "lake-manifest.json", "lakefile.toml", "Golden/Frozen/state", "tools/lean-inspector"], "pinned_inputs")
            step(["make", "truth-export", f"OUT={directory / 'truth'}", f"LEAN_REPORT={options.lean_report}"],
                 "truth_export", build=True)
            report_path = exported_path((directory / "logs/truth_export.log").read_text())
        report_bytes = report_path.read_bytes()
        report = json.loads(report_bytes)
        head = report["source_commit"]
        if not options.fixture_truth_export and head != subprocess.check_output(
                ["git", "rev-parse", "HEAD"], cwd=repository, text=True).strip():
            raise ValueError("IE-C044 export revision differs from environment HEAD")
        all_keys = frozen_keys(report)
        keys = [key for key in all_keys if key[0] == options.prefix or key[0].startswith(options.prefix + ".")]
        if not keys:
            raise ValueError("no frozen theorem keys selected")
        request = {"head": head, "keys": keys, "report": str(report_path),
                   "report_sha256": "sha256:" + hashlib.sha256(report_bytes).hexdigest()}
        write(directory / "request.json", request)
        io_phase("enumerate", "tracked_domain")
        domain = read(directory / "domain.json")
        if options.fixture_truth_export:
            modules = sorted(node["repo_path"].removesuffix(".lean").replace("/", ".") for node in report["nodes"])
        else:
            modules = [m for m in domain if m == options.prefix or m.startswith(options.prefix + ".")]
        roots, assignment = root_definitions(modules, keys, [])
        write(directory / "membership-request.json", {"keys": keys, "roots": roots, "assignment": assignment,
              "discovery_roots": sorted(set(modules) | {"LeanInformationAudit.Census.Command"})})
        lean("scan.lean", [directory / "manifest.json", directory / "request.json", directory / "index.jsonl"],
             "streaming_index", 3)
        io_phase("graph", "upstream_graph")
        lean("membership.lean", [directory / "index.jsonl", directory / "membership-request.json",
                                directory / "membership.json"], "closure_membership")
        membership = read(directory / "membership.json")
        candidates = {"entries": [], "source_inputs": []}
        if membership["candidate_keys"]:
            owners = {key[0] for key in membership["candidate_keys"]}
            candidate_roots = {assignment[owner] for owner in owners}
            write(directory / "candidate-index.json", {
                "candidate_keys": membership["candidate_keys"], "named": membership["named"],
                "assignment": {owner: assignment[owner] for owner in owners},
                "scopes": [scope for scope in membership["scopes"] if scope[0] in candidate_roots]})
            imports = sorted(set(membership["validation_imports"]) | {"LeanInformationAudit.Census.Command"})
            source = "".join("import " + module + "\n" for module in imports)
            source += "#census_validate " + json.dumps(str(directory / "request.json"))
            source += " using " + json.dumps(str(directory / "candidate-index.json"))
            source += " output " + json.dumps(str(directory / "candidates.json")) + "\n"
            driver = directory / "Candidates.lean"
            driver.write_text(source)
            step([lean_binary, "-DmaxRecDepth=100000", "-DmaxHeartbeats=0", str(driver)],
                 "candidate_environment", design_limit_gb=8)
            candidates = read(directory / "candidates.json")
        rows = membership["rows"] + candidates["entries"]
        if sorted(row["statement_id"] for row in rows) != sorted(key[2] for key in keys):
            raise ValueError("IE-C044 streaming query did not account for each selected key exactly once")
        write(directory / "projection-input.json", {"head": head, "rows": rows, "scopes": membership["scopes"]})
        lean("project.lean", [directory / "projection-input.json", directory / "projection.json"], "row_accounting")
        projection = read(directory / "projection.json")
        io_phase("hash", "receipt_hashing")
        sources = {canonical(source): source for source in candidates["source_inputs"]}
        write(directory / "emission.json", {"head_sha": head, "report_sha256": request["report_sha256"],
            "source_inputs": [sources[key] for key in sorted(sources)], "theorem_count": len(all_keys),
            "requested_keys": len(all_keys), "input_kind": "synthetic_fixture" if options.fixture_truth_export else "production",
            "query_verification": "lean_streaming_query"})
        io_phase("emit", "json_emission")
        summary = read(directory / "census.json.summary.json")
        validate_summary(summary, requested=len(all_keys), accounted=len(keys))
        state.update(status=summary["status"], requested_keys=len(all_keys), counts=projection["counts"],
                     candidate_keys=len(membership["candidate_keys"]), tracked_modules=len(domain),
                     artifact_bytes=(directory / "census.json").stat().st_size,
                     candidate_environment_modules=candidates.get("environment_modules", 0))
        if options.replay_of:
            expected = pathlib.Path(options.replay_of).resolve()
            # Reaching here has re-enumerated, re-read, recomputed membership and
            # revalidated candidates. Hash checking alone never sets this flag.
            state["replay"] = replay(lambda: {"receipt": read(directory / "receipt.json"),
                "projection": projection}, {"receipt": read(expected / "receipt.json"),
                "projection": read(expected / "projection.json")})
            with (directory / "census.json").open("rb") as actual, (expected / "census.json").open("rb") as prior:
                while True:
                    block = actual.read(4 * 1024 * 1024)
                    if block != prior.read(4 * 1024 * 1024):
                        raise ValueError("IE-C044 replay JSON bytes differ")
                    if not block:
                        break
            state["byte_identical"] = True
        # The independent certificate lane owns the manifest/transport API. Its
        # current publisher requires retired per-root query receipts and cannot
        # consume a whole-stream receipt. These measured rows remain report-only.
        state["publication"] = {"status": "blocked", "accounted": len(keys),
            "reason": "certificate transport requires per-root receipts; whole-stream integration belongs to the certificate lane"}
        print(json.dumps({"status": state["status"], "counts": state["counts"], "replay": state["replay"]}), flush=True)
        return 0 if state["status"] == "complete" else 2
    except BaseException as error:
        state.update(status="rejected", error=str(error))
        raise
    finally:
        save()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", required=True, help="new run-local directory")
    parser.add_argument("--lean-report", default=".lake/build/stratalint/raw-lean-report.json")
    parser.add_argument("--fixture-truth-export", help="synthetic fixture input; production revisions reject")
    parser.add_argument("--prefix", default="D5", help="explicit partial measurement scope")
    parser.add_argument("--replay-of", help="rerun every phase and compare canonical outputs to this prior run")
    return execute(parser.parse_args())


if __name__ == "__main__":
    sys.exit(main())
