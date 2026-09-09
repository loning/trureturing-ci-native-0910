"""Memory-aware query scheduling with shared cancellation and deterministic inputs."""

from concurrent.futures import FIRST_COMPLETED, ThreadPoolExecutor, wait
from threading import Event

from resources import free_memory


def query_capacity(free_percent):
    return 3 if free_percent >= 40 else 1


def query_results(jobs, work, record):
    pending = iter(jobs)
    active = {}
    cancelled = Event()
    exhausted = False
    with ThreadPoolExecutor(max_workers=3) as pool:
        try:
            while active or not exhausted:
                free = free_memory()
                capacity = query_capacity(free)
                while len(active) < capacity and not exhausted:
                    job = next(pending, None)
                    if job is None:
                        exhausted = True
                        break
                    active[pool.submit(work, job, cancelled)] = job
                    record(job, len(active), capacity, free)
                if not active:
                    continue
                done, _ = wait(active, timeout=0.2, return_when=FIRST_COMPLETED)
                for future in done:
                    job = active.pop(future)
                    yield job, future.result()
        finally:
            cancelled.set()
            for future in active:
                future.cancel()
