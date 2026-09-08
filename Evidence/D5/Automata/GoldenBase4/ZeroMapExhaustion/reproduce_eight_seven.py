"""Rebuild the complete (8,7) obstruction from exact power inputs.

Usage: python reproduce_eight_seven.py OUTPUT_DIRECTORY
Requires Python 3, a C++17 compiler, and Boost multiprecision headers.
No solver, reference DFAO, downloaded data, or Lean executable is used.
The independent checker exhausts the J choices itself; its search order is
not a certificate supplied by the first implementation.
"""
from bisect import bisect_right
from hashlib import sha256
from math import isqrt
from pathlib import Path
import json
import os
import subprocess
import sys


def samples():
    fib = [1, 2]
    while fib[-1] <= 4**249:
        fib.append(fib[-1] + fib[-2])
    rows = []
    for n in range(250):
        q = 4**n
        remainder = q
        word = []
        for weight in reversed(fib[:bisect_right(fib, q)]):
            bit = int(weight <= remainder)
            word.append(bit)
            remainder -= bit * weight
        if remainder or word[0] != 1 or any(a and b for a, b in zip(word, word[1:])):
            raise ValueError('noncanonical power word')
        blocks, at = [], 0
        while at < len(word):
            if word[at] == 0:
                blocks.append(0)
                at += 1
            elif at + 1 < len(word):
                if word[at + 1] != 0:
                    raise ValueError('illegal one successor')
                blocks.append(1)
                at += 2
            else:
                break
        terminal = int(at < len(word))
        floor_phi = lambda x: (x + isqrt(5*x*x)) // 2
        digit = floor_phi(4*q) - 4*floor_phi(q)
        rows.append((n, blocks, terminal, digit))
    return rows


def write_inputs(out):
    vertices = [[0, -1, 0, -1]]
    lines = []
    for n, blocks, terminal, digit in samples():
        at = 0
        gaps = []
        for block in blocks:
            if block:
                gaps.append(0)
            else:
                if not gaps:
                    raise ValueError('unexpected leading zero block')
                gaps[-1] += 1
            if vertices[at][block] < 0:
                vertices[at][block] = len(vertices)
                vertices.append([-1]*4)
            at = vertices[at][block]
        if vertices[at][2 + terminal] not in (-1, digit):
            raise ValueError('inconsistent observation')
        vertices[at][2 + terminal] = digit
        lines.append(' '.join(map(str, [n, digit, terminal] + gaps)))
    (out/'powers.gaps').write_text('\n'.join(lines)+'\n')
    (out/'powers.trace').write_text(str(len(vertices))+'\n' +
        '\n'.join(' '.join(map(str, v)) for v in vertices)+'\n')


def command(args, log):
    p = subprocess.run(list(map(str, args)), text=True, capture_output=True, check=True)
    log.write_text(p.stderr)
    return json.loads(p.stdout) if p.stdout.strip() else None


def main():
    if len(sys.argv) != 2:
        raise SystemExit('usage: reproduce_eight_seven.py OUTPUT_DIRECTORY')
    here = Path(__file__).resolve().parent
    out = Path(sys.argv[1]).resolve()
    out.mkdir(parents=True, exist_ok=True)
    write_inputs(out)
    compiler = os.environ.get('CXX', 'g++')
    for source, binary in [('enumerate_zero_maps.cpp', 'enumerate'),
                           ('check_zero_maps.cpp', 'checker'),
                           ('check_small_instances.cpp', 'selftest')]:
        subprocess.run([compiler, '-O3', '-std=c++17', str(here/source),
                        '-o', str(out/binary)], check=True)
    command([out/'enumerate', 'generate', 8, out/'maps8.txt'], out/'generation.log')
    coverage = command([out/'enumerate', 'audit', out/'maps8.txt'], out/'coverage.log')
    if coverage != {'status': 'PASS', 'r': 8, 'raw_zero_maps': 2097152,
                    'representatives': 929, 'verified_conjugacies': 2097152}:
        raise ValueError('incomplete zero-map coverage')
    small = command([out/'selftest'], out/'selftest.log')
    if small['status'] != 'PASS' or small['instances'] != 6912:
        raise ValueError('small-instance truth comparison failed')
    primary = command([out/'enumerate', out/'powers.trace', out/'maps8.txt',
                       7, 12000, 0, 929], out/'primary.log')
    checked = command([out/'checker', out/'powers.gaps', out/'maps8.txt',
                       7, 12000, 0, 929], out/'checker.log')
    for result in [primary, checked]:
        if any(result[k] != v for k, v in {'status': 'UNSAT', 'r': 8, 's': 7,
                'begin': 0, 'end': 929, 'completed_shapes': 929}.items()):
            raise ValueError('no complete (8,7) exclusion: '+str(result))
    report = {'status': 'PASS', 'coverage': coverage, 'small_instances': small,
              'primary': primary, 'independent_check': checked,
              'sample_sha256': sha256((out/'powers.gaps').read_bytes()).hexdigest(),
              'maps_sha256': sha256((out/'maps8.txt').read_bytes()).hexdigest(),
              'lean_executed': False, 'total_lower_bound_16_claimed': False}
    (out/'report.json').write_text(json.dumps(report, indent=2)+'\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
