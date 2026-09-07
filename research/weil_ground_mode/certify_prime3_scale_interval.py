"""Uniform full-space Weil Schur certificate on an interval crossing c=3.

All low matrix entries and low/high couplings are directed interval functions
of the SAME length L in [log(3)-2*step, log(3)+2*step]. Prime 3 is represented
by its actual positive overlap; no samples stand in for an interval proof.
The high-space comparison retains all frequencies and both parity sectors.
Analytic Gamma, Fourier/domain and Schur bridges are documented separately.
A positive Young bound retains the midpoint Gram directions while enclosing
parameter uncertainty. Float Cholesky only proposes a dyadic congruence,
which is independently checked by directed products and strict LDL.
This program does not execute Lean, CI, or a spectral eigensolver.
"""
from __future__ import annotations
from fractions import Fraction as F
from pathlib import Path
import argparse, hashlib, importlib.util, json, math, platform, time
import numpy as np
from mpmath import iv

if not __debug__:
    raise RuntimeError('Assertions are part of the certificate; do not use -O.')
ROOT = Path(__file__).resolve().parent
PIN = '8bb067fc5499b0f2e1e48836e7a82237a15504109f82a856c72478d1096d69d0'
path = ROOT/'certify_prime3_refined.py'
if hashlib.sha256(path.read_bytes()).hexdigest() != PIN:
    raise ValueError('Unreviewed arithmetic dependency.')
spec=importlib.util.spec_from_file_location('scale_base',path)
if spec is None or spec.loader is None: raise ImportError(path)
base=importlib.util.module_from_spec(spec);spec.loader.exec_module(base)

N,M,BITS,RBITS=64,32768,44,60
THETA=F(1,200)

def rat(x):
    x=F(x);return iv.mpf(x.numerator)/x.denominator

def pospart(x):
    return iv.mpf([max(iv.mpf(0).a,x.a),max(iv.mpf(0).b,x.b)])

def wide_sine(x):
    # Integer period reduction is an untrusted choice, verified by the
    # reduced-argument guard; the Taylor remainder covers the full interval.
    q=np.floor(x.mid()/(2*np.pi)+.5)
    assert np.all(np.isfinite(q)) and np.max(abs(q))<2**53
    r=x-2*base.PI*base.I(q)
    assert np.max(np.maximum(abs(r.lo),abs(r.hi)))<4
    term=r;answer=base.I(0);r2=r*r
    for j in range(32):
        answer+=term
        term=-term*r2/((2*j+2)*(2*j+3))
    assert F(4)**64/math.factorial(64)<F.from_float(1e-49)
    return answer.widen(1e-49)

def floor_verified(x, bits=24):
    n=math.floor(float(x.a)*2**bits)-1
    q=F(n,2**bits)
    if not bool(rat(q)<x): raise ArithmeticError('Unverified rational floor.')
    return q

def ldl(A):
    d=len(A);low=[[iv.mpf(0) for _ in range(d)] for _ in range(d)]; piv=[]
    for j in range(d):
        low[j][j]=iv.mpf(1)
        p=A[j][j]-sum((low[j][k]**2*piv[k] for k in range(j)),iv.mpf(0))
        if not bool(p>0): raise ArithmeticError(f'LDL failed at {j}: {p}')
        piv.append(p)
        for i in range(j+1,d):
            low[i][j]=(A[i][j]-sum((low[i][k]*low[j][k]*piv[k] for k in range(j)),iv.mpf(0)))/p
    return min(float(p.a) for p in piv)

def congruence_ldl(matrix):
    # The floating factorization only proposes a change of coordinates.
    # Its dyadic rounding is checked by directed multiplication and LDL.
    dim=len(matrix)
    center=np.array([[float(x.mid) for x in row] for row in matrix])
    L=np.linalg.cholesky(center)
    proposal=np.linalg.solve(L.T,np.eye(dim))
    scaled=np.rint(proposal*2**32)
    assert np.all(np.isfinite(scaled)) and np.max(abs(scaled))<2**53
    integers=scaled.astype(np.int64)
    R=iv.matrix([[rat(F(int(x),2**32)) for x in row] for row in integers])
    A=iv.matrix(matrix)
    checked=R.T*A*R
    lower=ldl([[checked[i,j] for j in range(dim)] for i in range(dim)])
    # Positive R^* A R implies that square R is injective and therefore
    # bijective, so no unverified numerical invertibility premise is used.
    digest=hashlib.sha256(json.dumps(integers.tolist(),separators=(',',':')).encode()).hexdigest()
    return {'positive_interval_pivot_display':lower,'dyadic_basis_sha256':digest}

def run(step=F(1,5*10**7), digits=70, threshold=F(6,10**6), upper=F(6,5*10**6)):
    if step<=0 or step>F(1,10000) or not 55<=digits<=200 or not 0<upper<threshold<F(1,100):
        raise ValueError('Parameters outside the reviewed range.')
    iv.dps=digits
    d=2*N+1
    L0=iv.ln(3); dh=rat(2*step)
    L=iv.mpf([(L0-dh).a,(L0+dh).b]); lo=L.a;hi=L.b
    assert bool(iv.ln(2)<L) and bool(L<2*iv.ln(2)) and bool(L<iv.ln(4))
    w2=iv.ln(2)/iv.sqrt(2);w3=iv.ln(3)/iv.sqrt(3);debt=w2+w3
    H2=2-2*iv.ln(2)/L;H3=pospart(2-2*iv.ln(3)/L)
    assert bool(H2>0) and bool(H2<1) and bool(H3>=0) and bool(H3<1)
    B=4
    assert bool(iv.pi/2+hi/(iv.pi*(N+1))<2)
    assert bool(2*(iv.exp(hi/2)+iv.exp(-hi/2))/2+debt<B)
    iL=base.outer_iv(L); q=base.outer_iv(iv.exp(-2*L)); decay0=base.outer_iv(iv.exp(-L/2))
    ich=base.outer_iv((iv.exp(L/2)+iv.exp(-L/2))/2)
    iH2=base.outer_iv(H2);iH3=base.outer_iv(H3)
    iW2=base.outer_iv(w2);iW3=base.outer_iv(w3)
    def symbols(ns):
        omega=2*base.PI*base.I(ns)/iL
        gam=base.psi_im_array(omega/2)/2;correction=base.I(0);decay=decay0
        for j in range(32):
            b=base.I(4*j+1)/2;correction+=omega*decay/(b*b+omega*omega);decay*=q
        tail=iv.exp(-rat(F(129,2))*lo)/(129*(1-iv.exp(-2*lo)))
        assert bool(tail<rat(F(1,10**30)))
        gam=(gam-correction).widen(1e-30)
        pole=-2*omega*(ich-1)/(base.I(1)/4+omega*omega)
        primes=iW2*wide_sine(base.PI*base.I(ns)*iH2)+iW3*wide_sine(base.PI*base.I(ns)*iH3)
        return pole-gam+primes
    def diagonal(n):
        w=2*iv.pi*n/L;z=iv.mpc(rat(F(1,4)),w/2)
        gam=base.psi_iv(z).real-iv.ln(iv.pi)+base.psi_iv(z,True).real/(2*L)
        corr=iv.mpf(0)
        for j in range(32):
            b=rat(F(4*j+1,2));corr+=iv.exp(-b*L)*(1/iv.mpc(b,-w)**2).real
        gam-=2*corr/L
        rem=2/lo*iv.exp(-rat(F(129,2))*lo)/(rat(F(129,2))**2*(1-iv.exp(-2*lo)))
        gam+=iv.mpf([-rem.b,rem.b])
        ch=(iv.exp(L/2)+iv.exp(-L/2))/2
        pole=4*(ch-1)/L*(1/iv.mpc(rat(F(1,2)),w)**2).real
        primes=-w2*H2*iv.cos(iv.pi*n*H2)-w3*H3*iv.cos(iv.pi*n*H3)
        return gam+pole+primes
    def weight(n,odd=False):
        x=iv.mpf(n); n0=N+1
        if odd:
            pole_debt=iv.exp(hi/2)-iv.exp(-hi/2)-hi
            bound=iv.ln(x/hi)-2-(2*hi+1)/(iv.pi*n0)-hi/(2*iv.pi**2*n0**2)-debt-pole_debt
        else:
            bound=iv.ln(x/hi)-hi/(iv.pi*x)-debt
        v=floor_verified(bound)
        assert v>threshold
        return v
    ms=np.arange(N+1,M+1,dtype=np.int64);ns=np.arange(1,N+1,dtype=np.int64)
    sig=symbols(np.arange(1,M+1,dtype=np.int64))
    sm=base.I(sig.lo[N:,None],sig.hi[N:,None]);sn=base.I(sig.lo[:N][None,:],sig.hi[:N][None,:])
    mvec=base.I(ms[:,None]);nvec=base.I(ns[None,:]);den=base.PI*base.I(ms[:,None]**2-ns[None,:]**2)
    evenC=(2*nvec*sn-2*mvec*sm)/den
    ec0=-base.SQRT2*base.I(sig.lo[N:],sig.hi[N:])/(base.PI*base.I(ms))
    evenC=base.I(np.column_stack([ec0.lo,evenC.lo]),np.column_stack([ec0.hi,evenC.hi]))
    oddC=(2*mvec*sn-2*nvec*sm)/den
    weights=[];traces=[];errors=[];etas=[];shell_records=[]
    for sector,CI in enumerate((evenC,oddC)):
        dim=CI.lo.shape[1]; scaled=np.rint(CI.mid()*2**BITS)
        assert np.all(np.isfinite(scaled)) and np.max(abs(scaled))<2**53
        X=scaled.astype(np.int64);xx=np.ldexp(X.astype(float),-BITS)
        er=np.maximum(base.up(CI.hi-xx),base.up(xx-CI.lo))
        assert np.all(er>=0) and np.all(np.isfinite(er))
        radfloat=np.ceil(np.ldexp(er,RBITS))
        assert np.max(radfloat)<2**53
        radii=radfloat.astype(np.int64)
        assert np.all(np.ldexp(radii.astype(float),-RBITS)>=er)
        W=[[F(0) for _ in range(dim)] for _ in range(dim)]
        tr,ee=F(0),F(0);first=N+1;shells=[]
        while first<=M:
            last=min(2*(first-1),M);l,r=first-N-1,last-N
            gram=base.exact_gram(X[l:r])
            re=F(sum(int(v)*int(v) for v in radii[l:r].ravel()),2**(2*RBITS))
            gtr=F(sum(int(gram[i,i]) for i in range(dim)),2**(2*BITS))
            highfloor=weight(first,bool(sector));ww=1/(highfloor-threshold)
            tr+=ww*gtr;ee+=ww*re
            for i in range(dim):
                for j in range(dim):W[i][j]+=ww*F(int(gram[i,j]),2**(2*BITS))
            shells.append({'first':first,'last':last,'lower':str(highfloor)})
            first=last+1
        theta=THETA
        assert theta>0
        eta=(1+1/theta)*ee
        W=[[(1+theta)*x for x in row] for row in W]
        weights.append(W);traces.append(tr);errors.append(ee);etas.append(eta);shell_records.append(shells)
    print('parity Gram assembled; radii',list(map(str,etas)),flush=True)
    sy=[iv.mpf(0)]+[iv.mpf([float(x),float(y)]) for x,y in zip(sig.lo[:N],sig.hi[:N])]
    rt2=iv.sqrt(2); diagonals=[diagonal(n) for n in range(N+1)]
    A=[]
    even=[[iv.mpf(0) for _ in range(N+1)] for _ in range(N+1)]
    even[0][0]=diagonals[0]
    odd=[[iv.mpf(0) for _ in range(N)] for _ in range(N)]
    for n in range(1,N+1):
        even[n][0]=even[0][n]=-rt2*sy[n]/(iv.pi*n)
        even[n][n]=diagonals[n]-sy[n]/(iv.pi*n)
        odd[n-1][n-1]=diagonals[n]+sy[n]/(iv.pi*n)
        for m in range(1,n):
            den=iv.pi*(m*m-n*n)
            ev=2*(n*sy[n]-m*sy[m])/den
            od=2*(m*sy[n]-n*sy[m])/den
            even[m][n]=even[n][m]=ev
            odd[m-1][n-1]=odd[n-1][m-1]=od
    A=[even,odd]
    rem=F(2,10**12)
    assert bool(16*B*B*N**4*d/(iv.pi**2*(1-rat(F(N,M)))**2*M**5)<rat(rem))
    WW=[]
    for sector,W in enumerate(weights):
        dim=len(W);far=1/(weight(M+1,bool(sector))-threshold)
        if sector==0:
            first=[iv.mpf(1)]+[rt2 for _ in range(N)]
            second=[iv.mpf(0)]+[rt2*n*sy[n] for n in range(1,N+1)]
        else:
            first=[rt2*sy[n] for n in range(1,N+1)]
            second=[rt2*n for n in range(1,N+1)]
        mat=[[iv.mpf(0) for _ in range(dim)] for _ in range(dim)]
        for i in range(dim):
            for j in range(i+1):
                tail=8/iv.pi**2*((B*B if sector==0 else 1)*first[i]*first[j]/M+
                    (1 if sector==0 else B*B)*second[i]*second[j]/M**3)
                entry=rat(W[i][j])+rat(far)*tail
                if i==j:entry+=rat(etas[sector]+far*rem)
                mat[i][j]=mat[j][i]=entry
        WW.append(mat)
    vv=[iv.mpf(base.CANDIDATE[N])/2**40]+[rt2*base.CANDIDATE[N+n]/2**40 for n in range(1,N+1)]
    exact_norm=F(sum(s*s for s in base.CANDIDATE),2**80)
    ray=sum((vv[i]*even[i][j]*vv[j] for i in range(N+1) for j in range(N+1)),iv.mpf(0))/rat(exact_norm)
    print('ray',ray,flush=True);assert bool(ray<rat(upper))
    piv={}
    for sector in (0,1):
        dim=len(A[sector]);matrix=[[A[sector][i][j]-WW[sector][i][j]+(vv[i]*vv[j] if not sector else 0)-
            (rat(threshold) if i==j else 0) for j in range(dim)] for i in range(dim)]
        piv['even_complement' if not sector else 'odd_full']=congruence_ldl(matrix)
        print('piv',piv,flush=True)
    assert upper<threshold
    return {'step':str(step),'length_interval':str(L),'even_odd_Gamma_high_lower_at_65':[str(weight(65,False)),str(weight(65,True))],
       'N':N,'M':M,'interval_decimal_digits':digits,'parity_shells':shell_records,'weighted_Gram_error_budgets':list(map(str,etas)),
       'candidate_rayleigh_interval':str(ray),'candidate_upper':str(upper),'candidate_orthogonal_threshold':str(threshold),
       'spectral_gap_lower':str(threshold-upper),
       'candidate_squared_norm_exact':str(exact_norm),
       'active_overlap_2':str(H2),'active_overlap_3':str(H3),
       'symbol_reference_intervals':{str(n):str(sy[n]) for n in (1,2,8,64)},
       'diagonal_reference_intervals':{str(n):str(diagonals[n]) for n in (0,1,2,8,64)},
       'far_second_jet_remainder_upper':str(rem),
       'gram_Young_parameter':str(THETA),
       'midpoint_Gram_multiplier':str(1+THETA),
       'weighted_radius_energy':list(map(str,errors)),
       'weighted_midpoint_trace':list(map(str,traces)),
       'python':platform.python_version(),'numpy':np.__version__,
       'method':'One interval covers every half-width; no sampled eigenvalues. Float Cholesky only proposes dyadic congruences, which are independently checked by directed products and strict LDL.',
       'inherited_numerical_gap':False,
       'pivot_displays':piv,'base_sha256':PIN,'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
       'status':'All interval matrices, all-mode weighted tails and final strict LDL guards passed.',
       'scope':'One full parameter interval, including prime-3 activation. Paper operator/domain and logarithmic/Neumann high-space estimates are inherited analytically; no historical numeric spectral result is assumed. Not a Lean/kernel result, all-scale gap, or Xi limit.'}

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--digits',type=int,default=70)
    parser.add_argument('--step',type=F,default=F(1,5*10**7))
    args=parser.parse_args()
    result=run(step=args.step,digits=args.digits)
    suffix='' if args.digits==70 else '_'+str(args.digits)
    (ROOT/('prime3_scale_interval_certificate'+suffix+'.json')).write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2),flush=True)
