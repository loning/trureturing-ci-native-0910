"""Uniform full-space Schur certificate across the prime-3 activation.

The Fourier candidate is transported by the unitary change of interval.
A length interval enters every matrix and coupling evaluation, not a mesh of
sampled scales. Spectral conclusions also use the documented Fourier/core
identification and high-complement bound. This is not a Lean-kernel proof.
"""
from __future__ import annotations
from fractions import Fraction as F
from pathlib import Path
import hashlib,json,math,platform,sys,time
import numpy as np
from mpmath import iv
if not __debug__:
    raise RuntimeError('Assertions are required; do not use -O.')
ROOT = Path(__file__).resolve().parent
BASE_SHA = '8bb067fc5499b0f2e1e48836e7a82237a15504109f82a856c72478d1096d69d0'
if hashlib.sha256((ROOT / 'certify_prime3_refined.py').read_bytes()).hexdigest() != BASE_SHA:
    raise ValueError('Unreviewed arithmetic dependency.')
import certify_prime3_refined as base
def rat(x):
 x=F(x);return iv.mpf(x.numerator)/x.denominator
def exact_endpoint_sum(xs):
 return sum((F.from_float(float(x)) for x in np.asarray(xs).ravel()),F(0))
def verified_congruence(A, label):
 # A floating eigensolver proposes a dyadic coordinate change ONLY. The final
 # decision below uses exact Python-integer products and Gershgorin bounds on
 # R^T A R. Positive definiteness of that square congruence also proves R is
 # invertible. No computed floating eigenvalue is a certificate premise.
 n=len(A);bits=44;r_bits=32
 mids=np.array([[float(x.mid) for x in row] for row in A])
 vals,vecs=np.linalg.eigh(mids)
 print(label,'proposal least eigenvalue',vals[0],flush=True)
 if vals[0]<=0:raise ArithmeticError('No positive midpoint proposal')
 proposed=(vecs/np.sqrt(vals)[None,:])*2**r_bits
 assert np.all(np.isfinite(proposed)) and np.max(abs(proposed))<2**53
 RR=np.rint(proposed).astype(np.int64).astype(object)
 Y=np.empty((n,n),dtype=object);E=np.empty((n,n),dtype=object)
 for i in range(n):
  for j in range(n):
   center=int(round(float(A[i][j].mid)*2**bits))
   delta=A[i][j]-rat(F(center,2**bits))
   q=int(math.ceil(float(abs(delta).b)*2**bits))+2
   assert bool(abs(delta)<rat(F(q,2**bits)))
   Y[i,j]=center;E[i,j]=q
 assert np.array_equal(Y,Y.T) and np.array_equal(E,E.T)
 Z=RR.T@Y@RR;ER=abs(RR).T@E@abs(RR)
 margins=[int(Z[i,i]-ER[i,i]-sum(abs(Z[i,j])+ER[i,j] for j in range(n) if j!=i)) for i in range(n)]
 floor=F(min(margins),2**(bits+2*r_bits))
 print(label,'verified Gershgorin lower',float(floor),flush=True)
 if floor<=0:raise ArithmeticError(label+': congruence failed')
 return {'rational_Gershgorin_lower':str(floor),'congruence_sha256':hashlib.sha256(json.dumps(RR.tolist(),separators=(',',':')).encode()).hexdigest(),'quantization_bits':bits,'congruence_bits':r_bits}
def run(digits: int = 90, radius: F = F(1,10**8), N: int = 128, M: int = 8192) -> dict:
 if not 80 <= digits <= 200 or radius != F(1,10**8) or N != 128 or M != 8192:
  raise ValueError('Use 80..200 digits and the fixed reviewed radius/dimensions.')
 if hashlib.sha256(Path(base.__file__).read_bytes()).hexdigest()!=BASE_SHA:raise ValueError('Unreviewed arithmetic dependency.')
 iv.dps=digits;L0=iv.ln(3);R=rat(radius);L=L0+iv.mpf([-2*R.b,2*R.b]);a=L/2
 assert bool(iv.ln(2)<L) and bool(L<iv.ln(4)) and bool(a<iv.ln(2))
 log2,log3=iv.ln(2),iv.ln(3);w2=log2/iv.sqrt(2);w3=log3/iv.sqrt(3)
 LI=base.outer_iv(L);P=base.outer_iv(iv.pi);l2=base.outer_iv(log2);l3=base.outer_iv(log3)
 W2=base.outer_iv(w2);W3=base.outer_iv(w3);I=base.I
 def syms(ns):
  ns=np.asarray(ns,dtype=np.int64);w=2*P*I(ns)/LI
  g=base.psi_im_array(w/2)/2;decay=base.outer_iv(iv.exp(-L/2));q=base.outer_iv(iv.exp(-2*L));cor=I(np.zeros(len(ns)))
  for j in range(48):
   bj=I(4*j+1)/2;cor=cor+w*decay/(bj*bj+w*w);decay=decay*q
  tail=iv.exp(-L/2)*iv.exp(-2*L)**48/(1-iv.exp(-2*L));assert bool(tail<rat(F(1,10**44)))
  g=(g-cor).widen(1e-44);ch=base.outer_iv((iv.exp(L/2)+iv.exp(-L/2))/2)
  pole=-2*w*(ch-1)/(I(1)/4+w*w);p2=-W2*base.sin_interval(w*l2)
  # Prime 3 is absent on the left side and present on the right side.
  # The hull includes both, and its actual lattice sine vanishes at activation.
  p3=-W3*base.sin_interval(w*l3)
  p3=I(np.minimum(p3.lo,0),np.maximum(p3.hi,0))
  return pole-g+p2+p3
 def diag(n):
  w=2*iv.pi*n/L;z=iv.mpc(rat(F(1,4)),w/2)
  g=base.psi_iv(z).real-iv.ln(iv.pi)+base.psi_iv(z,True).real/(2*L);cor=iv.mpf(0)
  for j in range(48):
   bj=rat(F(4*j+1,2));cor+=iv.exp(-bj*L)*(1/iv.mpc(bj,-w)**2).real
  tail=2/L*iv.exp(-rat(F(193,2))*L)/(rat(F(193,2))**2*(1-iv.exp(-2*L)))
  g=g-2/L*cor+iv.mpf([-tail.b,tail.b]);ch=(iv.exp(L/2)+iv.exp(-L/2))/2
  po=4*(ch-1)/L*(1/iv.mpc(rat(F(1,2)),w)**2).real
  p2=-2*w2*(1-log2/L)*iv.cos(w*log2)
  # Unlike the sine column, the diagonal contains the overlap fraction.
  # Its positive part is exact, including zero at the activation threshold.
  ol=1-log3/L
  overlap=iv.mpf([max(0,base.down(float(ol.a))),max(0,base.up(float(ol.b)))])
  return g+po+p2-2*w3*overlap*iv.cos(w*log3)
 eps=4/(3*iv.pi**2);freq=iv.pi*N/(2*L);g0=-iv.euler-iv.pi/2-3*iv.ln(2)-iv.ln(iv.pi)
 freqlo=iv.mpf(freq.a);inc=sum((2*freqlo**2/(rat(F(4*j+1,2))*(rat(F(4*j+1,2))**2+freqlo**2)) for j in range(2048)),iv.mpf(0))
 debt=2*((iv.exp(a)-iv.exp(-a))/2-a);beta=g0+(1-eps)*inc-w2-w3-debt
 assert bool(beta>1),str(beta)
 assert bool(2*((iv.exp(a)+iv.exp(-a))/2)+w2+w3<4)
 beta_floor=F(1);threshold=F(1,200000);upper=F(1,1000000)
 ns=np.arange(-N,N+1,dtype=np.int64);ms=np.arange(N+1,M+1,dtype=np.int64);d=len(ns)
 begin=time.time();sig=syms(np.arange(1,M+1));slo=np.r_[-sig.hi[:N][::-1],0,sig.lo[:N]];shi=np.r_[-sig.lo[:N][::-1],0,sig.hi[:N]]
 C=(I(slo[None,:],shi[None,:])-I(sig.lo[N:,None],sig.hi[N:,None]))/(P*I(ms[:,None]-ns[None,:]))
 bits=40;scaled=np.rint(C.mid()*2**bits);assert np.all(np.isfinite(scaled)) and np.max(abs(scaled))<2**53
 X=scaled.astype(np.int64);exactx=np.ldexp(X.astype(float),-bits)
 err=np.maximum(base.up(C.hi-exactx),base.up(exactx-C.lo));assert np.all(err>=0) and np.all(np.isfinite(err))
 # Exact summation of binary-rational upward endpoints bounds the COMPLETE
 # two-sided Frobenius error, uniformly over all lengths in the interval.
 e2=2*exact_endpoint_sum(base.up(err*err))
 posG=base.exact_gram(X)
 G=posG+posG[::-1,::-1]
 # Young's inequality preserves the exact midpoint Gram directionality:
 # C^*C <= (1+theta) D^*D + (1+1/theta)||C-D||_F^2 I.
 # Replacing this by a linear-in-radius scalar norm loses the narrow gap.
 theta=F(1,20)
 eta=rat((1+1/theta)*e2)
 print('Gram seconds',round(time.time()-begin,2),'eta',str(eta),'beta',str(beta),flush=True)
 sy=[iv.mpf([float(slo[i]),float(shi[i])]) for i in range(d)]
 A=[[iv.mpf(0) for _ in range(d)] for _ in range(d)];GG=[[iv.mpf(0) for _ in range(d)] for _ in range(d)]
 rem=16*16*N**4*d/(iv.pi**2*(1-rat(F(N,M)))**2*M**5)
 for i,n in enumerate(ns):
  A[i][i]=diag(int(n))
  for j in range(i):A[i][j]=A[j][i]=(sy[i]-sy[j])/(iv.pi*int(ns[j]-n))
  for j in range(i+1):
   tail=8/iv.pi**2*((16+sy[i]*sy[j])/M+int(ns[i])*int(ns[j])*(16+sy[i]*sy[j])/M**3)
   term=rat((1+theta)*F(int(G[i,j]),2**(2*bits)))+tail
   if i==j:term+=eta+rem
   GG[i][j]=GG[j][i]=term
 assert len(base.CANDIDATE) == 129
 assert base.CANDIDATE == tuple(reversed(base.CANDIDATE))
 ck=[iv.mpf(0) for _ in range(d)]
 for j,s in enumerate(base.CANDIDATE):ck[N-64+j]=iv.mpf(s)/2**40
 cn=sum((x*x for x in ck),iv.mpf(0))
 assert bool(cn > 0)
 ray=sum((ck[i]*A[i][j]*ck[j] for i in range(d) for j in range(d)),iv.mpf(0))/cn
 print('ray interval',str(ray),flush=True);assert bool(ray<rat(upper)),str(ray)
 raised=[[A[i][j]-GG[i][j]/rat(beta_floor-threshold)+ck[i]*ck[j]-(rat(threshold) if i==j else 0) for j in range(d)] for i in range(d)]
 even=[[(N,1)]]+[[(N+j,1),(N-j,1)] for j in range(1,N+1)];odd=[[(N+j,1),(N-j,-1)] for j in range(1,N+1)]
 def block(basis):return [[sum((sx*sy*raised[i][j] for i,sx in x for j,sy in y),iv.mpf(0)) for y in basis] for x in basis]
 p1=verified_congruence(block(even),'even')
 p2=verified_congruence(block(odd),'odd')
 report={'radius_a':str(radius),'log_length_interval':str(L),'N':N,'M':M,'interval_digits':digits,'beta_lower_enclosure':str(beta),'high_floor':str(beta_floor),'complement_threshold':str(threshold),'candidate_upper':str(upper),'rayleigh_interval':str(ray),'gram_radius':str(eta),'far_jet_remainder':str(rem),'even_congruence':p1,'odd_congruence':p2,'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'base_sha256':BASE_SHA, 'uniform_gap_lower': str(threshold-upper),
 'prime3_overlap_interval': str(iv.mpf([0, (1-log3/L).b])),
 'gram_error_frobenius_squared_upper':str(e2),'gram_Young_parameter':str(theta),
 'near_Gram_integer_sha256':hashlib.sha256(json.dumps(G.tolist(),separators=(',',':')).encode()).hexdigest(),
 'python':platform.python_version(),'numpy':np.__version__,
 'status':'All uniform parameter, full-tail Schur and exact integer congruence checks passed.',
 'conclusion':'For every |a-log(3)/2|<=1e-8, the original candidate-orthogonal form is at least 1/200000, its candidate Rayleigh value is below 1/1000000, and the actual ground is simple and even with spectral gap at least 1/250000.',
 'scope':'Uniform-in-parameter computer-assisted spectral theorem with the documented original Fourier/core, infinite-coupling and high-complement analytic bridges. No old spectral JSON is used as a hypothesis; the old arithmetic source is reused. Floating eigensolvers propose coordinates only; exact integer congruence decides positivity. Lean/Scribe are not executed. No full Weil positivity, new prolate approximation rate, or unbounded-scale Xi limit is claimed.' }
 return report
if __name__ == '__main__':
    digits = int(sys.argv[1]) if len(sys.argv) > 1 else 90
    report = run(digits=digits)
    suffix = '' if digits == 90 else '_' + str(digits)
    target = ROOT / ('prime3_scale_schur_certificate' + suffix + '.json')
    target.write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(report, indent=2), flush=True)
