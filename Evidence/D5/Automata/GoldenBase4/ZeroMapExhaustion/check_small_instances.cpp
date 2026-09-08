#define main fixed_zero_cli_main
#include "check_zero_maps.cpp"
#undef main
#include <random>
int brute_minimum(const vector<Vertex>&vs,const vector<int>&A){int r=A.size(),bound=r+1;long long total=1;for(int i=0;i<r;i++)total*=r;
 for(long long code=0;code<total;code++){long long z=code;vector<int>J(r);for(int&q:J){q=z%r;z/=r;}
  unsigned reach=1,old;do{old=reach;for(int q=0;q<r;q++)if(reach&(1u<<q))reach|=(1u<<A[q])|(1u<<J[q]);}while(old!=reach);
  vector<array<int,2>>O(r,{-1,-1});vector<int>X(vs.size(),-1);X[0]=0;bool good=true;
  for(int v=0;v<(int)vs.size()&&good;v++){require(X[v]>=0,"test trie reach");int q=X[v];for(int ch=0;ch<2;ch++)if(vs[v].label[ch]>=0){int d=vs[v].label[ch];if(O[q][ch]>=0&&O[q][ch]!=d){good=false;break;}O[q][ch]=d;}for(auto[k,w]:vs[v].edges){int t=J[q];for(int n=0;n<k;n++)t=A[t];X[w]=t;}}
  if(!good)continue;int cost=0;for(int j=0;j<r;j++){unsigned colors=0;bool used=false;for(int q=0;q<r;q++)if(J[q]==j){used=true;if(O[q][1]>=0)colors|=1u<<O[q][1];}if(used)cost+=max(1,__builtin_popcount(colors));}
  bound=min(bound,cost);
 }return bound;}
int main(){mt19937 rng(20260907);long long cases=0,sat=0,unsat=0,functions=0;auto start=chrono::steady_clock::now();
 for(int r=1;r<=4;r++){long long total=1;for(int j=1;j<r;j++)total*=r;
  for(long long code=0;code<total;code++){vector<int>A(r),J(r),F(r),G(r);long long z=code;for(int j=1;j<r;j++){A[j]=z%r;z/=r;}for(int j=0;j<r;j++)J[j]=(j+1)%r;functions++;
   for(int trial=0;trial<24;trial++){for(int q=0;q<r;q++){F[q]=rng()%4;G[q]=rng()%4;}F[0]=0;vector<Vertex>v(1);v[0].label[0]=0;
    for(int obs=0;obs<12;obs++){int len=rng()%5,at=0,q=0;for(int j=0;j<len;j++){int k=rng()%5;q=J[q];for(int h=0;h<k;h++)q=A[q];auto it=v[at].edges.find(k);if(it==v[at].edges.end()){int child=v.size();v[at].edges[k]=child;v.emplace_back();at=child;}else at=it->second;}
     int ch=rng()%2;if(v[at].label[ch]<0)v[at].label[ch]=trial%2?(int)(rng()%4):(ch?G[q]:F[q]);
    }
    int lower=brute_minimum(v,A);
    for(int s=1;s<=r;s++){Engine e(v,A,s,start,120);bool actual=e.run(),expect=lower<=s;require(actual==expect,"unrestricted search disagrees with full J/output completion");cases++;sat+=actual;unsat+=!actual;}
   }
  }
 }
 cout<<"{\"status\":\"PASS\",\"zero_maps\":"<<functions<<",\"random_seed\":20260907,\"instances\":"<<cases<<",\"SAT_controls\":"<<sat<<",\"UNSAT_controls\":"<<unsat<<",\"truth_source\":\"all full J tables with exact minimal output completion\",\"seconds\":"<<chrono::duration<double>(chrono::steady_clock::now()-start).count()<<"}\n";
}
