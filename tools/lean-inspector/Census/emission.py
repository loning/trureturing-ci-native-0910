"""Emit pure Lean data from successful Lean query results, without importing targets."""

import json
import re


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


def key_list(keys):
    ordered = sorted(((key, statement_nat(wire)) for key, wire in keys), key=lambda item: item[1])
    return "[\n" + ",\n".join(f"  ({name(key)}, {value})" for key, value in ordered) + "]"


def manifest_source(rows, report_keys, head, digest, root):
    root_name = ["anonymous"]
    for part in root.split("."):
        root_name = ["str", root_name, part]
    inventory = key_list((row["theorem_name"], row["statement_id"]) for row in rows)
    report = key_list((parse_name_key(key), wire) for _, key, wire in report_keys)
    return ("import LeanInformationAudit.Census.Publish\nopen LeanInformationAudit\n"
            "def CensusRun.manifest : CensusKeyManifest :=\n"
            f"  {{ headSha := {string(head)}, reportSha256 := {string(digest)},\n"
            f"    censusRoot := {name(root_name)}, keys := {inventory} }}\n"
            f"def CensusRun.reportKeys : List (Lean.Name × Nat) := {report}\n")


def write_module(directory, module, contents):
    path = directory.joinpath(*module.split(".")).with_suffix(".lean")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(contents, encoding="utf-8")
    return path
