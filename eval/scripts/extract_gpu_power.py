#!/usr/bin/env python

import gpu_power
import argparse
import bmk2.mapfile
import pandas as pd
import sys

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Extract power for each experiment")
    p.add_argument("mapfile", help="Mapfile from bmk2 collect")
    p.add_argument("-o", dest='output', help="Output")

    args = p.parse_args()
    out = []
    for me in bmk2.mapfile.read_mapfile(args.mapfile):
        #print me
        if me.filetype == "cuda/nvprof":
            s = gpu_power.get_gpu_power_samples(me.abspath)
            if len(s):
                e = gpu_power.get_gpu_energy(s)
                x,r = bmk2.mapfile.split_runid(me.runid)
                o = {'xid': x,
                     'run': r,
                     'energy_joules_1': e[0],
                     'energy_joules_2': e[1],
                     'nvprof_filename': me.filename}

                out.append(o)
    
    of = pd.DataFrame(out)
    if args.output:
        of.to_csv(args.output, index=False)
    else:
        of.to_csv(sys.stdout, index=False)
