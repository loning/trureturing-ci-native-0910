"""Executable input and emission contracts for the run-local census producer."""

import importlib.util
import pathlib
import tempfile
import unittest

PROGRAM = pathlib.Path(__file__).with_name("pipeline.py")


class PipelineTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        spec = importlib.util.spec_from_file_location("census_pipeline", PROGRAM)
        cls.program = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(cls.program)

    def test_completion_cannot_be_supplied(self):
        for field in ("queryCompleted", "query_completed", "completed"):
            with self.subTest(field=field), self.assertRaises(ValueError):
                self.program.parse_request({"root": "Root", "report": "report.json", field: True})

    def test_duplicate_names_in_different_modules_keep_distinct_keys(self):
        nodes = [{"repo_path": f"D5/{module}.lean", "freeze_status": "frozen",
                  "declarations": [{"kind": "theorem", "declaration_name_key": "ns(n0,4:same)",
                                    "statement_id": identity}]}
                 for module, identity in (("A", "first-id"), ("B", "second-id"))]
        self.assertEqual(self.program.frozen_keys({"nodes": nodes}), [
            ("D5.A", "ns(n0,4:same)", "first-id"),
            ("D5.B", "ns(n0,4:same)", "second-id")])

    def test_repeated_statement_id_is_rejected(self):
        node = {"repo_path": "D5/A.lean", "freeze_status": "frozen", "declarations": [
            {"kind": "theorem", "declaration_name_key": "ns(n0,4:same)", "statement_id": "id"}]}
        with self.assertRaises(ValueError):
            self.program.frozen_keys({"nodes": [node, node]})

    def test_partition_preserves_every_key_and_emits_deterministically(self):
        keys = [("D5.A", "ns(n0,4:same)", f"id-{i}") for i in range(22001)]
        with tempfile.TemporaryDirectory() as first, tempfile.TemporaryDirectory() as second:
            for directory in (first, second):
                self.program.write_requests(pathlib.Path(directory), keys)
            def contents(directory):
                return {str(path.relative_to(directory)): path.read_bytes()
                        for path in pathlib.Path(directory).rglob("*.json")}
            left, right = contents(first), contents(second)
            self.assertEqual(left, right)
            self.assertEqual(sum(len(self.program.read_keys(data)) for data in left.values()), 22001)
            self.assertTrue(all(len(self.program.read_keys(data)) <= 100 for data in left.values()))
            self.assertTrue(all(len(list(path.iterdir())) <= 24
                                for path in pathlib.Path(first).rglob("*") if path.is_dir()))


if __name__ == "__main__":
    unittest.main()
