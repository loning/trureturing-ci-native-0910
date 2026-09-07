#!/usr/bin/env python3
"""Exact development checks for the conserved-residual interval contractor.

The independent oracle enumerates vertices of box intersect sum(r)=0.
This does not prove the C++ implementation universally or constitute Lean admission.
"""
from __future__ import annotations
from fractions import Fraction as F
from pathlib import Path
import argparse, hashlib, itertools, json, random, subprocess

SCALE = 1 << 40


def require(ok, message):
    if not ok:
        raise ValueError(message)


def exact_extrema(c, lo, hi):
    values = []
    for free in range(6):
        other = [j for j in range(6) if j != free]
        for bits in itertools.product((0, 1), repeat=5):
            x = [F(0)] * 6
            for j, bit in zip(other, bits):
                x[j] = (lo[j], hi[j])[bit]
            x[free] = -sum(x)
            if lo[free] <= x[free] <= hi[free]:
                values.append(sum(a*b for a,b in zip(c,x)))
    require(values, 'empty balanced box in test generator')
    return min(values), max(values)


HELPER = r'''
#define MUB_BALANCED_SUBLEVEL_LIBRARY
#include "check_real_x_balanced_sublevel.cpp"
int main() {
  try {
    int n; if (!(cin >> n) || n < 0) throw runtime_error("bad sample count");
    for (int t=0; t<n; ++t) {
      array<ll,6> c; array<I,6> r;
      for (int j=0;j<6;++j) if (!(cin >> c[j])) throw runtime_error("bad coefficient");
      for (int j=0;j<6;++j) {
        ll lo,hi; if (!(cin>>lo>>hi)) throw runtime_error("bad endpoints");
        r[j]=I(lo,hi);
      }
      I bound=balanced_linear_range(c,r);
      cout<<bound.l<<' '<<bound.h<<'\n';
    }
    return 0;
  } catch (exception const& e) { cerr<<e.what()<<'\n'; return 1; }
}
'''


def run(output: Path, samples=1200):
    require(samples > 0, 'nonpositive test count')
    output.mkdir(parents=True, exist_ok=True)
    directory = Path(__file__).resolve().parent
    helper=output/'dual_probe.cpp'; helper.write_text(HELPER)
    binary=(output/'dual_probe').resolve()
    subprocess.run(['g++','-O2','-std=c++17','-Wall','-Wextra','-Werror',
                    '-I',str(directory),str(helper),'-o',str(binary)],check=True)
    rng=random.Random(502820260907)
    cases=[]
    for _ in range(samples):
        c=[F(rng.randrange(-256,257),16) for _ in range(6)]
        witness=[F(rng.randrange(-32,33),32) for _ in range(5)]
        witness.append(-sum(witness))
        lo=[x-F(rng.randrange(0,65),64) for x in witness]
        hi=[x+F(rng.randrange(0,65),64) for x in witness]
        cases.append((c,lo,hi))
    # Includes repeated coefficients and collapsed balanced faces.
    cases.extend([
        ([F(1)]*5+[F(0)], [F(-1)]*6, [F(1)]*6),
        ([F(7)]*6, [F(-1)]*6, [F(1)]*6),
        ([F(i) for i in range(6)], [F(0)]*6, [F(0)]*6),
    ])
    payload=[str(len(cases))]
    for c,lo,hi in cases:
        payload.append(' '.join(str(int(a*SCALE)) for a in c))
        payload.append(' '.join(str(int(a*SCALE)) for p in zip(lo,hi) for a in p))
    done=subprocess.run([str(binary)],input='\n'.join(payload)+'\n',text=True,
                        stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=True)
    lines=done.stdout.splitlines(); require(len(lines)==len(cases),'truncated output')
    tightened=0
    for (c,lo,hi),line in zip(cases,lines):
        raw=list(map(int,line.split())); require(len(raw)==2,'bad output')
        a,b=[F(v,SCALE) for v in raw]
        lower,upper=exact_extrema(c,lo,hi)
        require(a <= lower <= upper <= b, 'outward interval missed an exact LP vertex')
        naive_low=sum(min(x*y,x*z) for x,y,z in zip(c,lo,hi))
        naive_hi=sum(max(x*y,x*z) for x,y,z in zip(c,lo,hi))
        require(naive_low <= a <= b <= naive_hi,'contractor widened naive interval')
        tightened += int(a>naive_low or b<naive_hi)
        # All coefficients/endpoints in these tests are dyadic with modest
        # denominator; the candidate shifts attain the exact LP optimum.
        require(a==lower and b==upper, 'dual not sharp on dyadic vertex fixture')
    median_count=0
    for _ in range(200):
        c=[F(rng.randrange(-500,501),32) for _ in range(6)]
        epsilon=F(rng.randrange(1,50),64)
        ordered=sorted(c); expected=epsilon*(sum(ordered[3:])-sum(ordered[:3]))
        values=[]
        for plus in itertools.combinations(range(6),3):
            values.append(epsilon*(sum(c[j] for j in plus)-sum(c[j] for j in range(6) if j not in plus)))
        require(max(values)==expected and min(values)==-expected,'median formula failed')
        median_count+=1
    # Removing a mathematical premise really invalidates the bound.
    c=[F(1)]*5+[F(0)]; nonbalanced=[F(1)]*5+[F(0)]
    _,balanced_cap=exact_extrema(c,[F(-1)]*6,[F(1)]*6)
    require(sum(a*b for a,b in zip(c,nonbalanced))>balanced_cap,
            'missing-balance negative control failed')
    bad='1\n0 0 0 0 0 0\n1 -1 0 0 0 0 0 0 0 0 0 0\n'
    rejected=subprocess.run([str(binary)],input=bad,text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    require(rejected.returncode!=0,'reversed interval was accepted')
    # Force an intermediate checked overflow in the exact endpoint readout.
    huge='1\n'+ ' '.join([str(2**63-1)]*6)+'\n'+' '.join(['1 '+str(2**63-1)]*6)+'\n'
    overflow=subprocess.run([str(binary)],input=huge,text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    require(overflow.returncode!=0,'overflow was accepted')
    import check_real_x_balanced_cover as driver
    seed_result=driver.check_seed()
    E=driver.seed_owner.E
    b=E((F(-3,5),F(4,5),F(0),F(0)))
    e=E((F(-2,5),F(0),F(0),F(1,5)))
    H0=driver.seed_owner.hadamard(b,e)
    H0=[H0[i] for i in [2,0,1,4,5,3]]
    AH=driver.seed_owner.adj(H0)
    for _ in range(100):
        phases=[E.rat(1)]
        for j in range(5):
            t=F(rng.randrange(-15,16),16)
            sign=rng.choice([-1,1])
            phases.append(E((sign*(1-t*t)/(1+t*t),sign*2*t/(1+t*t),F(0),F(0))))
        ys=[sum((a*z for a,z in zip(row,phases)),E.rat(0)) for row in AH]
        rs=[y*y.conj()-6 for y in ys]
        require(sum(rs,E.rat(0))==E.rat(0),'actual exact seed conservation failed')
    good=[{'status':'FULL_SIX_SUBLEVEL_COVERED','chart':i,'nodes':1,'pending':0,
           'unresolved':0,'epsilon_bits':6,'tube_bits':4,'dual_improvements':0,
           'residual_domain':'all_six_balanced'} for i in range(32)]
    report_controls=0
    for altered in [good[:-1], [dict(r, residual_domain='first_five') for r in good],
                    [dict(r, epsilon_bits=5) for r in good],
                    [dict(r, status='INCOMPLETE') if r['chart']==11 else r for r in good]]:
        try: driver.audit_reports(altered)
        except ValueError: report_controls+=1
        else: raise ValueError('malformed cover report accepted')
    require(report_controls==4,'missing negative control')
    report={'status':'EXACT_DUAL_TESTS_PASSED','box_hyperplane_vertex_cases':len(cases),
        'strictly_tightened_cases':tightened,'balanced_twenty_vertex_tests':median_count,
        'missing_balance_counterexample':True,'reversed_interval_rejected':True,
        'overflow_rejected':True,'actual_seed_gram':seed_result,'exact_seed_phase_tests':100,
        'malformed_cover_reports_rejected':report_controls,'lean_kernel_verified':False,
        'scope':'finite exact development tests against a separately implemented LP vertex oracle',
        'source_sha256':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in
            (Path(__file__),directory/'check_real_x_balanced_sublevel.cpp',directory/'check_real_x_global_cover.cpp')}}
    (output/'verification.json').write_text(json.dumps(report,indent=2)+'\n')
    return report

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--samples',type=int,default=1200);a=p.parse_args()
    print(json.dumps(run(a.output,a.samples),indent=2))
