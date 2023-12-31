#!/usr/bin/env python
# 
# Graph challenge metrics

#* Total number of edges in the given graph: This measures the amount of data processed
#* Execution time: Total time required to count the triangles or compute the k-truss of the given graph. Time required for reading graph data from a file is not included in this time
# TODO: execution time (transferring graph?)
#* Rate: Measures the throughput of the implementation as the ratio of the number of edges in the graph to the execution time
#* Energy: Total amount of energy consumption in watts for the computation
#* Rate per energy (edges/second/Watt): Measures the throughput achieved per unit of energy consumed
# Memory: Specifies the amount of memory required for the computation
#    TODO: compute memory
#* Processor: Number and type of processors used in the computation

import argparse
import pandas as pd

p = argparse.ArgumentParser(description="Compute Graph Challenge metrics for GPU")
p.add_argument("perfcsv", help="Performance CSV (from bmk2)")
p.add_argument("metricscsv", help="Metrics CSV")
p.add_argument("inputdescsv", help="Input description CSV")
p.add_argument("--na", dest="no_adjust", action="store_true", help="Do not adjust time")
p.add_argument("-o", dest="output", help="Output file")

args = p.parse_args()

perf = pd.read_csv(args.perfcsv)
metc = pd.read_csv(args.metricscsv)

inpd = pd.read_csv(args.inputdescsv)

perf = perf.merge(inpd, 'left', on='input')
perf = perf.merge(metc[["bmk", "variant", "input", "energy_joules_2_avg", "energy_joules_2_sd", "energy_joules_2_count",
                        "data_transfer_ns_avg", "data_transfer_ns_sd", "data_transfer_ns_count",
                        "malloc_ns_avg", "malloc_ns_sd", "malloc_ns_count",
                    ]], 'left', on=['bmk', 'variant', 'input'], suffixes=('', '_y'))

if args.no_adjust:
    perf["adj_time_ns_avg"] = perf["time_ns_avg"]
else:
    perf["adj_time_ns_avg"] = perf["time_ns_avg"] + perf["data_transfer_ns_avg"] + perf["malloc_ns_avg"]    

perf["energy_joules_avg"] = perf["energy_joules_2_avg"]
perf['rate_eps'] = perf['edges'] * 1E9 / perf['adj_time_ns_avg']
perf['rate_per_energy'] = perf['rate_eps'] / perf['energy_joules_2_avg']

if args.output:
    perf.to_csv(args.output, index=False)
else:
    print perf


