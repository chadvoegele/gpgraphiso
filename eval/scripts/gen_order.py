#!/usr/bin/env python

# Quickie script to get log files in order of edges

import argparse
import pandas as pd

p = argparse.ArgumentParser(description="Sort log files in order of edges")
p.add_argument("inputs")
p.add_argument("inputdesccsv")
p.add_argument("-x", dest="exptdir", default="")

args = p.parse_args()

ic = pd.read_csv(args.inputs, header=None,names=['input', 'file'], delim_whitespace=True,index_col=['input'])
#print ic
idc = pd.read_csv(args.inputdesccsv, index_col=['input'])
#print idc

j = ic.join(idc, how='left', rsuffix='_r')
j = j.sort_values('edges')
for x in j.index.get_level_values('input'):
    print "%s%s.log" % (args.exptdir, x)



