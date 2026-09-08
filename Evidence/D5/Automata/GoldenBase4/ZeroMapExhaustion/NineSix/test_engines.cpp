// Exact anchored zero-map exhaustion with explicit per-map coverage records.
// For each fixed A, only identities A^i=A^j are used to compress zero runs.
// All J targets are branched; outputs are constrained only by observed labels.
#include <algorithm>
#include <array>
#include <chrono>
#include <fstream>
#include <iostream>
#include <map>
#include <numeric>
#include <sstream>
#include <vector>
#include <boost/multiprecision/cpp_int.hpp>
using namespace std;using boost::multiprecision::cpp_int;using Clock=chrono::steady_clock;
void require(bool b,const string&m){if(!b)throw runtime_error(m);}
cpp_int root(cpp_int n){if(n==0)return 0;cpp_int x=1;x<<=((boost::multiprecision::msb(n)+2)/2);for(;;){cpp_int y=(x+n/x)/2;if(y>=x)return x;x=y;}}
cpp_int golden(cpp_int n){return (n+root(5*n*n))/2;}
struct Vertex{vector<pair<int,int>>edges;array<int,2>label={-1,-1};};
struct Row{int n,d,terminal;vector<int>ks;};
vector<Row> read(const string&fn){ifstream f(fn);require(bool(f),"sample missing");vector<Row>rows;string line;while(getline(f,line)){
 istringstream in(line);Row o;require(bool(in>>o.n>>o.d>>o.terminal),"malformed row");require(o.n==(int)rows.size()&&o.d>=0&&o.d<4&&(o.terminal==0||o.terminal==1),"row header");int k;while(in>>k){require(k>=0,"negative zeros");o.ks.push_back(k);}require(in.eof(),"trailing syntax");
 cpp_int q=0,z=0;auto bit=[&](int b){cpp_int next=z+b;z=q+z+2*b;q=next;};
 for(int k:o.ks){bit(1);bit(0);for(int j=0;j<k;j++)bit(0);}if(o.terminal)bit(1);
 require(q==(cpp_int(1)<<(2*o.n)),"wrong power word");require(golden(4*q)-4*golden(q)==o.d,"wrong exact digit");rows.push_back(o);
 }require(!rows.empty(),"empty sample set");return rows;}


#include <random>
#include <set>
struct Stop{};
struct JumpEngine {
 const vector<Row>&rows;int r,s;vector<int>A,J,F,G;vector<vector<int>>P;
 vector<array<int,3>>trail;vector<unsigned>reasonF,reasonG;unsigned assigned=0;long long calls=0,leaves=0,backjumps=0;Clock::time_point started;double limit;
 JumpEngine(const vector<Row>&rs,const vector<int>&a,int budget,double seconds):rows(rs),r(a.size()),s(budget),A(a),J(r,-1),F(r,-1),G(r,-1),started(Clock::now()),limit(seconds){
 reasonF.assign(r,0);reasonG.assign(r,0);F[0]=0;int maximum=0;for(auto&x:rows)for(int k:x.ks)maximum=max(maximum,k);
 P.assign(maximum+1,vector<int>(r));iota(P[0].begin(),P[0].end(),0);for(int k=1;k<=maximum;++k)for(int q=0;q<r;++q)P[k][q]=A[P[k-1][q]];
 }
 int cost(){uint64_t pairs=0;unsigned og=0,tg=0,o=0,t=0;for(int q=0;q<r;++q){if(J[q]>=0&&G[q]>=0){pairs|=1ULL<<(G[q]*r+J[q]);og|=1U<<G[q];tg|=1U<<J[q];}else{if(G[q]>=0)o|=1U<<G[q];if(J[q]>=0)t|=1U<<J[q];}}return __builtin_popcountll(pairs)+max(__builtin_popcount(o&~og),__builtin_popcount(t&~tg));}
 void restore(size_t mark){while(trail.size()>mark){auto[k,q,value]=trail.back();trail.pop_back();(k==0?F:k==1?G:J)[q]=value;}}
 // On failure, return a set of currently fixed J coordinates sufficient
 // for the contradiction. Eliminate a decision only after all r values fail.
 pair<bool,unsigned> dfs(int row,int pos,int q,unsigned path){calls++;if((calls&8191)==0&&chrono::duration<double>(Clock::now()-started).count()>limit)throw Stop{};
  while(row<(int)rows.size()){
   auto &w=rows[row];
   while(pos<(int)w.ks.size()){
    if(J[q]<0){size_t mark=trail.size();unsigned before=assigned,combined=0;for(int j=0;j<r;++j){J[q]=j;assigned=before|(1U<<q);trail.push_back({2,q,-1});pair<bool,unsigned> result;
      if(cost()>s){leaves++;result={false,assigned};}else result=dfs(row,pos+1,P[w.ks[pos]][j],path|(1U<<q));
      if(result.first)return result;
      unsigned why=result.second;restore(mark);assigned=before;
      if(!(why&(1U<<q))){backjumps++;return {false,why};}
      combined|=why&~(1U<<q);
    }return {false,combined};}
    path|=1U<<q;q=P[w.ks[pos]][J[q]];pos++;
   }
   int&out=(w.terminal?G:F)[q];unsigned&why=(w.terminal?reasonG:reasonF)[q];
   if(out>=0&&out!=w.d){leaves++;return {false,path|why};}
   if(out<0){out=w.d;why=path;trail.push_back({w.terminal,q,-1});if(cost()>s){leaves++;return {false,assigned};}}
   row++;pos=0;q=0;path=0;
  }
  return {true,0};
 }
 bool run(){auto result=dfs(0,0,0,0);if(!result.first)require(result.second==0,"unclosed root conflict");return result.first;}
 void model(ostream&out){out<<"A";for(int x:A)out<<" "<<x;out<<"\nJ";for(int x:J)out<<" "<<x;out<<"\nF";for(int x:F)out<<" "<<x;out<<"\nG";for(int x:G)out<<" "<<x;out<<"\n";}
};

struct PlainEngine {
 const vector<Row>&rows;int r,s;vector<int>A,J,F,G;vector<vector<int>>P;
 vector<array<int,3>>trail;long long calls=0,leaves=0;Clock::time_point started;double limit;
 PlainEngine(const vector<Row>&rs,const vector<int>&a,int budget,double seconds):rows(rs),r(a.size()),s(budget),A(a),J(r,-1),F(r,-1),G(r,-1),started(Clock::now()),limit(seconds){
 F[0]=0;int maximum=0;for(auto&x:rows)for(int k:x.ks)maximum=max(maximum,k);
 P.assign(maximum+1,vector<int>(r));iota(P[0].begin(),P[0].end(),0);for(int k=1;k<=maximum;++k)for(int q=0;q<r;++q)P[k][q]=A[P[k-1][q]];
 }
 int cost(){uint64_t pairs=0;unsigned og=0,tg=0,o=0,t=0;for(int q=0;q<r;++q){if(J[q]>=0&&G[q]>=0){pairs|=1ULL<<(G[q]*r+J[q]);og|=1U<<G[q];tg|=1U<<J[q];}else{if(G[q]>=0)o|=1U<<G[q];if(J[q]>=0)t|=1U<<J[q];}}return __builtin_popcountll(pairs)+max(__builtin_popcount(o&~og),__builtin_popcount(t&~tg));}
 void restore(size_t mark){while(trail.size()>mark){auto[k,q,value]=trail.back();trail.pop_back();(k==0?F:k==1?G:J)[q]=value;}}
 bool dfs(int row,int pos,int q){calls++;if((calls&8191)==0&&chrono::duration<double>(Clock::now()-started).count()>limit)throw Stop{};
  while(row<(int)rows.size()){
   auto &w=rows[row];
   while(pos<(int)w.ks.size()){
    if(J[q]<0){size_t mark=trail.size();for(int j=0;j<r;++j){J[q]=j;trail.push_back({2,q,-1});if(cost()<=s&&dfs(row,pos+1,P[w.ks[pos]][j]))return true;restore(mark);}return false;}
    q=P[w.ks[pos]][J[q]];pos++;
   }
   int&out=(w.terminal?G:F)[q];if(out>=0&&out!=w.d){leaves++;return false;}
   if(out<0){out=w.d;trail.push_back({w.terminal,q,-1});if(cost()>s){leaves++;return false;}}
   row++;pos=0;q=0;
  }
  return true;
 }
 bool run(){return dfs(0,0,0);}
 void model(ostream&out){out<<"A";for(int x:A)out<<" "<<x;out<<"\nJ";for(int x:J)out<<" "<<x;out<<"\nF";for(int x:F)out<<" "<<x;out<<"\nG";for(int x:G)out<<" "<<x;out<<"\n";}
};

struct Engine{
 vector<Vertex>v;int r,s;vector<int>A,J;vector<array<int,2>>O;vector<vector<int>>power;vector<vector<pair<int,int>>>wait;vector<array<int,3>>undo;vector<pair<int,int>>todo;long long calls=0,leaves=0;Clock::time_point start;double timeout;bool immediate=false;
 Engine(const vector<Row>&rows,const vector<int>&a,int cap,double secs,bool normalize):r(a.size()),s(cap),A(a),J(r,-1),O(r,{-1,-1}),wait(r),start(Clock::now()),timeout(secs){
 int maxk=0;for(auto&row:rows)for(int k:row.ks)maxk=max(maxk,k);power.assign(maxk+1,vector<int>(r));iota(power[0].begin(),power[0].end(),0);for(int k=1;k<=maxk;k++)for(int q=0;q<r;q++)power[k][q]=A[power[k-1][q]];
 vector<int>norm(maxk+1);for(int k=0;k<=maxk;++k){norm[k]=k;if(normalize)for(int j=0;j<k;++j)if(power[k]==power[j]){norm[k]=j;break;}}
 vector<map<int,int>>edges(1);v.resize(1);v[0].label[0]=0;
 for(auto&row:rows){int at=0;for(int k:row.ks){int key=norm[k];auto it=edges[at].find(key);if(it==edges[at].end()){int next=v.size();edges[at][key]=next;edges.emplace_back();v.emplace_back();at=next;}else at=it->second;}int&label=v[at].label[row.terminal];if(label>=0&&label!=row.d)immediate=true;label=row.d;}
 for(size_t i=0;i<v.size();++i)for(auto e:edges[i])v[i].edges.push_back(e);
 }
 bool extend(){while(!todo.empty()){
 auto[node,q]=todo.back();todo.pop_back();for(int c=0;c<2;c++)if(v[node].label[c]>=0){int d=v[node].label[c];if(O[q][c]>=0){if(O[q][c]!=d)return false;}else{O[q][c]=d;undo.push_back({c,q,-1});}}
 for(auto[k,child]:v[node].edges)if(J[q]>=0)todo.emplace_back(child,power[k][J[q]]);else{wait[q].emplace_back(child,k);undo.push_back({2,q,-1});}
 }return true;}
 int necessary(){uint64_t pairs=0;unsigned og=0,o=0,tg=0,t=0;for(int q=0;q<r;q++){if(O[q][1]>=0&&J[q]>=0){pairs|=1ULL<<(O[q][1]*r+J[q]);og|=1U<<O[q][1];tg|=1U<<J[q];}else{if(O[q][1]>=0)o|=1U<<O[q][1];if(J[q]>=0)t|=1U<<J[q];}}return __builtin_popcountll(pairs)+max(__builtin_popcount(o&~og),__builtin_popcount(t&~tg));}
 void restore(size_t mark){todo.clear();while(undo.size()>mark){auto[k,q,b]=undo.back();undo.pop_back();if(k<2)O[q][k]=b;else if(k==2)wait[q].pop_back();else J[q]=b;}}
 bool solve(){calls++;if((calls&4095)==0&&chrono::duration<double>(Clock::now()-start).count()>timeout)throw Stop{};
 if(!extend()||necessary()>s){leaves++;return false;}int q=-1;for(int p=0;p<r;p++)if(J[p]<0&&!wait[p].empty()&&(q<0||wait[p].size()>wait[q].size()))q=p;if(q<0)return true;
 size_t mark=undo.size();for(int j=0;j<r;j++){undo.push_back({3,q,-1});J[q]=j;for(auto[node,k]:wait[q])todo.emplace_back(node,power[k][j]);if(solve())return true;restore(mark);}return false;}
 bool run(){if(immediate){calls=leaves=1;return false;}todo.emplace_back(0,0);return solve();}
 void model(ostream&out){out<<"A";for(int q:A)out<<" "<<q;out<<"\nJ";for(int q:J)out<<" "<<q;for(int c=0;c<2;++c){out<<"\n"<<(c?"G":"F");for(auto x:O)out<<" "<<x[c];}out<<"\n";}
};

bool brute(const vector<Row>&rows,const vector<int>&A,int cap){int r=A.size();unsigned long long count=1;for(int q=0;q<r;++q)count*=r;for(unsigned long long enc=0;enc<count;++enc){auto x=enc;vector<int>J(r),F(r,-1),G(r,-1);for(int q=0;q<r;++q){J[q]=x%r;x/=r;}F[0]=0;bool valid=true;for(auto &row:rows){int q=0;for(int k:row.ks){q=J[q];for(int z=0;z<k;++z)q=A[q];}int &v=(row.terminal?G:F)[q];if(v>=0&&v!=row.d){valid=false;break;}v=row.d;}if(!valid)continue;
 set<pair<int,int>>pairs;set<int>targets,covered;for(int q=0;q<r;++q){targets.insert(J[q]);if(G[q]>=0){pairs.insert({G[q],J[q]});covered.insert(J[q]);}}
 int cost=pairs.size();for(int q:targets)if(!covered.count(q))++cost;if(cost<=cap)return true;
 }return false;}
int main(){mt19937 rng(20260907);long long instances=0,sat=0,unsat=0,backjumps=0;for(int r=1;r<=4;++r){int acount=1;for(int i=1;i<r;++i)acount*=r;for(int ai=0;ai<acount;++ai){vector<int>A(r);int z=ai;for(int i=1;i<r;++i){A[i]=z%r;z/=r;}
 for(int repeat=0;repeat<24;++repeat){vector<int>J(r),F(r),G(r);for(int q=0;q<r;++q){J[q]=rng()%r;F[q]=rng()%4;G[q]=rng()%4;}F[0]=0;G[0]=2;vector<Row>rows={{0,2,1,{}}};for(int j=0;j<12;++j){Row row;row.n=j+1;row.terminal=rng()%2;int len=1+rng()%5;int q=0;for(int k=0;k<len;++k){int zeros=rng()%5;row.ks.push_back(zeros);q=J[q];for(int h=0;h<zeros;++h)q=A[q];}row.d=row.terminal?G[q]:F[q];if(repeat%2&&j%3==0)row.d=rng()%4;rows.push_back(row);}
 for(int cap=1;cap<=r;++cap){bool expected=brute(rows,A,cap);JumpEngine j(rows,A,cap,3600);PlainEngine p(rows,A,cap,3600);Engine e(rows,A,cap,3600,true);require(j.run()==expected,"CBJ mismatch");require(p.run()==expected,"plain mismatch");require(e.run()==expected,"normalized event mismatch");instances++;backjumps+=j.backjumps;sat+=expected;unsat+=!expected;}
 }
 }}cout<<"{\"status\":\"PASS\",\"instances\":"<<instances<<",\"SAT\":"<<sat<<",\"UNSAT\":"<<unsat<<",\"backjumps_checked\":"<<backjumps<<",\"maximum_r\":4,\"truth\":\"all complete J tables and exact optimal output completion\"}\n";}
