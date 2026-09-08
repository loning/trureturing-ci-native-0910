"""Resolved seed partitions and semantic report inputs are distinct contracts."""
import importlib.util
import json
import os
import subprocess
import sys
import tempfile
import unittest
from unittest import mock

from lean_seed_contract import INPUT, ROOT, REV, OTHER, PartitionFixture, write


class PartitionTests(PartitionFixture, unittest.TestCase):
    def semantic_input(self):
        with tempfile.TemporaryDirectory() as scratch:
            result = subprocess.run(["bash", "-euo", "pipefail", "-c", '''
REPOSITORY="$1"
TMP_ROOT="$2"
source "$3"
lean_cache_address
''', "semantic-input", str(self.root), scratch, str(INPUT)], text=True, capture_output=True)
        self.assertEqual(0, result.returncode, result.stderr)
        self.assertRegex(result.stdout, r"^[0-9a-f]{64} [0-9a-f]{64}\n$")
        return result.stdout.split()

    def test_retired_address_commands_are_rejected(self):
        for command in ["address", "dependency-address"]:
            with self.subTest(entrypoint="shell", command=command):
                result = self.run_input(command)
                self.assertEqual(2, result.returncode, result.stdout + result.stderr)
                self.assertEqual("", result.stdout)
        result = subprocess.run([sys.executable, str(ROOT / "tools/scripts/worktree/lean_cache.py"),
            "dependency-address", "--repository", str(self.root)], text=True, capture_output=True)
        self.assertEqual(2, result.returncode, result.stdout + result.stderr)
        self.assertEqual("", result.stdout)

    def test_partition_uses_exactly_resolved_mathlib(self):
        self.assertEqual(REV, self.partition())
        self.manifest["packages"][0]["inputRev"] = "another-tag"
        self.manifest["version"] = "metadata"
        self.save_manifest()
        write(self.root / "lean-toolchain", "different spelling\n")
        write(self.root / "D5/A.lean", "def a := 2\n")
        write(self.root / "lakefile.toml", 'keywords = ["different"]\n')
        self.assertEqual(REV, self.partition())
        self.manifest["packages"][0]["rev"] = OTHER
        self.save_manifest()
        self.assertEqual(OTHER, self.partition())

    def test_missing_duplicate_and_unresolved_mathlib_are_invalid(self):
        for packages in [[], [{"name": "mathlib", "inputRev": REV}],
                         [{"name": "mathlib", "rev": "v4.33.0"}],
                         [{"name": "mathlib", "rev": REV}] * 2]:
            self.manifest["packages"] = packages
            self.save_manifest()
            result = self.run_input("partition")
            self.assertEqual(2, result.returncode, result.stdout + result.stderr)
            self.assertEqual("", result.stdout)

    def test_actions_snapshots_share_partition_and_pr_cannot_save(self):
        def keys(run, attempt, event, ref, success="true"):
            result = self.run_input("keys", env={"GITHUB_RUN_ID": run, "GITHUB_RUN_ATTEMPT": attempt,
                "GITHUB_EVENT_NAME": event, "GITHUB_REF": ref, "STRATALINT_CHECK_SUCCEEDED": success})
            self.assertEqual(0, result.returncode, result.stderr)
            return json.loads(result.stdout)
        first = keys("12", "1", "push", "refs/heads/dev")
        self.manifest["packages"].append({"name": "other", "rev": OTHER})
        self.manifest["packages"][0]["inputRev"] = "another-tag"
        self.save_manifest()
        write(self.root / "lean-toolchain", "changed\n")
        write(self.root / "lakefile.toml", '[leanOptions]\nmaxRecDepth = 2000\n')
        write(self.root / "D5/A.lean", "def a := 2\n")
        second = keys("13", "2", "pull_request_target", "refs/heads/dev")
        self.assertTrue(first["save_allowed"])
        self.assertFalse(second["save_allowed"])
        self.assertFalse(keys("14", "1", "push", "refs/heads/dev", "false")["save_allowed"])
        self.manifest["packages"][0]["rev"] = OTHER
        self.save_manifest()
        upgraded = keys("15", "1", "push", "refs/heads/dev")
        self.assertEqual(first["release_prefix"], second["release_prefix"])
        self.assertNotEqual(first["release_prefix"], upgraded["release_prefix"])
        for layer in ["dependency", "project", "report"]:
            a, b = first[layer], second[layer]
            self.assertEqual(a["restore_prefix"], b["restore_prefix"])
            self.assertIn(REV, a["restore_prefix"])
            self.assertTrue(a["key"].endswith("12-1"))
            self.assertTrue(b["key"].endswith("13-2"))
            self.assertNotEqual(a["key"], b["key"])
            self.assertNotEqual(a["restore_prefix"], upgraded[layer]["restore_prefix"])

    def test_binary_platform_isolates_all_seed_layers(self):
        spec = importlib.util.spec_from_file_location("lean_cache", ROOT / "tools/scripts/worktree/lean_cache.py")
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        for system, machine, expected in [("Linux", "x86_64", "linux-x64"),
                                          ("Linux", "aarch64", "linux-arm64"),
                                          ("Darwin", "arm64", "darwin-arm64")]:
            with self.subTest(platform=expected), \
                    mock.patch.object(module.platform, "system", return_value=system), \
                    mock.patch.object(module.platform, "machine", return_value=machine), \
                    mock.patch.dict(os.environ, GITHUB_RUN_ID="12", GITHUB_RUN_ATTEMPT="1"):
                keys = module.actions_keys(self.root)
                self.assertEqual(f"{REV}/{expected}", keys["partition"])
                self.assertEqual(f"lean-cache-v2-{REV}-{expected}-", keys["release_prefix"])
                for layer in ["dependency", "project", "report"]:
                    prefix = f"lean-{layer}-v3-{REV}-{expected}-"
                    self.assertEqual(prefix, keys[layer]["restore_prefix"])
                    self.assertEqual(prefix + "12-1", keys[layer]["key"])

    def test_metadata_has_no_semantic_config_effect(self):
        before = self.semantic_input()
        self.manifest["version"] = "new-metadata"
        self.manifest["packages"][0]["inputRev"] = "same-resolved"
        self.save_manifest()
        write(self.root / "lakefile.toml", 'name = "renamed"\nkeywords = ["metadata"]\n[leanOptions]\nmaxRecDepth = 1000\n')
        self.assertEqual(before, self.semantic_input())
        write(self.root / "lakefile.toml", '[leanOptions]\nmaxRecDepth = 2000\n')
        changed = self.semantic_input()
        self.assertEqual(before[0], changed[0])
        self.assertNotEqual(before[1], changed[1])

    def test_source_changes_only_the_source_report_input(self):
        before = self.semantic_input()
        write(self.root / "D5/A.lean", "def a := 2\n")
        changed = self.semantic_input()
        self.assertNotEqual(before[0], changed[0])
        self.assertEqual(before[1], changed[1])


if __name__ == "__main__":
    unittest.main(verbosity=2)
