"""Run query and publication contracts in real bounded Lean processes."""

import argparse
import hashlib
import json
import os
import pathlib
import tempfile
import unittest

from pipeline import execute
from resources import run


def prepare_fixtures(repository, directory):
    """Compile the fixture closure in dependency order, one bounded process at a time."""
    env = dict(os.environ, LEAN_NUM_THREADS="1")
    run(["make", "lean-cache-ensure"], directory / "cache", "process", cwd=repository, env=env)
    source_root = repository / "tools/lean-inspector"
    build_root = repository / ".lake/build/lib/lean"
    prepared = set()

    def prepare(module):
        if module in prepared:
            return
        prepared.add(module)
        source = source_root / (module.replace(".", "/") + ".lean")
        target = build_root / (module.replace(".", "/") + ".olean")
        logs = directory / "prepare" / module
        run(["lake", "env", "lean", "--deps", str(source)], logs, "deps", cwd=repository, env=env)
        dependencies = [pathlib.Path(line) for line in (logs / "deps.log").read_text().splitlines()]
        for dependency in dependencies:
            if dependency.is_relative_to(build_root):
                relative = dependency.relative_to(build_root).with_suffix(".lean")
                if (source_root / relative).exists():
                    prepare(".".join(relative.with_suffix("").parts))
        if (target.exists() and target.stat().st_mtime_ns >= source.stat().st_mtime_ns
                and all(path.exists() and path.stat().st_mtime_ns <= target.stat().st_mtime_ns
                        for path in dependencies)):
            return
        target.parent.mkdir(parents=True, exist_ok=True)
        run(["lake", "env", "lean", "-R", str(source_root), "-o", str(target), str(source)],
            logs, "compile", cwd=repository, env=env)

    for module in ("Query.Observed", "Query.DuplicateLeft", "Query.DuplicateRight", "Query.Contract",
                   "Query.Coverage", "Query.Publication", "Query.DirectEvidence", "Query.Enumeration", "Query.Ownership",
                   "AssessmentCommand", "Command", "CommandRejection",
                   "InvalidEvidence", "LandedFinite", "Coverage", "Json", "NameIdentity", "Assessment",
                   "Evidence", "ArchitectureRepair", "ProvenanceUniverses", "RegisteredClosedTruth", "LawRegistry",
                   "SplitRootCatalog", "UnreachableProofs", "UnreachableRoot",
                   "Manifest.Contract", "Manifest.Environment", "Manifest.Precedence",
                   "Manifest.Length", "Manifest.Ascending", "Manifest.Chunks", "Manifest.Buckets"):
        prepare("LeanInformationAudit.Tests.Census." + module)
    prepare("LeanInformationAudit.Census.Command")


def name_key(text):
    result = "n0"
    for part in text.split("."):
        result = f"ns({result},{len(part.encode('utf-8'))}:{part})"
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output")
    options = parser.parse_args()
    suite = unittest.defaultTestLoader.discover(str(pathlib.Path(__file__).parent), pattern="test_*.py")
    if not unittest.TextTestRunner().run(suite).wasSuccessful():
        raise SystemExit(1)
    directory = pathlib.Path(options.output or tempfile.mkdtemp(prefix="census-fixtures-")).resolve()
    directory.mkdir(parents=True, exist_ok=True)
    repository = pathlib.Path(__file__).resolve().parents[3]
    prepare_fixtures(repository, directory)
    identity_path = directory / "identity.json"
    identity_source = directory / "Identity.lean"
    identity_source.write_text("import LeanInformationAudit.DispositionCensus\n"
        f"#eval IO.FS.writeFile {json.dumps(str(identity_path))} "
        "LeanInformationAudit.DispositionCensus.truthExportIdentity.compress\n")
    run(["lake", "env", "lean", str(identity_source)], directory / "identity", "process", cwd=repository)
    report = dict(json.loads(identity_path.read_text()), source_commit="fixture-head", nodes=[])
    source = "LeanInformationAudit.Tests.Census.Query.Observed"
    finite = "LeanInformationAudit.Tests.SealSuccess"
    for module, declaration, identity in [
            (source, source + ".independent", "sha256:" + format(1, "064x")),
            (finite, finite + ".idTheorem", "sha256:" + format(0, "064x")),
            ("LeanInformationAudit.Tests.Census.Query.DuplicateLeft",
             "LeanInformationAudit.Tests.Census.Query.shared", "sha256:" + format(2, "064x")),
            ("LeanInformationAudit.Tests.Census.Query.DuplicateRight",
             "LeanInformationAudit.Tests.Census.Query.shared", "sha256:" + format(3, "064x")),
            ("LeanInformationAudit.Tests.Census.Evidence", None, None)]:
        report["nodes"].append({"repo_path": module.replace(".", "/") + ".lean",
                                "freeze_status": "frozen", "declarations": [] if declaration is None else [
                                    {"kind": "theorem", "declaration_name_key": name_key(declaration),
                                     "statement_id": identity}]})
    report_path = directory / "report.json"
    report_path.write_text(json.dumps(report) + "\n")
    duplicate_request = directory / "duplicate-evidence-imports.json"
    duplicate_request.write_text(json.dumps({"head": "fixture-head", "report": str(report_path),
        "report_sha256": "sha256:" + hashlib.sha256(report_path.read_bytes()).hexdigest(),
        "keys": [[node["repo_path"].removesuffix(".lean").replace("/", "."),
                  decl["declaration_name_key"], decl["statement_id"]]
                 for node in report["nodes"] for decl in node["declarations"]
                 if node["repo_path"].endswith(("DuplicateLeft.lean", "DuplicateRight.lean"))]}) + "\n")
    duplicate_source = directory / "DuplicateEvidenceImports.lean"
    duplicate_output = directory / "duplicate-evidence-output.json"
    duplicate_source.write_text("import LeanInformationAudit.Census.Command\n"
        "import LeanInformationAudit.Tests.Census.Query.DuplicateLeft\n"
        "import LeanInformationAudit.Tests.Census.Query.DuplicateRight\n"
        f"#census_query {json.dumps(str(duplicate_request))} output {json.dumps(str(duplicate_output))}\n")
    try:
        run(["lake", "env", "lean", str(duplicate_source)], directory / "duplicate-evidence-imports",
            "process", cwd=repository)
    except RuntimeError:
        log = (directory / "duplicate-evidence-imports/process.log").read_text()
        assert any(message in log for message in
                   ("owning module mismatch", "already been declared", "environment already contains")), log
        assert not duplicate_output.exists()
    else:
        raise AssertionError("duplicate-name owners reintroduced by evidence imports were accepted")
    results = []
    for label in ("first", "second"):
        run_directory = directory / label
        outcome = execute(argparse.Namespace(output=str(run_directory), fixture_truth_export=str(report_path),
                                            lean_report=None, prefix="LeanInformationAudit", partition_modules=32))
        if outcome != 0:
            raise RuntimeError("fixture census did not complete")
        artifact = (run_directory / "census.json").read_bytes()
        projection = json.loads(artifact)
        assert projection["counts"]["accounted"] == 4
        assert projection["counts"]["certified"] == 1
        assert projection["counts"]["observed"] == 3
        duplicates = [row for row in projection["rows"]
                      if row["statement_id"] in {"sha256:" + format(n, "064x") for n in (2, 3)}]
        assert len(duplicates) == 2
        assert duplicates[0]["theorem_name"] == duplicates[1]["theorem_name"]
        assert duplicates[0]["payload"]["owning_module"] != duplicates[1]["payload"]["owning_module"]
        assert projection["certified_complete"] is False
        results.append(hashlib.sha256(artifact).hexdigest())
        probe = run_directory / "Absent.lean"
        probe.write_text("import Lean\nimport CensusRun.Root\nopen Lean Elab Command\n"
                         "run_cmd do\n"
                         "  if (<- getEnv).contains\n"
                         "      `LeanInformationAudit.Tests.Census.Query.Observed.independent then\n"
                         "    throwError \"observed theorem imported by publication\"\n")
        import os
        env = dict(os.environ, LEAN_PATH=str(run_directory), LEAN_NUM_THREADS="1")
        run(["lake", "env", "lean", str(probe)], directory / (label + "-absent"), "process",
            cwd=repository, env=env)
    assert results[0] == results[1], "artifact bytes are nondeterministic"
    partial = directory / "partial-certified"
    assert execute(argparse.Namespace(output=str(partial), fixture_truth_export=str(report_path),
                                      lean_report=None, prefix=finite, partition_modules=32)) == 2
    summary = json.loads((partial / "census.json.summary.json").read_text())
    assert summary["status"] == "partial" and summary["requested_keys"] == 4
    assert summary["counts"]["accounted"] == summary["counts"]["certified"] == 1
    assert summary["counts"]["observed"] == 0 and summary["certified_complete"] is False
    assert summary["report_sha256"] == "sha256:" + hashlib.sha256(report_path.read_bytes()).hexdigest()
    bad_request = directory / "bad-request.json"
    bad_request.write_text(json.dumps({"head": "fixture-head", "keys": [], "query_completed": True}))
    bad_output = directory / "bad-output.json"
    bad_source = directory / "BadRequest.lean"
    bad_source.write_text("import LeanInformationAudit.Census.Command\n"
                          f"#census_query {json.dumps(str(bad_request))} output {json.dumps(str(bad_output))}\n")
    try:
        run(["lake", "env", "lean", str(bad_source)], directory / "input-flag", "process", cwd=repository)
    except RuntimeError:
        assert "input requires exactly head, keys, report and report_sha256" in (directory / "input-flag/process.log").read_text()
        assert not bad_output.exists()
    else:
        raise AssertionError("input completion flag was accepted")
    for module in ("Query/Contract", "Query/Coverage", "Query/Publication", "Query/DirectEvidence", "Query/Enumeration", "AssessmentCommand", "Command",
                   "CommandRejection", "InvalidEvidence", "LandedFinite"):
        run(["lake", "env", "lean", "-R", str(repository / "tools/lean-inspector"),
             "-DmaxRecDepth=100000", "-DmaxHeartbeats=0",
             str(repository / f"tools/lean-inspector/LeanInformationAudit/Tests/Census/{module}.lean")],
            directory / module, "process", cwd=repository)
    from receipt_fixtures import check_receipts
    receipt_negatives = check_receipts(repository, directory, report_path)
    from negative_fixtures import check_manifest_negatives
    manifest_negatives = check_manifest_negatives(repository, directory)
    from chunk_fixtures import check_chunks
    manifest_negatives.extend(check_chunks(repository, directory))
    from bucket_fixtures import check_bucket_negatives
    manifest_negatives.extend(check_bucket_negatives(repository, directory))
    result = {"query_contract": "passed", "coverage": "passed", "artifact_determinism": results[0],
              "manifest_negatives": manifest_negatives,
              "query_receipt_negatives": receipt_negatives,
              "duplicate_owners_via_evidence_imports": "rejected",
              "private_evidence": "included", "transparent_alias": "observed; normalization deferred to J4",
              "direct_unreachable_bounded_and_malformed_evidence": "passed",
              "partial_certified_denominator": "passed (accounted=1/4, certified=1, observed=0, certified_complete=false)",
              "duplicate_name_modules": 2,
              "existing_census_command_fixtures": 5,
              "observed_theorem_absent_from_publication": True, "input_completion_flag_rejected": True,
              "counts": projection["counts"]}
    (directory / "fixtures.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result), flush=True)


if __name__ == "__main__":
    main()
