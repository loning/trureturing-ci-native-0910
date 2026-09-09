"""Stream detached olean records into the content-addressed extraction cache."""

import hashlib
import json
import pathlib
import subprocess
import sys

from incremental import extraction_plan, save_extraction
from streaming import canonical, digest, file_stamp

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))
from materials import declaration_statement_id


def finish_record(record, source_path):
    for owner in record["owners"]:
        # Reuse the report producer; no second encoding, JSON canonicalizer or
        # statement-domain hasher exists in the census.
        material = owner.pop("statement_material")
        owner["statement_id"] = declaration_statement_id(
            source_path, owner["kind"], owner.pop("name_key"), material)
    return record


def source_digest(repository):
    inspector = repository / "tools/lean-inspector"
    paths = [inspector / name for name in [
        "LeanInformationAudit/Census/Stream.lean", "LeanInformationAudit/Census/Ownership.lean",
        "LeanInformationAudit/RegistryTypes.lean", "LeanInformationAudit/NameWire.lean",
        "LeanInformationAudit/StatementEncoding.lean", "Census/scan.lean",
        "Census/extraction.py", "materials.py"]]
    return digest([(str(p.relative_to(repository)), hashlib.sha256(p.read_bytes()).hexdigest()) for p in paths])


def scan(repository, directory, binary):
    def read(name):
        return json.loads((directory / name).read_bytes())
    manifest, hashes = read("manifest.json"), read("olean-hashes.json")
    request, domain = read("request.json"), read("domain.json")
    names = digest(sorted(set(row[1] for row in request["keys"])))
    plan = extraction_plan(manifest, hashes, repository / ".lake/build/census/index",
                           source_digest(repository), names)
    missing = directory / "missing-manifest.json"
    missing.write_bytes(canonical(plan["misses"]))
    if plan["misses"]:
        proc = subprocess.Popen([str(binary), str(missing), str(directory / "request.json"), "-"],
                                cwd=repository, stdout=subprocess.PIPE, text=True)
        try:
            current, records = None, []
            for line in proc.stdout:
                data = json.loads(line)
                module = data["module"]
                if current is not None and module != current:
                    save_extraction(plan, current, records)
                    records = []
                current = module
                records.append(finish_record(data, domain[module]))
            if proc.wait():
                raise ValueError("IE-C044 olean extraction failed")
            if current is not None:
                save_extraction(plan, current, records)
        finally:
            proc.stdout.close()
            if proc.poll() is None:
                proc.kill()
                proc.wait()
    # Each module is decoded, copied to the read stream, then released. No
    # repository-sized array of constant records or extraction DOM is retained.
    used = []
    with (directory / "index.jsonl").open("wb") as out:
        for module, _ in manifest:
            path = plan["paths"][module]
            data = path.read_bytes()
            for record in json.loads(data):
                if record["module"] != module:
                    raise ValueError("IE-C044 extraction module binding mismatch")
                out.write(canonical(record))
            used.append([module, plan["digests"][module], digest(json.loads(data))])
    stamps = read("stamps.json")
    for _, _, path in read("inputs.json"):
        if file_stamp(path) != stamps[path]:
            raise ValueError("IE-C044 olean changed during extraction")
    result = {"hits": len(plan["hits"]), "misses": len(plan["misses"]),
              "reread_modules": [m for m, _ in plan["misses"]], "cache_keys": used,
              "source_digest": source_digest(repository), "frozen_names_digest": names}
    (directory / "extraction.json").write_bytes(canonical(result))
    return result


if __name__ == "__main__":
    scan(pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2]), sys.argv[3])
