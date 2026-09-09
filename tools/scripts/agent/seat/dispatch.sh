#!/usr/bin/env bash
# dispatch.sh — 派一个 codex-cli 席位:解析 sshx runner → 过负载门 → 单次直调 → 落哨兵。
# usage: dispatch.sh FLIGHT_ID ATTEMPT BRIEF WORKTREE STAGE [STAGGER_SECONDS] [MAX_CODEX]
#        dispatch.sh --selftest
# STAGE ∈ thinking|implementation|review|termination。哨兵:RUNNER_EXIT=<n>
# (判终局仍须 result.json + completion sentinel 双在,本行只是载体退出码,见器律⑥)
#
# 立条依据 issue #6220(器只放在 scratchpad,活会话中途被整目录清空)。本器此前只存在于
# scratchpad,故每台驱动机各写一份、各带各的 bug;入仓后这笔学费只付一次(器律⑨ / 第 8.9 条)。
#
# 2026-09-09 实测的两条缺陷,是把它搬进来的**直接理由**,不是顺手改的风格:
#
#  ①**runner 版本钉死在最老的一版**。scratchpad 版写死
#    `consensus-rnd/1.0.0-beta.31/skills/sshx/scripts/run-codex-worker.sh`,而本机当时装了
#    **五个**版本(beta.31/.32/.36/.37/.42)。于是当天派出的每一席都跑在最老的 runner 上,
#    而这**不会有任何症状** —— 老路径还在,脚本照常退出 0。这正是第 9.2 条所指的
#    「无检测的引用是断链」:指错了没人比,永远不会红。
#    修法是解析而非钉死,且**解析不到就 fail-closed**(第 2.1 条),不许静默回退。
#    版本序必须用 `sort -V`:纯字典序在出现 `beta.9` 时会把它排在 `beta.42` 之后。
#
#  ②**负载门跑满即静默放行**。scratchpad 版是 `for i in $(seq 1 240)`,门若一直不过,
#    循环结束后**照常 dispatch**,且不打任何字。2 小时的等待与「门通过」在输出上无法区分,
#    正是第 2.1 条禁的浮账。此处改为超时即 GATE_TIMEOUT + 非零退出。
#
# 本器是**胶水**(编排 runner、top、pgrep),按第 9.1 条辨析不建单元测试套件;
# 其义务是三样:开头 fail-fast 断言全部输入、哨兵退出码、可安全重跑。--selftest 钉住前两样。

set -uo pipefail

RUNNER_GLOB="${SSHX_PLUGIN_ROOT:-$HOME/.claude/plugins/cache/consensus-rnd/consensus-rnd}"

# 解析已安装的最新 sshx runner。找不到即 fail-closed —— 不回退到任何猜测路径。
resolve_runner() {
  local root="$1" newest
  newest=$(ls -d "$root"/*/ 2>/dev/null | sed 's|.*/\([^/]*\)/$|\1|' | sort -V | tail -1)
  [ -n "$newest" ] || return 1
  local candidate="$root/$newest/skills/sshx/scripts/run-codex-worker.sh"
  [ -f "$candidate" ] || return 1
  printf '%s\n' "$candidate"
}

# selftest 的每个子调用都必须 hermetic:存根 runner + 单轮 gate + 零 sleep。否则删掉任一输入断言,
# 该用例就会掉进**真实**的 240×30s 负载门,selftest 变成挂起而不是变红 —— 挂起不是红(第 9.3 条),
# 且第 9.6 条禁止真实等待承判词。这一条是变异实验逼出来的:M3 删掉 brief 断言后正是如此挂住。
hermetic() { local t="$1"; shift
  SSHX_PLUGIN_ROOT="$t/plugins" DISPATCH_GATE_ROUNDS=1 DISPATCH_GATE_SLEEP=0 "$0" "$@"; }

selftest() {
  local fails=0 tmp; tmp=$(mktemp -d); trap 'rm -rf "$tmp"' RETURN
  # 版本序:beta.9 必须排在 beta.42 之前(纯 sort 会判反,这正是用 -V 的理由)
  mkdir -p "$tmp/plugins/1.0.0-beta.9/skills/sshx/scripts" \
           "$tmp/plugins/1.0.0-beta.42/skills/sshx/scripts"
  : > "$tmp/plugins/1.0.0-beta.9/skills/sshx/scripts/run-codex-worker.sh"
  : > "$tmp/plugins/1.0.0-beta.42/skills/sshx/scripts/run-codex-worker.sh"
  local got; got=$(resolve_runner "$tmp/plugins" || echo NONE)
  case "$got" in
    *1.0.0-beta.42*) echo "  ok   resolve picks newest by version order" ;;
    *) echo "  FAIL resolve picked '$got', expected beta.42"; fails=$((fails + 1)) ;;
  esac
  # fail-closed:目录在而 runner 不在
  mkdir -p "$tmp/empty/1.0.0-beta.1"
  if resolve_runner "$tmp/empty" >/dev/null 2>&1; then
    echo "  FAIL resolve succeeded with no runner present"; fails=$((fails + 1))
  else
    echo "  ok   resolve fails closed when the runner file is absent"
  fi
  # fail-closed:根本没有插件根
  if resolve_runner "$tmp/absent" >/dev/null 2>&1; then
    echo "  FAIL resolve succeeded with no plugin root"; fails=$((fails + 1))
  else
    echo "  ok   resolve fails closed when the plugin root is absent"
  fi
  # 输入断言:brief 缺失必须以 3 退出,且不得触及 runner
  : > "$tmp/brief.md"; mkdir -p "$tmp/wt"
  hermetic "$tmp" f 1 "$tmp/missing-brief.md" "$tmp/wt" review 0 1 >"$tmp/o" 2>&1
  [ $? -eq 3 ] && grep -q 'brief-missing' "$tmp/o" \
    && echo "  ok   missing brief exits 3" \
    || { echo "  FAIL missing brief: rc=$? out=$(cat "$tmp/o")"; fails=$((fails + 1)); }
  hermetic "$tmp" f 1 "$tmp/brief.md" "$tmp/absent-wt" review 0 1 >"$tmp/o" 2>&1
  [ $? -eq 3 ] && grep -q 'worktree-missing' "$tmp/o" \
    && echo "  ok   missing worktree exits 3" \
    || { echo "  FAIL missing worktree: rc=$? out=$(cat "$tmp/o")"; fails=$((fails + 1)); }
  # 负载门超时必须**拒派**。这一条是补上来的:第一版 selftest 五条全绿,
  # 而把 gate_ok 判断整块删掉一条都不红 —— 即缺陷②本身没有钉子(第 9.3 条六元组第六项)。
  # 指向 $tmp/plugins 的**空 runner 存根**:即使 gate 守卫被删,fall-through 也只是执行一个
  # 空文件后立刻返回,而不是真派席位挂住。删掉守卫时得到一条具名 FAIL,不是一次超时
  # —— 消掉挂起,而不是给挂起加看门狗(第 9.6 条:真实等待永不承判词)。
  hermetic "$tmp" f 1 "$tmp/brief.md" "$tmp/wt" review 0 0 >"$tmp/o" 2>&1
  rc=$?
  if [ "$rc" -eq 4 ] && grep -q 'GATE_TIMEOUT' "$tmp/o"; then
    echo "  ok   gate timeout refuses to dispatch (exit 4)"
  else
    echo "  FAIL gate timeout: rc=$rc out=$(cat "$tmp/o")"; fails=$((fails + 1))
  fi
  echo "SELFTEST_FAILS=$fails"; [ "$fails" -eq 0 ]
}

[ "${1:-}" = "--selftest" ] && { selftest; exit $?; }

FLIGHT="${1:?flight id}"; ATT="${2:?attempt}"; BRIEF="${3:?brief}"
WT="${4:?worktree}"; STAGE="${5:?stage}"; STAGGER="${6:-0}"; MAXC="${7:-12}"

[ -f "$BRIEF" ] || { echo "DISPATCH_FAIL brief-missing $BRIEF"; exit 3; }
[ -d "$WT" ]    || { echo "DISPATCH_FAIL worktree-missing $WT"; exit 3; }
case "$STAGE" in
  thinking|implementation|review|termination) ;;
  *) echo "DISPATCH_FAIL bad-stage '$STAGE' (thinking|implementation|review|termination)"; exit 3 ;;
esac

RUNNER=$(resolve_runner "$RUNNER_GLOB") || {
  echo "DISPATCH_FAIL runner-unresolved under $RUNNER_GLOB"; exit 3; }
echo "RUNNER $RUNNER"

[ "$STAGGER" -gt 0 ] && sleep "$STAGGER"

# 负载门。等的是宿主负载,没有自带同步原语,故轮询合法(第 8.7 条辨析);
# 但按该条要求:间隔与被等事件节奏对齐、有上限、每轮带读数,且**判据写在开跑之前**。
GATE_ROUNDS="${DISPATCH_GATE_ROUNDS:-240}"; gate_ok=0
for _ in $(seq 1 "$GATE_ROUNDS"); do
  idle=$(top -l 2 -s 2 -n 0 | grep 'CPU usage' | tail -1 | grep -o '[0-9.]*% idle' | tr -d '% idle')
  lean=$(pgrep -f '^(/bin/)?bash [^ ]*report-supervisor\.sh' | wc -l | tr -d ' ')
  cdx=$(pgrep -f 'codex exec' | wc -l | tr -d ' ')
  if python3 -c "import sys; sys.exit(0 if float('${idle:-0}')>=20 and $lean<=4 and $cdx<$MAXC else 1)" 2>/dev/null; then
    echo "GATE_PASS idle=$idle lean=$lean codex=$cdx brief=$BRIEF"; gate_ok=1; break
  fi
  sleep "${DISPATCH_GATE_SLEEP:-30}"
done
# 门不过就不派 —— 静默放行会让「等了两小时」与「门通过」在输出上无法区分(第 2.1 条)。
[ "$gate_ok" = "1" ] || {
  echo "GATE_TIMEOUT rounds=$GATE_ROUNDS idle=${idle:-?} lean=${lean:-?} codex=${cdx:-?}"; exit 4; }

RUNROOT="${TMPDIR:-/tmp}/consensus-rnd/sshx"
while [ -e "$RUNROOT/$FLIGHT/attempt-$ATT" ]; do
  ATT=$((ATT + 1))
  [ "$ATT" -gt 40 ] && { echo "DISPATCH_FAIL no-free-attempt for $FLIGHT"; exit 3; }
done
echo "FLIGHT $FLIGHT attempt=$ATT"

bash "$RUNNER" --flight-id "$FLIGHT" --attempt "$ATT" --stage "$STAGE" --work-target "$WT" < "$BRIEF"
echo "RUNNER_EXIT=$?"
