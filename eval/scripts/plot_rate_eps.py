#!/usr/bin/env python

import argparse
import pandas as pd
import matplotlib
import plot_common
#matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
plt.style.use('seaborn-paper')

p = argparse.ArgumentParser(description="Plot rate in eps")
p.add_argument("inputs", nargs="+")
p.add_argument("-l", dest="labels", action="append")
p.add_argument("-t", dest="title", default="")
p.add_argument("--di", dest="drop_inputs", help="Drop inputs in file")
p.add_argument("-o", dest='output')

args = p.parse_args()

out = pd.DataFrame()

for lbl, i in zip(args.labels, args.inputs):
    f = pd.read_csv(i)
    f["lbl"] = lbl
    out = out.append(f[["input", "lbl", "edges", "rate_eps"]])

out = out.set_index(["edges", "input", "lbl"])
out = out.unstack("lbl")

out = plot_common.drop_inputs(out, args.drop_inputs)
out = plot_common.rename_inputs(out)

eps = out["rate_eps"]

p = eps.plot(linestyle='dotted', rot=90, figsize=(8, 5), legend=None)
p.set_xticks(range(len(eps)))
p.set_xticklabels(eps.index.get_level_values("input"))
p.set_yscale('log')
p.set_ylabel("Rate (Edges/Second)")
p.set_title(args.title)
p.set_xlabel("Input")

plot_common.set_markers(p)
plot_common.set_legend(plt, p, eps)

if args.output:
    plt.savefig(args.output, bbox_inches='tight')
else:
    plt.show()
