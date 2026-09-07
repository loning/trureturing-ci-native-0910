"""Development checks independent of the endpoint-energy implementation.

Exact SymPy polynomial identities and antiderivative differentiation are paired
with a high-precision direct Gamma-kernel quadrature for individual atoms.
Quadrature checks are diagnostics only; the energy certificate uses no quadrature.
"""
from fractions import Fraction
from pathlib import Path
import hashlib
import json
import mpmath as mp
import sympy as sp


def run() -> dict:
    t,u=sp.symbols('t u',positive=True)
    polynomial_checks=0
    for r in range(10):
        regular=sum((t**(2*j+1)*u**(2*(r-1-j)) for j in range(r)), sp.Integer(0))
        if sp.expand((t*t-u*u)*regular-t*(t**(2*r)-u**(2*r))) != 0:
            raise AssertionError(('quotient',r))
        for left,right in [(sp.Rational(1,3),sp.Rational(3,2)),(1,1),(sp.Rational(7,5),3)]:
            value=sp.integrate(regular.subs(u,left),(t,left,right))
            endpoint=sum(left**(2*(r-1-j))*(right**(2*j+2)-left**(2*j+2))/sp.Integer(2*j+2) for j in range(r))
            if sp.simplify(value-endpoint)!=0:
                raise AssertionError(('integral',r,left,right))
            polynomial_checks+=1
    # Check the endpoint primitives for both signs and all three integer-rate cases.
    y=sp.symbols('y',positive=True)
    primitives=0
    for n in range(-8,9):
        for s in (-1,1):
            if n==0:
                # Li2'(s*y)= -log(1-s*y)/y.
                continue
            sign=sp.Integer(s)**n
            expr=(y**n-sign)*sp.log(1-s*y)/n
            if n>0:
                expr-=sign*sum((s*y)**j/sp.Integer(j) for j in range(1,n+1))/n
            else:
                m=-n
                expr-=sp.Integer(s)**m*sp.log(y)/m
                expr+=sum(sp.Integer(s)**(m-j)*y**(-j)/sp.Integer(j) for j in range(1,m))/m
            if sp.simplify(sp.diff(expr,y)-y**(n-1)*sp.log(1-s*y))!=0:
                raise AssertionError(('primitive',n,s))
            primitives+=1
    # Independent comparison: original infinite Gamma kernel versus derived atom formula.
    mp.mp.dps=65
    gamma0=mp.digamma(mp.mpf(1)/4)-mp.log(mp.pi)
    constant=-mp.euler-mp.log(2*mp.pi)
    errors=[]
    exterior_signal=mp.mpf(0)
    for r in range(5):
        for x in map(mp.mpf,('-.4','.1','.6','1.1')):
            left,right=mp.mpf('-.7'),mp.mpf('.8')
            alpha=2*r+mp.mpf('.5')
            kernel=lambda v:mp.exp(-v/2)/(-mp.expm1(-2*v))
            if x<right:
                dp,dm=right-x,x-left
                plus=mp.quad(lambda v:kernel(v)*(-mp.expm1(alpha*v)),[0,dp])+mp.quad(kernel,[dp,mp.inf])
                minus=mp.quad(lambda v:kernel(v)*(-mp.expm1(-alpha*v)),[0,dm])+mp.quad(kernel,[dm,mp.inf])
                direct=mp.exp(alpha*x)*(gamma0+plus+minus)
                derived=mp.exp(alpha*x)*(constant-dp-mp.log(-mp.expm1(-2*dp))/2+
                    mp.atanh(mp.exp(-dm))-
                    sum(mp.expm1(2*k*dp)/(2*k) for k in range(1,r+1))+
                    sum(-mp.expm1(-(2*j-1)*dm)/(2*j-1) for j in range(1,r+1)))
            else:
                direct=-mp.quad(lambda v:kernel(v)*mp.exp(alpha*(x-v)),[x-right,x-left])
                P=lambda q:mp.atanh(q)-sum(q**(2*j-1)/(2*j-1) for j in range(1,r+1))
                derived=-mp.exp(alpha*x)*(P(mp.exp(right-x))-P(mp.exp(left-x)))
                exterior_signal=max(exterior_signal,abs(direct))
            errors.append(abs(direct-derived)/(1+abs(direct)))
    if max(errors)>=mp.mpf('1e-50'):
        raise AssertionError('Independent kernel comparison failed.')
    if exterior_signal<mp.mpf('.01'):
        raise AssertionError('Omitted-exterior negative control failed.')
    # The proof's positive majorants are checked with exact rationals.
    rho=Fraction(1,4);K=32
    if not 4000-356*(1/rho+rho)>0:
        raise AssertionError('Infinite tail comparison failed.')
    if 4000-356*(1/Fraction(1,100)+Fraction(1,100))>0:
        raise AssertionError('Overaggressive tail ratio was not rejected.')
    return {
      'exact_polynomial_endpoint_cases':polynomial_checks,
      'exact_logarithmic_antiderivative_derivatives':primitives,
      'independent_Gamma_atom_kernel_quadratures':len(errors),
      'quadrature_decimal_digits':65,
      'maximum_relative_kernel_discrepancy':mp.nstr(max(errors),16),
      'negative_controls':['zero exterior Gamma action rejected','tail ratio 1/100 rejected by exact infinite comparison'],
      'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'status':'All exact identities and development diagnostics passed.',
      'scope':'Quadrature is a nonrigorous independent diagnostic. The separate directed full-energy certificate uses only endpoint identities and explicit tails. These checks do not establish Lean parsing or kernel acceptance.'
    }

if __name__=='__main__':
    r=run()
    Path(__file__).with_name('gamma_logarithmic_seed_regression.json').write_text(json.dumps(r,indent=2)+'\n')
    print(json.dumps(r,indent=2))
