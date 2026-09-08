"""A full-space, same-scale ground/prolate Fourier certificate.

The old interval Schur producer is executed and supplies its freshly checked
matrices, not a historical result JSON. A correlated candidate column and a
candidate-normalized Fourier load are bounded in the inverse energy of the
same rank-one stabilized operator. This avoids an assumed absolute uniform
lower ground energy. Every high mode is retained through weighted sums and
an analytic tail. Float Cholesky proposes dyadic coordinates only; interval
Gershgorin/LDL establishes all matrix conclusions.

The original Fourier/core, high-space comparison, inverse-form Schur identity
and spectral variational arguments are paper bridges in the RH theory volume.
The new Lean source proves the residual-energy step without an absolute
spectral lower bound. This program is not a Lean/Scribe/kernel replay.
"""
from __future__ import annotations
from fractions import Fraction as F
from pathlib import Path
import hashlib, importlib.util, json, math, platform, sys
import numpy as np
from mpmath import iv

if not __debug__:
    raise RuntimeError('Assertions are required; do not use -O.')
ROOT = Path(__file__).resolve().parent
PINS = {
    'certify_prime3_scale_interval.py': '13b50abcec06663e35ad8f704cac6de9f3c1a2c37159e7f63e8c24fee4681993',
    'certify_prime3_refined.py': '8bb067fc5499b0f2e1e48836e7a82237a15504109f82a856c72478d1096d69d0',
    'certify_prime3_prolate_scale_transport.py': 'fe1d574f38a13e0dbcc185649c0e6c32dfd9e1cb676ceebb73ad7c6c31218b4f',
    'certify_prime3_prolate_model.py': '42dceb5c81f9aabdc12b51a99d29f0929d81e712f815b49b13bbf9bb5ec56039',
    'prime3_prolate_proposal.json': '242c9897bbd247ef0485039e6dcde819a351c5900ceac52fecc420934c1896db',
}


def load(name: str, filename: str):
    spec = importlib.util.spec_from_file_location(name, ROOT / filename)
    if spec is None or spec.loader is None:
        raise ImportError(filename)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


def rat(x):
    x = F(x)
    return iv.mpf(x.numerator) / x.denominator


def isum(x):
    """Sum outward binary endpoints exactly, then enclose once at iv precision."""
    if not np.all(np.isfinite(x.lo)) or not np.all(np.isfinite(x.hi)):
        raise ArithmeticError('Nonfinite interval input.')
    lo = sum((F.from_float(float(v)) for v in np.ravel(x.lo)), F(0))
    hi = sum((F.from_float(float(v)) for v in np.ravel(x.hi)), F(0))
    return iv.mpf([rat(lo).a, rat(hi).b])


def run(digits: int = 100) -> dict:
    if not 100 <= digits <= 160:
        raise ValueError('Use 100 through 160 decimal interval digits.')
    for name, expected in PINS.items():
        if hashlib.sha256((ROOT/name).read_bytes()).hexdigest() != expected:
            raise ValueError('Unreviewed dependency: '+name)
    cert = load('uniform_ground_schur', 'certify_prime3_scale_interval.py')
    spectral, data = cert.run(digits=digits, with_components=True)
    model = load('uniform_ground_prolate_flow', 'certify_prime3_prolate_scale_transport.py')
    transport = model.run(digits)
    prolate = load('uniform_ground_prolate_base', 'certify_prime3_prolate_model.py')
    model0 = prolate.run(digits)
    iv.dps = digits
    base = cert.base
    N, M = cert.N, cert.M
    assert (N, M) == (64, 32768)
    U, tau, kap = rat(F(3,2500000)), F(3,500000), rat(F(1,1000))
    L = data['length']; Lplus = L.b; ap = Lplus/2
    A, W = iv.matrix(data['low_blocks'][0]), iv.matrix(data['schur_budgets'][0])
    v = iv.matrix(data['candidate'])
    exact_norm2 = F(sum(s*s for s in base.CANDIDATE), 2**80)
    k = v/iv.sqrt(rat(exact_norm2))
    S = A-W+v*v.T-U*iv.eye(N+1)
    center = np.array([[float(S[i,j].mid) for j in range(N+1)] for i in range(N+1)])
    chol = np.linalg.cholesky(center)
    proposed = np.rint(np.linalg.solve(chol.T, np.eye(N+1))*2**32)
    assert np.all(np.isfinite(proposed)) and np.max(abs(proposed)) < 2**53
    integers = proposed.astype(np.int64)
    R = iv.matrix([[rat(F(int(x),2**32)) for x in row] for row in integers])
    whitened = R.T*S*R
    gamma = rat(F(99,100))
    row_margins = [whitened[i,i]-sum((abs(whitened[i,j]) for j in range(N+1) if j!=i),rat(0))
                   for i in range(N+1)]
    assert all(bool(x>gamma) for x in row_margins)
    # The same complete Schur bound also certifies a stronger EVEN threshold.
    # Do not use this value as an odd- or whole-complement gap.
    d65 = rat(F(data['shells'][0][0]['lower']))
    assert bool(d65 > U+kap)
    ratio = (d65-rat(tau))/(d65-U-kap)
    even_coercivity = cert.congruence_ldl((A+v*v.T-(U+kap)*iv.eye(N+1)-ratio*W).tolist())
    sig = data['symbols']; CI = data['even_columns']; sy = data['low_symbols']
    ms = np.arange(N+1,M+1,dtype=np.int64)
    ns = np.arange(1,N+1,dtype=np.int64)
    den = base.PI*base.I(ms[:,None]**2-ns[None,:]**2)
    sm = base.I(sig.lo[N:],sig.hi[N:])
    kc = [base.outer_iv(k[i]) for i in range(N+1)]
    # ONE common high symbol is multiplied only after the candidate sum.
    low_part = base.I(np.zeros(len(ms))); high_coefficient = base.I(np.zeros(len(ms)))
    for n in range(1,N+1):
        dn = base.I(den.lo[:,n-1],den.hi[:,n-1])
        low_part += kc[n]*2*n*base.I(sig.lo[n-1],sig.hi[n-1])/dn
        high_coefficient += kc[n]*2*base.I(ms)/dn
    high_coefficient += base.SQRT2*kc[0]/(base.PI*base.I(ms))
    residual_high = low_part-sm*high_coefficient
    Ak = A*k; mu = (k.T*Ak)[0]
    residual_low = Ak-mu*k
    debt = iv.ln(2)/iv.sqrt(2)+iv.ln(3)/iv.sqrt(3)
    d_far = iv.ln((M+1)/Lplus)-Lplus/(iv.pi*(M+1))-debt
    far = 1/(d_far-rat(tau))
    assert bool(d_far > rat(tau))
    B = 4
    tail_column = []
    for n in range(N+1):
        first = rat(1) if n==0 else iv.sqrt(2)
        second = rat(0) if n==0 else iv.sqrt(2)*n*sy[n]
        tail_column.append(far*(8/iv.pi**2*(B*B*first**2/M+second**2/M**3)+rat(F(2,10**12))))
    trace = k[0]+iv.sqrt(2)*sum(k[n] for n in range(1,N+1))
    jet = iv.sqrt(2)*sum(n*k[n]*sy[n] for n in range(1,N+1))
    mass = abs(k[0])+iv.sqrt(2)*sum(abs(k[n]) for n in range(1,N+1))
    constants = [iv.sqrt(2)*B*abs(trace)/iv.pi, iv.sqrt(2)*abs(jet)/iv.pi,
                 iv.sqrt(2)*2*B*N*N*mass/(iv.pi*(1-rat(F(N,M))))]
    residual_tail = sum((far*x*y/((i+j-1)*M**(i+j-1))
                        for i,x in enumerate(constants,1) for j,y in enumerate(constants,1)),rat(0))

    def inverse_energy(low, high_re, high_im, tail):
        """Complete inverse-energy upper bound via the same actual Schur data."""
        cross = iv.matrix(N+1,1); near = rat(0)
        for shell in data['shells'][0]:
            l,r = shell['first']-N-1, shell['last']-N
            wt = base.outer_iv(rat(1/(F(shell['lower'])-tau)))
            br = base.I(high_re.lo[l:r],high_re.hi[l:r])
            bi = base.I(high_im.lo[l:r],high_im.hi[l:r])
            near += isum(wt*(br*br+bi*bi))
            for i in range(N+1):
                cc = base.I(CI.lo[l:r,i],CI.hi[l:r,i])
                cross[i] += iv.mpc(isum(wt*cc*br),isum(wt*cc*bi))
        for i in range(N+1):
            radius = iv.sqrt(tail_column[i]*tail).b
            # A complex disk is enclosed by a rectangle, deliberately safely.
            cross[i] += iv.mpc(iv.mpf([-radius,radius]),iv.mpf([-radius,radius]))
        transformed = R.T*(low-cross)
        answer = near+tail+sum((abs(x)**2 for x in transformed),rat(0))/gamma
        return answer, {'weighted_near_load':str(near),'weighted_tail_upper':str(tail),
                        'whitened_low_load_squared_upper':str(sum((abs(x)**2 for x in transformed),rat(0)))}

    E, e_parts = inverse_energy(residual_low, residual_high, base.I(np.zeros(len(ms))), residual_tail)
    assert bool(E < rat(F(44,10**10)))
    # The Fourier load is centered at the candidate's origin ratio. This makes
    # its pairing with k exactly zero at every scale, without a fitted phase.
    z0 = iv.mpc(20,rat(F(1,4))); rho = rat(F(1,1000)); b = rat(F(251,1000))
    conj = lambda z: iv.mpc(z.real,-z.imag)
    def coefficients(a,z):
        zz = conj(a*z); numer = 2*zz*iv.sin(zz)
        return [iv.sqrt(2)*iv.sin(zz)/zz]+[numer/(zz*zz-(iv.pi*n)**2) for n in range(1,N+1)]
    zz = conj(L*z0/2); numer = 2*zz*iv.sin(zz)
    goal_low = iv.matrix(coefficients(L/2,z0))
    goal_low[0] = -sum((k[n]*goal_low[n] for n in range(1,N+1)),iv.mpc(0))/k[0]
    zz2=zz*zz; omega=base.PI*base.I(ms)
    dr=base.outer_iv(zz2.real)-omega*omega; di=base.outer_iv(zz2.imag)
    denom=dr*dr+di*di; nr=base.outer_iv(numer.real); ni=base.outer_iv(numer.imag)
    goal_re=(nr*dr+ni*di)/denom; goal_im=(ni*dr-nr*di)/denom
    assert bool(M>=2*abs(zz)/iv.pi)
    goal_tail=far*(4*abs(numer)/(3*iv.pi**2))**2/(3*M**3)
    Cgoal, g_parts = inverse_energy(goal_low,goal_re,goal_im,goal_tail)
    assert bool(Cgoal < rat(F(37,10)))
    K0=iv.sqrt(2)*k[0]
    goal_variation=iv.sqrt(2)*ap*iv.exp(ap*b)*(1+iv.sqrt(2)/abs(K0))*rho
    Cdisk=(iv.sqrt(Cgoal)+goal_variation/iv.sqrt(kap))**2
    angle=iv.sqrt(E/kap); origin_floor=abs(K0)-iv.sqrt(2)*angle
    assert bool(origin_floor>rat(F(108,100)))
    ground_candidate=iv.sqrt(E*Cdisk)/origin_floor
    assert bool(Cdisk<4) and bool(ground_candidate<rat(F(1,8000)))

    # Reconstruct the SAME central prolate polynomial and transport its true
    # error using the freshly replayed model certificate, including its norm.
    pdata=json.loads((ROOT/'prime3_prolate_proposal.json').read_bytes()); vectors=[]
    for p in pdata['proposals']:
        nums=list(map(int,p['vector_numerators']))
        nv=iv.sqrt(rat(sum((F(n*n,2**500) for n in nums),F(0))))
        vectors.append([rat(F(n,2**250))/nv for n in nums])
    rr=vectors[1][0]/vectors[0][0]
    hh=[vectors[1][j]-rr*vectors[0][j] for j in range(32)]; hh[0]=rat(0)
    ar=[rat(0) for _ in range(32)]
    for j in range(1,32):
        pol=model.legendre(2*j); fac=hh[j]*iv.sqrt(rat(F(4*j+1,2)))
        for t in range(j+1): ar[t]+=fac*rat(pol[2*t])/3**t
    a0=iv.ln(3)/2
    def ft(z):
        val=iv.mpc(0)
        for t,x in enumerate(ar):
            rate=2*t+rat(F(1,2))+iv.j*z
            for m in (1,2):val+=4*x*m**(2*t)*(iv.exp(rate*(a0-iv.ln(m)))-iv.exp(-rate*a0))/rate
        return val
    normp=iv.mpf(model0['unnormalized_mellin_model_norm_interval'])
    epsp=iv.mpf(model0['normalized_true_vs_polynomial_model_error'])
    P0poly=(-ft(iv.mpc(0))/(normp*iv.sqrt(a0))).real
    p0error=iv.sqrt(2)*epsp
    P0=P0poly+iv.mpf([-p0error.b,p0error.b])
    assert bool(abs(P0poly)>p0error)
    Pzpoly=-(ft(z0)+ft(-z0))/(2*normp*iv.sqrt(a0))
    pzerror=iv.sqrt(2)*iv.exp(a0/4)*epsp
    candidate_center=sum((conj(g)*k[n] for n,g in enumerate(coefficients(a0,z0))),iv.mpc(0))/K0
    model_center_error=abs(candidate_center-Pzpoly/P0poly)+(pzerror+abs(Pzpoly/P0poly)*p0error)/abs(P0)
    assert model0['true_normalized_prolate_model_to_fixed_weil_candidate_bound']=='113/100000'
    assert bool(iv.mpf(model0['polynomial_model_candidate_overlap'])<0)
    normalized_distance=rat(F(113,100000))/abs(K0)+abs(K0-P0)/(abs(K0)*abs(P0))
    frequency_error=iv.sqrt(2)*a0*iv.exp(a0*b)*rho*normalized_distance
    candidate_scale=iv.sqrt(2)*(abs(z0)+rho)*iv.exp(ap*b)*rat(F(1,50000000))/abs(K0)
    model_scale=iv.mpf(transport['origin_normalized_scale_variation_upper'])
    candidate_model=model_center_error+frequency_error+candidate_scale+model_scale
    total=ground_candidate+candidate_model
    assert bool(candidate_model<rat(F(67,10**6)))
    assert bool(total<rat(F(1,5000)))
    return {
        'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        'dependency_sha256':PINS,'interval_decimal_digits':digits,
        'half_width_center':'log(3)/2','half_width_radius':'1/50000000',
        'frequency_disk':{'center':['20','1/4'],'radius':'1/1000'},'N':N,'M':M,
        'full_space_interval_replayed':spectral['status'],
        'prolate_interval_replayed':transport['status'],
        'central_true_prolate_replayed':model0['new_checks'],
        'lower_ground_energy_assumed':False,
        'candidate_upper':'3/2500000','even_shifted_coercivity':'1/1000',
        'even_only_stronger_coercivity_check':even_coercivity,
        'inverse_congruence_lower':'99/100',
        'inverse_congruence_integer_sha256':hashlib.sha256(json.dumps(integers.tolist(),separators=(',',':')).encode()).hexdigest(),
        'candidate_residual_inverse_energy_upper':str(E),'residual_energy_parts':e_parts,
        'center_observer_inverse_energy_upper':str(Cgoal),'observer_energy_parts':g_parts,
        'disk_observer_inverse_energy_upper':str(Cdisk),
        'projective_mode_distance_upper':str(angle),'projective_origin_modulus_lower':str(origin_floor),
        'uniform_normalized_ground_candidate_error':str(ground_candidate),
        'uniform_normalized_candidate_prolate_error':str(candidate_model),
        'uniform_normalized_ground_prolate_error':str(total),
        'rational_claims':{'residual_inverse_energy_upper':'44/10000000000','disk_observer_energy_upper':'4',
            'normalized_ground_candidate_error_upper':'1/8000','normalized_candidate_prolate_error_upper':'67/1000000',
            'normalized_ground_prolate_error_upper':'1/5000','projective_origin_modulus_lower':'27/25'},
        'normalization':'FT(u_a)(z)/FT(u_a)(0) versus FT(p_a^+)(z)/FT(p_a^+)(0), at the SAME a throughout I.',
        'status':'All fresh full-space, correlated Schur-load, infinite-tail, even-coercivity and normalization guards passed.',
        'scope':'One continuous scale interval and complete complex disk. Analytic operator/core, high-space and inverse-form identities remain paper bridges. No historical numerical ground lower bound, all-scale limit, RH, or Lean/Scribe verdict.',
        'python':platform.python_version(),'numpy':np.__version__}


if __name__=='__main__':
    digits=int(sys.argv[1]) if len(sys.argv)>1 else 100
    result=run(digits);suffix='' if digits==100 else '_'+str(digits)
    (ROOT/('prime3_uniform_ground_readout_certificate'+suffix+'.json')).write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2),flush=True)
