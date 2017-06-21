#!/usr/bin/env python

from __future__ import division
import argparse
import grf
import pandas as pd

def read_inputs(inputs):
    out = {}
    for ii in inputs:
        with open(ii, "r") as f:
            for l in f:
                ls = l.strip().split(" ", 1)
                out[ls[0]] = ls[1]

    return out

def describe_input(inp, p):
    out = {}

    out['input'] = inp
    out['file'] = p

    g = grf.GRGraphReader()
    hdr = g.read_hdr(out['file'])
    out['nodes'] = hdr.numNodes
    out['phy_edges'] = hdr.numEdges

    out['symmetric'] = ".sym." in out['file']

    if out['symmetric']:
        out['edges'] = out['phy_edges'] // 2
    else:
        out['edges'] = out['phy_edges']
        
    return out

p = argparse.ArgumentParser(description="Describe input graphs")
p.add_argument("inputs", nargs="+", help="Files containing inputs and paths")

args = p.parse_args()

all_inputs = read_inputs(args.inputs)

out = []
for i, p in all_inputs.items():
    out.append(describe_input(i, p))

df = pd.DataFrame(out)
df = df.set_index(['input'])
print df.to_csv()

