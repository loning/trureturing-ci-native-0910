"""Run query and publication contracts in real bounded Lean processes."""

import argparse
import hashlib
import json
import pathlib
import tempfile

from pipeline import execute
from resources import run


def name_key(text):
    result = "n0"
    for part in text.split("."):
        result = f"ns({result},{len(part.encode('utf-8'))}:{part})"
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output")
    options = parser.parse_args()
    directory = pathlib.Path(options.output or tempfile.mkdtemp(prefix="census-fixtures-")).resolve()
    directory.mkdir(parents=True, exist_ok=True)
    repository = pathlib.Path(__file__).resolve().parents[3]
    report = {"schema": "stratalint.truth-export", "schema_version": 2,
              "dialect": "stratalint.truth-export.v2", "producer": "TruthExportCommand",
              "source_commit": "fixture-head", "nodes": []}
    source = "LeanInformationAudit.Tests.Census.Query.Observed"
    finite = "LeanInformationAudit.Tests.SealSuccess"
    run(["lake", "env", "lean", "-o",
         str(repository / ".lake/build/lib/lean/LeanInformationAudit/Tests/Census/Query/Observed.olean"),
         str(repository / "tools/lean-inspector/LeanInformationAudit/Tests/Census/Query/Observed.lean")],
        directory / "observed-fixture", "process", cwd=repository)
    for module, declaration, identity in [
            (source, source + ".independent", "b-observed"),
            (finite, finite + ".idTheorem", "a-certified"),
            ("LeanInformationAudit.Tests.Census.Evidence", None, None)]:
        report["nodes"].append({"repo_path": module.replace(".", "/") + ".lean",
                                "freeze_status": "frozen", "declarations": [] if declaration is None else [
                                    {"kind": "theorem", "declaration_name_key": name_key(declaration),
                                     "statement_id": identity}]})
    report_path = directory / "report.json"
    report_path.write_text(json.dumps(report) + "\n")
    results = []
    for label in ("first", "second"):
        run_directory = directory / label
        outcome = execute(argparse.Namespace(output=str(run_directory), truth_export=str(report_path),
                                            lean_report=None, prefix="LeanInformationAudit", partition_modules=32))
        if outcome != 0:
            raise RuntimeError("fixture census did not complete")
        artifact = (run_directory / "census.json").read_bytes()
        projection = json.loads(artifact)
        assert projection["counts"]["accounted"] == 2
        assert projection["counts"]["certified"] == 1
        assert projection["counts"]["observed"] == 1
        assert projection["certified_complete"] is False
        results.append(hashlib.sha256(artifact).hexdigest())
        probe = run_directory / "Absent.lean"
        probe.write_text("import CensusRun.Root\nopen Lean Elab Command\n"
                         "run_cmd do\n"
                         "  if (<- getEnv).contains\n"
                         "      `LeanInformationAudit.Tests.Census.Query.Observed.independent then\n"
                         "    throwError \"observed theorem imported by publication\"\n")
        import os
        env = dict(os.environ, LEAN_PATH=str(run_directory), LEAN_NUM_THREADS="1")
        run(["lake", "env", "lean", str(probe)], directory / (label + "-absent"), "process",
            cwd=repository, env=env)
    assert results[0] == results[1], "artifact bytes are nondeterministic"
    bad_request = directory / "bad-request.json"
    bad_request.write_text(json.dumps({"head": "fixture-head", "keys": [], "query_completed": True}))
    bad_output = directory / "bad-output.json"
    bad_source = directory / "BadRequest.lean"
    bad_source.write_text("import LeanInformationAudit.Census.Command\n"
                          f"#census_query {json.dumps(str(bad_request))} output {json.dumps(str(bad_output))}\n")
    try:
        run(["lake", "env", "lean", str(bad_source)], directory / "input-flag", "process", cwd=repository)
    except RuntimeError:
        assert "input requires exactly head and keys" in (directory / "input-flag/process.log").read_text()
        assert not bad_output.exists()
    else:
        raise AssertionError("input completion flag was accepted")
    for module in ("Contract", "Coverage"):
        run(["lake", "env", "lean", "-DmaxRecDepth=100000", "-DmaxHeartbeats=0",
             str(repository / f"tools/lean-inspector/LeanInformationAudit/Tests/Census/Query/{module}.lean")],
            directory / module, "process", cwd=repository)
    result = {"query_contract": "passed", "coverage": "passed", "artifact_determinism": results[0],
              "observed_theorem_absent_from_publication": True, "input_completion_flag_rejected": True,
              "counts": projection["counts"]}
    (directory / "fixtures.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result), flush=True)


if __name__ == "__main__":
    main()
