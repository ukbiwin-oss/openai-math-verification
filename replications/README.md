# Comparator replications

Each folder holds `summary.csv` (challenge, exit code, verdict, start, end, seconds), `versions.txt` (exact tool
versions) and one Comparator log per challenge. Logs are unedited except that local paths and machine names were
replaced by placeholders.

## How to rerun

On Linux with Landlock enabled (kernel ≥ 5.13) and no sudo:

```sh
git clone --filter=blob:none --no-checkout https://github.com/openai/math.git openai-math
cd openai-math && git sparse-checkout set --no-cone /lean/ && git checkout --detach fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb && cd ..
# install elan (Lean) and Go in user space, then:
ROOT=$PWD SRC=$PWD/openai-math/lean WORK=$PWD/work LOG=$PWD/run \
  setsid nohup bash scripts/run_comparator_v2.sh CriticalZ3 Heisenberg CriticalPercolation LaughlinFock >/dev/null 2>&1 &
tail -f run/run.log
```

The script installs the project's Lean toolchain, runs `lake update` (refusing if any dependency pin would move) and
`lake exe cache get`, builds lean4export and Comparator from their tags matching the project's Lean version, builds
landrun and checks that it blocks writes, adds a seccomp guard against AF_UNIX sockets, and then lets Comparator compile
the challenge and solution inside the sandbox. It resumes if interrupted. Expect several GB of downloads and, for
LaughlinFock, more than an hour of build time.
