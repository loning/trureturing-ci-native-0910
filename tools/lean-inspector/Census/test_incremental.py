"""Content reuse and bounded validation are behavioral census contracts."""

import pathlib
import tempfile
import unittest


class IncrementalTests(unittest.TestCase):
    def test_stale_extraction_cache_reextracts_changed_olean_only(self):
        from incremental import extraction_plan, save_extraction
        with tempfile.TemporaryDirectory() as folder:
            cache = pathlib.Path(folder)
            modules = [["A", ["a"]], ["B", ["b"]]]
            hashes = [["A", "base", 10, "sha256:" + "a" * 64],
                      ["B", "base", 10, "sha256:" + "b" * 64]]
            first = extraction_plan(modules, hashes, cache, "source", "keys")
            self.assertEqual([m[0] for m in first["misses"]], ["A", "B"])
            for module in ("A", "B"):
                save_extraction(first, module, [{"module": module, "owners": []}])
            hashes[0][3] = "sha256:" + "c" * 64
            second = extraction_plan(modules, hashes, cache, "source", "keys")
            self.assertEqual([m[0] for m in second["misses"]], ["A"])
            self.assertEqual(second["hits"], ["B"])

    def test_extraction_cache_binds_frozen_name_universe_and_reader(self):
        from incremental import extraction_plan, save_extraction
        with tempfile.TemporaryDirectory() as folder:
            args = ([["A", ["a"]]], [["A", "base", 1, "sha256:" + "a" * 64]], pathlib.Path(folder))
            first = extraction_plan(*args, "reader", "keys")
            save_extraction(first, "A", [{"module": "A"}])
            self.assertEqual(extraction_plan(*args, "reader", "keys")["hits"], ["A"])
            self.assertEqual(extraction_plan(*args, "new-reader", "keys")["hits"], [])
            self.assertEqual(extraction_plan(*args, "reader", "new-keys")["hits"], [])

    def test_two_batches_respect_union_closure_bound(self):
        from incremental import candidate_batches
        graph = {"Init": [], "Command": ["Init"], "A": ["Init"], "B": ["Init"]}
        keys = [["A", "a", "id-a"], ["B", "b", "id-b"]]
        batches = candidate_batches(keys, {"A": ["A", "Command"], "B": ["B", "Command"]}, graph, 3)
        self.assertEqual(len(batches), 2)
        self.assertEqual([batch["keys"] for batch in batches], [[keys[0]], [keys[1]]])
        self.assertTrue(all(len(batch["modules"]) <= 3 for batch in batches))
        with self.assertRaisesRegex(ValueError, "IE-C044.*batch"):
            candidate_batches(keys, {"A": ["A", "Command"], "B": ["B", "Command"]}, graph, 2)

    def test_validation_cache_invalidates_only_changed_inputs(self):
        from incremental import validation_key
        args = (["A", "a", "id-a"], "owner-digest", [["Evidence", "digest"]], "lean", "query", "scope")
        baseline = validation_key(*args)
        for index in range(1, 6):
            changed = list(args)
            changed[index] = [["Evidence", "changed"]] if index == 2 else "changed"
            self.assertNotEqual(baseline, validation_key(*changed))
        self.assertEqual(baseline, validation_key(*args))

    def test_one_large_owner_is_split_by_key_bound(self):
        from incremental import candidate_batches
        keys = [["A", str(i), str(i)] for i in range(257)]
        batches = candidate_batches(keys, {"A": ["A"]}, {"A": []}, 1)
        self.assertEqual([len(batch["keys"]) for batch in batches], [128, 128, 1])
        self.assertEqual([key for batch in batches for key in batch["keys"]], keys)


if __name__ == "__main__":
    unittest.main()
