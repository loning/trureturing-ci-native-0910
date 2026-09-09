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
    publisher = source_root / "LeanInformationAudit/Census/Publish.lean"
    report = source_root / "LeanInformationAudit/Census/Report.lean"
    contract = source_root / "LeanInformationAudit/Tests/Census/Manifest/Contract.lean"
    environment = contract.with_name("Environment.lean")
    cases = [
        ("drop-ascending", publisher, contract, "certificateAscendingConjunct",
         lambda text: text.replace(
             '" :\\n  LeanInformationAudit.CensusKeyManifest.Certificate " ++', '" :\\n  " ++').replace(
             'ids.toString ++ " " ++ toString requested ++ " " ++ reportIds.toString ++',
             'ids.toString ++ ".length = " ++ toString requested ++ " ∧ " ++ ids.toString ++ " = " ++ reportIds.toString ++').replace(
             'exact ⟨by decide +kernel, by decide +kernel, rfl⟩', 'exact ⟨by decide +kernel, rfl⟩')),
        ("drop-length", publisher, contract.with_name("Length.lean"), "certificateLengthConjunct",
         lambda text: text.replace(
             '" :\\n  LeanInformationAudit.CensusKeyManifest.Certificate " ++', '" :\\n  LeanInformationAudit.strictlyAscending " ++').replace(
             'ids.toString ++ " " ++ toString requested ++ " " ++ reportIds.toString ++',
             'ids.toString ++ " = true ∧ " ++ ids.toString ++ " = " ++ reportIds.toString ++').replace(
             'exact ⟨by decide +kernel, by decide +kernel, rfl⟩', 'exact ⟨by decide +kernel, rfl⟩')),
        ("skip-chunk-recomputation", manifest, contract.with_name("Chunks.lean"), "chunkLiteralBinding",
         lambda text: text.replace(
             '    unless (.lit (.natVal value) : Expr) == .lit (.natVal packed) do',
             '    unless (.lit (.natVal value) : Expr) == .lit (.natVal value) do')),
        ("payload-import", publisher, environment, "finalEnvironmentImports",
         lambda text: text.replace('  let input := input',
             '  let input := "import LeanInformationAudit.DispositionCensus\\n" ++ input')),
        ("report-codec-before-inventory-duplicates", report, contract.with_name("Precedence.lean"),
         "inventoryDuplicateBeforeMalformedReport", lambda text: text.replace(
             "  checkInventoryDuplicates rows\n  checkStatementIds frozen",
             "  checkStatementIds frozen\n  checkInventoryDuplicates rows")),
        ("missing-before-nat-binding", manifest, contract.with_name("Precedence.lean"),
         "manifestNatBeforeMissingRow", lambda text: text.replace(
             "  checkMissingKeys report.headSha report.theorems rows\n", "").replace(
             "  ofExcept <| checkMissingKeys report.headSha report.theorems rows\n", "").replace(
             '  bindKeys "manifest_keys" rows m.keys',
             '  checkMissingKeys report.headSha report.theorems rows\n  bindKeys "manifest_keys" rows m.keys').replace(
             '  let listName := manifestName.appendAfter "Keys"',
             '  ofExcept <| checkMissingKeys report.headSha report.theorems rows\n' +
             '  let listName := manifestName.appendAfter "Keys"')),
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
