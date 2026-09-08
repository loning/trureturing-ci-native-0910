#!/usr/bin/env bash
# op-body-shapes.sh WORKTREE MODULE_DOTTED — per-public-declaration evidence table for a deposit PR body.
#
# Three review seats on two PRs asked for the same thing: first-freeze evidence reported per public
# theorem, not one module-wide paragraph. This runs the kernel-derived edge/axiom extractor in the
# worktree and prints a table whose machine columns come from the elaborated environment.
#
# This table gives NO verdict. Three attempts to make the machine classify proof shape each produced a
# fabrication: "a live path through a module theorem implies content" (a seat rejected it), "no module
# theorem on the live path implies bind-only" (wrong for a multi-step estimate built from Mathlib), and
# "closed type plus a decide marker implies a numeric certificate" (it fired on a two-line derivation
# whose only decide marker arrived transitively). The machine reports facts — dependencies, external
# dependencies, axioms, whether the type is closed, whether a decision procedure appears — and the
# proposer states the shape and the witness in the PR body, where a review seat can overturn it.
set -uo pipefail
W="${1:?worktree}"; MOD="${2:?module dotted}"
SP="$(cd "$(dirname "$0")" && pwd)"
# Intermediates go to a scratch dir. This tool lives in the repository now, so writing beside itself
# would dirty the working tree; WORK can be overridden by the caller.
WORK="${WORK:-${TMPDIR:-/tmp}/deposit-evidence}"; mkdir -p "$WORK"
OUT="$WORK/edges-$(echo "$MOD" | tr '.' '_').json"
bash "$SP/proof-edges.sh" "$W" "$MOD" "$OUT" >&2 || { echo "(内核判形不可用:边提取失败,本表退化为仅事件字段)"; exit 0; }
python3 - "$W" "$OUT" "$SP" <<'PY'
import json, os, re, subprocess, sys

w, edges_path, tooldir = sys.argv[1], sys.argv[2], sys.argv[3]
eg = json.load(open(edges_path))
changed = subprocess.run(["git", "-C", w, "diff", "--name-only", "origin/dev...HEAD"],
                         capture_output=True, text=True).stdout.split()
event = [p for p in changed if p.startswith("Golden/Frozen/accepted/")]
ev = json.load(open(os.path.join(w, event[0])))
p = ev.get("payload", ev)
mod_comps = p.get("descriptor_selector", "")[:-5].split("/")

GEN = re.compile(r'\.(eq_def|eq_\d+|match_\d+(_\d+)*|proof_\d+(_\d+)*|sizeOf_spec|_sizeOf_inst|_sizeOf_\d+'
                 r'|_f|_sunfold|_unsafe_rec|_mutual|injEq|inj|noConfusion\w*|noConfusionType|rec|recOn'
                 r'|casesOn|mk\.\w+|below|brecOn|ibelow|binductionOn|ctorIdx|_flat_ctor)$|\._sizeOf')


def nm(key):
    c = re.findall(r'\d+:([^)]+)\)', key)
    return '.'.join(c[len(mod_comps):]) if c[:len(mod_comps)] == mod_comps else '.'.join(c)


src_path = os.path.join(w, p.get("descriptor_selector", ""))
src = open(src_path, encoding="utf-8").read() if os.path.exists(src_path) else ""
# One parser, one place. This regex used to be duplicated here; when facts.py was fixed and this
# copy was not, the two tools disagreed by exactly the declaration the first bug had hidden.
sys.path.insert(0, tooldir)
from facts import AUTHORED
authored = {m.group(2) for m in AUTHORED.finditer(src)}

edges = eg.get("edges", {})
axioms = eg.get("axioms", {})
numeric = eg.get("numeric_certificate", {})
ext = eg.get("external_deps", {})
undecided = []
rows_order = []
kinds = {}

print("| 公开声明 | kind | 类型闭合 | 直接依赖含判定程序标记 | 模块内直接依赖(consumer → prerequisite) | 模块外依赖 | axioms |")
print("|---|---|---|---|---|---|---|")
for d in p.get("declaration_statement_ids", []):
    name = nm(d.get("declaration_name_key", ""))
    if name not in authored or GEN.search(name):
        continue
    kind = d.get("kind", "")
    rows_order.append(name)
    kinds[name] = kind
    inner = sorted(set(edges.get(name, [])))
    outer = sorted(set(ext.get(name, [])))
    ax = axioms.get(name, "?")
    if False:
        pass
    else:
        # No machine bind-only rule. CLAUDE.md 5-quadruple-prime makes a conclusion bind-only when it
        # follows by instantiation, projection or normalization of frozen results — not merely when no
        # module theorem sits on its live path. A multi-step analytic estimate assembled from several
        # Mathlib lemmas has no module theorem on its path and is still not an instantiation of one.
        # An earlier version of this table judged such a theorem bind-only; that was the same
        # fabrication a seat already rejected in the opposite direction, so the middle stays 未判.
        undecided.append(name)
    # No truncation. These columns are the evidence a seat checks against the proof term; a review seat
    # caught an earlier version silently dropping three of eight direct dependencies behind `[:5]`.
    inner_s = ", ".join(f"`{e}`" for e in inner) or "无"
    outer_s = ", ".join(f"`{e}`" for e in outer) or "无"
    closed = "是" if numeric.get(name + "::closed", numeric.get(name)) is not None else "—"
    dec = "是" if numeric.get(name) else "否"
    print(f"| `{name}` | {kind} | {closed} | {dec} | {inner_s} | {outer_s} | {ax} |")

print()
# A judgment-table skeleton whose dependency column is machine-filled. The proposer fills only the
# verdict and the reason; retyping the dependencies by hand is what went wrong three times.
print("\n### 判词段骨架(依赖列由机器填,判形与理由由提出方填)\n")
print("复制到 PR 正文后逐行补 `proof_shape` 与理由。**依赖列不要手改**——它是从内核边导出的。\n")
print("| 公开声明 | proof_shape | 模块内直接依赖(划掉 def 后) | 模块外依赖 | 理由 |")
print("|---|---|---|---|---|")
defs = {d for d in kinds if kinds[d] == "def"}
for name in rows_order:
    inner = [x for x in sorted(set(edges.get(name, []))) if x.split(" ")[0] not in defs]
    outer = sorted({o.split(":")[-1].split(".")[-1] for o in set(ext.get(name, []))})
    print("| `%s` | **待填** | %s | %s | 待填 |" % (
        name,
        ", ".join("`%s`" % i for i in inner) or "无",
        ", ".join("`%s`" % o for o in outer) or "无"))

print("**本表不给判形**。机器三次尝试分类都产出了伪造结论(经本模块定理即 content;活路径无本模块定理即 bind-only;"
      "类型闭合且出现判定程序即数值证书——第三条在一条两行推导上误触发)。故此表只报事实:"
      "kind、类型是否闭合、**直接**依赖里是否出现判定程序标记(`decide` / `norm_num` 一族)、"
      "内核直接依赖、模块外依赖、axioms。"
      "**注意该列只看直接依赖**:一条自身用 `decide` 但把它藏在私有引理里的定理,这一列会显示「否」;"
      "而一条只是引用了它的定理反而可能显示「是」。它是原始事实,不是「谁在做计算」的答案。"
      "**`proof_shape` 与 `escape_witness` 由提出方在正文的判词段逐条给出并说明理由,评审席可推翻**(5⁗)。"
      + (f"本表共 {len(undecided)} 条定理待判词段处理。" if undecided else ""))
print()
print("依赖两列由内核环境导出(`Expr.getUsedConstants` 于证明项与类型,展开辅助常量),不是文本扫描;"
      "`axioms` 列由 `Lean.collectAxioms` 得出。")
PY
