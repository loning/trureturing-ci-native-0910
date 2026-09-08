"""Exhaustive small partial-skeleton checks of recurrent-state conjugacy.

This independently checks the algebra used by explicit zero-map witnesses.
It is neither a Lean execution nor a numerical lower-bound certificate.
Only Python's standard library is used.
"""
from itertools import product, permutations
import json


def evaluate(start, zero, sig, output, blocks, terminal):
    q=start
    for b in blocks:
        if b==0:q=zero[q]
        else:q=None if sig[q] is None else sig[q][1]
        if q is None:return None
    return output[q] if terminal==0 else None if sig[q] is None else sig[q][0]


def run():
    words=[w for n in range(4) for w in product((0,1),repeat=n)]
    models=renamings=identities=undefined=0
    for r in (1,2):
        targets=[None]+list(range(r))
        signatures=[None]+list(product(range(4),targets))
        for zero,sig,output in product(product(targets,repeat=r),
                product(signatures,repeat=r),product(range(4),repeat=r)):
            models+=1
            old_cost=r+len(set(x for x in sig if x is not None))
            for p in permutations(range(r)):
                inverse=[p.index(q) for q in range(r)]
                mapped_zero=[None if zero[inverse[q]] is None else p[zero[inverse[q]]] for q in range(r)]
                mapped_sig=[None if sig[inverse[q]] is None else
                    (sig[inverse[q]][0],None if sig[inverse[q]][1] is None else p[sig[inverse[q]][1]]) for q in range(r)]
                mapped_output=[output[inverse[q]] for q in range(r)]
                if old_cost!=r+len(set(x for x in mapped_sig if x is not None)):
                    raise ValueError('canonical cost changed')
                renamings+=1
                for word,terminal in product(words,(0,1)):
                    before=evaluate(0,zero,sig,output,word,terminal)
                    after=evaluate(p[0],mapped_zero,mapped_sig,mapped_output,word,terminal)
                    if before!=after:raise ValueError('evaluation changed')
                    identities+=1;undefined+=before is None
    # Moving the carrier while leaving a return unchanged must fail.
    p=[1,0];zero=[0,1];sig=[(2,1),(3,0)];out=[0,1]
    wrong_sig=[sig[1],sig[0]]
    if evaluate(0,zero,sig,out,(1,),0)==evaluate(1,[0,1],wrong_sig,[1,0],(1,),0):
        raise ValueError('wrong-return mutation undetected')
    return dict(status='PASS',partial_skeletons=models,renamings=renamings,
        evaluation_equalities=identities,undefined_cases=undefined,
        exact_cost_checked=True,wrong_return_rejected=True,
        lean_executed=False,new_numerical_lower_bound=False)

if __name__=='__main__':print(json.dumps(run(),indent=2))
