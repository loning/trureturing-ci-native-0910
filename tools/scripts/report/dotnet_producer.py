"""MSBuild-owned source and semantic inputs of an executable project graph."""
import hashlib
import json
import pathlib
import subprocess
import tempfile
import xml.etree.ElementTree as ET


def project_inputs(root, project):
    paths = set()
    semantics = set()

    def add_file(path):
        path = path.resolve()
        if not path.is_file():
            raise ValueError(f"required producer input is absent: {path}")
        paths.add(path.relative_to(root))

    def query(project, *arguments):
        result = subprocess.run([
            "dotnet", "msbuild", str(root / project), "-nologo", "-noAutoResponse",
            "-nodeReuse:false", "-verbosity:quiet", "-property:Configuration=Release", *arguments,
        ], cwd=root, text=True, capture_output=True)
        if result.returncode:
            raise ValueError(f"MSBuild producer evaluation failed: {root / project}\n{result.stdout}{result.stderr}")
        return result.stdout

    add_file(root / "global.json")
    pending = [project]
    visited = set()
    properties = ("NETCoreSdkVersion", "TargetFramework", "RuntimeIdentifier", "DefineConstants",
                  "LangVersion", "Nullable", "ImplicitUsings", "Optimize", "AllowUnsafeBlocks",
                  "CheckForOverflowUnderflow", "PlatformTarget", "RestorePackagesWithLockFile",
                  "NuGetLockFilePath")
    while pending:
        project = pathlib.Path(pending.pop())
        if project in visited:
            continue
        visited.add(project)
        add_file(root / project)
        evaluated = json.loads(query(project,
            "-getItem:Compile,ProjectReference,AdditionalFiles,EmbeddedResource,Analyzer",
            "-getProperty:" + ",".join(properties)))
        if not evaluated["Items"]["Compile"]:
            raise ValueError(f"MSBuild returned no Compile inputs: {project}")
        for kind, items in evaluated["Items"].items():
            for item in items:
                path = pathlib.Path(item["FullPath"]).resolve()
                if kind == "Analyzer" and not path.is_relative_to(root):
                    semantics.add(("external-analyzer", hashlib.sha256(path.read_bytes()).hexdigest()))
                    continue
                add_file(path)
                if kind == "ProjectReference":
                    pending.append(path.relative_to(root))
        values = evaluated["Properties"]
        for name, value in values.items():
            semantics.add((f"{project}:{name}", value.replace(str(root), "@repository")))
        if values["RestorePackagesWithLockFile"].lower() == "true":
            add_file(root / project.parent / (values["NuGetLockFilePath"] or "packages.lock.json"))
        # /preprocess records the imports MSBuild actually evaluated, including
        # property-only imports absent from MSBuildAllProjects and item metadata.
        with tempfile.TemporaryDirectory(prefix="report-msbuild-") as temporary:
            expanded = pathlib.Path(temporary) / "project.xml"
            query(project, f"-preprocess:{expanded}")
            parser = ET.XMLParser(target=ET.TreeBuilder(insert_comments=True))
            document = ET.parse(expanded, parser=parser)
        imports = 0
        for node in document.iter(ET.Comment):
            lines = (node.text or "").strip().splitlines()
            if len(lines) < 3 or set(lines[0].strip()) != {"="} or lines[0] != lines[-1]:
                continue
            path = pathlib.Path(lines[-2].strip())
            if not path.is_absolute():
                continue
            imports += 1
            path = path.resolve()
            if path.is_relative_to(root):
                if "obj" not in path.relative_to(root).parts:
                    add_file(path)
            else:
                semantics.add(("external-build-input", hashlib.sha256(path.read_bytes()).hexdigest()))
        if not imports:
            raise ValueError(f"MSBuild returned no import provenance: {project}")
    return paths, semantics
