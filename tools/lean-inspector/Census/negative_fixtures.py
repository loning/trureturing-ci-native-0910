"""Manifest and row binding attacks through the actual data-only publisher."""

import copy
import json
import os
import pathlib
import re

from emission import manifest_source, string
from pipeline import frozen_keys
from resources import run


def check_manifest_negatives(repository, directory, only=None):
    root = directory / "first"
    source = root / "CensusRun/Root.lean"
    original = source.read_text()
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
        source.write_text(text)
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
            source.write_text(original)
            driver.write_text(original_driver)
            response.write_bytes(pristine)
            report_path.write_bytes(report_bytes)

    def source_for(transport):
        rows = [row for path in responses
                for row in (transport if path == response else json.loads(path.read_text()))["entries"]]
        return manifest_source(rows, frozen_keys(report), report["source_commit"], digest, "CensusRun.Root")

    rejected("manifestDetachedFromRows", "component=manifest_keys",
             text=original.replace("keys := CensusRun.manifestKeys", "keys := []", 1))
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
    wrong_nat = re.sub(r"(CensusRun.manifestKeys.chunk0 : Nat := )(0x[0-9a-f]+)",
                       lambda m: m[1] + hex(int(m[2], 0) + 1), source_for(deleted), count=1)
    rejected("publisherNatBeforeMissingRow", "component=statement_id_nat",
             text=wrong_nat, transport=deleted)
    # Both 0 and 1 have valid distinct wire strings. Binding both to Nat 1 fails.
    rejected("sameNatDifferentWireRejected", "component=statement_id_nat",
             text=re.sub(r"(CensusRun.manifestKeys.chunk0 : Nat := )(0x[0-9a-f]+)",
                         lambda m: m[1] + hex(int(m[2], 0) + 1), original, count=1))
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
    start = original.index("noncomputable def CensusRun.reportKeys.")
    reflexive = original[:start] + (
        "noncomputable def CensusRun.reportKeys : List Nat := CensusRun.manifest.keys\n")
    rejected("reflexiveReportRejected", "component=report_keys_binding", text=reflexive)
    rejected("reflexiveReportNameRejected", "component=report_keys_binding", driver_text=original_driver.replace(
        "report_keys CensusRun.reportKeys", "report_keys CensusRun.manifestKeys"))
    rejected("wrongChunkArity", "component=report_keys_binding", text=re.sub(
        r"decodeIds (\d+) CensusRun.reportKeys.chunk0",
        lambda m: f"decodeIds {int(m[1]) - 1} CensusRun.reportKeys.chunk0", original, count=1))
    relabelled = copy.deepcopy(data)
    certified = next(row for path in responses for row in json.loads(path.read_text())["entries"]
                     if row["class"] != "observed")
    relabelled["entries"][observed_index]["class"] = certified["class"]
    relabelled["entries"][observed_index]["payload"] = certified["payload"]
    rejected("observedRelabelledCertified", "query receipt: edited", transport=relabelled)
    rejected("staleManifestHead", "component=head",
             text=original.replace('headSha := "fixture-head"', 'headSha := "stale"', 1))
    rejected("wrongManifestDigest", "component=report_sha256",
             text=original.replace('reportSha256 := ' + string(digest), 'reportSha256 := "wrong"', 1))
    artifact = json.loads((root / "census.json").read_text())
    assert any(row["statement_id"] == "sha256:" + "0" * 64 for row in artifact["rows"])
    outcomes.append({"name": "leadingZeroIdentity", "status": "preserved"})
    outcomes.append({"name": "noncomputableDataBound", "status": "accepted"})
    rejected("chunkMovedBetweenSides", "component=report_keys_binding", text=re.sub(
        r"decodeIds (\d+) CensusRun.reportKeys.chunk0", r"decodeIds \1 CensusRun.manifestKeys.chunk0", original))
    rejected("chunkDuplicatedBetweenSides", "component=report_keys_binding", text=re.sub(
        r"decodeIds (\d+) CensusRun.reportKeys.chunk0",
        r"decodeIds \1 CensusRun.reportKeys.chunk0, decodeIds \1 CensusRun.manifestKeys.chunk0", original))
    (directory / "negative-fixtures.json").write_text(json.dumps(outcomes, indent=2) + "\n")
    return outcomes
