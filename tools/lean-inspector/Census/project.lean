import LeanInformationAudit.Census.Report

open Lean LeanInformationAudit LeanInformationAudit.DispositionCensus

def main (args : List String) : IO Unit := do
  let [inputPath, destination] := args | throw <| IO.userError "expected input and output"
  let input ← IO.ofExcept <| Json.parse (← IO.FS.readFile inputPath)
  let head ← IO.ofExcept <| input.getObjValAs? String "head"
  let scopes ← IO.ofExcept <| input.getObjValAs? (Array (String × Array String)) "scopes"
  let mut scopeMap : Std.HashMap Name ImportClosureScope := {}
  for (root, modules) in scopes do
    scopeMap := scopeMap.insert root.toName ⟨modules.map String.toName, true⟩
  let mut entries := #[]
  for row in ← IO.ofExcept <| input.getObjValAs? (Array Json) "rows" do
    let scope ← if (← IO.ofExcept <| stringField row "class") == "observed" then do
      let payload ← IO.ofExcept <| row.getObjVal? "payload"
      let root ← IO.ofExcept <| parseNameJson (← IO.ofExcept <| payload.getObjVal? "root")
      let some scope := scopeMap[root]? | throw <| IO.userError "IE-C044 row root is missing"
      pure (some scope)
    else pure none
    entries := entries.push (← IO.ofExcept <| parseRow row scope)
  let inventory := DispositionInventory.mk head entries
  IO.ofExcept <| checkInventoryDuplicates (entries.map (·.1))
  let counts := count inventory
  -- Incomplete rows are diagnostic output only; certificate admission retains
  -- its existing rejection of incomplete observations.
  if counts.observedQueryIncomplete == 0 then IO.ofExcept <| checkCounts inventory counts
  let mut rows := #[]
  for row in inventory.sortedEntries do
    -- Retain shared scopes during transport; emission expands the same bytes.
    let json := match row.2 with
      | .observed value => dispositionRowJson ⟨row.1, .observed {value with importScope := ⟨#[], true⟩}⟩
      | _ => dispositionRowJson row
    let json := if let .observed _ := row.2 then
      json.setObjVal! "payload" ((← IO.ofExcept <| json.getObjVal? "payload").setObjVal! "import_scope" Json.null)
      else json
    rows := rows.push json
  IO.FS.writeFile destination (Json.mkObj [("counts", toJson counts), ("rows", toJson rows)]).compress
