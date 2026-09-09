"""Measured IO around the Lean streaming query; no evidence classification here."""

import argparse
import hashlib
import json
import os
import pathlib
import subprocess

from streaming import canonical, digest, enumerate_oleans, file_stamp, hash_inputs, tracked_domain


def read(path):
    return json.loads(pathlib.Path(path).read_bytes())


def write(path, value):
    pathlib.Path(path).write_bytes(canonical(value))


def enumerate_domain(repository, directory):
    domain = tracked_domain(repository)
    manifest, inputs = enumerate_oleans(repository, domain)
    write(directory / "domain.json", domain)
    write(directory / "manifest.json", manifest)
    write(directory / "inputs.json", inputs)
    write(directory / "stamps.json", {path: file_stamp(path) for _, _, path in inputs})


def external_graph(directory):
    """Upstream packages cannot depend on this downstream package.

    Project edges come exclusively from the streamed olean headers. For scope
    display, upstream edges use the compiler's directImports in ilean metadata;
    these packages define none of the downstream evidence types/extensions.
    A missing header or an edge back into the tracked domain fails closed. No
    upstream or surplus project olean is opened or hashed by the census.
    """
    domain = read(directory / "domain.json")
    domain_names = set(domain)
    repository = pathlib.Path(__file__).resolve().parents[3]
    pending = set()
    for line in (directory / "index.jsonl").open():
        data = json.loads(line)
        pending.update(e["module"] for e in data["imports"] if e["module"] not in domain)
    project_build = (repository / ".lake/build/lib/lean").resolve()
    search = [pathlib.Path(p) for p in os.environ["LEAN_PATH"].split(os.pathsep)
              if p and pathlib.Path(p).resolve() != project_build]
    prefix = subprocess.check_output(["lean", "--print-prefix"], text=True).strip()
    search.append(pathlib.Path(prefix) / "lib/lean")
    result = {}
    while pending:
        module = pending.pop()
        if module in result:
            continue
        relative = pathlib.Path(module.replace(".", "/") + ".ilean")
        path = next((root / relative for root in search if (root / relative).is_file()), None)
        if path is None:
            raise ValueError("IE-C044 missing upstream compiler import metadata: " + module)
        data = read(path)
        if data["module"] != module:
            raise ValueError("IE-C044 mismatched compiler import metadata: " + module)
        imports = sorted(set(entry[0] for entry in data["directImports"]))
        if domain_names.intersection(imports):
            raise ValueError("IE-C044 upstream evidence boundary violated: " + module)
        result[module] = imports
        pending.update(dependency for dependency in imports if dependency not in result)
    request = read(directory / "membership-request.json")
    request["external_graph"] = sorted(result.items())
    write(directory / "membership-request.json", request)


def hash_receipt(repository, directory):
    request = read(directory / "request.json")
    membership = read(directory / "membership.json")
    projection = read(directory / "projection.json")
    paths = subprocess.check_output(["git", "ls-files", "-z", "--", "tools/lean-inspector",
        "lean-toolchain", "lakefile.toml", "lake-manifest.json"], cwd=repository).split(b"\0")
    programs = [[p.decode(), "sha256:" + hashlib.sha256((repository / p.decode()).read_bytes()).hexdigest()]
                for p in paths if p and pathlib.Path(p.decode()).suffix in (".lean", ".py", ".toml", ".json", "")]
    graph = {"project_headers": membership["headers"], "upstream": membership["external_graph"]}
    validation = None
    if membership["candidate_keys"]:
        validation = read(directory / "candidates.json.receipt.json")
        actual = "sha256:" + hashlib.sha256((directory / "candidates.json").read_bytes()).hexdigest()
        if (validation["rows_sha256"] != actual or validation["head"] != request["head"]
                or validation["report_sha256"] != request["report_sha256"]):
            raise ValueError("IE-C044 candidate validation receipt differs from its output or request")
    inputs = {"head": request["head"],
              "oleans": hash_inputs(read(directory / "inputs.json"), read(directory / "stamps.json")),
              "import_graph": digest(graph), "programs": sorted(programs),
              "export_sha256": request["report_sha256"], "domain": read(directory / "domain.json"),
              "scopes": membership["scopes"], "candidate_validation": validation,
              "toolchain": (repository / "lean-toolchain").read_text().strip()}
    from streaming import receipt_digest
    receipt = {"inputs": inputs, "digest": receipt_digest(inputs),
               "rows_sha256": digest(projection), "candidate_keys": membership["candidate_keys"]}
    write(directory / "receipt.json", receipt)


def name_json(name):
    value = ["anonymous"]
    for part in name.split("."):
        value = ["str", value, part]
    return value


def emit(directory):
    projection = read(directory / "projection.json")
    info = read(directory / "emission.json")
    counts = projection["counts"]
    complete = counts["accounted"] == info["requested_keys"]
    fields = dict(info, schema="lean-information-disposition-census", counts=counts,
                  status="complete" if complete else "partial", coverage_theorem_count=counts["accounted"],
                  certified_complete=complete and counts["certified"] == counts["accounted"])
    scopes = {}
    for root, modules in read(directory / "membership.json")["scopes"]:
        scopes[canonical(name_json(root))] = canonical({"modules": [name_json(m) for m in modules],
                                                       "completed": True}).rstrip(b"\n")
    # Scope bytes are encoded once per semantic root, then copied to each row.
    # This retains the J2 row schema without constructing a repository-sized DOM.
    with (directory / "census.json").open("wb") as out:
        out.write(canonical(fields)[:-2] + b',"rows":[\n')
        for number, row in enumerate(projection["rows"]):
            if number:
                out.write(b",\n")
            encoded = canonical(row).rstrip(b"\n")
            if row["class"] == "observed":
                encoded = encoded.replace(b'"import_scope":null', b'"import_scope":' +
                    scopes[canonical(row["payload"]["root"])] , 1)
            out.write(encoded)
        out.write(b"\n]}\n")
    write(directory / "census.json.summary.json", fields)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("phase", choices=["enumerate", "graph", "hash", "emit"])
    parser.add_argument("repository", type=pathlib.Path)
    parser.add_argument("directory", type=pathlib.Path)
    options = parser.parse_args()
    if options.phase == "enumerate":
        enumerate_domain(options.repository, options.directory)
    elif options.phase == "graph":
        external_graph(options.directory)
    elif options.phase == "hash":
        hash_receipt(options.repository, options.directory)
    else:
        emit(options.directory)
