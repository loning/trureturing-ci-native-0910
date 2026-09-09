"""Cache input binding, full-key axiom joins and cross-tree artifact bytes."""

import json
import pathlib
import tempfile
import unittest

from negative_fixtures import name_key
from phases import write
from streaming import digest
from structure import axiom_readings, header, publish
from structure_graph import analyse
from structure_sources import file_digest, part_plan
from structure_store import Store


class StructureSourceTests(unittest.TestCase):
    def test_part_cache_binds_content_layout_reader_but_not_tree_path(self):
        hashes = [["A", "base", 3, "digest-a"], ["A", "server", 2, "digest-s"]]
        plan = lambda paths, values=hashes, reader="reader": part_plan(
            [["A", paths]], values, reader, pathlib.Path("cache"), "bodies")["A"]["address"]
        first = plan(["one/A.olean", "one/A.olean.server"])
        self.assertEqual(first, plan(["two/A.olean", "two/A.olean.server"]))
        self.assertNotEqual(first, plan(["one/A.olean"]))
        self.assertNotEqual(first, plan(["one/A.olean", "one/A.olean.server"], reader="changed"))
        self.assertNotEqual(first, plan(["one/A.olean", "one/A.olean.server"],
                                       [["A", "base", 3, "new"], hashes[1]]))

    def test_axiom_join_requires_name_identity_owner_and_source(self):
        with tempfile.TemporaryDirectory() as scratch:
            root = pathlib.Path(scratch)
            source, report = root / "A.lean", root / "report.json"
            source.write_text("fixture source")
            row = {"kind": "theorem", "name_key": name_key("a"), "statement_id": "id-a", "axioms": ["sorryAx"]}
            module = {"module": "A", "source_path": "A.lean", "source_sha256": file_digest(source), "declarations": [row]}
            write(report, {"modules": [module]})
            keys = [("A", name_key("a"), "id-a"), ("A", name_key("a"), "wrong-id"),
                    ("Wrong", name_key("a"), "id-a")]
            self.assertEqual(axiom_readings(root, report, keys), {(name_key("a"), "id-a"): ["sorryAx"]})
            source.write_text("changed")
            self.assertEqual(axiom_readings(root, report, keys), {})

    def test_cross_tree_bytes_equal_with_identical_semantic_inputs(self):
        with tempfile.TemporaryDirectory() as scratch:
            artifacts = []
            for tree in ["left", "right"]:
                root = pathlib.Path(scratch) / tree
                root.mkdir()
                key = ("A", name_key("a"), "id-a")
                write(root / "request.json", {"head": "same-head", "report_sha256": "same-report", "keys": [key]})
                (root / "census.json").write_bytes(b'{"counts":{"observed":1}}\n')
                store = Store(root / "store.sqlite")
                try:
                    store.module("A", [], "repository")
                    store.declaration("A", key[1], "theorem", [])
                    rows = root / "rows.jsonl"
                    analyse(store, [key], rows, [], cache=root / "cache", axioms={key[1:]: []})
                    inputs = {"olean_part_manifest_sha256": digest([]), "reader_fingerprint": "same-reader",
                              "ownership_fingerprint": store.snapshot()}
                    publish(root, header(root, inputs), rows)
                finally:
                    store.close()
                artifacts.append((root / "census-structure.json").read_bytes())
            self.assertEqual(*artifacts)
            self.assertEqual(json.loads(artifacts[0])["rows"][0]["status"], "complete")


if __name__ == "__main__":
    unittest.main()
