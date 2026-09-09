#!/usr/bin/env python3
"""Report bundle staging and transport framing; report semantics belong to delta.py."""

import argparse
import hashlib
import importlib.util
import json
import os
import pathlib
import re
import shutil
import subprocess
import sys
import tempfile
import zipfile

HERE = pathlib.Path(__file__).resolve().parent
RAW = "raw-lean-report.json"
SUFFIXES = ("", ".sha256", ".input.attestation", ".provenance.json", ".materials.zip")
HEX = re.compile(r"[0-9a-f]{64}")


def digest(path):
    result = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            result.update(block)
    return result.hexdigest()


def member(report, suffix):
    return pathlib.Path(str(report) + suffix)


def asset_name(repository, producer, resident, config):
    if any(not HEX.fullmatch(value) for value in (repository, producer, resident, config)):
        raise ValueError("invalid input coordinate")
    compatibility = hashlib.sha256(f"{producer} {resident} {config}\n".encode("ascii")).hexdigest()
    return f"report-{compatibility}-{repository}.zip"


def delta_owner():
    spec = importlib.util.spec_from_file_location("lean_report_delta", HERE / "../../lean-inspector/delta.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def bundle_metadata(report, transport=False):
    # The baseline adapter's existing sidecar contract, generalized for the
    # caller's basename. This does not implement a report schema validator.
    if any(not member(report, suffix).is_file() or not member(report, suffix).stat().st_size
           for suffix in SUFFIXES):
        raise ValueError("missing-bundle-member")
    report_sha = digest(report)
    sidecar = member(report, ".sha256").read_text(encoding="ascii").splitlines()
    attestation = member(report, ".input.attestation").read_text(encoding="ascii").splitlines()
    provenance = json.loads(member(report, ".provenance.json").read_text(encoding="utf-8"))
    expected_keys = {
        "schema", "side", "mode", "source_side", "input_address", "producer_sha256",
        "repository_inspector_sha256", "lean_sources_sha256", "lean_config_sha256", "report_sha256",
    }
    if (not isinstance(provenance, dict) or set(provenance) != expected_keys
            or any(not isinstance(value, str) for value in provenance.values())
            or provenance["schema"] != "stratalint-lean-report-provenance-v1"
            or provenance["side"] != "candidate" or provenance["source_side"] != "candidate"
            or provenance["mode"] not in ("produced", "cached")
            or not re.fullmatch(r"sha256:[0-9a-f]{64}", provenance["input_address"])
            or any(not HEX.fullmatch(provenance[field]) for field in (
                "producer_sha256", "repository_inspector_sha256", "lean_sources_sha256",
                "lean_config_sha256", "report_sha256"))
            or provenance["report_sha256"] != report_sha
            or sidecar != [report_sha + "  " + report.name]
            or len(attestation) != 4
            or attestation[0] != "schema=stratalint-lean-report-input-attestation-v1"
            or not re.fullmatch(r"repository_input_sha256=[0-9a-f]{64}", attestation[1])
            or attestation[2] != "producer_sha256=" + provenance["producer_sha256"]
            or attestation[3] != "report_sha256=" + report_sha):
        raise ValueError("invalid-attestation")
    repository = attestation[1].split("=", 1)[1]
    if transport:
        coordinates = subprocess.check_output([
            "bash", str(HERE / "lean-report-input.sh"), "coordinates",
            *(provenance[field] for field in ("producer_sha256", "repository_inspector_sha256",
                                             "lean_sources_sha256", "lean_config_sha256")),
        ], text=True).strip().split(" ")
        if coordinates != [provenance["input_address"][7:], repository]:
            raise ValueError("bundle-input-coordinate-mismatch")
        with zipfile.ZipFile(member(report, ".materials.zip")) as materials:
            if materials.testzip() is not None:
                raise ValueError("corrupt-materials-zip")
    return provenance, repository


def checked_root(root):
    root.mkdir(mode=0o700, parents=True, exist_ok=True)
    info = root.stat()
    if info.st_uid != os.getuid() or info.st_mode & 0o022:
        raise ValueError("cache-root-untrusted")


def copy_bundle(report, directory, transport):
    bundle_metadata(report, transport)
    target = directory / RAW
    for suffix in SUFFIXES:
        shutil.copyfile(member(report, suffix), member(target, suffix))
    member(target, ".sha256").write_text(digest(target) + "  " + RAW + "\n", encoding="ascii")
    bundle_metadata(target, transport)
    if transport:
        delta_owner().parse_json_modules(target)
    return target


def stage(args):
    report = pathlib.Path(args.bundle)
    if not report.is_absolute():
        raise ValueError("bundle must be absolute")
    if args.staging_directory:
        destination = pathlib.Path(args.staging_directory)
        if not destination.is_absolute():
            raise ValueError("staging directory must be absolute")
        destination.mkdir(parents=True, exist_ok=True)
        copy_bundle(report, destination, args.transport)
        print(destination / RAW)
        return
    root = pathlib.Path(args.cache_root)
    if not root.is_absolute():
        raise ValueError("cache root must be absolute")
    provenance, _ = bundle_metadata(report, args.transport)
    checked_root(root)
    entry = root / provenance["input_address"][7:]
    staged = pathlib.Path(tempfile.mkdtemp(prefix=".staging.", dir=root))
    try:
        copy_bundle(report, staged, args.transport)
        if entry.exists():
            existing, _ = bundle_metadata(entry / RAW, args.transport)
            if existing["input_address"] != provenance["input_address"]:
                raise ValueError("cache-entry-address-mismatch")
        else:
            # Rename a complete private directory into the UID-owned store. A
            # concurrent complete winner is harmless; never replace live output.
            try:
                staged.rename(entry)
            except OSError:
                existing, _ = bundle_metadata(entry / RAW, args.transport)
                if existing["input_address"] != provenance["input_address"]:
                    raise
        print(f"LEAN_REPORT_CI_BASELINE status=ready input_address={provenance['input_address']}", file=sys.stderr)
        print(root)
    finally:
        if staged.exists():
            shutil.rmtree(staged)


def pack(report, archive):
    provenance, repository = bundle_metadata(report, True)
    if report.name != RAW or archive.name != asset_name(repository, provenance["producer_sha256"],
            provenance["repository_inspector_sha256"], provenance["lean_config_sha256"]):
        raise ValueError("archive-coordinate-mismatch")
    delta_owner().parse_json_modules(report)
    with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED, allowZip64=True) as bundle:
        bundle.comment = json.dumps({"producer_commit_sha": os.environ.get("GITHUB_SHA", ""),
                                    "workflow_run_id": os.environ.get("GITHUB_RUN_ID", "")}).encode("utf-8")
        for suffix in SUFFIXES:
            info = zipfile.ZipInfo(RAW + suffix)
            info.compress_type = zipfile.ZIP_DEFLATED
            with member(report, suffix).open("rb") as source, bundle.open(info, "w", force_zip64=True) as target:
                shutil.copyfileobj(source, target)
    member(archive, ".sha256").write_text(digest(archive) + "  " + archive.name + "\n", encoding="ascii")


def unpack(archive, directory):
    # The transport digest binds every byte, including materials and provenance.
    if member(archive, ".sha256").read_text(encoding="ascii").splitlines() != [digest(archive) + "  " + archive.name]:
        raise ValueError("transport-digest-mismatch")
    directory.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(archive) as bundle:
        expected = {RAW + suffix for suffix in SUFFIXES}
        if len(bundle.infolist()) != len(expected) or set(bundle.namelist()) != expected:
            raise ValueError("partial-transport-bundle")
        for name in sorted(expected):
            with bundle.open(name) as source, (directory / name).open("wb") as target:
                shutil.copyfileobj(source, target)
    report = directory / RAW
    provenance, repository = bundle_metadata(report, True)
    if archive.name != asset_name(repository, provenance["producer_sha256"],
            provenance["repository_inspector_sha256"], provenance["lean_config_sha256"]):
        raise ValueError("archive-coordinate-mismatch")
    delta_owner().parse_json_modules(report)


def asset_inventory(path):
    pages = json.loads(path.read_text(encoding="utf-8"))
    return {asset["name"]: asset for page in pages for asset in page}


def publication_state(path, exact):
    assets = asset_inventory(path)
    members = [assets.get(name) for name in (exact, exact + ".sha256")]
    if any(item is not None and item.get("state") != "uploaded" for item in members):
        # An upload in progress is unavailable, not confirmed damaged content.
        return "unavailable"
    if all(item is not None for item in members):
        return "complete"
    return "partial" if any(item is not None for item in members) else "absent"


def select_assets(path, exact):
    assets = {name: asset for name, asset in asset_inventory(path).items() if asset.get("state") == "uploaded"}
    prefix = exact.rsplit("-", 1)[0] + "-"
    compatible = sorted((asset for name, asset in assets.items()
                         if re.fullmatch(re.escape(prefix) + r"[0-9a-f]{64}\.zip", name)
                         and name != exact and name + ".sha256" in assets),
                        key=lambda asset: (asset.get("updated_at", ""), asset["name"]), reverse=True)
    if exact in assets and exact + ".sha256" in assets:
        print(exact)
    if compatible:
        print(compatible[0]["name"])


def local_seed(root, address, producer, resident, config):
    checked_root(root)
    owner = delta_owner()
    entries = sorted(root.iterdir(), key=lambda path: path.stat().st_mtime_ns, reverse=True)
    for entry in entries:
        if entry.is_dir() and owner.valid_baseline(entry, address, producer, resident, config) is not None:
            return 0
    return 1


def main():
    command, *values = sys.argv[1:]
    try:
        if command == "stage":
            parser = argparse.ArgumentParser()
            parser.add_argument("--bundle", required=True)
            target = parser.add_mutually_exclusive_group(required=True)
            target.add_argument("--cache-root")
            target.add_argument("--staging-directory")
            parser.add_argument("--transport", action="store_true")
            stage(parser.parse_args(values))
        elif command == "name":
            print(asset_name(*values))
        elif command == "pack":
            pack(*map(pathlib.Path, values))
        elif command == "unpack":
            unpack(*map(pathlib.Path, values))
        elif command == "select":
            select_assets(pathlib.Path(values[0]), values[1])
        elif command == "publication-state":
            print(publication_state(pathlib.Path(values[0]), values[1]))
        elif command == "local-seed":
            return local_seed(pathlib.Path(values[0]), *values[1:])
        elif command == "root":
            checked_root(pathlib.Path(values[0]))
        else:
            raise ValueError("unknown command")
        return 0
    except (OSError, ValueError, TypeError, KeyError, UnicodeError, zipfile.BadZipFile,
            RuntimeError, subprocess.SubprocessError) as error:
        print(f"lean-report-cache: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
