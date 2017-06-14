#!/usr/bin/env python

import sys
import os

def parse(f):
    # TODO: possibly pass in a standard set of imports?
    g = {}

    c = compile(open(f).read(), f, 'exec')
    exec c in g
    return g['ast']

Import = parse

if __name__ == "__main__":
    print(parse(sys.argv[1]))
