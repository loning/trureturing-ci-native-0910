"""Preregistered streaming mutations with compile, named red, and restoration."""

import argparse
import hashlib
import json
import pathlib
import sys

from resources import run


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", required=True, type=pathlib.Path)
    parser.add_argument("--fixtures", required=True, type=pathlib.Path)
    options = parser.parse_args()
    directory = options.output.resolve()
    repository = pathlib.Path(__file__).resolve().parents[3]
    source_root = repository / "tools/lean-inspector"
    python_root = source_root / "Census"
    streaming = python_root / "streaming.py"
    ownership = source_root / "LeanInformationAudit/Census/Ownership.lean"
    membership = source_root / "LeanInformationAudit/Census/Membership.lean"
    incremental = python_root / "incremental.py"
    fixture = source_root / "LeanInformationAudit/Tests/Census/Query/Ownership.lean"
    cases = [
        ("skip-freshness", streaming, "streamFreshnessGate",
         '    return step(["make", "lean"], "lake_freshness")', '    return None',
         [sys.executable, str(python_root / "negative_fixtures.py"), "--directory", str(options.fixtures), "--case", "stale_olean"]),
        ("first-import-ownership", ownership, "ownerMembershipPositive",
         '  return moduleContainsTheorem env.header.moduleData[index.toNat]! info',
         '  return env.getModuleIdxFor? declaration == some index',
         ["lake", "env", "lean", str(fixture)]),
        ("drop-scope-filter", membership, "streamOutOfScopeEvidence",
         '      unless scope.contains entry.moduleName do continue',
         '      pure ()',
         [sys.executable, str(python_root / "negative_fixtures.py"), "--directory", str(options.fixtures), "--case", "out_of_scope"]),
        ("ignore-import-graph", streaming, "test_receipt_digest_includes_import_graph",
         'def receipt_digest(inputs):\n    return digest(inputs)',
         'def receipt_digest(inputs):\n    return digest({k: v for k, v in inputs.items() if k != "import_graph"})',
         [sys.executable, "-m", "unittest", "test_streaming.StreamingTests.test_receipt_digest_includes_import_graph"]),
        ("cache-ignores-olean-digest", incremental, "test_stale_extraction_cache_reextracts_changed_olean_only",
         '    addresses = module_digests(hashes)',
         '    addresses = {module: digest(module) for module, _ in manifest}',
         [sys.executable, "-m", "unittest", "test_incremental.IncrementalTests.test_stale_extraction_cache_reextracts_changed_olean_only"]),
        ("ignore-batch-bound", incremental, "test_two_batches_respect_union_closure_bound",
         '        if current_keys and len(modules | scope) > bound:',
         '        if current_keys and not modules:',
         [sys.executable, "-m", "unittest", "test_incremental.IncrementalTests.test_two_batches_respect_union_closure_bound"]),
        ("skip-statement-collision-resolution", membership, "streamStatementCollisionPositive",
         '      let matching := resolveCollision occurrences id',
         '      let matching : Array String := #[]',
         [sys.executable, str(python_root / "negative_fixtures.py"), "--directory", str(options.fixtures), "--case", "statement_collision"]),
    ]
    outcomes = []
    for label, source, expected, old, new, command in cases:
        original = source.read_bytes()
        assert original.decode().count(old) == 1, "mutation location is not unique"
        mutated = original.decode().replace(old, new).encode()
        target = (repository / ".lake/build/lib/lean" / source.relative_to(source_root).with_suffix(".olean")) if source.suffix == ".lean" else None
        compiled = target.read_bytes() if target else None
        native = repository / ".lake/build/ir" / source.relative_to(source_root).with_suffix(".c") if target else None
        native_bytes = native.read_bytes() if native else None
        logs = directory / label
        logs.mkdir(parents=True, exist_ok=False)
        record = {"mutation": label, "location": str(source.relative_to(repository)),
                  "expected_named_red": [expected], "expected_red_count": 1,
                  "pristine_sha256": hashlib.sha256(original).hexdigest(),
                  "mutant_sha256": hashlib.sha256(mutated).hexdigest(),
                  "expected_written_before_running": True}
        (logs / "preregistration.json").write_text(json.dumps(record, indent=2) + "\n")
        try:
            source.write_bytes(mutated)
            compile_command = (["lake", "env", "lean", "-R", str(source_root), "-o", str(target), "-c", str(native), str(source)]
                if target else [sys.executable, "-m", "py_compile", str(source)])
            run(compile_command, logs, "compile", cwd=repository)
            record["compile_errors"] = 0
            try:
                run(command, logs, "test", cwd=python_root if command[1:3] == ["-m", "unittest"] else repository)
            except RuntimeError:
                log = (logs / "test.log").read_text()
                assert expected in log, log
                record["named_red"] = [expected]
                record["test_exit_code"] = json.loads((logs / "test.resources.json").read_text())["exit_code"]
            else:
                raise AssertionError(label + " survived")
        finally:
            source.write_bytes(original)
            if target:
                target.write_bytes(compiled)
                native.write_bytes(native_bytes)
            record["restored_byte_identical"] = source.read_bytes() == original and (not target or
                target.read_bytes() == compiled and native.read_bytes() == native_bytes)
            (logs / "result.json").write_text(json.dumps(record, indent=2) + "\n")
        outcomes.append(record)
    run([sys.executable, "-m", "unittest", "test_streaming", "test_incremental"], directory, "restored-python", cwd=python_root)
    run(["lake", "env", "lean", str(fixture)], directory, "restored-membership", cwd=repository)
    (directory / "mutations.json").write_text(json.dumps(outcomes, indent=2) + "\n")
    print(json.dumps(outcomes), flush=True)


if __name__ == "__main__":
    main()
