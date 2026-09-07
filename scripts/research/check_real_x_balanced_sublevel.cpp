// Research verifier for the FULL six-outcome residual sublevel.
// Reuses the existing evaluator, dyadic arithmetic and signed-Cayley atlas.
// Additional premise: the exact seed satisfies H0 H0*=6 I and |u_j|=1,
// so the six REAL squared-modulus residuals sum to zero.
#define main original_root_cover_main
#include "check_real_x_global_cover.cpp"
#undef main

struct SixRange { array<I,6> r; bool feasible; };
SixRange six_residual_ranges(Box const& X,int mask,ll epsilon) {
  I f[5]; eval(X,mask,f,nullptr);
  Ray u=phase(X,mask); C y;
  for(int i=0;i<6;i++) y=y+conj(H[i][5])*u[i];
  I sixth=normsq(y)-I(6);
  SixRange z;z.feasible=true; wide low=0,high=0;
  for(int a=0;a<6;a++) {
    I v=a<5?f[a]:sixth;
    ll l=max(v.l,-epsilon),h=min(v.h,epsilon);
    if(l>h){z.feasible=false;return z;}
    z.r[a]=I(l,h);low+=l;high+=h;
  }
  z.feasible=low<=0 && high>=0;
  return z;
}

// For EVERY real vector r in these intervals with sum r=0,
// c.r = sum_i (c_i-lambda)*r_i. Any lambda gives a valid interval;
// intersecting the six candidate intervals remains sound. No optimizer
// optimum or approximate dual multiplier is trusted.
I balanced_linear_range(array<ll,6> const& c,array<I,6> const& r) {
  I naive;
  for(int a=0;a<6;a++)naive=naive+I::point(c[a])*r[a];
  ll lo=naive.l,hi=naive.h;
  for(ll lambda:c) {
    I z;
    for(int a=0;a<6;a++)z=z+I::point(checked((wide)c[a]-lambda))*r[a];
    lo=max(lo,z.l);hi=min(hi,z.h);
  }
  if(lo>hi)throw runtime_error("balanced dual enclosures inconsistent");
  return I(lo,hi);
}

bool balanced_krawczyk(Box const&X,int mask,SixRange const&range,Kr&out,
                      long&improved) {
  try {
    Box m;for(int j=0;j<5;j++)m[j]=I::point(mid(X[j]));
    I f[5],J[5][5],f0[5],J0[5][5],Cpre[5][5];
    eval(m,mask,f0,J0);if(!propose(J0,Cpre))return false;
    eval(X,mask,f,J);out.contraction=0;
    for(int i=0;i<5;i++) {
      out.k[i]=m[i];ll row=0;
      for(int a=0;a<5;a++)out.k[i]=out.k[i]-Cpre[i][a]*f0[a];
      for(int j=0;j<5;j++) {
        I e=I(i==j);for(int a=0;a<5;a++)e=e-Cpre[i][a]*J[a][j];
        row=checked((wide)row+absmax(e));
        out.k[i]=out.k[i]+e*(X[j]-m[j]);
      }
      array<ll,6> c{};I naive;
      for(int a=0;a<5;a++){c[a]=Cpre[i][a].l;
        if(Cpre[i][a].l!=Cpre[i][a].h)throw runtime_error("nonpoint preconditioner");
        naive=naive+Cpre[i][a]*range.r[a];}
      I tight=balanced_linear_range(c,range.r);
      if(tight.l>naive.l||tight.h<naive.h)improved++;
      out.k[i]=out.k[i]+tight;out.contraction=max(out.contraction,row);
    }
    return true;
  }catch(overflow_error const&){return false;}
}

#ifndef MUB_BALANCED_SUBLEVEL_LIBRARY
int main(int argc,char**argv){try {
  if(argc!=7)throw runtime_error("centers chart cap epsilon_bits tube_bits report");
  int mask=stoi(argv[2]),eb=stoi(argv[4]),tb=stoi(argv[5]);long cap=stol(argv[3]);
  if(mask<0||mask>=32||cap<1||eb<1||eb>39||tb<1||tb>16)
    throw runtime_error("invalid arguments");
  ll eps=ONE>>eb,rad=ONE>>tb;
  seed();load_roots(argv[1]);
  for(auto&r:roots)for(auto&t:r.x){ll m=mid(t);t=I(checked((wide)m-rad),checked((wide)m+rad));}
  Box initial;for(auto&t:initial)t=I(-ONE,ONE);
  vector<Node> pending{{initial,0}};
  long nodes=0,excluded=0,inside=0,contracted=0,unresolved=0,dual_improvements=0;
  auto start=chrono::steady_clock::now();
  while(!pending.empty()&&nodes<cap){
    auto[X,depth]=pending.back();pending.pop_back();nodes++;
    if(in_known(X,mask)>=0){inside++;continue;}
    auto r=six_residual_ranges(X,mask,eps);
    if(!r.feasible){excluded++;continue;}
    Kr k;if(balanced_krawczyk(X,mask,r,k,dual_improvements)){
      bool empty=false;for(int j=0;j<5;j++)empty|=k.k[j].h<X[j].l||k.k[j].l>X[j].h;
      if(empty){excluded++;continue;}
      Box Y;bool shrink=false;
      for(int j=0;j<5;j++){Y[j]=I(max(X[j].l,k.k[j].l),min(X[j].h,k.k[j].h));
        shrink|=((wide)5*(Y[j].h-Y[j].l)<(wide)3*(X[j].h-X[j].l));}
      if(in_known(Y,mask)>=0){inside++;continue;}
      if(shrink){pending.push_back({Y,depth+1});contracted++;continue;}
    }
    int j=0;for(int a=1;a<5;a++)if(X[a].h-X[a].l>X[j].h-X[j].l)j=a;
    ll m=mid(X[j]);if(depth>180||m<=X[j].l||m>=X[j].h){unresolved++;continue;}
    Box Y=X;Y[j].l=m;X[j].h=m;
    pending.push_back({Y,depth+1});pending.push_back({X,depth+1});
  }
  bool pass=pending.empty()&&unresolved==0;
  double secs=chrono::duration<double>(chrono::steady_clock::now()-start).count();
  string report=string("{\"status\":\"")+(pass?"FULL_SIX_SUBLEVEL_COVERED":"INCOMPLETE")+
    "\",\"chart\":"+to_string(mask)+",\"nodes\":"+to_string(nodes)+
    ",\"excluded\":"+to_string(excluded)+",\"tube_leaves\":"+to_string(inside)+
    ",\"contracted\":"+to_string(contracted)+",\"pending\":"+to_string(pending.size())+
    ",\"unresolved\":"+to_string(unresolved)+",\"dual_improvements\":"+to_string(dual_improvements)+
    ",\"epsilon_bits\":"+to_string(eb)+",\"tube_bits\":"+to_string(tb)+
    ",\"seconds\":"+to_string(secs)+",\"residual_domain\":\"all_six_balanced\""+
    ",\"seed_gram_is_mathematical_premise\":true,\"lean_kernel_verified\":false}";
  ofstream out(argv[6]);if(!out)throw runtime_error("cannot write report");out<<report<<'\n';
  cout<<report<<'\n';return pass?0:2;
}catch(exception const&e){cerr<<"FAIL CLOSED: "<<e.what()<<'\n';return 1;}}

#endif
