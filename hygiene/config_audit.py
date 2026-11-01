"""Audit openai/math Comparator configs and challenge files for loopholes (read-only).
Usage: python3 -I config_audit.py <lean-dir> <out.json>"""
import json, glob, os, re, sys
L, out = sys.argv[1], sys.argv[2]
C = os.path.join(L, 'ComparatorChallenges')
STD = {'propext', 'Quot.sound', 'Classical.choice'}
rows = []
for f in sorted(glob.glob(C + '/**/*.json', recursive=True)):
    try: d = json.load(open(f))
    except Exception as e: rows.append({'config': os.path.relpath(f, C), 'error': str(e)}); continue
    if 'theorem_names' not in d: continue
    r = {'config': os.path.relpath(f, C), 'theorems': len(d.get('theorem_names', [])),
         'definition_names': d.get('definition_names', []),
         'extra_axioms': sorted(set(d.get('permitted_axioms', [])) - STD),
         'missing_std_axioms': sorted(STD - set(d.get('permitted_axioms', []))),
         'enable_nanoda': bool(d.get('enable_nanoda')), 'flags': []}
    mod = d.get('challenge_module', '')
    src = os.path.join(L, *mod.split('.')) + '.lean'
    r['challenge_file'] = os.path.relpath(src, L)
    if not os.path.exists(src): r['flags'].append('challenge_module_file_missing')
    else:
        t = open(src).read()
        t_nc = re.sub(r'/-.*?-/', '', t, flags=re.S); t_nc = re.sub(r'--[^\n]*', '', t_nc)
        if re.search(r'^\s*axiom\s', t_nc, re.M): r['flags'].append('axiom_in_challenge')
        if re.search(r'^\s*(private\s+)?opaque\s', t_nc, re.M): r['flags'].append('opaque_in_challenge')
        if re.search(r'\bimplemented_by\b|\bextern\b', t_nc): r['flags'].append('implemented_by_or_extern')
        if re.search(r'set_option\s+(debug\.skipKernelTC|maxRecDepth|trust)', t_nc): r['flags'].append('suspicious_set_option')
        # definitions (not theorems) whose body is sorry -> definition holes
        for m in re.finditer(r'^\s*(?:noncomputable\s+)?(?:def|abbrev|instance)\s+([^\s:(\[{]+)[^\n]*?(?::=\s*sorry\b|\n\s*sorry\b)', t_nc, re.M):
            name = m.group(1)
            listed = any(n.endswith('.' + name) or n == name for n in r['definition_names'])
            r['flags'].append(f'sorry_definition:{name}' + ('' if listed else ':NOT_LISTED'))
        thm_sorry = len(re.findall(r':=\s*(?:by\s+)?sorry\b', t_nc))
        r['sorry_count'] = thm_sorry
    if r['definition_names']: r['flags'].append('definition_names_nonempty')
    if r['extra_axioms']: r['flags'].append('extra_axioms')
    if r['theorems'] == 0: r['flags'].append('no_theorems')
    rows.append(r)
json.dump(rows, open(out, 'w'), indent=1)
from collections import Counter
c = Counter(fl.split(':')[0] + (':NOT_LISTED' if fl.endswith('NOT_LISTED') else '') for r in rows for fl in r.get('flags', []))
print('configs', len(rows)); print(dict(c))
for r in rows:
    if [x for x in r.get('flags', []) if not x.startswith('definition_names_nonempty') and not (x.startswith('sorry_definition') and not x.endswith('NOT_LISTED'))]:
        print(' ', r['config'], r['flags'][:6], r.get('extra_axioms'))
