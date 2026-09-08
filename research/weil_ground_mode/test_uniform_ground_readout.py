"""Exact Schur and projective-energy diagnostics for the joint certificate.

Synthetic matrices test algebra and rejected mutations only. They do not
supply Weil spectra. The separate directed producer replays the actual
full-space arithmetic, all exterior modes and genuine prolate construction.
"""
from __future__ import annotations
from fractions import Fraction as F
from pathlib import Path
import hashlib, importlib.util, json, random, sys
import sympy as s
from mpmath import iv

ROOT=Path(__file__).resolve().parent


def run():
    rng=random.Random(20260908)
    def q():return s.Rational(rng.randint(-6,6),rng.randint(1,8))
    def z():return q()+s.I*q()
    inverse_cases=0; cross_mutations=0; monotonic_cases=0
    for _ in range(60):
        c=s.Matrix([[z(),z()]])
        d=s.Rational(rng.randint(1,9),rng.randint(1,5))
        S=s.Matrix([[3,s.Rational(1,3)],[s.Rational(1,3),2]])
        L=S+c.conjugate().T*c/d
        G=L.row_join(c.conjugate().T).col_join(c.row_join(s.Matrix([[d]])))
        b=s.Matrix([z(),z(),z()]); low=b[:2,0]; high=b[2]
        y=c.conjugate().T*high/d
        corrected=low-y
        form=s.simplify((s.conjugate(high)*high/d+(corrected.conjugate().T*S.inv()*corrected)[0]))
        actual=s.simplify((b.conjugate().T*G.inv()*b)[0])
        assert s.simplify(form-actual)==0;inverse_cases+=1
        wrong=low+y
        altered=s.simplify(s.conjugate(high)*high/d+(wrong.conjugate().T*S.inv()*wrong)[0])
        cross_mutations+=int(s.simplify(altered-actual)!=0)
        stronger=G.copy();stronger[2,2]+=s.Rational(3,2)
        actual2=s.simplify((b.conjugate().T*stronger.inv()*b)[0])
        assert s.simplify(form-actual2)>=0;monotonic_cases+=1
    assert cross_mutations>40
    residual_cases=0
    for _ in range(180):
        lam=-abs(q()); b=1-lam+abs(q()); w=z()
        n=s.simplify(s.conjugate(w)*w)
        M=s.Matrix([[lam+b*n,-b*s.conjugate(w)],[-b*w,lam+b]])
        u=s.Matrix([1,w]); error=s.Matrix([0,w]); k=s.Matrix([1,0])
        assert all(s.simplify(x)==0 for x in M*u-lam*u)
        r=M*k-M[0,0]*k; B=lam+b
        energy=s.simplify((error.conjugate().T*M*error)[0])
        E=s.simplify((r.conjugate().T*r)[0]/B)
        assert B>0 and energy>=0 and s.simplify(E-energy)>=0
        assert s.simplify(n-E/B)<=0
        residual_cases+=1
    # Dropping the nonpositive eigenvalue premise breaks the conclusion.
    assert s.Rational(3)>s.Rational(4,3)
    lam,b,w=s.Integer(1),s.Integer(2),s.Integer(1)
    assert (lam+b)*w*w>b*b*w*w/(lam+b)
    m=s.Symbol('m',nonzero=True); pi=s.Symbol('pi',nonzero=True)
    sm=s.Symbol('sm'); trace=s.Symbol('trace'); jet=s.Symbol('jet')
    symbolic=0
    for N in (1,2,4):
        coeff=s.symbols('k0:'+str(N+1)); symbols=s.symbols('s0:'+str(N+1))
        direct=-s.sqrt(2)*sm*coeff[0]/(pi*m)
        common=-s.sqrt(2)*coeff[0]/(pi*m)
        low=0
        for n in range(1,N+1):
            direct+=coeff[n]*2*(n*symbols[n]-m*sm)/(pi*(m*m-n*n))
            low+=coeff[n]*2*n*symbols[n]/(pi*(m*m-n*n))
            common-=coeff[n]*2*m/(pi*(m*m-n*n))
        assert s.factor(direct-(low+sm*common))==0;symbolic+=1
    # Exact two-term expansion and its remainder for a raw signed column.
    n,sn=s.symbols('n sn')
    expression=(sn-sm)/(pi*(m-n))
    expansion=(sn-sm)/(pi*m)+n*(sn-sm)/(pi*m*m)+n*n*(sn-sm)/(pi*m*m*(m-n))
    assert s.factor(expression-expansion)==0;symbolic+=1
    # The complete tail is integrated, not sampled. This checks the elementary
    # primitive for all nine cross terms of the 1/m,1/m^2,1/m^3 envelope.
    x=s.Symbol('x',positive=True);tail_terms=0
    for i in range(1,4):
        for j in range(1,4):
            primitive=-x**(-(i+j-1))/s.Integer(i+j-1)
            assert s.simplify(s.diff(primitive,x)-x**(-i-j))==0;tail_terms+=1
    path=ROOT/'certify_prime3_uniform_ground_readout.py'
    sha=hashlib.sha256(path.read_bytes()).hexdigest()
    lo=json.loads((ROOT/'prime3_uniform_ground_readout_certificate.json').read_bytes())
    hi=json.loads((ROOT/'prime3_uniform_ground_readout_certificate_120.json').read_bytes())
    assert lo['source_sha256']==hi['source_sha256']==sha
    assert lo['rational_claims']==hi['rational_claims']
    assert lo['lower_ground_energy_assumed'] is False
    assert lo['half_width_radius']==hi['half_width_radius']=='1/50000000'
    iv.dps=80
    E=iv.mpf(lo['candidate_residual_inverse_energy_upper'])
    C=iv.mpf(lo['disk_observer_inverse_energy_upper'])
    beta=iv.mpf(lo['projective_origin_modulus_lower'])
    total=iv.sqrt(E*C)/beta+iv.mpf(lo['uniform_normalized_candidate_prolate_error'])
    assert bool(total<iv.mpf(1)/5000)
    # Same executable load must reject unsupported precision before any heavy run.
    spec=importlib.util.spec_from_file_location('uniform_ground_guard',path)
    if spec is None or spec.loader is None:raise ImportError(path)
    mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
    rejects=0
    for precision in (70,99,161):
        try:mod.run(precision)
        except ValueError:rejects+=1
        else:raise AssertionError('precision guard missing')
    # A false expected hash is rejected before importing/running dependencies.
    name=next(iter(mod.PINS));old=mod.PINS[name];mod.PINS[name]='0'*64
    try:mod.run(100)
    except ValueError:rejects+=1
    else:raise AssertionError('pin guard missing')
    finally:mod.PINS[name]=old
    return {'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        'exact_complex_inverse_Schur_identities':inverse_cases,
        'exact_positive_high_block_inverse_comparisons':monotonic_cases,
        'wrong_cross_sign_mutations_detected':cross_mutations,
        'exact_candidate_residual_energy_cases':residual_cases,
        'positive_shifted_eigenvalue_counterexample':True,
        'exact_actual_column_algebra_identities':symbolic,
        'exact_infinite_tail_primitives':tail_terms,
        'two_directed_precisions_same_claims':True,
        'invalid_precision_and_pin_rejections':rejects,
        'status':'All exact Schur/residual identities, mutations, endpoint algebra and replay bindings passed.',
        'scope':'Single-author development diagnostics. Synthetic matrices verify algebra only; the separate producer supplies the actual Weil/prolate numerical certificate. No Lean/Scribe or independent-author review.'}


if __name__=='__main__':
    result=run()
    ROOT.joinpath('uniform_ground_readout_regression.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))
