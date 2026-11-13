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


## Second-kernel runs of the two ETH formalisations

- `machine-1-2026-11-02-sat-nanoda/` and `machine-2-2026-11-02-sat-nanoda/`: OpenAI's `SubexponentialSAT` challenge
  through Comparator with nanoda enabled (a work-directory copy of the config with `enable_nanoda: true`). Machine 1
  has two logs: the first attempt, where nanoda's 32 MiB thread stack overflowed while the Lean kernel accepted, and the
  passing run with nanoda rebuilt with a 1 GiB default (`hygiene/nanoda-bigstack-util.rs.diff`). `versions.txt` in each
  folder says what was and was not recorded.
- `anthropic-formal-math-eth-machine-1-2026-11-13/`: Anthropic's `eth/` project at anthropics/formal-math `16a5ce41`,
  checked with that repository's own script, `.github/scripts/comparator-check.sh`, unmodified. `run_eth_check.sh` is
  the wrapper used here; it only redirects the tool and log folders and records versions, time and peak memory.
  Four runs, in `summary.csv`: run 1 crashed (Comparator exit status 139 at the nanoda step, no verdict), runs 2 to 4
  pass both kernels. Run 2 had the process stack limit lifted, runs 3 and 4 did not, and run 4 rebuilt the project from
  cold, so neither the stack limit nor a cold build explains run 1. To rerun:

```sh
git clone --filter=blob:none https://github.com/anthropics/formal-math.git && cd formal-math
git checkout --detach 16a5ce41304fcdaea4e0be7c132e1c361dc26da5 && cd eth
lake exe cache get && bash ../.github/scripts/comparator-check.sh    # needs elan, git, go, cargo, jq; Linux
```
