#!/usr/bin/env bash
# nyx.sh — nyxid 派票与状态分类。**不要再用 `tail -1` 肉眼判成败。**
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
#   nyx.sh pools                     打印全部 active 池的排名表(脚本版本/在线 worker/空位/队列/可用性)
#   nyx.sh status [glob]             分类打印 /tmp/nyx-*.out 的真实状态
#   nyx.sh inflight                  当前 in-flight 数(NYX_POOL 或排名第一的池)
export PATH="$HOME/.local/bin:$PATH"
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

__classify() {  # 读一个 .out,打印:OK|EXTRACTION|QUOTA|NOFILE|RUNNING|UNKNOWN
  local f="$1"
  [ -f "$f" ] || { echo NOFILE_OUT; return; }
  if [ "$(tail -1 "$f")" = "EXIT=0" ]; then echo OK; return; fi
  grep -q 'oracle_quota_exceeded\|HTTP 429' "$f" && { echo QUOTA; return; }
  grep -q 'Failed to read prompt' "$f" && { echo NOFILE; return; }
  grep -q 'extraction_failure' "$f" && { echo EXTRACTION; return; }
  grep -q 'EXIT=' "$f" && { echo UNKNOWN; return; }
  echo RUNNING   # 无 EXIT= 行 ⟹ 进程还没结束
}

__expired() {  # 会话过期是能力缺口,不是池满 —— 必须与 in-flight 区分,否则白等 10 分钟
  nyxid oracle status "$POOL" 2>&1 | grep -q 'session has expired' && return 0 || return 1
}
__capacity() {  # pool 自报的总容量(Dispatched: N / M 的 M)
  local m
  m=$(nyxid oracle status "$POOL" 2>&1 | grep -oE 'Dispatched: *[0-9]+ */ *[0-9]+' | grep -oE '[0-9]+$')
  echo "${m:-2}"   # 读不到退回保守值,fail-closed
}
__script_ver() {  # pool 自报的 worker 脚本版本 —— `extraction_failure` 的第一诊断位。
  # 取表格首个数据行的最后一列(Script)。读不到就空,调用方按缺失处理,不猜。
  # 注:`nyxid oracle status` 把表写到 **stderr**,必须 2>&1(与 __inflight 同坑)。
  nyxid oracle status "$POOL" 2>&1 | __script_ver_parse
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
  local n
  n=$(nyxid oracle status "$POOL" 2>&1 | grep -oE 'Dispatched: *[0-9]+' | grep -oE '[0-9]+$')
  echo "${n:-99}"   # 读不到就当满,fail-closed:宁可等,不可再打 429
  # 注:`nyxid oracle status` 把状态写到 **stderr**,必须 2>&1,否则恒为空 → 恒判 99
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
  # online = 状态表数据行数(每行一个 worker);script = 首个数据行的 Script 列;读不到的数字记 0,expired 由文本判。
  local slug="$1"
  awk -v slug="$slug" -F'┆' '
    /session has expired/ { expired = 1 }
    /Queued:/     { if (match($0, /Queued: *[0-9]+/)) { q = substr($0, RSTART, RLENGTH); sub(/Queued: */, "", q); queued = q } }
    /Dispatched:/ { if (match($0, /Dispatched: *[0-9]+ *\/ *[0-9]+/)) { d = substr($0, RSTART, RLENGTH); sub(/Dispatched: */, "", d); split(d, p, /\//); gsub(/ /, "", p[1]); gsub(/ /, "", p[2]); dispatched = p[1]; capacity = p[2] } }
    /┆/ {
      v = $NF; gsub(/[│┆]/, "", v); gsub(/^[ \t]+|[ \t]+$/, "", v)
      if (v != "" && v != "Script") { online++; if (script == "") script = v }
    }
    END { printf "%s|%s|%d|%d|%d|%d|%d\n", slug, script, online+0, dispatched+0, capacity+0, queued+0, expired+0 }'
}
__rank_pools() {  # 纯函数:stdin 读 __pool_stats_parse 的行,打印可用池 slug,按 空位 desc、队列 asc、slug asc
  # 可用 = 未过期 ∧ 在线 worker>0 ∧ 脚本已知 ∧ 脚本不以 BAD_SCRIPTS 任一前缀开头;空位 = min(在线, 容量) − dispatched(下限 0)
  awk -F'|' -v bad="$BAD_SCRIPTS" '
    BEGIN { nb = split(bad, B, / +/) }
    {
      slug = $1; script = $2; online = $3 + 0; dispatched = $4 + 0; capacity = $5 + 0; queued = $6 + 0; expired = $7 + 0
      if (expired || online == 0 || script == "") next
      isbad = 0; for (i = 1; i <= nb; i++) if (B[i] != "" && index(script, B[i]) == 1) isbad = 1
      if (isbad) next
      cap = (capacity > 0 && capacity < online) ? capacity : online
      free = cap - dispatched; if (free < 0) free = 0
      printf "%d %d %s\n", free, queued, slug
    }' | sort -k1,1nr -k2,2n -k3,3 | awk '{ print $3 }'
}
__pool_rows() {  # 取数:遍历全部 active 池,打印 __pool_stats_parse 行(每池一次 status 调用)
  local s
  for s in $(nyxid oracle pool list 2>/dev/null | __pools_active_parse); do
    nyxid oracle status "$s" 2>&1 | __pool_stats_parse "$s"
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
  local r="$1" first
  case "$r" in
    *oracle_quota_exceeded*|*"HTTP 429"*) echo QUOTA;      return;;
    *"Failed to read prompt"*)            echo NOFILE;     return;;
    *extraction_failure*)                 echo EXTRACTION; return;;
  esac
  [ -n "$r" ] || { echo UNKNOWN; return; }
  first=${r%%$'\n'*}
  case "$first" in "Error:"*) echo UNKNOWN; return;; esac
  echo OK
}

__poll_task() {  # <task-id> <outfile> —— 轮询取回,落判词与 EXIT= 哨兵。ask 与 fetch 共用**同一份**实现。
  # **这不是挂钟猜测**(器律⑥′):池无 webhook,`nyxid oracle result` 是唯一取回原语;
  # 间隔对齐真实任务时长(实测数分钟级),有上限,且判据(__verdict_of_payload)在开跑前已写死。
  local tid="$1" out="$2" n=0 r rc verdict
  while [ $n -lt "${NYX_POLL_ROUNDS:-60}" ]; do
    r=$(nyxid oracle result "$tid" 2>&1)
    case "$r" in *"Task is dispatched"*|*"Phase:"*|*queued*) ;; *) printf '%s\n' "$r" >> "$out"; break;; esac
    n=$((n+1)); sleep "${NYX_POLL_SECONDS:-20}"
  done
  if [ $n -ge "${NYX_POLL_ROUNDS:-60}" ]; then
    echo "NYX_TIMEOUT $tid 仍未落定;可随时 nyx.sh fetch $tid <out> 续等,或 nyxid oracle result $tid 取回"
    rc=3; verdict=TIMEOUT
  else
    verdict=$(__verdict_of_payload "$r")
    case "$verdict" in OK) rc=0;; *) rc=1;; esac
  fi
  echo "EXIT=$rc" >> "$out"
  echo "NYX_$verdict $(basename "$out" .out)"
  LAST_VERDICT="$verdict"
  return $rc
}

__submit_and_poll() {  # <brief> <out> —— 对当前 $POOL 投一票并取回;返回 __poll_task 的 rc,LAST_VERDICT 记判词
  local brief="$1" out="$2" n rc tid
  [ -n "$LIMIT" ] || LIMIT="$(__capacity)"
  # 会话过期 → 立刻报能力缺口,不要当池满去等 10 分钟(2026-08-28 实测遇到)
  __expired && { echo "NYX_EXPIRED pool=$POOL 会话已过期 —— 需人跑 \`nyxid login\`(第15条:能力缺口,等灯亮)"; LAST_VERDICT=EXPIRED; return 4; }
  # **锁**:检查 in-flight 与提交之间必须原子,否则两个并发 ask 会都看到有空位、都提交 → 429。
  # (2026-08-28 实测:并发两个 ask,in-flight=3,两者都判有空位,一者得 QUOTA。
  #  这是 TOCTOU 竞态 —— 器自己犯了它要防的那个错。)
  # 锁**按 pool 分片**:跨 pool 本无竞态,共用一把锁会让空闲 pool 的票排在满 pool 的票后面。
  LOCK="${TMPDIR:-/tmp}/nyx-ask-${POOL}.lock"
  n=0
  while ! mkdir "$LOCK" 2>/dev/null; do
    n=$((n+1)); [ $n -gt 120 ] && { echo "NYX_LOCKBUSY 等锁超时: $out"; LAST_VERDICT=LOCKBUSY; return 3; }
    sleep 5
  done
  trap 'rmdir "$LOCK" 2>/dev/null' EXIT INT TERM
  # 持锁期间等空位,再提交 —— 提交后立刻放锁(任务已计入 in-flight)
  n=0
  while [ "$(__inflight)" -ge "$LIMIT" ] && [ $n -lt 30 ]; do sleep 20; n=$((n+1)); done
  if [ "$(__inflight)" -ge "$LIMIT" ]; then
    rmdir "$LOCK" 2>/dev/null; trap - EXIT
    echo "NYX_BUSY pool=$POOL 等了 10 分钟仍满($LIMIT),放弃: $out"; LAST_VERDICT=BUSY; return 3
  fi
  # **--no-wait + 记 task id**:阻塞等待会让「我的进程生死」决定「任务是否丢失」。
  # 2026-08-28 实测:前台 ask 被 2min 超时杀、后台 ask 被 SIGTERM(exit 143)杀,
  # 而 `nyxid oracle result <task-id>` 显示**任务在池里仍活着**(`Phase: waiting_response`)。
  # 故改为提交后立刻拿 id 落盘,等待与取回分离 —— 被杀只丢等待,不丢工作。
  # **提交前把产地打出来**:失败判词只说 `extraction_failure`,不说是哪个 pool、哪个 worker 脚本,
  # 于是每次都要另跑一条 `nyxid oracle status` 才能归因。产地进输出即自诊断(第 8.4 条)。
  echo "NYX_SUBMIT pool=$POOL script=$(__script_ver) tag=$TAG brief_bytes=$(wc -c <"$brief" | tr -d ' ') out=$out"
  nyxid oracle ask "$POOL" --file "$brief" --tag "$TAG" --no-wait >> "$out" 2>&1; rc=$?
  tid=$(grep -oE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' "$out" | tail -1)
  [ -n "$tid" ] && echo "$tid" >> "$out.taskid"
  rmdir "$LOCK" 2>/dev/null; trap - EXIT
  if [ -z "$tid" ]; then
    LAST_VERDICT=$(__verdict_of_payload "$(cat "$out")")
    echo "EXIT=$rc" >> "$out"; echo "NYX_$LAST_VERDICT $(basename "$out" .out)"; return $rc
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
  local fail=0 got
  chk() {  # chk <期望> <名字> <payload>
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
  chk UNKNOWN    carrier-bare-error         'Error: forbidden'
  chk UNKNOWN    empty-payload              ''
  # Script 列解析的阳性/阴性对照:缺省 pool 的选择依赖它,解析错了就诊断错了。
  chkv() {  # chkv <期望> <名字> <表格文本>
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
  chke 'chrono||0|0|0|0|1' pool-stats-parse-expired "$(printf '%s\n' "$st_expired" | __pool_stats_parse chrono)"
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

  # 回归钉:文件级 __classify 在「最后一行是答案」的文件上必判 RUNNING,
  # 这正是它不能用于活判决的原因;若有人把它改回去,本例变红。
  local tmp; tmp=$(mktemp)
  printf 'Task submitted.\n\n{"ok":true}\n' > "$tmp"
  got=$(__classify "$tmp"); rm -f "$tmp"
  if [ "$got" = RUNNING ]; then printf '  ok   %-30s %s\n' file-classifier-unusable-live "$got"
  else printf '  FAIL %-30s expected=RUNNING got=%s\n' file-classifier-unusable-live "$got"; fail=1; fi
  # 接线钉:活判决必须用 __verdict_of_payload,不得退回文件级 __classify。
  # 载体是 shell,无语言服务器(器律⑩ 的辨析允许对这类载体作窄形状断言);
  # 断言窄到一条赋值形状,不是通用文本判语义。
  if grep -qE 'verdict=\$\(__classify' "$0"; then
    printf '  FAIL %-30s live verdict still reads the file classifier\n' wiring-uses-payload-classifier; fail=1
  else
    printf '  ok   %-30s %s\n' wiring-uses-payload-classifier verdict_of_payload
  fi
  # 接线钉:ask 的池选择与 pools 动词必须用同一个排名函数(否则表上说可用、票却投别处)。
  if [ "$(grep -c '__rank_pools' "$0")" -ge 4 ]; then
    printf '  ok   %-30s %s\n' wiring-ask-uses-rank-pools shared
  else
    printf '  FAIL %-30s ask/pools 不共用 __rank_pools\n' wiring-ask-uses-rank-pools; fail=1
  fi
  [ $fail -eq 0 ] && echo "SELFTEST_OK" || echo "SELFTEST_FAIL"
  return $fail
}

case "$1" in
  --selftest) __selftest; exit $? ;;
  pools) __pools_table ;;
  inflight)
    [ -n "$POOL" ] || POOL=$(__pool_rows | __rank_pools | head -1)
    [ -n "$POOL" ] || { echo "NYX_NOPOOL 没有可用池"; exit 4; }
    __inflight ;;
  status)
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
    tid="$2"; out="$3"
    [ -n "$tid" ] || { echo "NYX_ERR fetch 需要 <task-id>"; exit 2; }
    [ -n "$out" ] || { echo "NYX_ERR fetch 需要 <outfile>"; exit 2; }
    case "$tid" in
      [0-9a-f]*-[0-9a-f]*-[0-9a-f]*-[0-9a-f]*-[0-9a-f]*) ;;
      *) echo "NYX_ERR fetch 的 <task-id> 不是 uuid 形: $tid"; exit 2 ;;
    esac
    : > "$out"
    echo "$tid" > "$out.taskid"
    __poll_task "$tid" "$out"; exit $?
    ;;
  ask)
    brief="$2"; out="$3"
    [ -f "$brief" ] || { echo "NYX_ERR brief 不存在: $brief"; exit 2; }   # 110B 那个 bug 的门
    [ -n "$out" ] || { echo "NYX_ERR ask 需要 <outfile>"; exit 2; }
    : > "$out"; : > "$out.taskid"
    if [ -n "$POOL" ]; then
      candidates="$POOL"   # 显式指定:只投这一个池,不遍历(调用方要确定性)
    else
      candidates=$(__pool_rows | __rank_pools | tr '\n' ' ')
      echo "NYX_POOLS ranked=[${candidates% }] bad_scripts=[$BAD_SCRIPTS]"
      [ -n "${candidates% }" ] || { echo "NYX_NOPOOL 没有可用池(全部过期/零在线/坏脚本);查 nyx.sh pools"; echo "EXIT=4" >> "$out"; exit 4; }
    fi
    rc=1; LAST_VERDICT=""
    for POOL in $candidates; do
      LIMIT="${NYX_LIMIT:-}"   # 每池按自报容量重新派生
      __submit_and_poll "$brief" "$out"; rc=$?
      case "$LAST_VERDICT" in
        EXTRACTION|QUOTA|BUSY|EXPIRED) echo "NYX_NEXT_POOL after=$POOL verdict=$LAST_VERDICT";;   # 载体侧/容量侧失败 → 换池重投同一份 brief
        *) break;;   # OK / TIMEOUT(任务仍活,不重投)/ NOFILE / UNKNOWN(我方 bug,换池无益)
      esac
    done
    exit $rc
    ;;
  *) echo "usage: nyx.sh {ask <brief> <out>|fetch <task-id> <out>|pools|status [glob]|inflight|--selftest}" >&2; exit 2 ;;
esac
