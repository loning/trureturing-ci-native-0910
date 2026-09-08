"""Discover executable script and local Python dependencies from producer entrypoints."""
import ast
import hashlib
import json
import pathlib
import re
import sys
from dotnet_producer import project_inputs

root = pathlib.Path(sys.argv[1]).resolve()
scope = sys.argv[2]
inspector_entrypoint = pathlib.PurePosixPath("tools/lean-inspector/inspect.sh")
inspector_root = root / "tools" / "lean-inspector"
if scope == "lean-report":
    entrypoints = (
        inspector_entrypoint,
        pathlib.PurePosixPath("tools/scripts/lean-report-pair.sh"),
        pathlib.PurePosixPath("tools/scripts/report/lean-report-input.sh"),
        # LeanArchiveFetch.Run executes this optional seed fetcher under the C# writer guard.
        pathlib.PurePosixPath("tools/scripts/worktree/lean-cache-publish.sh"),
    )
elif scope == "scribe-content":
    entrypoints = (
        pathlib.PurePosixPath("tools/scripts/workflow/scribe-content-checks.sh"),
    )
else:
    raise SystemExit(f"lean-report-input: unknown producer scope: {scope}")
reference_pattern = re.compile(
    r"(?P<path>(?:\$[A-Za-z_][A-Za-z0-9_]*|\$\{[A-Za-z_][A-Za-z0-9_]*\}|[A-Za-z0-9_.-]+)"
    r"(?:/[A-Za-z0-9_.$@{}+-]+)+\.(?:sh|py|csproj))(?![A-Za-z0-9_.])"
)


def source_text(relative):
    path = root.joinpath(*relative.parts).resolve()
    try:
        path.relative_to(root)
    except ValueError as error:
        raise SystemExit(f"lean-report-input: producer script escaped repository: {relative}") from error
    if relative == inspector_entrypoint and not path.is_file() and not inspector_root.exists():
        return None
    if not path.is_file():
        raise SystemExit(f"lean-report-input: reachable producer input is absent: {relative}")
    text = path.read_text(encoding="utf-8")
    return text


def normalize(reference, source):
    if "/candidate/" in reference:
        reference = reference.split("/candidate/", 1)[1]
    elif reference.startswith("candidate/"):
        reference = reference[len("candidate/"):]
    elif reference.startswith("$"):
        reference = reference.split("/", 1)[1]
        if reference.startswith("candidate/"):
            reference = reference[len("candidate/"):]
    if reference.startswith(("tools/", ".github/")):
        candidate = pathlib.PurePosixPath(reference)
    else:
        candidate = source.parent.joinpath(pathlib.PurePosixPath(reference))
    normalized = pathlib.PurePosixPath(pathlib.PurePosixPath(candidate).as_posix())
    parts = []
    for part in normalized.parts:
        if part in ("", "."):
            continue
        if part == "..":
            if not parts:
                raise SystemExit(f"lean-report-input: producer script escaped repository: {reference}")
            parts.pop()
        else:
            parts.append(part)
    return pathlib.PurePosixPath(*parts)


pending = list(entrypoints)
reachable = set()
semantics = set()
while pending:
    source = pending.pop()
    if source in reachable:
        continue
    text = source_text(source)
    if text is None:
        continue
    reachable.add(source)
    if source.suffix == ".csproj":
        try:
            inputs, values = project_inputs(root, source)
        except (ValueError, KeyError, OSError) as error:
            raise SystemExit(f"lean-report-input: {error}") from error
        reachable.update(pathlib.PurePosixPath(path.as_posix()) for path in inputs)
        semantics.update(values)
        continue
    if source.suffix == ".py":
        for node in ast.walk(ast.parse(text, filename=str(source))):
            if isinstance(node, ast.Import):
                imports = [alias.name for alias in node.names]
            elif isinstance(node, ast.ImportFrom):
                imports = [node.module] if node.module else []
            else:
                continue
            for name in imports:
                for directory in (source.parent, pathlib.PurePosixPath("tools/scripts/worktree")):
                    local = directory / (name.replace(".", "/") + ".py")
                    if root.joinpath(*local.parts).is_file():
                        pending.append(local)
        continue
    if source.suffix != ".sh":
        continue
    for match in reference_pattern.finditer(text):
        if text[max(0, match.start() - 3):match.start()] == "://":
            continue
        if match.group("path").endswith(".csproj") and not re.search(
                r"--project\s+[\"']?$", text[:match.start()]):
            continue
        referenced = normalize(match.group("path"), source)
        if referenced not in reachable:
            pending.append(referenced)

for relative in sorted(reachable, key=lambda path: path.as_posix().encode("utf-8")):
    print(relative.as_posix())

if len(sys.argv) == 4:
    value = json.dumps(sorted(semantics), separators=(",", ":")).encode("utf-8")
    pathlib.Path(sys.argv[3]).write_text(hashlib.sha256(value).hexdigest() + "  @msbuild-semantics\n",
                                      encoding="utf-8")
