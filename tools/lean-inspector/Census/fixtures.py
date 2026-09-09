"""Run the retained J3 elaborator cases and actual streaming olean negatives."""

import argparse
import json
import pathlib
import tempfile
import shutil
import unittest

from negative_fixtures import prepare, check_manifest_negatives, lean_env, validate_control
from receipt_fixtures import check_receipts
from resources import run


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output")
    options = parser.parse_args()
    directory = pathlib.Path(options.output or tempfile.mkdtemp(prefix="census-fixtures-")).resolve()
    directory.mkdir(parents=True, exist_ok=True)
    repository = pathlib.Path(__file__).resolve().parents[3]
    suite = unittest.defaultTestLoader.discover(str(pathlib.Path(__file__).parent), pattern="test_*.py")
    if not unittest.TextTestRunner().run(suite).wasSuccessful():
        raise SystemExit(1)
    run(["make", "lean-cache-ensure"], directory, "cache", cwd=repository, budget_gb=None)
    run(["make", "lean"], directory, "freshness", cwd=repository, budget_gb=None)
    env = lean_env(repository)
    # Lake checks every retained fixture through the inspector lean_lib glob.
    # Reimporting each fixture in another Environment would repeat that work.
    cases = ["Query/Streaming", "Query/Contract", "Query/DirectEvidence", "Query/Enumeration", "Query/Ownership",
             "Query/StreamingOutside", "Query/Coverage", "Query/Publication",
             "AssessmentCommand", "Command", "CommandRejection", "InvalidEvidence", "LandedFinite",
             "Manifest/Contract", "Manifest/Environment", "Manifest/Precedence"]
    for case in ["Query/Streaming"]:
        path = repository / "tools/lean-inspector/LeanInformationAudit/Tests/Census" / (case + ".lean")
        run([shutil.which("lean", path=env["PATH"]), "-DmaxRecDepth=100000", "-DmaxHeartbeats=0", str(path)],
            directory / "lean" / case, "fixture", cwd=repository, env=env)
    streaming = directory / "streaming"
    prepare(repository, streaming)
    negatives = check_manifest_negatives(repository, streaming) + check_receipts(repository, streaming)
    negatives.append(validate_control(repository, streaming))
    from chunk_fixtures import check_chunks
    chunks = check_chunks(repository, directory)
    result = {"negative_fixtures": negatives, "lean_fixture_modules": cases, "retained_fixture_execution": "Lake lean_lib build",
              "certificate_chunk_binding": chunks, "query_scheduler": "retired"}
    (directory / "fixtures.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result), flush=True)


if __name__ == "__main__":
    main()
