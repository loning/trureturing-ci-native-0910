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

struct Stop{};
struct StreamEngine {
 const vector<Row>&rows;int r,s;vector<int>A,J,F,G;vector<vector<int>>P;
 vector<array<int,3>>trail;vector<unsigned>reasonF,reasonG;unsigned assigned=0;long long calls=0,leaves=0,backjumps=0;Clock::time_point started;double limit;
 StreamEngine(const vector<Row>&rs,const vector<int>&a,int budget,double seconds):rows(rs),r(a.size()),s(budget),A(a),J(r,-1),F(r,-1),G(r,-1),started(Clock::now()),limit(seconds){
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
int main(int argc,char**argv){try{require(argc>=6,"usage: samples maps s seconds_per_case begin [end]");auto rows=read(argv[1]);ifstream f(argv[2]);int r,count;require(bool(f>>r>>count)&&r>0&&r<16&&count>0,"map header");vector<vector<int>>maps(count,vector<int>(r));for(auto&a:maps){for(int&x:a)require(bool(f>>x)&&x>=0&&x<r,"map entry");require(a[0]==0,"root not fixed");}string junk;require(!(f>>junk),"map trailing data");int s=stoi(argv[3]),begin=stoi(argv[5]),end=argc>6?stoi(argv[6]):count;require(0<=begin&&begin<=end&&end<=count,"case range");double seconds=stod(argv[4]);auto start=Clock::now();
 for(int i=begin;i<end;i++){auto st=Clock::now();StreamEngine e(rows,maps[i],s,seconds);string status;try{status=e.run()?"SAT":"UNSAT";}catch(Stop&){status="UNKNOWN";}cout<<"{\"shape\":"<<i<<",\"r\":"<<r<<",\"s\":"<<s<<",\"status\":\""<<status<<"\",\"nodes\":"<<e.calls<<",\"leaves\":"<<e.leaves<<",\"backjumps\":"<<e.backjumps<<",\"seconds\":"<<chrono::duration<double>(Clock::now()-st).count()<<"}\n"<<flush;if(status=="SAT"){e.model(cerr);break;}}
 cerr<<"elapsed "<<chrono::duration<double>(Clock::now()-start).count()<<"\n";
 }catch(exception&e){cerr<<e.what()<<"\n";return 2;}}
