"""Run-local truth census. Lean owns registration queries and certification."""

from __future__ import annotations

import json
import pathlib
import argparse
import hashlib
import os
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
    isolated = {module for members in owners.values() if len(members) > 1 for module in members}
    # Lean's imported constant map has one owner per Name. Keep repeated names
    # in separate elaborated environments while preserving each statement ID.
    return sorted(partition_modules(set(modules) - isolated, limit)
                  + [(module, [module]) for module in isolated])


def validate_result(result, head, keys):
    if not isinstance(result, dict) or set(result) != {"head", "root", "scope", "entries", "certified_imports"}:
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


def write_requests(directory: pathlib.Path, keys):
    for start in range(0, len(keys), 100):
        chunk = start // 100
        path = directory / f"Group{chunk // 20:04d}" / f"Rows{chunk:05d}.json"
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(keys[start:start + 100], ensure_ascii=True) + "\n", encoding="ascii")


def execute(options):
    from emission import array, module_pool, rows_module, scope_module, string, write_module
    from resources import run

    repository = pathlib.Path(__file__).resolve().parents[3]
    directory = pathlib.Path(options.output).resolve()
    directory.mkdir(parents=True, exist_ok=False)
    started = time.monotonic()
    state = {"status": "running", "rss_budget_gib": 8, "concurrency": 1, "partitions": {},
             "runtime_seconds": {}, "rejected": [], "assumed_unverified": []}
    env = dict(os.environ, LEAN_NUM_THREADS="1")
    # Lake adds its own search paths after this run-local root.
    env["LEAN_PATH"] = str(directory) + os.pathsep + env.get("LEAN_PATH", "")
    env["LEAN_SRC_PATH"] = str(repository / "tools/lean-inspector") + os.pathsep + str(repository)

    def save():
        state["runtime_seconds"]["total"] = round(time.monotonic() - started, 3)
        (directory / "run.json").write_text(json.dumps(state, indent=2) + "\n")

    def step(command, label, log_directory=None):
        log_directory = log_directory or directory / "logs" / label
        print("CENSUS_STEP " + label, flush=True)
        result = run(command, log_directory, "process", cwd=repository, env=env)
        state["runtime_seconds"][label] = result["wall_seconds"]
        save()
        return result

    def lean(path, label, compile_module=False):
        arguments = ["lake", "env", "lean", "-DmaxRecDepth=100000", "-DmaxHeartbeats=0",
                     "-R", str(directory)]
        if compile_module:
            arguments += ["-o", str(path.with_suffix(".olean"))]
        return step([*arguments, str(path)], label)

    try:
        if not options.truth_export:
            step(["make", "lean-cache-ensure"], "cache")
        for module in ["Census.Coverage", "DispositionEvidence", "DispositionCensus",
                       "Census.Query", "Census.Command", "Census.Publish"]:
            source = repository / "tools/lean-inspector/LeanInformationAudit" / (module.replace(".", "/") + ".lean")
            target = repository / ".lake/build/lib/lean/LeanInformationAudit" / (module.replace(".", "/") + ".olean")
            target.parent.mkdir(parents=True, exist_ok=True)
            step(["lake", "env", "lean", "-R", str(repository / "tools/lean-inspector"),
                  "-o", str(target), str(source)], "build-" + module)
        if options.truth_export:
            report_path = pathlib.Path(options.truth_export).resolve()
        else:
            step(["git", "diff", "--exit-code", "HEAD", "--", "D5", "lean-toolchain",
                  "lake-manifest.json", "lakefile.toml", "Golden/Frozen/state"], "pinned-inputs")
            step(["make", "truth-export", f"OUT={directory / 'truth'}", f"LEAN_REPORT={options.lean_report}"], "truth-export")
            report_path = directory / "truth/truth-export.v1.json"
        report_bytes = report_path.read_bytes()
        report = json.loads(report_bytes)
        head = report["source_commit"]
        state["source_commit"] = head
        state["report_sha256"] = "sha256:" + hashlib.sha256(report_bytes).hexdigest()
        all_keys = frozen_keys(report)
        keys = [key for key in all_keys if key[0] == options.prefix or key[0].startswith(options.prefix + ".")]
        state["requested_keys"] = len(all_keys)
        state["selected_keys"] = len(keys)
        if not keys:
            raise ValueError("no frozen theorem keys selected")
        if options.truth_export:
            modules = sorted({node["repo_path"].removesuffix(".lean").replace("/", ".") for node in report["nodes"]})
        else:
            tracked = subprocess.check_output(["git", "ls-files", "-z", "--", "D5"], cwd=repository)
            modules = sorted(path.decode().removesuffix(".lean").replace("/", ".")
                             for path in tracked.split(b"\0") if path.endswith(b".lean"))
        if options.prefix != "D5" and not options.truth_export:
            modules = [module for module in modules
                       if module == options.prefix or module.startswith(options.prefix + ".")]
        partitions = partition_modules(modules, options.partition_modules)
        query_partitions = partition_queries(modules, keys, options.partition_modules)
        state["partitioning"] = {"module_limit": options.partition_modules, "total": len(partitions),
                                 "query_total": len(query_partitions),
                                 "grouping": "top-level directory under D5/S*, sorted chunks; repeated-name owners queried alone"}
        save()
        evidence_modules = set()
        for number, (label, members) in enumerate(partitions):
            if not options.truth_export:
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
        state["evidence_modules"] = sorted(evidence_modules)
        completed = []
        query_outputs = []
        scope_modules = []
        certified_imports = set()
        for number, (label, members) in enumerate(query_partitions):
            selected = [key for key in keys if key[0] in members]
            if not selected:
                continue
            relative = f"Group{number // 20:04d}.Part{number:05d}"
            folder = directory / "queries" / relative.replace(".", "/")
            folder.mkdir(parents=True, exist_ok=True)
            request = folder / "request.json"
            response = folder / "response.json"
            request.write_text(json.dumps({"head": head, "keys": selected}) + "\n")
            source = "import LeanInformationAudit.Census.Command\n" + "".join(
                f"import {module}\n" for module in sorted(set(members) | evidence_modules))
            source += f"#census_query {string(str(request))} output {string(str(response))}\n"
            path = write_module(directory, "CensusQueryRun." + relative, source)
            try:
                result = lean(path, "query-" + label)
                output = validate_result(json.loads(response.read_text()), head, selected)
            except (RuntimeError, ValueError) as error:
                state["rejected"].append({"partition": label, "keys": len(selected), "error": str(error)})
                save()
                break
            state["partitions"].setdefault(label, {})["query"] = result
            state["partitions"][label]["query_modules"] = members
            state["partitions"][label]["keys"] = len(selected)
            certified_imports.update(output["certified_imports"])
            scope = "CensusRun.Scopes." + relative
            query_outputs.append((label, scope, output))
            scope_modules.append(scope)
            completed.extend((row, scope) for row in output["entries"])
            state["completed_keys"] = len(completed)
            save()
        if not completed:
            raise RuntimeError("no completed query partitions; no census artifact published")
        pool = "CensusRun.ModuleNames"
        pool_modules, indexes = module_pool(directory, pool, [output for _, _, output in query_outputs])
        for module, path in pool_modules:
            lean(path, "names-" + module, True)
        for label, scope, output in query_outputs:
            path = scope_module(directory, scope, output, pool, indexes)
            lean(path, "scope-" + label, True)
        completed.sort(key=lambda item: item[0]["statement_id"])
        completed_ids = {row["statement_id"] for row, _ in completed}
        if len(completed) != len(all_keys):
            subset = dict(report, nodes=[dict(node, declarations=[decl for decl in node["declarations"]
                if decl.get("statement_id") in completed_ids]) for node in report["nodes"]])
            report_path = directory / "partial-report.json"
            report_path.write_text(json.dumps(subset) + "\n")
            state["status"] = "partial"
        else:
            state["status"] = "complete"
        inventories = []
        for start in range(0, len(completed), 100):
            number = start // 100
            module = f"CensusRun.Rows.Group{number // 20:04d}.Rows{number:05d}"
            path = rows_module(directory, module, completed[start:start + 100])
            lean(path, "rows-" + str(number), True)
            inventories.append(module)
        # Only evidence selected by successful certification enters the final environment.
        imports = sorted(set(inventories) | certified_imports)
        state["certified_imports"] = sorted(certified_imports)
        source = "".join(f"import {module}\n" for module in imports)
        source += "open LeanInformationAudit\n"
        source += f"def CensusRun.inventory : DispositionInventory :=\n  {{ headSha := {string(head)}, entries := "
        source += "CensusProjection.assemble " + array(module + ".rows" for module in inventories) + " }\n"
        source += f"def CensusRun.scopes : Array CensusProjection.Scope := {array(scope + '.record' for scope in scope_modules)}\n"
        digest = "sha256:" + hashlib.sha256(report_path.read_bytes()).hexdigest()
        source += (f"#disposition_census projection root CensusRun.Root report {string(str(report_path))}\n"
                   f"  head {string(head)} report_sha256 {string(digest)} inventory CensusRun.inventory\n"
                   f"  scopes CensusRun.scopes certificate CensusRun.exactlyCovers output {string(str(directory / 'census.json'))}\n")
        path = write_module(directory, "CensusRun.Root", source)
        lean(path, "publication", True)
        summary = json.loads((directory / "census.json.summary.json").read_text())
        state["artifact_counters"] = dict(summary["counts"], certified_complete=summary["certified_complete"])
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
    parser.add_argument("--truth-export", help="explicit export input (also used by fixtures)")
    parser.add_argument("--prefix", default="D5", help="explicit partial measurement scope")
    parser.add_argument("--partition-modules", type=int, default=32)
    return execute(parser.parse_args())


if __name__ == "__main__":
    sys.exit(main())
