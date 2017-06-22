include ../common.mk

all: tuxedo-gtx1080-metrics.csv nopower-vs-power.csv tuxedo-gtx1080-pp.txt unopt-vs-opt.csv

%-metrics.csv: %.csv %-power.csv ../inputs-desc.csv
	../scripts/gcmetrics.py $^ -o $@

%-pp.txt: %.csv
	~/src/bmk2/ps/pp.py --fmt "{experiment} {bmk}/{variant}/{input} {time:0.2f} +- {ci95:0.2f} {unit}  s.d. {sd:0.2f} ms runs {runs}" $< > $@

nopower-vs-power.csv: tuxedo-gtx1080.csv tuxedo-gtx1080-power.csv
	$(BMK2)/ps/norm.py -k bmk -k input -m time_ns_avg --rs _power $^ -o $@

unopt-vs-opt.csv: tuxedo-gtx1080-unopt.csv tuxedo-gtx1080.csv
	$(BMK2)/ps/norm.py -k bmk -k input -m time_ns_avg --rs _opt $^ -o $@
