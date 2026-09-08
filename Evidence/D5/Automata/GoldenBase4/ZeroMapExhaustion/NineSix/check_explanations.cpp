#define main checked_search_main
#ifdef WITH_REACHABILITY
#include "root_seed_search.cpp"
#else
#include "backjump_search.cpp"
#endif
#undef main
#include <random>
#include <set>

bool ground_truth(const vector<Row>& rows,const vector<int>&A,int cap,const vector<int>&fixed,unsigned mask){
 int r=A.size();unsigned long long count=1;for(int q=0;q<r;q++)count*=r;
 for(unsigned long long enc=0;enc<count;enc++){
  auto z=enc;vector<int>J(r),F(r,-1),G(r,-1);bool ok=true;
  for(int q=0;q<r;q++){J[q]=z%r;z/=r;if((mask&(1U<<q))&&J[q]!=fixed[q])ok=false;}if(!ok)continue;
#ifdef WITH_REACHABILITY
  unsigned reached=1U,previous=0;while(reached!=previous){previous=reached;for(int q=0;q<r;q++)if(reached&(1U<<q))reached|=(1U<<A[q])|(1U<<J[q]);}if(reached!=((1U<<r)-1))continue;
#endif
  F[0]=0;
  for(const auto&row:rows){int q=0;for(int k:row.ks){q=J[q];while(k--)q=A[q];}int&v=(row.terminal?G:F)[q];if(v>=0&&v!=row.d){ok=false;break;}v=row.d;}if(!ok)continue;
  set<pair<int,int>>pairs;set<int>targets,covered;for(int q=0;q<r;q++){targets.insert(J[q]);if(G[q]>=0){pairs.insert({G[q],J[q]});covered.insert(J[q]);}}
  int cost=pairs.size();for(int v:targets)if(!covered.count(v))cost++;if(cost<=cap)return true;
 }
 return false;
}
int main(){mt19937 gen(876421);long long cases=0,unsat=0,reduced=0;
 for(int r=1;r<=5;r++)for(int repeat=0;repeat<450;repeat++){
  vector<int>A(r),target(r),F(r),G(r),fixed(r,-1);unsigned mask=0;
  for(int q=0;q<r;q++){A[q]=gen()%r;target[q]=gen()%r;F[q]=gen()%4;G[q]=gen()%4;if(gen()%2){mask|=1U<<q;fixed[q]=gen()%r;}}A[0]=0;F[0]=0;
  vector<Row>rows;for(int j=0;j<12;j++){Row row;row.n=j;row.terminal=gen()%2;int len=gen()%8,q=0;for(int h=0;h<len;h++){int k=gen()%6;row.ks.push_back(k);q=target[q];for(int z=0;z<k;z++)q=A[q];}row.d=row.terminal?G[q]:F[q];if(repeat%2&&j==5)row.d=gen()%4;rows.push_back(row);}
  int cap=1+gen()%r;bool expected=ground_truth(rows,A,cap,fixed,mask);StreamEngine e(rows,A,cap,3600);e.J=fixed;e.assigned=mask;
  pair<bool,unsigned>result;
#ifdef WITH_REACHABILITY
  if(e.cost()>cap||!e.global_observations())result={false,mask};else result=e.dfs(0,0,0,0);
#else
  if(e.cost()>cap)result={false,mask};else result=e.dfs(0,0,0,0);
#endif
  require(result.first==expected,"fixed-partial verdict mismatch");cases++;
  if(!result.first){unsat++;unsigned why=result.second;require((why&~mask)==0,"explanation escaped fixed coordinates");require(!ground_truth(rows,A,cap,fixed,why),"returned explanation fails on another completion");reduced+=why!=mask;}
 }
 cout<<"{\"status\":\"PASS\",\"partial_assignments\":"<<cases<<",\"unsatisfiable\":"<<unsat<<",\"strictly_reduced_explanations\":"<<reduced<<",\"maximum_r\":5,\"checks_all_completions_of_each_returned_explanation\":true}"<<endl;
}
