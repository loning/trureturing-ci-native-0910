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
        for field in ("queryCompleted", "query_completed", "completed", "candidates"):
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

    def test_module_partitions_are_bounded_exhaustive_and_deterministic(self):
        modules = [f"D5.S3.Area.Subgroup.Module{i:04d}" for i in range(3687)]
        partitions = self.program.partition_modules(modules, 32)
        self.assertEqual(partitions, self.program.partition_modules(list(reversed(modules)), 32))
        self.assertEqual(sorted(module for _, group in partitions for module in group), modules)
        self.assertTrue(all(0 < len(group) <= 32 for _, group in partitions))

    def test_duplicate_declarations_have_isolated_query_environments(self):
        modules = ["D5.S0.Area.Left", "D5.S0.Area.Right", "D5.S0.Area.Other"]
        keys = [(modules[0], "same", "left"), (modules[1], "same", "right"),
                (modules[2], "other", "other")]
        partitions = self.program.partition_queries(modules, keys, 32)
        self.assertEqual(sorted(module for _, group in partitions for module in group), sorted(modules))
        self.assertIn((modules[0], [modules[0]]), partitions)
        self.assertIn((modules[1], [modules[1]]), partitions)

    def test_incomplete_partition_is_rejected(self):
        for result in ({}, {"head": "head", "entries": []},
                       {"head": "head", "entries": [], "query_completed": True}):
            with self.subTest(result=result), self.assertRaises(ValueError):
                self.program.validate_result(result, "head", [("D5.A", "key", "id")])

    def test_budget_failures_are_rejections(self):
        spec = importlib.util.spec_from_file_location("census_resources", PROGRAM.with_name("resources.py"))
        resources = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(resources)
        with self.assertRaisesRegex(resources.ResourceRejected, "free_memory"):
            resources.check_budget(29, 0, 8 * 1024 ** 3)
        with self.assertRaisesRegex(resources.ResourceRejected, "rss"):
            resources.check_budget(83, 8 * 1024 ** 3 + 1, 8 * 1024 ** 3)
        resources.check_budget(30, 8 * 1024 ** 3, 8 * 1024 ** 3)


if __name__ == "__main__":
    unittest.main()
