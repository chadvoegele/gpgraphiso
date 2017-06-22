#!/usr/bin/env python

import gpu_metrics
import argparse
import bmk2.mapfile
import pandas as pd
import sys
import npreader2.dbreader

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Extract GPU metrics (power, data transfer time, etc.) for each experiment")
    p.add_argument("mapfile", help="Mapfile from bmk2 collect")
    p.add_argument("-o", dest='output', help="Output")

    args = p.parse_args()
    out = []
    for me in bmk2.mapfile.read_mapfile(args.mapfile):
        if me.filetype == "cuda/nvprof":
            nvp = npreader2.dbreader.NVProfile(me.abspath)
            dt = gpu_metrics.get_data_transfer_times(nvp)

            s = gpu_metrics.get_gpu_power_samples(nvp)
            assert len(s)           

            e = gpu_metrics.get_gpu_energy(s)
            x,r = bmk2.mapfile.split_runid(me.runid)
            o = {'xid': x,
                 'run': r,
                 'energy_joules_1': e[0],
                 'energy_joules_2': e[1],
                 'nvprof_filename': me.filename,
                 'data_transfer_ns': dt}
            
            out.append(o)
    
    of = pd.DataFrame(out)
    if args.output:
        of.to_csv(args.output, index=False)
    else:
        of.to_csv(sys.stdout, index=False)
