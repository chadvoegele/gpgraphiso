include ../common.mk

#tuxedo-gtx1080-gpu-metrics.csv tuxedo-gtx1080-gpu-na-metrics.csv tuxedo-gtx1080-pp.txt 
all: tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-ref-julia-cpu-metrics.csv

#%-gpu-metrics.csv: %.csv %-power.csv ../inputs-desc.csv
#	../scripts/gcmetrics.py $^ -o $@

#%-gpu-na-metrics.csv: %.csv %-power.csv ../inputs-desc.csv
#	../scripts/gcmetrics.py --na $^ -o $@

%-cpu-metrics.csv: %.csv ../inputs-desc.csv
	../scripts/cpumetrics.py $^ -o $@

