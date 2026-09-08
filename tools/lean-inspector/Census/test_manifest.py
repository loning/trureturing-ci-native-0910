"""Independent authorities for emitted kernel keys and report keys."""

import pathlib
import tempfile
import unittest

import emission


class ManifestTests(unittest.TestCase):
    def test_strict_statement_identity_codec(self):
        for value in (0, 1, 2 ** 256 - 1):
            wire = "sha256:" + format(value, "064x")
            self.assertEqual(emission.statement_nat(wire), value)
        for wire in ("0" * 64, "sha256:" + "0" * 63, "sha256:" + "0" * 65,
                     "sha256:" + "A" * 64, " sha256:" + "0" * 64,
                     "sha256:" + "0" * 64 + " ", "sha256:+" + "0" * 63):
            with self.subTest(wire=wire), self.assertRaisesRegex(ValueError, "statement_id_format"):
                emission.statement_nat(wire)

    def test_structured_name_decoder_preserves_constructor_identity(self):
        self.assertEqual(emission.parse_name_key("ns(n0,3:a.b)"), ["str", ["anonymous"], "a.b"])
        self.assertEqual(emission.parse_name_key("nn(ns(n0,1:A),3)"),
                         ["num", ["str", ["anonymous"], "A"], 3])
        self.assertNotEqual(emission.parse_name_key("nn(ns(n0,1:A),3)"),
                            emission.parse_name_key("ns(ns(n0,1:A),1:3)"))
        self.assertEqual(emission.parse_name_key("ns(n0,2:\u00e9)"), ["str", ["anonymous"], "\u00e9"])

    def test_report_keys_are_rendered_from_the_report(self):
        wire = "sha256:" + "0" * 64
        rows = [{"theorem_name": ["str", ["anonymous"], "Inventory"], "statement_id": wire}]
        report_keys = [("Fixture", "ns(n0,6:Report)", wire)]
        source = emission.manifest_source(rows, report_keys, "head", "digest", "Root")
        before, after = source.split("def CensusRun.reportKeys", 1)
        self.assertIn('"Inventory"', before)
        self.assertNotIn('"Report"', before)
        self.assertIn('"Report"', after)
        self.assertNotIn('"Inventory"', after)
        self.assertNotIn(wire, source)

    def test_manifest_literals_are_canonical_and_deterministic(self):
        keys = [("Fixture", f"ns(n0,1:{name})", "sha256:" + format(n, "064x"))
                for name, n in (("B", 2), ("A", 1))]
        rows = [{"theorem_name": emission.parse_name_key(key), "statement_id": wire}
                for _, key, wire in keys]
        first = emission.manifest_source(rows, keys, "head", "digest", "Root")
        self.assertEqual(first, emission.manifest_source(rows[::-1], keys[::-1], "head", "digest", "Root"))
        self.assertNotIn("CensusRun.Rows", first)
        self.assertNotIn("DispositionCensus", first)


if __name__ == "__main__":
    unittest.main()
