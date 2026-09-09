"""Receipt negatives rerun the Lean read and membership phases."""

import json
import shutil

from phases import read, write
from streaming import hash_inputs, replay
from negative_fixtures import PREFIX, key, lean, lean_env


def check_receipts(repository, directory):
    folder = directory / "receipt-byte"
    folder.mkdir(parents=True, exist_ok=True)
    module = PREFIX + "StreamingTarget"
    original = repository / ".lake/build/lib/lean" / (module.replace(".", "/") + ".olean")
    copy = folder / "Target.olean"
    shutil.copyfile(original, copy)
    target = key("StreamingTarget", "StreamingTarget.target")
    write(folder / "manifest.json", [[module, [str(copy)]]])
    write(folder / "request.json", {"keys": [target], "roots": [["Fixture.Root", [module]]],
        "assignment": {module: "Fixture.Root"}, "discovery_roots": [module],
        "external_graph": read(directory / "external.json")})
    env = lean_env(repository)
    def scan():
        try:
            lean(repository, folder, "scan.lean", [folder / "manifest.json", folder / "request.json",
                 folder / "index.jsonl"], "reread", env)
            lean(repository, folder, "membership.lean", [folder / "index.jsonl", folder / "request.json",
                 folder / "membership.json"], "recompute", env)
        except RuntimeError as error:
            raise ValueError("IE-C044 receipt replay rejected changed olean") from error
        return {"membership": read(folder / "membership.json"),
                "oleans": hash_inputs([(module, "base", str(copy))])}
    expected = scan()
    write(folder / "receipt.json", expected)
    content = bytearray(copy.read_bytes())
    content[0] ^= 1
    copy.write_bytes(content)
    try:
        replay(scan, expected)
    except ValueError as error:
        assert "IE-C044 receipt replay" in str(error), "streamReceiptReplayMismatch"
    else:
        raise AssertionError("streamReceiptReplayMismatch: changed olean accepted")
    return [{"name": "receipt_replay_changed_olean", "status": "passed", "changed_bytes": 1,
             "reread": True, "fresh_index_required": True}]
