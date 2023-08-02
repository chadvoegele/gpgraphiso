#!/usr/bin/env python

import argparse


def read_input_file(ifile):
    o = open(ifile).readlines()
    
    for l in o:
        ls = l.strip().split(" ", 1)
        yield ls

def parse_vars(vv):
    out = {}
    for v in vv:
        n, val = v.split("=", 1)
        out[n] = val

    return out

def parse_template(tmpl):
    STATE = None
    out = {}

    for l in tmpl.split("\n"):
        if STATE == "#RULE":
            out['rule'] = l.split(":", 1)[0]
            STATE = None
        elif STATE is None:
            if l == "#RULE":
                STATE = "#RULE"

    return out

p = argparse.ArgumentParser(description="Generate makefile rules for experiments")
p.add_argument("inputs", help="File containing inputs")
p.add_argument("binspec", help="Binary specification")
p.add_argument("expt", help="Experiment")
p.add_argument("template", help="Template file for makefile rule")
p.add_argument("output", nargs="?", help="Output file")
p.add_argument("-v", dest="vars", help="Extra variable=value to pass to template", action="append")
p.add_argument("-t", dest="toplevel", help="Template for top-level rule")

args = p.parse_args()

v = {}
if args.vars:
    v = parse_vars(args.vars)

i = list(read_input_file(args.inputs))
t = open(args.template, "r").read()
tvars = parse_template(t)

out = []
for inp in i:
    o = {}
    if len(tvars) and 'rule' in tvars:
        o['rule'] = tvars['rule'].format(input=inp[0], inputfile=inp[1], binspec=args.binspec, expt=args.expt, **v)

    o['template'] = t.format(input=inp[0], inputfile=inp[1], binspec=args.binspec, expt=args.expt, **v)

    out.append(o)


if args.output:
    of = open(args.output, "w")
else:
    of = sys.stdout

if args.toplevel:
    tlrule = args.toplevel.format(binspec=args.binspec,expt=args.expt, **v)
    of.write(".PHONY: %s\n" % (tlrule,))

    tldepends = [o['rule'] for o in out if 'rule' in o]
    if len(tldepends) == 0:
        print >>sys.stderr, "WARNING: toplevel rule has no dependencies, did you add #RULE to the template?"

    of.write("%s: %s\n" % (tlrule, " ".join(tldepends)))
    of.write("\n")

for o in out:
    of.write(o['template'])
    
of.close()
