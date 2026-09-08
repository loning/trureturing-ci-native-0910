"""Generate exact power observations; retain original full-word valuation."""
from pathlib import Path
from math import isqrt
from bisect import bisect_right
import sys,hashlib,json

def sample(n,fib):
 q=1<<(2*n);left=q;idx=[]
 while left:
  i=bisect_right(fib,left)-1;idx.append(i);left-=fib[i]
 used=set(idx);bits=[int(i in used) for i in range(idx[0],1,-1)]
 v=z=0
 for a in bits:v,z=z+a,v+z+2*a
 assert v==q and all(a*b==0 for a,b in zip(bits,bits[1:]))
 fl=lambda x:(x+isqrt(5*x*x))//2
 d=fl(4*q)-4*fl(q)
 ks=[];p=0
 while p<len(bits):
  assert bits[p]==1
  if p+1==len(bits):terminal=1;break
  assert bits[p+1]==0;p+=2;k=0
  while p<len(bits) and bits[p]==0:k+=1;p+=1
  ks.append(k);terminal=0
 return ' '.join(map(str,[n,d,terminal]+ks))

def main():
 count=int(sys.argv[1]);file=Path(sys.argv[2]);fib=[0,1,1,2]
 while fib[-1] <= 1<<(2*(count-1)):fib.append(fib[-1]+fib[-2])
 data=('\n'.join(sample(n,fib) for n in range(count))+'\n').encode();file.write_bytes(data)
 print(json.dumps({'samples':count,'sha256':hashlib.sha256(data).hexdigest()}))
if __name__=='__main__':main()
