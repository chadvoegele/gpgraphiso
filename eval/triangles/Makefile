include ../common.mk

all: tuxedo-gtx1080-metrics.csv

%-metrics.csv: %.csv ../inputs-desc.csv
	../scripts/gcmetrics.py $^ -o $@
