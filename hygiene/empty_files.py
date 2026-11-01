"""Find Lean files in openai/math OAI/ that declare nothing (read-only). Usage: python3 -I empty_files.py <lean-dir> <out.txt>"""
import os, re, sys
L, out = sys.argv[1], sys.argv[2]
DECL = re.compile(r'^\s*(?:@\[[^\]]*\]\s*)?(?:(?:private|protected|noncomputable|partial|unsafe|nonrec)\s+)*(theorem|lemma|def|abbrev|instance|structure|class|inductive|axiom|opaque|example|macro|syntax|notation|infix|infixl|infixr|prefix|postfix|elab|attribute|alias|initialize|declare_syntax_cat|scoped)\b', re.M)
tot = 0; empty = []; importonly = []
for root, _, files in os.walk(os.path.join(L, 'OAI')):
    for f in files:
        if not f.endswith('.lean'): continue
        p = os.path.join(root, f); tot += 1
        t = open(p, encoding='utf-8', errors='replace').read()
        t = re.sub(r'/-.*?-/', '', t, flags=re.S); t = re.sub(r'--[^\n]*', '', t)
        if not DECL.search(t):
            body = [l for l in t.splitlines() if l.strip() and not re.match(r'\s*(import|open|namespace|end|section|variable|set_option|universe|noncomputable section)\b', l)]
            (empty if not body else importonly).append(os.path.relpath(p, L))
open(out, 'w').write('\n'.join(sorted(empty)) + '\n')
print('OAI lean files', tot, '| no declarations at all', len(empty), '| no decls but other content', len(importonly))
for e in sorted(empty)[:8]: print(' ', e)
