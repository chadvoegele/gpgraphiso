#!/usr/bin/env python

from __future__ import division
import argparse
import grf
import pandas as pd
import os

def read_inputs(inputs):
    out = {}
    for ii in inputs:
        with open(ii, "r") as f:
            for l in f:
                ls = l.strip().split(" ", 1)
                out[ls[0]] = ls[1]

    return out

def describe_input(inp, p, md = {}):
    out = {}

    out['input'] = inp
    out['file'] = p

    fb = os.path.basename(p)

    g = grf.GRGraphReader()
    hdr = g.read_hdr(out['file'])
    out['nodes'] = hdr.numNodes
    out['phy_edges'] = hdr.numEdges

    out['symmetric'] = ".sym." in out['file']

    if out['symmetric']:
        out['edges'] = out['phy_edges'] // 2
    else:
        out['edges'] = out['phy_edges']

    if fb in md:
        out['max_degree'] = md[fb]
    else:
        out['max_degree'] = None
        
    return out

def load_max_degree(md):
    x = read_inputs([md])
    out = {}
    for f, d in x.items():
        fb = os.path.basename(f)

        assert fb not in out, "Duplicate filename %s" % (fb,)
        
        out[fb] = d

    return out

p = argparse.ArgumentParser(description="Describe input graphs")
p.add_argument("inputs", nargs="+", help="Files containing inputs and paths")
p.add_argument("-m", dest="max_degree", help="File containing max degrees")

args = p.parse_args()

all_inputs = read_inputs(args.inputs)

md = {}
if args.max_degree:
    print "loading", args.max_degree
    md = load_max_degree(args.max_degree)

out = []
for i, p in all_inputs.items():
    out.append(describe_input(i, p, md))

df = pd.DataFrame(out)
df = df.set_index(['input'])
print df.to_csv()

