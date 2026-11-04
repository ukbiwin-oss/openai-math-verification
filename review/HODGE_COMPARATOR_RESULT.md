# Comparator result: `HodgeConjectureCMAbelianVarieties` (3 Nov 2026; second kernel 4 Nov)

## Verdict

**PASS.** On machine-1, Comparator accepted OpenAI's solution to the CM Hodge challenge from github.com/openai/math at
HEAD `4eaee875`:

| | |
|---|---|
| Started | 2026-11-02 20:39:41 UTC |
| Finished | 2026-11-03 21:25:56 UTC |
| Wall-clock time | 89,175 s (24 h 46 min), single-threaded kernel check after a 42,093-job build |
| Exit code | 0 |
| Peak memory (systemd unit) | 39.9 GB RAM, plus 8 GB in swap |

The last log lines are `Running Lean default kernel on solution.`, `Lean default kernel accepts the solution`,
`Your solution is okay!`. The log, summary and tool versions are in
`replications/machine-1-2026-11-02-hodge/`.

**Tools.** Lean 4.34.1, mathlib `d13f23b7`, comparator `d03acab1` (v4.34.0), lean4export `076e8e57`, landrun 0.1.17.
`enable_nanoda` is `false` in the challenge's `main.json`, so in this run only Lean's default kernel checked the proof.
A second-kernel run followed on 4 Nov (next section).

**What Comparator certifies.** `Solution.lean` proves `HodgeCM.hodge_conjecture_for_cm_abelian_varieties` exactly as
stated in `Challenge.lean`. Every constant reachable from the statement is structurally identical in the challenge
export and the solution export. The exported axioms are only `propext`, `Quot.sound` and `Classical.choice`, and the
kernel accepts the proof.

**What it does not certify.** Comparator does not check that the framework definitions mean what the paper means.
`review/HODGE_STATEMENT_REVIEW.md` (2 Nov) assessed this and found the statement **faithful with caveats**. Its caveat
(d) still applies: the challenge side was written by the solver, so the PASS means the kernel accepted OpenAI's proof
of OpenAI's formalisation. Its ranked open questions for a human expert stand. Now that the run has passed, the
proof-internal definitions it names also need expert reading: Hironaka resolution, Lefschetz (1,1), and the
theta/ball-quotient construction.

## Second kernel: nanoda (4 Nov 2026)

**PASS on both kernels.** Comparator was run again on machine-1 against the same work tree, with a work-directory copy
of the config, `main.nanoda.json`. It is upstream's `main.json` with `enable_nanoda` set to `true`; upstream files are
untouched. Comparator then checks the solution export with nanoda first and Lean's default kernel second.

| | |
|---|---|
| Started | 2026-11-03 22:30:27 UTC |
| Finished | 2026-11-04 22:19:34 UTC |
| Wall-clock time | 85,747 s (23 h 49 min); the build was cached from the first run |
| Exit code | 0 |
| Peak memory (systemd unit) | 55.7 GB RAM, plus 7.3 GB in swap |

The log ends `Running nanoda kernel on solution`, `nanoda kernel accepts the solution`, `Running Lean default kernel on
solution.`, `Lean default kernel accepts the solution`, `Your solution is okay!`. The exported axioms are again only
`propext`, `Quot.sound` and `Classical.choice`. The log, summary and versions are in
`replications/machine-1-2026-11-03-hodge-nanoda/`.

Differences from the first run. All of them concern resources or config, not the check itself:
- **Config:** `enable_nanoda: true` (the only field changed).
- **nanoda:** 0.4.31 from ammkrn/nanoda_lib `8de7e0c4`, the same 1 GiB-default-stack build used for every other nanoda
  pass (`hygiene/nanoda-bigstack-util.rs.diff`, report section 11), selected through `COMPARATOR_NANODA`.
- **Comparator:** v4.34.0 `d03acab1`, with nanoda's `num_threads` raised from 4 to 24 in the kernel-config JSON it
  generates. That is the only source change: `hygiene/comparator-nanoda24-num-threads.diff`. The diff's other line is
  `lean-toolchain` v4.34.0 → v4.34.1, which the first run's Comparator build also has.

The build log shows the same 24 "has local changes" warnings as the first run, line for line. The section below covers
them.

## The "has local changes" warnings

The build log warns that 24 dependency repositories under `.lake/packages/` "have local changes". The earlier four-challenge
replications on both machines show the same warnings. Checked on 3 Nov, read-only:

1. **Source of the changes.** They are OpenAI's compatibility patches `lean/patches/<package>-lean4341.patch`, which port
   each dependency to Lean 4.34.1 and the shared mathlib. The upstream `lakefile.lean` applies them itself (lines
   193–243). It first checks that each dependency is a git checkout at its pinned commit, from the expected origin, and
   it refuses to proceed if a patch conflicts with other local edits. Our run scripts never edit package sources:
   `run_comparator_v2.sh` only runs `lake update`, refuses to continue if the manifest moves, and then runs
   `lake exe cache get`.
2. **No edits beyond the patches.** `scripts/check_patches.py` (output in `review/hodge_check_patches.out`) checked all
   42 packages and found **0 problems**. Every package's `HEAD` equals the commit pinned in the workspace
   `lake-manifest.json`. Each of the 24 patches is identical to the copy in the source checkout and fully applied
   (`git apply --reverse --check`). Every changed or untracked file is one that the patch touches. The 18 unpatched
   packages are clean.
3. **The proof does not use any patched package.** `scripts/import_closure.py` (output in
   `review/hodge_import_closure.out`) traced the transitive imports of the solution module. They reach 33,170
   workspace modules plus 8 packages: mathlib (8,530 modules), batteries, aesop, Qq, proofwidgets, plausible,
   importGraph and LeanSearchClient. None of these is patched. As an independent check, those same 8 packages are the
   only ones with build output on disk (`review/hodge_built_packages.out`). None of the 24 patched packages was
   compiled for this run.

Conclusion: the warnings are Lake's routine notice about upstream's own compatibility patches. Those patches are
applied exactly as published and play no part in the Hodge proof. They do not affect the PASS.

## Not done

- No human-expert review of the framework or the proof-internal definitions.
- No independent second-machine replication of this challenge.
