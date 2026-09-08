"""Recompute the complete (9,6) exclusion. No network or reference DFAO.
A completed output inventory is mandatory; timeouts never establish a bound.
"""
from pathlib import Path
import argparse,json,os,subprocess,sys,hashlib

def main():
    ap=argparse.ArgumentParser();ap.add_argument('output',type=Path);ap.add_argument('--workers',type=int,default=4);ap.add_argument('--case-limit',type=float,default=600)
    args=ap.parse_args();out=args.output.resolve();out.mkdir(parents=True,exist_ok=True);here=Path(__file__).resolve().parent
    if args.workers<1 or args.case_limit<=0:raise SystemExit('positive workers and case limit required')
    cxx=os.environ.get('CXX','g++')
    targets={'anchored_maps':'anchored_maps.cpp','verify_cover':'verify_anchored_cover.cpp','backjump_search':'backjump_search.cpp','test_engines':'test_engines.cpp','check_explanations':'check_explanations.cpp'}
    for target,source in targets.items():subprocess.run([cxx,'-O3','-std=c++17',str(here/source),'-o',str(out/target)],check=True)
    def capture(command,name):
        with open(out/name,'w') as stream:subprocess.run(command,stdout=stream,check=True)
    capture([sys.executable,str(here/'power_samples.py'),'250',str(out/'powers250.txt')],'sample_generation.json')
    capture([str(out/'anchored_maps'),'9',str(out)],'map_generation.jsonl')
    expected={'powers250.txt':'a2d1b327acec426636919de6eb6fd86f5ec2efa4df40e92b0a5afbf6304fa4e0','maps9.txt':'ac5ddf4a36f4909c5ab29aebab94434c94a1a9bd13f20cfd742354d79fb3b1d3'}
    for name,digest in expected.items():
        if hashlib.sha256((out/name).read_bytes()).hexdigest()!=digest:raise RuntimeError('regenerated input changed: '+name)
    capture([str(out/'verify_cover'),str(out/'maps9.txt')],'coverage9.json')
    capture([str(out/'test_engines')],'engine_controls.json')
    capture([str(out/'check_explanations')],'explanation_validation.json')
    capture([sys.executable,str(here/'run_ranges.py'),str(out),'9','6',str(args.workers),str(args.case_limit),'complete9'],'complete9.log')
    subprocess.run([sys.executable,str(here/'audit_case_records.py'),str(out/'complete9'),str(out/'complete9.log'),'9','6','2598',str(out/'audited')],check=True)
    print((out/'audited/summary.json').read_text())
if __name__=='__main__':main()
