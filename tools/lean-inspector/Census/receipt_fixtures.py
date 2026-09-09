"""Adversarial transport fixtures, exercised through the Lean publisher."""

import json
import os
import pathlib
import re

from emission import string
from resources import run


def check_receipts(repository, directory, report_path):
    root = directory / "first"
    source = root / "CensusRun/Bucket0.lean"
    original = source.read_text()
    driver = root / "CensusPublish/Root.lean"
    original_driver = driver.read_text()
    manifest = root / "query-outputs.json"
    responses = json.loads(manifest.read_text())
    response = pathlib.Path(responses[0])
    receipt = pathlib.Path(str(response) + ".receipt.json")
    env = dict(os.environ, LEAN_PATH=str(root), LEAN_NUM_THREADS="1")
    outcomes = []

    def rejected(label, expected, text=None):
        output = directory / (label + ".json")
        source.write_text(text or original)
        driver.write_text(original_driver.replace(string(str(root / "census.json")), string(str(output))))
        try:
            run(["lake", "env", "lean", "-R", str(root), str(driver)],
                directory / label, "process", cwd=repository, env=env)
        except RuntimeError:
            log = (directory / label / "process.log").read_text()
            assert expected in log, log
            assert not output.exists(), "rejected receipt produced an artifact"
            outcomes.append(label)
        else:
            raise AssertionError(label + " was accepted")
        finally:
            source.write_text(original)
            driver.write_text(original_driver)

    receipt_bytes = receipt.read_bytes()
    response_bytes = response.read_bytes()
    receipt.unlink()
    try:
        rejected("missing-query-receipt", "query receipt")
    finally:
        receipt.write_bytes(receipt_bytes)
    response.unlink()
    try:
        rejected("missing-query-transport", "query receipt")
    finally:
        response.write_bytes(response_bytes)
    edited = json.loads(response_bytes)
    observed = next(entry for entry in edited["entries"] if entry["class"] == "observed")
    observed["payload"]["note"] = "Edited after query execution."
    response.write_text(json.dumps(edited) + "\n")
    try:
        rejected("edited-query-transport", "query receipt")
    finally:
        response.write_bytes(response_bytes)
    stale = json.loads(receipt_bytes)
    stale["report_sha256"] = "sha256:" + "0" * 64
    receipt.write_text(json.dumps(stale))
    try:
        rejected("stale-query-receipt", "query receipt")
    finally:
        receipt.write_bytes(receipt_bytes)
    original_manifest = manifest.read_bytes()
    manifest.write_bytes((directory / "second/query-outputs.json").read_bytes())
    try:
        rejected("swapped-query-receipt", "query receipt")
    finally:
        manifest.write_bytes(original_manifest)
    edited_inventory = re.sub(r"(CensusRun.Bucket0.manifestKeys.chunk0 : Nat := )(0x[0-9a-f]+)",
                              lambda match: match[1] + hex(int(match[2], 0) + 99), original, count=1)
    assert edited_inventory != original
    rejected("edited-inventory-row", "component=statement_id_nat", edited_inventory)

    manifest.write_text("[]\n")
    try:
        rejected("invented-consistent-scope-and-completion", "query receipt")
    finally:
        manifest.write_bytes(original_manifest)
    return outcomes
