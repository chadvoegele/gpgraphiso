include ../common.mk

all: tuxedo-gtx1080-metrics.csv nopower-vs-power.csv

%-metrics.csv: %.csv ../inputs-desc.csv
	../scripts/gcmetrics.py $^ -o $@

nopower-vs-power.csv: tuxedo-gtx1080.csv tuxedo-gtx1080-power.csv
	$(BMK2)/ps/norm.py -k bmk -k input -m time_ns_avg --rs _power $^ -o $@
