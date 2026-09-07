"""Private runtimes shared by the Lean cache and report behavior fixtures."""

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
if args[:2] == ["release", "list"] and "FAKE_LIST_JSON" in os.environ:
    print(os.environ["FAKE_LIST_JSON"]); sys.exit(0)
if args[0] == "api" and "FAKE_API_JSON" in os.environ:
    print(os.environ["FAKE_API_JSON"]); sys.exit(0)
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
