"""Consume the query lane's J2 rows and whole-stream receipt, without query replay."""

import argparse
import hashlib
import json
import pathlib
import shutil

import sys

if __package__ in (None, ""):
    sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))

from streaming import canonical, digest


def fields(path):
    """Decode one J2 row at a time; scopes never accumulate in a full DOM."""
    with pathlib.Path(path).open(encoding="utf-8") as source:
        buffer, ended = "", False
        decoder = json.JSONDecoder()

        def more():
            nonlocal buffer, ended
            block = source.read(65536)
            buffer += block
            ended = not block

        def peek():
            nonlocal buffer
            while True:
                buffer = buffer.lstrip()
                if buffer or ended:
                    return buffer[:1]
                more()

        def take(token):
            nonlocal buffer
            if peek() != token:
                raise ValueError("IE-C044 whole_stream_json delimiter " + token)
            buffer = buffer[1:]

        def value():
            nonlocal buffer
            peek()
            while True:
                try:
                    result, end = decoder.raw_decode(buffer)
                    if end == len(buffer) and not ended:
                        more()
                        continue
                    buffer = buffer[end:]
                    return result
                except json.JSONDecodeError:
                    if ended:
                        raise ValueError("IE-C044 whole_stream_json truncated value")
                    more()

        take("{")
        seen = set()
        while peek() != "}":
            key = value()
            if not isinstance(key, str) or key in seen:
                raise ValueError("IE-C044 whole_stream_json duplicate field")
            seen.add(key)
            take(":")
            if key == "rows":
                take("[")
                while peek() != "]":
                    yield key, value()
                    if peek() == "]":
                        break
                    take(",")
                    if peek() == "]":
                        raise ValueError("IE-C044 whole_stream_json trailing row comma")
                take("]")
            else:
                yield key, value()
            if peek() == "}":
                break
            take(",")
            if peek() == "}":
                raise ValueError("IE-C044 whole_stream_json trailing field comma")
        take("}")
        if "rows" not in seen or peek():
            raise ValueError("IE-C044 whole_stream_json missing rows or trailing bytes")


def file_digest(path):
    hashed = hashlib.sha256()
    with pathlib.Path(path).open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            hashed.update(block)
    return "sha256:" + hashed.hexdigest()


def name_json(text):
    result = ["anonymous"]
    for part in text.split("."):
        result = ["str", result, part]
    return result


def read(census_path, receipt_path, report_sha, head, expected_digest=None):
    receipt = json.loads(pathlib.Path(receipt_path).read_bytes())
    inputs = receipt["inputs"]
    if receipt["digest"] != digest(inputs) or (expected_digest is not None and
                                              receipt["digest"] != expected_digest):
        raise ValueError("IE-C044 whole_stream_receipt_digest")
    if inputs["head"] != head or inputs["export_sha256"] != report_sha:
        raise ValueError("IE-C044 whole_stream_report_binding")
    names = [name_json(m) for m in inputs["module_names"]]
    scopes = {canonical(name_json(root)): indices for root, indices in inputs["scopes"]}
    metadata, keys = {}, []
    hashed = hashlib.sha256()
    for field, row in fields(census_path):
        if field != "rows":
            metadata[field] = row
            continue
        keys.append({key: row[key] for key in ["theorem_name", "statement_id"]})
        if row["class"] == "observed":
            payload = row["payload"]
            indices = scopes.get(canonical(payload["root"]))
            if indices is None or payload["import_scope"] != {
                    "modules": [names[i] for i in indices], "completed": True}:
                raise ValueError("IE-C044 whole_stream_scope_binding")
            payload["import_scope"] = None
        hashed.update(canonical(row))
    rows_sha = "sha256:" + hashed.hexdigest()
    programs = dict(inputs["programs"])
    emitter = digest([(name, programs["tools/lean-inspector/Census/" + name][7:])
                      for name in ["phases.py", "emission_cache.py", "streaming.py"]])
    if (rows_sha != receipt["rows_sha256"] or inputs["expanded_rows_cache_key"] !=
            digest([rows_sha, inputs["module_names"], inputs["scopes"], emitter])):
        raise ValueError("IE-C044 whole_stream_rows_binding")
    if metadata.get("head_sha") != head or metadata.get("report_sha256") != report_sha:
        raise ValueError("IE-C044 whole_stream_report_binding")
    if (metadata.get("schema") != "lean-information-disposition-census" or
            metadata.get("query_verification") != "lean_streaming_query"):
        raise ValueError("IE-C044 whole_stream_schema")
    return keys, receipt["digest"]


def publish(census, output, certificate):
    """Preserve the validated J2 bytes and append the certificate metadata."""
    output = pathlib.Path(output)
    if output.resolve() == pathlib.Path(census).resolve():
        raise ValueError("IE-C044 publication output aliases handoff")
    temporary = output.with_suffix(output.suffix + ".tmp")
    with pathlib.Path(census).open("rb") as source, temporary.open("w+b") as destination:
        shutil.copyfileobj(source, destination, 1024 * 1024)
        position = destination.tell()
        while position:
            position -= 1
            destination.seek(position)
            if destination.read(1) not in b" \t\r\n":
                break
        destination.seek(position)
        if destination.read(1) != b"}":
            raise ValueError("IE-C044 whole_stream_json footer")
        destination.seek(position)
        destination.write(b"," + canonical(certificate)[1:])
        destination.truncate()
    temporary.replace(output)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--census", required=True, type=pathlib.Path)
    parser.add_argument("--receipt", type=pathlib.Path)
    parser.add_argument("--report-sha")
    parser.add_argument("--head")
    parser.add_argument("--digest")
    parser.add_argument("--output", required=True, type=pathlib.Path)
    parser.add_argument("--certificate", type=pathlib.Path)
    args = parser.parse_args()
    if args.certificate:
        publish(args.census, args.output, json.loads(args.certificate.read_bytes()))
    else:
        rows, _ = read(args.census, args.receipt, args.report_sha, args.head, args.digest)
        args.output.write_bytes(canonical(rows))


if __name__ == "__main__":
    main()
