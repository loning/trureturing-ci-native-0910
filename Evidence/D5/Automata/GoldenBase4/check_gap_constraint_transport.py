"""Exact finite regressions for the new slot-to-CSP and renaming arguments.
The tests do not execute Lean and do not certify the remaining 5-slot cases.
"""
from itertools import product
from random import Random
from pathlib import Path
import json, hashlib

def require(ok,msg):
 if not ok:raise ValueError(msg)

def blocks(gs,channel):
 out=[]
 for k in gs:out += [1]+[0]*k
 return out+([1] if channel==0 else [])
def expand(bs,ch):
 return sum(([0] if b==0 else [1,0] for b in bs),[])+([1] if ch else [])
def gap_word(gs,ch):
 return [1]+sum(([0]*(k+1)+[1] for k in gs),[])+([0] if ch==0 else [])
def verify(A,B,C,F,G,gs,ch):
 q=0
 for b in blocks(gs,ch):q=A[q] if b==0 else C[B[q]]
 actual=G[B[q]] if ch else F[q]
 t=B[0]
 def h(k,u):
  z=C[u]
  for _ in range(k):z=A[z]
  return B[z]
 for k in gs:t=h(k,t)
 read=G[t] if ch else F[C[t]]
 require(actual==read,'gap transport')
 require(expand(blocks(gs,ch),ch)==gap_word(gs,ch),'word fidelity')
 return h,t
models=equations=selections=domains=0
allpaths=[tuple(p) for n in range(3) for p in product(range(3),repeat=n)]
for r,s in product((1,2),repeat=2):
 for A,B,C,F in product(product(range(r),repeat=r),product(range(s),repeat=r),product(range(r),repeat=s),product(range(4),repeat=r)):
  G=tuple((j+F[0])%4 for j in range(s));models+=1
  H=None;tr=[]
  for gs in allpaths:
   for ch in (0,1):H,t=verify(A,B,C,F,G,gs,ch);equations+=1
   tr.append(t)
  # Row-major addresses exactly match g*s+t and 3*s+i.
  flat=[H(g,t) for g in range(3) for t in range(s)]+tr
  for child,gs in enumerate(allpaths):
   if gs:
    par=allpaths.index(gs[:-1]);g=gs[-1]
    require(flat[3*s+child]==flat[g*s+flat[3*s+par]],'selection equation')
    selections+=1
  for i,t in enumerate(tr):
   for ch in (0,1):
    label=G[t] if ch else F[C[t]]
    allowed=[v for v in range(s) if (G[v] if ch else F[C[v]])==label]
    require(flat[3*s+i] in allowed,'observation domain');domains+=1
rng=Random(20260906);renamings=cases=0
for _ in range(250):
 r=1+rng.randrange(15);s=5
 A=[rng.randrange(r) for _ in range(r)];B=[rng.randrange(s) for _ in range(r)];C=[rng.randrange(r) for _ in range(s)];F=[rng.randrange(4) for _ in range(r)];G=[rng.randrange(4) for _ in range(s)]
 code=lambda t:4*G[t]+F[C[t]]
 P=list(range(s))
 if code(3)>code(4):P[3],P[4]=P[4],P[3]
 # P is its own inverse in this two-point transposition.
 BB=[P[t] for t in B];CC=[C[P[t]] for t in range(s)];GG=[G[P[t]] for t in range(s)]
 require(all((G[B[q]],C[B[q]])==(GG[BB[q]],CC[BB[q]]) for q in range(r)), 'same Skeleton')
 require(all((C[i],G[i])==(CC[i],GG[i]) for i in range(3)), 'anchors')
 require(4*GG[3]+F[CC[3]]<=4*GG[4]+F[CC[4]], 'profile order')
 for gs in allpaths:
  h,t=verify(A,B,C,F,G,gs,1);hh,tt=verify(A,BB,CC,F,GG,gs,1)
  require(tt==P[t] and GG[tt]==G[t] and F[CC[tt]]==F[C[t]],'renamed trace');renamings+=1
 for k,t in product(range(5),range(5)):
  h,_=verify(A,B,C,F,G,[],1);hh,_=verify(A,BB,CC,F,GG,[],1)
  require(hh(k,P[t])==P[h(k,t)],'gap conjugacy');renamings+=1
raw=list(product(range(8),range(6),range(6)))
ordered=[(a,p,q) for a,p,q in raw if p<=q]
require(len(raw)==288 and len(ordered)==168,'case count')
require({(a,min(p,q),max(p,q)) for a,p,q in raw}==set(ordered),'orbit coverage')
# Ensure an invalid transformation changing the selector only is detected.
A=[0,1];B=[3,4];C=[0,0,0,0,1];F=[0,1];G=[2,1,3,1,2];P=[0,1,2,4,3]
require(any((G[B[q]],C[B[q]])!=(G[P[B[q]]],C[P[B[q]]]) for q in range(2)), 'bad renaming must differ')
print(json.dumps(dict(status='PASS',slot_tables=models,gap_word_and_evaluation_equations=equations,selection_equations=selections,observed_domain_checks=domains,renaming_equations=renamings,unsorted_output_cases=len(raw),ordered_output_cases=len(ordered),output_orbit_coverage=True,invalid_selector_only_rename_rejected=True,lean_executed=False,powers_only_bound_improved=False),indent=2))
