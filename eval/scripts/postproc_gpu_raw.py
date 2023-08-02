#!/usr/bin/env python

import argparse
import bmk2.mapfile
import pandas as pd
import sys
import npreader2.dbreader

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Postprocess raw GPU metrics (power, data transfer time, etc.) for each experiment")
    p.add_argument("rawcsv", help="Raw csv filename")
    p.add_argument("-o", dest='output', help="Output")

    args = p.parse_args()
    df = pd.read_csv(args.rawcsv)

    df['meminfo_bytes'] = df['instr_gpu_memory_free_start'] - df['instr_gpu_memory_free_end'] 

    if args.output:
        df.to_csv(args.output, index=False)
    else:
        df.to_csv(sys.stdout, index=False)
