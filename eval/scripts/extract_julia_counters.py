#!/usr/bin/env python

import argparse
import bmk2.logproc
import sys
import pandas as pd
import extract_galois_counters  as egc
import re

# 925.668471 seconds (32.81 M allocations: 3.615 GiB, 0.16% gc time)
M_RE = re.compile(r" *[0-9]+\.[0-9]+ seconds \((?P<alloc>[0-9]+\.[0-9]+) (?P<alloc_unit>.) allocations: (?P<mem>[0-9]+\.[0-9]+) (?P<memunit>[^,]+), [0-9]+\.[0-9]+% gc time\)")

UNITS = {'M': 1E6, 'K': 1E3, 'G': 1E9}
UNITS_BIN = {'MiB': 1024*1024, 'GiB': 1024*1024*1024, 'KiB': 1024}

def extract_relevant_counters(entries):
    for e in entries:
        m = M_RE.match(e.raw)
        if m is not None:
            o = {}
            o['alloc_raw'] = float(m.group('alloc'))
            o['alloc_unit'] = m.group('alloc_unit')
            o['memory_raw'] = float(m.group('mem'))            
            o['memory_unit'] = m.group('memunit')
            o['meminfo_bytes'] = o['memory_raw'] * UNITS_BIN[o['memory_unit']]
            o['alloc'] = o['alloc_raw'] * UNITS[o['alloc_unit']]
            
            return o
            
    return {}

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Extract Julia metrics from bmk2 log files")
    p.add_argument("logfiles", nargs="+", help="bmk2 log files")
    p.add_argument("-o", dest='output', help="Output")

    args = p.parse_args()
    
    out = []
    for lf in args.logfiles:
        for rd in egc.get_run_data(lf):
            if rd.status != 'FAIL' and hasattr(rd, 'perf'):
                o = extract_relevant_counters(rd.entries)
                o.update({'xid': rd.perf.xid, 'run': rd.perf.run, 'binid': rd.perf.binid})
                out.append(o)

    if args.output:
        pd.DataFrame(out).to_csv(args.output, index=False)
    else:
        pd.DataFrame(out).to_csv(sys.stdout, index=False)
        
