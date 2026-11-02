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

All four statements are unchanged at HEAD and this review judged them faithful.

**Wider Comparator run (completed 2 Nov 2026).** All 367 challenges judged faithful at the snapshot commit fd4aeeb2
were checked on machine-1, machine-2 (laptop), machine-3 and, from 2 Nov, machine-4. **367 of 367 PASS; none failed on
its merits.** By 02:00 UTC on 2 Nov, 146 had passed on two or more machines and 45 on three (machines 3 and 4 keep
re-confirming the quicker ones). Three environment faults were found and fixed rather than counted:
- ArtinParabolicIntersections first FAILed because its config enables the second kernel, nanoda, which was not
  installed; the Lean kernel had accepted it. With nanoda 0.4.31 (built from ammkrn/nanoda_lib 8de7e0c4) both kernels
  accept it. Only two configs enable nanoda (this one and TraceIdealTransportSupport).
- 38 laptop checks failed in seconds when its work partition filled up ("no space left on device"). Those rows were
  removed and re-queued; machine-2 (laptop) now works from a
  new 512 GB NVMe.
- One laptop check was interrupted by a USB-drive failure and is re-queued.

**Upstream changes since the snapshot.** At HEAD 4eaee875, 11 challenges changed (Brenier, DefocusingNLS,
ElementaryPositivity, EuclideanFiveColor, HarmonicGrowth, KServer, LogspaceEquality, Naimark, OccupiedOverlap, Rokhlin,
SpinAngle) and 2 are new (LocalSmoothing, SubexponentialSAT). **All 13 PASS at HEAD** on machine-1 (longest:
ElementaryPositivity 12,481 s, SubexponentialSAT 10,163 s, LocalSmoothing 8,478 s), and 12 of the 13 also pass the
second kernel (section 11). An independent replication of the 13 on machine-2 is in progress (8 of 13 passed so far).
HEAD also adds a large separate formalisation, `ComparatorChallenges/HodgeConjectureCMAbelianVarieties/`, whose
statement is reviewed in section 12.

Lee Miller's 10 Oct desk audit flagged families 263 (ionization: the statement is not N_c ≤ Z + C), 267 (Bose gas:
zero temperature only) and 261 (Anderson: spectrum only).

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

## 8. Independent re-runs of the papers' own computer certificates (1 Nov 2026)

31 manuscripts ship a `verification/` folder with their computer-assisted proof steps. Each folder was fetched from
openai/math at 4eaee875 (sparse clone; GMP 6.3.0, Boost 1.89, python-flint
0.9.0, sympy 1.14.0, mpmath 1.3.0 installed per user, no sudo) and run by one agent per paper inside a Landlock sandbox
(no network, writes only in the run directory), comparing outputs with saved outputs, hashes and the paper's numbers.

| Result | Papers |
|---|---|
| Reproduced: every documented check ran and agreed | 30 |
| Partial: all numbers agree, but the documented command cannot run unmodified | 1 |
| Mismatch with the paper | 0 |

The partial case:
- *The Mahler conjecture for general convex bodies*: a genuine upstream gap. `SOURCE-MANIFEST.json`, `saved-original/`
  and `input.md`, which the README and runner rely on, are not in the repository at any commit. All ten computations
  agree when run directly.

*Foulkes conjecture for the sixth symmetric power* was partial at first only because its runner clears the compiler's
include path and Boost was not installed system-wide; with Boost installed it reproduced unmodified (both programs
match the shipped output byte for byte).

Per-paper verdicts, what each checker certifies, and the agents' soundness notes (trusted inputs, hand-coded formulas,
float use) are in `certificate_reruns.csv` (this folder).

## 9. GPU counterexample searches (31 Oct – 1 Nov 2026)

172 physics-flavoured manuscripts were screened for claims a GPU could stress-test; 21 candidates were each reviewed
by a sceptical agent and all 21 rejected for that purpose (already Lean-checked, already certified exactly, bound far
from the physical value, existential only, or not GPU-shaped; `gpu-candidates-SHORTLIST.md` in this folder). With the GPUs idle,
four were run anyway as independent stress tests, each capped at 4 hours, with any hit to be confirmed in exact or
50-digit arithmetic:

| Record | Claim tested | Machine | Cases | Result |
|---|---|---|---|---|
| DOC0632 Potts reconstruction | Prop. 3.1 polynomial inequalities on Δ4×Δ4 | machine-1 RTX 5060 Ti | 15.7 billion pairs | No violation; worst normalised slack 0.0071 / 0.0050 |
| DOC0437 planar Coulomb energy | Thm 1.2, W_n ≥ n W(E_tri), n = 2–400 | machine-1 RTX 5060 Ti | 380,237 local minima | No violation; closest 3.0e-6 per point (n = 209) |
| DOC0724 matching-polytope entropy | Thm 1.1 lower bound (the Lean statement is still `sorry`) | laptop RTX 4060 | 28.0 million cases, 3,244 graphs | No violation; worst ratio 0.118 (m = 2) |
| DOC0696 isotropic constant | Thm 1.1, simplex maximises L_K, n = 3–6 | laptop RTX 4060 | 2.47 million polytopes, 51.8 million hulls | No violation; nothing beats the simplex |

Earlier, the entropy photon-number inequality (Comparator challenge EntropyPhotonNumber, which then PASSed) was tested
with 8.3 million cases on both GPUs with no violation. These searches are evidence, not proof. Code and results are in
`numerics/`.

## 10. Comparator config and Lean file hygiene (1 Nov 2026)

Two read-only scripts (`hygiene/config_audit.py`, `hygiene/empty_files.py` in this repo) were run over the snapshot and HEAD copies.

Comparator configs: no config permits axioms beyond `propext`, `Quot.sound`, `Classical.choice`, and no challenge file
uses `opaque`, `implemented_by`, `extern` or kernel-skipping options. But at the snapshot, 10 of 416 configs had a
non-empty `definition_names` list (the solution may replace those constants), one of them (ElementaryPositivity) had an
empty `theorem_names` list, so Comparator checked no theorem at all, and HarmonicGrowth's challenge file declared an
`axiom`. At HEAD 4eaee875 all three issues are gone except ElementaryPositivity's single redefinable witness. Nine of
the ten were rewritten, which is why those challenges changed between the commits. None of these configs were in our
snapshot replication queue. The "all 416 configurations accepted" figure reported elsewhere therefore includes, at the
snapshot, one vacuous config and ten weakened ones.

Lean files: of 162,417 `.lean` files under `OAI/` at HEAD, 418 declare nothing. 324 of those are import-only umbrella
files, which is normal Lean practice; the other 94 are namespace shells with no content (list in
`hygiene/shell_files_head.txt`), the pattern raised on the Lean Zulip. Harmless to correctness, costly to build time.

## 11. The 13 HEAD challenges on a second kernel, and a nanoda stack limit (2 Nov 2026)

Upstream enables the second kernel, nanoda, in only 2 of 416 configs; the 13 HEAD configs have `enable_nanoda: false`.
We re-ran each with a work-directory copy of its config that sets `enable_nanoda: true` (upstream files untouched;
nanoda 0.4.31 from ammkrn/nanoda_lib 8de7e0c4, the build used in section 4). Both kernels accept 12 of the 13:
LocalSmoothing (4,623 s), Brenier, KServer, EuclideanFiveColor, HarmonicGrowth, Naimark, DefocusingNLS,
ElementaryPositivity, SpinAngle, OccupiedOverlap, Rokhlin (99–472 s each, builds cached) and LogspaceEquality (177 s,
see below). SubexponentialSAT's second-kernel run is queued.

Two first attempts ended differently: for SubexponentialSAT (after 1,405 s) and LogspaceEquality (156 s) nanoda aborted
with "thread has overflowed its stack" (exit code 134) while the Lean kernel accepted the same export in the same run.
nanoda sizes each checking thread's stack from the config field `stack_size_bytes`, default 32 MiB, and Comparator's
generated config omits the field. This is a resource limit of the second kernel on very deep proof terms, not a
rejection, though Comparator records it as FAIL. Comparator's sandbox lets only the kernel binary itself execute, so a
wrapper script cannot raise the limit; we rebuilt nanoda from the same source with that one default changed to 1 GiB
(`hygiene/nanoda-bigstack-util.rs.diff`) and selected it through Comparator's own `COMPARATOR_NANODA` override,
Comparator unmodified. LogspaceEquality then passes nanoda. Anyone running these two proofs through nanoda will need
the same setting.

## 12. The CM Hodge challenge: statement review (2 Nov 2026)

HEAD adds `ComparatorChallenges/HodgeConjectureCMAbelianVarieties/`: a 257-file statement framework (adapted from
Paul-Lez/HodgeConjecture and deancureton/sphere-six-complex), the CM hypothesis (`CM.lean`), the challenge theorem
`HodgeCM.hodge_conjecture_for_cm_abelian_varieties`, and a one-line solution importing OpenAI's ~300k-line proof. The
paper is "The rational Hodge conjecture for CM abelian varieties" (6 Oct 2026). Its headline is an open conjecture whose
truth implies the Tate conjecture for abelian varieties over finite fields and the Hodge standard conjecture for abelian
varieties, so the statement was reviewed with maximal suspicion: six independent agent reviews (paper against Lean,
every definition traced, the `IsProjective` question and Comparator's mechanics, a smuggling sweep of the framework and
of the proof's 33,169-module import closure, vacuity, proof structure), each finding then attacked by three sceptical
verifiers; full text in `review/HODGE_STATEMENT_REVIEW.md`, key facts re-checked by hand against the files.

Verdict: **faithful with caveats.** The Lean statement is the paper's Theorem 1.1 clause by clause: a complex abelian
variety (`IsIntegral`, `Smooth`, `IsProjective`, `GrpObj` over `Spec ℂ`, the point included), the CM hypothesis in the
paper's Lemma 2.3(ii) form (rational H¹ a sum of rank-one lines over CM fields acting by Hodge endomorphisms), and the
conclusion that `Hdg^p(X; ℚ)` lies in the ℚ-span of fundamental classes of codimension-p integral subvarieties. `Hdg^p`
is the textbook F^p ∩ conj(F^p); the cycle span cannot contain anything outside the image of Z^p(X)_ℚ; no hypothesis is
unsatisfiable or satisfied by non-CM varieties. The sweep found no `axiom`, `sorry`, `opaque`, `implemented_by`,
`extern`, `unsafe`, `partial def` or `native_decide`, no unconditional instance of any hypothesis class, and no lemma
deriving `False` or a trivial Hodge space from the hypotheses.

Caveats: (a) the CM hypothesis is the (ii) form; (ii) ⇔ (iii) is the paper's Lemma 2.3, not a Lean theorem. (b) The
holomorphic-forms sheaf behind F^p is built by an unusual route, identified with the standard one by lemmas but not by
one named theorem. (c) No object satisfying all four instance hypotheses is constructed in either tree. (d) **The
challenge side is solver-authored**: upstream commit `204e5f8` (29 Oct 2026, "Align CM Hodge comparator declarations
with the Lean solution") rewrote all 257 framework files into `OAI.*` namespaces matching the solution, so Comparator's
assumption that the challenge closure is controlled by an independent party is met only by reading it, which this review
does. A PASS therefore means the kernel accepted OpenAI's proof of OpenAI's formalisation, and the burden moves to the
framework definitions and the proof tree. Minor: about ten textual divergences between the framework and OpenAI's twin
modules, all of which can only make Comparator fail, never pass a weaker statement; and one stale docstring
(`CMCore.lean`) says a key claim is unproved when `CMReduction/Core.lean` proves it.

Kevin Buzzard's question on the Lean Zulip was whether the challenge's `IsProjective` and the solution's might differ.
Both use `OAI.AlgebraicGeometry.Foundations.ProjectiveSpaceIs.IsProjective`, declared once in each tree (the trees are
never loaded together); the two declarations differ only by `_root_.` qualification. Comparator does not rely on names:
`Compare.lean` walks every constant reachable from the statement and throws "Const does not match" on any structural
difference, and `definition_names` is empty for this challenge, so a differing `IsProjective` would make the run FAIL;
it cannot make it PASS with a weaker statement.

Comparator run: started 1 Nov 23:48 UTC on machine-1 after a 42,093-job build (the build needs `LEAN_NUM_THREADS`
capped; Comparator's sandbox drops that variable, and 17 parallel Lean jobs took about 75 GB and were killed on earlier
attempts); the kernel check was in progress at the time of writing, with no verdict yet. Open questions for a human
expert are ranked in the review: whether the chart-evaluation holomorphic-forms sheaf is Ω^p after sheafification;
whether the transported conjugation is geometric complex conjugation; whether the cycle component class equals [Z] up to
a nonzero scalar for singular Z; whether `analyticTopology` is the classical topology; and, if the run passes, the
proof-internal definitions behind Hironaka resolution, Lefschetz (1,1) and the theta/ball-quotient construction.
