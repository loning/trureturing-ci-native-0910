// Independently check coverage by visiting every labelled anchored map.
// Canon is used only to propose a permutation; its defining equations and
// membership in the supplied finite representative list are checked explicitly.
#define main anchored_generation_main
#include "anchored_maps.cpp"
#undef main
#include <chrono>
int main(int argc,char**argv){try{
 req(argc==2,"usage: verify_anchored_cover map_file");ifstream in(argv[1]);int r,count;req(bool(in>>r>>count)&&r>=1&&r<=9&&count>0,"header");set<string>allowed;for(int i=0;i<count;++i){string row;for(int j=0;j<r;++j){int x;req(bool(in>>x)&&x>=0&&x<r,"map entry");row+=char(x);}req(row[0]==0,"root not fixed");req(allowed.insert(row).second,"duplicate representatives");}string garbage;req(!(in>>garbage),"trailing data");
 uint64_t total=1;for(int i=1;i<r;++i)total*=r;vector<int>A(r);auto start=chrono::steady_clock::now();
 for(uint64_t code=0;code<total;++code){auto remaining=code;A[0]=0;for(int i=1;i<r;++i){A[i]=remaining%r;remaining/=r;}Canon proposed(A);auto target=proposed.run();req(allowed.count(target)==1,"missing representative");vector<int>seen(r);req(proposed.p[0]==0,"root moved");for(int i=0;i<r;++i){int p=proposed.p[i];req(p>=0&&p<r&&!seen[p]++,"invalid permutation");req((unsigned char)target[p]==proposed.p[A[i]],"failed conjugacy");}
  if(code&&code%5000000==0)cerr<<"checked "<<code<<"\n";
 }
 cout<<"{\"status\":\"PASS\",\"r\":"<<r<<",\"raw_maps\":"<<total<<",\"representatives\":"<<count<<",\"verified_conjugacies\":"<<total<<",\"seconds\":"<<chrono::duration<double>(chrono::steady_clock::now()-start).count()<<"}\n";
}catch(exception&e){cerr<<e.what()<<"\n";return 2;}}
