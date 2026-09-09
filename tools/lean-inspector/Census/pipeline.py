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


def partition_modules(modules, limit=32):
    if limit < 1:
        raise ValueError("partition limit must be positive")
    groups = {}
    for module in sorted(set(modules)):
        group = ".".join(module.split(".")[:3])
        groups.setdefault(group, []).append(module)
    return [(f"{group}.{start // limit:04d}", members[start:start + limit])
            for group, members in sorted(groups.items())
            for start in range(0, len(members), limit)]


def partition_queries(modules, keys, limit=32):
    owners = {}
    for module, name, _ in keys:
        owners.setdefault(name, set()).add(module)
    isolated = {module for members in owners.values() if len(members) > 1 for module in members} & set(modules)
    # Lean's imported constant map has one owner per Name. Keep repeated names
    # in separate elaborated environments while preserving each statement ID.
    return sorted(partition_modules(set(modules) - isolated, limit)
                  + [(module, [module]) for module in isolated])


def validate_result(result, head, keys):
    if not isinstance(result, dict) or set(result) != {"head", "root", "scope", "entries", "certified_imports", "source_inputs"}:
        raise ValueError("incomplete query result")
    if result["head"] != head or result["scope"].get("completed") is not True:
        raise ValueError("query identity or scope incomplete")
    expected = sorted(key[2] for key in keys)
    if sorted(row["statement_id"] for row in result["entries"]) != expected:
        raise ValueError("query did not complete every requested key exactly once")
    for row in result["entries"]:
        if row["class"] == "observed":
            payload = row["payload"]
            if payload["query_completed"] is not True or payload["root"] != result["root"]:
                raise ValueError("query did not complete")
            if payload["owning_module"] not in result["scope"]["modules"]:
                raise ValueError("owning module absent from query scope")
    return result


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
    certified_complete = complete and summary["counts"]["observed"] == 0
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


def write_requests(directory: pathlib.Path, keys):
    for start in range(0, len(keys), 100):
        chunk = start // 100
        path = directory / f"Group{chunk // 20:04d}" / f"Rows{chunk:05d}.json"
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(keys[start:start + 100], ensure_ascii=True) + "\n", encoding="ascii")


def execute(options):
    from emission import string, write_module
    from resources import run

    repository = pathlib.Path(__file__).resolve().parents[3]
    directory = pathlib.Path(options.output).resolve()
    directory.mkdir(parents=True, exist_ok=False)
    started = time.monotonic()
    state = {"status": "running", "rss_budget_gib": 8, "concurrency": 3, "pipeline_jobs": 1, "partitions": {},
             "query_schedule": [], "query_peak_concurrency": 0,
             "runtime_seconds": {}, "rejected": [], "assumed_unverified": []}
    env = dict(os.environ, LEAN_NUM_THREADS="1")
    env["CENSUS_RESOURCE_ABORT"] = str(directory / "resource-abort.json")
    # Lake adds its own search paths after this run-local root.
    env["LEAN_PATH"] = str(directory) + os.pathsep + env.get("LEAN_PATH", "")
    env["LEAN_SRC_PATH"] = str(repository / "tools/lean-inspector") + os.pathsep + str(repository)

    def save():
        state["runtime_seconds"]["total"] = round(time.monotonic() - started, 3)
        (directory / "run.json").write_text(json.dumps(state, indent=2) + "\n")

    def step(command, label, log_directory=None, phase_path=None):
        log_directory = log_directory or directory / "logs" / label
        print("CENSUS_STEP " + label, flush=True)
        result = run(command, log_directory, "process", cwd=repository, env=env, phase_path=phase_path)
        state["runtime_seconds"][label] = result["wall_seconds"]
        save()
        return result

    def lean(path, label, compile_module=False, phase_path=None):
        arguments = ["lake", "env", "lean", "-DmaxRecDepth=100000", "-DmaxHeartbeats=0",
                     "-R", str(directory)]
        if compile_module:
            arguments += ["-o", str(path.with_suffix(".olean"))]
        return step([*arguments, str(path)], label, phase_path=phase_path)

    try:
        if options.fixture_truth_export:
            validate_fixture_export(json.loads(pathlib.Path(options.fixture_truth_export).read_bytes()))
        step(["make", "lean-cache-ensure"], "cache")
        for module in ["Census.Certificate", "Census.Codec", "CensusSchema", "Census.Coverage", "Census.Report", "Census.Ownership",
                       "Census.Manifest", "Census.Transport", "DispositionEvidence", "DispositionCensus",
                       "Census.Query", "Census.Receipt", "Census.Command", "Census.Publish"]:
            source = repository / "tools/lean-inspector/LeanInformationAudit" / (module.replace(".", "/") + ".lean")
            target = repository / ".lake/build/lib/lean/LeanInformationAudit" / (module.replace(".", "/") + ".olean")
            target.parent.mkdir(parents=True, exist_ok=True)
            step(["lake", "env", "lean", "-R", str(repository / "tools/lean-inspector"),
                  "-o", str(target), str(source)], "build-" + module)
        if options.fixture_truth_export:
            report_path = pathlib.Path(options.fixture_truth_export).resolve()
        else:
            step(["git", "diff", "--exit-code", "HEAD", "--", "D5", "lean-toolchain",
                  "lake-manifest.json", "lakefile.toml", "Golden/Frozen/state"], "pinned-inputs")
            step(["make", "truth-export", f"OUT={directory / 'truth'}", f"LEAN_REPORT={options.lean_report}"], "truth-export")
            report_path = exported_path((directory / "logs/truth-export/process.log").read_text())
        report_bytes = report_path.read_bytes()
        report = json.loads(report_bytes)
        head = report["source_commit"]
        if not options.fixture_truth_export:
            environment_head = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=repository, text=True).strip()
            if head != environment_head:
                raise ValueError("report source_commit differs from the queried environment HEAD")
        state["source_commit"] = head
        state["report_sha256"] = "sha256:" + hashlib.sha256(report_bytes).hexdigest()
        all_keys = frozen_keys(report)
        keys = [key for key in all_keys if key[0] == options.prefix or key[0].startswith(options.prefix + ".")]
        state["requested_keys"] = len(all_keys)
        state["selected_keys"] = len(keys)
        if not keys:
            raise ValueError("no frozen theorem keys selected")
        if options.fixture_truth_export:
            modules = sorted({node["repo_path"].removesuffix(".lean").replace("/", ".") for node in report["nodes"]})
        else:
            tracked = subprocess.check_output(["git", "ls-files", "-z", "--", "D5"], cwd=repository)
            modules = sorted(path.decode().removesuffix(".lean").replace("/", ".")
                             for path in tracked.split(b"\0") if path.endswith(b".lean"))
        if options.prefix != "D5" and not options.fixture_truth_export:
            modules = [module for module in modules
                       if module == options.prefix or module.startswith(options.prefix + ".")]
        partitions = partition_queries(modules, all_keys, options.partition_modules)
        query_partitions = partition_queries(modules, keys, options.partition_modules)
        state["partitioning"] = {"module_limit": options.partition_modules, "total": len(partitions),
                                 "query_total": len(query_partitions),
                                 "grouping": "top-level directory under D5/S*, sorted chunks; repeated-name owners discovered and queried alone"}
        save()
        evidence_modules = set()
        discovery_started = time.monotonic()
        for number, (label, members) in enumerate(partitions):
            if not options.fixture_truth_export:
                step(["lake", "--no-build", "build", *members], "environment-" + label)
            relative = f"Group{number // 20:04d}.Part{number:05d}"
            output = directory / "discovery" / relative.replace(".", "/") / "discovery.json"
            output.parent.mkdir(parents=True, exist_ok=True)
            source = "import LeanInformationAudit.Census.Command\n" + "".join(f"import {module}\n" for module in members)
            source += f"#census_discover {string(str(output))}\n"
            path = write_module(directory, "CensusDiscovery." + relative, source)
            result = lean(path, "discover-" + label)
            evidence_modules.update(json.loads(output.read_text()))
            state["partitions"][label] = {"modules": members, "discovery": result}
            save()
        state["runtime_seconds"]["discovery"] = round(time.monotonic() - discovery_started, 3)
        state["evidence_modules"] = sorted(evidence_modules)
        completed = []
        certified_imports = set()
        response_paths = []
        jobs = []
        for number, (label, members) in enumerate(query_partitions):
            selected = [key for key in keys if key[0] in members]
            if not selected:
                continue
            relative = f"Group{number // 20:04d}.Part{number:05d}"
            folder = directory / "queries" / relative.replace(".", "/")
            folder.mkdir(parents=True, exist_ok=True)
            request = folder / "request.json"
            response = folder / "response.json"
            request.write_text(json.dumps({"head": head, "keys": selected,
                                           "report": str(report_path), "report_sha256": state["report_sha256"]}) + "\n")
            source = "import LeanInformationAudit.Census.Command\n" + "".join(
                f"import {module}\n" for module in sorted(set(members) | evidence_modules))
            source += f"#census_query {string(str(request))} output {string(str(response))}\n"
            path = write_module(directory, "CensusQueryRun." + relative, source)
            jobs.append((label, members, selected, path, response))

        def query(job, cancel):
            label, _, selected, path, response = job
            print("CENSUS_STEP query-" + label, flush=True)
            result = run(["lake", "env", "lean", "-DmaxRecDepth=100000", "-DmaxHeartbeats=0",
                          "-R", str(directory), str(path)], directory / "logs" / ("query-" + label),
                         "process", cwd=repository, env=env, cancel=cancel)
            return result, validate_result(json.loads(response.read_text()), head, selected)

        def scheduled(job, active, capacity, free):
            state["query_schedule"].append({"partition": job[0], "active": active,
                "capacity": capacity, "free_percent": free, "seconds": round(time.monotonic() - started, 3)})
            state["query_peak_concurrency"] = max(state["query_peak_concurrency"], active)
            save()

        from scheduling import query_results
        query_started = time.monotonic()
        for job, (result, output) in query_results(jobs, query, scheduled):
            label, members, selected, path, response = job
            state["runtime_seconds"]["query-" + label] = result["wall_seconds"]
            state["partitions"].setdefault(label, {})["query"] = result
            state["partitions"][label]["query_modules"] = members
            state["partitions"][label]["keys"] = len(selected)
            receipt = json.loads(pathlib.Path(str(response) + ".receipt.json").read_text())
            state["partitions"][label]["direct_import_count"] = receipt["direct_import_count"]
            state["partitions"][label]["transitive_closure_count"] = receipt["transitive_closure_count"]
            response_paths.append(str(response))
            certified_imports.update(output["certified_imports"])
            completed.extend(output["entries"])
            state["completed_keys"] = len(completed)
            save()
        state["runtime_seconds"]["query_partitions"] = round(time.monotonic() - query_started, 3)
        if not completed:
            raise RuntimeError("no completed query partitions; no census artifact published")
        state["status"] = "complete" if len(completed) == len(all_keys) else "partial"
        state["certified_imports"] = sorted(certified_imports)
        receipts = directory / "query-outputs.json"
        receipts.write_text(json.dumps(sorted(response_paths)) + "\n")
        step([sys.executable, str(repository / "tools/lean-inspector/Census/manifest.py"),
              "--directory", str(directory), "--report", str(report_path),
              "--receipts", str(receipts), "--prefix", options.prefix], "manifest_emission")
        path = directory / "CensusRun/Root.lean"
        state["manifest_bytes"] = path.stat().st_size
        publication = lean(directory / "CensusPublish/Root.lean", "publication", False, directory / "census.json.phase")
        state["publication_phases"] = publication["phases"]
        state["final_environment"] = json.loads((directory / "census.json.environment.json").read_text())
        summary = json.loads((directory / "census.json.summary.json").read_text())
        validate_summary(summary, requested=len(all_keys), accounted=len(completed))
        state["artifact_counters"] = dict(summary["counts"], requested_keys=summary["requested_keys"],
                                          certified_complete=summary["certified_complete"])
        state["artifact_bytes"] = (directory / "census.json").stat().st_size
        counts = state["artifact_counters"]
        text = (f"status={state['status']} accounted={counts['accounted']}/{len(all_keys)} "
                f"certified={counts['certified']} observed={counts['observed']} "
                f"certified_complete={str(counts['certified_complete']).lower()}\n")
        (directory / "summary.txt").write_text(text, encoding="ascii")
        print(text, end="", flush=True)
        return 0 if state["status"] == "complete" else 2
    except BaseException as error:
        state["status"] = "rejected"
        state["error"] = str(error)
        raise
    finally:
        save()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", required=True, help="new run-local directory")
    parser.add_argument("--lean-report", default=".lake/build/stratalint/raw-lean-report.json")
    parser.add_argument("--fixture-truth-export", help="synthetic fixture input only; rejects production paths and revisions")
    parser.add_argument("--prefix", default="D5", help="explicit partial measurement scope")
    parser.add_argument("--partition-modules", type=int, default=32)
    return execute(parser.parse_args())


if __name__ == "__main__":
    sys.exit(main())
