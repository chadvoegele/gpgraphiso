#!/usr/bin/env python

import argparse
import pandas as pd
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

p = argparse.ArgumentParser(description="Plot rate in eps")
p.add_argument("inputs", nargs="+")
p.add_argument("-l", dest="labels", action="append")
p.add_argument("-t", dest="title")
p.add_argument("-e", dest="energy", action="store_true")

args = p.parse_args()

out = pd.DataFrame()

for lbl, i in zip(args.labels, args.inputs):
    f = pd.read_csv(i)
    f["lbl"] = lbl
    out = out.append(f[["input", "lbl", "edges", "rate_per_energy", "energy_joules_avg"]])

out = out.set_index(["edges", "input", "lbl"])
out = out.unstack("lbl")

print out

if not args.energy:
    e = out["rate_per_energy"]
    unit = "Rate per Energy ((Edges/Second)/Joule)"
else:
    e = out["energy_joules_avg"]
    unit = "Energy (Joule)"

p = e.plot(marker='o', rot=90)
p.set_xticks(range(len(e)))
p.set_xticklabels(e.index.get_level_values("input"))
p.set_yscale('log')
p.set_ylabel(unit)
p.set_title(args.title)
p.set_xlabel("Input")


plt.show()





