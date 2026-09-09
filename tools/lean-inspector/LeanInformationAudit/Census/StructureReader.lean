import LeanInformationAudit.NameWire
import LeanInformationAudit.StatementEncoding
import LeanInformationAudit.DeclarationDependencies

namespace LeanInformationAudit.CensusStructure

open Lean

def kind (info : ConstantInfo) : String :=
  match info with
  | .thmInfo _ => "theorem"
  | .axiomInfo _ => "axiom"
  | .defnInfo _ => "def"
  | .opaqueInfo _ => "opaque"
  | .quotInfo _ => "quotient"
  | _ => "other"

/-- Raw summaries do not depend on the frozen set or core policy. In particular,
a newly frozen helper reuses its raw summary and changes the projection cut. -/
def summary (info : ConstantInfo) : Json :=
  Json.mkObj [("name", toJson (encodeName info.name)), ("kind", toJson (kind info)),
    ("value", toJson ((declarationValueDependencies info).map (·.map encodeName))),
    ("type", toJson ((declarationTypeDependencies info).map encodeName))]

@[noinline] private unsafe def emitPart (moduleName part : String) (data : ModuleData)
    (bodies : Bool) (out : IO.FS.Stream) : IO Unit := do
  out.putStrLn (Json.mkObj [("module", toJson moduleName), ("part", toJson part),
    ("imports", toJson (data.imports.map (·.module.toString)))]).compress
  if bodies then
    for info in data.constants do out.putStrLn (summary info).compress
  else
    -- Membership only at the package boundary; upstream proof values are never walked.
    for name in data.constNames do
      out.putStrLn (Json.mkObj [("name", toJson (encodeName name))]).compress

/-- No region-backed Name, Expr or JSON escapes this lifetime. Parts are read
together and released in reverse order, including server/private overrides. -/
@[noinline] private unsafe def readOne (moduleName : String) (paths : Array String)
    (bodies : Bool) (out : IO.FS.Stream) : IO (Array CompactedRegion) := do
  let parts ← readModuleDataParts (paths.map System.FilePath.mk)
  let mut regions := #[]
  for h : i in [:parts.size] do
    let (data, region) := parts[i]
    emitPart moduleName (#["base", "server", "private"][i]!) data bodies out
    regions := regions.push region
  return regions

unsafe def scan (manifest destination mode : String) : IO Unit := do
  let modules ← IO.ofExcept <| (Json.parse (← IO.FS.readFile manifest)).bind
    (fromJson? (α := Array (String × Array String)))
  let out ← if destination == "-" then IO.getStdout else
    IO.FS.Stream.ofHandle <$> IO.FS.Handle.mk destination .write
  for (moduleName, paths) in modules do
    unless paths.size ≥ 1 && paths.size ≤ 3 do
      throw <| IO.userError "missing_olean_part"
    let regions ← readOne moduleName paths (mode == "bodies") out
    for region in regions.reverse do region.free
    out.flush

end LeanInformationAudit.CensusStructure
