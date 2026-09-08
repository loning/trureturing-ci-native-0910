"""Validate exact range coverage. Mathematical rechecking reruns the search.
This inventory checker does not treat arbitrary UNSAT strings as certificates.
"""
from pathlib import Path
import hashlib,json

def audit(folder: Path, log: Path, r: int, s: int, count: int):
    expected=[(a,min(a+50,count)) for a in range(0,count,50)]
    statuses={}
    for line in log.read_text().splitlines():
        value=json.loads(line)
        if 'exit_code' in value:
            key=(value['begin'],value['end'])
            if key in statuses:raise ValueError('duplicate process range')
            statuses[key]=value['exit_code']
    if set(statuses)!=set(expected) or any(statuses.values()):raise ValueError('uncompleted process range')
    records=[]
    for a,b in expected:
        part=[json.loads(line) for line in (folder/f'{a}_{b}.jsonl').read_text().splitlines()]
        if [x['shape'] for x in part]!=list(range(a,b)):raise ValueError('missing or repeated case')
        for x in part:
            if x['r']!=r or x['s']!=s or x['status']!='UNSAT':raise ValueError('case is not the completed target exclusion')
            if min(x['nodes'],x['leaves'],x['backjumps'])<0:raise ValueError('invalid counter')
        records+=part
    summary=dict(status='COMPLETE_EXTERNAL_EXCLUSION',r=r,s=s,sample_indices=[0,249],
        expected_cases=count,completed_cases=len(records),completed_process_ranges=len(statuses),
        all_process_exit_codes_zero=True,all_cases_unsat=True,sat_cases=[],unknown_cases=[],
        search_calls=sum(x['nodes'] for x in records),rejected_branches=sum(x['leaves'] for x in records),
        backjumps=sum(x['backjumps'] for x in records),
        lean_executed=False,standard_sat_proof_log_emitted=False,
        verification='Exact exhaustive program with conflict-support argument; independently recompute to verify numerical verdicts.')
    return records,summary

if __name__=='__main__':
    import argparse
    a=argparse.ArgumentParser();a.add_argument('folder',type=Path);a.add_argument('log',type=Path);a.add_argument('r',type=int);a.add_argument('s',type=int);a.add_argument('count',type=int);a.add_argument('output',type=Path);x=a.parse_args()
    records,summary=audit(x.folder,x.log,x.r,x.s,x.count)
    x.output.mkdir(parents=True,exist_ok=True)
    (x.output/'cases.jsonl').write_text(''.join(json.dumps(row,sort_keys=True)+'\n' for row in records))
    summary['case_records_sha256']=hashlib.sha256((x.output/'cases.jsonl').read_bytes()).hexdigest()
    (x.output/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps(summary,indent=2))
