# GPU-testable claims in openai/math physics papers (2026-10-31)

Screened 172 physics-flavoured records (wf_bccf161b-d52); 21 candidates; each vetted by a sceptical agent (wf_9e9f1346-f46). **0 kept**; top priority 3/10.

Main reasons: the claim is already Lean-formalised; the paper already has an exact or interval-arithmetic certificate; the bound is far below known physical values; the statement is only existential or asymptotic; or the work is exact or symbolic (CPU, not GPU).

| priority | id | title | faithful | counterexample value | GPU fit | Lean |
|---|---|---|---|---|---|---|
| 3 | DOC0632 | The Reconstruction Threshold for the Ferromagnetic Four-State Potts Model | exact | refutes_key_lemma | medium | No. Grep for 'potts' in the openai-math Lean snapshot (fd4aeeb2, lean/ |
| 3 | DOC0200 | Cylinder loop weights and planar nesting | controlled_truncation | refutes_key_lemma | low | No. None of lean/docs/*.md or ComparatorChallenges/* at snapshot fd4ae |
| 3 | DOC0696 | A sharp entropy bound and the simplex inequality for isotropic constants | exact | refutes_headline | medium | Thm 1.1 and Thm 1.2 are not formalised. The Mahler consequence (1.3) i |
| 3 | DOC0641 | Tensor saturation for even spin groups | exact | refutes_headline | low | No. A grep for 'saturation' or 'Spin(2' in lean/docs/*.md and Comparat |
| 2 | DOC0275 | A Fock-space inequality and the Laughlin spectral gap | exact | refutes_headline | medium | Yes, exactly. ComparatorChallenges/LaughlinPlanar.lean (theorem OAI.La |
| 2 | DOC0884 | The exact reconstruction threshold for the three-state symmetric channel | exact | refutes_key_lemma | low | No. docs/229.md formalises only supercritical reconstruction (Comparat |
| 2 | DOC0437 | Triangular minimality for planar Coulomb renormalized energy | exact | refutes_headline | medium | No. There is no Comparator challenge or docs entry for the Sandier-Ser |
| 2 | DOC0340 | Sharp one-dimensional Lieb–Thirring constants | controlled_truncation | refutes_headline | medium | Yes. openai-math snapshot: lea |
| 2 | DOC0322 | Universal optimality of the triangular lattice | controlled_truncation | refutes_headline | medium | Yes, for the headline: ComparatorChallenges/TriangularEnergy.lean (uni |
| 2 | DOC0724 | Entropy and Face Dimension of the Perfect-Matching Polytope | exact | refutes_headline | medium | The exact statement is in ComparatorChallenges/MatchingEntropyBounds.l |
| 2 | DOC0768 | Sharp one-dimensional Lieb–Thirring inequalities for matrix potentials | controlled_truncation | refutes_headline | medium | Partly. openai-math snapshot:  |
| 1 | DOC0510 | An atomic certificate for triangular-lattice universal optimality | controlled_truncation | refutes_headline | medium | Yes. lean/ComparatorChallenges/TriangularEnergy.lean states universal_ |
| 1 | FTL295 | Classical capacity and entropy inequalities for generalized amplitude damping | heuristic_only | none | medium | Yes for the headline. ComparatorChallenges/AmplitudeDamping.lean (theo |
| 1 | DOC0886 | Equality cases in the sharp one-dimensional matrix Lieb–Thirring inequality | controlled_truncation | refutes_headline | medium | Partly. ComparatorChallenges/LiebThirring.lean (config LiebThirring.js |
| 1 | DOC0718 | Three fixed points on the symplectic quadric threefold | heuristic_only | none | low | Yes, as a statement only: openai-math snapshot: so |
| 1 | FTL296 | Entanglement with zero distillable secret key in local dimension ten | heuristic_only | none | low | Yes for Thms 1.2 and 1.3. ComparatorChallenges/DimensionTenPair.lean ( |
| 1 | DOC0046 | Sharp binary-information contraction on the discrete cube | exact | refutes_headline | medium | Yes, fully. ComparatorChallenges/CourtadeKumar.lean (FullStatement) is |
| 1 | DOC0272 | A Polynomial-Time 2-Approximation for Shortest Common Superstring | exact | none | low | Yes, formalised exactly. openai-math snapshot: sou |
| 1 | DOC0495 | A boundary-field gap for the spin-one Heisenberg chain | controlled_truncation | none | low | No. ComparatorChallenges/Heisenberg.lean (theorem OAI.Heisenberg.spont |
| 1 | DOC0581 | The periodic spin-one Haldane gap | controlled_truncation | none | low | No. A grep for 'haldane' or 'spin-one' over lean/docs/*.md and Compara |
| 0 | DOC0159 | A Polynomial-Time Algorithm for Three-Machine Unit-Job Scheduling | heuristic_only | none | low | Yes. openai-math snapshot: lea |

Full verdicts, corrected claim statements and test specs: vetted.json.
