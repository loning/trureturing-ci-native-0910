"""Exercise multi-chunk binding against independent synthetic wire authorities."""

import json
import os
import re

from emission import manifest_source, name, string, write_module
from resources import run


def check_chunks(repository, directory):
    root = directory / "chunks"
    rows = [{"theorem_name": ["str", ["anonymous"], "T"],
             "statement_id": "sha256:" + format(n, "064x")} for n in range(205)]
    keys = [("Fixture", "ns(n0,1:T)", row["statement_id"]) for row in rows]
    original = manifest_source(rows, keys, "fixture-head", "digest", "CensusRun.Root")
    wire = "#[" + ",\n".join(
        f"StatementKey.mk {name(row['theorem_name'])} {string(row['statement_id'])}" for row in rows) + "]"
    source = write_module(root, "CensusRun.Root", original)
    driver = write_module(root, "ChunkBinding", "import LeanInformationAudit.Census.Publish\n"
        "open Lean Elab Command LeanInformationAudit\n"
        f"def expectedRows : Array StatementKey := {wire}\n"
        "run_cmd do\n"
        f"  let env <- CensusProjection.elaborateFinalSource (<- IO.FS.readFile {string(str(source))})\n"
        f"    {string(str(source))} `CensusRun.Root {{}}\n"
        "  liftTermElabM <| CensusProjection.checkFinalEnvironment env\n"
        "  withEnv env <| liftTermElabM do\n"
        "    CensusManifest.bindEmittedManifest\n"
        "      { headSha := \"fixture-head\", reportSha256 := \"digest\", theorems := expectedRows }\n"
        "      `CensusRun.Root expectedRows `CensusRun.manifest `CensusRun.reportKeys\n")
    ordered = "decodeIds 100 CensusRun.reportKeys.chunk0, decodeIds 100 CensusRun.reportKeys.chunk1, decodeIds 5 CensusRun.reportKeys.chunk2"
    cases = [("noncomputableMultiChunkBound", original, True),
             ("chunkReorderedBetweenSides", original.replace(ordered,
                 "decodeIds 100 CensusRun.reportKeys.chunk1, decodeIds 100 CensusRun.reportKeys.chunk0, decodeIds 5 CensusRun.reportKeys.chunk2"), False),
             ("wrongChunkArity", original.replace("decodeIds 100 CensusRun.reportKeys.chunk0",
                 "decodeIds 99 CensusRun.reportKeys.chunk0"), False),
             ("chunkLiteralBinding", re.sub(r"(CensusRun.reportKeys.chunk0 : Nat := )(\d+)",
                 lambda m: m[1] + str(int(m[2]) + 1), original, count=1), False)]
    outcomes = []
    try:
        for label, text, accepted in cases:
            source.write_text(text)
            try:
                run(["lake", "env", "lean", "-R", str(root), str(driver)], root / label, "process",
                    cwd=repository, env=dict(os.environ, LEAN_PATH=str(root), LEAN_NUM_THREADS="1"))
            except RuntimeError:
                assert not accepted
                log = (root / label / "process.log").read_text()
                expected = "component=statement_id_nat" if label == "chunkLiteralBinding" else "component=report_keys_binding"
                assert expected in log, log
            else:
                assert accepted, label + " accepted"
            outcomes.append({"name": label, "status": "accepted" if accepted else "rejected",
                             "keys": 205, "chunks_per_side": 3})
    finally:
        source.write_text(original)
    (root / "fixtures.json").write_text(json.dumps(outcomes, indent=2) + "\n")
    return outcomes
