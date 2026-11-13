#!/bin/bash
# Replicate the Comparator check of anthropics/formal-math eth/ at commit 16a5ce41 (13 Nov 2026).
# Runs the repository's own CI script unmodified (.github/scripts/comparator-check.sh): Comparator with a
# toolchain-matched lean4export, the nanoda second kernel and the landrun sandbox, at the script's pinned commits.
# Only the tool and log directories are redirected into this folder.
set -uo pipefail
R=$ROOT
export PATH=$HOME/.elan/bin:$HOME/.cargo/bin:$HOME/go/pkg/mod/golang.org/toolchain@v0.0.1-go1.26.9.linux-amd64/bin:$PATH
export TOOLS_DIR=$R/tools LOG_DIR=${LOG_DIR:-$R/run}
mkdir -p "$LOG_DIR"
cd "$R/formal-math/eth" || exit 1
{
  echo "date: $(date -u)"; echo "host: $(hostname), kernel $(uname -r)"
  echo "repository: anthropics/formal-math $(git rev-parse HEAD)"
  echo "toolchain file: $(cat lean-toolchain)"; echo "lean: $(lean --version 2>&1)"; echo "lake: $(lake --version 2>&1)"
  echo "go: $(go version 2>&1)"; echo "cargo: $(cargo --version 2>&1)"; echo "jq: $(jq --version 2>&1)"
  echo "stack limit (ulimit -s): $(ulimit -s)"
  echo "tool pins: see the head of .github/scripts/comparator-check.sh; lean4export commit is printed in comparator-check.log"
} > "$LOG_DIR/versions.txt" 2>&1
s=$(date -u +%s)
lake exe cache get > "$LOG_DIR/cache-get.log" 2>&1 || { echo "eth,1,ABORT: lake exe cache get,$s,$(date -u +%s),," >> "$LOG_DIR/summary.csv"; exit 1; }
c=$(date -u +%s)
bash ../.github/scripts/comparator-check.sh > "$LOG_DIR/comparator-check.log" 2>&1; r=$?
e=$(date -u +%s)
cg=/sys/fs/cgroup$(cut -d: -f3 /proc/self/cgroup)
[ -f "$LOG_DIR/summary.csv" ] || echo "check,exit_code,verdict,start_utc_s,end_utc_s,seconds_total,seconds_check,cgroup_peak_bytes" > "$LOG_DIR/summary.csv"
echo "eth,$r,$([ $r -eq 0 ] && echo PASS || echo FAIL),$s,$e,$((e-s)),$((e-c)),$(cat $cg/memory.peak 2>/dev/null)" >> "$LOG_DIR/summary.csv"
exit $r
