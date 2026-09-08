"""Execute explicit, disjoint case ranges; aggregate only completed JSON rows."""
import concurrent.futures as cf,json,pathlib,subprocess,sys,time
root=pathlib.Path(sys.argv[1]);r=int(sys.argv[2]);s=int(sys.argv[3]);workers=int(sys.argv[4]);cap=float(sys.argv[5]);tag=sys.argv[6];binary=sys.argv[7] if len(sys.argv)>7 else 'backjump_search'
count=int((root/f'maps{r}.txt').read_text().split()[1]);folder=root/tag;folder.mkdir(exist_ok=True)
ranges=[(a,min(a+50,count)) for a in range(0,count,50)]
def run(pair):
 a,b=pair;command=[str(root/binary),str(root/'powers250.txt'),str(root/f'maps{r}.txt'),str(s),str(cap),str(a),str(b)]
 with open(folder/f'{a}_{b}.jsonl','w') as out,open(folder/f'{a}_{b}.log','w') as err:
  result=subprocess.run(command,stdout=out,stderr=err)
 return {'begin':a,'end':b,'exit_code':result.returncode}
with cf.ThreadPoolExecutor(workers) as pool:
 for result in pool.map(run,ranges):
  print(json.dumps(result),flush=True)
allrows=[]
for a,b in ranges:
 rows=[json.loads(x) for x in (folder/f'{a}_{b}.jsonl').read_text().splitlines()];allrows+=rows
observed={x['shape']:x for x in allrows}
complete=set(observed)==set(range(count)) and len(observed)==len(allrows)
report={'r':r,'s':s,'expected':count,'completed':len(observed),'complete':complete,'all_unsat':complete and all(x['status']=='UNSAT' for x in allrows),'SAT':[x['shape'] for x in allrows if x['status']=='SAT'],'UNKNOWN':[x['shape'] for x in allrows if x['status']=='UNKNOWN'],'nodes':sum(x['nodes'] for x in allrows),'leaves':sum(x['leaves'] for x in allrows)}
(folder/'summary.json').write_text(json.dumps(report,indent=2));print(json.dumps(report),flush=True)
