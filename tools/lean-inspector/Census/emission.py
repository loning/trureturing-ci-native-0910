"""Emit pure Lean data from successful Lean query results, without importing targets."""

import json


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


def display(value):
    if value == ["anonymous"]:
        return ""
    prefix = display(value[1])
    return (prefix + "." if prefix else "") + str(value[2])


def array(values):
    return "#[" + ", ".join(values) + "]"


def row(value, scope):
    key = f"(StatementKey.mk {name(value['theorem_name'])} {string(value['statement_id'])})"
    payload = value["payload"]
    kind = value["class"]
    if kind == "observed":
        fields = [name(payload["owning_module"]), name(payload["root"]), scope,
                  "true" if payload["query_completed"] else "false",
                  array(map(name, payload["candidates"])), string(payload["note"])]
        assessment = "(.observed (AnalysisObservation.mk " + " ".join(fields) + "))"
    else:
        constructors = {
            "finite_occurrence": ("finiteOccurrence", "FiniteOccurrenceDisposition", [
                "canonical_arena", "registration", "realization", "nondegeneracy_certificate",
                "state_enumeration_certificate"]),
            "structural_occurrence": ("structuralOccurrence", "StructuralOccurrenceDisposition", [
                "canonical_arena", "registration", "realization", "strictness_certificate",
                "witness_certificate"]),
        }
        if kind in constructors:
            case, constructor, fields = constructors[kind]
            body = f"({constructor}.mk " + " ".join(name(payload[field]) for field in fields) + ")"
        elif kind == "bounded_finite_truncation":
            case = "boundedFiniteTruncation"
            certification = payload["certification"]
            status = (".reportOnly" if certification["kind"] == "report_only" else
                      f"(.transferred {name(certification['transfer_theorem'])})")
            body = (f"(BoundedFiniteTruncationDisposition.mk {name(payload['truncation_family'])} "
                    f"{payload['bound']} {name(payload['comparison_statement'])} {status})")
        elif kind == "unreachable":
            case = "unreachable"
            reasons = {"no_canonical_object_carrier": "noCanonicalObjectCarrier",
                       "no_finite_primitive_bundle": "noFinitePrimitiveBundle",
                       "no_faithful_primitive_realization": "noFaithfulPrimitiveRealization"}
            body = f"(UnreachableDisposition.mk .{reasons[payload['reason']]} {name(payload['evidence'])})"
        else:
            raise ValueError(f"unknown census class: {kind}")
        assessment = f"(.certified (.{case} {body}))"
    return f"Sigma.mk {key} {assessment}"


def write_module(directory, module, contents):
    path = directory.joinpath(*module.split(".")).with_suffix(".lean")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(contents, encoding="utf-8")
    return path


def module_pool(directory, module, results):
    names = {json.dumps(value): value for result in results for value in result["scope"]["modules"]}
    ordered = sorted(names)
    indexes = {key: index for index, key in enumerate(ordered)}
    parts = []
    for start in range(0, len(ordered), 100):
        number = start // 100
        part = f"{module}.Group{number // 20:04d}.Names{number:05d}"
        source = ("import Lean\n" + f"def {part}.names : Array Lean.Name :=\n  "
                  + array(name(names[key]) for key in ordered[start:start + 100]) + "\n")
        parts.append((part, write_module(directory, part, source)))
    source = "".join(f"import {part}\n" for part, _ in parts)
    source += f"def {module}.names : Array Lean.Name :=\n  "
    source += " ++ ".join(part + ".names" for part, _ in parts) + "\n"
    source += f"@[noinline] def {module}.get (index : Nat) : Lean.Name := {module}.names[index]!\n"
    return parts + [(module, write_module(directory, module, source))], indexes


def scope_module(directory, module, result, pool, indexes):
    modules = string(json.dumps([indexes[json.dumps(value)] for value in result["scope"]["modules"]]))
    contents = ("import LeanInformationAudit.Census.Publish\n" + f"import {pool}\n"
                "open LeanInformationAudit\n"
                f"private def {module}.indices : Array Nat :=\n"
                f"  ((Lean.Json.parse {modules} >>= Lean.fromJson?).toOption.getD #[])\n"
                f"opaque {module}.scope : ImportClosureScope :=\n"
                f"  ImportClosureScope.mk ({module}.indices.map {pool}.get) true\n"
                f"def {module}.record : CensusProjection.Scope :=\n"
                f"  CensusProjection.Scope.mk {name(result['root'])} {module}.scope\n")
    return write_module(directory, module, contents)


def rows_module(directory, module, rows):
    imports = sorted({scope for _, scope in rows})
    contents = "".join(f"import {scope}\n" for scope in imports)
    contents += "open LeanInformationAudit\n"
    contents += f"def {module}.rows : Array (Sigma fun key : StatementKey => CensusAssessment key) := #[\n"
    contents += ",\n".join("  " + row(value, scope + ".scope") for value, scope in rows) + "]\n"
    return write_module(directory, module, contents)
