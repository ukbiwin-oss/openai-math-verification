# Verification of the openai/math records in the library — report (2026-10-30)

_By Lee Miller, prepared with Claude Code. Per-paper results: `papers.csv` (one row per manuscript, keyed by its path in the upstream repository). Identifiers such as FTL712 or DOC0275 are record IDs in Lee Miller's private research catalogue._

## 1. Answer

The 787 records are genuine, unmodified copies of files from OpenAI's public repository **github.com/openai/math**.
They are AI-generated, not peer-reviewed mathematics manuscripts plus supplementary files. The repository itself says
an unnamed internal OpenAI model produced them, that they are "raw research data", that unformalised results "could
have issues", and its `formalization.yaml` gives review status `unchecked`. Their mathematical standing varies widely
and is now recorded per record. Where a Lean statement exists we checked whether it says what the paper claims; no proof
was compiled in this audit. Four statements had already passed Lee Miller's own Comparator runs on 10–11 October.

## 2. Identity and integrity (all 787 records)

| Check | Result |
|---|---|
| Library SHA-256 = file on disk | 787 / 787 |
| Library file = committed git blob at snapshot commit `fd4aeeb2` (2026-10-07) | 787 / 787 |
| Identical at current upstream HEAD `4eaee875` (2026-10-30) | 786 / 787 (only `overview.pdf`, record DOC0165, changed) |
| Page 1 names OpenAI as author (manuscripts and notices) | 749 / 749 |
| Other catalogue records with a similar title (local-first check) | none (best similarity 0.65, unrelated) |

Upstream moved six commits after the snapshot. It added two manuscripts that are not in the library
("Local smoothing for the Euclidean wave equation" and "The Exponential Time Hypothesis is False", both 2026-10-25),
about 40,000 Lean files and Comparator challenges (including the CM Hodge formalisation), and restored computation files
for the dimension-six mutually-unbiased-bases paper. No library PDF was changed or withdrawn upstream.

## 3. What the records are

| Kind | Records | Note |
|---|---|---|
| Manuscript, current edition | 719 | listed in upstream `CONTENTS.md` (8 FTL + 711 DOC) |
| Manuscript, superseded edition | 27 | newer edition's README links it as "previous version"; 27 version pairs |
| Withdrawal notice | 3 | DOC0158, DOC0282, DOC0550: withdrawn 6 Oct 2026 for a sign error in a stabilization-trace argument; the library holds the 1-page notices, not the manuscripts |
| Figure / build file | 27 | not papers |
| Reasoning summary | 10 | "Summarized chain of thought" PDFs; not papers |
| Collection overview | 1 | DOC0165 |

## 4. Formal-verification status of the 719 current manuscripts

The collection's own claims (from `formalization.yaml` and the `lean/docs` scope notes at HEAD):

| Collection claim | Current manuscripts |
|---|---|
| Main result formalised (listed in formalization.yaml) | 173 |
| Family scope note links the paper, main result not listed | 169 |
| Family has a scope note, but it covers other papers | 139 |
| No Lean formalisation in the family | 238 |

Our statement review covered all 244 documented families (the 52 physics, quantum and FTL families with two independent
reviews and adjudication, a further 24 audit families double-reviewed, and the rest single-reviewed):

| Review result | Current manuscripts |
|---|---|
| Headline theorem stated in Lean (Comparator statement matches the paper's main claim) | 293 |
| Headline partly stated (special case, weaker form, or some of several claims) | 49 |
| Only supporting results stated | 27 |
| No formal statement (including the 238 without any formalisation) | 350 |

Second reviews agreed on 164 of 174 papers; 28 records were adjudicated. 16 challenges rely on local definitions whose
meaning the reviewers could not fully confirm (flag `custom_definitions_unclear` in `verification.csv`).

A stated headline is not a checked proof. Machine-checked so far, with Comparator in the landrun sandbox:

| Record | Challenge | Lee Miller's run (machine-1, 10–11 Oct) | Independent replication (laptop machine-2, fresh GitHub copy, 30–31 Oct) |
|---|---|---|---|
| FTL712 critical percolation on ℤ³ | CriticalZ3 | PASS | PASS (187 s) |
| FTL714 Heisenberg ferromagnet | Heisenberg | PASS | PASS (1,169 s) |
| FTL713 no percolation at criticality, quasi-transitive | CriticalPercolation | PASS | PASS (825 s) |
| DOC0275 Laughlin Fock-space gap | LaughlinFock | PASS | PASS (4,109 s) |

All four statements are unchanged at HEAD and this review judged them faithful. No second kernel (nanoda) was run.
Further Comparator checks of the other challenges judged faithful (367 at the snapshot commit) are running on both
machines; results accumulate in `~/comparator-replication-20261031/run/summary.csv` (machine-1) and
`~/comparator-replication-20261030/run{2,3,4}/summary.csv` (laptop). Lee Miller's 10 Oct desk audit flagged families 263
(ionization: the statement is not N_c ≤ Z + C), 267 (Bose gas: zero temperature only) and 261 (Anderson: spectrum only).

## 5. The eight FTL records and the quantum-computing titles

| Record | Result |
|---|---|
| FTL290 charged spacetime Penrose inequality | no formal statement (family 260's challenge covers a companion paper) |
| FTL291 inextendibility near Kerr | no Lean formalisation |
| FTL292 VOAs and conformal nets | headline partly stated |
| FTL295 generalized amplitude damping capacity | headline partly stated; 98,304 numerical checks (9 Oct) found no counterexample |
| FTL296 entanglement with zero distillable key | headline partly stated (zero-key claim stated only existentially) |
| FTL712, FTL713, FTL714 | headline stated and Comparator PASS |
| DOC0107, DOC0842 parity ∉ QAC⁰ | headline stated |
| DOC0233 exact quantum factoring over a fixed gate set | headline stated |
| DOC0810 QMA-hardness of Coulomb energy | headline stated |
| DOC0653 threshold parallel repetition, entangled games | headline partly stated |
| DOC0305 QAOA reaches the SK optimum | only supporting results stated |
| DOC0419 / DOC0689 three MUBs in dimension six | 0419 headline stated; 0689 partly (the computer-assisted "no fourth basis" step is not stated) |
| DOC0079 PEPS, DOC0137 unitary synthesis, DOC0639 quartic query separation | no Lean formalisation |
| DOC0864 exact Fourier circuits | not yet reviewed |

The blind review matched every earlier verdict recorded in the FTL index notes, which serves as a calibration check.

## 6. Publication and reception

Local first: no other library record matches any manuscript title; the library holds human prior work for family 213
(FTL708–FTL711, FTL715) and the one published critique (OAIM0007). The repository has no public issues and its pull
requests are locked. The web check covered 45 claims plus the release as a whole; an independent checker re-fetched
every cited source (151 supported, 12 partly supported, 1 unreachable, none contradicted). Details per claim:
`reception/reception.json`; per record: `reception_*` columns in `verification.csv`.

**Independent confirmation (human re-derivations or independent formal checks; none peer-reviewed yet)**
- Parity ∉ QAC⁰ (274): Gao, Ji and Liu, ECCC TR26-258, a simplified self-contained proof.
- Matrix multiplication ω ≤ 9/4 (107): three independent write-ups (Shpilka, ECCC TR26-281; Pass, arXiv 2610.28627;
  Amanov, van den Berg and Zuiddam, arXiv 2610.30054, who also prove the method cannot go below 9/4).
- 2D area law (265): an independent Lean proof (AxiomMath/AreaLaw2D) with its own audited statement; PEPS not covered.

**Partial confirmation or expert engagement without a verdict**
- Haldane gap (268): Hal Tasaki's expository notes find the analytic argument sound; the computer-assisted part is unchecked.
- Thompson's group F nonamenable (248): exposition by specialists Kim and Lodha, no error reported.
- Cannon's conjecture (246): Mario Bonk's 22 Oct seminar reportedly says the proof "seems to be correct".
- MUBs in dimension six (266): two independent re-implementations agree μ(6) = 3.
- Unique Games (102): studied by Moshkovitz with Khot, Håstad, Minzer and others; no written verdict.

**Prior or parallel results by others**
- θ(p_c) = 0 on ℤ^d (213): bond case by Leder with Claude in Lean (Aug–Sept 2026), site case d ≥ 3 by Bou-Rabee and Leder
  (5 Sept), human proof by Blanc-Renaudie (arXiv 2610.10502). The quasi-transitive extension has no expert check.
- Generalized amplitude damping capacity (276, FTL295): Kun Fang, arXiv 2609.14621 v2, reached the same result in parallel.
- Exponential Time Hypothesis is false (378, OAIM0001): an Anthropic paper reports the same #3-SAT bound found the same day.
- Spacetime Penrose inequalities (260): overlapping human results under extra hypotheses (Dong, Dolmen, Ng, 2026).

**Errors and cautions**
- Collection level: 3 withdrawals and 14 revisions; Johan Commelin and others say some Lean statements prove weaker results;
  community notes (mathcommunity.github.io/oai-math-revised) record that the Lean statements have not been checked by people.
- The Navier–Stokes critique (arXiv 2610.08144, OAIM0007) concerns OpenAI's separate blow-up release
  (openai/NavierStokesAndEuler), not a manuscript in this collection.
- BFSS (270): DOC0227's claim of infinitely many positive-energy SU(2) bound states conflicts with an exclusion stated
  in the original BFSS paper; no expert has addressed it.
- Bose gas (267): an independent tracker confirms the desk-audit flag that only zero-temperature condensation is formalised.

Most claims, including BSD (002), the π exponent (017), Hilbert's tenth over ℚ (004), L = RL = BPL (103) and the
Singer conjecture (315), have no expert verdict yet. Title searches of OpenAlex, Crossref and arXiv: see HANDOFF.md.

## 7. Method and limits

Every manuscript PDF was matched by hash to a file in github.com/openai/math at commit fd4aeeb2 (2026-10-07) and checked
against the current head 4eaee875 (2026-10-30). Kinds, editions and withdrawals come from the repository's CONTENTS.md
and folder READMEs; formalisation claims from lean/formalization.yaml and lean/docs. The statement review was done by AI
agents (Claude) reading the scope notes, the Comparator challenge files and the manuscripts, with independent second
reviews and adjudication for priority families; treat its verdicts as a screen for specialists, not expert judgement.
The reception check searched local holdings first, then the web; every cited source was re-fetched by an independent
checker. Comparator runs are in `replications/`; see the README there for how to rerun them.
