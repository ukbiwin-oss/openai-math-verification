# Comparator config and Lean file hygiene audit of openai/math (1 Nov 2026)

Read-only scripts over local copies: snapshot fd4aeeb2 (7 Oct) and HEAD 4eaee875 (30 Oct).
`config_audit.py` reads every `ComparatorChallenges/**/*.json` and its challenge `.lean`;
`empty_files.py` scans every `OAI/**/*.lean`.

## Comparator configs

| | snapshot fd4aeeb2 | HEAD 4eaee875 |
|---|---|---|
| configs | 416 | 419 |
| `definition_names` non-empty (solution may redefine these constants) | 10 | 1 (ElementaryPositivity: `OAI.elementaryPositivityWitness`) |
| `theorem_names` empty (Comparator checks no theorem at all) | 1 (ElementaryPositivity) | 0 |
| `axiom` declaration inside the challenge file | 1 (HarmonicGrowth: `axiom mainStatement : MainClaim`) | 0 |
| permitted axioms beyond propext / Quot.sound / Classical.choice | 0 | 0 |
| `opaque`, `implemented_by`, `extern`, kernel-skipping options in challenge files | 0 | 0 |

The ten snapshot configs with `definition_names` were Brenier, DefocusingNLS, ElementaryPositivity, EuclideanFiveColor,
KServer, LogspaceEquality, Naimark, OccupiedOverlap, Rokhlin, SpinAngle. Nine were rewritten at HEAD without
`definition_names`; this is why those challenges changed between the two commits. At the snapshot, ElementaryPositivity
listed no theorem, so a Comparator PASS on it certified only that the witness definition type-checks. None of these
ten, nor HarmonicGrowth, were in our snapshot replication queue (they were excluded by the statement review), so our
snapshot PASS counts are unaffected; the HEAD versions are being checked separately.

Consequence for the "all 416 configurations accepted" figure reported elsewhere: at the snapshot that figure includes
one config that checks no theorem and ten whose statements depend on definitions the solution is allowed to replace.

## Lean files in `OAI/` that declare nothing (HEAD)

| | count |
|---|---|
| `.lean` files under `OAI/` | 162,417 |
| files with no declaration of any kind | 418 |
| of which import-only umbrella files (normal Lean practice) | 324 |
| of which namespace/section shells with no imports of substance and no content | 94 |

The 94 shells (list: `shell_files_head.txt`) look like the example raised on Zulip,
`OAI/NumberTheory/OrdinaryCorrelations/AbsoluteDefect/OrdinaryArchimedeanTwistBasic.lean`: `import Mathlib`, a dozen
`open` lines, an empty namespace. They are harmless to correctness but cost build time and obscure the tree.
