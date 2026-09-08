// Independent exhaustive fixed-zero-map checker on compressed zero-run traces.
// Every A^k(J(q)) edge is derived from an actual Fibonacci power input.
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
using namespace std;using boost::multiprecision::cpp_int;
void require(bool b,const string&m){if(!b)throw runtime_error(m);}
cpp_int root(cpp_int n){if(n==0)return 0;cpp_int x=1;x<<=((boost::multiprecision::msb(n)+2)/2);for(;;){cpp_int y=(x+n/x)/2;if(y>=x)return x;x=y;}}
cpp_int golden(cpp_int n){return (n+root(5*n*n))/2;}
struct Vertex{map<int,int>edges;array<int,2>label={-1,-1};};
struct Observation{int n,d,terminal;vector<int>ks;};
vector<Vertex> read(const string&fn){ifstream f(fn);require(bool(f),"sample missing");vector<Vertex>v(1);v[0].label[0]=0;string line;int rows=0;while(getline(f,line)){
 istringstream in(line);Observation o;require(bool(in>>o.n>>o.d>>o.terminal),"malformed row");require(o.n==rows&&o.d>=0&&o.d<4&&(o.terminal==0||o.terminal==1),"row header");int k;while(in>>k){require(k>=0,"negative zeros");o.ks.push_back(k);}require(in.eof(),"trailing syntax");
 cpp_int q=0,z=0;auto bit=[&](int b){cpp_int next=z+b;z=q+z+2*b;q=next;};int at=0;
 for(int k:o.ks){bit(1);bit(0);for(int j=0;j<k;j++)bit(0);auto it=v[at].edges.find(k);if(it==v[at].edges.end()){int child=v.size();v[at].edges[k]=child;v.emplace_back();at=child;}else at=it->second;}
 if(o.terminal)bit(1);require(q==(cpp_int(1)<<(2*o.n)),"wrong power word");require(golden(4*q)-4*golden(q)==o.d,"wrong exact digit");require(v[at].label[o.terminal]==-1||v[at].label[o.terminal]==o.d,"label conflict");v[at].label[o.terminal]=o.d;rows++;
 }require(rows==250,"incomplete sample set");cerr<<"validated powers="<<rows<<" compressed_vertices="<<v.size()<<"\n";return v;}
struct Stop{};
struct Engine{
 const vector<Vertex>&v;int r,s;vector<int>A,J;vector<array<int,2>>O;vector<vector<int>>power;vector<vector<pair<int,int>>>wait;vector<array<int,3>>undo;vector<pair<int,int>>todo;long long calls=0,leaves=0;chrono::steady_clock::time_point start;double timeout;
 Engine(const vector<Vertex>&vs,const vector<int>&a,int cap,chrono::steady_clock::time_point st,double secs):v(vs),r(a.size()),s(cap),A(a),J(r,-1),O(r,{-1,-1}),wait(r),start(st),timeout(secs){
 int maxk=0;for(auto&x:v)if(!x.edges.empty())maxk=max(maxk,x.edges.rbegin()->first);power.assign(maxk+1,vector<int>(r));iota(power[0].begin(),power[0].end(),0);for(int k=1;k<=maxk;k++)for(int q=0;q<r;q++)power[k][q]=A[power[k-1][q]];
 }
 bool extend(){while(!todo.empty()){
 auto[node,q]=todo.back();todo.pop_back();for(int c=0;c<2;c++)if(v[node].label[c]>=0){int d=v[node].label[c];if(O[q][c]>=0){if(O[q][c]!=d)return false;}else{O[q][c]=d;undo.push_back({c,q,-1});}}
 for(auto[k,child]:v[node].edges)if(J[q]>=0)todo.emplace_back(child,power[k][J[q]]);else{wait[q].emplace_back(child,k);undo.push_back({2,q,-1});}
 }return true;}
 int necessary(){array<bool,4>og{},o{};array<bool,16>tg{},t{};array<bool,64>pairs{};int total=0;for(int q=0;q<r;q++){if(O[q][1]>=0&&J[q]>=0){int z=O[q][1]*r+J[q];if(!pairs[z]){pairs[z]=true;total++;}og[O[q][1]]=true;tg[J[q]]=true;}else{if(O[q][1]>=0)o[O[q][1]]=true;if(J[q]>=0)t[J[q]]=true;}}int a=0,b=0;for(int d=0;d<4;d++)a+=o[d]&&!og[d];for(int q=0;q<r;q++)b+=t[q]&&!tg[q];return total+max(a,b);}
 void restore(size_t mark){todo.clear();while(undo.size()>mark){auto[k,q,b]=undo.back();undo.pop_back();if(k<2)O[q][k]=b;else if(k==2)wait[q].pop_back();else J[q]=b;}}
 bool solve(){calls++;if((calls&1023)==0&&chrono::duration<double>(chrono::steady_clock::now()-start).count()>timeout)throw Stop{};
 if(!extend()||necessary()>s){leaves++;return false;}int q=-1;for(int p=0;p<r;p++)if(J[p]<0&&!wait[p].empty()&&(q<0||wait[p].size()>wait[q].size()))q=p;if(q<0)return true;
 size_t mark=undo.size();for(int j=0;j<r;j++){undo.push_back({3,q,-1});J[q]=j;for(auto[node,k]:wait[q])todo.emplace_back(node,power[k][j]);if(solve())return true;restore(mark);}return false;}
 bool run(){todo.emplace_back(0,0);return solve();}
};
int main(int argc,char**argv){try{require(argc>=6,"usage: samples maps s seconds begin [end]");auto v=read(argv[1]);ifstream f(argv[2]);int r,count;require(bool(f>>r>>count)&&r>0&&r<16&&count>0,"map header");vector<vector<int>>maps(count,vector<int>(r));for(auto&a:maps){for(int&x:a)require(bool(f>>x)&&x>=0&&x<r,"map entry");require(a[0]==0,"root not fixed");}string junk;require(!(f>>junk),"map trailing data");int s=stoi(argv[3]),begin=stoi(argv[5]),end=argc>6?stoi(argv[6]):count;require(0<=begin&&begin<=end&&end<=count,"case range");double seconds=stod(argv[4]);auto st=chrono::steady_clock::now();long long calls=0,leaves=0;int done=0;string status="UNSAT";
 for(int i=begin;i<end;i++){Engine e(v,maps[i],s,st,seconds);try{bool sat=e.run();calls+=e.calls;leaves+=e.leaves;if(sat){status="SAT";cerr<<"satisfiable map "<<i<<"\n";break;}done++;}catch(Stop&){calls+=e.calls;leaves+=e.leaves;status="UNKNOWN";break;}if((i-begin)%25==0)cerr<<"done "<<i+1<<" calls "<<calls<<" seconds "<<chrono::duration<double>(chrono::steady_clock::now()-st).count()<<"\n";}
 cout<<"{\"status\":\""<<status<<"\",\"r\":"<<r<<",\"s\":"<<s<<",\"begin\":"<<begin<<",\"end\":"<<end<<",\"completed_shapes\":"<<done<<",\"nodes\":"<<calls<<",\"conflicts\":"<<leaves<<",\"seconds\":"<<chrono::duration<double>(chrono::steady_clock::now()-st).count()<<"}\n";
 }catch(exception&e){cerr<<e.what()<<"\n";return 2;}}
