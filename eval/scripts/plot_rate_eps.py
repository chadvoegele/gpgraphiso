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
args = p.parse_args()

out = pd.DataFrame()

for lbl, i in zip(args.labels, args.inputs):
    f = pd.read_csv(i)
    f["lbl"] = lbl
    out = out.append(f[["input", "lbl", "edges", "rate_eps"]])

out = out.set_index(["edges", "input", "lbl"])
out = out.unstack("lbl")

print out

eps = out["rate_eps"]

print eps

p = eps.plot(marker='o', rot=90)
p.set_xticks(range(len(eps)))
p.set_xticklabels(eps.index.get_level_values("input"))
p.set_yscale('log')
p.set_ylabel("Rate (Edges/Second)")
p.set_title(args.title)
p.set_xlabel("Input")


plt.show()





