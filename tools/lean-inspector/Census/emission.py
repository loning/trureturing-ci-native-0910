"""Emit pure Lean data from successful Lean query results, without importing targets."""

import json
import re

from config import PREFIX_BITS


def statement_nat(wire):
    if not isinstance(wire, str) or not re.fullmatch(r"sha256:[0-9a-f]{64}", wire):
        raise ValueError("IE-C036 component=statement_id_format")
    value = int(wire[7:], 16)
    if "sha256:" + format(value, "064x") != wire:
        raise ValueError("IE-C036 component=statement_id_nat")
    return value


def parse_name_key(text):
    data = text.encode("utf-8")

    def parse(offset):
        if data[offset:offset + 2] == b"n0":
            return ["anonymous"], offset + 2
        tag = data[offset:offset + 3]
        if tag not in (b"ns(", b"nn("):
            raise ValueError("invalid structured Name")
        parent, offset = parse(offset + 3)
        if data[offset:offset + 1] != b",":
            raise ValueError("invalid Name separator")
        end = offset + 1
        while end < len(data) and 48 <= data[end] <= 57:
            end += 1
        value = int(data[offset + 1:end])
        if tag == b"ns(":
            if data[end:end + 1] != b":":
                raise ValueError("invalid Name length")
            value, end = data[end + 1:end + 1 + value].decode("utf-8"), end + 1 + value
        if data[end:end + 1] != b")":
            raise ValueError("invalid Name terminator")
        return ["str" if tag == b"ns(" else "num", parent, value], end + 1

    value, offset = parse(0)
    if offset != len(data):
        raise ValueError("trailing Name bytes")
    return value


def string(value):
    return json.dumps(value, ensure_ascii=False)


def name(value):
    if value == ["anonymous"]:
        return "Lean.Name.anonymous"
    tag, parent, part = value
    if tag == "str":
        return f"(Lean.Name.str {name(parent)} {string(part)})"
    if tag == "num" and isinstance(part, int):
        return f"(Lean.Name.num {name(parent)} {part})"
    raise ValueError("invalid structured Lean name")


def pack_ids(values):
    """Least significant digit first; arity is emitted separately, including zero."""
    if not 1 <= len(values) <= 100 or any(not 0 <= value < 2 ** 256 for value in values):
        raise ValueError("IE-C036 component=statement_id_nat or chunk_arity")
    packed = 0
    for value in reversed(values):
        packed = (packed << 256) | value
    return packed


def chunked_keys(declaration, keys, public=False):
    # Hex numeral syntax is still a Nat literal in Lean. It avoids decimal
    # conversion limits for these 25,600-bit values; no id is a JSON number.
    ordered = sorted(statement_nat(wire) for _, wire in keys)
    chunks = []
    definitions = []
    for start in range(0, len(ordered), 100):
        chunk = f"{declaration}.chunk{start // 100}"
        values = ordered[start:start + 100]
        chunks.append(f"decodeIds {len(values)} {chunk}")
        definitions.append(f"noncomputable def {chunk} : Nat := 0x{pack_ids(values):x}\n")
    definitions.append(("public " if public else "") + f"noncomputable def {declaration} : List Nat := "
                       + "List.flatten [" + ", ".join(chunks) + "]\n")
    return "".join(definitions)


def partition(keys, b):
    if not isinstance(b, int) or not 0 <= b <= 256:
        raise ValueError("prefix bits must be in [0, 256]")
    buckets = [[] for _ in range(2 ** b)]
    for key, wire in keys:
        buckets[statement_nat(wire) >> (256 - b)].append((key, wire))
    return buckets


def bucket_sources(rows, report_keys, b=PREFIX_BITS):
    inventory = partition(((row["theorem_name"], row["statement_id"]) for row in rows), b)
    report = partition(((parse_name_key(key), wire) for _, key, wire in report_keys), b)
    sources = {}
    for k, (inv, rep) in enumerate(zip(inventory, report)):
        module = f"CensusRun.Bucket{k}"
        sources[module] = ("module\npublic import LeanInformationAudit.Census.Certificate\n"
            "open LeanInformationAudit\n"
            + chunked_keys(module + ".manifestKeys", inv, public=True)
            + chunked_keys(module + ".reportKeys", rep, public=True)
            + f"@[expose] public def {module}.n : Nat := {len(inv)}\n"
            + f"public theorem {module}.ascending : strictlyAscending {module}.manifestKeys = true := by decide +kernel\n"
            + f"public theorem {module}.range : inRange {k} {b} {module}.manifestKeys = true := by decide +kernel\n"
            + f"public theorem {module}.length : {module}.manifestKeys.length = {module}.n := by decide +kernel\n"
            + f"public theorem {module}.equality : {module}.manifestKeys = {module}.reportKeys := by rfl\n")
    return sources


def manifest_source(rows, report_keys, head, digest, root, b=PREFIX_BITS):
    root_name = ["anonymous"]
    for part in root.split("."):
        root_name = ["str", root_name, part]
    buckets = [f"CensusRun.Bucket{k}" for k in range(2 ** b)]
    def refs(suffix):
        return "[" + ", ".join(module + suffix for module in buckets) + "]"
    proof = "\n".join(f"  BucketCertificates.cons {m}.ascending {m}.range {m}.length {m}.equality <|"
                      for m in buckets) + f"\n  BucketCertificates.nil {2 ** b}\n"
    return ("module\npublic import LeanInformationAudit.Census.Certificate\n"
            + "".join(f"public import {module}\n" for module in buckets)
            + "open LeanInformationAudit\n"
            + f"@[expose] public def CensusRun.prefixBits : Nat := {b}\n"
            + f"@[expose] public noncomputable def CensusRun.manifestKeys : List Nat := List.flatten {refs('.manifestKeys')}\n"
            + f"@[expose] public noncomputable def CensusRun.reportKeys : List Nat := List.flatten {refs('.reportKeys')}\n"
            + "@[expose] public noncomputable def CensusRun.manifest : CensusKeyManifest :=\n"
            f"  {{ headSha := {string(head)}, reportSha256 := {string(digest)},\n"
            f"    censusRoot := {name(root_name)}, keys := CensusRun.manifestKeys }}\n"
            + f"public theorem CensusRun.bucketFacts : BucketCertificates {b} 0 "
            + refs('.manifestKeys') + " " + refs('.n') + " " + refs('.reportKeys') + " :=\n" + proof)


def write_manifest(directory, rows, report_keys, head, digest, root, b=PREFIX_BITS):
    for module, source in bucket_sources(rows, report_keys, b).items():
        write_module(directory, module, source)
    return write_module(directory, root, manifest_source(rows, report_keys, head, digest, root, b))


def write_module(directory, module, contents):
    path = directory.joinpath(*module.split(".")).with_suffix(".lean")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(contents, encoding="utf-8")
    return path
