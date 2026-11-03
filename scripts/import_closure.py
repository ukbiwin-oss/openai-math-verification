#!/usr/bin/env python3
"""Read-only: transitive import closure of a Lean module inside a Lake workspace; reports which .lake/packages it
reaches and how many modules from each. Usage: python3 -I import_closure.py WORK_LEAN_DIR MODULE"""
import os, re, sys
work, start = sys.argv[1], sys.argv[2]
roots = [('(workspace)', work)] + [(p, os.path.join(work, '.lake', 'packages', p))
                                    for p in sorted(os.listdir(os.path.join(work, '.lake', 'packages')))]
imp = re.compile(r'^\s*(?:public\s+)?(?:meta\s+)?import\s+(?:all\s+)?([\w.«»\']+)', re.M)

def find(mod):
    rel = mod.replace('«', '').replace('»', '').replace('.', os.sep) + '.lean'
    for name, r in roots:
        f = os.path.join(r, rel)
        if os.path.exists(f):
            return name, f
    return None, None

seen, todo, owner, missing = set(), [start], {}, set()
while todo:
    m = todo.pop()
    if m in seen:
        continue
    seen.add(m)
    name, f = find(m)
    if not f:
        missing.add(m)
        continue
    owner[m] = name
    src = open(f, encoding='utf-8', errors='replace').read()
    src = re.sub(r'--[^\n]*', '', re.sub(r'/-.*?-/', '', src, flags=re.S))      # drop comments (non-nested approximation)
    head = src.split('\nnamespace', 1)[0].split('\nsection', 1)[0]   # imports precede the first declaration block
    todo += imp.findall(head)
count = {}
for m, n in owner.items():
    count[n] = count.get(n, 0) + 1
for n, c in sorted(count.items(), key=lambda x: -x[1]):
    print(f'{c:6d}  {n}')
core = sorted(m for m in missing if not m.split('.')[0] in ('Init', 'Lean', 'Std', 'Lake'))
print('unresolved (non-core):', len(core), core[:10])
