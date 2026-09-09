"""Execute preregistered production mutations and retain six-tuple receipts."""

import argparse
import hashlib
import json
import pathlib

from resources import run


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", required=True, type=pathlib.Path)
    options = parser.parse_args()
    directory = options.output.resolve()
    repository = pathlib.Path(__file__).resolve().parents[3]
    source_root = repository / "tools/lean-inspector"
    manifest = source_root / "LeanInformationAudit/Census/Manifest.lean"
    codec = source_root / "LeanInformationAudit/Census/Codec.lean"
    publisher = source_root / "LeanInformationAudit/Census/Publish.lean"
    contract = source_root / "LeanInformationAudit/Tests/Census/Manifest/Contract.lean"
    environment = contract.with_name("Environment.lean")
    cases = [
        ("drop-ascending", manifest, contract, "certificateAscendingConjunct",
         lambda text: text.replace(
             '  let mut proof ← mkAppM ``And.intro #[orderProof, equalityProof]',
             '  let mut proof := equalityProof')),
        ("inventory-copy-rhs", manifest, contract, "reportListEqualityBinding",
         lambda text: text.replace(
             '#[manifest, toExpr head, toExpr sha, toExpr root, reportKeys]',
             '#[manifest, toExpr head, toExpr sha, toExpr root, keys]')),
        ("skip-codec-roundtrip", codec, contract, "codecRoundTripBinding",
         lambda text: text.replace(
             '  unless (← renderStatementId value) == wire do throw <| formatError name wire\n', '')),
        ("payload-import", publisher, environment, "finalEnvironmentImports",
         lambda text: text.replace('Elab.runFrontend input options',
             'Elab.runFrontend ("import LeanInformationAudit.DispositionCensus\\n" ++ input) options')),
        ("publisher-import", publisher, environment, "finalEnvironmentImports",
         lambda text: text.replace('Elab.runFrontend input options',
             'Elab.runFrontend ("import LeanInformationAudit.Census.Publish\\n" ++ input) options')),
    ]
    outcomes = []
    for label, source, fixture, expected, transform in cases:
        original = source.read_bytes()
        mutated = transform(original.decode()).encode()
        assert original != mutated, "mutation did not change production"
        target = repository / ".lake/build/lib/lean" / source.relative_to(source_root).with_suffix(".olean")
        compiled_original = target.read_bytes()
        logs = directory / label
        logs.mkdir(parents=True, exist_ok=False)
        record = {"mutation": label, "location": str(source.relative_to(repository)),
                  "expected_named_red": [expected], "expected_red_count": 1,
                  "pristine_sha256": hashlib.sha256(original).hexdigest(),
                  "mutant_sha256": hashlib.sha256(mutated).hexdigest()}
        (logs / "preregistration.json").write_text(json.dumps(record, indent=2) + "\n")
        compile_command = ["lake", "env", "lean", "-R", str(source_root), "-o", str(target), str(source)]
        try:
            source.write_bytes(mutated)
            run(compile_command, logs, "compile", cwd=repository)
            record["compile_errors"] = 0
            try:
                run(["lake", "env", "lean", str(fixture)], logs, "test", cwd=repository)
            except RuntimeError:
                log = (logs / "test.log").read_text()
                errors = [line for line in log.splitlines() if ": error:" in line]
                assert len(errors) == 1 and expected in errors[0], log
                record["named_red"] = expected
                record["actual_red_count"] = len(errors)
                record["test_exit_code"] = json.loads((logs / "test.resources.json").read_text())["exit_code"]
            else:
                raise AssertionError(label + " survived")
        finally:
            source.write_bytes(original)
            target.write_bytes(compiled_original)
            record["restored_byte_identical"] = source.read_bytes() == original and target.read_bytes() == compiled_original
            (logs / "result.json").write_text(json.dumps(record, indent=2) + "\n")
        outcomes.append(record)
    run(["lake", "env", "lean", str(contract)], directory, "restored-contract", cwd=repository)
    run(["lake", "env", "lean", str(environment)], directory, "restored-environment", cwd=repository)
    (directory / "mutations.json").write_text(json.dumps(outcomes, indent=2) + "\n")
    print(json.dumps(outcomes))


if __name__ == "__main__":
    main()
