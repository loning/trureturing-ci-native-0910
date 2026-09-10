"""Emit the independent data-only Lean manifest from two separate authorities."""

import argparse
import hashlib
import json
import pathlib

import sys

if __package__ in (None, ""):
    sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))

from Certificate.emission import write_manifest, string, write_module
from pipeline import frozen_keys
from Certificate.handoff import read as read_handoff


def emit(directory, report_path, census_path, receipt_path, prefix):
    report_bytes = report_path.read_bytes()
    report = json.loads(report_bytes)
    head = report["source_commit"]
    digest = "sha256:" + hashlib.sha256(report_bytes).hexdigest()
    try:
        all_keys = frozen_keys(report)
    except ValueError as error:
        raise ValueError("IE-C044 report: " + str(error)) from error
    keys = [key for key in all_keys if key[0] == prefix or key[0].startswith(prefix + ".")]
    rows, receipt_digest = read_handoff(census_path, receipt_path, digest, head)
    path = write_manifest(directory, rows, keys, head, digest, "CensusRun.Root")
    driver = ("import LeanInformationAudit.Census.Publish\n"
               f"#disposition_census projection root CensusRun.Root source {string(str(path))} "
               f"report {string(str(report_path))}\n"
               f"  head {string(head)} report_sha256 {string(digest)}\n"
               f"  prefix {string(prefix)} manifest CensusRun.manifest report_keys CensusRun.reportKeys\n"
               f"  census {string(str(census_path))} receipt {string(str(receipt_path))} "
               f"receipt_digest {string(receipt_digest)} certificate CensusRun.accountingCertificate "
               f"output {string(str(directory / 'publication.json'))}\n")
    write_module(directory, "CensusPublish.Root", driver)
    return path


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--directory", required=True, type=pathlib.Path)
    parser.add_argument("--report", required=True, type=pathlib.Path)
    parser.add_argument("--census", required=True, type=pathlib.Path)
    parser.add_argument("--receipt", required=True, type=pathlib.Path)
    parser.add_argument("--prefix", required=True)
    options = parser.parse_args()
    emit(options.directory, options.report, options.census, options.receipt, options.prefix)
