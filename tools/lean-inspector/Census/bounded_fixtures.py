"""Real olean ballast and real sequential Environment batch controls."""

import json
import pathlib
import shutil

from phases import read, write
from resources import run
from streaming import canonical, closure
from negative_fixtures import COMMAND, PREFIX, key, lean_env


def non_evidence(repository, directory):
    from native import build
    env = lean_env(repository)
    binary = build(repository, "scan.lean", env)
    folder = directory / "non-evidence"
    folder.mkdir(parents=True)
    generator = folder / "Generate.lean"
    generator.write_text('''import Lean
open Lean
def main (args : List String) : IO Unit := do
  let [path, amount] := args | throw <| IO.userError "path count"
  let mut constants : Array ConstantInfo := #[]
  for i in [:amount.toNat!] do
    constants := constants.push (.defnInfo {
      name := .num `Noise i, levelParams := [], type := mkConst ``Nat,
      value := mkNatLit i, hints := .abbrev, safety := .safe })
  let data : ModuleData := { (default : ModuleData) with
    constNames := constants.map (·.name), constants }
  saveModuleData path `Fixture.Noise data
''')
    # Both arms scan the same real domain. File size alone is not a proxy for
    # the reader's maximum active working set; measure the actual index peak.
    manifest = read(directory / "manifest.json")
    ballast = folder / "Noise.olean"
    write(folder / "request.json", {"keys": []})
    write(folder / "manifest.json", manifest + [["Fixture.Noise", [str(ballast)]]])
    measurements = []
    for count in [0, 50000]:
        label = f"constants-{count}"
        run([shutil.which("lean", path=env["PATH"]), "--run", str(generator), str(ballast), str(count)],
            folder, label + "-generate", cwd=repository, env=env, budget_gb=None)
        output = folder / (label + ".jsonl")
        measurement = run([str(binary), str(folder / "manifest.json"), str(folder / "request.json"), str(output)],
                          folder, label, cwd=repository, env=env, budget_gb=1)
        records = [json.loads(line) for line in output.open()]
        assert records[-1]["named"] == [] and records[-1]["owners"] == [], "streamNonEvidenceConstantBound"
        measurements.append({"non_evidence_constants": count, "peak_rss_bytes": measurement["peak_rss_bytes"],
                             "wall_seconds": measurement["wall_seconds"], "index_bytes": output.stat().st_size})
    assert (folder / "constants-0.jsonl").read_bytes() == (folder / "constants-50000.jsonl").read_bytes(), "streamNonEvidenceConstantBound"
    result = {"name": "non_evidence_constants", "check": "streamNonEvidenceConstantBound", "status": "passed",
              "baseline_modules": len(manifest), "measurements": measurements, "retained_bytes_identical": True}
    write(folder / "result.json", result)
    return result


def two_batches(repository, directory):
    from incremental import candidate_batches
    from validation import prepare, run_batches
    env = lean_env(repository)
    folder = directory / "two-batches"
    folder.mkdir()
    keys = [key("StatementLeft", "statement_shared", 31), key("StatementRight", "statement_shared", 32)]
    graph = dict(read(directory / "external.json"))
    headers = []
    for line in (directory / "index.jsonl").open():
        row = json.loads(line)
        graph[row["module"]] = [entry["module"] for entry in row["imports"]]
        headers.append({k: row[k] for k in ["module", "part", "imports"]})
    imports = {k[0]: [COMMAND, k[0]] for k in keys}
    bound = max(len(closure(graph, value)) for value in imports.values())
    batches = candidate_batches(keys, imports, graph, bound)
    assert len(batches) == 2, "streamTwoBatchBound"
    names = sorted(graph)
    indices = {name: i for i, name in enumerate(names)}
    metadata = {"candidate_keys": keys, "external_graph": sorted(graph.items()), "headers": headers,
                "module_names": names, "assignment": {k[0]: k[0] for k in keys},
                "scopes": [[k[0], sorted(indices[n] for n in closure(graph, imports[k[0]]))] for k in keys],
                "evidence_modules": [], "named": []}
    report = {"schema": "stratalint.truth-export", "schema_version": 2,
              "dialect": "stratalint.truth-export.v2", "producer": "TruthExportCommand",
              "source_commit": "fixture-head", "nodes": [
                  {"repo_path": k[0].replace(".", "/") + ".lean", "freeze_status": "frozen",
                   "declarations": [{"kind": "theorem", "declaration_name_key": k[1], "statement_id": k[2]}]}
                  for k in keys]}
    write(folder / "report.json", report)
    for name in ["domain.json", "olean-hashes.json"]:
        shutil.copyfile(directory / name, folder / name)
    request = {"head": "fixture-head", "keys": keys, "report": str(folder / "report.json"), "report_sha256": "unused-parent"}
    plan = prepare(repository, folder, metadata, request, bound=bound, cache=folder / "cache")
    assert len(plan["execute"]) == 2, "streamTwoBatchBound"
    def step(command, label, **kwargs):
        return run(command, folder, label, cwd=repository, env=env, **kwargs)
    result, record = run_batches(repository, folder, metadata, request, plan, step,
                                shutil.which("lean", path=env["PATH"]))
    assert len(result["entries"]) == 2 and len(record["executions"]) == 2, "streamTwoBatchBound"
    assert all(e["receipt"]["environment_modules"] <= bound for e in record["executions"]), "streamTwoBatchBound"
    return {"name": "two_candidate_batches", "check": "streamTwoBatchBound", "status": "passed",
            "bound": bound, "count": 2, "environment_modules": [e["receipt"]["environment_modules"] for e in record["executions"]]}
