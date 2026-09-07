#!/usr/bin/env python3
"""Audit literal Lean data for the checked real-X origin sector.

This re-parses the expression DAG, paths and instruction codes of the actual
Lean source rather than trusting generator objects. Domain constants and the
instruction decoding follow the documented fixed instance. All arithmetic is
fractions.Fraction. This is a finite diagnostic, NOT a Lean compiler or a
universal proof of the checker's analytic soundness or the source semantics.
"""
from __future__ import annotations
import argparse, ast, copy, hashlib, json, random, re
from fractions import Fraction as Q
from functools import lru_cache
from pathlib import Path

SQRT = (Q(5038595261767, 1099511627776), Q(629824407721,137438953472))
ROOT = (SQRT,)+((Q(-1,5),Q(1,5)),)*5
EPS = Q(1,64)


def require(condition: bool, text: str) -> None:
    if not condition:
        raise ValueError(text)


def rational(text: str) -> Q:
    text = text.replace(': ℚ', '').replace('(', '').replace(')', '').replace(' ', '')
    require(bool(re.fullmatch(r'-?\d+(?:/\d+)?', text)), 'not a rational literal')
    return Q(text)


def parse_source(text: str):
    section = text.split('private def residualData : List (Expr 6) :=\n',1)[1].split('\nprivate def residual (',1)[0]
    expressions = []
    for line in section.splitlines():
        match = re.fullmatch(r'  let e(\d+) : Expr 6 := \.(\w+) (.*)',line)
        if not match:
            continue
        index, operation, rest = int(match[1]),match[2],match[3]
        require(index == len(expressions), 'noncanonical expression index')
        if operation == 'input':
            m = re.fullmatch(r'(\d+) 0 0',rest)
            require(m is not None, 'invalid input')
            idx = int(m[1]); require(idx < 6, 'input out of range')
            expression = ('input',idx)
        elif operation == 'const':
            m = re.fullmatch(r'(\(.*? : ℚ\)) 0 0',rest)
            require(m is not None, 'invalid constant')
            expression = ('const',rational(m[1]))
        else:
            require(operation in ('add','neg','mul','square','inv'), 'unsupported operator')
            m = re.fullmatch(r'0 0 (e\d+(?: e\d+)?)',rest)
            require(m is not None, 'invalid arithmetic node')
            children = [int(i[1:]) for i in m[1].split()]
            require(len(children) == (2 if operation in ('add','mul') else 1), 'arity')
            require(all(i < index for i in children), 'expression not ordered')
            expression = (operation,)+(tuple(expressions[i] for i in children))
        expressions.append(expression)
    outputs = re.search(r'\n  \[(e\d+(?:, e\d+)*)\]\s*$',section)
    require(outputs is not None, 'missing expression outputs')
    residual = [expressions[int(i[1:])] for i in outputs[1].split(', ')]
    require(len(residual) == 6, 'residual arity')
    path_section = text.split('private def paths : List (ℕ × ℕ) :=\n',1)[1].split('\n\nprivate def boxes',1)[0]
    paths = ast.literal_eval(path_section.strip())
    code_section = text.split('private def stepCodes : List ℕ :=\n',1)[1].split('\n\nprivate def index237',1)[0]
    codes = ast.literal_eval(code_section.strip())
    require(len(codes)==237 and all(isinstance(c,int) and c>=0 for c in codes),'bad instruction codes')
    records=[]
    for i,code in enumerate(codes):
        if code<6:
            records.append(('excluded',code,i,code))
        else:
            data=code-6;j=data%6;left=(data//6)%237;right=(data//(6*237))%237
            box=path_box(*paths[i]);cut=(box[j][0]+box[j][1])/2
            records.append(('split',j,cut,left,right))
    return residual, paths, records, len(expressions)


@lru_cache(maxsize=None)
def path_box(depth: int, word: int):
    require(depth >= 0 and 0 <= word < (1 << depth),'invalid path')
    if depth == 0:
        return ROOT
    b = list(path_box(depth-1,word//2));j=(depth-1)%5+1
    middle = (b[j][0]+b[j][1])/2
    b[j] = (b[j][0],middle) if word%2==0 else (middle,b[j][1])
    return tuple(b)


def annotate(box, expression):
    op = expression[0]
    if op == 'input':
        l,u=box[expression[1]]; return (l,u,expression,())
    if op == 'const':
        q=expression[1];return (q,q,expression,())
    children=tuple(annotate(box,a) for a in expression[1:]);a=children[0]
    if op=='neg':l,u=-a[1],-a[0]
    elif op=='square':
        l=Q(0) if a[0]<=0<=a[1] else min(a[0]**2,a[1]**2)
        u=max(a[0]**2,a[1]**2)
    elif op=='inv':
        require(a[1]<0 or 0<a[0], 'inverse crosses zero')
        l,u=1/a[1],1/a[0]
    elif op=='add':l,u=a[0]+children[1][0],a[1]+children[1][1]
    elif op=='mul':
        corners=[v*w for v in a[:2] for w in children[1][:2]];l,u=min(corners),max(corners)
    else:raise ValueError(op)
    return (l,u,expression,children)


def check_expression(box, cert):
    l,u,expression,children=cert;op=expression[0]
    if l>u:return False
    if op=='input':return l<=box[expression[1]][0] and box[expression[1]][1]<=u
    if op=='const':return l<=expression[1]<=u
    if not all(check_expression(box,c) for c in children):return False
    a=children[0]
    if op=='neg':return l<=-a[1] and -a[0]<=u
    if op=='square':return (l<=0 or (0<=a[0] and l<=a[0]**2) or (a[1]<=0 and l<=a[1]**2)) and a[0]**2<=u and a[1]**2<=u
    if op=='inv':return (a[1]<0 or 0<a[0]) and l<=1/a[1] and 1/a[0]<=u
    b=children[1]
    if op=='add':return l<=a[0]+b[0] and a[1]+b[1]<=u
    if op=='mul':return all(l<=v*w<=u for v in a[:2] for w in b[:2])
    return False


def verify(residual, paths, records):
    require(len(records)==len(paths)==237,'wrong node count')
    require(paths[-1]==(0,0),'wrong root')
    counts={'excluded':0,'split':0}; bounds=[]
    for i,record in enumerate(records):
        box=path_box(*paths[i]);require(all(l<=u for l,u in box),'inverted box')
        if record[0]=='excluded':
            _,outcome,bi,formula=record
            require(0<=outcome<6 and 0<=bi<237 and 0<=formula<6,'bad typed index')
            require(residual[outcome]==residual[formula],'residual identity changed')
            cert=annotate(path_box(*paths[bi]),residual[formula])
            require(check_expression(box,cert),'invalid interval check')
            require(EPS<cert[0] or cert[1]<-EPS,'no residual separation')
            bounds.append((i,outcome,str(cert[0]),str(cert[1])));counts['excluded']+=1
        else:
            _,j,cut,left,right=record
            require(0<=j<6 and 0<=left<i and 0<=right<i,'cycle or bad index')
            require(box[j][0]<=cut<=box[j][1],'bad cut')
            low=list(box);high=list(box);low[j]=(low[j][0],cut);high[j]=(cut,high[j][1])
            for parent_half, child in ((low,left),(high,right)):
                child_box=path_box(*paths[child])
                require(all(cl<=pl and pu<=cu for (pl,pu),(cl,cu) in zip(parent_half,child_box)),'missing closed half')
            counts['split']+=1
    return counts,bounds


def eval_expression(x,expression):
    op=expression[0]
    if op=='input':return x[expression[1]]
    if op=='const':return expression[1]
    a=eval_expression(x,expression[1])
    if op=='neg':return -a
    if op=='square':return a*a
    if op=='inv':return 1/a
    b=eval_expression(x,expression[2])
    return a+b if op=='add' else a*b


def cmul(a,b):return a[0]*b[0]-a[1]*b[1],a[0]*b[1]+a[1]*b[0]
def cadd(a,b):return a[0]+b[0],a[1]+b[1]
def conj(a):return a[0],-a[1]


def direct_residual(x,j):
    s,*t=x;u=[(Q(1),Q(0))]+[((1-a*a)/(1+a*a),2*a/(1+a*a)) for a in t]
    def entry(i,j):
        if i<3 and j<3:return (Q(-3,5),Q(4,5)) if i==j else (Q(1),Q(0))
        if i<3:return (Q(-2,5),s/5) if i+3==j else (Q(1),Q(0))
        if j<3:return (Q(-2,5),-s/5) if i==j+3 else (Q(1),Q(0))
        return (Q(3,5),Q(4,5)) if i==j else (Q(-1),Q(0))
    z=(Q(0),Q(0))
    for i in range(6):z=cadd(z,cmul(conj(entry(i,j)),u[i]))
    return z[0]*z[0]+z[1]*z[1]-6


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--source',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
    args=ap.parse_args();raw=args.source.read_bytes();text=raw.decode('utf-8')
    residual,paths,records,expr_nodes=parse_source(text)
    require(SQRT[0]>0 and SQRT[0]**2<21<SQRT[1]**2,'sqrt enclosure')
    counts,bounds=verify(residual,paths,records)
    rng=random.Random(6143);sample_count=0
    for _ in range(120):
        x=tuple(l+(h-l)*Q(rng.randrange(1001),1000) for l,h in ROOT)
        for a in range(6):
            require(eval_expression(x,residual[a])==direct_residual(x,a),'actual-matrix identity failed')
            sample_count+=1
    mutations=[]
    def reject(name, fn):
        pp=copy.deepcopy(paths);rr=copy.deepcopy(records);fn(pp,rr)
        try:verify(residual,pp,rr)
        except (ValueError,IndexError,TypeError):mutations.append(name);return
        raise ValueError('mutation accepted: '+name)
    reject('missing_final_branch',lambda p,r:r.pop())
    reject('cyclic_child',lambda p,r:r.__setitem__(-1,('split',1,Q(0),236,r[-1][4])))
    reject('both_halves_use_left_child',lambda p,r:r.__setitem__(-1,('split',1,Q(0),r[-1][3],r[-1][3])))
    reject('changed_outcome_same_expression',lambda p,r:r.__setitem__(0,('excluded',(r[0][1]+1)%6,r[0][2],r[0][3])))
    reject('wrong_annotation_box',lambda p,r:r.__setitem__(0,('excluded',r[0][1],236,r[0][3])))
    reject('incomplete_root_domain',lambda p,r:p.__setitem__(-1,(1,0)))
    box=path_box(*paths[0]);cert=annotate(box,residual[records[0][1]])
    require(not check_expression(box,(Q(1000),Q(1001),cert[2],cert[3])),'forged bound accepted')
    mutations.append('forged_exclusion_bound')
    result={'status':'LITERAL_LEAN_SECTOR_DATA_REPLAYED_EXACTLY','source_sha256':hashlib.sha256(raw).hexdigest(),
      'nodes':len(records),'expression_dag_nodes':expr_nodes,**counts,'actual_matrix_rational_checks':sample_count,
      'negative_controls_rejected':mutations,'phase_radius':'1/5','residual_tolerance':'1/64',
      'sign_chart':0,'complete_32_chart_coverage':False,'lean_elaboration_executed':False,
      'universal_soundness_machine_checked':False,'floating_point_in_acceptance':False}
    args.output.parent.mkdir(parents=True,exist_ok=True);args.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))
if __name__=='__main__':main()
