#!/bin/bash

P=`dirname $0`
BMK2=~/src/bmk2

$BMK2/inputdb.py --update $P/graphinp.py $P/graph.inputdb && $BMK2/inputprops.py $P/graph.inputdb $P/graph.inputprops

