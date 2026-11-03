#!/usr/bin/env python3
"""Read-only: for each Lake package in the Hodge Comparator workspace, check (1) HEAD equals the rev pinned in the
workspace lake-manifest.json, (2) the openai/math compatibility patch is fully applied (git apply --reverse --check),
(3) every file git reports as changed/untracked is one the patch touches (no edits beyond the patch), and for
packages without a patch, that the tree is clean. Also compares the copied patch against the source repo's patch.
Usage: python3 -I check_patches.py WORK_LEAN_DIR SRC_LEAN_DIR"""
import hashlib, json, os, subprocess, sys
work, src = sys.argv[1], sys.argv[2]
pk = os.path.join(work, '.lake', 'packages')
man = {}
for p in json.load(open(os.path.join(work, 'lake-manifest.json')))['packages']:
    man[p['name'].strip('«»')] = p
    man.setdefault(p.get('url', '').rstrip('/').removesuffix('.git').rsplit('/', 1)[-1], p)  # dir is named after the repo
git = lambda d, *a: subprocess.run(['git', '-C', d, *a], capture_output=True, text=True)
sha = lambda f: hashlib.sha256(open(f, 'rb').read()).hexdigest()
bad = 0
for name in sorted(os.listdir(pk)):
    d = os.path.join(pk, name)
    if not os.path.isdir(os.path.join(d, '.git')):
        continue
    head = git(d, 'rev-parse', 'HEAD').stdout.strip()
    pin = man.get(name, {}).get('rev')
    status = git(d, 'status', '--porcelain', '--untracked-files=all').stdout.splitlines()
    changed = {l[3:].split(' -> ')[-1] for l in status}
    patch = os.path.join(work, 'patches', f'{name}-lean4341.patch')
    srcpatch = os.path.join(src, 'patches', f'{name}-lean4341.patch')
    notes = []
    if head != pin:
        notes.append(f'HEAD {head[:12]} != pinned {str(pin)[:12]}')
    if os.path.exists(patch):
        if not os.path.exists(srcpatch) or sha(patch) != sha(srcpatch):
            notes.append('patch differs from source repo copy')
        rev = git(d, 'apply', '--reverse', '--check', patch)
        if rev.returncode:
            notes.append('patch NOT fully applied: ' + rev.stderr.strip().splitlines()[0])
        files = set()
        for l in git(d, 'apply', '--numstat', patch).stdout.splitlines():
            files.add(l.split('\t')[2])
        extra = sorted(changed - files)
        if extra:
            notes.append(f'{len(extra)} changes not in patch: {extra[:5]}')
        state = f'patch {len(files)} files, {len(changed)} changed'
    else:
        state = f'no patch, {len(changed)} changed'
        if changed:
            notes.append('local changes without a patch')
    bad += bool(notes)
    print(f"{'FAIL' if notes else 'ok  '} {name:30s} {state}" + ('  ' + '; '.join(notes) if notes else ''))
print('packages with problems:', bad)
