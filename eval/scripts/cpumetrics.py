#!/usr/bin/env python
# 
# Graph challenge metrics

#* Total number of edges in the given graph: This measures the amount of data processed
#* Execution time: Total time required to count the triangles or compute the k-truss of the given graph. Time required for reading graph data from a file is not included in this time
#* Rate: Measures the throughput of the implementation as the ratio of the number of edges in the graph to the execution time
#* Energy: Total amount of energy consumption in watts for the computation
#* Rate per energy (edges/second/Watt): Measures the throughput achieved per unit of energy consumed
# Memory: Specifies the amount of memory required for the computation
#* Processor: Number and type of processors used in the computation

import argparse
import pandas as pd

p = argparse.ArgumentParser(description="Compute Graph Challenge metrics for CPU")
p.add_argument("perfcsv", help="Performance CSV (from bmk2)")
#p.add_argument("metricscsv", help="Metrics CSV")
p.add_argument("inputdescsv", help="Input description CSV")

p.add_argument("-o", dest="output", help="Output file")

args = p.parse_args()

perf = pd.read_csv(args.perfcsv)
#metc = pd.read_csv(args.metricscsv)

inpd = pd.read_csv(args.inputdescsv)

perf = perf.merge(inpd, 'left', on='input')

perf['energy_ujoules_avg'] = perf[['instr_intel-rapl:0_avg','instr_intel-rapl:0:0_avg','instr_intel-rapl:1_avg','instr_intel-rapl:1:0_avg']].sum(axis=1)
perf['energy_joules_avg'] = perf['energy_ujoules_avg'] / 1E6

#perf = perf.merge(metc[["bmk", "variant", "input", "energy_joules_2_avg", "energy_joules_2_sd", "energy_joules_2_count",
#                        "data_transfer_ns_avg", "data_transfer_ns_sd", "data_transfer_ns_count",
#                        "malloc_ns_avg", "malloc_ns_sd", "malloc_ns_count",
#                    ]], 'left', on=['bmk', 'variant', 'input'])

if "preprocess_time_ms_avg" in perf.columns:
    perf["adj_time_ns_avg"] = perf["time_ns_avg"] + perf["preprocess_time_ms_avg"] * 1E3
    TIME = "adj_time_ns_avg"
else:
    TIME = "time_ns_avg"

perf['rate_eps'] = perf['edges'] * 1E9 / perf[TIME]
perf['rate_per_energy'] = perf['rate_eps'] / perf['energy_joules_avg']

if args.output:
    perf.to_csv(args.output, index=False)
else:
    print perf


