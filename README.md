# Independent checks of the openai/math release

_By Lee Miller ([@ukbiwin-oss](https://github.com/ukbiwin-oss)), with Claude Code._

This repository records an independent look at [github.com/openai/math](https://github.com/openai/math), OpenAI's
September–October 2026 release of AI-generated mathematics manuscripts with Lean formalisations.

## What is here

| Folder | Contents |
|---|---|
| `replications/` | **Comparator replications** of four Lean challenges on two machines, with exact tool versions and logs; since 13 Nov 2026 also the second-kernel logs for the two "ETH is false" formalisations (see below) |
| `scripts/` | The run script used for every replication |
| `report/` | The full verification report and `papers.csv`, one row per manuscript |

## Headline results

Four of the repository's [Comparator](https://github.com/leanprover/comparator) challenges were checked, each inside
Comparator's landrun sandbox with only the standard axioms (`propext`, `Quot.sound`, `Classical.choice`) permitted:

| Challenge | Claim | Machine 1 (2026-10-10/11) | Machine 2 (2026-10-30/31, fresh clone from GitHub) |
|---|---|---|---|
| `CriticalZ3` | no infinite cluster at p_c for bond and site percolation on ℤ³ | PASS (200 s) | PASS (187 s) |
| `Heisenberg` | spontaneous magnetisation of the quantum Heisenberg ferromagnet, d ≥ 3, every spin | PASS (836 s) | PASS (1,169 s) |
| `CriticalPercolation` | no percolation at criticality on every quasi-transitive graph with p_c < 1 | PASS (690 s) | PASS (825 s) |
| `LaughlinFock` | uniform Fock-space inequality behind the Laughlin spectral gap | PASS (4,049 s) | PASS (4,109 s) |

Library: openai/math at commit `fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb`; the four challenge files are unchanged at
the later head `4eaee875`. Toolchain: Lean 4.34.1 (`5045d005`), Mathlib `d13f23b7`, Comparator `d03acab1` (v4.34.0),
lean4export v4.34.0, landrun 0.1.17.

## What a PASS does and does not mean

- **It means** the Lean kernel accepted a proof of exactly the challenge statement, using only the permitted axioms.
- **It does not mean** the challenge statement says what the paper claims. That needs a person who knows the field. The
  report's statement review (done by AI agents, with second reviews) judged these four statements faithful.
- The four checks above used Lean's kernel only. A second kernel, nanoda, was later run on the 13 challenges that are
  new or changed at HEAD `4eaee875`: all 13 pass both kernels, on two machines (report, section 11). All checks trust Mathlib's
  definitions.
- The θ(p_c) = 0 result on ℤ^d was obtained earlier by others (see the report, section 6).

## The two "Exponential Time Hypothesis is false" formalisations on two kernels (13 Nov 2026)

OpenAI and Anthropic each published a Lean formalisation of a claimed refutation of the Exponential Time Hypothesis in
late October 2026. Both are accepted by Lean's kernel and by the independent nanoda kernel, with only the three
standard axioms:

| Formalisation | Commit | Result | Logs |
|---|---|---|---|
| OpenAI, `SubexponentialSAT` challenge | openai/math `4eaee875` | Both kernels accept, on two machines (2 Nov 2026; 1,489 s and 1,579 s with builds cached). nanoda needed its thread stack raised from 32 MiB to 1 GiB; the first attempt overflowed and is kept. | `replications/machine-1-2026-11-02-sat-nanoda/`, `replications/machine-2-2026-11-02-sat-nanoda/` |
| Anthropic, `eth/` | anthropics/formal-math `16a5ce41` | Both kernels accept in three of four runs on one machine (13 Nov 2026), using the repository's own check script unmodified. The first run ended when Comparator crashed with a segmentation fault at the nanoda step, before either kernel gave a verdict; it did not happen again, with a cold or a cached build, and its cause is not known. | `replications/anthropic-formal-math-eth-machine-1-2026-11-13/` |

For the OpenAI run the work copy's commit was not recorded at the time. On 13 Nov 2026 all 3,977 files of the proof
tree, the challenge file and its config, `lean-toolchain`, `lake-manifest.json` and `lakefile.lean` were compared by
git blob hash with upstream at `4eaee875`: all identical. The second machine's copy no longer has its work tree, so
that comparison was made on machine 1 only.

As everywhere in this repository, a pass says that the kernels accepted a proof of the stated theorem. It does not
say that the stated theorem means "ETH is false"; that is a question about the statements, which this check does not
address.

## Report

`report/REPORT.md` covers all 787 files of the release at the snapshot: identity checks against the upstream git
blobs, kinds and editions, the three withdrawals, the collection's own formalisation claims, a review of whether each
Lean statement captures its paper's headline (719 current manuscripts), and a check of public reception for 45 headline
claims with every cited source re-fetched. It is an audit, not new mathematics, and contains no peer review.

## Licence

The report, the per-manuscript table, the replication summaries and logs, and this README are licensed under
[Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/) (`LICENSE`): you may
share and adapt them with credit to Lee Miller. The script in `scripts/` is under the MIT licence (`scripts/LICENSE`).
Titles and paths of the upstream manuscripts refer to github.com/openai/math, which is licensed by OpenAI under Apache-2.0.
