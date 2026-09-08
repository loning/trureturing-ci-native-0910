// Complete growth of finite endofunctions with distinguished fixed point 0.
// At each order: attach a new indegree-zero vertex to every smaller map,
// and include every permutation cycle partition of the remaining vertices.
// Deduplication is allowed only after an explicitly checked conjugacy.
#include <algorithm>
#include <fstream>
#include <iostream>
#include <map>
#include <numeric>
#include <set>
#include <stdexcept>
#include <string>
#include <vector>
using namespace std;
void req(bool b,string s){if(!b)throw runtime_error(s);}
struct Canon {
 vector<int>a,cyc,ind,order,p;vector<vector<int>>children;vector<string>code;int n;
 Canon(vector<int>x):a(x),n(x.size()){}
 string tree(int v){vector<pair<string,int>>ks;for(int c:children[v])if(!cyc[c])ks.emplace_back(tree(c),c);sort(ks.begin(),ks.end());string s="(";for(auto&[t,c]:ks)s+=t;s+=")";code[v]=s;return s;}
 void visit(int v){order.push_back(v);vector<pair<string,int>>ks;for(int c:children[v])if(!cyc[c])ks.emplace_back(code[c],c);sort(ks.begin(),ks.end());for(auto&[s,c]:ks)visit(c);}
 string run(){
  ind.assign(n,0);cyc.assign(n,1);children.assign(n,{});code.assign(n,"");for(int i=0;i<n;i++){ind[a[i]]++;children[a[i]].push_back(i);}vector<int>queue;for(int i=0;i<n;i++)if(!ind[i])queue.push_back(i);for(int z=0;z<int(queue.size());z++){int v=queue[z];cyc[v]=0;if(--ind[a[v]]==0)queue.push_back(a[v]);}
  vector<vector<int>>cycles;vector<bool>seen(n,false);for(int i=0;i<n;i++)if(cyc[i]&&!seen[i]){vector<int>vs;int v=i;do{seen[v]=true;vs.push_back(v);v=a[v];}while(v!=i);cycles.push_back(vs);}
  vector<pair<string,vector<int>>>comps;
  for(auto vs:cycles){for(int v:vs)tree(v);if(find(vs.begin(),vs.end(),0)!=vs.end()){req(vs.size()==1,"root not fixed");comps.emplace_back("!"+code[0],vs);continue;}
   string best;vector<int>bv;for(int k=0;k<int(vs.size());k++){string s="C";vector<int>v;for(int j=0;j<int(vs.size());j++){int q=vs[(j+k)%vs.size()];s+=code[q];s+='.';v.push_back(q);}if(k==0||s<best){best=s;bv=v;}}
   comps.emplace_back(best,bv);
  }
  sort(comps.begin(),comps.end());order.clear();for(auto&[c,vs]:comps)for(int v:vs)visit(v);req(int(order.size())==n&&order[0]==0,"order");p.assign(n,-1);for(int i=0;i<n;i++)p[order[i]]=i;
  string result(n,'\0');for(int i=0;i<n;i++)result[p[i]]=char(p[a[i]]);
  vector<int>seenp(n);req(p[0]==0,"moved root");for(int i=0;i<n;++i){req(p[i]>=0&&p[i]<n&&!seenp[p[i]]++,"nonbijection");req((unsigned char)result[p[i]]==p[a[i]],"nonconjugacy");}return result;
 }
};
int main(int argc,char**argv){try{
 req(argc==3,"usage: anchored_maps max_order output_directory");int maximum=stoi(argv[1]);req(maximum>=1&&maximum<=15,"unsupported order");string outdir=argv[2];vector<string>prev={string(1,0)};
 for(int r=1;r<=maximum;++r){set<string>keys;long long extensions=0,permutations=0;
  if(r==1)keys.insert(string(1,0));else{
   for(auto row:prev){vector<int>a(r);for(int j=0;j<r-1;j++)a[j]=(unsigned char)row[j];for(int target=0;target<r-1;++target){a[r-1]=target;keys.insert(Canon(a).run());extensions++;}}
   vector<int>parts;auto partitions=[&](auto&&self,int remain,int least)->void{if(!remain){vector<int>a(r);a[0]=0;int next=1;for(int len:parts){for(int j=0;j<len;++j)a[next+j]=next+(j+1)%len;next+=len;}req(next==r,"partition size");keys.insert(Canon(a).run());permutations++;return;}for(int p=least;p<=remain;++p){parts.push_back(p);self(self,remain-p,p);parts.pop_back();}};partitions(partitions,r-1,1);
  }
  ofstream f(outdir+"/maps"+to_string(r)+".txt");req(bool(f),"cannot write map file");f<<r<<" "<<keys.size()<<"\n";for(auto row:keys){for(unsigned char q:row)f<<int(q)<<" ";f<<"\n";}f.close();prev.assign(keys.begin(),keys.end());
  cout<<"{\"r\":"<<r<<",\"representatives\":"<<keys.size()<<",\"checked_leaf_extensions\":"<<extensions<<",\"checked_permutations\":"<<permutations<<"}\n";
 }
}catch(exception&e){cerr<<e.what()<<"\n";return 2;}}
