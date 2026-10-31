# Independent checks of the openai/math release

This repository records an independent look at [github.com/openai/math](https://github.com/openai/math), OpenAI's
September–October 2026 release of AI-generated mathematics manuscripts with Lean formalisations.

## What is here

| Folder | Contents |
|---|---|
| `replications/` | **Comparator replications** of four Lean challenges on two machines, with exact tool versions and logs |
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
| `LaughlinFock` | uniform Fock-space inequality behind the Laughlin spectral gap | PASS (4,049 s) | running |

Library: openai/math at commit `fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb`; the four challenge files are unchanged at
the later head `4eaee875`. Toolchain: Lean 4.34.1 (`5045d005`), Mathlib `d13f23b7`, Comparator `d03acab1` (v4.34.0),
lean4export v4.34.0, landrun 0.1.17.

## What a PASS does and does not mean

- **It means** the Lean kernel accepted a proof of exactly the challenge statement, using only the permitted axioms.
- **It does not mean** the challenge statement says what the paper claims. That needs a person who knows the field. The
  report's statement review (done by AI agents, with second reviews) judged these four statements faithful.
- **No second kernel** (for example nanoda) has been run, and the checks trust Lean's kernel and Mathlib's definitions.
- The θ(p_c) = 0 result on ℤ^d was obtained earlier by others (see the report, section 6).

## Report

`report/REPORT.md` covers all 787 files of the release at the snapshot: identity checks against the upstream git
blobs, kinds and editions, the three withdrawals, the collection's own formalisation claims, a review of whether each
Lean statement captures its paper's headline (719 current manuscripts), and a check of public reception for 45 headline
claims with every cited source re-fetched. It is an audit, not new mathematics, and contains no peer review.
