"""Independent-expression checks for the actual moving polynomial window.

Symbolic identities are exact. Nondirected quadrature is diagnostic only;
the separate interval program proves the uniform prolate-model bound.
"""
from pathlib import Path
import hashlib,json
import sympy as sp
import mpmath as mp

def run():
    a,l,s=sp.symbols('a l s');symbolic=0;mutations=0
    for r in range(6):
        q=s+2*r
        original=4*sp.exp(-2*r*a+2*r*l)*(sp.exp(q*(a-l))-sp.exp(-q*a))/q
        centered=4*sp.exp(2*r*l)*(sp.exp(-q*l)-sp.exp(-2*q*a))/q
        assert sp.simplify(sp.expand_power_exp(sp.exp(-s*a)*original)-centered)==0
        assert sp.simplify(sp.diff(original,a)-s*original-8*sp.exp(2*r*l-a*(s+4*r)))==0
        assert sp.simplify(original.subs(a,l/2))==0
        assert sp.simplify(sp.diff(original,a).subs(a,l/2)-8*sp.exp(-s*l/2))==0
        symbolic+=4
        if r:
            bad=sp.diff(original,a)-s*original-8*sp.exp(2*r*l-a*s)
            assert sp.simplify(bad)!=0;mutations+=1
    mp.mp.dps=65;errors=[]
    for aa in (mp.log(3)/2-mp.mpf('2e-8'),mp.log(3)/2+mp.mpf('2e-8')):
        for zz in (mp.mpc(0),mp.mpc(20,mp.mpf('.25'))):
            for coeff in ((1,),(1,-2,3),(mp.mpc(1,2),mp.mpc(-2,1))):
                def H(t):return sum(c*t**(2*r) for r,c in enumerate(coeff))
                raw=mp.mpc(0);endpoint=mp.mpc(0)
                for m in (1,2,3):
                    upper=aa-mp.log(m)
                    if upper<=-aa:continue
                    raw+=4*mp.quad(lambda x:mp.exp(x/2)*H(m*mp.exp(x-aa))*mp.exp(1j*zz*x),[-aa,upper])
                    for r,c in enumerate(coeff):
                        rate=2*r+mp.mpf('.5')+1j*zz
                        endpoint+=4*c*mp.exp(-2*r*aa)*m**(2*r)*(mp.exp(rate*upper)-mp.exp(-rate*aa))/rate
                errors.append(abs(raw-endpoint)/(1+abs(raw)))
    assert max(errors)<mp.mpf('1e-55')
    root=Path(__file__).parent
    lo=json.loads((root/'prime3_prolate_scale_transport_certificate.json').read_text())
    hi=json.loads((root/'prime3_prolate_scale_transport_certificate_130.json').read_text())
    sourcehash=hashlib.sha256((root/'certify_prime3_prolate_scale_transport.py').read_bytes()).hexdigest()
    assert lo['source_sha256']==hi['source_sha256']==sourcehash
    assert lo['rational_claims']==hi['rational_claims']
    assert [x['two_sided_full_spectrum_counts'] for x in lo['spectral_mode_certificates']]==[[0,0,1,1],[2,2,3,3]]
    return {'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
            'exact_scale_identity_derivative_and_activation_checks':symbolic,
            'wrong_seed_scaling_mutations_rejected':mutations,
            'original_moving_window_quadrature_diagnostics':len(errors),
            'diagnostic_precision':65,'maximum_relative_quadrature_difference':mp.nstr(max(errors),20),
            'two_interval_precisions_same_rational_claims':True,
            'status':'Exact scale identities, mutation checks and separate-expression diagnostics passed.',
            'scope':'Single-author tests. Quadrature does not certify the interval theorem; Lean and Scribe have not been executed.'}
if __name__=='__main__':
    result=run();Path(__file__).with_name('prolate_scale_transport_regression.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
