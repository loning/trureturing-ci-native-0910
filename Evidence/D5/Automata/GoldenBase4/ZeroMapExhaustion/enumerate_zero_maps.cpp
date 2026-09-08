// Enumerate all zero maps up to an explicit state relabeling, then solve J.
#include <algorithm>
#include <array>
#include <chrono>
#include <fstream>
#include <iostream>
#include <numeric>
#include <set>
#include <string>
#include <unordered_set>
#include <vector>
using namespace std;
struct Canon {
 vector<int>a,cyc,ind,order,p;vector<vector<int>>children;vector<string>code;int n;
 Canon(vector<int>x):a(x),n(x.size()){}
 string tree(int v){vector<pair<string,int>>ks;for(int c:children[v])if(!cyc[c])ks.emplace_back(tree(c),c);sort(ks.begin(),ks.end());string s="(";for(auto&[t,c]:ks)s+=t;s+=")";code[v]=s;return s;}
 void visit(int v){order.push_back(v);vector<pair<string,int>>ks;for(int c:children[v])if(!cyc[c])ks.emplace_back(code[c],c);sort(ks.begin(),ks.end());for(auto&[s,c]:ks)visit(c);}
 string run(){
  ind.assign(n,0);cyc.assign(n,1);children.assign(n,{});code.assign(n,"");for(int i=0;i<n;i++){ind[a[i]]++;children[a[i]].push_back(i);}vector<int>queue;for(int i=0;i<n;i++)if(!ind[i])queue.push_back(i);for(int z=0;z<int(queue.size());z++){int v=queue[z];cyc[v]=0;if(--ind[a[v]]==0)queue.push_back(a[v]);}
  vector<vector<int>>cycles;vector<bool>seen(n,false);for(int i=0;i<n;i++)if(cyc[i]&&!seen[i]){vector<int>vs;int v=i;do{seen[v]=true;vs.push_back(v);v=a[v];}while(v!=i);cycles.push_back(vs);}
  vector<pair<string,vector<int>>>comps;
  for(auto vs:cycles){for(int v:vs)tree(v);if(find(vs.begin(),vs.end(),0)!=vs.end()){if(vs.size()!=1)throw runtime_error("root not fixed");comps.emplace_back("!"+code[0],vs);continue;}
   string best;vector<int>bv;for(int k=0;k<int(vs.size());k++){string s="C";vector<int>v;for(int j=0;j<int(vs.size());j++){int q=vs[(j+k)%vs.size()];s+=code[q];s+='.';v.push_back(q);}if(k==0||s<best){best=s;bv=v;}}
   comps.emplace_back(best,bv);
  }
  sort(comps.begin(),comps.end());order.clear();for(auto&[c,vs]:comps)for(int v:vs)visit(v);if(order.size()!=n||order[0]!=0)throw runtime_error("order");p.assign(n,-1);for(int i=0;i<n;i++)p[order[i]]=i;
  string result(n,'\0');for(int i=0;i<n;i++)result[p[i]]=char(p[a[i]]);return result;
 }
};
struct Timeout{};
struct Solve {
 int r,s;vector<array<int,4>>tr;vector<int>A,J,F,G,X;vector<vector<int>>waiting;vector<pair<int,int>>pending;vector<array<int,3>>trail;vector<int>touched;
 long long nodes=0,conflicts=0;chrono::steady_clock::time_point start;double limit;bool exceeded=false;
 Solve(vector<array<int,4>>const&t,vector<int>a,int ss,chrono::steady_clock::time_point st,double lim):r(a.size()),s(ss),tr(t),A(a),J(r,-1),F(r,-1),G(r,-1),X(t.size(),-1),waiting(r),start(st),limit(lim){}
 bool setout(int ch,int p,int d){vector<int>&O=ch?G:F;if(O[p]>=0)return O[p]==d;trail.push_back({ch,p,O[p]});O[p]=d;return true;}
 bool propagate(){
  while(!pending.empty()){
   auto[v,p]=pending.back();pending.pop_back();if(X[v]>=0){if(X[v]!=p)throw runtime_error("nondeterministic trace");continue;}
   trail.push_back({2,v,X[v]});X[v]=p;
   for(int c=0;c<2;c++)if(tr[v][2+c]>=0&&!setout(c,p,tr[v][2+c]))return false;
   if(tr[v][0]>=0)pending.emplace_back(tr[v][0],A[p]);
   if(tr[v][1]>=0){if(J[p]>=0)pending.emplace_back(tr[v][1],J[p]);else{waiting[p].push_back(tr[v][1]);trail.push_back({3,p,0});}}
  }return true;
 }
 void rollback(size_t k){pending.clear();while(trail.size()>k){auto x=trail.back();trail.pop_back();if(x[0]==0)F[x[1]]=x[2];else if(x[0]==1)G[x[1]]=x[2];else if(x[0]==2)X[x[1]]=x[2];else if(x[0]==3)waiting[x[1]].pop_back();else J[x[1]]=x[2];}}
 int cost(){unsigned long long full=0;unsigned o=0,t=0,og=0,tg=0;for(int q=0;q<r;q++){if(G[q]>=0&&J[q]>=0){full|=1ULL<<(G[q]*r+J[q]);og|=1u<<G[q];tg|=1u<<J[q];}else{if(G[q]>=0)o|=1u<<G[q];if(J[q]>=0)t|=1u<<J[q];}}return __builtin_popcountll(full)+max(__builtin_popcount(o&~og),__builtin_popcount(t&~tg));}
 bool dfs(int depth){nodes++;if((nodes&255)==0&&chrono::duration<double>(chrono::steady_clock::now()-start).count()>limit)throw Timeout{};
  if(!propagate()||cost()>s){conflicts++;return false;}
  int p=-1;for(int q=0;q<r;q++)if(J[q]<0&&!waiting[q].empty()&&(p<0||waiting[q].size()>waiting[p].size()))p=q;
  if(p<0)return true;
  for(int j=0;j<r;j++){auto mark=trail.size();trail.push_back({4,p,J[p]});J[p]=j;for(int v:waiting[p])pending.emplace_back(v,j);if(dfs(depth+1))return true;rollback(mark);}return false;
 }
 bool run(){pending.emplace_back(0,0);return dfs(0);}
 void model(){cerr<<"MODEL r="<<r<<" s="<<s<<"\n";for(int q=0;q<r;q++)cerr<<q<<" "<<A[q]<<" "<<J[q]<<" "<<F[q]<<" "<<G[q]<<"\n";}
};
int main(int argc,char**argv){
 if(argc>1&&string(argv[1])=="audit"){
  ifstream in(argv[2]);int r,count;in>>r>>count;if(r<1||r>8||count<1)return 2;
  set<string>allowed;for(int i=0;i<count;i++){string row;for(int j=0;j<r;j++){int x;in>>x;if(!in||x<0||x>=r)return 3;row+=char(x);}if(row[0]!=0)return 4;allowed.insert(row);}string extra;if(in>>extra)return 5;
  long long total=1;for(int i=1;i<r;i++)total*=r;vector<int>A(r);long long checked=0;
  for(long long z=0;z<total;z++){auto t=z;A[0]=0;for(int i=1;i<r;i++){A[i]=t%r;t/=r;}
   Canon c(A);string key=c.run();if(!allowed.count(key))throw runtime_error("missing zero map representative");
   vector<int>seen(r);if(c.p[0]!=0)throw runtime_error("renaming moves root");
   for(int i=0;i<r;i++){if(c.p[i]<0||c.p[i]>=r||seen[c.p[i]]++)throw runtime_error("renaming not bijective");if((unsigned char)key[c.p[i]]!=c.p[A[i]])throw runtime_error("renaming not conjugacy");}checked++;
  }
  cout<<"{\"status\":\"PASS\",\"r\":"<<r<<",\"raw_zero_maps\":"<<total<<",\"representatives\":"<<allowed.size()<<",\"verified_conjugacies\":"<<checked<<"}\n";return 0;
 }

 if(argc>1&&string(argv[1])=="grow"){
  ifstream in(argv[2]);int old,count;in>>old>>count;int r=old+1;unordered_set<string>keys;
  for(int k=0;k<count;k++){vector<int>a(r);for(int j=0;j<old;j++)in>>a[j];for(int to=0;to<old;to++){a[old]=to;keys.insert(Canon(a).run());}}
  if(!in)return 3;
  vector<int>parts;auto partitions=[&](auto&&self,int remain,int least)->void{
   if(!remain){vector<int>a(r);a[0]=0;int next=1;for(int len:parts){for(int j=0;j<len;j++)a[next+j]=next+(j+1)%len;next+=len;}keys.insert(Canon(a).run());return;}
   for(int p=least;p<=remain;p++){parts.push_back(p);self(self,remain-p,p);parts.pop_back();}
  };partitions(partitions,r-1,1);
  vector<string>sorted(keys.begin(),keys.end());sort(sorted.begin(),sorted.end());ofstream out(argv[3]);out<<r<<" "<<sorted.size()<<"\n";for(auto&s:sorted){for(unsigned char x:s)out<<int(x)<<" ";out<<"\n";}
  cerr<<"grown r="<<r<<" shapes="<<sorted.size()<<"\n";return 0;
 }
 if(argc>1&&string(argv[1])=="generate"){
  int r=stoi(argv[2]);unordered_set<string>keys;long long total=1;for(int i=1;i<r;i++)total*=r;vector<int>A(r);auto st=chrono::steady_clock::now();
  for(long long z=0;z<total;z++){auto t=z;A[0]=0;for(int i=1;i<r;i++){A[i]=t%r;t/=r;}keys.insert(Canon(A).run());}
  vector<string>sorted(keys.begin(),keys.end());sort(sorted.begin(),sorted.end());ofstream out(argv[3]);out<<r<<" "<<sorted.size()<<"\n";for(auto&s:sorted){for(unsigned char x:s)out<<int(x)<<" ";out<<"\n";}cerr<<"raw "<<total<<" shapes "<<sorted.size()<<" seconds "<<chrono::duration<double>(chrono::steady_clock::now()-st).count()<<"\n";return 0;
 }
 if(argc<6)return 2;ifstream f(argv[1]);int n;f>>n;vector<array<int,4>>tr(n);for(auto&x:tr)for(int&v:x)f>>v;if(!f)return 3;
 ifstream g(argv[2]);int r,count;g>>r>>count;vector<vector<int>>maps(count,vector<int>(r));for(auto&a:maps)for(int&v:a)g>>v;if(!g)return 4;
 int s=stoi(argv[3]);double limit=stod(argv[4]);int begin=stoi(argv[5]),end=argc>6?stoi(argv[6]):count;auto st=chrono::steady_clock::now();long long nodes=0,conflicts=0;int done=0;string status="UNSAT";
 for(int i=begin;i<end;i++){Solve sol(tr,maps[i],s,st,limit);try{bool sat=sol.run();nodes+=sol.nodes;conflicts+=sol.conflicts;if(sat){status="SAT";sol.model();cerr<<"shape "<<i<<"\n";break;}done++;}catch(Timeout&){nodes+=sol.nodes;conflicts+=sol.conflicts;status="UNKNOWN";break;}if((i-begin)%25==0)cerr<<"done "<<i+1<<" nodes "<<nodes<<" seconds "<<chrono::duration<double>(chrono::steady_clock::now()-st).count()<<"\n";}
 cout<<"{\"status\":\""<<status<<"\",\"r\":"<<r<<",\"s\":"<<s<<",\"begin\":"<<begin<<",\"end\":"<<end<<",\"completed_shapes\":"<<done<<",\"nodes\":"<<nodes<<",\"conflicts\":"<<conflicts<<",\"seconds\":"<<chrono::duration<double>(chrono::steady_clock::now()-st).count()<<"}\n";
}
