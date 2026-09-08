#!/usr/bin/env bash
# nyx.sh — nyxid 派票与状态分类。**不要再用 `tail -1` 肉眼判成败。**
#
# Caller contract: every ask/fetch invocation starts a NEW RUN for <out>.
# Append previous <out> bytes to <out>.history after a line
# NYX_RUN_BOUNDARY <utc-stamp> <verb>, then truncate <out>. History is audit only.
# Completion readers (status, await make/vote, tail) see RUNNING/no EXIT= until
# this run's sole terminal EXIT=<rc>. Unwritable artifacts fail with NYX_IO.
# <out>.taskid is append-only across runs; its last line is the current task ID.
# Use `nyx.sh taskid <out>` (prints that ID or exits 1), never parse the sidecar.
# ask submits afresh, including after terminal EXTRACTION/QUOTA/BUSY failures;
# fetch resumes the supplied task. A TIMEOUT still has a live task: use fetch.
# await vote follows the command verdict; successful traversal settles the vote.
#
# 立条依据(2026-08-28):我用「tail -1 != EXIT=0」当失败的代理,它把**四个状态**混成一个:
#   110B  Failed to read prompt   —— 我自己的 mkrev bug
#   153B  extraction_failure      —— 载体侧随机,可重投
#   178B  waiting_response        —— **还在跑,根本不是失败**
#   248B  HTTP 429 quota_exceeded —— **我自己把池打满了**
# 契约就写在 429 的 body 里:`limit 4` 并发。我从没读到它,因为代理把它藏了。
# 而误读直接导致错误决策:读到「6 投全败」于是投得更多 → 更多 429。
#
# 用法:
#   nyx.sh ask <brief> <outfile>     投一票;NYX_POOL 未设时**按池排名遍历**(见 pools),载体侧失败换下一池
#   nyx.sh fetch <task-id> <out>     续等一个已提交的任务(ask 超时后用它,不重复提交)
#   nyx.sh taskid <out>             Print the authoritative current task ID, or exit 1.
#   nyx.sh pools                     打印全部 active 池的排名表(脚本版本/在线 worker/空位/队列/可用性)
#   nyx.sh status [glob]             分类打印 /tmp/nyx-*.out 的真实状态
#   nyx.sh inflight                  当前 in-flight 数(NYX_POOL 或排名第一的池)
export PATH="$HOME/.local/bin:$PATH"
CLI="${NYX_CLI:-nyxid}"  # One executable/function name; no shell evaluation.
# 2026-08-28 实测:契约写 limit 4,但实际吞吐更低,且 `nyxid oracle status` 的 in-flight
# **包含别人的任务**(组织级共享池)—— 某刻显示 3 而我只有 2 张在跑。故保守取 2。
# 缺省 pool(2026-09-06 实测立、2026-09-08 复发后改默认):`extraction_failure` 由 pool 的
# **worker 脚本版本**决定,不是 brief 大小。同字节对照:`chatgpt-pro-pool`(`cdp-1.3-url-key-image`)
# 2/2 失败(17.9 KB 与 35.7 KB),同一份 17.9 KB 在 `chrono-chatgpt-pro-pool`(`0.11.7+…`)逐字节重发即成功,
# 该 pool 另测 24.5 KB 与 34.5 KB 亦成功。2026-09-08 复发:默认仍指向 cdp-1.3 那个 pool,
# 于是一份 8.1 KB 的 brief 连投两次都 `extraction_failure`,显式 `NYX_POOL=chrono-…` 才通。
# 缺省与已记录的用法背离,就是器自己产的坏原材料(第 8.4 条);故把缺省改成实测能用的那个。
#
# 池遍历(2026-09-08 下午立,用户问「有好几个池子,脚本能都遍历处理掉吗」):写死任何一个缺省池都会
# 在池容量随时间漂移时失效——同日实测:chrono 池 20 worker 仅 2 在线、队列 7,一行 JSON 排 20 min 排不到;
# company 池(`cdp-2.8.0-astra-resilient`,6 在线)4 min 即 NYX_OK。故 NYX_POOL **未设**时不再取固定缺省,
# 而是遍历 `nyxid oracle pool list` 的全部 active 池,按「在线空位多、队列短」排名,剔除已知坏脚本
# (NYX_BAD_SCRIPTS,前缀匹配,缺省 `cdp-1.3`)与零在线 worker 的池;载体侧失败(EXTRACTION/QUOTA)
# 换下一池重投同一份 brief。NYX_POOL 显式设定时保持旧行为:只投那一个池,不遍历(调用方要确定性时用)。
POOL="${NYX_POOL:-}"
BAD_SCRIPTS="${NYX_BAD_SCRIPTS:-cdp-1.3}"
# LIMIT 缺省**由 pool 自报容量派生**,不写死(2026-09-04 立)。
# 案由:await.sh 曾写死 NYX_LIMIT=4,而 company pool 容量为 10、已被他人占 6 —— 6 >= 4,
# 于是持锁者永远等不到「空位」,10 分钟后报 NYX_BUSY,五票全部卡在提交之前、零输出。
# 写死一个与被测对象无关的数,就是器律④ 的坏原材料:它看起来像个限额,实际与真实容量无关。
LIMIT="${NYX_LIMIT:-}"
# 提交模式(2026-09-04 立)。新版 worker 脚本(cdp-2.6+)执行 `nyxid.oracle.submission-gate.v1`,
# **fresh task 必须显式带 mode tag**,否则秒退 `oracle_mode_required` 且 retryable=false。
# 旧脚本(cdp-1.3)不要求,故同一条命令在不同 pool 上一个能过一个不能 —— 这正是
# 「不看 pool 自报的契约就派」的代价。契约原文:`nyxid oracle pool show <slug> --output json`。
# 取 mode:chat 因其默认模型即 ChatGPT **Pro**,与本仓 goal 的「1 席 gpt pro」精确对应;
# mode:work 默认 Ultra,属另一档,不在 goal 射程内。
TAG="${NYX_TAG:-mode:chat}"
POLL_ROUNDS="${NYX_POLL_ROUNDS-60}"
POLL_SECONDS="${NYX_POLL_SECONDS-20}"
OUT=""; OWNED_LOCK=""; LOCK_TRANSITION=0; CANCEL_RC=0

__uint() { [[ "$1" =~ ^[0-9]+$ ]] && [ "$1" -le 2147483647 ] 2>/dev/null; }
__uuid() { [[ "$1" =~ ^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$ ]]; }
__validate_settings() {
  { [ -z "$LIMIT" ] || { __uint "$LIMIT" && [ "$LIMIT" -gt 0 ]; }; } &&
    __uint "$POLL_ROUNDS" && [ "$POLL_ROUNDS" -gt 0 ] && __uint "$POLL_SECONDS" || {
    echo 'NYX_ERR NYX_LIMIT/NYX_POLL_ROUNDS must be positive integers; NYX_POLL_SECONDS must be nonnegative' >&2; return 2;
  }
  [ -z "$POOL" ] || [[ "$POOL" =~ ^[a-zA-Z0-9][a-zA-Z0-9._-]*$ ]] || {
    echo "NYX_ERR invalid pool slug: $POOL" >&2; return 2;
  }
  command -v "$CLI" >/dev/null || { echo "NYX_ERR CLI unavailable: $CLI" >&2; return 2; }
}
__append() {
  printf '%s\n' "$2" >> "$1" || { echo "NYX_IO cannot write: $1" >&2; LAST_VERDICT=IO; return 2; }
}
__cancel() {
  # Complete mkdir/rmdir bookkeeping before honoring a signal in that transition.
  if [ "$LOCK_TRANSITION" -eq 1 ]; then CANCEL_RC="$1"; else exit "$1"; fi
}
__release_lock() {
  local rc=0
  LOCK_TRANSITION=1
  if [ -n "$OWNED_LOCK" ]; then
    rmdir "$OWNED_LOCK" || { echo "NYX_IO cannot release lock: $OWNED_LOCK" >&2; rc=2; }
    OWNED_LOCK=""
  fi
  LOCK_TRANSITION=0
  [ "$CANCEL_RC" -eq 0 ] || exit "$CANCEL_RC"
  return "$rc"
}
__finish() {  # The only terminal sentinel writer, including pre-submit failures and signals.
  local rc="$1"
  trap - EXIT INT TERM
  case "$rc" in 130|143) echo "NYX_CANCELLED signal_rc=$rc" >&2;; esac
  CANCEL_RC=0
  __release_lock || rc=2
  if [ -n "$OUT" ]; then
    printf 'EXIT=%s\n' "$rc" >> "$OUT" || { echo "NYX_IO cannot write terminal sentinel: $OUT" >&2; rc=2; }
  fi
  exit "$rc"
}
__open_output() {
  local out="$1" verb="$2"
  [ -n "$out" ] && { [ ! -e "$out" ] || [ -f "$out" ]; } &&
    [ ! "$out" -ef "$out.taskid" ] && [ ! "$out" -ef "$out.history" ] &&
    [ ! "$out.taskid" -ef "$out.history" ] || {
    echo "NYX_IO outfile must be a writable regular file: $out" >&2; return 2;
  }
  if [ -e "$out" ]; then
    [ ! -e "$out.history" ] || [ -f "$out.history" ] || {
      echo "NYX_IO history must be a writable regular file: $out.history" >&2; return 2;
    }
    if [ -s "$out.history" ] && [ -n "$(tail -c 1 "$out.history")" ]; then __append "$out.history" '' || return 2; fi
    __append "$out.history" "NYX_RUN_BOUNDARY $(date -u +%Y-%m-%dT%H:%M:%SZ) $verb" || return 2
    cat "$out" >> "$out.history" || { echo "NYX_IO cannot archive: $out" >&2; return 2; }
  fi
  : > "$out" || { echo "NYX_IO cannot truncate: $out" >&2; return 2; }
  OUT="$out"
  # These handlers belong to the command, not to a candidate pool's lock path.
  trap '__finish $?' EXIT
  trap '__cancel 130' INT
  trap '__cancel 143' TERM
}
__taskid() {
  local id
  [ -f "$1.taskid" ] || return 1
  id=$(tail -1 "$1.taskid") || return 1
  __uuid "$id" || return 1
  printf '%s\n' "$id"
}
__open_taskids() {
  local out="$1" id
  [ ! "$out" -ef "$out.taskid" ] && { [ ! -e "$out.taskid" ] || [ -f "$out.taskid" ]; } && : >> "$out.taskid" || {
    echo "NYX_IO taskid must be a separate writable regular file: $out.taskid" >&2; return 2;
  }
  while IFS= read -r id || [ -n "$id" ]; do
    __uuid "$id" || { echo "NYX_ERR invalid recovery id: $out.taskid" >&2; return 2; }
  done < "$out.taskid"
}

__classify() {  # 读一个 .out,打印:OK|EXTRACTION|QUOTA|NOFILE|RUNNING|UNKNOWN
  local f="$1"
  [ -f "$f" ] || { echo NOFILE_OUT; return; }
  grep -qE '^EXIT=[0-9]+$' "$f" || { echo RUNNING; return; }
  if [ "$(tail -1 "$f")" = "EXIT=0" ]; then echo OK; return; fi
  grep -q 'oracle_quota_exceeded\|HTTP 429' "$f" && { echo QUOTA; return; }
  grep -q 'Failed to read prompt' "$f" && { echo NOFILE; return; }
  grep -q 'extraction_failure' "$f" && { echo EXTRACTION; return; }
  echo UNKNOWN
}

__expired() {  # 会话过期是能力缺口,不是池满 —— 必须与 in-flight 区分,否则白等 10 分钟
  "$CLI" oracle status "$POOL" 2>&1 | grep -q 'session has expired' && return 0 || return 1
}
__capacity() {  # pool 自报的总容量(Dispatched: N / M 的 M)
  local m status
  status=$("$CLI" oracle status "$POOL" 2>&1) || return 1
  m=$(printf '%s\n' "$status" | __pool_stats_parse "$POOL" | cut -d'|' -f5)
  __uint "$m" || return 1
  echo "$m"
}
__script_ver() {  # pool 自报的 worker 脚本版本 —— `extraction_failure` 的第一诊断位。
  # 取表格首个数据行的最后一列(Script)。读不到就空,调用方按缺失处理,不猜。
  # 注:`nyxid oracle status` 把表写到 **stderr**,必须 2>&1(与 __inflight 同坑)。
  "$CLI" oracle status "$POOL" 2>&1 | __script_ver_parse
}
__script_ver_parse() {  # 纯函数:从 stdin 读状态表,打印首个数据行的 Script 列
  awk -F'┆' '
    /┆/ {
      v = $NF
      gsub(/[│┆]/, "", v)
      gsub(/^[ \t]+|[ \t]+$/, "", v)
      if (v != "" && v != "Script") { print v; exit }
    }'
}
__inflight() {
  local n status
  status=$("$CLI" oracle status "$POOL" 2>&1) || return 1
  n=$(printf '%s\n' "$status" | __pool_stats_parse "$POOL" | cut -d'|' -f4)
  __uint "$n" || return 1
  echo "$n"
  # Status is emitted on stderr; an unreadable observation must not admit a submission.
}

# ---- 池遍历:三个纯函数 + 一个取数函数 -------------------------------------------------
__pools_active_parse() {  # 纯函数:从 stdin 读 `nyxid oracle pool list` 的表,打印 Active=yes 的 slug
  awk -F'┆' '
    /┆/ {
      s = $1; gsub(/[│┆]/, "", s); gsub(/^[ \t]+|[ \t]+$/, "", s)
      a = $5; gsub(/[│┆]/, "", a); gsub(/^[ \t]+|[ \t]+$/, "", a)
      if (s != "" && s != "Slug" && a == "yes") print s
    }'
}
__pool_stats_parse() {  # 纯函数:<slug> + stdin(该池的 status 文本)→ 一行 `slug|script|online|dispatched|capacity|queued|expired`
  # online = worker rows; missing/invalid dispatch and capacity stay unknown (?), never zero.
  local slug="$1"
  awk -v slug="$slug" -F'┆' '
    BEGIN { dispatched = capacity = "?" }
    /session has expired/ { expired = 1 }
    /Queued:/     { if (match($0, /Queued: *[0-9]+/)) { q = substr($0, RSTART, RLENGTH); sub(/Queued: */, "", q); queued = q } }
    /^[ \t]*Dispatched:[ \t]*[0-9]+[ \t]*\/[ \t]*[0-9]+[ \t]*$/ { d = $0; sub(/^[ \t]*Dispatched:[ \t]*/, "", d); split(d, p, /\//); gsub(/[ \t]/, "", p[1]); gsub(/[ \t]/, "", p[2]); dispatched = p[1]; capacity = p[2] }
    /┆/ {
      v = $NF; gsub(/[│┆]/, "", v); gsub(/^[ \t]+|[ \t]+$/, "", v)
      if (v != "" && v != "Script") { online++; if (script == "") script = v }
    }
    END { printf "%s|%s|%d|%s|%s|%d|%d\n", slug, script, online+0, dispatched, capacity, queued+0, expired+0 }'
}
__rank_pools() {  # 纯函数:stdin 读 __pool_stats_parse 的行,打印可用池 slug,按 空位 desc、队列 asc、slug asc
  # 可用 = 未过期 ∧ 在线 worker>0 ∧ 脚本已知 ∧ 脚本不以 BAD_SCRIPTS 任一前缀开头;空位 = min(在线, 容量) − dispatched(下限 0)
  awk -F'|' -v bad="$BAD_SCRIPTS" '
    BEGIN { nb = split(bad, B, / +/) }
    {
      if (NF != 7 || $1 !~ /^[a-zA-Z0-9][a-zA-Z0-9._-]*$/) next
      for (i = 3; i <= 7; i++) if ($i !~ /^[0-9]+$/ || $i + 0 > 2147483647) next
      slug = $1; script = $2; online = $3 + 0; dispatched = $4 + 0; capacity = $5 + 0; queued = $6 + 0; expired = $7 + 0
      if (expired || online == 0 || capacity == 0 || script == "") next
      isbad = 0; for (i = 1; i <= nb; i++) if (B[i] != "" && index(script, B[i]) == 1) isbad = 1
      if (isbad) next
      cap = (capacity < online) ? capacity : online
      free = cap - dispatched; if (free < 0) free = 0
      printf "%d %d %s\n", free, queued, slug
    }' | sort -k1,1nr -k2,2n -k3,3 | awk '{ print $3 }'
}
__pool_rows() {  # 取数:遍历全部 active 池,打印 __pool_stats_parse 行(每池一次 status 调用)
  local s listing status
  listing=$("$CLI" oracle pool list 2>&1) || return 1
  for s in $(printf '%s\n' "$listing" | __pools_active_parse); do
    status=$("$CLI" oracle status "$s" 2>&1) || continue
    printf '%s\n' "$status" | __pool_stats_parse "$s"
  done
}
__pools_table() {  # `pools` 动词:人读表 + 排名;判据与 ask 用的完全同一份(__rank_pools)
  local rows ranked
  rows=$(__pool_rows)
  ranked=$(printf '%s\n' "$rows" | __rank_pools | tr '\n' ' ')
  printf '%-26s %-28s %6s %10s %8s %6s %s\n' pool script online disp/cap queued expired eligible
  printf '%s\n' "$rows" | awk -F'|' -v ranked=" $ranked " '{
    el = (index(ranked, " " $1 " ") > 0) ? "yes" : "no"
    printf "%-26s %-28s %6s %10s %8s %6s %s\n", $1, ($2 == "" ? "-" : $2), $3, $4 "/" $5, $6, $7, el }'
  echo "NYX_POOLS ranked=[${ranked% }] bad_scripts=[$BAD_SCRIPTS]"
}

__verdict_of_payload() {  # 判**取回的文本**,不判文件 —— 活判决唯一合法的分类器。
  # 分界:载体是否把答案交回来了,与 worker 判词是 approve 还是 reject **无关**;
  # 故只认 nyxid CLI 自己的错误形态,不因答案里出现 "Error:" 字样而误判(见 --selftest 阴性对照)。
  local r="$1" first last
  case "$r" in
    *oracle_quota_exceeded*|*"HTTP 429"*) echo QUOTA;      return;;
    *"Failed to read prompt"*)            echo NOFILE;     return;;
    *extraction_failure*)                 echo EXTRACTION; return;;
  esac
  # 2026-09-08 实测:chrono pool 的任务 `e72e6521…` 终态返回
  #   Attempts: 1 (infrastructure retries 0/3)
  #   Message delivery timed out. Please try again.Retry
  # 那是载体 UI 自己的失败文本,不是答案。它不含 `Error:` 前缀、也不匹配上面任何一形,
  # 于是**被判 OK 且退出码 0** —— 调用方按退出码判就把一次失败的派席当成了成功
  # (第 8.4 条:坏原材料让下游误判)。与 EXTRACTION 分开记,因为处置不同:
  # extraction 是 pool 的 worker 脚本版本问题(换 pool);delivery 是同 pool 重投。
  # **只认末行**,不做全文子串匹配:本仓的 brief 与评审答案会**引用**这句失败文本
  # (本条注释自己就是一例),全文匹配会把一个真答案误判成载体失败。
  [ -n "$r" ] || { echo UNKNOWN; return; }
  last=$(printf '%s' "$r" | awk 'NF{l=$0} END{print l}')
  case "$last" in *"Message delivery timed out"*) echo DELIVERY; return;; esac
  # 2026-09-08 16:5x 实测(company 池,task 912474a6):终态 `Error: Task failed (prompt_delivery_uncertain).`
  # —— worker 不能确认 prompt 已投递,任务失败;与 delivery timeout 同类(载体侧、未消费、可重投),
  # 此前落到 UNKNOWN(我方 bug 类)于是遍历停在第一个池、调用方也不重试。只认末行,理由同上。
  case "$last" in *"Task failed (prompt_delivery_uncertain)"*) echo DELIVERY; return;; esac
  first=${r%%$'\n'*}
  case "$first" in "Error:"*) echo UNKNOWN; return;; esac
  echo OK
}

__poll_task() {  # <task-id> <outfile>; ask/fetch share polling, __finish owns the sentinel.
  # **这不是挂钟猜测**(器律⑥′):池无 webhook,`nyxid oracle result` 是唯一取回原语;
  # 间隔对齐真实任务时长(实测数分钟级),有上限,且判据(__verdict_of_payload)在开跑前已写死。
  local tid="$1" out="$2" n=0 r rc verdict
  while [ $n -lt "$POLL_ROUNDS" ]; do
    r=$("$CLI" oracle result "$tid" 2>&1); rc=$?
    if [ "$rc" -eq 0 ]; then
      case "$r" in
        *"Task is dispatched"*|*"Phase:"*|*queued*) n=$((n+1)); sleep "$POLL_SECONDS"; continue;;
      esac
    fi
    __append "$out" "$r" || return 2
    break
  done
  if [ $n -ge "$POLL_ROUNDS" ]; then
    echo "NYX_TIMEOUT $tid 仍未落定;可随时 nyx.sh fetch $tid <out> 续等,或 nyxid oracle result $tid 取回"
    rc=3; verdict=TIMEOUT
  else
    verdict=$(__verdict_of_payload "$r")
    [ "$rc" -eq 0 ] || { [ "$verdict" != OK ] || verdict=UNKNOWN; }
    case "$verdict" in OK) rc=0;; *) rc=1;; esac
  fi
  echo "NYX_$verdict $(basename "$out" .out)"
  LAST_VERDICT="$verdict"
  return $rc
}

__submit_and_poll() {  # <brief> <out> —— 对当前 $POOL 投一票并取回;返回 __poll_task 的 rc,LAST_VERDICT 记判词
  local brief="$1" out="$2" n rc tid response inflight lock
  # 会话过期 → 立刻报能力缺口,不要当池满去等 10 分钟(2026-08-28 实测遇到)
  __expired && { echo "NYX_EXPIRED pool=$POOL 会话已过期 —— 需人跑 \`nyxid login\`(第15条:能力缺口,等灯亮)"; LAST_VERDICT=EXPIRED; return 4; }
  if [ -z "$LIMIT" ]; then
    LIMIT=$(__capacity) || { echo "NYX_UNKNOWN capacity pool=$POOL"; LAST_VERDICT=UNKNOWN; return 4; }
  fi
  [ "$LIMIT" -gt 0 ] || { echo "NYX_BUSY capacity=0 pool=$POOL"; LAST_VERDICT=BUSY; return 3; }
  # **锁**:检查 in-flight 与提交之间必须原子,否则两个并发 ask 会都看到有空位、都提交 → 429。
  # (2026-08-28 实测:并发两个 ask,in-flight=3,两者都判有空位,一者得 QUOTA。
  #  这是 TOCTOU 竞态 —— 器自己犯了它要防的那个错。)
  # 锁**按 pool 分片**:跨 pool 本无竞态,共用一把锁会让空闲 pool 的票排在满 pool 的票后面。
  lock="${TMPDIR:-/tmp}/nyx-ask-${POOL}.lock"
  n=0
  while [ -z "$OWNED_LOCK" ]; do
    LOCK_TRANSITION=1
    if mkdir "$lock" 2>/dev/null; then OWNED_LOCK="$lock"; fi
    LOCK_TRANSITION=0
    [ "$CANCEL_RC" -eq 0 ] || exit "$CANCEL_RC"
    [ -z "$OWNED_LOCK" ] || break
    n=$((n+1)); [ $n -gt 120 ] && { echo "NYX_LOCKBUSY 等锁超时: $out"; LAST_VERDICT=LOCKBUSY; return 3; }
    sleep 5
  done
  # 持锁期间等空位,再提交 —— 提交后立刻放锁(任务已计入 in-flight)
  n=0
  while :; do
    inflight=$(__inflight) || { echo "NYX_UNKNOWN inflight pool=$POOL"; LAST_VERDICT=UNKNOWN; return 4; }
    [ "$inflight" -ge "$LIMIT" ] && [ $n -lt 30 ] || break
    sleep 20; n=$((n+1))
  done
  if [ "$inflight" -ge "$LIMIT" ]; then
    __release_lock || { LAST_VERDICT=IO; return 2; }
    echo "NYX_BUSY pool=$POOL 等了 10 分钟仍满($LIMIT),放弃: $out"; LAST_VERDICT=BUSY; return 3
  fi
  # **--no-wait + 记 task id**:阻塞等待会让「我的进程生死」决定「任务是否丢失」。
  # 2026-08-28 实测:前台 ask 被 2min 超时杀、后台 ask 被 SIGTERM(exit 143)杀,
  # 而 `nyxid oracle result <task-id>` 显示**任务在池里仍活着**(`Phase: waiting_response`)。
  # 故改为提交后立刻拿 id 落盘,等待与取回分离 —— 被杀只丢等待,不丢工作。
  # **提交前把产地打出来**:失败判词只说 `extraction_failure`,不说是哪个 pool、哪个 worker 脚本,
  # 于是每次都要另跑一条 `nyxid oracle status` 才能归因。产地进输出即自诊断(第 8.4 条)。
  echo "NYX_SUBMIT pool=$POOL script=$(__script_ver) tag=$TAG brief_bytes=$(wc -c <"$brief" | tr -d ' ') out=$out"
  response=$("$CLI" oracle ask "$POOL" --file "$brief" --tag "$TAG" --no-wait 2>&1); rc=$?
  tid=$(printf '%s\n' "$response" | grep -oE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' | tail -1)
  # Parse only this response; earlier attempts remain audit data, never submission input.
  __append "$out" "$response" || { echo "NYX_IO recovery task=${tid:-<none>} out=$out" >&2; return 2; }
  if [ -n "$tid" ]; then
    __append "$out.taskid" "$tid" || { echo "NYX_IO recovery task=$tid out=$out" >&2; return 2; }
  fi
  __release_lock || { LAST_VERDICT=IO; return 2; }
  if [ -z "$tid" ]; then
    LAST_VERDICT=$(__verdict_of_payload "$response")
    [ "$LAST_VERDICT" != OK ] || LAST_VERDICT=UNKNOWN
    [ "$rc" -ne 0 ] || rc=1
    echo "NYX_$LAST_VERDICT $(basename "$out" .out)"; return "$rc"
  fi
  # 轮询取回与判词由 __poll_task 承担(唯一真源;ask 与 fetch 共用)。
  # **退出码必须反映取回的内容,不能写死 0**
  # (2026-08-28:no-wait 改造首跑即回归 —— `extraction_failure` 报了 EXIT=0,
  #  正是器律④「原材料好,不靠读者警惕」要禁的坏材料:调用方按退出码判就会误判成功。)
  # **进程退出码也必须反映判词**:此前 ask 分支以 echo 收尾,脚本恒 exit 0,
  # 于是写进文件的 EXIT= 与进程退出码可以相反 —— 同一个「坏原材料」病的第二个面。
  __poll_task "$tid" "$out"
}

__selftest() {  # 分类器的阳性/阴性对照。**立条依据(2026-09-06)**:`__classify` 的 OK 分支要求
  # `tail -1 = EXIT=0`,而 `EXIT=` 是**分类之后**才追加的 —— 在 ask 的活判决里该分支
  # **结构上不可达**,于是每一次成功取回都被判 rc=1。器律④:坏原材料让调用方误判。
  # 该错配无运行期信号(答案就在文件里,只有退出码是错的),故必须由对照钉住。
  local fail=0 cases=0 got BAD_SCRIPTS=cdp-1.3
  chk() {  # chk <期望> <名字> <payload>
    cases=$((cases+1))
    got=$(__verdict_of_payload "$3" 2>/dev/null)
    if [ "$got" = "$1" ]; then printf '  ok   %-30s %s\n' "$2" "$got"
    else printf '  FAIL %-30s expected=%s got=%s\n' "$2" "$1" "${got:-<none>}"; fail=1; fi
  }
  # 阳性:真答案必须判 OK —— 载体成功与 worker 判词是两回事,reject 也是成功取回
  chk OK         answer-json                '{"ok":true}'
  chk OK         answer-reject-verdict      '{"verdict":"reject","conclusion":{"a":1}}'
  chk OK         answer-contains-error-word '{"verdict":"reject","note":"Error: in their proof"}'
  chk OK         answer-multiline-err-later "$(printf 'line one\nError: quoted from their log')"
  # 阴性:载体侧失败必须各自可辨,不得混成一个
  chk EXTRACTION carrier-extraction         'Error: Task failed (extraction_failure).'
  chk QUOTA      carrier-quota-429          'Error: HTTP 429 {"error":"oracle_quota_exceeded"}'
  chk NOFILE     carrier-prompt-missing     'Error: Failed to read prompt'
  # 载体投递失败:失败文本是 payload 的**末行**
  chk DELIVERY   carrier-delivery-timeout   "$(printf '%s\n' 'Attempts: 1 (infrastructure retries 0/3)' \
    'Message delivery timed out. Please try again.Retry')"
  chk DELIVERY   carrier-prompt-uncertain   "$(printf '%s\n' 'Attempts: 1 (infrastructure retries 0/3)' \
    'Error: Task failed (prompt_delivery_uncertain).')"
  chk OK         answer-quotes-prompt-uncertain "$(printf '%s\n' 'The seat hit Error: Task failed (prompt_delivery_uncertain). earlier' '{"verdict":"approve"}')"
  # 阴性对照:**真答案里引用了同一句失败文本**,但末行是答案 —— 必须仍判 OK。
  # 这条钉的正是「不做全文子串匹配」;改成全文匹配它立刻变红。
  chk OK         answer-quotes-delivery-text "$(printf '%s\n' \
    'The seat reported: Message delivery timed out. Please try again.' \
    '{"verdict":"reject","conclusion":{"blocking":1}}')"
  chk UNKNOWN    carrier-bare-error         'Error: forbidden'
  chk UNKNOWN    empty-payload              ''
  # Script 列解析的阳性/阴性对照:缺省 pool 的选择依赖它,解析错了就诊断错了。
  chkv() {  # chkv <期望> <名字> <表格文本>
    cases=$((cases+1))
    got=$(printf '%s\n' "$3" | __script_ver_parse)
    if [ "$got" = "$1" ]; then printf '  ok   %-30s %s\n' "$2" "${got:-<empty>}"
    else printf '  FAIL %-30s expected=%s got=%s\n' "$2" "$1" "${got:-<none>}"; fail=1; fi
  }
  chkv 'cdp-1.3-url-key-image' script-first-data-row "$(printf '%s\n' \
    '│ Worker          ┆ Seen (s ago) ┆ Task ┆ Script                │' \
    '╞═════════════════╪══════════════╪══════╪═══════════════════════╡' \
    '│ share_account_6 ┆ 0            ┆ -    ┆ cdp-1.3-url-key-image │' \
    '│ share_account_5 ┆ 0            ┆ -    ┆ cdp-1.3-url-key-image │')"
  chkv '0.11.7+63d573839245' script-other-version "$(printf '%s\n' \
    '│ Worker ┆ Seen ┆ Task ┆ Script             │' \
    '│ w1     ┆ 3    ┆ -    ┆ 0.11.7+63d573839245 │')"
  chkv '' script-no-table "$(printf '%s\n' "Pool 'x':" '  Queued:     0' '  Dispatched: 0 / 20')"

  # 池遍历三个纯函数的对照(2026-09-08 立):排名错了就把票投进坏池,与固定缺省同病。
  chke() {  # chke <期望> <名字> <实际>
    cases=$((cases+1))
    if [ "$3" = "$1" ]; then printf '  ok   %-30s %s\n' "$2" "${3:-<empty>}"
    else printf '  FAIL %-30s expected=[%s] got=[%s]\n' "$2" "$1" "$3"; fail=1; fi
  }
  local plist st_company st_bad st_idle st_expired rows
  plist=$(printf '%s\n' \
    '│ Slug                ┆ Name        ┆ Visibility ┆ Workers ┆ Active ┆ Manage │' \
    '╞═════════════════════╪═════════════╪════════════╪═════════╪════════╪════════╡' \
    '│ company-chatgpt-pro ┆ Company     ┆ org        ┆ 10      ┆ yes    ┆ no     │' \
    '│ old-pool            ┆ Old         ┆ org        ┆ 20      ┆ yes    ┆ yes    │' \
    '│ paused-pool         ┆ Paused      ┆ org        ┆ 3       ┆ no     ┆ yes    │' \
    '│ heca-1              ┆ Private     ┆ private    ┆ 1       ┆ yes    ┆ yes    │')
  chke 'company-chatgpt-pro old-pool heca-1' pools-active-parse "$(printf '%s\n' "$plist" | __pools_active_parse | tr '\n' ' ' | sed 's/ $//')"
  st_company=$(printf '%s\n' "Pool 'company-chatgpt-pro':" '  Queued:     2' '  Dispatched: 4 / 10' '  Diagnosis:  running' \
    '│ Worker ┆ Seen (s ago) ┆ Task ┆ Script                    │' \
    '│ w1     ┆ 2            ┆ t1   ┆ cdp-2.8.0-astra-resilient │' \
    '│ w2     ┆ 4            ┆ -    ┆ cdp-2.8.0-astra-resilient │' \
    '│ w3     ┆ 4            ┆ -    ┆ cdp-2.8.0-astra-resilient │' \
    '│ w4     ┆ 9            ┆ t2   ┆ cdp-2.8.0-astra-resilient │' \
    '│ w5     ┆ 13           ┆ t3   ┆ cdp-2.8.0-astra-resilient │' \
    '│ w6     ┆ 21           ┆ t4   ┆ cdp-2.8.0-astra-resilient │')
  chke 'company-chatgpt-pro|cdp-2.8.0-astra-resilient|6|4|10|2|0' pool-stats-parse-company "$(printf '%s\n' "$st_company" | __pool_stats_parse company-chatgpt-pro)"
  st_bad=$(printf '%s\n' "Pool 'old-pool':" '  Queued:     0' '  Dispatched: 0 / 20' \
    '│ Worker ┆ Seen ┆ Task ┆ Script                │' \
    '│ a      ┆ 1    ┆ -    ┆ cdp-1.3-url-key-image │')
  chke 'old-pool|cdp-1.3-url-key-image|1|0|20|0|0' pool-stats-parse-bad-script "$(printf '%s\n' "$st_bad" | __pool_stats_parse old-pool)"
  st_idle=$(printf '%s\n' "Pool 'heca-1':" '  Queued:     1' '  Dispatched: 0 / 1')
  st_expired=$(printf '%s\n' "Pool 'chrono':" 'Error: session has expired')
  chke 'heca-1||0|0|1|1|0' pool-stats-parse-no-workers "$(printf '%s\n' "$st_idle" | __pool_stats_parse heca-1)"
  chke 'chrono||0|?|?|0|1' pool-stats-parse-expired "$(printf '%s\n' "$st_expired" | __pool_stats_parse chrono)"
  chke 'x||0|?|?|0|0' pool-stats-missing-capacity "$(printf '%s\n' 'Queued: 0' | __pool_stats_parse x)"
  chke 'x||0|?|?|0|0' pool-stats-invalid-capacity "$(printf '%s\n' 'Dispatched: 0 / 6oops' | __pool_stats_parse x)"
  chke 'x||0|0|0|0|0' pool-stats-zero-capacity "$(printf '%s\n' 'Dispatched: 0 / 0' | __pool_stats_parse x)"
  rows=$(printf '%s\n' \
    'company-chatgpt-pro|cdp-2.8.0-astra-resilient|6|4|10|2|0' \
    'old-pool|cdp-1.3-url-key-image|5|0|20|0|0' \
    'heca-1||0|0|1|1|0' \
    'chrono|0.11.7+63d573839245|3|2|20|7|0' \
    'expired-pool|0.11.7+63d573839245|3|0|20|0|1' \
    'fresh|0.11.7+63d573839245|3|0|20|0|0')
  # 期望:fresh(空位 3,队列 0)> company(空位 2)> chrono(空位 1);old-pool 坏脚本、heca 零在线、expired 过期均剔除
  chke 'fresh company-chatgpt-pro chrono' rank-pools-order "$(printf '%s\n' "$rows" | __rank_pools | tr '\n' ' ' | sed 's/ $//')"
  # 同空位按队列短优先;再同则 slug 字典序(确定性,不随 status 输出顺序变)
  chke 'b-pool a-pool' rank-pools-tiebreak "$(printf '%s\n' 'a-pool|v|4|1|10|5|0' 'b-pool|v|4|1|10|1|0' | __rank_pools | tr '\n' ' ' | sed 's/ $//')"
  # BAD_SCRIPTS 是前缀匹配、可多项:把 0.11.7 也列为坏时 chrono 被剔
  chke 'company-chatgpt-pro' rank-pools-bad-prefix-list "$(printf '%s\n' "$rows" | BAD_SCRIPTS='cdp-1.3 0.11.7' __rank_pools | tr '\n' ' ' | sed 's/ $//')"
  # 全部剔除 ⟹ 空(调用方按 NYX_NOPOOL 处理,不猜)
  chke '' rank-pools-none "$(printf '%s\n' 'old-pool|cdp-1.3-url-key-image|5|0|20|0|0' | __rank_pools | tr '\n' ' ' | sed 's/ $//')"
  chke 'known-capacity' rank-pools-unknown-zero-capacity "$(printf '%s\n' \
    'unknown-capacity|v|6|0|?|0|0' 'missing-capacity|v|6|0||0|0' \
    'invalid-capacity|v|6|0|bad|0|0' 'zero-capacity|v|6|0|0|0|0' \
    'known-capacity|v|6|5|6|0|0' | __rank_pools)"

  # 回归钉:文件级 __classify 在「最后一行是答案」的文件上必判 RUNNING,
  # 这正是它不能用于活判决的原因;若有人把它改回去,本例变红。
  local tmp; tmp=$(mktemp) || return 1
  printf 'Task submitted.\n\n{"ok":true}\n' > "$tmp"
  got=$(__classify "$tmp")
  chke RUNNING file-classifier-unusable-live "$got"
  printf 'Error: Task failed (extraction_failure).\n' > "$tmp"
  chke RUNNING file-classifier-carrier-running "$(__classify "$tmp")"; rm -f "$tmp"
  # Run the real command dispatcher in child shells with an isolated, fail-closed CLI.
  # Fixture columns: slug|script|online|dispatched|capacity|queued|response|task-id.
  __nyx_fake_cli() {
    local slug script online dispatched capacity queued response id i
    printf '%s\n' "$*" >> "$NYX_TEST_DIR/calls"
    [ "$1" = oracle ] || return 97
    [ "$2" != result ] || printf '%s\n' "$3" >> "$NYX_TEST_DIR/polls"
    while IFS='|' read -r slug script online dispatched capacity queued response id; do
      if [ "$2 $3" = 'pool list' ]; then
        printf '│ %s ┆ Fixture ┆ org ┆ %s ┆ yes ┆ no │\n' "$slug" "$online"; continue
      fi
      if [ "$2" = result ]; then
        if [ "${NYX_TEST_UNIQUE_IDS:-}" = 1 ]; then [ "${3%-*}" = "${id%-*}" ] || continue; id="$3"
        else [ "$3" = "$id" ] || continue; fi
      else [ "$3" = "$slug" ] || continue; fi
      case "$2" in
        status)
          if [ "$response" = expired ] || { [ "$response" = late-expired ] && [ -s "$NYX_TEST_DIR/submits" ]; }; then
            echo 'Error: session has expired'; return 1
          fi
          if [ "$capacity" != '?' ]; then printf '  Dispatched: %s / %s\n' "$dispatched" "$capacity"; fi
          printf '  Queued: %s\n│ Worker ┆ Seen ┆ Task ┆ Script │\n' "$queued"
          i=0; while [ "$i" -lt "$online" ]; do
            printf '│ w%s ┆ 1 ┆ - ┆ %s │\n' "$i" "$script"; i=$((i+1))
          done; return 0;;
        ask)
          [ "$4" = --file ] && [ -r "$5" ] && [ "$6" = --tag ] && [ "$7" = mode:chat ] && [ "$8" = --no-wait ] || return 97
          cmp -s "$5" "$NYX_TEST_DIR/expected-brief" || return 97
          printf '%s\n' "$slug" >> "$NYX_TEST_DIR/submits"
          if [ "${NYX_TEST_UNIQUE_IDS:-}" = 1 ]; then id="${id%-*}-$(printf '%012d' "$(wc -l < "$NYX_TEST_DIR/submits")")"; fi
          case "$response" in
            quota) echo 'Error: HTTP 429 oracle_quota_exceeded'; return 1;;
            nofile) echo 'Error: Failed to read prompt'; return 2;;
            unknown) echo 'Error: forbidden'; return 7;;
            noid) echo 'Accepted without an id'; return 0;;
            id-write-error) rm "$NYX_TEST_OUT.taskid"; command mkdir "$NYX_TEST_OUT.taskid";;
          esac
          printf 'Task submitted: %s\n' "$id"; return 0;;
        result)
          case "$response" in
            extraction) echo 'Error: Task failed (extraction_failure).'; return 1;;
            delivery) printf '%s\n' 'Attempts: 1 (infrastructure retries 0/3)' 'Message delivery timed out. Please try again.Retry';;
            prompt-uncertain) printf '%s\n' 'Attempts: 1 (infrastructure retries 0/3)' 'Error: Task failed (prompt_delivery_uncertain).'; return 1;;
            quote) printf '%s\n' 'Quoted: Message delivery timed out. Please try again.' '{"verdict":"reject"}';;
            timeout) echo 'Phase: waiting_response';;
            resume) if [ "$(wc -l < "$NYX_TEST_DIR/polls")" -le 2 ]; then echo 'Phase: waiting_response'; else echo '{"ok":true}'; fi;;
            barrier) printf 'ready\n' > "$NYX_TEST_DIR/ready"; IFS= read -r response < "$NYX_TEST_DIR/release"; echo '{"ok":true}';;
            result-error) echo 'Unexpected transport failure'; return 1;;
            *) echo '{"ok":true}';;
          esac; return 0;;
        *) return 97;;
      esac
    done <<< "$NYX_TEST_ROWS"
    [ "$2 $3" = 'pool list' ] || return 97
  }
  local testroot run_name run_dir run_out run_rc run_rows run_env run_args run_script
  local await_script; await_script="$(dirname "$0")/await.sh"
  local id1=11111111-1111-4111-8111-111111111111 id2=22222222-2222-4222-8222-222222222222 id3=33333333-3333-4333-8333-333333333333
  local selection traversal third
  testroot=$(mktemp -d) || return 1
  selection=$(printf '%s\n' "bad|cdp-1.3-old|3|0|3|0|extraction|$id1" "idle|v|0|0|2|0|answer|$id2" "good|v|1|0|1|0|answer|$id3")
  traversal=$(printf '%s\n' "second|v|1|0|1|0|answer|$id2" "first|v|2|0|2|0|extraction|$id1")
  third="third|v|1|0|1|1|answer|$id3"
  run_case() {
    run_name="$1"; run_rows="$2"; shift 2
    run_dir="$testroot/$run_name"; run_out="$run_dir/result.out"
    mkdir "$run_dir" || return 1
    printf 'fixture brief\n' > "$run_dir/brief"
    cp "$run_dir/brief" "$run_dir/expected-brief"
    : > "$run_dir/calls"; : > "$run_dir/submits"; : > "$run_dir/polls"
    case "$run_name" in
      ask-output-init-error) mkdir "$run_out";;
      ask-sidecar-init-error) mkdir "$run_out.taskid";;
      *foreign*|ask-lockbusy) mkdir "$run_dir/nyx-ask-second.lock";;
      await-vote-*) printf '%s\n' "$id3" > "$run_out.taskid"; printf 'EXIT=1\n' > "$run_out"; : > "$run_out.settled";;
    esac
    run_env=("TMPDIR=$run_dir" 'NYX_CLI=__nyx_fake_cli' 'NYX_POOL=' 'NYX_LIMIT=' 'NYX_BAD_SCRIPTS=cdp-1.3' 'NYX_TAG=mode:chat'
      'NYX_POLL_SECONDS=0' 'NYX_POLL_ROUNDS=2' "NYX_TEST_DIR=$run_dir" "NYX_TEST_OUT=$run_out" "NYX_TEST_ROWS=$run_rows"
      'NYX_TEST_SIGNAL=' 'NYX_TEST_CANCEL=' 'NYX_TEST_WRITE_ERROR=' 'NYX_TEST_UNIQUE_IDS=' 'AWAIT_TICK=0' 'AWAIT_DEADLINE=5400' "$@")
    run_script="$0"
    run_args=(ask "$run_dir/brief" "$run_out")
    case "$run_name" in fetch-*) run_args=(fetch "$id1" "$run_out");; esac
    case "$run_name" in await-vote-*) run_script="$await_script"; run_args=(vote "$run_dir/brief" "$run_out" 2);; esac
    case "$run_name" in
      ask-missing-brief) run_args=(ask "$run_dir/missing" "$run_out");;
      fetch-invalid-id) run_args=(fetch '1-2-3-4-5' "$run_out");;
    esac
    run_child > "$run_dir/stdout" 2>&1; run_rc=$?
  }
  run_child() (
    # No real nyxid call or wall-clock delay can escape a selftest child.
    nyxid() { echo NYX_TEST_UNEXPECTED_CLI >&2; return 97; }
    sleep() { :; }
    printf() {
      if [ "$BASH_SUBSHELL" -eq 0 ] && [ "$NYX_TEST_WRITE_ERROR" = submit ] && [[ "${2:-}" = 'Task submitted:'* ]]; then return 1; fi
      command printf "$@"
    }
    mkdir() {
      local rc
      if [ "$NYX_TEST_CANCEL" = foreign ] && [ "$1" = "$NYX_TEST_DIR/nyx-ask-second.lock" ]; then
        kill -s "$NYX_TEST_SIGNAL" "$$"; return 1
      fi
      command mkdir "$@"; rc=$?
      if [ "$rc" -eq 0 ] && [ "$NYX_TEST_CANCEL" = owned ]; then kill -s "$NYX_TEST_SIGNAL" "$$"; fi
      return "$rc"
    }
    export -f __nyx_fake_cli nyxid sleep mkdir printf
    env "${run_env[@]}" bash "$run_script" "${run_args[@]}"
  )
  joined() { if [ -f "$1" ]; then awk 'NF {printf "%s%s", sep, $0; sep=","}' "$1"; fi; }
  check_run() {  # rc | final line | submissions | recorded IDs | polled IDs | next pools | last verdict
    local last='' next verdict actual
    [ ! -f "$run_out" ] || last=$(tail -1 "$run_out")
    next=$(awk '/^NYX_NEXT_POOL / {sub(/^after=/,"",$2); printf "%s%s", sep, $2; sep=","}' "$run_dir/stdout")
    verdict=$(awk '/^NYX_(OK|EXTRACTION|QUOTA|NOFILE|UNKNOWN|DELIVERY|NOPOOL|BUSY|EXPIRED|LOCKBUSY|TIMEOUT|IO|ERR|CANCELLED)( |$)/ {v=$1} END {print v}' "$run_dir/stdout")
    actual="$run_rc|$last|$(joined "$run_dir/submits")|$(joined "$run_out.taskid")|$(joined "$run_dir/polls")|$next|$verdict"
    chke "$1" "$run_name" "$actual"
    [ "$actual" = "$1" ] || cat "$run_dir/stdout"
  }
  run_case ask-select-good "$selection"
  check_run "0|EXIT=0|good|$id3|$id3||NYX_OK"
  run_case ask-ranked-traversal "$traversal"
  check_run "0|EXIT=0|first,second|$id1,$id2|$id1,$id2|first|NYX_OK"
  run_name=fetch-rerun-resumes; run_args=(fetch "$id2" "$run_out")
  run_child > "$run_dir/stdout" 2>&1; run_rc=$?
  check_run "0|EXIT=0|first,second|$id1,$id2|$id1,$id2,$id2||NYX_OK"
  run_case ask-all-bad "bad|cdp-1.3-old|1|0|1|0|answer|$id1"
  check_run '4|EXIT=4|||||NYX_NOPOOL'
  run_case ask-explicit-bad "$selection" NYX_POOL=bad
  check_run "1|EXIT=1|bad|$id1|$id1||NYX_EXTRACTION"
  run_case ask-busy "second|v|1|1|1|0|answer|$id2"
  check_run '3|EXIT=3|||||NYX_BUSY'
  run_case ask-extraction-then-busy "${traversal/second|v|1|0/second|v|1|1}"
  check_run "3|EXIT=3|first|$id1|$id1|first|NYX_BUSY"
  run_case ask-extraction-then-nofile "${traversal/answer/nofile}"$'\n'"$third"
  check_run "2|EXIT=2|first,second|$id1|$id1|first|NYX_NOFILE"
  rows="${traversal/extraction/quota}"
  run_case ask-quota-then-unknown "${rows/answer/unknown}"$'\n'"$third" NYX_LIMIT=1
  check_run '7|EXIT=7|first,second|||first|NYX_UNKNOWN'
  run_case ask-extraction-then-expired "${traversal/answer/late-expired}"
  check_run "4|EXIT=4|first|$id1|$id1|first|NYX_EXPIRED"
  run_case ask-expired "first|v|1|0|1|0|expired|$id1" NYX_POOL=first
  check_run '4|EXIT=4|||||NYX_EXPIRED'
  run_case ask-lockbusy "second|v|1|0|1|0|answer|$id2"
  check_run '3|EXIT=3|||||NYX_LOCKBUSY'
  local signal cancel expected response rows_one="first|v|1|0|1|0|answer|$id1"
  for signal in INT TERM; do
    case "$signal" in INT) expected=130;; TERM) expected=143;; esac
    for cancel in owned foreign; do
      run_case "ask-cancel-$cancel-$signal" "$traversal" "NYX_TEST_SIGNAL=$signal" "NYX_TEST_CANCEL=$cancel"
      if [ "$cancel" = owned ]; then check_run "$expected|EXIT=$expected|||||NYX_CANCELLED"
      else check_run "$expected|EXIT=$expected|first|$id1|$id1|first|NYX_CANCELLED"; fi
      chke "$cancel" "lock-ownership-$cancel-$signal" "$(if [ -d "$run_dir/nyx-ask-second.lock" ]; then echo foreign; else echo owned; fi)"
      chke absent "lock-released-first-$signal-$cancel" "$(if [ -d "$run_dir/nyx-ask-first.lock" ]; then echo leaked; else echo absent; fi)"
    done
  done
  for response in delivery prompt-uncertain quote timeout noid result-error; do
    run_case "ask-$response" "${rows_one/answer/$response}"$'\n'"$third"
    case "$response" in
      delivery|prompt-uncertain) check_run "0|EXIT=0|first,third|$id1,$id3|$id1,$id3|first|NYX_OK";;
      quote) check_run "0|EXIT=0|first|$id1|$id1||NYX_OK";;
      timeout) check_run "3|EXIT=3|first|$id1|$id1,$id1||NYX_TIMEOUT";;
      noid) check_run '1|EXIT=1|first||||NYX_UNKNOWN';;
      result-error) check_run "1|EXIT=1|first|$id1|$id1||NYX_UNKNOWN";;
    esac
  done
  local setting
  for setting in NYX_LIMIT=invalid NYX_LIMIT=0 NYX_LIMIT=999999999999999999999 NYX_POLL_ROUNDS=-1 NYX_POLL_SECONDS=oops; do
    run_case "ask-invalid-$setting" "$rows_one" "$setting"
    check_run '2|EXIT=2|||||NYX_ERR'
    chke '' "no-cli-$setting" "$(joined "$run_dir/calls")"
  done
  run_case ask-output-init-error "$rows_one"
  check_run '2||||||NYX_IO'
  chke '' no-cli-output-init-error "$(joined "$run_dir/calls")"
  run_case ask-sidecar-init-error "$rows_one"
  check_run '2|EXIT=2|||||NYX_IO'
  chke '' no-cli-sidecar-init-error "$(joined "$run_dir/calls")"
  run_case ask-taskid-write-error "${rows_one/answer/id-write-error}"
  check_run '2|EXIT=2|first||||NYX_IO'
  chke absent lock-released-on-write-error "$(if [ -d "$run_dir/nyx-ask-first.lock" ]; then echo leaked; else echo absent; fi)"
  run_case ask-output-write-error "$rows_one" NYX_TEST_WRITE_ERROR=submit
  check_run '2|EXIT=2|first||||NYX_IO'
  chke absent lock-released-on-output-error "$(if [ -d "$run_dir/nyx-ask-first.lock" ]; then echo leaked; else echo absent; fi)"
  run_case ask-unknown-capacity "${rows_one/|0|1|/|0|?|}"
  check_run '4|EXIT=4|||||NYX_NOPOOL'
  run_case ask-zero-capacity "${rows_one/|0|1|/|0|0|}"
  check_run '4|EXIT=4|||||NYX_NOPOOL'
  run_case ask-unknown-inflight "${rows_one/|0|1|/|0|?|}" NYX_POOL=first NYX_LIMIT=100
  check_run '4|EXIT=4|||||NYX_UNKNOWN'
  for response in ask-missing-brief fetch-invalid-id; do
    run_case "$response" "$rows_one"
    check_run '2|EXIT=2|||||NYX_ERR'
    chke '' "no-cli-$response" "$(joined "$run_dir/calls")"
  done
  run_case fetch-delivery "${rows_one/answer/delivery}"
  check_run "1|EXIT=1||$id1|$id1||NYX_DELIVERY"
  # A fresh ask after terminal failure retains audit bytes and both IDs, but submits again.
  run_case ask-rerun-history "${rows_one/answer/extraction}" NYX_POOL=first
  cp "$run_out" "$run_dir/prior"
  run_env+=("NYX_TEST_ROWS=first|v|1|0|1|0|answer|$id2")
  run_child > "$run_dir/stdout" 2>&1; run_rc=$?
  check_run "0|EXIT=0|first,first|$id1,$id2|$id1,$id2||NYX_OK"
  run_args=(taskid "$run_out")
  chke "$id2" taskid-current "$(run_child)"
  chke yes ask-history-bytes "$(if tail -n +2 "$run_out.history" 2>/dev/null | cmp -s - "$run_dir/prior"; then echo yes; fi)"
  chke 1 ask-current-sentinel-count "$(grep -c '^EXIT=' "$run_out")"
  chke 1 ask-history-boundary "$(grep -Ec '^NYX_RUN_BOUNDARY [0-9T:Z-]+ ask$' "$run_out.history" 2>/dev/null)"
  cp "$run_out.history" "$run_dir/first-history"
  run_args=(ask "$run_dir/brief" "$run_out"); run_child > "$run_dir/stdout" 2>&1
  chke 2 ask-history-appends "$(grep -c '^NYX_RUN_BOUNDARY ' "$run_out.history")"
  chke yes ask-history-prefix-preserved "$(if head -n "$(wc -l < "$run_dir/first-history")" "$run_out.history" | cmp -s - "$run_dir/first-history"; then echo yes; fi)"
  run_args=(taskid "$run_dir/missing"); run_child > "$run_dir/taskid-missing" 2>&1; got=$?
  chke '1|' taskid-missing "$got|$(cat "$run_dir/taskid-missing")"
  # FIFO handshakes hold an actual fetch at result; the timeout only guards broken infrastructure.
  run_case fetch-timeout "${rows_one/answer/timeout}"
  cp "$run_out" "$run_dir/prior"
  mkfifo "$run_dir/ready" "$run_dir/release"
  exec 8<> "$run_dir/ready" 9<> "$run_dir/release"
  run_env+=("NYX_TEST_ROWS=${rows_one/answer/barrier}")
  run_child > "$run_dir/stdout" 2>&1 &
  local fetch_pid=$! ready='' running make_rc fetch_rc
  IFS= read -r -t 30 -u 8 ready || { echo 'infrastructure-hang-guard expired: fetch barrier'; fail=1; }
  run_args=(status "$run_out")
  running=$(run_child 2>/dev/null | awk '/(RUNNING|OK|UNKNOWN).*result$/ {print $(NF-2)}')
  run_script="$await_script"; run_args=(make "$run_out"); run_env+=('AWAIT_DEADLINE=0')
  run_child > "$run_dir/make-running" 2>&1; make_rc=$?
  printf 'release\n' >&9
  wait "$fetch_pid"; fetch_rc=$?
  exec 8>&- 9>&-
  run_script="$0"; run_args=(status "$run_out")
  got=$(run_child 2>/dev/null | awk '/(RUNNING|OK|UNKNOWN).*result$/ {print $(NF-2)}')
  chke 'ready|RUNNING|124|0|OK|EXIT=0' run-boundary-fetch-running "$ready|$running|$make_rc|$fetch_rc|$got|$(tail -1 "$run_out")"
  chke yes fetch-history-bytes "$(if tail -n +2 "$run_out.history" 2>/dev/null | cmp -s - "$run_dir/prior"; then echo yes; fi)"
  chke 1 fetch-current-sentinel-count "$(grep -c '^EXIT=' "$run_out")"
  run_case await-vote-fallback "$traversal"
  chke "0|$id1,$id2|yes|yes" await-vote-fallback "$run_rc|$(joined "$run_dir/polls")|$(if [ -f "$run_out.settled" ]; then echo yes; fi)|$(if grep -q "task=$id2 state=settled" "$run_dir/stdout"; then echo yes; fi)"
  run_case await-vote-exhausted "${traversal/answer/extraction}" NYX_TEST_UNIQUE_IDS=1
  chke "125|first,second,first,second|${id1%-*}-000000000001,${id2%-*}-000000000002,${id1%-*}-000000000003,${id2%-*}-000000000004|no|yes" await-vote-exhausted \
    "$run_rc|$(joined "$run_dir/submits")|$(joined "$run_dir/polls")|$(if [ -f "$run_out.settled" ]; then echo yes; else echo no; fi)|$(if grep -q 'state=exhausted attempts=2' "$run_dir/stdout"; then echo yes; fi)"
  run_case await-vote-timeout "${rows_one/answer/resume}"
  chke "0|first|$id1,$id1,$id1|yes" await-vote-timeout "$run_rc|$(joined "$run_dir/submits")|$(joined "$run_dir/polls")|$(if grep -q "task=$id1 state=settled" "$run_dir/stdout"; then echo yes; fi)"
  for response in quota busy delivery unknown; do
    rows="${rows_one/answer/$response}"; expected="125|first,first|"
    case "$response" in
      busy) rows="${rows_one/|0|1|/|1|1|}"; expected='125||';;
      delivery) expected="125|first,first|$id1,$id1";;   # nyx 只有一个池可投 → DELIVERY → await 重试至耗尽(预登记预测,2026-09-08)
      unknown) expected='7|first|';;
    esac
    run_case "await-vote-$response" "$rows"
    chke "$expected|no" "await-vote-$response" "$run_rc|$(joined "$run_dir/submits")|$(joined "$run_dir/polls")|$(if [ -f "$run_out.settled" ]; then echo yes; else echo no; fi)"
  done
  rm -rf "$testroot"
  [ $fail -eq 0 ] && echo "SELFTEST_OK cases=$cases" || echo "SELFTEST_FAIL cases=$cases"
  return $fail
}

case "${1:-}" in
  --selftest) __selftest; exit $? ;;
  taskid) [ "$#" -eq 2 ] && __taskid "$2"; exit $? ;;
  pools) __validate_settings || exit 2; __pools_table ;;
  inflight)
    __validate_settings || exit 2
    [ -n "$POOL" ] || POOL=$(__pool_rows | __rank_pools | head -1)
    [ -n "$POOL" ] || { echo "NYX_NOPOOL 没有可用池"; exit 4; }
    __inflight ;;
  status)
    __validate_settings || exit 2
    printf "%-8s %-26s %6s %s\n" 时间 状态 字节 文件
    for f in ${2:-/tmp/nyx-*.out}; do
      printf "  %-8s %-26s %5sB %s\n" "$(stat -f '%Sm' -t '%H:%M' "$f")" "$(__classify "$f")" \
        "$(wc -c <"$f"|tr -d ' ')" "$(basename "$f" .out)"
    done | sort -k2
    [ -n "$POOL" ] || POOL=$(__pool_rows | __rank_pools | head -1)
    echo "  ---- pool=${POOL:-<none>} in-flight=$(__inflight)/${LIMIT:-$(__capacity)}"
    ;;
  fetch)
    # `ask` 的取回循环有上限;一个深研究任务(读 500KB 理论卷 + 仓库树)常跑得比它久。
    # 那时任务**仍活在池里**,只是没有动词能续等 —— 本会话两次撞上,故补此动词(器律⑥″:一切经器)。
    # 幂等:重复调用只是再取一次;不重复提交,不消耗配额。
    tid="${2:-}"; out="${3:-}"
    __open_output "$out" fetch || exit 2
    __validate_settings || exit 2
    [ "$#" -eq 3 ] || { echo 'NYX_ERR fetch needs <task-id> <outfile>' >&2; exit 2; }
    [ -n "$tid" ] || { echo "NYX_ERR fetch 需要 <task-id>"; exit 2; }
    [ -n "$out" ] || { echo "NYX_ERR fetch 需要 <outfile>"; exit 2; }
    __uuid "$tid" || { echo "NYX_ERR fetch 的 <task-id> 不是 uuid 形: $tid"; exit 2; }
    __open_taskids "$out" || exit 2
    if [ "$(__taskid "$out")" != "$tid" ]; then __append "$out.taskid" "$tid" || exit 2; fi
    __poll_task "$tid" "$out"; exit $?
    ;;
  ask)
    brief="${2:-}"; out="${3:-}"
    if [ "$brief" -ef "$out" ] || [ "$brief" -ef "$out.taskid" ] || [ "$brief" -ef "$out.history" ]; then
      echo 'NYX_ERR brief and recovery artifacts must be separate files' >&2; exit 2
    fi
    __open_output "$out" ask || exit 2
    __validate_settings || exit 2
    [ "$#" -eq 3 ] && [ -f "$brief" ] && [ -r "$brief" ] || { echo "NYX_ERR ask needs a readable brief and outfile: $brief"; exit 2; }
    [ -d "${TMPDIR:-/tmp}" ] && [ -w "${TMPDIR:-/tmp}" ] || { echo 'NYX_ERR TMPDIR must be writable' >&2; exit 2; }
    __open_taskids "$out" || exit 2
    if [ -n "$POOL" ]; then
      candidates="$POOL"   # 显式指定:只投这一个池,不遍历(调用方要确定性)
    else
      candidates=$(__pool_rows | __rank_pools | tr '\n' ' ')
      echo "NYX_POOLS ranked=[${candidates% }] bad_scripts=[$BAD_SCRIPTS]"
      [ -n "${candidates% }" ] || { echo "NYX_NOPOOL 没有可用池(全部过期/零在线/坏脚本/容量未知或零);查 nyx.sh pools"; exit 4; }
    fi
    rc=1; LAST_VERDICT=""; previous_pool=""
    for POOL in $candidates; do
      [ -z "$previous_pool" ] || echo "NYX_NEXT_POOL after=$previous_pool verdict=$LAST_VERDICT"
      previous_pool="$POOL"
      LIMIT="${NYX_LIMIT:-}"   # 每池按自报容量重新派生
      __submit_and_poll "$brief" "$out"; rc=$?
      case "$LAST_VERDICT" in
        EXTRACTION|QUOTA|BUSY|EXPIRED|DELIVERY) ;;   # 载体侧/容量侧失败 → 换池重投同一份 brief(DELIVERY:prompt 未被消费,换池安全)
        *) break;;   # OK / TIMEOUT(任务仍活,不重投)/ NOFILE / UNKNOWN(我方 bug,换池无益)
      esac
    done
    exit $rc
    ;;
  *) echo "usage: nyx.sh {ask <brief> <out>|fetch <task-id> <out>|taskid <out>|pools|status [glob]|inflight|--selftest}" >&2; exit 2 ;;
esac
