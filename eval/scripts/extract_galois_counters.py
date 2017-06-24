#!/usr/bin/env python

import argparse
import bmk2.logproc
import sys
import pandas as pd

class RunData(object):
    def __init__(self):
        self.entries = []
        self.status = None

def get_run_data(log):
    rd = None
    for le in bmk2.logproc.parse_log_file(log, True):
        if le.type == 'RUN_BEGIN':
            if rd: yield rd
            rd = RunData()
        elif le.type == 'PASS' or le.type == 'FAIL':
            if rd:
                rd.status = le.type
        elif le.type == 'PERF':
            if rd:
                rd.perf = le
            
        if rd:
            rd.entries.append(le)

def extract_galois_csv(run_lines):
    hdrs = None
    out = []
    in_stdout = False
    in_csv = False

    for l in run_lines:
        if l.type == 'GENERIC_LOG' and l.loglevel == 'INFO' and l.raw[-7:] == 'STDOUT\n':
            in_stdout = True

        if l.type == 'UNMATCHED':
            if in_csv:
                if l.raw == '\n':
                    in_csv = False                    
                else:
                    assert "*** SQUASHED ***" not in l.raw, l # data is incomplete
                    ls = l.raw.strip().split(",")
                    out.append(ls)
    
            if in_stdout:
                if 'LOOP,INSTANCE,CATEGORY,THREAD,HOST,VAL\n' == l.raw:
                    assert hdrs is None, hdrs # duplicate?
                    hdrs = l.raw.strip().split(",")
                    in_csv = True

    assert len(out) > 0, out
    return pd.DataFrame(out, columns = hdrs)

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Extract Galois metrics from bmk2 log files")
    p.add_argument("logfiles", nargs="+", help="bmk2 log files")
    p.add_argument("-o", dest='output', help="Output")

    args = p.parse_args()

    for lf in args.logfiles:
        for rd in get_run_data(lf):
            if rd.status != 'FAIL':
                df = extract_galois_csv(rd.entries)
                df['xid'] = rd.perf.xid
                df['binid'] = rd.perf.binid
                print df
