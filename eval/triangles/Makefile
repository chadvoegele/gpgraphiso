include ../common.mk

all: tuxedo-gtx1080-gpu-metrics.csv tuxedo-gtx1080-gpu-na-metrics.csv  nopower-vs-power.csv tuxedo-gtx1080-pp.txt unopt-vs-opt.csv cpu-vs-minitri.csv gpu-vs-minitri.csv gpu-vs-cpu-01.csv gpu-vs-cpu-24.csv gpu-vs-cpu-12.csv tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-minitri-cpu-metrics.csv graphs

.phony: graphs

graphs: triangles-rps.pdf triangles-reu.pdf triangles-energy.pdf triangles-memusage.pdf

%-gpu-metrics.csv: %.csv %-power.csv ../inputs-desc.csv
	../scripts/gcmetrics.py $^ -o $@

%-gpu-na-metrics.csv: %.csv %-power.csv ../inputs-desc.csv
	../scripts/gcmetrics.py --na $^ -o $@

%-cpu-metrics.csv: %.csv ../inputs-desc.csv
	../scripts/cpumetrics.py $^ -o $@

%-pp.txt: %.csv
	~/src/bmk2/ps/pp.py --fmt "{experiment} {bmk}/{variant}/{input} {time:0.2f} +- {ci95:0.2f} {unit}  s.d. {sd:0.2f} ms runs {runs}" $< > $@

nopower-vs-power.csv: tuxedo-gtx1080.csv tuxedo-gtx1080-power.csv
	$(BMK2)/ps/norm.py -k bmk -k input -m time_ns_avg --rs _power $^ -o $@

unopt-vs-opt.csv: tuxedo-gtx1080-unopt.csv tuxedo-gtx1080.csv
	$(BMK2)/ps/norm.py -k bmk -k input -m time_ns_avg --rs _opt $^ -o $@

cpu-vs-minitri.csv: tuxedo-01.csv tuxedo-minitri.csv 
	$(BMK2)/ps/norm.py -k bmk -k input -m time_ns_avg -s _spdup --rs _cpu01 $^ -o $@

gpu-vs-minitri.csv:  tuxedo-gtx1080-gpu-metrics.csv tuxedo-minitri.csv
	$(BMK2)/ps/norm.py -k bmk -k input -m time_ns_avg --bm adj_time_ns_avg  -s _spdup --rs _gpu $^ -o $@

gpu-vs-cpu-01.csv: tuxedo-gtx1080-gpu-metrics.csv tuxedo-01.csv
	$(BMK2)/ps/norm.py -k bmk -k input --rs _gpu -s _spdup -m time_ns_avg --bm adj_time_ns_avg $^ -o $@

gpu-vs-cpu-12.csv: tuxedo-gtx1080-gpu-metrics.csv tuxedo-12.csv 
	$(BMK2)/ps/norm.py -k bmk -k input -m time_ns_avg --rs _gpu -s _spdup --bm adj_time_ns_avg $^ -o $@

gpu-vs-cpu-24.csv: tuxedo-gtx1080-gpu-metrics.csv tuxedo-24.csv 
	$(BMK2)/ps/norm.py -k bmk -k input -m time_ns_avg --rs _gpu -s _spdup --bm adj_time_ns_avg $^ -o $@


triangles-rps.pdf: tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-gtx1080-gpu-metrics.csv tuxedo-gtx1080-gpu-na-metrics.csv   tuxedo-minitri-cpu-metrics.csv dropInputs.txt
	../scripts/plot_rate_eps.py tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-gtx1080-gpu-metrics.csv tuxedo-gtx1080-gpu-na-metrics.csv tuxedo-minitri-cpu-metrics.csv -l cpu-01 -l cpu-12 -l cpu-24 -l gpu -l gpu-nomem -l minitri -o $@ --di dropInputs.txt

triangles-energy.pdf: tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-gtx1080-gpu-metrics.csv tuxedo-gtx1080-gpu-na-metrics.csv   tuxedo-minitri-cpu-metrics.csv dropInputs.txt
	../scripts/plot_energy.py -e tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-gtx1080-gpu-metrics.csv tuxedo-gtx1080-gpu-na-metrics.csv tuxedo-minitri-cpu-metrics.csv -l cpu-01 -l cpu-12 -l cpu-24 -l gpu -l gpu-nomem -l minitri -o $@ --di dropInputs.txt

triangles-reu.pdf: tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-gtx1080-gpu-metrics.csv tuxedo-gtx1080-gpu-na-metrics.csv  tuxedo-minitri-cpu-metrics.csv dropInputs.txt
	../scripts/plot_energy.py tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-gtx1080-gpu-metrics.csv tuxedo-gtx1080-gpu-na-metrics.csv tuxedo-minitri-cpu-metrics.csv -l cpu-01 -l cpu-12 -l cpu-24 -l gpu -l gpu-nomem -l minitri -o $@ --di dropInputs.txt

triangles-memusage.pdf: tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-gtx1080-gpu-metrics.csv tuxedo-gtx1080-gpu-na-metrics.csv dropInputs.txt
	../scripts/plot_memusage.py tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-gtx1080-gpu-metrics.csv tuxedo-gtx1080-gpu-na-metrics.csv -l cpu-01 -l cpu-12 -l cpu-24 -l gpu -l gpu-nomem -o $@ --di dropInputs.txt
