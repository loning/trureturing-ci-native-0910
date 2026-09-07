"""Full-exterior even-sector Schur certificate across prime-three activation.

Arithmetic formulas and the complete high/near/far Schur construction follow
certify_prime3_scale_schur.py in PR #5602 at
5b1c54e84706acdca64e2ec042b51a5d52c5fcea. This independent consumer tests the
stronger threshold 1/1000 ONLY on the even candidate-orthogonal subspace.
It does not claim the odd or entire candidate complement has that threshold.

The interval length covers every |a-log(3)/2|<=1e-8. Floating eigenvalues
only propose congruence coordinates. Final positivity is exact integer
Gershgorin after outward interval quantization; every exterior Fourier mode
is charged. The original Fourier/core, Gamma high-complement and associated
operator realization remain paper analytic inputs, not a Lean kernel verdict.

Only the inspected arithmetic primitives of the old owner are executed through
its AST-pinned loader. No upstream full-file hash or spectral rerun is inferred
from that projection. The complete local input byte hash is reported separately.
"""
from fractions import Fraction as F
from pathlib import Path
import importlib.util, json, math, hashlib, sys, time
import numpy as np
from mpmath import iv
PRIOR_SHA='35c4376cf0638a9aa1dff5b69d042f0191e103d6c9fb941efc5d83f2a1302eea'

def load_arithmetic(prior_checker, arithmetic_source):
 req(__debug__, '-O would disable inherited arithmetic assertions')
 req(hashlib.sha256(prior_checker.read_bytes()).hexdigest()==PRIOR_SHA,
     'Changed inspected residual arithmetic loader')
 sp=importlib.util.spec_from_file_location('owned_residual_loader',prior_checker)
 req(sp is not None and sp.loader is not None, 'Missing owned arithmetic loader')
 old=importlib.util.module_from_spec(sp);sp.loader.exec_module(old)
 return old, old.load_arithmetic(arithmetic_source)

def Q(x):
 x=F(x);return iv.mpf(x.numerator)/x.denominator
def req(h,msg):
 if not bool(h):raise ArithmeticError(msg)
def exact_gram(X):
 req(X.ndim==2 and X.shape[0]>0 and X.shape[1]>0 and X.dtype==np.int64, 'Expected nonempty int64 matrix')
 req(np.all(X>-(2**53)) and np.all(X<2**53), 'Exact binary conversion range')
 radix=2**20;lo=X%radix;hi=X//radix
 for U,V in ((lo,lo),(hi,lo),(hi,hi)):
  req(len(X)*int(np.max(abs(U)))*int(np.max(abs(V)))<2**63,'Gram int64 overflow')
 ll=lo.T@lo;hl=hi.T@lo;hh=hi.T@hi
 return ll.astype(object)+radix*(hl.astype(object)+hl.T.astype(object))+radix**2*hh.astype(object)
def congruence(A):
 n=len(A);bits=44;rb=32;mids=np.array([[float(x.mid) for x in row] for row in A]);vals,vecs=np.linalg.eigh(mids)
 print('even proposal least eigenvalue',vals[0],flush=True);req(vals[0]>0,'No positive proposal')
 proposed=vecs/np.sqrt(vals)[None,:]*2**rb;req(np.max(abs(proposed))<2**53 and np.all(np.isfinite(proposed)),'Bad proposal')
 R=np.rint(proposed).astype(np.int64).astype(object);Y=np.empty((n,n),object);E=np.empty((n,n),object)
 for i in range(n):
  for j in range(n):
   mid=int(round(float(A[i][j].mid)*2**bits));delta=A[i][j]-Q(F(mid,2**bits));rad=int(math.ceil(float(abs(delta).b)*2**bits))+2
   req(abs(delta)<Q(F(rad,2**bits)),'Quantization radius');Y[i,j]=mid;E[i,j]=rad
 req(np.array_equal(Y,Y.T) and np.array_equal(E,E.T),'Symmetry')
 Z=R.T@Y@R;ER=abs(R).T@E@abs(R)
 margins=[int(Z[i,i]-ER[i,i]-sum(abs(Z[i,j])+ER[i,j] for j in range(n) if j!=i)) for i in range(n)]
 floor=F(min(margins),2**(bits+2*rb));req(floor>0,'Exact congruence failed')
 return {'margin':str(floor),'dimension':n,'matrix_quantization_bits':bits,'congruence_bits':rb,'congruence_sha256':hashlib.sha256(json.dumps(R.tolist(),separators=(',',':')).encode()).hexdigest()}
def run(prior_checker, arithmetic_source, digits=90):
 req(80<=digits<=160, 'Require 80..160 interval digits')
 old,base=load_arithmetic(prior_checker,arithmetic_source)
 T=F(1,1000);radius=F(1,10**8)
 iv.dps=digits;N=128;M=8192
 L=iv.ln(3)+iv.mpf([-2*Q(radius).b,2*Q(radius).b]);a=L/2
 req(iv.ln(2)<L and L<iv.ln(4) and a<iv.ln(2),'Prime regime')
 log2,log3=iv.ln(2),iv.ln(3);w2=log2/iv.sqrt(2);w3=log3/iv.sqrt(3)
 I=base.I;LI=base.outer_iv(L);PI=base.outer_iv(iv.pi);l2=base.outer_iv(log2);l3=base.outer_iv(log3);W2=base.outer_iv(w2);W3=base.outer_iv(w3)
 def syms(ns):
  w=2*PI*I(ns)/LI;gam=base.psi_im_array(w/2)/2;decay=base.outer_iv(iv.exp(-L/2));q=base.outer_iv(iv.exp(-2*L));cor=I(np.zeros(len(ns)))
  for j in range(48):
   bj=I(4*j+1)/2;cor=cor+w*decay/(bj*bj+w*w);decay=decay*q
  tail=iv.exp(-L/2)*iv.exp(-2*L)**48/(1-iv.exp(-2*L));req(tail<Q(F(1,10**44)),'Gamma symbol tail')
  gam=(gam-cor).widen(1e-44);ch=base.outer_iv((iv.exp(L/2)+iv.exp(-L/2))/2)
  pole=-2*w*(ch-1)/(I(1)/4+w*w);p2=-W2*base.sin_interval(w*l2);p3=-W3*base.sin_interval(w*l3)
  return pole-gam+p2+I(np.minimum(p3.lo,0),np.maximum(p3.hi,0))
 def diag(n):
  w=2*iv.pi*n/L;z=iv.mpc(Q(F(1,4)),w/2)
  gam=base.psi_iv(z).real-iv.ln(iv.pi)+base.psi_iv(z,True).real/(2*L);cor=iv.mpf(0)
  for j in range(48):
   bj=Q(F(4*j+1,2));cor+=iv.exp(-bj*L)*(1/iv.mpc(bj,-w)**2).real
  tail=2/L*iv.exp(-Q(F(193,2))*L)/(Q(F(193,2))**2*(1-iv.exp(-2*L)))
  gam=gam-2/L*cor+iv.mpf([-tail.b,tail.b]);ch=(iv.exp(L/2)+iv.exp(-L/2))/2
  pole=4*(ch-1)/L*(1/iv.mpc(Q(F(1,2)),w)**2).real;p2=-2*w2*(1-log2/L)*iv.cos(w*log2)
  ol=1-log3/L;overlap=iv.mpf([max(0,base.down(float(ol.a))),max(0,base.up(float(ol.b)))])
  return gam+pole+p2-2*w3*overlap*iv.cos(w*log3)
 epsilon=4/(3*iv.pi**2);flo=iv.mpf((iv.pi*N/(2*L)).a);gam0=-iv.euler-iv.pi/2-3*iv.ln(2)-iv.ln(iv.pi)
 inc=sum((2*flo**2/(Q(F(4*j+1,2))*(Q(F(4*j+1,2))**2+flo**2)) for j in range(2048)),iv.mpf(0))
 beta=gam0+(1-epsilon)*inc-w2-w3-2*((iv.exp(a)-iv.exp(-a))/2-a)
 req(beta>1,'Full high-complement floor');req(2*((iv.exp(a)+iv.exp(-a))/2)+w2+w3<4,'Symbol cap')
 ns=np.arange(-N,N+1,dtype=np.int64);ms=np.arange(N+1,M+1,dtype=np.int64);d=len(ns);sig=syms(np.arange(1,M+1))
 slo=np.r_[-sig.hi[:N][::-1],0,sig.lo[:N]];shi=np.r_[-sig.lo[:N][::-1],0,sig.hi[:N]]
 C=(I(slo[None,:],shi[None,:])-I(sig.lo[N:,None],sig.hi[N:,None]))/(PI*I(ms[:,None]-ns[None,:]))
 bits=40;scaled=np.rint(C.mid()*2**bits);req(np.all(np.isfinite(scaled)) and np.max(abs(scaled))<2**53,'Unsafe rounding');X=scaled.astype(np.int64)
 exactx=np.ldexp(X.astype(float),-bits);err=np.maximum(base.up(C.hi-exactx),base.up(exactx-C.lo));req(np.all(np.isfinite(err)) and np.all(err>=0),'Error sign or nonfinite bound')
 e2=2*sum((F.from_float(float(x)) for x in base.up(err*err).ravel()),F(0))
 Gpos=exact_gram(X);G=Gpos+Gpos[::-1,::-1];theta=F(1,20);eta=Q((1+1/theta)*e2)
 sy=[iv.mpf([float(slo[i]),float(shi[i])]) for i in range(d)]
 A=[[iv.mpf(0) for _ in range(d)] for _ in range(d)];GG=[[iv.mpf(0) for _ in range(d)] for _ in range(d)]
 rem=16*16*N**4*d/(iv.pi**2*(1-Q(F(N,M)))**2*M**5)
 for i,n in enumerate(ns):
  A[i][i]=diag(int(n))
  for j in range(i):A[i][j]=A[j][i]=(sy[i]-sy[j])/(iv.pi*int(ns[j]-n))
  for j in range(i+1):
   tail=8/iv.pi**2*((16+sy[i]*sy[j])/M+int(ns[i])*int(ns[j])*(16+sy[i]*sy[j])/M**3)
   term=Q((1+theta)*F(int(G[i,j]),2**(2*bits)))+tail
   if i==j:term+=eta+rem
   GG[i][j]=GG[j][i]=term
 ck=[iv.mpf(0) for _ in range(d)]
 for j,s in enumerate(base.CANDIDATE):ck[N-64+j]=iv.mpf(s)/2**40
 cn=sum((x*x for x in ck),iv.mpf(0));ray=sum((ck[i]*A[i][j]*ck[j] for i in range(d) for j in range(d)),iv.mpf(0))/cn
 raised=[[A[i][j]-GG[i][j]/Q(1-T)+ck[i]*ck[j]-(Q(T) if i==j else 0) for j in range(d)] for i in range(d)]
 even=[[(N,1)]]+[[(N+j,1),(N-j,1)] for j in range(1,N+1)]
 block=[[sum((si*sj*raised[i][j] for i,si in x for j,sj in y),iv.mpf(0)) for y in even] for x in even]
 cert=congruence(block)
 return {
  'status':'All whole-interval, full-exterior even-sector congruence guards passed',
  'a_center':'log(3)/2','a_radius':str(radius),'even_candidate_complement_threshold':str(T),
  'N':N,'M':M,'digits':digits,'numpy':np.__version__,
  'full_high_complement_floor':old.enclosure(beta),
  'candidate_rayleigh_interval':old.enclosure(ray),
  'two_sided_Gram_Frobenius_error_sq':str(e2),
  'far_second_jet_remainder':old.enclosure(rem),
  'even_congruence':cert,'arithmetic_primitive_AST_sha256':old.PRIMITIVE_AST_HASH,
  'prior_loader_sha256':PRIOR_SHA,
  'complete_local_arithmetic_input_sha256':hashlib.sha256(arithmetic_source.read_bytes()).hexdigest(),
  'checker_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
  'input_scope':'Only the inspected arithmetic primitive projection is executed. The complete local input hash is not attestation of the full upstream owner file.',
  'conclusion':'For every |a-log(3)/2|<=1/100000000 and every even candidate-orthogonal form-domain vector, q_a(f)>=||f||^2/1000, under the stated analytic Fourier/core/high-complement identifications.',
  'analytic_premises':[
    'Original real arithmetic Fourier matrix, complete coupling and high-complement Gamma lower bound',
    'Fourier core density and associated closed-form realization on the actual physical window',
    'Spatial reflection is an invariant form/domain involution; complex vectors follow from real symmetric congruence'],
  'not_claimed':['The full or odd candidate complement has threshold 1/1000',
    'A global shifted lower bound uniformly on this interval',
    'Additional physical scales beyond this stated interval',
    'Unbounded-scale genuine-mode/prolate convergence','Lean or Scribe compilation']}

if __name__=='__main__':
 import argparse
 root=Path(__file__).resolve().parent
 parser=argparse.ArgumentParser(description=__doc__)
 parser.add_argument('--prior-checker',type=Path,default=root/'certify_prime3_full_residual.py')
 parser.add_argument('--arithmetic-source',type=Path,default=root/'certify_prime3_refined.py')
 parser.add_argument('--digits',type=int,default=90)
 parser.add_argument('--output',type=Path,default=root/'prime3_even_sector_certificate.json')
 args=parser.parse_args()
 out=run(args.prior_checker,args.arithmetic_source,args.digits)
 args.output.write_text(json.dumps(out,indent=2)+'\n')
 print(json.dumps(out,indent=2))
