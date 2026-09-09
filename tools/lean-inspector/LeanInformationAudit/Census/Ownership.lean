import Lean

namespace LeanInformationAudit.CensusOwnership

open Lean

/-- Realized reserved theorems can occur in several modules. The first-import
index is provenance for lookup, not a unique ownership authority. -/
def moduleContainsTheorem (data : ModuleData) (info : ConstantInfo) : Bool :=
  info.isTheorem && data.constNames.contains info.name &&
    data.constants.any (fun localInfo => localInfo.name == info.name && localInfo.isTheorem &&
      localInfo.type == info.type && localInfo.levelParams == info.levelParams)

def recordedModuleContainsTheorem (env : Environment) (scope : Array Name)
    (owner declaration : Name) : IO Bool := do
  unless scope.contains owner do return false
  let some info := env.find? declaration | return false
  if owner == env.header.mainModule then
    return moduleContainsTheorem (<- mkModuleData env) info
  let some index := env.getModuleIdx? owner | return false
  return moduleContainsTheorem env.header.moduleData[index.toNat]! info

end LeanInformationAudit.CensusOwnership
