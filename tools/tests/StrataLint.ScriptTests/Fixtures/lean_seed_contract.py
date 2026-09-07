"""Behavior contracts. All transport is a private local fake; no GitHub writes."""
import hashlib
import importlib.util
import json
import os
import pathlib
import subprocess
import sys
import tempfile
import unittest
import zipfile
import concurrent.futures
import shutil

ROOT = pathlib.Path(__file__).resolve().parents[4]
INPUT = ROOT / "tools/scripts/worktree/lean-cache-input.sh"
DELTA = ROOT / "tools/lean-inspector/delta.py"
REV = "0123456789abcdef0123456789abcdef01234567"
OTHER = "f" * 40
PUBLISH = ROOT / "tools/scripts/worktree/lean-cache-publish.sh"


def write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(value, encoding="utf-8")


def digest(value):
    return hashlib.sha256(value).hexdigest()


class PartitionFixture:
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = pathlib.Path(self.temporary.name)
        self.manifest = {"packages": [{"name": "mathlib", "rev": REV, "inputRev": "v1"}]}
        self.save_manifest()
        write(self.root / "lean-toolchain", "leanprover/lean4:v4.33.0\n")
        write(self.root / "lakefile.toml", 'name = "fixture"\n[leanOptions]\nmaxRecDepth = 1000\n')
        write(self.root / "Trureturing.lean", "import D5.A\n")
        write(self.root / "D5/A.lean", "def a := 1\n")

    def save_manifest(self):
        write(self.root / "lake-manifest.json", json.dumps(self.manifest))

    def run_input(self, command, *extra, env=None):
        return subprocess.run(["bash", str(INPUT), command, "--repository", str(self.root), *extra],
                              text=True, capture_output=True, env={**os.environ, **(env or {})})

    def partition(self):
        result = self.run_input("partition")
        self.assertEqual(0, result.returncode, result.stderr)
        return result.stdout.strip()


class PartitionTests(PartitionFixture, unittest.TestCase):
    def test_legacy_dependency_address_keeps_digest_shape_and_partition_only(self):
        before = self.run_input("dependency-address")
        self.assertEqual(0, before.returncode, before.stderr)
        self.assertRegex(before.stdout, r"^[0-9a-f]{64}\n$")
        self.manifest["packages"][0]["inputRev"] = "new-requested-ref"
        self.save_manifest()
        write(self.root / "lean-toolchain", "metadata-spelling\n")
        write(self.root / "lakefile.toml", 'keywords = ["metadata"]\n')
        self.assertEqual(before.stdout, self.run_input("dependency-address").stdout)
        self.manifest["packages"][0]["rev"] = OTHER
        self.save_manifest()
        self.assertNotEqual(before.stdout, self.run_input("dependency-address").stdout)

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
        second = keys("13", "2", "pull_request_target", "refs/heads/dev")
        self.assertTrue(first["save_allowed"])
        self.assertFalse(second["save_allowed"])
        self.assertFalse(keys("14", "1", "push", "refs/heads/dev", "false")["save_allowed"])
        for layer in ["dependency", "project", "report"]:
            a, b = first[layer], second[layer]
            self.assertEqual(a["restore_prefix"], b["restore_prefix"])
            self.assertIn(REV, a["restore_prefix"])
            self.assertTrue(a["key"].endswith("12-1"))
            self.assertTrue(b["key"].endswith("13-2"))
            self.assertNotEqual(a["key"], b["key"])

    def test_metadata_has_no_semantic_config_effect(self):
        before = self.run_input("address")
        self.assertEqual(0, before.returncode, before.stderr)
        self.manifest["version"] = "new-metadata"
        self.manifest["packages"][0]["inputRev"] = "same-resolved"
        self.save_manifest()
        write(self.root / "lakefile.toml", 'name = "renamed"\nkeywords = ["metadata"]\n[leanOptions]\nmaxRecDepth = 1000\n')
        after = self.run_input("address")
        self.assertEqual(0, after.returncode, after.stderr)
        self.assertEqual(before.stdout, after.stdout)
        write(self.root / "lakefile.toml", '[leanOptions]\nmaxRecDepth = 2000\n')
        changed = self.run_input("address")
        self.assertEqual(0, changed.returncode, changed.stderr)
        self.assertNotEqual(before.stdout.split()[1], changed.stdout.split()[1])


class DeltaTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = pathlib.Path(self.temporary.name)
        self.cache = self.root / "cache"
        self.address = "a" * 64
        self.producer = "b" * 64
        self.config = "c" * 64
        self.entry = self.cache / self.address
        self.report = self.entry / "raw-lean-report.json"
        self.modules = []
        self.materials = {}
        for name, imports in [("A", []), ("B", ["A"]), ("C", ["B"]), ("D", [])]:
            write(self.root / (name + ".lean"), "def value := 1\n")
            self.modules.append({"module": name, "source_path": name + ".lean",
                "source_sha256": "sha256:" + digest((self.root / (name + ".lean")).read_bytes()),
                "imports": imports, "declarations": []})
        self.store()

    def store(self):
        write(self.report, json.dumps({"modules": self.modules, "schema": "stratalint-raw-lean-report-v2"}, sort_keys=True) + "\n")
        report_sha = digest(self.report.read_bytes())
        write(pathlib.Path(str(self.report) + ".sha256"), report_sha + "  raw-lean-report.json\n")
        write(pathlib.Path(str(self.report) + ".input.attestation"), "schema=stratalint-lean-report-input-attestation-v1\nrepository_input_sha256=" + "d"*64 + "\nproducer_sha256=" + self.producer + "\nreport_sha256=" + report_sha + "\n")
        write(pathlib.Path(str(self.report) + ".provenance.json"), json.dumps({
            "schema": "stratalint-lean-report-provenance-v1", "side": "candidate", "mode": "produced",
            "source_side": "candidate", "input_address": "sha256:" + self.address,
            "producer_sha256": self.producer, "repository_inspector_sha256": self.producer,
            "lean_sources_sha256": "e"*64, "lean_config_sha256": self.config, "report_sha256": report_sha}))
        with zipfile.ZipFile(str(self.report) + ".materials.zip", "w") as archive:
            for name, material in sorted(self.materials.items()):
                archive.writestr(name, material)

    def add_declaration_material(self):
        spec = importlib.util.spec_from_file_location("materials", DELTA.with_name("materials.py"))
        materials = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(materials)
        material = b"statement-v1(uparams=[],type=ec(ns(n0,3:Nat),[]),value=ei(ln(1)))"
        declaration = {"axioms": [], "include_in_statement": True, "kind": "def",
            "name": "value", "name_key": "ns(n0,5:value)",
            "type_sha256": materials.statement_address(material),
            "statement_id": materials.statement_address(materials.canonical_json({
                "declaration_name_key": "ns(n0,5:value)", "kind": "def", "module_path": "A.lean",
                "schema": "declaration-statement-v1", "statement_material": material.decode("utf-8")}))}
        self.modules[0]["declarations"] = [declaration]
        self.materials["sha256/" + declaration["type_sha256"][7:]] = material
        self.store()
        return declaration

    def plan(self, producer=None, config=None, extra=()):
        names = sorted(path.stem for path in self.root.glob("*.lean"))
        table = self.root / "modules.tsv"
        write(table, "".join(name + "\t" + name + ".lean\n" for name in names))
        plan = self.root / "plan.json"
        result = subprocess.run([sys.executable, str(DELTA), "plan", str(self.root), str(self.cache),
            self.address, producer or self.producer, producer or self.producer, config or self.config,
            str(table), str(plan), *extra], text=True, capture_output=True)
        self.assertEqual(0, result.returncode, result.stderr)
        return json.loads(plan.read_text())

    def test_exact_seed_enters_incremental_reuse(self):
        result = self.plan()
        self.assertEqual("reuse", result["status"])
        self.assertEqual([], result["recheck"])

    def test_source_changes_close_transitive_reverse_dependencies(self):
        write(self.root / "A.lean", "def value := 2\n")
        self.assertEqual(["A", "B", "C"], self.plan()["recheck"])

    def test_add_remove_preserves_unaffected_modules(self):
        (self.root / "A.lean").unlink()
        write(self.root / "E.lean", "def e := 3\n")
        result = self.plan()
        self.assertEqual(["A"], result["removed"])
        self.assertEqual(["E"], result["added"])
        self.assertEqual(["B", "C", "E"], result["recheck"])

    def test_semantics_change_reinspects_inside_producer(self):
        for result in [self.plan(producer="f"*64), self.plan(config="f"*64)]:
            self.assertEqual("delta", result["status"])
            self.assertEqual(["A", "B", "C", "D"], result["recheck"])
            self.assertTrue(result["semantic_changed"])

    def test_corrupt_materials_are_not_a_reuse_seed(self):
        write(pathlib.Path(str(self.report) + ".materials.zip"), "broken")
        self.assertEqual("fallback", self.plan()["status"])

    def test_nonempty_declaration_material_is_reused(self):
        self.add_declaration_material()
        result = self.plan()
        self.assertEqual("reuse", result["status"])
        self.assertEqual([], result["recheck"])

    def test_damaged_declaration_material_is_not_a_reuse_seed(self):
        declaration = self.add_declaration_material()
        self.materials["sha256/" + declaration["type_sha256"][7:]] += b"damaged"
        self.store()
        self.assertEqual("fallback", self.plan()["status"])

    def test_wrong_declaration_identity_is_not_a_reuse_seed(self):
        declaration = self.add_declaration_material()
        declaration["statement_id"] = "sha256:" + "f" * 64
        self.store()
        self.assertEqual("fallback", self.plan()["status"])

    def test_runtime_invalidation_is_internal_and_partition_mismatch_is_a_miss(self):
        seed = {"schema": "lean-report-seed-v1", "partition": REV + "/linux-x64",
            "runtime_sha256": "1"*64, "report_sha256": digest(self.report.read_bytes()),
            "materials_sha256": digest(pathlib.Path(str(self.report)+".materials.zip").read_bytes())}
        write(pathlib.Path(str(self.report)+".seed.json"), json.dumps(seed))
        options = ["--partition", seed["partition"], "--runtime-sha", "1"*64]
        self.assertEqual("reuse", self.plan(extra=options)["status"])
        options[-1] = "2"*64
        result = self.plan(extra=options)
        self.assertEqual(["A", "B", "C", "D"], result["recheck"])
        self.assertTrue(result["semantic_changed"])
        options[1] = OTHER + "/linux-x64"
        self.assertEqual("fallback", self.plan(extra=options)["status"])

    def test_legacy_logs_are_never_imported_as_production_evidence(self):
        logs = pathlib.Path(str(self.report)+".logs")
        logs.symlink_to(self.root / "absent")
        self.assertEqual("fallback", self.plan()["status"])


class TransportTests(PartitionFixture, unittest.TestCase):
    def setUp(self):
        super().setUp()
        self.remote = self.root / "remote"
        self.bin = self.root / "bin"
        self.bin.mkdir()
        self.remote.mkdir()
        write(self.root / ".lake/build/lib/lean/D5/A.olean", "locally-produced-olean")
        write(self.bin / "make", '#!/bin/sh\nprintf "%s\\n" "$*" >> "$FAKE_BUILD_LOG"\nexit "${FAKE_BUILD_EXIT:-0}"\n')
        write(self.bin / "gh", FAKE_GH)
        for path in self.bin.iterdir():
            path.chmod(0o755)

    def transport_environment(self, run="123", **extra):
        return {**os.environ, "PATH": str(self.bin) + os.pathsep + os.environ["PATH"],
            "HOME": str(self.root), "FAKE_BUILD_LOG": str(self.root / "build-runs"),
            "FAKE_REMOTE": str(self.remote), "GITHUB_SHA": "d" * 40, "GITHUB_RUN_ID": run,
            "GITHUB_RUN_ATTEMPT": "1", "GITHUB_EVENT_NAME": "schedule", "GITHUB_REF": "refs/heads/dev",
            "STRATALINT_CHECK_SUCCEEDED": "true", "STRATALINT_ACTIONS_CACHE_SEEDED": "", **extra}

    def transport(self, verb, run="123", arguments=(), **extra):
        return subprocess.run(["bash", str(PUBLISH), verb, "--repository", str(self.root), *arguments],
                              text=True, capture_output=True, env=self.transport_environment(run, **extra))

    def fetch_then_build(self, **extra):
        # Exercise the optional-fetch caller protocol under errexit. Workflow
        # execution itself is verified by a real integration run, not YAML tests.
        return subprocess.run(["bash", "-euo", "pipefail", "-c", '''
if ! "$1" fetch --allow-seed --repository "$2"; then
    printf '%s\\n' 'Release seed unavailable; continuing with the normal Lean build.'
fi
make -C "$2" lean
''', "optional-fetch", str(PUBLISH), str(self.root)], text=True, capture_output=True,
            env=self.transport_environment(**extra))

    def test_optional_fetch_miss_reaches_build_and_preserves_build_failure(self):
        for build_exit in (0, 19):
            with self.subTest(build_exit=build_exit):
                result = self.fetch_then_build(FAKE_BUILD_EXIT=str(build_exit))
                self.assertEqual(build_exit, result.returncode, result.stdout + result.stderr)
                self.assertIn('"status":"miss"', result.stdout)
        self.assertEqual(["-C " + str(self.root) + " lean"] * 2,
                         (self.root / "build-runs").read_text().splitlines())

    def test_optional_fetch_corruption_and_download_failure_reach_build(self):
        self.assertEqual(0, self.transport("publish").returncode)
        shutil.rmtree(self.root / ".lake/build")
        for archive in self.remote.glob("*/lean-build.tgz"):
            write(archive, "corrupt transfer")
        for failure in ("", "download"):
            for build_exit in (0, 19):
                with self.subTest(failure=failure, build_exit=build_exit):
                    result = self.fetch_then_build(FAKE_FAIL=failure, FAKE_BUILD_EXIT=str(build_exit))
                    self.assertEqual(build_exit, result.returncode, result.stdout + result.stderr)
                    self.assertIn('"status":"miss"', result.stdout)
                    self.assertFalse((self.root / ".lake/build").exists())
        self.assertEqual(["lean"] + ["-C " + str(self.root) + " lean"] * 4,
                         (self.root / "build-runs").read_text().splitlines())

    def test_optional_fetch_valid_seed_still_reaches_build(self):
        self.assertEqual(0, self.transport("publish").returncode)
        shutil.rmtree(self.root / ".lake/build")
        result = self.fetch_then_build()
        self.assertEqual(0, result.returncode, result.stdout + result.stderr)
        self.assertIn('"status":"unpacked"', result.stdout)
        self.assertEqual(["lean", "-C " + str(self.root) + " lean"],
                         (self.root / "build-runs").read_text().splitlines())

    def test_unavailable_lock_is_an_explicit_fetch_miss(self):
        write(self.bin / "fcntl.py", 'raise ImportError("fixture: fcntl unavailable")\n')
        result = self.transport("fetch", PYTHONPATH=str(self.bin))
        self.assertEqual(1, result.returncode, result.stdout + result.stderr)
        self.assertIn('"status":"miss"', result.stdout)
        self.assertNotIn("Traceback", result.stderr)

    def test_unavailable_lock_skips_publication_after_build_success(self):
        write(self.bin / "fcntl.py", 'raise ImportError("fixture: fcntl unavailable")\n')
        result = self.transport("publish", PYTHONPATH=str(self.bin))
        self.assertEqual(0, result.returncode, result.stdout + result.stderr)
        self.assertIn('"status":"skipped"', result.stdout)
        self.assertNotIn("Traceback", result.stderr)
        self.assertEqual([], list(self.remote.iterdir()))
        failed = self.transport("publish", PYTHONPATH=str(self.bin), FAKE_BUILD_EXIT="19")
        self.assertEqual(19, failed.returncode, failed.stdout + failed.stderr)
        self.assertEqual([], list(self.remote.iterdir()))

    def test_legacy_fetch_flag_cannot_enable_cross_partition_selection(self):
        self.assertEqual(0, self.transport("publish").returncode)
        shutil.rmtree(self.root / ".lake/build")
        restored = self.transport("fetch", arguments=("--allow-seed",))
        self.assertEqual(0, restored.returncode, restored.stdout + restored.stderr)
        self.assertTrue((self.root / ".lake/build/lib/lean/D5/A.olean").is_file())
        shutil.rmtree(self.root / ".lake/build")
        self.manifest["packages"][0]["rev"] = OTHER
        self.save_manifest()
        self.assertNotEqual(0, self.transport("fetch", arguments=("--allow-seed",)).returncode)
        self.assertFalse((self.root / ".lake/build").exists())

    def test_roundtrip_is_partitioned_and_source_sha_is_provenance_only(self):
        saved = self.transport("publish")
        self.assertEqual(0, saved.returncode, saved.stdout + saved.stderr)
        self.assertIn('"status":"published"', saved.stdout.replace(" ", ""))
        shutil.rmtree(self.root / ".lake/build")
        write(self.root / "D5/A.lean", "def a := 333\n")
        restored = self.transport("fetch", GITHUB_SHA="e"*40)
        self.assertEqual(0, restored.returncode, restored.stdout + restored.stderr)
        self.assertEqual("locally-produced-olean", (self.root / ".lake/build/lib/lean/D5/A.olean").read_text())
        self.assertIn('"mode":"partition"', restored.stdout.replace(" ", ""))

    def test_missing_corrupt_and_cross_partition_are_misses_without_target_writes(self):
        missing = self.transport("fetch")
        self.assertNotEqual(0, missing.returncode)
        self.assertEqual(0, self.transport("publish").returncode)
        shutil.rmtree(self.root / ".lake/build")
        self.manifest["packages"][0]["rev"] = OTHER
        self.save_manifest()
        self.assertNotEqual(0, self.transport("fetch").returncode)
        self.assertFalse((self.root / ".lake/build").exists())
        self.manifest["packages"][0]["rev"] = REV
        self.save_manifest()
        for archive in self.remote.glob("*/lean-build.tgz"):
            write(archive, "corrupt transfer")
        self.assertNotEqual(0, self.transport("fetch").returncode)
        self.assertFalse((self.root / ".lake/build").exists())

    def test_failed_save_never_publishes_a_usable_partial_snapshot(self):
        result = self.transport("publish", FAKE_FAIL="upload")
        self.assertEqual(0, result.returncode, result.stdout + result.stderr)
        self.assertIn('"status":"failed"', result.stdout.replace(" ", ""))
        shutil.rmtree(self.root / ".lake/build")
        self.assertNotEqual(0, self.transport("fetch").returncode)
        self.assertFalse((self.root / ".lake/build").exists())

    def test_concurrent_publishers_keep_distinct_complete_snapshots(self):
        with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
            results = list(pool.map(lambda run: self.transport("publish", run), ["401", "402"]))
        self.assertEqual([0, 0], [result.returncode for result in results])
        releases = [json.loads(path.read_text()) for path in self.remote.glob("*/release.json")]
        self.assertEqual(2, len(releases))
        self.assertTrue(all(not release["draft"] for release in releases))
        self.assertEqual(2, len({release["tag_name"] for release in releases}))

    def test_direct_fetch_respects_existing_cache_writer(self):
        import fcntl
        self.assertEqual(0, self.transport("publish").returncode)
        shutil.rmtree(self.root / ".lake/build")
        address = digest(str((self.root / ".lake").resolve()).encode())
        directory = self.root / ".cache/stratalint-lean-cache-guards"
        directory.mkdir(parents=True, exist_ok=True)
        with (directory / (address + ".lock")).open("a+b") as lock:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            blocked = self.transport("fetch")
            self.assertNotEqual(0, blocked.returncode)
            self.assertFalse((self.root / ".lake/build").exists())
        self.assertEqual(0, self.transport("fetch").returncode)
        self.assertTrue((self.root / ".lake/build/lib/lean/D5/A.olean").is_file())

    def test_actions_seed_skips_release_and_real_build_failure_blocks_save(self):
        result = self.transport("fetch", STRATALINT_ACTIONS_CACHE_SEEDED="1")
        self.assertEqual(0, result.returncode, result.stderr)
        self.assertIn("skipped", result.stdout)
        result = self.transport("publish", FAKE_BUILD_EXIT="19")
        self.assertEqual(19, result.returncode, result.stdout + result.stderr)
        self.assertEqual([], list(self.remote.iterdir()))

    def test_pr_cannot_publish_even_after_a_successful_build(self):
        result = self.transport("publish", GITHUB_EVENT_NAME="pull_request_target")
        self.assertEqual(0, result.returncode, result.stdout + result.stderr)
        self.assertIn("skipped", result.stdout)
        self.assertEqual([], list(self.remote.iterdir()))

    def test_transfer_failure_is_a_miss_and_empty_target_accepts_a_complete_seed(self):
        self.assertEqual(0, self.transport("publish").returncode)
        shutil.rmtree(self.root / ".lake/build")
        failed = self.transport("fetch", FAKE_FAIL="download")
        self.assertNotEqual(0, failed.returncode)
        self.assertFalse((self.root / ".lake/build").exists())
        (self.root / ".lake/build").mkdir()
        restored = self.transport("fetch")
        self.assertEqual(0, restored.returncode, restored.stdout + restored.stderr)
        self.assertTrue((self.root / ".lake/build/lib/lean/D5/A.olean").is_file())

    def test_retention_keeps_five_complete_snapshots_and_cleanup_failure_is_nonfatal(self):
        for run in range(501, 508):
            self.assertEqual(0, self.transport("publish", str(run)).returncode)
        self.assertEqual(5, len(list(self.remote.glob("*/release.json"))))
        result = self.transport("publish", "508", FAKE_FAIL="delete")
        self.assertEqual(0, result.returncode, result.stdout + result.stderr)
        self.assertIn('"status":"published"', result.stdout)
        self.assertIn("prune_error", result.stdout)


class PairFixture(PartitionFixture):
    def setUp(self):
        super().setUp()
        shutil.copytree(ROOT / "tools/scripts", self.root / "tools/scripts")
        shutil.copytree(ROOT / "tools/lean-inspector", self.root / "tools/lean-inspector")
        self.producer = self.root / "tools/lean-inspector/inspect.sh"
        write(self.producer, PAIR_PRODUCER)
        self.producer.chmod(0o755)
        self.cache = self.root / ".lake/report-cache"
        self.output = self.root / "out/raw-lean-report.json"
        self.helper = self.root / "tools/scripts/report/lean-report-input.sh"

    def pair(self, **extra):
        return subprocess.run([str(self.root / "tools/scripts/lean-report-pair.sh"),
            "--producer", str(self.producer), "--lake-bin", "/bin/echo",
            "--candidate-root", str(self.root), "--candidate-output", str(self.output)],
            text=True, capture_output=True, env={**os.environ,
                "STRATALINT_REPORT_CACHE_ROOT": str(self.cache), **extra})

    def report_input(self, command="address"):
        return subprocess.run([str(self.helper), command, "--repository", str(self.root),
            *(["--report", str(self.output)] if command == "verify" else [])], text=True, capture_output=True)

    def runs(self):
        return len((self.root / "producer-runs").read_text().splitlines())

    def seeds(self):
        return list(self.cache.glob("*/*/*/raw-lean-report.json"))


class PairTests(PairFixture, unittest.TestCase):
    def test_exact_hit_always_enters_producer_and_rebinds_candidate(self):
        first = self.pair()
        self.assertEqual(0, first.returncode, first.stdout + first.stderr)
        before = self.output.read_bytes()
        second = self.pair()
        self.assertEqual(0, second.returncode, second.stdout + second.stderr)
        self.assertEqual(2, self.runs())
        self.assertEqual(before, self.output.read_bytes())
        self.assertEqual("produced", json.loads(pathlib.Path(str(self.output) + ".provenance.json").read_text())["mode"])
        self.assertEqual(0, self.report_input("verify").returncode)
        self.assertEqual(1, len(self.seeds()))
        self.assertFalse(pathlib.Path(str(self.seeds()[0]) + ".logs").exists())

    def test_real_producer_failure_cannot_be_masked_by_prior_report(self):
        self.assertEqual(0, self.pair().returncode)
        before = self.output.read_bytes()
        result = self.pair(PAIR_FAIL="19")
        self.assertEqual(19, result.returncode, result.stdout + result.stderr)
        self.assertEqual(2, self.runs())
        self.assertEqual(before, self.output.read_bytes())

    def test_corrupt_seed_and_failed_save_do_not_override_production(self):
        self.assertEqual(0, self.pair().returncode)
        write(self.seeds()[0], "corrupt seed")
        self.assertEqual(0, self.pair().returncode)
        shutil.rmtree(self.cache)
        write(self.cache, "cache storage unavailable")
        result = self.pair()
        self.assertEqual(0, result.returncode, result.stdout + result.stderr)
        self.assertEqual(3, self.runs())
        self.assertEqual(0, self.report_input("verify").returncode)

    def test_invalid_producer_outputs_never_replace_prior_bundle(self):
        self.assertEqual(0, self.pair().returncode)
        before = self.output.read_bytes()
        for damage in ["logs", "materials", "checksum", "report"]:
            with self.subTest(damage=damage):
                result = self.pair(PAIR_DAMAGE=damage)
                self.assertNotEqual(0, result.returncode, result.stdout + result.stderr)
                self.assertEqual(before, self.output.read_bytes())

    def test_transport_adapter_preserves_seed_identity_and_omits_logs(self):
        self.assertEqual(0, self.pair().returncode)
        target = self.root / "imported"
        result = subprocess.run([str(self.root / "tools/scripts/report/lean-report-ci-baseline.sh"),
            "--bundle", str(self.output), "--cache-root", str(target)], text=True, capture_output=True)
        self.assertEqual(0, result.returncode, result.stderr)
        self.assertEqual(str(target), result.stdout.strip())
        imported = list(target.glob("*/*/*/raw-lean-report.json"))
        self.assertEqual(1, len(imported))
        for suffix in ["", ".input.attestation", ".provenance.json", ".materials.zip", ".seed.json"]:
            self.assertEqual(pathlib.Path(str(self.output)+suffix).read_bytes(),
                             pathlib.Path(str(imported[0])+suffix).read_bytes())
        self.assertFalse(pathlib.Path(str(imported[0])+".logs").exists())

    def test_input_follows_transitive_program_dependencies_without_workflow(self):
        before = self.report_input()
        self.assertEqual(0, before.returncode, before.stderr)
        write(self.root / ".github/workflows/ci.yml", "not a workflow")
        write(self.root / "tools/StrataLint.Cli/unused.cs", "irrelevant")
        self.assertEqual(before.stdout, self.report_input().stdout)
        module = self.root / "tools/lean-inspector/materials.py"
        write(module, module.read_text() + "\nimport fixture_dependency\n")
        dependency = self.root / "tools/lean-inspector/fixture_dependency.py"
        write(dependency, "SEMANTIC_VALUE = 1\n")
        first = self.report_input()
        self.assertEqual(0, first.returncode, first.stderr)
        write(dependency, "SEMANTIC_VALUE = 2\n")
        self.assertNotEqual(first.stdout, self.report_input().stdout)
        dependency.unlink()
        # Missing executable dependencies must fail closed during production.
        self.assertNotEqual(0, self.pair().returncode)

    def test_metadata_keeps_attestation_but_semantic_and_source_drift_are_stale(self):
        self.assertEqual(0, self.pair().returncode)
        write(self.root / "lakefile.toml", 'name = "renamed"\nkeywords = ["metadata"]\n[leanOptions]\nmaxRecDepth = 1000\n')
        self.assertEqual(0, self.report_input("verify").returncode)
        write(self.root / "D5/A.lean", "def a := 4\n")
        self.assertEqual(2, self.report_input("verify").returncode)
        self.assertEqual(0, self.pair().returncode)
        write(self.root / "lakefile.toml", '[leanOptions]\nmaxRecDepth = 2000\n')
        self.assertEqual(2, self.report_input("verify").returncode)


class InspectorTests(PairFixture, unittest.TestCase):
    def setUp(self):
        super().setUp()
        shutil.copyfile(ROOT / "tools/lean-inspector/inspect.sh", self.producer)
        runner = self.root / "tools/scripts/worktree/lean-cache-run.sh"
        write(runner, '#!/bin/sh\nexec "$@"\n')
        runner.chmod(0o755)
        self.lake = self.root / "runtime/bin/lean"
        write(self.lake, FAKE_LAKE)
        self.lake.chmod(0o755)
        self.core = self.root / "runtime/lib/lean/Init.olean"
        write(self.core, "compiled core fixture")
        write(self.core.with_suffix(".ilean"), json.dumps({"directImports": []}))

    def pair(self, **extra):
        return subprocess.run([str(self.root / "tools/scripts/lean-report-pair.sh"),
            "--producer", str(self.producer), "--lake-bin", str(self.lake),
            "--candidate-root", str(self.root), "--candidate-output", str(self.output)],
            text=True, capture_output=True, env={**os.environ,
                "STRATALINT_REPORT_CACHE_ROOT": str(self.cache), **extra})

    def test_inspector_runs_lake_on_exact_seed_with_zero_reinspection(self):
        first = self.pair()
        self.assertEqual(0, first.returncode, first.stdout + first.stderr)
        second = self.pair()
        self.assertEqual(0, second.returncode, second.stdout + second.stderr)
        self.assertIn("LEAN_REPORT_DELTA mode=reuse changed=0 added=0 removed=0 recheck=0", second.stdout)
        commands = (self.root / "lake-runs").read_text().splitlines()
        self.assertEqual(2, commands.count("build"))
        self.assertEqual(1, sum("--run" in command for command in commands))

    def test_report_staging_does_not_preempt_cold_cache_provisioning(self):
        self.output = self.root / ".lake/build/stratalint/raw-lean-report.json"
        result = self.pair(LAKE_EXPECT_NO_LAKE="1")
        self.assertEqual(0, result.returncode, result.stdout + result.stderr)

    def test_actual_runtime_dependency_change_reinspects_inside_same_partition(self):
        first = self.pair()
        self.assertEqual(0, first.returncode, first.stdout + first.stderr)
        write(self.core, "changed compiled core fixture")
        second = self.pair()
        self.assertEqual(0, second.returncode, second.stdout + second.stderr)
        self.assertIn("LEAN_REPORT_DELTA mode=delta changed=0 added=0 removed=0 recheck=2", second.stdout)

    def test_unknown_runtime_disables_reuse_but_allows_real_full_production(self):
        self.core.with_suffix(".ilean").unlink()
        for unused in range(2):
            result = self.pair()
            self.assertEqual(0, result.returncode, result.stdout + result.stderr)
            self.assertIn("LEAN_REPORT_DELTA mode=full-fallback", result.stdout)
        self.assertEqual([], self.seeds())

    def test_inspector_real_failure_blocks_even_when_report_seed_exists(self):
        self.assertEqual(0, self.pair().returncode)
        before = self.output.read_bytes()
        result = self.pair(LAKE_BUILD_FAIL="19")
        self.assertEqual(19, result.returncode, result.stdout + result.stderr)
        self.assertEqual(before, self.output.read_bytes())
        write(self.root / "D5/A.lean", "def a := 3\n")
        result = self.pair(LAKE_INSPECT_FAIL="23")
        self.assertEqual(23, result.returncode, result.stdout + result.stderr)
        self.assertEqual(before, self.output.read_bytes())


FAKE_LAKE = '''#!/usr/bin/env python3
import json, os, pathlib, sys
args = sys.argv[1:]
root = pathlib.Path.cwd()
with (root/"lake-runs").open("a") as log: log.write(" ".join(args)+"\\n")
if args == ["build"]:
    if os.environ.get("LAKE_EXPECT_NO_LAKE") and (root/".lake").exists(): sys.exit(29)
    sys.exit(int(os.environ.get("LAKE_BUILD_FAIL", "0")))
if "--print-prefix" in args: print(pathlib.Path(__file__).parent.parent); sys.exit(0)
if "--deps" in args: print(pathlib.Path(__file__).parent.parent/"lib/lean/Init.olean"); sys.exit(0)
if os.environ.get("LAKE_INSPECT_FAIL"): sys.exit(int(os.environ["LAKE_INSPECT_FAIL"]))
output = pathlib.Path(args[args.index("--output")+1])
modules = []
values = args[args.index("--material-spool")+2:]
for index in range(0, len(values), 3):
    module, source, sha = values[index:index+3]
    modules.append({"module": module, "source_path": source, "source_sha256": sha, "imports": [], "declarations": []})
output.write_text(json.dumps({"schema":"stratalint-lean-inspector-spool-v1", "modules":sorted(modules, key=lambda m: m["module"])})+"\\n")
'''


PAIR_PRODUCER = '''#!/usr/bin/env python3
import hashlib, json, os, pathlib, sys, zipfile
args = sys.argv[1:]
root = pathlib.Path(args[args.index("--repository")+1])
output = pathlib.Path(args[args.index("--output")+1])
with (root / "producer-runs").open("a") as log: log.write("entered\\n")
if os.environ.get("PAIR_FAIL"): sys.exit(int(os.environ["PAIR_FAIL"]))
modules = [{"module": str(p.relative_to(root))[:-5].replace("/", "."),
    "source_path": str(p.relative_to(root)), "source_sha256": "sha256:"+hashlib.sha256(p.read_bytes()).hexdigest(),
    "imports": [], "declarations": []} for p in sorted([root/"Trureturing.lean", root/"D5/A.lean"])]
output.write_text(json.dumps({"modules": modules, "schema": "stratalint-raw-lean-report-v2"}, sort_keys=True)+"\\n")
with zipfile.ZipFile(str(output)+".materials.zip", "w"): pass
pathlib.Path(str(output)+".sha256").write_text(hashlib.sha256(output.read_bytes()).hexdigest()+"  "+output.name+"\\n")
pathlib.Path(str(output)+".seed.json").write_text(json.dumps({"runtime_sha256":"c"*64}))
logs = pathlib.Path(str(output)+".logs"); logs.mkdir()
(logs/"producer.log").write_text("produced\\n")
damage = os.environ.get("PAIR_DAMAGE")
if damage == "logs": (logs/"producer.log").unlink()
if damage == "materials": pathlib.Path(str(output)+".materials.zip").write_text("corrupt")
if damage == "checksum": pathlib.Path(str(output)+".sha256").write_text("bad")
if damage == "report": output.write_text("bad")
'''


FAKE_GH = '''#!/usr/bin/env python3
import hashlib, json, os, pathlib, shutil, sys
args = sys.argv[1:]
root = pathlib.Path(os.environ["FAKE_REMOTE"])
if len(args) > 1 and os.environ.get("FAKE_FAIL") == args[1] and args[1] != "upload": sys.exit(23)
def option(name): return args[args.index(name)+1]
def metadata(directory):
    value = json.loads((directory / "release.json").read_text())
    value["assets"] = [{"name": p.name, "digest": "sha256:" + hashlib.sha256(p.read_bytes()).hexdigest()}
                       for p in directory.iterdir() if p.name != "release.json"]
    return value
if args[:2] == ["release", "list"]:
    print(json.dumps([{"tagName": p.parent.name, "createdAt": p.parent.name, "isDraft": json.loads(p.read_text())["draft"]}
                      for p in root.glob("*/release.json")]))
elif args[0] == "api":
    directory = root / args[1].split("/")[-1]
    print(json.dumps(metadata(directory)))
else:
    verb, tag = args[1:3]
    directory = root / tag
    if verb == "create":
        directory.mkdir()
        (directory / "release.json").write_text(json.dumps({"tag_name": tag, "target_commitish": option("--target"), "draft": True}))
    elif verb == "upload":
        for value in args[3:]:
            if pathlib.Path(value).is_file(): shutil.copyfile(value, directory / pathlib.Path(value).name)
        if os.environ.get("FAKE_FAIL") == "upload": sys.exit(23)
    elif verb == "edit":
        value = json.loads((directory / "release.json").read_text()); value["draft"] = False
        (directory / "release.json").write_text(json.dumps(value))
    elif verb == "download":
        destination = pathlib.Path(option("--dir")); destination.mkdir(exist_ok=True)
        for path in directory.iterdir():
            if path.name != "release.json": shutil.copyfile(path, destination / path.name)
    elif verb == "view":
        if not directory.exists(): sys.exit(1)
        print(json.dumps(metadata(directory)))
    elif verb == "delete": shutil.rmtree(directory)
    else: sys.exit(2)
'''


if __name__ == "__main__":
    unittest.main(verbosity=2)
