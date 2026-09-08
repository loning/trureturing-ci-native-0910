"""Adversarial transport fixtures, exercised through the Lean publisher."""

import json
import os
import pathlib

from emission import array, name, row, string
from resources import run


def check_receipts(repository, directory, report_path):
    root = directory / "first"
    source = root / "CensusRun/Root.lean"
    original = source.read_text()
    manifest = root / "query-outputs.json"
    responses = json.loads(manifest.read_text())
    response = pathlib.Path(responses[0])
    receipt = pathlib.Path(str(response) + ".receipt.json")
    env = dict(os.environ, LEAN_PATH=str(root), LEAN_NUM_THREADS="1")
    outcomes = []

    def rejected(label, expected, text=None):
        output = directory / (label + ".json")
        source.write_text((text or original).replace(string(str(root / "census.json")), string(str(output))))
        try:
            run(["lake", "env", "lean", "-R", str(root), str(source)],
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
    edited_inventory = original.replace("entries := ", "entries := ", 1)
    start = edited_inventory.index("entries := ") + len("entries := ")
    end = edited_inventory.index(" }\n", start)
    entries = edited_inventory[start:end]
    changed = ("(" + entries + ").map (fun entry => match entry with "
               "| .mk key (.observed value) => .mk key (.observed { value with note := \"edited inventory\" }) "
               "| other => other)")
    rejected("edited-inventory-row", "query receipt", edited_inventory[:start] + changed + edited_inventory[end:])

    observed = next(entry for path in responses for entry in json.loads(pathlib.Path(path).read_text())["entries"]
                    if entry["class"] == "observed")
    fake_root = ["str", ["anonymous"], "InventedQueryRoot"]
    observed["payload"]["root"] = fake_root
    observed["payload"]["candidates"] = []
    fake_scope = array([name(fake_root), name(observed["payload"]["owning_module"])])
    fake = ("import LeanInformationAudit.Census.Publish\nopen LeanInformationAudit\n"
            f"def inventedScope : ImportClosureScope := .mk {fake_scope} true\n"
            f"def invented : DispositionInventory := .mk \"fixture-head\" #[{row(observed, 'inventedScope')}]\n"
            f"def scopes : Array CensusProjection.Scope := #[.mk {name(fake_root)} inventedScope]\n")
    command = original[original.index("#disposition_census"):]
    fake += command.replace("inventory CensusRun.inventory", "inventory invented").replace(
        "scopes CensusRun.scopes", "scopes scopes")
    manifest.write_text("[]\n")
    try:
        rejected("invented-consistent-scope-and-completion", "query receipt", fake)
    finally:
        manifest.write_bytes(original_manifest)
    return outcomes
