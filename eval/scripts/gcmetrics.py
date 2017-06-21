#!/usr/bin/env python
# 
# Graph challenge metrics

# Total number of edges in the given graph: This measures the amount of data processed
# Execution time: Total time required to count the triangles or compute the k-truss of the given graph. Time required for reading graph data from a file is not included in this time
# Rate: Measures the throughput of the implementation as the ratio of the number of edges in the graph to the execution time
# Energy: Total amount of energy consumption in watts for the computation
# Rate per energy (edges/second/Watt): Measures the throughput achieved per unit of energy consumed
# Memory: Specifies the amount of memory required for the computation
# Processor: Number and type of processors used in the computation

import argparse
import pandas as pd

p = argparse.ArgumentParser(description="Compute Graph Challenge metrics")
p.add_argument("perfcsv", help="Performance CSV (from bmk2)")
p.add_argument("inputdescsv", help="Input description CSV")
#p.add_argument("powercsv"
p.add_argument("-o", dest="output", help="Output file")

args = p.parse_args()

perf = pd.read_csv(args.perfcsv)
inpd = pd.read_csv(args.inputdescsv)

perf = perf.merge(inpd, 'left', on='input')

perf['rate_eps'] = perf['edges'] * 1E9 / perf['time_ns_avg']

if args.output:
    perf.to_csv(args.output, index=False)
else:
    print perf


