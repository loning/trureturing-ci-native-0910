#!/usr/bin/env python3
"""Replay conserved-six-residual coverage and strong MUB unextendibility.

An accepting full run rebuilds the seed, all 32 compact charts, the label-5
refinement and all whole-tube overlap constraints. It does not consume a
previous PASS. This is computer-assisted verification, not Lean admission.
"""
from __future__ import annotations
import argparse
from concurrent.futures import ThreadPoolExecutor
from fractions import Fraction as F
import hashlib, itertools, json, subprocess
from pathlib import Path
import check_real_x_arc_constellation as arc
import check_real_x_strong_unextendibility as strong
import check_strict_x_counterexample as seed_owner

EPSILON=F(1,64)
TAU=F(1,256)
SIGMA=F(9,4096)
OUTER=F(1,16)
INNER=F(1,32)
REFINE=5


def require(ok, message):
    if not ok:
        raise ValueError(message)


def git_blob(path):
    b=Path(path).read_bytes()
    return hashlib.sha1(b'blob '+str(len(b)).encode()+b'\0'+b).hexdigest()


def check_seed():
    E=seed_owner.E
    b=E((F(-3,5),F(4,5),F(0),F(0)))
    e=E((F(-2,5),F(0),F(0),F(1,5)))
    one=E.rat(1)
    H=[]
    for i in range(6):
        row=[]
        for j in range(6):
            if i<3 and j<3: z=b if i==j else one
            elif i<3: z=e if i==j-3 else one
            elif j<3: z=e.conj() if i-3==j else one
            else: z=-b.conj() if i==j else -one
            row.append(z)
        H.append(row)
    require(all(z*z.conj()==one for row in H for z in row),'seed entry modulus')
    goal=[[E.rat(6*int(i==j)) for j in range(6)] for i in range(6)]
    require(seed_owner.mm(H,seed_owner.adj(H))==goal,'seed row Gram')
    require(seed_owner.mm(seed_owner.adj(H),H)==goal,'seed column Gram')
    return {'field':'Q(i,sqrt(21))','unit_entries':True,'both_grams_six_I':True,
            'conservation_used_only_for_this_exact_seed':True}


def audit_reports(reports):
    require(len(reports)==32 and {r.get('chart') for r in reports}==set(range(32)),
            'missing or repeated chart')
    for r in reports:
        require(r.get('status')=='FULL_SIX_SUBLEVEL_COVERED' and
                r.get('pending')==r.get('unresolved')==0 and
                r.get('epsilon_bits')==6 and r.get('tube_bits')==4 and
                r.get('residual_domain')=='all_six_balanced',
                'incomplete or mismatched all-six cover')
    return {'charts':32,'nodes':sum(r['nodes'] for r in reports),
            'pending':0,'unresolved':0,
            'balanced_readout_improvements':sum(r['dual_improvements'] for r in reports),
            'domain':'all six seed residuals have absolute value <=1/64',
            'tube_radius':str(OUTER),'tube_uniqueness_used':False}


LOCAL_SOURCE = r'''
#define MUB_BALANCED_SUBLEVEL_LIBRARY
#include "check_real_x_balanced_sublevel.cpp"
int main(int argc,char**argv) {
 try {
  if(argc!=7) throw runtime_error("centers label epsilon_bits inner_bits cap output");
  seed(); load_roots(argv[1]);
  int label=stoi(argv[2]),eb=stoi(argv[3]),ib=stoi(argv[4]); long cap=stol(argv[5]);
  if(label<0||label>=60||eb<1||eb>39||ib<5||ib>20||cap<1)
    throw runtime_error("bad arguments");
  auto it=find_if(roots.begin(),roots.end(),[&](Root const&r){return r.id==label;});
  if(it==roots.end()) throw runtime_error("missing label");
  Box initial,target;
  for(int j=0;j<5;j++) {
    ll m=mid(it->x[j]);
    initial[j]=I(checked((wide)m-(ONE>>4)),checked((wide)m+(ONE>>4)));
    target[j]=I(checked((wide)m-(ONE>>ib)),checked((wide)m+(ONE>>ib)));
  }
  auto contained=[&](Box const&X) {
    for(int j=0;j<5;j++) if(!subset(X[j],target[j])) return false;
    return true;
  };
  vector<Node> pending{{initial,0}};
  long nodes=0,excluded=0,inside=0,unresolved=0,improved=0;
  while(!pending.empty()&&nodes<cap) {
    auto[X,depth]=pending.back(); pending.pop_back(); nodes++;
    if(contained(X)){inside++;continue;}
    auto r=six_residual_ranges(X,it->mask,ONE>>eb);
    if(!r.feasible){excluded++;continue;}
    Kr k;
    if(balanced_krawczyk(X,it->mask,r,k,improved)) {
      bool empty=false;
      for(int j=0;j<5;j++) empty|=k.k[j].h<X[j].l||k.k[j].l>X[j].h;
      if(empty){excluded++;continue;}
      Box Y; bool shrink=false;
      for(int j=0;j<5;j++) {
        Y[j]=I(max(X[j].l,k.k[j].l),min(X[j].h,k.k[j].h));
        shrink|=(wide)5*(Y[j].h-Y[j].l)<(wide)3*(X[j].h-X[j].l);
      }
      if(contained(Y)){inside++;continue;}
      if(shrink){pending.push_back({Y,depth+1});continue;}
    }
    int j=0;
    for(int a=1;a<5;a++) if(X[a].h-X[a].l>X[j].h-X[j].l) j=a;
    ll m=mid(X[j]);
    if(depth>180||m<=X[j].l||m>=X[j].h){unresolved++;continue;}
    Box Y=X; Y[j].l=m; X[j].h=m;
    pending.push_back({Y,depth+1}); pending.push_back({X,depth+1});
  }
  bool pass=pending.empty()&&unresolved==0;
  string report=string("{\"status\":\"")+(pass?"BALANCED_REFINEMENT_COVERED":"INCOMPLETE")+
    "\",\"label\":"+to_string(label)+",\"epsilon_bits\":"+to_string(eb)+
    ",\"outer_bits\":4,\"inner_bits\":"+to_string(ib)+
    ",\"nodes\":"+to_string(nodes)+",\"pending\":"+to_string(pending.size())+
    ",\"unresolved\":"+to_string(unresolved)+",\"inside\":"+to_string(inside)+
    ",\"excluded\":"+to_string(excluded)+",\"dual_improvements\":"+to_string(improved)+
    ",\"lean_kernel_verified\":false}";
  ofstream out(argv[6]); if(!out) throw runtime_error("cannot write report");
  out<<report<<'\n'; cout<<report<<'\n'; return pass?0:2;
 } catch(exception const&e) {cerr<<e.what()<<'\n'; return 1;}
}
'''


def run(centers: Path, output: Path, full: bool, jobs: int, cap: int):
    require(__debug__,'the reused interval library requires ordinary Python')
    require(1<=jobs<=32 and cap>0,'invalid budget')
    directory=Path(__file__).resolve().parent
    output.mkdir(parents=True,exist_ok=True)
    for name in ('verification.json','failure.json'):
        (output/name).unlink(missing_ok=True)
    # This executable is specialized to the literal seed constructed by the
    # reused evaluator. A different seed or a rectangular interval matrix
    # must not silently inherit the exact Gram/conservation premise.
    require(git_blob(directory/'check_real_x_global_cover.cpp')==
            '8e1439391594875aafea3dbcf14e6625dc001b2d','unreviewed seed/evaluator revision')
    require(arc.RADIUS==OUTER and arc.TAU==TAU and arc.ETA==TAU**2,'changed arc constants')
    symbolic=check_seed()
    values=arc.read_centers(centers)
    A,B,bounds,same=arc.relations(values)
    first=arc.prior.enumerate_six_cliques(A)
    before=[]
    for c in first:
        m=(1<<60)-1
        for i in c: m &= B[i]
        if m: before.append((c,m))
    require({j for _,m in before for j in arc.prior.vertices(m)}=={REFINE},
            'unexpected unrefined partner labels')
    local_cpp=output/'balanced_local.cpp'; local_cpp.write_text(LOCAL_SOURCE)
    local_bin=(output/'balanced_local').resolve()
    subprocess.run(['g++','-O3','-std=c++17','-Wall','-Wextra','-Werror',
                    '-I',str(directory),str(local_cpp),'-o',str(local_bin)],check=True)
    local_report=(output/'refined_label_5.json').resolve()
    local_report.unlink(missing_ok=True)
    subprocess.run([str(local_bin),str(centers.resolve()),'5','6','5',str(cap),str(local_report)],
                   check=True,stdout=subprocess.DEVNULL)
    local=json.loads(local_report.read_text())
    require(local.get('status')=='BALANCED_REFINEMENT_COVERED' and
            local.get('pending')==local.get('unresolved')==0 and
            (local.get('label'),local.get('epsilon_bits'),local.get('outer_bits'),local.get('inner_bits'))==(5,6,4,5),
            'wrong or incomplete local refinement')
    refined=[]
    for i in range(60):
        lo,hi=strong.overlap_bounds(values[i],INNER if i==REFINE else OUTER,values[REFINE],INNER)
        refined.append([i,str(lo),str(hi)])
        if lo>F(1,6)+TAU or hi<F(1,6)-TAU:
            B[i] &= ~(1<<REFINE); B[REFINE] &= ~(1<<i)
    # A is deliberately retained as a supergraph after refinement.
    for c in first:
        m=(1<<60)-1
        for i in c: m &= B[i]
        require(m==0,'a possible fourth-vector partner remains')
    require(same>F(3,4)>TAU**2 and TAU<=F(1,4),'invalid overlap threshold')
    transfer=TAU+SIGMA*(5+SIGMA)
    require(transfer<EPSILON,'matrix transport budget exhausted')
    (output/'finite_certificate.json').write_text(json.dumps({
        'orthogonality_masks':A,'unbiased_masks':B,'first_six_cliques':first,
        'original_overlap_bounds':bounds,'refined_overlap_bounds':refined})+'\n')
    result={'status':'FINITE_AND_BALANCED_LOCAL_CERTIFICATE_VERIFIED',
        'symbolic_seed':symbolic,'first_six_cliques':len(first),
        'orthogonality_edges':sum(x.bit_count() for x in A)//2,
        'unbiased_edges':sum(x.bit_count() for x in B)//2,'remaining_partner_sets':0,
        'whole_tube_pair_checks':len(bounds)+len(refined),'same_tube_lower':str(same),
        'seed_sublevel_all_six':str(EPSILON),'candidate_tolerance':str(TAU),
        'outer_tube_radius':str(OUTER),'refined_tube_radius':str(INNER),
        'column_l1_radius':str(SIGMA),'entrywise_radius':str(SIGMA/6),
        'residual_transfer_upper':str(transfer),'energy_gap':str(TAU**2),
        'literal_constellation_sizes':[6,6,6,1],'local_refinement':local,
        'global_cover_replayed':False,'lean_kernel_verified':False,
        'comparison_warning':'all-six sublevel, not the older first-five sublevel; node counts are not a same-domain speed comparison'}
    if full:
        source=directory/'check_real_x_balanced_sublevel.cpp'
        binary=(output/'balanced_global').resolve()
        subprocess.run(['g++','-O3','-std=c++17','-Wall','-Wextra','-Werror',
                        str(source),'-o',str(binary)],check=True)
        def chart(k):
            dest=(output/f'chart_{k:02d}.json').resolve();dest.unlink(missing_ok=True)
            subprocess.run([str(binary),str(centers.resolve()),str(k),str(cap),'6','4',str(dest)],
                           check=True,stdout=subprocess.DEVNULL)
            return json.loads(dest.read_text())
        with ThreadPoolExecutor(max_workers=jobs) as pool:
            reports=list(pool.map(chart,range(32)))
        result['global_cover']=audit_reports(reports)
        result['global_cover_replayed']=True
        result['status']='COMPUTATIONAL_BALANCED_STRONG_UNEXTENDIBILITY_VERIFIED'
    paths=[Path(__file__),directory/'check_real_x_balanced_sublevel.cpp',centers,
           directory/'check_real_x_global_cover.cpp',Path(arc.__file__),Path(strong.__file__),
           Path(seed_owner.__file__)]
    result['source_sha256']={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
    result['source_scope']={'strong_overlap_owner':'two unchanged mathematical functions from remote blob 90c3d6a82cd970e3fec7dee3850caf69fe59919b',
        'standalone_bundle':'may contain a read-only excerpt of the strong owner; that excerpt is not a repository overlay file'}
    (output/'verification.json').write_text(json.dumps(result,indent=2)+'\n')
    return result

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('centers',type=Path)
    p.add_argument('--output',type=Path,required=True);p.add_argument('--full-cover',action='store_true')
    p.add_argument('--jobs',type=int,default=4);p.add_argument('--max-nodes',type=int,default=1800000)
    a=p.parse_args()
    try:
        print(json.dumps(run(a.centers,a.output,a.full_cover,a.jobs,a.max_nodes),indent=2))
    except Exception as e:
        a.output.mkdir(parents=True,exist_ok=True);(a.output/'verification.json').unlink(missing_ok=True)
        (a.output/'failure.json').write_text(json.dumps({'status':'FAIL','error':str(e)})+'\n')
        raise
