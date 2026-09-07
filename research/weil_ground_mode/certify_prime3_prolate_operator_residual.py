"""Certify the complete operator residual of the genuine c=3 prolate model.

The input modes are first checked by the pinned infinite-prolate and full-form
verifier. Actual Gamma images, including their nonzero atom-exterior pieces,
are combined with prime, pole and Rayleigh terms before squaring. Interior
cells use directed Taylor coefficients plus a complex-disc Cauchy remainder;
all omitted endpoint strips have explicit logarithmic-square integrals.
A piecewise-C1/jump estimate controls the *operator graph norm* error of the
true prolate model. Plain L2 continuity of the unbounded operator is not used.

The gamma-kernel realization, graph-norm estimate and Cauchy integration
argument are proved on paper in RH_RESEARCH_LANE_THEORY.md. The endpoint
logarithmic envelope has a companion Lean proof script. This Python program
and its numerical interval implementation are not Lean-kernel verified.
"""
from __future__ import annotations
from fractions import Fraction as F
from pathlib import Path
import hashlib
import importlib.util
import json
import platform
import sys
import time
from mpmath import iv

if not __debug__:
    raise RuntimeError('Assertions are part of this verifier; do not use -O.')
ROOT=Path(__file__).resolve().parent
PINS={
 'certify_prime3_prolate_weil_energy.py':'d48dd32752a76edff93331cee6825d12e6c67fe46aa811e48e11b05ab96f646b',
 'certify_prime3_prolate_model.py':'42dceb5c81f9aabdc12b51a99d29f0929d81e712f815b49b13bbf9bb5ec56039',
 'prime3_prolate_proposal.json':'242c9897bbd247ef0485039e6dcde819a351c5900ceac52fecc420934c1896db',
 'certify_prime3_refined.py':'8bb067fc5499b0f2e1e48836e7a82237a15504109f82a856c72478d1096d69d0',
}

def checked_import(name,filename):
    spec=importlib.util.spec_from_file_location(name,ROOT/filename)
    if spec is None or spec.loader is None: raise ImportError(filename)
    module=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

# Only finite exact Legendre coefficients are used here; the spectral check
# is rerun in run(), and every mathematical input is hash-pinned first.
def legendre_coefficients(n):
    from math import factorial
    result=[F(0)]*(n+1)
    for k in range(n//2+1):
        result[n-2*k]=F((-1)**k*factorial(2*n-2*k),
            2**n*factorial(k)*factorial(n-k)*factorial(n-2*k))
    return result

def make_model(C=iv):
    def rat(x):
        x=F(x);return C.mpf(x.numerator)/x.denominator
    data=json.loads((ROOT/'prime3_prolate_proposal.json').read_bytes())
    K,bits=data['dimension'],data['dyadic_bits']
    assert (data['scale_c'],K,bits)==(3,32,250)
    assert [p['even_index'] for p in data['proposals']]==[0,2]
    v=[]
    for prop in data['proposals']:
        nums=[int(n) for n in prop['vector_numerators']]
        assert len(nums)==K
        ns=sum((F(n*n,2**(2*bits)) for n in nums),F(0))
        assert ns>0
        nn=C.sqrt(rat(ns))
        v.append([rat(F(n,2**bits))/nn for n in nums])
    assert bool(v[0][0]>0)
    ratio=v[1][0]/v[0][0]
    H=[y-ratio*x for x,y in zip(*v)];H[0]=rat(0)
    A=[rat(0) for _ in range(K)]
    for j in range(1,K):
        poly=legendre_coefficients(2*j);z=H[j]*C.sqrt(rat(F(4*j+1,2)))
        for r in range(j+1): A[r]+=z*rat(poly[2*r])/3**r
    a=C.ln(3)/2;L=2*a;h=C.ln(2);b=a-h
    c0=-C.euler-C.ln(2*C.pi)
    def add(d,k,x):d[k]=d.get(k,rat(0))+x
    def even(plus,minus):
        d={}
        for j,ar in enumerate(A):
            t=F(4*j+1,2)
            d[t]=2*ar*sum(m**(2*j) for m in plus)
            d[-t]=2*ar*sum(m**(2*j) for m in minus)
        return d
    E=[even((1,2),(1,)),even((1,),(1,)),even((1,),(1,2))]
    bounds=[(-a,b),(b,-b),(-b,a)]
    def powerint(t,l,r):
        return r-l if t==0 else (C.exp(rat(t)*r)-C.exp(rat(t)*l))/rat(t)
    pn=sum((co*(powerint(t+F(1,2),l,r)+powerint(t-F(1,2),l,r))/2
            for (l,r),ee in zip(bounds,E) for t,co in ee.items()),rat(0))
    norm2=sum((ar*br*powerint(t+s,l,r) for (l,r),ee in zip(bounds,E)
               for t,ar in ee.items() for s,br in ee.items()),rat(0))
    mu=rat(F(5949113595,10**17))
    def gamma(active):
        sm={};lin={};logs={}
        def log(anchor,sgn,s,t,z):
            key=(anchor,sgn,s)
            if key not in logs: logs[key]={}
            add(logs[key],t,z)
        for m in (1,2):
            up=a-C.ln(m)
            for r,ar in enumerate(A):
                t=F(4*r+1,2);z=4*ar*m**(2*r)
                log('left',-1,-1,t,z/2);log('left',-1,1,t,-z/2)
                for j in range(1,r+1):add(sm,t-(2*j-1),-z*C.exp(-(2*j-1)*a)/(2*j-1))
                if m in active:
                    Hs=sum((rat(F(1,2*j))+rat(F(1,2*j-1)) for j in range(1,r+1)),rat(0))
                    add(sm,t,z*(c0-up+Hs));add(lin,t,z)
                    for j in range(1,r+1):add(sm,t-2*j,-z*C.exp(2*j*up)/(2*j))
                    log('upper'+str(m),1,-1,t,-z/2);log('upper'+str(m),1,1,t,-z/2)
                else:
                    for j in range(1,r+1):add(sm,t-(2*j-1),z*C.exp((2*j-1)*up)/(2*j-1))
                    log('upper'+str(m),-1,-1,t,-z/2);log('upper'+str(m),-1,1,t,z/2)
        anchors={'left':(-1,0),'upper1':(1,0),'upper2':(1,-1)}
        return sm,lin,[(anchors[k[0]],k[1],k[2],d) for k,d in logs.items()]
    G=[gamma((1,2)),gamma((1,)),gamma((1,))]
    pieces=[]
    for i in range(3):
        sm={};lin={};logs=[]
        for refl,g in [(False,G[i]),(True,G[2-i])]:
            for t,ar in g[0].items():add(sm,-t if refl else t,ar/2)
            for t,ar in g[1].items():add(lin,-t if refl else t,(-ar if refl else ar)/2)
            for anchor,sgn,s,d in g[2]:
                logs.append((tuple(-j for j in anchor) if refl else anchor,-sgn if refl else sgn,s,
                             {(-t if refl else t):ar/2 for t,ar in d.items()}))
        # Combine identical logarithms by a symbolic key, with interval anchors
        # compared by their discrete list identity later, not numerical equality.
        V=C.ln(2)/C.sqrt(2)
        if i==0:
            for t,ar in E[2].items():add(sm,t,-V*ar*C.exp(rat(t)*h))
        if i==2:
            for t,ar in E[0].items():add(sm,t,-V*ar*C.exp(-rat(t)*h))
        add(sm,F(1,2),pn);add(sm,F(-1,2),pn)
        for t,ar in E[i].items():add(sm,t,-mu*ar)
        grouped={}
        for anchor,sgn,ss,dct in logs:
            key=(anchor,sgn,ss)
            if key not in grouped:grouped[key]={}
            for t,ar in dct.items():add(grouped[key],t,ar)
        logs=[(anchor,sgn,ss,dct) for (anchor,sgn,ss),dct in grouped.items()]
        pieces.append((sm,lin,logs))
    return {'pieces':pieces,'bounds':bounds,'norm2':norm2,'poleint':pn,'mu':mu,'a':a,'L':L,'A':A,'ratio':ratio}

def value(piece,x,C=iv):
    sm,lin,logs=piece
    def ee(d):return sum((ar*C.exp((C.mpf(t.numerator)/t.denominator)*x) for t,ar in d.items()),C.mpf(0))
    res=ee(sm)+x*ee(lin)
    for anchor,sgn,s,d in logs:
        aval=anchor[0]*C.ln(3)/2+anchor[1]*C.ln(2)
        res+=ee(d)*C.ln(1-s*C.exp(sgn*(x-aval)))
    return res

def rat(x):
 x=F(x);return iv.mpf(x.numerator)/x.denominator

def upper(x):return abs(x).b

def box(l,r):
 assert bool(l<=r) or bool(l<r)
 return iv.mpf([l.a,r.b])

def conv(a,b,n):
 o=[iv.mpf(0)]*(n+1)
 for i in range(min(len(a),n+1)):
  for j in range(min(len(b),n+1-i)):o[i+j]+=a[i]*b[j]
 return o

def buildpiece(piece):
 sm,lin,logs=piece
 # Logarithms have already been combined by exact symbolic anchor keys.
 exponents=set(sm)|set(lin)
 for anchor,sgn,s,d in logs:exponents.update(d)
 return sm,lin,logs,exponents

def series(piece,c,h,N):
 sm,lin,logs,exps=piece
 es={}
 for t in exps:
  ec=iv.exp(rat(t)*c);th=rat(t)*h
  arr=[ec]
  for j in range(1,N+1):arr.append(arr[-1]*th/j)
  es[t]=arr
 def esum(d):
  out=[iv.mpf(0)]*(N+1)
  for t,ar in d.items():
   for j in range(N+1):out[j]+=ar*es[t][j]
  return out
 out=esum(sm);z=esum(lin)
 for j in range(N+1):
  out[j]+=c*z[j]
  if j:out[j]+=h*z[j-1]
 for anchor,sgn,s,d in logs:
  aval=anchor[0]*iv.ln(3)/2+anchor[1]*iv.ln(2)
  q=s*iv.exp(sgn*(c-aval));hh=sgn*h
  w=[1-q,-q*hh]
  for j in range(2,N+1):w.append(w[-1]*hh/j)
  assert bool(w[0]>0)
  g=[iv.ln(w[0])]
  for j in range(1,N+1):
   g.append((w[j]-sum((g[k]*w[j-k]*(iv.mpf(k)/j) for k in range(1,j)),iv.mpf(0)))/w[0])
  term=conv(esum(d),g,N)
  for j in range(N+1):out[j]+=term[j]
 return out

def majorant(piece,c,h):
 sm,lin,logs,exps=piece
 R=2*h
 es={t:iv.exp(rat(t)*c+abs(rat(t))*R) for t in exps}
 def row(d):return sum((upper(ar)*es[t] for t,ar in d.items()),iv.mpf(0))
 M=row(sm)+(upper(c)+R)*row(lin)
 for anchor,sgn,s,d in logs:
  aval=anchor[0]*iv.ln(3)/2+anchor[1]*iv.ln(2)
  rr=iv.exp(sgn*(c-aval)+R)
  assert bool(rr<1), ('disc crosses logarithm', str(c),str(h),str(anchor))
  M+=row(d)*(-iv.ln(1-rr))
 return M.b

def cell(piece,l,r,N):
 c=(l+r)/2;h=(r-l)/2
 aa=series(piece,c,h,N)
 pp=conv(aa,aa,2*N)
 val=h*sum((2*pp[j]/(j+1) for j in range(0,2*N+1,2)),iv.mpf(0))
 eps=majorant(piece,c,h)/2**N
 pmax=sum((upper(x) for x in aa),iv.mpf(0))
 err=2*h*(2*pmax*eps+eps*eps)
 return val+iv.mpf([-err.b,err.b]),err.b

def tail(piece,l,r,delta,left,endpoint_key):
 sm,lin,logs,exps=piece
 X=box(l,l+delta) if left else box(r-delta,r)
 ep={t:iv.exp(rat(t)*X) for t in exps}
 def row(d):return upper(sum((ar*ep[t] for t,ar in d.items()),iv.mpf(0)))
 smooth=sum((ar*ep[t] for t,ar in sm.items()),iv.mpf(0))+X*sum((ar*ep[t] for t,ar in lin.items()),iv.mpf(0))
 B=iv.mpf(0)
 for anchor,sgn,s,d in logs:
  aval=anchor[0]*iv.ln(3)/2+anchor[1]*iv.ln(2)
  arg=1-s*iv.exp(sgn*(X-aval))
  if bool(arg>0):
   smooth+=sum((ar*ep[t] for t,ar in d.items()),iv.mpf(0))*iv.ln(arg)
  else:
   assert s==1
   assert anchor==endpoint_key
   assert sgn==(-1 if left else 1)
   # Here the actual positive log-distance is exactly the endpoint distance.
   B+=row(d)
 A=upper(smooth)+B
 assert bool(delta>0) and bool(delta<=1)
 D=-iv.ln(delta)
 budget=delta*(A*A+2*A*B*(D+1)+B*B*(D*D+2*D+2))
 return budget.b, (A.b,B.b)


def run(digits: int=100, order: int=80, depth: int=48) -> dict:
    if digits<100 or order<64 or depth<40:
        raise ValueError('Require digits>=100, Taylor order>=64 and dyadic depth>=40.')
    if digits>500 or order>256 or depth>200:
        raise ValueError('Parameters outside the reviewed resource range.')
    for filename,expected in PINS.items():
        if hashlib.sha256((ROOT/filename).read_bytes()).hexdigest()!=expected:
            raise ValueError('Unreviewed input: '+filename)
    previous=checked_import('reviewed_full_energy','certify_prime3_prolate_weil_energy.py').run(digits)
    assert previous['status']=='Pinned infinite-prolate replay and all directed interval/positive-tail guards passed.'
    iv.dps=digits
    model=make_model(iv)
    a,L=model['a'],model['L']
    assert bool(model['norm2']>0)
    # Exact reflection is built from the same atom rows. No sampled symmetry is used.
    intervals=[(iv.mpf(0),model['bounds'][1][1],model['pieces'][1],(0,0),(-1,1)),
               (*model['bounds'][2],model['pieces'][2],(-1,1),(1,0))]
    integral=iv.mpf(0); errors=iv.mpf(0); tails=iv.mpf(0); count=0
    tail_records=[]; segment_records=[]
    start=time.time()
    for l,r,p,left_key,right_key in intervals:
        assert bool(l<r)
        piece=buildpiece(p); width=r-l; delta=width/2**depth
        part=iv.mpf(0)
        for left in (True,False):
            t,ab=tail(piece,l,r,delta,left,left_key if left else right_key)
            tails+=2*t
            tail_records.append({'left':left,'width':str(delta),'A':str(ab[0]),'B':str(ab[1]),
                                 'one_sided_squared_mass_upper':str(t)})
            for j in range(1,depth):
                near=width/2**(j+1); far=width/2**j
                cl,cr=(l+near,l+far) if left else (r-far,r-near)
                val,err=cell(piece,cl,cr,order)
                part+=2*val; errors+=2*err; count+=1
                if count%40==0:
                    print(f'certified cells={count}, elapsed={time.time()-start:.1f}s',file=sys.stderr,flush=True)
        segment_records.append(str(part))
        integral+=part
    integral+=iv.mpf([0,tails.b])
    assert bool(integral>0)
    polynomial_norm=iv.sqrt(model['norm2'])
    raw_residual=iv.sqrt(integral)

    # The preceding executed proof gives independently bounded true-model value
    # and derivative errors on each of its four smooth/jump pieces.
    D0=rat(F(7718,10**24)); D1=rat(F(1287,10**20))
    assert bool(iv.mpf(previous['true_model_piecewise_value_error'])<D0)
    assert bool(iv.mpf(previous['true_model_piecewise_derivative_error'])<D1)
    assert previous['tail_diagonal_floor']==4160
    delta=iv.sqrt(L)*D0
    assert bool(polynomial_norm>delta)
    # Minkowski on the actual infinite Gamma difference kernel, both directions:
    gamma_graph=6*iv.sqrt(2*L)*D1+(24*iv.sqrt(4)+23*iv.sqrt(L))*D0
    W=2*iv.ln(2)/iv.sqrt(2)+2*((iv.exp(a)-iv.exp(-a))/2+a)
    graph_error=gamma_graph+(W+abs(model['mu']))*delta
    # The integral is computed at a fixed exact center. The genuine Rayleigh
    # center is only known through the previous complete interval certificate.
    lo_mu,hi_mu=map(F,previous['true_model_rayleigh_interval_rational'])
    exact_center=F(5949113595,10**17)
    center_error=rat(max(abs(lo_mu-exact_center),abs(hi_mu-exact_center)))
    lower=(raw_residual-graph_error)/(polynomial_norm+delta)-center_error
    upper_bound=(raw_residual+graph_error)/(polynomial_norm-delta)+center_error
    lo,hi=F(9166619,10**11),F(9166620,10**11)
    assert bool(lower>rat(lo))
    assert bool(upper_bound<rat(hi))
    sqlo,sqhi=F(8402690,10**15),F(8402692,10**15)
    assert bool(lower**2>rat(sqlo)) and bool(upper_bound**2<rat(sqhi))
    # Only a comparison with the PREVIOUS CERTIFIED second-eigenvalue threshold.
    # It says nothing about a sharper, currently unknown actual spectral gap.
    threshold=F(3,250000)
    assert lo>7*(threshold-lo_mu)>0
    return {
      'scale':'lambda=sqrt(3), a=log(3)/2; genuine evenized zero-integral prolate model',
      'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'dependency_sha256':PINS,
      'preceding_full_energy_and_infinite_prolate_replayed':True,
      'interval_decimal_digits':digits,'Taylor_order':order,'dyadic_endpoint_depth':depth,
      'interior_cells_positive_half':count,
      'exact_center':str(exact_center),
      'polynomial_norm_squared':str(model['norm2']),
      'complete_polynomial_residual_squared_integral':str(integral),
      'Taylor_integral_error_radius':str(errors),
      'all_endpoint_strips_squared_mass_upper':str(tails),
      'endpoint_strip_records':tail_records,
      'reflected_interior_segment_integrals':segment_records,
      'true_model_graph_error_upper':str(graph_error),
      'Rayleigh_recentering_error_upper':str(center_error),
      'true_normalized_Rayleigh_residual_lower_enclosure':str(lower),
      'true_normalized_Rayleigh_residual_upper_enclosure':str(upper_bound),
      'true_normalized_Rayleigh_residual_rational_interval':[str(lo),str(hi)],
      'true_normalized_squared_Rayleigh_residual_rational_interval':[str(sqlo),str(sqhi)],
      'comparison':'Using only the historical lambda_1>=3/250000 threshold gives a residual/distance coefficient greater than seven. No necessity or actual-gap upper bound is asserted.',
      'status':'All pinned replays, analytic-disc guards, endpoint envelopes, graph-error and rational residual guards passed.',
      'scope':'Full physical-window L2 residual of the actual prolate model, with paper Gamma/domain identification and executed directed integration. No new eigenvalue/gap, all-scale approximation, Xi convergence, or Lean kernel verdict.',
      'python':platform.python_version(),
    }

if __name__=='__main__':
    digits=int(sys.argv[1]) if len(sys.argv)>1 else 100
    report=run(digits)
    suffix='' if digits==100 else '_'+str(digits)
    target=ROOT/('prime3_prolate_operator_residual_certificate'+suffix+'.json')
    target.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2),flush=True)
