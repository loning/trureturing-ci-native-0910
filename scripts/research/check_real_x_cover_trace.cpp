// Proof-record export and replay for the existing balanced six-residual cover.
// This does not assert Lean-kernel verification. Only proposals, never verdicts,
// are trusted as input: replay recomputes every enclosure and covers both halves.
#define MUB_BALANCED_SUBLEVEL_LIBRARY
#include "check_real_x_balanced_sublevel.cpp"
#include <sstream>

using Preconditioner = array<array<ll,5>,5>;

bool choose_preconditioner(Box const& X,int mask,Preconditioner& c) {
  Box m;for(int j=0;j<5;j++)m[j]=I::point(mid(X[j]));
  I f[5],J[5][5],p[5][5];eval(m,mask,f,J);
  if(!propose(J,p))return false;
  for(int i=0;i<5;i++)for(int a=0;a<5;a++){
    if(p[i][a].l!=p[i][a].h)throw runtime_error("nonpoint proposal");
    c[i][a]=p[i][a].l;
  }
  return true;
}

// Arbitrary rational c is permitted. Invertibility is not a soundness premise.
Box fixed_image(Box const& X,int mask,SixRange const& r,Preconditioner const& c) {
  Box m,K;for(int j=0;j<5;j++)m[j]=I::point(mid(X[j]));
  I f[5],J[5][5],f0[5];eval(m,mask,f0,nullptr);eval(X,mask,f,J);
  for(int i=0;i<5;i++){
    K[i]=m[i];array<ll,6> row{};
    for(int a=0;a<5;a++){
      row[a]=c[i][a];K[i]=K[i]-I::point(c[i][a])*f0[a];
    }
    for(int j=0;j<5;j++){
      I e=I(i==j);
      for(int a=0;a<5;a++)e=e-I::point(c[i][a])*J[a][j];
      K[i]=K[i]+e*(X[j]-m[j]);
    }
    K[i]=K[i]+balanced_linear_range(row,r.r);
  }
  return K;
}

bool intersection(Box const& X,Box const& K,Box& Y) {
  for(int j=0;j<5;j++)if(K[j].h<X[j].l||X[j].h<K[j].l)return false;
  for(int j=0;j<5;j++)Y[j]=I(max(X[j].l,K[j].l),min(X[j].h,K[j].h));
  return true;
}
void write_preconditioner(ostream& out,Preconditioner const& c){
  for(auto const& row:c)for(ll a:row)out<<' '<<a;
}
Preconditioner read_preconditioner(istream& in){
  Preconditioner c{};for(auto& row:c)for(auto& a:row)
    if(!(in>>a))throw runtime_error("truncated preconditioner");
  return c;
}
void require_end(istream& in){string rest;if(in>>rest)throw runtime_error("trailing instruction data");}

struct Counts {long nodes=0,cover=0,range=0,empty=0,kcover=0,contract=0,split=0;};

Counts export_trace(string const& path,int mask,ll eps,long cap,int eb,int tb){
  ofstream out(path);if(!out)throw runtime_error("cannot create trace");
  out<<"MUB_BALANCED_TRACE_V1 "<<mask<<' '<<eb<<' '<<tb<<" 40\n";
  Box initial;for(auto& x:initial)x=I(-ONE,ONE);
  vector<Node> pending{{initial,0}};Counts n;
  while(!pending.empty()){
    if(n.nodes>=cap)throw runtime_error("trace incomplete: node cap reached");
    auto[X,depth]=pending.back();pending.pop_back();++n.nodes;
    int label=in_known(X,mask);
    if(label>=0){out<<"G "<<label<<'\n';++n.cover;continue;}
    auto r=six_residual_ranges(X,mask,eps);
    if(!r.feasible){out<<"R\n";++n.range;continue;}
    Preconditioner c{};bool have=false;Box K;
    try {
      if(choose_preconditioner(X,mask,c)){
        K=fixed_image(X,mask,r,c);have=true;
        Kr old;long improvements=0;
        if(!balanced_krawczyk(X,mask,r,old,improvements))
          throw runtime_error("reference contractor rejected a recorded image");
        for(int j=0;j<5;j++)if(K[j].l!=old.k[j].l||K[j].h!=old.k[j].h)
          throw runtime_error("recorded image disagrees with unchanged contractor");
      }
    } catch(overflow_error const&){have=false;}
    if(have){
      Box Y;
      if(!intersection(X,K,Y)){
        out<<"E";write_preconditioner(out,c);out<<'\n';++n.empty;continue;
      }
      label=in_known(Y,mask);
      if(label>=0){out<<"K "<<label;write_preconditioner(out,c);out<<'\n';++n.kcover;continue;}
      bool shrink=false;
      for(int j=0;j<5;j++)shrink|=((wide)5*(Y[j].h-Y[j].l)<(wide)3*(X[j].h-X[j].l));
      if(shrink){out<<"C";write_preconditioner(out,c);out<<'\n';++n.contract;
        pending.push_back({Y,depth+1});continue;}
    }
    int j=0;for(int a=1;a<5;a++)if(X[a].h-X[a].l>X[j].h-X[j].l)j=a;
    ll cut=mid(X[j]);
    if(depth>180||cut<=X[j].l||cut>=X[j].h)
      throw runtime_error("trace incomplete: unsplittable unresolved box");
    out<<"S "<<j<<' '<<cut<<'\n';++n.split;
    Box Y=X;Y[j].l=cut;X[j].h=cut;
    pending.push_back({Y,depth+1});pending.push_back({X,depth+1});
  }
  out<<"END\n";out.flush();if(!out)throw runtime_error("trace write failed");
  return n;
}

Counts replay_trace(string const& path,int mask,ll eps,int eb,int tb){
  ifstream in(path);if(!in)throw runtime_error("missing trace");
  string line,magic;int chart=-1,e=-1,t=-1,bits=-1;
  if(!getline(in,line))throw runtime_error("missing header");
  {istringstream h(line);if(!(h>>magic>>chart>>e>>t>>bits))throw runtime_error("invalid header");require_end(h);}
  if(magic!="MUB_BALANCED_TRACE_V1"||chart!=mask||e!=eb||t!=tb||bits!=40)
    throw runtime_error("trace parameters disagree with requested theorem");
  Box initial;for(auto& x:initial)x=I(-ONE,ONE);
  vector<Box> pending{initial};Counts n;
  while(!pending.empty()){
    if(!getline(in,line)||line=="END")throw runtime_error("missing proof branch");
    auto X=pending.back();pending.pop_back();++n.nodes;
    istringstream row(line);char kind=0;if(!(row>>kind))throw runtime_error("empty instruction");
    if(kind=='G'){
      int label;if(!(row>>label)||label<0||label>=60)throw runtime_error("invalid tube label");require_end(row);
      if(in_known(X,mask)!=label)throw runtime_error("tube inclusion is false");
      ++n.cover;
    }else if(kind=='R'){
      require_end(row);
      if(six_residual_ranges(X,mask,eps).feasible)
        throw runtime_error("residual exclusion is false");
      ++n.range;
    }else if(kind=='S'){
      int j;ll cut;if(!(row>>j>>cut)||j<0||j>=5)throw runtime_error("bad split");require_end(row);
      if(cut<=X[j].l||cut>=X[j].h)throw runtime_error("split is not interior");
      Box Y=X;Y[j].l=cut;X[j].h=cut;
      pending.push_back(Y);pending.push_back(X);++n.split;
    }else if(kind=='E'||kind=='C'||kind=='K'){
      int label=-1;if(kind=='K'&&!(row>>label))throw runtime_error("missing tube label");
      auto c=read_preconditioner(row);require_end(row);
      auto r=six_residual_ranges(X,mask,eps);
      if(!r.feasible)throw runtime_error("contract instruction on rejected residual domain");
      Box K=fixed_image(X,mask,r,c),Y;bool meet=intersection(X,K,Y);
      if(kind=='E'){
        if(meet)throw runtime_error("empty-contraction claim is false");
        ++n.empty;
      }else{
        if(!meet)throw runtime_error("nonempty child was asserted for empty intersection");
        if(kind=='K'){
          if(label<0||label>=60||in_known(Y,mask)!=label)throw runtime_error("contracted tube inclusion is false");
          ++n.kcover;
        }else {pending.push_back(Y);++n.contract;}
      }
    }else throw runtime_error("unknown proof instruction");
  }
  if(!getline(in,line)||line!="END")throw runtime_error("extra instructions after proof closure");
  while(getline(in,line))if(!line.empty())throw runtime_error("data after END");
  return n;
}

int main(int argc,char**argv){try{
  if(argc!=8)throw runtime_error("mode centers chart epsilon_bits tube_bits max_nodes trace");
  string mode=argv[1];int mask=stoi(argv[3]),eb=stoi(argv[4]),tb=stoi(argv[5]);long cap=stol(argv[6]);
  if((mode!="export"&&mode!="replay")||mask<0||mask>=32||eb<1||eb>39||tb<1||tb>16||cap<1)
    throw runtime_error("invalid parameters");
  seed();load_roots(argv[2]);ll eps=ONE>>eb,rad=ONE>>tb;
  for(auto&r:roots)for(auto&t:r.x){ll m=mid(t);t=I(checked((wide)m-rad),checked((wide)m+rad));}
  Counts n=mode=="export"?export_trace(argv[7],mask,eps,cap,eb,tb):replay_trace(argv[7],mask,eps,eb,tb);
  cout<<"{\"status\":\""<<(mode=="export"?"TRACE_EXPORTED":"TRACE_REPLAYED")
      <<"\",\"chart\":"<<mask<<",\"nodes\":"<<n.nodes<<",\"guard\":"<<n.cover
      <<",\"residual_excluded\":"<<n.range<<",\"contract_excluded\":"<<n.empty
      <<",\"contract_guard\":"<<n.kcover<<",\"contract\":"<<n.contract
      <<",\"split\":"<<n.split<<",\"pending\":0,\"unresolved\":0,\"lean_kernel_verified\":false}\n";
  return 0;
}catch(exception const&e){cerr<<"TRACE REJECTED: "<<e.what()<<'\n';return 1;}}
