#!/usr/bin/env python

# Extract valid edges, valid nodes and k-values from the .verify files
# produced from the verifyKtruss tool

import argparse
import re

K_RE = re.compile(r"^Verifying .* (?P<k>[0-9]+)-truss$")
N_RE = re.compile(r"^Truss is computed for (?P<name>.*.gr) and .*")
VN_RE = re.compile(r"^(?P<nodes>[0-9]+) valid nodes$")
VE_RE = re.compile(r"^(?P<edges>[0-9]+) valid edges$")

TEMPLATE = """# {name}
ktruss_{k}_nodes={nodes}
ktruss_{k}_edges={edges}
"""

def extract_ne(f):
    with open(f, "r") as of:
        out = {'k': None, 'nodes': None, 'edges': None, 'name': None}
        for l in of:
            m = K_RE.match(l) or VN_RE.match(l) or VE_RE.match(l) or N_RE.match(l)
            if m:
                #print l
                out.update(m.groupdict())

        if out['k'] is not None and out['nodes'] is not None and out['edges'] is not None and out['name'] is not None:
            return out
        else:
            #print l
            pass


    return None

p = argparse.ArgumentParser(description="Extract valid edges, valid nodes and k-values from .verify files to place in graph.inputprops")

p.add_argument("files", nargs="+", help="Output of the verifyTruss tool")

args = p.parse_args()

for f in args.files:
    x = extract_ne(f)
    if x: 
        print TEMPLATE.format(**x)
        if x['nodes'] == '0':
            print "ktruss_max=%s" % (int(x['k'] - 1))
