"""Uniform true-prolate Fourier transport on the certified prime-three interval.

The fixed dyadic modes are proposals only. Two-sided Sturm/Schur counts
include the entire Legendre complement for every parameter in the interval.
Residual variation is evaluated as (q(a)^2-q(a0)^2)*t^2*v, keeping correlation.
The actual moving Mellin cutoffs are handled by an exact scale-flow identity;
new integer summands enter with zero Fourier mass. No quadrature, eigensolver,
zeta data or precomputed spectral certificate supplies the result.

Operator realization, spectral projection and the Mellin L2/flow estimates
are paper bridges in RH_RESEARCH_LANE_THEORY.md. The finite centered Fourier
identity has a Lean companion. This verifier does not check the Weil ground
mode across the parameter interval and is not a Lean kernel replay.
"""
from __future__ import annotations
from fractions import Fraction as F
from pathlib import Path
import hashlib,json,math,sys
from mpmath import iv
ROOT=Path(__file__).resolve().parent
PROPOSAL_SHA='242c9897bbd247ef0485039e6dcde819a351c5900ceac52fecc420934c1896db'
if not __debug__:raise RuntimeError('Assertions are required; do not use -O.')
def rat(x):
    x=F(x);return iv.mpf(x.numerator)/x.denominator
def legendre(n):
    out=[F(0)]*(n+1)
    for k in range(n//2+1):out[n-2*k]=F((-1)**k*math.factorial(2*n-2*k),2**n*math.factorial(k)*math.factorial(n-k)*math.factorial(n-2*k))
    return out

def run(digits=110):
    if not 100<=digits<=200:raise ValueError('Require 100 through 200 interval digits.')
    raw=ROOT.joinpath('prime3_prolate_proposal.json').read_bytes()
    if hashlib.sha256(raw).hexdigest()!=PROPOSAL_SHA:raise ValueError('Unreviewed prolate proposal.')
    data=json.loads(raw);K=32
    assert (data['scale_c'],data['dimension'],data['dyadic_bits'])==(3,K,250)
    assert [p['even_index'] for p in data['proposals']]==[0,2]
    iv.dps=digits
    step=rat(F(1,50000000));a0=iv.ln(3)/2
    aa=iv.mpf([(a0-step).a,(a0+step).b]);amin,amax=aa.a,aa.b
    assert bool(iv.ln(2)/2<amin) and bool(amax<iv.ln(4)/2)
    q2=(2*iv.pi*iv.exp(2*aa))**2;q20=(6*iv.pi)**2;dq=abs(q2-q20).b
    alpha=lambda j:rat(j+1)/iv.sqrt((2*j+1)*(2*j+3)) if j>=0 else rat(0)
    Vdiag=[alpha(2*j)**2+alpha(2*j-1)**2 for j in range(K)]
    Voff=[alpha(2*j)*alpha(2*j+1) for j in range(K)]
    D=[rat(2*j*(2*j+1))+q2*Vdiag[j] for j in range(K)]
    off=[q2*x for x in Voff];Htail=2*K*(2*K+1)
    def count(s,lower):
        assert bool(s<Htail)
        p=D[0]-s;negative=0
        for j in range(K):
            if j:p=D[j]-s-off[j-1]**2/p
            if j==K-1 and lower:p-=off[-1]**2/(Htail-s)
            assert bool(p>0) or bool(p<0),('ambiguous Sturm pivot',j,str(p))
            negative+=int(bool(p<0))
        return negative
    vectors=[];errors=[];center_errors=[];spectral=[]
    for prop in data['proposals']:
        nums=list(map(int,prop['vector_numerators']));assert len(nums)==K
        norm=iv.sqrt(rat(sum((F(n*n,2**500) for n in nums),F(0))))
        v=[rat(F(n,2**250))/norm for n in nums];assert bool(v[0]>0)
        mu=rat(F(int(prop['center_numerator']),2**250));sep=50;jindex=prop['even_index']
        counts=[count(mu-sep,b) for b in(False,True)]+[count(mu+sep,b) for b in(False,True)]
        assert counts==[jindex,jindex,jindex+1,jindex+1]
        potential=[];residual=[]
        for j in range(K):
            t=Vdiag[j]*v[j]+(Voff[j-1]*v[j-1] if j else 0)+(Voff[j]*v[j+1] if j+1<K else 0)
            potential.append(t)
            residual.append((rat(2*j*(2*j+1))-mu)*v[j]+q20*t)
        potential_norm=iv.sqrt(sum((x**2 for x in potential),rat(0))+(Voff[-1]*v[-1])**2)
        center_r=iv.sqrt(sum((x**2 for x in residual),rat(0))+(q20*Voff[-1]*v[-1])**2)
        r=center_r+dq*potential_norm
        err=iv.sqrt(2)*r/sep;err0=iv.sqrt(2)*center_r/sep
        assert bool(v[0]>err)
        vectors.append(v);errors.append(err);center_errors.append(err0)
        spectral.append({'even_index':jindex,'center':str(mu),'two_sided_full_spectrum_counts':counts,
                         'complement_distance_from_center':sep,'full_potential_action_norm':str(potential_norm),
                         'center_full_residual_norm':str(center_r),'uniform_mode_distance_upper':str(err)})
    v0,v4=vectors;ratio=v4[0]/v0[0]
    def seed_error(es):
        e0,e4=es;dr=(e4+abs(ratio)*e0)/(v0[0]-e0)
        return e4+(abs(ratio)+dr)*e0+dr
    errH=seed_error(errors);errH0=seed_error(center_errors)
    H=[v4[j]-ratio*v0[j] for j in range(K)];H[0]=rat(0)
    Hsup=sum((abs(x)*iv.sqrt(rat(F(4*j+1,2))) for j,x in enumerate(H)),rat(0))
    Hnorm=1+abs(ratio)
    radius=rat(F(1,1000));z0=iv.mpc(20,rat(F(1,4)));b=rat(F(251,1000))
    assert bool(abs(z0)+radius+rat(F(1,2))<21)
    C=4*iv.exp(amax/2)*sum((1/iv.sqrt(m) for m in(1,2,3)),rat(0))
    FTweight=iv.sqrt(2*amax)*iv.exp(amax*b)*C
    FTweight0=iv.sqrt(2*amax)*C
    # The same fixed seed is used in the exact scale-flow identity on both
    # sides of a0. At a0 the m=3 term has zero integral, so no jump is lost.
    flux=21*FTweight*Hnorm+24*iv.exp(-amin*(rat(F(1,2))-b))*Hsup
    flux0=FTweight0*Hnorm/2+24*iv.exp(-amin/2)*Hsup
    difference=FTweight*(errH+errH0)+step*flux
    difference0=FTweight0*(errH+errH0)+step*flux0
    # Exact endpoint evaluation of the fixed polynomial model at a0.
    A=[rat(0) for _ in range(K)]
    for j in range(1,K):
        poly=legendre(2*j);fac=H[j]*iv.sqrt(rat(F(4*j+1,2)))
        for r in range(j+1):A[r]+=fac*rat(poly[2*r])/3**r
    def ft(z):
        result=iv.mpc(0)
        for r,ar in enumerate(A):
            rate=2*r+rat(F(1,2))+iv.j*z
            for m in(1,2):
                result+=4*ar*m**(2*r)*(iv.exp(rate*(a0-iv.ln(m)))-iv.exp(-rate*a0))/rate
        return result
    fixed_origin=ft(iv.mpc(0)).real
    center_origin_floor=abs(fixed_origin)-FTweight0*errH0
    all_origin_floor=center_origin_floor-difference0
    center_even=(ft(z0)+ft(-z0))/2
    # Derivative with respect to z on the disk for the central model.
    center_numerator_upper=abs(center_even)+FTweight*errH0+radius*a0*FTweight*(Hnorm+errH0)
    normalized_change=(difference+center_numerator_upper*difference0/center_origin_floor)/all_origin_floor
    assert bool(all_origin_floor>rat(F(23,10)))
    assert bool(errH<rat(F(652,10**9)))
    assert bool(normalized_change<rat(F(1,100000)))
    centered_readout_change=iv.sqrt(2)*(abs(z0)+radius)*iv.exp(amax*b)*step+iv.sqrt(2)*normalized_change
    assert bool(centered_readout_change<rat(F(15,1000000)))
    return {'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
            'proposal_sha256':PROPOSAL_SHA,'interval_decimal_digits':digits,
            'half_width_center':'log(3)/2','half_width_radius':'1/50000000',
            'spectral_mode_certificates':spectral,'uniform_zero_integral_seed_error':str(errH),
            'central_zero_integral_seed_error':str(errH0),'fixed_seed_uniform_bound':str(Hsup),
            'fixed_seed_scale_derivative_bound_on_disk':str(flux),
            'raw_Fourier_scale_difference_bound':str(difference),
            'raw_origin_scale_difference_bound':str(difference0),
            'central_raw_model_origin':str(fixed_origin),'all_scale_raw_origin_floor':str(all_origin_floor),
            'origin_normalized_scale_variation_upper':str(normalized_change),
            'dilated_model_centered_readout_change_upper':str(centered_readout_change),
            'closed_frequency_disk':{'center':['20','1/4'],'radius':'1/1000'},
            'rational_claims':{'uniform_origin_modulus_lower':'23/10','uniform_normalized_scale_variation_upper':'1/100000','uniform_centered_readout_change_upper':'15/1000000'},
            'normalization':'FT(p_a^+)(z)/FT(p_a^+)(0) versus the SAME true prolate construction at a0; no fixed-seed substitution.',
            'status':'All full-space Sturm-Schur, correlated residual, seed-ratio, cutoff-flow and normalization guards passed.',
            'not_claimed':'No new Weil-ground Fourier bound across the scale interval, no all-scale rate, no Xi limit, and no Lean/Scribe execution.',
            'scope':'Uniform true-prolate model transport on the previously certified narrow scale interval. Analytic prolate realization, Mellin L2/scale-flow and spectral projection are paper bridges.'}
if __name__=='__main__':
    digits=int(sys.argv[1]) if len(sys.argv)>1 else 110
    result=run(digits);suffix='' if digits==110 else '_'+str(digits)
    ROOT.joinpath('prime3_prolate_scale_transport_certificate'+suffix+'.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))
