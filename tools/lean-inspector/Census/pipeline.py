"""Run-local truth census. Lean owns registration queries and certification."""

from __future__ import annotations

import json
import pathlib


def parse_request(value):
    if not isinstance(value, dict) or set(value) != {"root", "report"}:
        raise ValueError("census request requires exactly root and report")
    if any(not isinstance(item, str) or not item for item in value.values()):
        raise ValueError("census request values must be nonempty strings")
    return value


def frozen_keys(report):
    result = []
    identities = set()
    for node in report["nodes"]:
        if node["freeze_status"] not in ("frozen", "proven-not-yet-frozen"):
            raise ValueError("invalid freeze status")
        if node["freeze_status"] != "frozen":
            continue
        module = node["repo_path"].removesuffix(".lean").replace("/", ".")
        for declaration in node["declarations"]:
            if declaration["kind"] != "theorem":
                continue
            identity = declaration["statement_id"]
            if identity in identities:
                raise ValueError("duplicate statement identity")
            identities.add(identity)
            result.append((module, declaration["declaration_name_key"], identity))
    return sorted(result)


def read_keys(data):
    value = json.loads(data)
    if not isinstance(value, list) or any(
            not isinstance(row, list) or len(row) != 3
            or any(not isinstance(item, str) or not item for item in row) for row in value):
        raise ValueError("expected module, structured declaration name, statement identity triples")
    return value


def write_requests(directory: pathlib.Path, keys):
    for start in range(0, len(keys), 100):
        chunk = start // 100
        path = directory / f"Group{chunk // 20:04d}" / f"Rows{chunk:05d}.json"
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(keys[start:start + 100], ensure_ascii=True) + "\n", encoding="ascii")
