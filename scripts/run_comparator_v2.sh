#!/usr/bin/env bash
# run_comparator_v2.sh: independent Comparator check of OpenAI-repo Lean challenges (corrected).
# Written by Claude, 10 Oct 2026 (evening). run_comparator.sh (v1) is kept for the record.
#
# Why v2. v1's run (14:52-14:57 UTC, 10 Oct) never finished: the LaughlinFock build was stopped by
# SIGINT (Ctrl-C) after 62 s, and a restart at 14:57:21 stopped inside `lake update`. v1 also had
# two faults that this version fixes:
#  1. v1 built lean4export and comparator from master, on Lean 4.35.0-rc4. The library uses Lean
#     4.34.1, and Comparator needs a lean4export matched to the project's Lean version, so the
#     export step would have failed whatever the proofs said. v2 builds both from their tag for the
#     project's Lean version (v4.34.0), on the project's exact toolchain (read from lean-toolchain).
#  2. v1 compiled the solution outside the sandbox before calling Comparator. Comparator's trust
#     model assumes the solution was never compiled outside its sandbox. v2 lets Comparator do all
#     the building inside landrun, in a fresh copy whose .lake holds only dependencies and the
#     Mathlib cache.
#  Also: v2 applies the AF_UNIX restriction the Comparator README asks for (the README uses
#  systemd-run, which can't run detached; v2 applies the same seccomp rule with a small Python
#  wrapper), runs detached, and writes summary.csv as each challenge finishes.
#
# START (one line, from anywhere on machine-1; closing the terminal won't stop it):
#   setsid nohup bash ~/claude2/claude-ftl-research-resources/analysis/beyond-ftl/2026-10-10/run_comparator_v2.sh >/dev/null 2>&1 &
# Default challenges, smallest first: CriticalZ3 Heisenberg LaughlinFock. To choose, name them:
#   setsid nohup bash .../run_comparator_v2.sh CriticalZ3 >/dev/null 2>&1 &
# WATCH:  tail -f ~/claude2/claude-ftl-research-resources/analysis/beyond-ftl/2026-10-10/comparator-run-v2/run.log
# RESULT: ~/claude2/claude-ftl-research-resources/analysis/beyond-ftl/2026-10-10/comparator-run-v2/summary.csv
# STOP:   pkill -f run_comparator_v2.sh; pkill -f 'comparator-work-v2'
#         Re-running resumes: finished challenges are skipped (FORCE=1 redoes them).
#
# Installs nothing system-wide and needs no sudo. Writes only under analysis/beyond-ftl/
# (comparator-work-v2/ and 2026-10-10/comparator-run-v2/) and ~/.elan (Lean toolchains; already
# present from v1). Downloads: Lean toolchain if missing, the library's git dependencies, the Mathlib
# cache, and the comparator/lean4export/landrun sources (same tools v1 used, at matched versions).

set -uo pipefail
ROOT=${ROOT:-$HOME/claude2/claude-ftl-research-resources}
SRC=${SRC:-$ROOT/sources/openai-math/lean}
WORK=${WORK:-$ROOT/analysis/beyond-ftl/comparator-work-v2}
LOG=${LOG:-$ROOT/analysis/beyond-ftl/2026-10-10/comparator-run-v2}
TOOLS=$WORK/tools
LEAN_DIR=$WORK/lean
V1_GO=$ROOT/analysis/beyond-ftl/comparator-work/tools/go/bin
if [ $# -gt 0 ]; then CHALLENGES=("$@"); else CHALLENGES=(CriticalZ3 Heisenberg LaughlinFock); fi

mkdir -p "$TOOLS/bin" "$LOG" || exit 1
exec >>"$LOG/run.log" 2>&1
trap 'echo "=== stopped by signal $(date -u)"; exit 130' INT TERM
export PATH=$HOME/.elan/bin:$TOOLS/bin:$HOME/go/bin:/usr/local/go/bin:$V1_GO:$PATH
export GLIBC_TUNABLES=glibc.malloc.mmap_max=0:glibc.malloc.arena_max=1   # the repo README's mmap workaround
export GIT_TERMINAL_PROMPT=0   # fail instead of waiting for a password if a dependency URL ever asks
[ -f "$LOG/summary.csv" ] || echo "challenge,exit_code,verdict,start_utc,end_utc,seconds" > "$LOG/summary.csv"
fail() { local m="$*"; echo "ABORT: $m  ($(date -u))"; echo "setup,1,ABORT: ${m//,/;},,$(date -u +%FT%TZ)," >> "$LOG/summary.csv"; exit 1; }

echo "=== v2 start $(date -u) on $(hostname); kernel $(uname -r); nproc=$(nproc); mem=$(free -g | awk '/Mem/{print $2}')G; free disk=$(df -h "$ROOT" | awk 'NR==2{print $4}')"
echo "challenges: ${CHALLENGES[*]}"

# 0. elan (Lean version manager); v1 already installed it.
if ! command -v elan >/dev/null 2>&1; then
  curl -sSfL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -o "$TOOLS/elan-init.sh" || fail "elan download"
  bash "$TOOLS/elan-init.sh" -y --default-toolchain none --no-modify-path || fail "elan install"
fi

# 1. Fresh copy of the library: no build outputs from earlier runs.
if [ ! -f "$WORK/.copy-complete" ]; then
  rm -rf "$LEAN_DIR"
  cp -a "$SRC" "$LEAN_DIR" || fail "copy of $SRC"
  rm -rf "$LEAN_DIR/.lake"
  touch "$WORK/.copy-complete"
fi
cd "$LEAN_DIR" || fail "cd $LEAN_DIR"
TC=$(tr -d '[:space:]' < lean-toolchain)                      # leanprover/lean4:v4.34.1
VER=${TC##*:}                                                  # v4.34.1
MM=$(echo "$VER" | sed -E 's/^(v[0-9]+\.[0-9]+)\..*/\1/')      # v4.34
elan toolchain install "$TC" >/dev/null 2>&1
echo "project toolchain $TC: $(lean --version)"

# 2. Dependencies and Mathlib cache (the repo README's procedure). lake update must not move any pin.
if [ ! -f "$WORK/.deps-complete" ]; then
  before=$(sha256sum lake-manifest.json | cut -d' ' -f1)
  lake update > "$LOG/lake-update.log" 2>&1 || fail "lake update (see lake-update.log)"
  after=$(sha256sum lake-manifest.json | cut -d' ' -f1)
  echo "lake-manifest.json sha256 before $before, after $after"
  [ "$before" = "$after" ] || fail "lake update changed lake-manifest.json; refusing to check against moved pins"
  lake exe cache get > "$LOG/cache-get.log" 2>&1 || fail "lake exe cache get (see cache-get.log)"
  tr '\r' '\n' < "$LOG/cache-get.log" | grep -v '^Downloaded:' | tail -4
  touch "$WORK/.deps-complete"
fi

# 3. lean4export and comparator from their tag for this Lean version, built on the project's toolchain.
for repo in lean4export comparator; do
  d=$TOOLS/$repo
  if [ ! -x "$d/.lake/build/bin/$repo" ]; then
    [ -d "$d" ] || git clone -q "https://github.com/leanprover/$repo" "$d" || fail "clone of $repo"
    ( cd "$d" && { git checkout -q --detach "$VER" 2>/dev/null || git checkout -q --detach "$MM.0"; } ) \
      || fail "$repo has no tag $VER or $MM.0"
    echo "$TC" > "$d/lean-toolchain"
    ( cd "$d" && lake build > "$LOG/build-$repo.log" 2>&1 ) || fail "build of $repo (see build-$repo.log)"
  fi
  ln -sf "$d/.lake/build/bin/$repo" "$TOOLS/bin/$repo"
  echo "$repo: tag $(cd "$d" && git describe --tags 2>/dev/null), commit $(cd "$d" && git rev-parse HEAD), built on $TC"
done

# 4. landrun (Landlock sandbox), the same version v1 built, then a check that it really blocks writes.
if [ ! -x "$TOOLS/bin/landrun" ]; then
  command -v go >/dev/null 2>&1 || fail "go not found"
  GOBIN=$TOOLS/bin go install github.com/zouuup/landrun/cmd/landrun@v0.1.17 > "$LOG/build-landrun.log" 2>&1 || fail "landrun build"
fi
ok=$WORK/.sandbox-allowed; probe=$WORK/.sandbox-denied; rm -f "$ok" "$probe"
landrun --best-effort --ro / --rw /dev --rwx "$WORK" -ldd -add-exec /usr/bin/touch "$ok" >/dev/null 2>&1
[ -e "$ok" ] || fail "landrun could not run a permitted command"
landrun --best-effort --ro / --rw /dev -ldd -add-exec /usr/bin/touch "$probe" >/dev/null 2>&1
[ -e "$probe" ] && { rm -f "$probe"; fail "landrun did not block a write (no Landlock?)"; }
rm -f "$ok"
echo "landrun $(landrun --version 2>&1 | awk '{print $NF}'): runs permitted commands and blocks writes"

# 5. AF_UNIX guard (stand-in for: systemd-run --property=RestrictAddressFamilies=~AF_UNIX).
cat > "$TOOLS/no-af-unix.py" <<'PY'
#!/usr/bin/env python3
"""Run a command with socket(AF_UNIX)/socketpair(AF_UNIX) and io_uring_setup denied (seccomp via
libseccomp). Stand-in for Comparator's recommended systemd-run RestrictAddressFamilies=~AF_UNIX.
The filter, and no_new_privs, is inherited by every child process."""
import ctypes, errno, os, sys
lib = ctypes.CDLL("libseccomp.so.2", use_errno=True)
SCMP_ACT_ALLOW = 0x7FFF0000
def act_errno(e): return 0x00050000 | (e & 0xFFFF)
class Cmp(ctypes.Structure):
    _fields_ = [("arg", ctypes.c_uint), ("op", ctypes.c_int), ("a", ctypes.c_uint64), ("b", ctypes.c_uint64)]
SCMP_CMP_MASKED_EQ = 7
lib.seccomp_init.restype = ctypes.c_void_p; lib.seccomp_init.argtypes = [ctypes.c_uint32]
lib.seccomp_syscall_resolve_name.argtypes = [ctypes.c_char_p]
lib.seccomp_rule_add_array.argtypes = [ctypes.c_void_p, ctypes.c_uint32, ctypes.c_int, ctypes.c_uint, ctypes.POINTER(Cmp)]
lib.seccomp_load.argtypes = [ctypes.c_void_p]
ctx = lib.seccomp_init(SCMP_ACT_ALLOW)
assert ctx
for name in (b"socket", b"socketpair"):
    nr = lib.seccomp_syscall_resolve_name(name)
    arr = (Cmp * 1)(Cmp(0, SCMP_CMP_MASKED_EQ, 0xFFFFFFFF, 1))   # domain == AF_UNIX (1)
    assert lib.seccomp_rule_add_array(ctx, act_errno(errno.EAFNOSUPPORT), nr, 1, arr) == 0
nr = lib.seccomp_syscall_resolve_name(b"io_uring_setup")
assert lib.seccomp_rule_add_array(ctx, act_errno(errno.EPERM), nr, 0, None) == 0
assert lib.seccomp_load(ctx) == 0
os.execvp(sys.argv[1], sys.argv[1:])
PY
GUARD=(python3 "$TOOLS/no-af-unix.py")
"${GUARD[@]}" /bin/true || fail "AF_UNIX guard does not start (libseccomp missing?)"
"${GUARD[@]}" python3 -c 'import socket; socket.socket(socket.AF_UNIX)' >/dev/null 2>&1 && fail "AF_UNIX guard not effective"
echo "AF_UNIX guard: active"

# Record exact versions.
{
  echo "date: $(date -u)"; echo "host: $(hostname), kernel $(uname -r)"
  echo "library: $SRC (openai/math commit $(git -C "$ROOT/sources/openai-math" rev-parse HEAD 2>/dev/null || echo unknown))"
  echo "lean: $(lean --version)"; echo "lake: $(lake --version)"
  echo "mathlib: $(python3 -c "import json;print([p['rev'] for p in json.load(open('lake-manifest.json'))['packages'] if p['name']=='mathlib'][0])")"
  for repo in lean4export comparator; do echo "$repo: $(git -C "$TOOLS/$repo" rev-parse HEAD) ($(git -C "$TOOLS/$repo" describe --tags 2>/dev/null))"; done
  echo "landrun: $(landrun --version 2>&1)"
} > "$LOG/versions.txt"

# 6. The checks. Comparator builds challenge and solution itself, inside landrun.
export COMPARATOR_LANDRUN=$TOOLS/bin/landrun COMPARATOR_LEAN4EXPORT=$TOOLS/bin/lean4export
for C in "${CHALLENGES[@]}"; do
  cfg=ComparatorChallenges/$C.json
  [ -f "$cfg" ] || { echo "no such challenge: $cfg"; continue; }
  if [ "${FORCE:-0}" != 1 ] && grep -qE "^$C,[0-9]+,(PASS|FAIL)," "$LOG/summary.csv"; then
    echo "=== $C already done (FORCE=1 to redo)"; continue
  fi
  s=$(date -u +%FT%TZ); t0=$(date +%s)
  echo "=== $C: comparator start $s"
  nice -n 10 "${GUARD[@]}" lake env "$TOOLS/bin/comparator" "$cfg" > "$LOG/$C.comparator.log" 2>&1; r=$?
  e=$(date -u +%FT%TZ); dt=$(( $(date +%s) - t0 ))
  if [ $r -eq 0 ] && grep -q "Your solution is okay!" "$LOG/$C.comparator.log"; then v=PASS
  elif [ $r -gt 128 ]; then v=INTERRUPTED
  else v=FAIL; fi        # FAIL = Comparator rejected it OR a build/infrastructure error: read the log
  echo "$C,$r,$v,$s,$e,$dt" >> "$LOG/summary.csv"
  echo "=== $C: $v (exit $r, $dt s)"; tail -25 "$LOG/$C.comparator.log"
done
echo "=== v2 done $(date -u)"; cat "$LOG/summary.csv"
