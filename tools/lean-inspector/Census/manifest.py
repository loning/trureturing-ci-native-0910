"""Emit the independent data-only Lean manifest from two separate authorities."""

import argparse
import hashlib
import json
import pathlib

from emission import manifest_source, string, write_module
from pipeline import frozen_keys


def emit(directory, report_path, receipts_path, prefix):
    report_bytes = report_path.read_bytes()
    report = json.loads(report_bytes)
    head = report["source_commit"]
    digest = "sha256:" + hashlib.sha256(report_bytes).hexdigest()
    keys = [key for key in frozen_keys(report) if key[0] == prefix or key[0].startswith(prefix + ".")]
    rows = []
    for path in json.loads(receipts_path.read_text()):
        result = json.loads(pathlib.Path(path).read_text())
        rows.extend({field: row[field] for field in ("theorem_name", "statement_id")}
                    for row in result["entries"])
    source = manifest_source(rows, keys, head, digest, "CensusRun.Root")
    source += (f"#disposition_census projection root CensusRun.Root report {string(str(report_path))}\n"
               f"  head {string(head)} report_sha256 {string(digest)}\n"
               f"  prefix {string(prefix)} manifest CensusRun.manifest report_keys CensusRun.reportKeys\n"
               f"  receipts {string(str(receipts_path))} certificate CensusRun.accountingCertificate "
               f"output {string(str(directory / 'census.json'))}\n")
    return write_module(directory, "CensusRun.Root", source)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--directory", required=True, type=pathlib.Path)
    parser.add_argument("--report", required=True, type=pathlib.Path)
    parser.add_argument("--receipts", required=True, type=pathlib.Path)
    parser.add_argument("--prefix", required=True)
    options = parser.parse_args()
    emit(options.directory, options.report, options.receipts, options.prefix)
