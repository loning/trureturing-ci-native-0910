"""Manifest and row binding attacks through the actual data-only publisher."""

import copy
import json
import os
import pathlib
import re

from emission import manifest_source, bucket_sources, string, write_module
from pipeline import frozen_keys
from resources import run


def partition_check_manifest_negatives(repository, directory, only=None):
    root = directory / "first"
    source = root / "CensusRun/Root.lean"
    original = {"CensusRun.Root": source.read_text()}
    original.update({"CensusRun." + p.stem: p.read_text() for p in source.parent.glob("Bucket*.lean")})

    def change(bundle, module, transform):
        return dict(bundle, **{module: transform(bundle[module])})

    def root_change(transform):
        return change(original, "CensusRun.Root", transform)

    def bucket_change(transform, bundle=None):
        return change(original if bundle is None else bundle, "CensusRun.Bucket0", transform)
    driver = root / "CensusPublish/Root.lean"
    original_driver = driver.read_text()
    responses = [pathlib.Path(path) for path in json.loads((root / "query-outputs.json").read_text())]
    response = next(path for path in responses
                    if any(row["class"] == "observed" for row in json.loads(path.read_text())["entries"]))
    pristine = response.read_bytes()
    data = json.loads(pristine)
    report_path = directory / "report.json"
    report_bytes = report_path.read_bytes()
    report = json.loads(report_bytes)
    digest = json.loads((root / "census.json.summary.json").read_text())["report_sha256"]
    observed_index = next(i for i, row in enumerate(data["entries"]) if row["class"] == "observed")
    env = dict(os.environ, LEAN_PATH=str(root), LEAN_NUM_THREADS="1")
    outcomes = []

    def rejected(label, expected, *, text=original, transport=None, driver_text=original_driver,
                 report_data=None):
        if only is not None and label not in only:
            return
        output = directory / (label + ".json")
        for module, contents in text.items():
            write_module(root, module, contents)
        driver.write_text(driver_text.replace(string(str(root / "census.json")), string(str(output))))
        if transport is not None:
            response.write_text(json.dumps(transport) + "\n")
        if report_data is not None:
            report_path.write_text(json.dumps(report_data) + "\n")
        try:
            run(["lake", "env", "lean", "-DmaxRecDepth=100000", "-DmaxHeartbeats=0",
                 "-R", str(root), str(driver)], directory / label, "process", cwd=repository, env=env)
        except RuntimeError:
            log = (directory / label / "process.log").read_text()
            assert expected in log, label + ": " + log
            assert not output.exists(), "rejected manifest produced an artifact"
            outcomes.append({"name": label, "diagnostic": expected, "status": "rejected"})
        else:
            raise AssertionError(label + " was accepted")
        finally:
            for module, contents in original.items():
                write_module(root, module, contents)
            driver.write_text(original_driver)
            response.write_bytes(pristine)
            report_path.write_bytes(report_bytes)

    def source_for(transport):
        rows = [row for path in responses
                for row in (transport if path == response else json.loads(path.read_text()))["entries"]]
        return dict(bucket_sources(rows, frozen_keys(report)), **{"CensusRun.Root":
            manifest_source(rows, frozen_keys(report), report["source_commit"], digest, "CensusRun.Root")})

    rejected("manifestDetachedFromRows", "component=manifest_keys",
             text=root_change(lambda text: text.replace("keys := CensusRun.manifestKeys", "keys := []", 1)))
    deleted = copy.deepcopy(data)
    deleted["entries"].pop(observed_index)
    rejected("deletedManifestRow", "IE-C034", text=source_for(deleted), transport=deleted)
    duplicated = copy.deepcopy(data)
    other = copy.deepcopy(duplicated["entries"][observed_index])
    other["theorem_name"] = ["str", ["anonymous"], "DifferentName"]
    duplicated["entries"].append(other)
    rejected("duplicateIdDifferentName", "IE-C035", transport=duplicated)
    malformed_report = copy.deepcopy(report)
    next(node for node in malformed_report["nodes"] if node["declarations"])["declarations"][0][
        "statement_id"] = "sha256:" + "0" * 63
    rejected("publisherInventoryDuplicateBeforeMalformedReport", "IE-C035",
             transport=duplicated, report_data=malformed_report)
    wrong_nat = bucket_change(lambda text: re.sub(r"(CensusRun.Bucket0.manifestKeys.chunk0 : Nat := )(0x[0-9a-f]+)",
                       lambda m: m[1] + hex(int(m[2], 0) + 1), text, count=1), source_for(deleted))
    rejected("publisherNatBeforeMissingRow", "component=statement_id_nat",
             text=wrong_nat, transport=deleted)
    # Both 0 and 1 have valid distinct wire strings. Binding both to Nat 1 fails.
    rejected("sameNatDifferentWireRejected", "component=statement_id_nat",
             text=bucket_change(lambda text: re.sub(r"(CensusRun.Bucket0.manifestKeys.chunk0 : Nat := )(0x[0-9a-f]+)",
                         lambda m: m[1] + hex(int(m[2], 0) + 1), text, count=1)))
    rejected("idPlacedInWrongBucket", "component=bucket_prefix",
             text=bucket_change(lambda text: re.sub(r"(CensusRun.Bucket0.manifestKeys.chunk0 : Nat := )(0x[0-9a-f]+)",
                         lambda m: m[1] + hex(int(m[2], 0) + 2 ** 248), text, count=1)))
    for label, wire in [
            ("uppercaseIdentity", "sha256:" + "A" * 64),
            ("shortIdentity", "sha256:" + "0" * 63),
            ("longIdentity", "sha256:" + "0" * 65),
            ("idAtOrAbove256Bits", "sha256:" + format(2 ** 256, "x")),
            ("missingPrefixIdentity", "0" * 64),
            ("signedIdentity", "sha256:+" + "0" * 63),
            ("whitespaceIdentity", "sha256:" + "0" * 64 + " ")]:
        malformed = copy.deepcopy(data)
        malformed["entries"][observed_index]["statement_id"] = wire
        rejected(label, "component=statement_id_format", transport=malformed)
    reflexive = root_change(lambda text: re.sub(
        r"(def CensusRun.reportKeys : List Nat := )[^\n]+", r"\1CensusRun.manifestKeys", text))
    rejected("reflexiveReportRejected", "component=report_keys_binding", text=reflexive)
    rejected("reflexiveReportNameRejected", "component=report_keys_binding", driver_text=original_driver.replace(
        "report_keys CensusRun.reportKeys", "report_keys CensusRun.manifestKeys"))
    rejected("wrongChunkArity", "component=report_keys_binding", text=bucket_change(lambda text: re.sub(
        r"decodeIds (\d+) CensusRun.Bucket0.reportKeys.chunk0",
        lambda m: f"decodeIds {int(m[1]) - 1} CensusRun.Bucket0.reportKeys.chunk0", text, count=1)))
    relabelled = copy.deepcopy(data)
    certified = next(row for path in responses for row in json.loads(path.read_text())["entries"]
                     if row["class"] != "observed")
    relabelled["entries"][observed_index]["class"] = certified["class"]
    relabelled["entries"][observed_index]["payload"] = certified["payload"]
    rejected("observedRelabelledCertified", "query receipt: edited", transport=relabelled)
    rejected("staleManifestHead", "component=head",
             text=root_change(lambda text: text.replace('headSha := "fixture-head"', 'headSha := "stale"', 1)))
    rejected("wrongManifestDigest", "component=report_sha256",
             text=root_change(lambda text: text.replace('reportSha256 := ' + string(digest), 'reportSha256 := "wrong"', 1)))
    artifact = json.loads((root / "census.json").read_text())
    assert any(row["statement_id"] == "sha256:" + "0" * 64 for row in artifact["rows"])
    outcomes.append({"name": "leadingZeroIdentity", "status": "preserved"})
    outcomes.append({"name": "noncomputableDataBound", "status": "accepted"})
    rejected("chunkMovedBetweenSides", "component=report_keys_binding", text=bucket_change(lambda text: re.sub(
        r"decodeIds (\d+) CensusRun.Bucket0.reportKeys.chunk0", r"decodeIds \1 CensusRun.Bucket0.manifestKeys.chunk0", text)))
    rejected("chunkDuplicatedBetweenSides", "component=report_keys_binding", text=bucket_change(lambda text: re.sub(
        r"decodeIds (\d+) CensusRun.Bucket0.reportKeys.chunk0",
        r"decodeIds \1 CensusRun.Bucket0.reportKeys.chunk0, decodeIds \1 CensusRun.Bucket0.manifestKeys.chunk0", text)))
    (directory / "negative-fixtures.json").write_text(json.dumps(outcomes, indent=2) + "\n")
    return outcomes


# Merged whole-stream query fixtures.
"""Real olean negatives for the streaming ownership and scope boundary."""

import json
import os
import pathlib
import shutil
import subprocess
import sys

from phases import enumerate_domain, external_graph, read, write
from resources import run
from streaming import enumerate_oleans, freshness

PREFIX = "LeanInformationAudit.Tests.Census.Query."
COMMAND = "LeanInformationAudit.Census.Command"


def name_key(text):
    result = "n0"
    for part in text.split("."):
        result = f"ns({result},{len(part.encode('utf-8'))}:{part})"
    return result


def key(module, declaration, number=0):
    return [PREFIX + module, name_key(PREFIX + declaration), "sha256:" + format(number, "064x")]


def lean_env(repository):
    env = json.loads(subprocess.check_output(["lake", "env", sys.executable, "-c",
        "import os,json;print(json.dumps(dict(os.environ)))"], cwd=repository))
    env["LEAN_NUM_THREADS"] = "1"
    env["LEAN_SRC_PATH"] = str(repository / "tools/lean-inspector") + os.pathsep + str(repository)
    return env


def lean(repository, directory, program, args, label, env):
    binary = shutil.which("lean", path=env["PATH"])
    if program in ("scan.lean", "membership.lean"):
        from native import build
        native = build(repository, program, env)
        result = run([str(native), *map(str, args)], directory, label, cwd=repository, env=env,
                     budget_gb=1 if program == "scan.lean" else 0.5)
        if program == "scan.lean":
            from extraction import detached_records
            path = pathlib.Path(args[2])
            temporary = path.with_suffix(".finished")
            with path.open() as source, temporary.open("wb") as out:
                from streaming import canonical
                for row in detached_records(source, lambda module: "tools/lean-inspector/" +
                        module.replace(".", "/") + ".lean"):
                    out.write(canonical(row))
            os.replace(temporary, path)
            from extraction import add_collision_identities
            add_collision_identities(repository, path, read(args[0]), pathlib.Path(args[1]),
                lambda module: "tools/lean-inspector/" + module.replace(".", "/") + ".lean", env)
        return result
    return run([binary, "-DmaxRecDepth=100000", "-DmaxHeartbeats=0", "--run",
                str(repository / "tools/lean-inspector/Census" / program), *map(str, args)],
               directory, label, cwd=repository, env=env)


def prepare(repository, directory):
    directory.mkdir(parents=True, exist_ok=True)
    env = lean_env(repository)
    enumerate_domain(repository, directory)
    keys = [key("StreamingTarget", "StreamingTarget.target"),
            key("DuplicateLeft", "shared", 1), key("DuplicateRight", "shared", 2),
            key("StatementLeft", "statement_shared", 3), key("StatementRight", "statement_shared", 4)]
    write(directory / "request.json", {"keys": keys})
    lean(repository, directory, "scan.lean", [directory / "manifest.json", directory / "request.json",
                                            directory / "index.jsonl"], "fixture_index", env)
    write(directory / "membership-request.json", {})
    # The same compiler metadata resolver used by the production pipeline.
    old = os.environ.copy()
    try:
        os.environ.update(env)
        external_graph(directory)
    finally:
        os.environ.clear()
        os.environ.update(old)
    write(directory / "external.json", read(directory / "membership-request.json")["external_graph"])


def membership_case(repository, directory, label, roots, keys, discovery=None):
    request = {"keys": keys, "roots": [["Fixture.Root", roots]],
        "assignment": {row[0]: "Fixture.Root" for row in keys},
        "discovery_roots": discovery if discovery is not None else [PREFIX + "StreamingTarget", COMMAND],
        "external_graph": read(directory / "external.json")}
    input_path, output_path = directory / (label + ".input.json"), directory / (label + ".json")
    write(input_path, request)
    lean(repository, directory, "membership.lean", [directory / "index.jsonl", input_path, output_path],
         label, lean_env(repository))
    result = read(output_path)
    result["rows"] = [json.loads(line) for line in pathlib.Path(str(output_path) + ".rows.jsonl").open()]
    result["scopes"] = [[root, [result["module_names"][i] for i in indices]] for root, indices in result["scopes"]]
    from incremental import BATCH_KEY_BOUND, BATCH_MODULE_BOUND
    result["batch_module_bound"] = BATCH_MODULE_BOUND
    result["batch_key_bound"] = BATCH_KEY_BOUND
    # This small fixture view also serves the independent candidate command.
    write(output_path, result)
    return result


def truth_export_identity(repository, directory):
    identity = directory / "identity.json"
    driver = directory / "Identity.lean"
    driver.write_text("import LeanInformationAudit.Census.Report\n" +
        "#eval IO.FS.writeFile " + json.dumps(str(identity)) +
        " LeanInformationAudit.DispositionCensus.truthExportIdentity.compress\n")
    run(["lake", "env", "lean", str(driver)], directory, "identity", cwd=repository, env=lean_env(repository))
    return read(identity)


def validate_control(repository, directory):
    import hashlib
    env = lean_env(repository)
    identity = truth_export_identity(repository, directory)
    target = key("StreamingTarget", "StreamingTarget.target")
    report = dict(identity, source_commit="fixture-head", nodes=[{
        "repo_path": target[0].replace(".", "/") + ".lean", "freeze_status": "frozen",
        "declarations": [{"kind": "theorem", "declaration_name_key": target[1], "statement_id": target[2]}]}])
    report_path = directory / "control-report.json"
    write(report_path, report)
    request = directory / "control-request.json"
    write(request, {"head": "fixture-head", "keys": [target], "report": str(report_path),
                    "report_sha256": "sha256:" + hashlib.sha256(report_path.read_bytes()).hexdigest()})
    output = directory / "control-candidate.json"
    driver = directory / "Control.lean"
    driver.write_text("import " + COMMAND + "\nimport " + PREFIX + "StreamingOutside\n" +
        "#census_validate " + json.dumps(str(request)) + " using " +
        json.dumps(str(directory / "inside_scope.json")) + " output " + json.dumps(str(output)) + "\n")
    run(["lake", "env", "lean", "-DmaxRecDepth=100000", "-DmaxHeartbeats=0", str(driver)],
        directory, "candidate_control", cwd=repository, env=env)
    rows = read(output)["entries"]
    assert len(rows) == 1 and rows[0]["class"] == "unreachable", "streamCandidateValidationControl"
    return {"name": "single_environment_candidate_control", "status": "passed", "certified": 1}


def check_case(repository, directory, case):
    target = key("StreamingTarget", "StreamingTarget.target")
    if case == "ownership_collision":
        keys = [key("DuplicateLeft", "shared", 1), key("DuplicateRight", "shared", 2)]
        result = membership_case(repository, directory, case, [row[0] for row in keys] + [COMMAND], keys)
        assert len(result["errors"]) == 2 and all("IE-C035" in e["error"] for e in result["errors"]), "streamOwnershipCollision"
        assert all(not row["payload"]["query_completed"] for row in result["rows"]), "streamOwnershipCollision"
    elif case == "statement_collision":
        keys = []
        for line in (directory / "index.jsonl").open():
            row = json.loads(line)
            if row["module"] in [PREFIX + "StatementLeft", PREFIX + "StatementRight"]:
                for owner in row["owners"]:
                    keys.append([row["module"], name_key(PREFIX + "statement_shared"), owner["statement_id"]])
        assert len(keys) == 2, "streamStatementCollisionPositive"
        result = membership_case(repository, directory, case, [k[0] for k in keys] + [COMMAND], keys)
        assert not result["errors"] and len(result["rows"]) == 2, "streamStatementCollisionPositive"
        assert all(c["resolved_by_statement"] for c in result["collisions"]), "streamStatementCollisionPositive"
        assert all(r["payload"]["query_completed"] for r in result["rows"]), "streamStatementCollisionPositive"
    elif case == "unclassifiable_named_key":
        result = membership_case(repository, directory, case, [PREFIX + "StreamingUnknown", COMMAND], [target])
        assert any("unclassifiable_named_key" in e["error"] for e in result["errors"]), "streamUnclassifiableNamedKey"
        assert not result["candidate_keys"] and not result["rows"][0]["payload"]["query_completed"], "streamUnclassifiableNamedKey"
    elif case == "out_of_scope":
        result = membership_case(repository, directory, case, [target[0], COMMAND], [target])
        assert not result["candidate_keys"] and not result["errors"], "streamOutOfScopeEvidence"
        assert result["rows"][0]["payload"]["query_completed"], "streamOutOfScopeEvidence"
        control = membership_case(repository, directory, "inside_scope", [PREFIX + "StreamingOutside", COMMAND], [target])
        assert control["candidate_keys"] == [target] and not control["errors"], "streamInsideScopeControl"
    elif case == "missing_olean":
        folder = directory / "missing"
        folder.mkdir(exist_ok=True)
        try:
            enumerate_oleans(folder, {"Fixture.Missing": "Fixture/Missing.lean"})
        except ValueError as error:
            assert "IE-C044 missing olean" in str(error), "streamMissingOlean"
        else:
            raise AssertionError("streamMissingOlean")
    elif case == "stale_olean":
        folder = directory / "stale"
        folder.mkdir(exist_ok=True)
        source, olean = folder / "Fresh.lean", folder / ".lake/build/lib/lean/Fresh.olean"
        env = lean_env(repository)
        (folder / "lean-toolchain").write_bytes((repository / "lean-toolchain").read_bytes())
        (folder / "lakefile.toml").write_text('name = "census_stale_fixture"\ndefaultTargets = ["Fresh"]\n[[lean_lib]]\nname = "Fresh"\n')
        (folder / "Makefile").write_text("lean:\n\tlake build\n")
        source.write_text("theorem fresh : True := True.intro\n")
        run(["make", "lean"], folder, "valid", cwd=folder, env=env, budget_gb=None)
        original = olean.read_bytes()
        source.write_text('def fresh : Nat := "edited without rebuilding"\n')
        try:
            freshness(lambda command, label: run(command, folder, label, cwd=folder, env=env, budget_gb=None))
        except RuntimeError:
            assert "error:" in (folder / "lake_freshness.log").read_text(), "streamFreshnessGate"
        else:
            raise AssertionError("streamFreshnessGate: stale olean accepted after edited source failed Lake")
        assert not olean.exists() or olean.read_bytes() == original, "streamFreshnessGate"
    else:
        raise ValueError(case)
    return {"name": case, "status": "passed"}


def check_manifest_negatives(repository, directory):
    # The old per-partition transport fixtures are retired with that transport.
    return [check_case(repository, directory, case) for case in
            ("stale_olean", "missing_olean", "ownership_collision", "statement_collision",
             "unclassifiable_named_key", "out_of_scope")]


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--directory", type=pathlib.Path, required=True)
    parser.add_argument("--case", required=True)
    options = parser.parse_args()
    repository = pathlib.Path(__file__).resolve().parents[3]
    print(check_case(repository, options.directory, options.case))
