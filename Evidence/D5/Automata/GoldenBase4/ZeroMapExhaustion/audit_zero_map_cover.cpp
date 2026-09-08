// Exhaustive labelled-map coverage; uses the existing canonicalizer only to
// propose witnesses. Every permutation and every conjugacy edge is checked.
#define main existing_enumerator_main
#include "enumerate_zero_maps.cpp"
#undef main
int main(int argc,char**argv){try{
 if(argc!=4)throw runtime_error("usage: maps begin end");
 ifstream in(argv[1]);int r,count;
 if(!(in>>r>>count)||r<1||r>10||count<1)throw runtime_error("map header");
 unordered_set<string>allowed;
 for(int i=0;i<count;i++){string row;for(int j=0;j<r;j++){int x;if(!(in>>x)||x<0||x>=r)throw runtime_error("bad entry");row+=char(x);}if(row[0]!=0)throw runtime_error("root");if(!allowed.insert(row).second)throw runtime_error("duplicate representative");}
 string extra;if(in>>extra)throw runtime_error("trailing data");
 long long total=1;for(int i=1;i<r;i++)total*=r;
 long long begin=stoll(argv[2]),end=stoll(argv[3]);if(begin<0||begin>end||end>total)throw runtime_error("range");
 vector<int>A(r);long long checked=0;auto start=chrono::steady_clock::now();
 for(long long z=begin;z<end;z++){auto t=z;A[0]=0;for(int i=1;i<r;i++){A[i]=t%r;t/=r;}
  Canon c(A);string key=c.run();if(key.size()!=size_t(r))throw runtime_error("witness size");if(!allowed.count(key))throw runtime_error("missing representative");
  vector<int>seen(r);if(c.p[0]!=0)throw runtime_error("root moved");
  for(int i=0;i<r;i++){if(c.p[i]<0||c.p[i]>=r||seen[c.p[i]]++)throw runtime_error("not permutation");if((unsigned char)key[c.p[i]]!=c.p[A[i]])throw runtime_error("not conjugacy");}
  checked++;
 }
 cout<<"{\"status\":\"PASS\",\"r\":"<<r<<",\"begin\":"<<begin<<",\"end\":"<<end<<",\"total_labelled_maps\":"<<total<<",\"representatives\":"<<count<<",\"verified_conjugacies\":"<<checked<<",\"seconds\":"<<chrono::duration<double>(chrono::steady_clock::now()-start).count()<<"}\n";
}catch(exception&e){cerr<<e.what()<<"\n";return 2;}}
