"""Manifest and row binding attacks through the actual data-only publisher."""

import copy
import json
import os
import pathlib

from emission import string
from resources import run


def check_manifest_negatives(repository, directory):
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
    observed_index = next(i for i, row in enumerate(data["entries"]) if row["class"] == "observed")
    env = dict(os.environ, LEAN_PATH=str(root), LEAN_NUM_THREADS="1")
    outcomes = []

    def rejected(label, expected, *, text=original, transport=None):
        output = directory / (label + ".json")
        source.write_text(text)
        driver.write_text(original_driver.replace(string(str(root / "census.json")), string(str(output))))
        if transport is not None:
            response.write_text(json.dumps(transport) + "\n")
        try:
            run(["lake", "env", "lean", "-DmaxRecDepth=100000", "-DmaxHeartbeats=0",
                 "-R", str(root), str(driver)], directory / label, "process", cwd=repository, env=env)
        except RuntimeError:
            log = (directory / label / "process.log").read_text()
            assert expected in log, log
            assert not output.exists(), "rejected manifest produced an artifact"
            outcomes.append({"name": label, "diagnostic": expected, "status": "rejected"})
        else:
            raise AssertionError(label + " was accepted")
        finally:
            source.write_text(original)
            driver.write_text(original_driver)
            response.write_bytes(pristine)

    rejected("manifestDetachedFromRows", "component=manifest_keys",
             text=original.replace('"idTheorem"', '"Detached"', 1))
    deleted = copy.deepcopy(data)
    deleted["entries"].pop(observed_index)
    rejected("deletedManifestRow", "IE-C034", transport=deleted)
    duplicated = copy.deepcopy(data)
    other = copy.deepcopy(duplicated["entries"][observed_index])
    other["theorem_name"] = ["str", ["anonymous"], "DifferentName"]
    duplicated["entries"].append(other)
    rejected("duplicateIdDifferentName", "IE-C035", transport=duplicated)
    # Both 0 and 1 have valid distinct wire strings. Binding both to Nat 1 fails.
    rejected("sameNatDifferentWireRejected", "component=statement_id_nat",
             text=original.replace(", 0)", ", 1)", 1))
    for label, wire in [
            ("uppercaseIdentity", "sha256:" + "A" * 64),
            ("shortIdentity", "sha256:" + "0" * 63),
            ("longIdentity", "sha256:" + "0" * 65),
            ("missingPrefixIdentity", "0" * 64),
            ("signedIdentity", "sha256:+" + "0" * 63),
            ("whitespaceIdentity", "sha256:" + "0" * 64 + " ")]:
        malformed = copy.deepcopy(data)
        malformed["entries"][observed_index]["statement_id"] = wire
        rejected(label, "component=statement_id_format", transport=malformed)
    start = original.index("noncomputable def CensusRun.reportKeys.")
    reflexive = original[:start] + (
        "noncomputable def CensusRun.reportKeys : List (Lean.Name × Nat) := CensusRun.manifest.keys\n")
    rejected("reflexiveReportRejected", "component=report_keys_binding", text=reflexive)
    relabelled = copy.deepcopy(data)
    certified = next(row for path in responses for row in json.loads(path.read_text())["entries"]
                     if row["class"] != "observed")
    relabelled["entries"][observed_index]["class"] = certified["class"]
    relabelled["entries"][observed_index]["payload"] = certified["payload"]
    rejected("observedRelabelledCertified", "query receipt: edited", transport=relabelled)
    rejected("staleManifestHead", "component=head",
             text=original.replace('headSha := "fixture-head"', 'headSha := "stale"', 1))
    digest = json.loads((root / "census.json.summary.json").read_text())["report_sha256"]
    rejected("wrongManifestDigest", "component=report_sha256",
             text=original.replace('reportSha256 := ' + string(digest), 'reportSha256 := "wrong"', 1))
    artifact = json.loads((root / "census.json").read_text())
    assert any(row["statement_id"] == "sha256:" + "0" * 64 for row in artifact["rows"])
    outcomes.append({"name": "leadingZeroIdentity", "status": "preserved"})
    outcomes.append({"name": "noncomputableDataBound", "status": "accepted"})
    rejected("chunkMovedBetweenSides", "component=report_keys_binding", text=original.replace(
        "List.flatten [CensusRun.reportKeys.chunk0]", "List.flatten [CensusRun.manifestKeys.chunk0]"))
    rejected("chunkDuplicatedBetweenSides", "component=report_keys_binding", text=original.replace(
        "List.flatten [CensusRun.reportKeys.chunk0]",
        "List.flatten [CensusRun.reportKeys.chunk0, CensusRun.manifestKeys.chunk0]"))
    (directory / "negative-fixtures.json").write_text(json.dumps(outcomes, indent=2) + "\n")
    return outcomes
