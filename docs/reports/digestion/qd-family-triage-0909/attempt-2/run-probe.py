from pathlib import Path
import subprocess,sys,time,shutil,json,gzip,base64
attempt=Path(__file__).parent
name,source=sys.argv[1:]
assert name and (attempt/source).is_file()
out=Path.cwd()/'docs/reports/digestion/qd-family-triage-0909/attempt-2'
shutil.copyfile(attempt/source,out/(name+'.lean'))
cmd=['make','-f','Makefile','-f',str(attempt/'probe.mk'),'lean','PROBE='+str(attempt/source)]
start=time.monotonic()
with (attempt/(name+'.log')).open('w') as log:
 log.write('COMMAND: '+json.dumps(cmd)+'\n');log.flush()
 r=subprocess.run(cmd,stdout=log,stderr=subprocess.STDOUT)
 seconds=time.monotonic()-start
 log.write('\nEXIT='+str(r.returncode)+'\nSECONDS='+str(seconds)+'\n')
raw=(attempt/(name+'.log')).read_bytes()
if len(raw)>1000000:
 (out/(name+'.log.gz.b64')).write_bytes(base64.encodebytes(gzip.compress(raw,mtime=0)))
 lines=raw.decode().splitlines()
 excerpt=[x for x in lines if x.startswith(('COMMAND:', 'LEAN_CACHE', chr(39), 'Build completed', 'EXIT=', 'SECONDS='))]
 (out/(name+'-excerpt.txt')).write_text('\n'.join(excerpt)+'\n')
else:
 shutil.copyfile(attempt/(name+'.log'),out/(name+'.log'))
(attempt/(name+'.exit')).write_text(str(r.returncode)+'\n')
print(name,'EXIT='+str(r.returncode),'SECONDS='+str(seconds),flush=True)
sys.exit(r.returncode)
